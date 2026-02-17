local M = {}
local global = require("core.global")

local function fix_toggleterm()
	local shell = vim.env.SHELL or ""
	if shell ~= "" then
		return
	end
	local maybe_shells = { "zsh", "bash" }
	for _, value in pairs(maybe_shells) do
		if vim.fn.executable(value) == 1 then
			vim.o.shell = value
			return
		end
	end
end

-- check termux system
-- @return 0 - no termux; 1 - termux; 2 - termux and use proot-distro
local function is_termux()
	local p = vim.env.PREFIX
	if type(p) == "string" and p:find("/data/data/com.termux/files/usr", 1, true) then
		return 1
	end
	-- proot-distro
	if vim.fn.executable("termux-info") == 1 then
		return 2
	end
	-- 有些环境还会有 TERMUX_VERSION
	if vim.env.TERMUX_VERSION ~= nil then
		return 1
	end
	return 0
end

function M.setup()
	local check_termux = is_termux()
	global.is_termux = check_termux == 1 or check_termux == 2
	global.is_termux_proot = check_termux == 2
	-- config clipboard if use termux and not proot-distro
	if not global.is_termux then
		return
	end
	if not global.is_termux_proot then
		vim.g.clipboard = {
			name = "termux-android-clipboard",
			copy = {
				["+"] = "termux-clipboard-set",
				["*"] = "termux-clipboard-set",
			},
			paste = {
				["+"] = "termux-clipboard-get",
				["*"] = "termux-clipboard-get",
			},
			cache_enabled = 0,
		}
	else -- use proot-distro debian
		fix_toggleterm()
	end
end

return M

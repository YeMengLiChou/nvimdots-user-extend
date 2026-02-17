local M = {}

M.setup = function()
	local utils = require("user.utils")
	local global = require("core.global")
	global.is_in_ssh = utils.is_in_ssh()

	if global.is_in_ssh then
		-- SSH 下关掉 unnamed/unnamedplus，避免 p 去读 OSC52 剪贴板
		-- 通过 schedule 等待 options 加载完成后再覆盖
		vim.schedule(function()
			vim.opt.clipboard = ""
		end)

		local group = vim.api.nvim_create_augroup("SSH_OSC52_YANK", { clear = true })
		vim.api.nvim_create_autocmd("TextYankPost", {
			group = group,
			callback = function()
				if vim.v.event.operator == "y" then
					local osc52 = require("vim.ui.clipboard.osc52")
					-- regcontents: table of lines
					osc52.copy("+")(vim.v.event.regcontents)
				end
			end,
			desc = "Copy yanks to local clipboard via OSC52 when in SSH",
		})
	end
end

return M

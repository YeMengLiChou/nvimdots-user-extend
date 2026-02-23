local definitions = {
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
}

-- 无后缀且首行为 #!xxxsh 时，认为这个文件是 sh 文件
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*",
	callback = function(event)
		local name = vim.fn.fnamemodify(event.file, ":t")
		-- 无后缀
		if name ~= "" and not name:find("%.") then
			local first_line = vim.fn.getline(1)
			if first_line:match("^#!.*sh") then
				vim.bo.filetype = "sh" -- 设置文件类型为 Bash
			end
		end
	end,
})

-- load user cmds
local user_cmd_path = require("core.global").vim_path .. "/lua/user/cmds"
local user_cmds = vim.split(vim.fn.glob(user_cmd_path .. "/*"), "\n", { trimempty = true })
for _, cmd in ipairs(user_cmds) do
	local name
	if vim.fn.isdirectory(cmd) then
		name = cmd:match("[^@/\\]*$") -- 取目录名称
	else
		name = cmd:match("[^@/\\]*.lua$")
		name = name:sub(0, #name - 4) -- 取 lua 名称
	end
	local ok, err = pcall(require, "user.cmds." .. name)
	if not ok then
		vim.notify("load cmds failed." .. cmd .. " " .. name .. " err: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end

return definitions

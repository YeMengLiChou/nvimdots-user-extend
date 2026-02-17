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

-- enable zsh treesitter
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		vim.notify("ts update")
	end,
})

return definitions

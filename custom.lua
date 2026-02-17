local M = {}

local function protect_vim_paste()
	local origin_paste = vim.paste
	vim.notify("protect_vim_paste")
	-- vim.notify()
	vim.paste = function(lines, phase)
		if not vim.bo.modifiable then
			return true -- 吞掉，避免 E21 + 刷屏卡死
		end
		return origin_paste(lines, phase)
	end
end

M.setup = function()
	protect_vim_paste()
end

return M

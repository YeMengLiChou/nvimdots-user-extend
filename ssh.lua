local M = {}

M.setup = function()
	local utils = require("user.utils")
	local use_ssh = utils.is_use_ssh()
	if use_ssh then
		-- SSH 下关掉 unnamed/unnamedplus，避免 p 去读 OSC52 剪贴板
		vim.opt.clipboard = ""

		local osc52 = require("vim.ui.clipboard.osc52")
		local group = vim.api.nvim_create_augroup("SSH_OSC52_YANK", { clear = true })
		vim.api.nvim_create_autocmd("TextYankPost", {
			group = group,
			callback = function()
				if vim.v.event.operator == "y" then
					-- regcontents: table of lines
					-- regtype: "v" / "V" / "\022" (blockwise)
					osc52.copy("+")(vim.v.event.regcontents)
				end
			end,
			desc = "Copy yanks to local clipboard via OSC52 when in SSH",
		})
	end
end

return M

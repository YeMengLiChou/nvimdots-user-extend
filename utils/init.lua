local M = {}

M.remove_all = function(t, x)
	for i = #t, 1, -1 do
		if t[i] == x then
			table.remove(t, i)
		end
	end
end

M.is_use_ssh = function()
	return vim.env.SSH_CONNECTION ~= nil
		or vim.env.SSH_CLIENT ~= nil
		or vim.env.SSH_TTY ~= nil
		or vim.env.MOSH_CONNECTION ~= nil
end

return M

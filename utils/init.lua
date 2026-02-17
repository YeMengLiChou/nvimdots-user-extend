local M = {}

M.remove_all = function(t, x)
	for i = #t, 1, -1 do
		if t[i] == x then
			table.remove(t, i)
		end
	end
end

M.is_in_ssh = function()
	return vim.env.SSH_CONNECTION ~= nil
		or vim.env.SSH_CLIENT ~= nil
		or vim.env.SSH_TTY ~= nil
		or vim.env.MOSH_CONNECTION ~= nil
end

-- 将 src 中的内容合并到 dst 中并去重；
-- 移除掉 excludes 中的元素
-- @param dst list
-- @param src list
-- @param excludes list
-- @return dst
M.merge = function(dst, src, excludes)
	vim.list_extend(dst, src)
	vim.fn.uniq(dst)
	if excludes ~= nil and vim.islist(excludes) then
		for _, value in ipairs(excludes) do
			M.remove_all(dst, value)
		end
	end
	return dst
end

return M

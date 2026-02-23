local M = {}

---输出内容`content`
---@param content string
---@param err boolean?
M.msg = function(content, err)
	local hl_group = "MoreMsg"
	if err == true then
		hl_group = "ErrorMsg"
	end
	vim.api.nvim_echo({ { content, hl_group } }, true, { err = err })
end

--- 补全参数，从 `items` 中过滤出匹配 `arglead` 前缀的候选列表
---@param items string[]
---@param arglead string
---@return string[]
M.filter_complete = function(items, arglead)
	local matched = {}
	for _, item in ipairs(items) do
		if arglead == "" or vim.startswith(item, arglead) then
			table.insert(matched, item)
		end
	end
	return matched
end

--- 确保指定 `name` 目录路径已经创建
---@param path any
---@return boolean
---@return string|nil
M.ensure_dir_created = function(path)
	if vim.fn.isdirectory(path) == 1 then
		return true
	end
	if vim.fn.mkdir(path, "p") == 1 or vim.fn.isdirectory(path) == 1 then
		return true
	end
	return false, ("failed to create directory: %s"):format(path)
end

---将 `value` 转换为 integer，转换失败时返回 `fallback`
---@param value string
---@param fallback integer|nil
---@return integer|nil
M.normalize_digits = function(value, fallback)
	local num = tonumber(value)
	if not num then
		return fallback
	end
	num = math.floor(num)
	return num
end

--- 确保 `path` 文件已经创建
---@param path string
---@return boolean
---@return string|nil
M.ensure_file_created = function(path)
	if vim.fn.filereadable(path) == 1 then
		return true
	end
	local ok, err = pcall(vim.fn.writefile, {}, path)
	if not ok then
		return false, ("failed to create file %s: %s"):format(path, err)
	end
	if vim.fn.filereadable(path) == 1 then
		return true
	end
	return false, ("failed to create file: %s"):format(path)
end


return M

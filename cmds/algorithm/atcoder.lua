local utils = require("user.cmds.algorithm.utils")

local atcoder_config = {
	root = "atcoder",
	solution_suffix = "go", -- 文件后缀,
	template_file = vim.fs.joinpath(vim.g.algorithm_env.root, "templates/io/acm.go"),
}

local options = { "-t", "--suffix" }

local function parse_atcoder_args(fargs)
	local parsed = {
		contest = utils.normalize_digits(fargs[1], -1),
		target_problems = "", -- 默认创建 A-E，可以指定创建的文件
		use_solution_suffix = atcoder_config.solution_suffix,
	}
	local i = 2
	while i <= #fargs do
		local flag = fargs[i]
		if flag == "-t" then
			local target = tostring(fargs[i + 1])
			if #target == 1 and target >= "A" and target <= "G" then
				parsed.target_problems = target
			else
				return nil, ("invalid params for options %s:%s"):format(flag, target)
			end
		elseif flag == "--suffix" then
			local suffix = fargs[i + 1]
			if not suffix then
				return nil, "missing suffix value."
			end
			parsed.use_solution_suffix = suffix
		else
			return nil, ("invalid options for %s."):format(flag)
		end
		i = i + 2
	end

	if parsed.contest <= 0 then
		return nil, "atcoder needs specify contest number with positive integer."
	end
	if #parsed.use_solution_suffix == 0 then
		return nil, "invalid suffix config, please set non-empty suffix."
	end

	return parsed, nil
end

---创建单个文件
---@param contest_dir string atcoder/ABCxxx/
---@param target string A-G
---@param suffix string 文件后缀
---@return boolean
---@return string|nil
---@return string|nil
local function create_single_contest_file(contest_dir, target, suffix)
	local target_dir = vim.fs.joinpath(contest_dir, target)
	local ok, err = utils.ensure_dir_created(target_dir)
	if not ok then
		return false, err, nil
	end
	local file = vim.fs.joinpath(target_dir, "solution." .. suffix)
	-- 已经创建并且有内容，则不修改
	if vim.fn.getfsize(file) > 0 then
		return ok, nil, file
	end
	-- 拷贝内容
	if vim.fn.filecopy(atcoder_config.template_file, file) == 0 then
		return false, ("copy file failed: %s"):format(file), nil
	end
	return ok, nil, file
end

local function create_contest_files(root, num, target, suffix)
	local contest_dir = vim.fs.joinpath(vim.g.algorithm_env.root, root, "ABC" .. num)
	local ok, err = utils.ensure_dir_created(contest_dir)
	local open_files = {}
	if not ok then
		return false, open_files, err
	end

	local file
	if #target == 1 then
		-- 仅创建单个文件
		ok, err, file = create_single_contest_file(contest_dir, target, suffix)
		table.insert(open_files, file)
	else
		-- 创建所有文件
		for i = string.byte("A"), string.byte("E") do
			ok, err, file = create_single_contest_file(contest_dir, string.char(i), suffix)
			if not ok then
				return ok, nil, err
			end
			table.insert(open_files, file)
		end
	end
	return true, open_files, nil
end

local function ensure_input_file_created()
	local input = vim.g.algorithm_env.input
	if vim.fn.filereadable(input) == 1 then
		return true, input
	end
	if not input or #input == 1 then
		return false, nil
	end
	local ok, _ = utils.ensure_file_created(input)
	if not ok then
		return false, nil
	end
	return true, input
end

return {
	help = "atcoder <num> [-t <target_problems>] [--suffix <extend>]",
	handle = function(fargs)
		local cfg, err = parse_atcoder_args(fargs)
		if not cfg then
			return false, err
		end
		local ok, files
		ok, files, err =
			create_contest_files(atcoder_config.root, cfg.contest, cfg.target_problems, cfg.use_solution_suffix)
		if not ok or not files or #files == 0 then
			return false, err or "failed to create files."
		end
		files = vim.fn.reverse(files)
		-- 先在上侧窗口打开一个文件
		vim.cmd.edit(vim.fn.fnameescape(files[1]))

		-- 再在下侧窗口打开 in 文件
		local input
		ok, input = ensure_input_file_created()
		if ok and input and #input > 0 then
			vim.cmd.split()
			vim.api.nvim_win_set_height(0, 10)
			vim.cmd.edit(vim.fn.fnameescape(input))
			vim.cmd.wincmd("k") -- 回到左侧窗口
		end

		-- 打开剩余的文件
		for idx = 2, #files do
			vim.cmd.edit(vim.fn.fnameescape(files[idx]))
		end
		return true
	end,
	command_complete = function(_, arglead)
		return utils.filter_complete(options, arglead)
	end,
}

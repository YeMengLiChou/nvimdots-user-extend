local utils = require("user.cmds.algorithm.utils")

local leetcode_config = {
	week_root = "leetcode/week", -- 周赛
	dweek_root = "leetcode/dweek", -- 双周赛
	problems_root = "leetcode/problems", -- 普通题目
	solution_suffix = "go", -- 文件后缀
	problem_digits = 4, -- 整体数字位数, L00xx
}

local options = { "-w", "-dw", "-p", "--suffix" }

local function parse_leetcode_args(fargs)
	local parsed = {
		weeks = -1,
		dweeks = -1,
		problems = -1,
		use_solution_suffix = leetcode_config.solution_suffix,
	}
	local i = 1

	while i <= #fargs do
		local flag = fargs[i]
		if not vim.list_contains(options, flag) then
			return nil, ("unknown option: %s"):format(flag)
		end

		if flag == "--suffix" then
			local suffix = fargs[i + 1]
			if not suffix then
				return nil, "missing suffix value."
			end
			parsed.use_solution_suffix = suffix
		elseif vim.list_contains(options, flag) then
			local num = utils.normalize_digits(fargs[i + 1], -1)
			if num == -1 then
				return nil, ("missing number or invalid number for %s: %s"):format(flag, num)
			end
			if flag == "-w" then
				parsed.weeks = num
			elseif flag == "-dw" then
				parsed.dweeks = num
			else
				parsed.problems = num
			end
		else
			return nil, ("invalid options for %s."):format(flag)
		end
		i = i + 2
	end
	return parsed
end

---创建对应目录
---@param root string
---@param num integer
---@param suffix string
---@return boolean 是否创建成功
---@return string|nil 打开文件的路径
---@return string|nil 错误信息
local function create_contest_dirs(root, num, suffix)
	local contest_dir = vim.fs.joinpath(vim.g.algorithm_env.root, root, num)
	local ok, err = utils.ensure_dir_created(contest_dir)
	local open_file = nil
	if not ok then
		return false, open_file, err
	end
	for idx = 1, 4 do
		local q_dir = vim.fs.joinpath(contest_dir, "Q" .. tostring(idx))
		ok, err = utils.ensure_dir_created(q_dir)
		if not ok then
			return false, open_file, err
		end
		local file = vim.fs.joinpath(q_dir, "solution." .. suffix)
		ok, err = utils.ensure_file_created(file)
		if not ok then
			return false, open_file, err
		end
		if idx == 1 then
			open_file = file
		end
	end
	return true, open_file, err
end

---创建普通问题的文件
---@param root string
---@param num integer
---@param digits integer
---@param suffix string
---@return boolean
---@return string|nil
---@return string|nil
local function create_problem_dir(root, num, digits, suffix)
	-- 创建 root/L00xx/L00xx.suffix
	local name = string.format("L%0" .. tostring(digits) .. "d", num)
	local problem_dir = vim.fs.joinpath(vim.g.algorithm_env.root, root, name)
	local ok, err = utils.ensure_dir_created(problem_dir)
	if not ok then
		return false, nil, err
	end
	local file = vim.fs.joinpath(problem_dir, ("%s.%s"):format(name, suffix))
	ok, err = utils.ensure_file_created(file)
	return ok, ok and file or nil, err
end

local M = {
	help = "leetcode -w/-dw/-p <num> [--suffix <extend>]",
	handle = function(fargs)
		local cfg, err = parse_leetcode_args(fargs)
		if not cfg then
			return false, err
		end
		if cfg.weeks <= 0 and cfg.dweeks <= 0 and cfg.problems <= 0 then
			return false, "leetcode needs one of -w/-dw/-p with positive integer"
		end
		if #cfg.use_solution_suffix == 0 then
			return false, "invalid suffix config, please set non-empty suffix"
		end

		local ok, file
		if cfg.weeks > 0 then
			ok, file, err = create_contest_dirs(leetcode_config.week_root, cfg.problems, cfg.use_solution_suffix)
		elseif cfg.dweeks > 0 then
			ok, file, err = create_contest_dirs(leetcode_config.dweeks_root, cfg.dweeks, cfg.use_solution_suffix)
		else
			ok, file, err = create_problem_dir(
				leetcode_config.problems_root,
				cfg.problems,
				leetcode_config.problem_digits,
				cfg.use_solution_suffix
			)
		end
		if not ok then
			return false, err
		end
		if not file then
			return false, "failed to create files."
		end
		vim.cmd.edit(vim.fn.fnameescape(file))
		return true
	end,
	command_complete = function(_, arglead)
		return utils.filter_complete(options, arglead)
	end,
}

return M

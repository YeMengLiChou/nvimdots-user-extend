local utils = require("user.cmds.algorithm.utils")

---@type table<string, SubCmdHandler>
local subcmd_handlers = {}

---@type string[]
local subcmds = {}

local function check_algorithm_dir()
	if vim.fn.executable("git") == 0 then
		utils.msg("command git is not available.", true)
		return false
	end
	local repo_url = vim.trim(vim.fn.system("git config --get remote.origin.url"))
	if not repo_url:match("YeMengLiChou/Algorithm%-Problems") then
		utils.msg("not valid repo url.", true)
		return false
	end
	return true
end

local function load_subcommands()
	local dir = vim.fs.dirname(debug.getinfo(1, "S").short_src)
	local ignored_files = {
		"init.lua",
		"utils.lua",
		"type.lua",
	}
	local subcommands = vim.fn.filter(
		vim.split(vim.fn.glob(dir .. "/*.lua"), "\n", { trimempty = true }),
		function(_, value)
			return not vim.list_contains(ignored_files, value:match("[^@/\\]*.lua$"))
		end
	)
	for _, value in ipairs(subcommands) do
		local name = value:match("[^@/\\]*.lua$")
		name = name:sub(0, #name - 4) -- 取 lua 名称
		local ok, res = pcall(require, "user.cmds.algorithm." .. name)
		if not ok then
			utils.msg("load " .. name .. " failed, caused by " .. vim.inspect(res))
		elseif type(res) == "table" then
			subcmd_handlers[name] = res
			table.insert(subcmds, name)
		end
	end
end

local function setup_env()
	local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
	local input = vim.fs.joinpath(root, "in")

	---@type AlgorithmEnv
	vim.g.algorithm_env = {
		root = root,
		input = input,
	}
	-- setup input env
	vim.env.input = vim.g.algorithm_env.input
end

local function algorithm_complete(arglead, cmdline, cursor_pos)
	-- 关注光标前面的内容
	local before = cmdline:sub(1, cursor_pos)
	-- 仅有参数
	local args = vim.api.nvim_parse_cmd(cmdline, {}).args

	-- 以空格结尾，说明正在输入下一个参数
	local ends_with_space = before:match("%s$") ~= nil
	local arg_index = #args + (ends_with_space and 1 or 0)

	-- <subcommand>
	if arg_index <= 1 then
		return utils.filter_complete(subcmds, arglead)
	end

	-- <args>
	local subcmd = args[1]
	local handler = subcmd_handlers[subcmd]
	if not handler then
		return {}
	end
	table.remove(args, 1)
	return handler.command_complete(args, arglead)
end

local function get_help_string()
	local help_string = "usage: Algorithm [subcommand]"
	for _, cmd in ipairs(subcmds) do
		help_string = help_string .. "\n\t" .. subcmd_handlers[cmd].help
	end
	return help_string
end

local function register_algorithm_command()
	vim.api.nvim_create_user_command("Algorithm", function(args)
		if not check_algorithm_dir() then
			return
		end
		if #args.fargs == 0 then
			utils.msg(get_help_string(), true)
			return
		end

		local subcmd = args.fargs[1]
		local handler = subcmd_handlers[subcmd]
		if not handler then
			utils.msg(("unknown subcommand: %s"):format(subcmd), true)
			return
		end

		local subcmd_args = {}
		for idx = 2, #args.fargs do
			table.insert(subcmd_args, args.fargs[idx])
		end

		local ok, err = handler.handle(subcmd_args)
		if not ok then
			utils.msg(("Algorithm %s failed: %s"):format(subcmd, err), true)
		else
			utils.msg(("Algorithm %s done."):format(subcmd))
		end
	end, {
		nargs = "+",
		complete = algorithm_complete,
	})
end

setup_env()
load_subcommands()
register_algorithm_command()

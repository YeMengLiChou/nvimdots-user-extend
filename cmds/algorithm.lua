local subcmds = {}

local function check_algorithm_dir()
	if vim.fn.executable("git") == 0 then
		vim.api.nvim_echo({ "command git is not available." }, true, { err = true })
		return false
	end
	local repo_url = vim.fn.execute("git config --get remote.origin.url")
	if repo_url == "" or not repo_url:match("git@github.com:YeMengLiChou/Algorithm-Problems.git") then
		vim.api.nvim_echo({ "not valid repo url." }, true, { err = true })
		return false
	end
	return true
end

-- subcmds.leetcode = function(args) end

-- local function algorithm_complete() end

vim.api.nvim_create_user_command("Algorithm", function(args)
	if not check_algorithm_dir() then
		return
	end
	vim.notify(vim.inspect(args))
end, {
	complete = algorithm_complete,
})

local tool = {}

-- repo: https://github.com/kawre/leetcode.nvim
tool["kawre/leetcode.nvim"] = {
	lazy = vim.fn.argv(0, -1) ~= "leetcode.nvim", -- 当使用 leetcode.nvim 参数时直接初始化
	cmd = { "Leet" },
	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {
		-- include a picker of your choice, see picker section for more details
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = require("user.configs.leetcode"),
}

return tool

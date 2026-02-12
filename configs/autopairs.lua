-- repo: https://github.com/windwp/nvim-autopairs
return function()
	-- config for nvim-autopairs
	require("nvim-autopairs").setup({
		fast_wrap = {
			map = "<M-e>", -- Alt+e
			chars = { "{", "[", "(", '"', "'", "<" },
			pattern = [=[[%'%"%>%]%)%}%,]]=],
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
		check_ts = true, -- 使用 treesitter 判断上下文
		enable_check_bracket_line = false,
	})
end

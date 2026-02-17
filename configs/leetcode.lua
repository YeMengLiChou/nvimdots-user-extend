return function()
	require("leetcode").setup({
		lang = "Go",
		cn = { -- use leetcode.cn
			enabled = true,
			translator = true,
			translate_problems = true,
		},
		plugins = {
			non_standalone = true,
		},
		image_support = true,
	})
end

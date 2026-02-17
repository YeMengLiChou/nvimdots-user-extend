return function(options)
	require("nvim-treesitter.parsers").get_parser_configs().zsh = {
		install_info = {
			url = "https://github.com/georgeharker/tree-sitter-zsh",
			files = { "src/parser.c", "src/scanner.c" },
			branch = "main",
			generate_from_json = true, -- only needed if repo does not contain `src/grammar.json` either
			queries = "nvim-queries", -- also install queries from given directory
		},
		tier = 3,
	}
	return options
end

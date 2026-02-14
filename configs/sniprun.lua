-- https://michaelb.github.io/sniprun/sources/README.html#usage
return {
	display = {
		-- "Terminal", -- "display results in a vertical split
		"Classic", -- "display results in the command-line area
		"VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
		"VirtualTextErr", -- "display error results as virtual text
		-- "TempFloatingWindow", -- "display results in a floating window
		--"LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText
	},
	display_options = {
		terminal_line_number = true,
		-- terminal_position = "horizontal",
	},
}

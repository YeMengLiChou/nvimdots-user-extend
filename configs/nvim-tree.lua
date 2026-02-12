-- overwrite some config for nvim-tree
return {
	filters = {
		git_ignored = false, -- show ignored files
	},
	disable_filetype = { "vim" },
}

-- overwrite some config for nvim-tree
return {
	disable_netrw = true,
	filters = {
		git_ignored = false, -- show ignored files
		custom = { ".git" },
	},
}

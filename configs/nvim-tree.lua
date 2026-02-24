local function ensure_value(t, k, v)
	if t[k] == nil then
		t[k] = v
	end
	return t[k]
end

-- overwrite some config for nvim-tree
return function(config)
	config.disable_netrw = true

	-- filters
	local filters = config.filters
	filters.dotfiles = false
	filters.git_ignored = false -- show ignored by .gitignore
	local custom = ensure_value(filters, "custom", {})
	table.insert(custom, "^\\.git$")

	-- renderer
	local renderer = config.renderer
	renderer.highlight_opened_files = "name"
	table.insert(renderer.special_files, ".gitignore")

	local show = ensure_value(renderer.icons, "show", {})
	show.hidden = true -- show hidden files

	return config
end

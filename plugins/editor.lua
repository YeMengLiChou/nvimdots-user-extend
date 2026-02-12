local editor = {}

editor["windwp/nvim-autopairs"] = {
	lazy = true,
	event = { "InsertEnter" },
	config = require("user.configs.autopairs"),
}

editor["nvim-mini/mini.surround"] = {
	lazy = true,
	event = { "InsertEnter" },
	config = require("user.configs.surround"),
}

return editor

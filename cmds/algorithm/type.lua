---@class SubCmdHandler
---@field handle fun(args?: string[]): (boolean, any)
---@field command_complete fun(args: string[], arglead: string): string[]
---@field help string
SubCmdHandler = {
	handle = function()
		return false, nil
	end,
	command_complete = function(_, _)
		return {}
	end,
	help = "",
}

---@class AlgorithmEnv
---@field root string 当前根目录
---@field input string 输入文件
AlgorithmEnv = {
	root = "",
	input = "",
}

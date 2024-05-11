-- @author      : denstiny (2254228017@qq.com)
-- @file        : init
-- @created     : Saturday May 11, 2024 17:22:45 CST
-- @github      : https://github.com/denstiny
-- @blog        : https://denstiny.github.io

local M = {}
local config = require("styledoc.config")
local event = require("styledoc.event")
local style = require("")

function M.setup(opts)
	config:merge_config(opts)
	config:init_color()
	event:init()
end

return M

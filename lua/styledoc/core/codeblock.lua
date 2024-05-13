local event = require("styledoc.event")
local M = {}
local query = require("styledoc.query.codeblock")
local utils = require("styledoc.utils")
local config = require("styledoc.config")
local ns_id = vim.api.nvim_create_namespace("code-block")

---@param bufnr
---@param captures
function M.draw(bufnr, captures)
	for capture_name, node in pairs(captures) do
		--vim.notify(string.format("name: %s type: %s", capture_name, node:type()))
		if capture_name == "code_lang" then -- [ 代码块语言类型 ]
		elseif capture_name == "code_block" then -- [ 代码块 ]
			local start, end_ = node:start(), node:end_()
			for i = start + 1, end_ - 2 do
				local _, text =
					pcall(utils.hi_line, bufnr, i, config.highlights.codeblock)
				if not _ then
					print(text)
				end
			end
		elseif capture_name == "code_end" then -- [ 代码块结束位置 ]
		end
	end
end

function M.init(bufnr)
	query.get_nodes(bufnr, 0, -1):for_each(M.draw)
end

function M.init_signal()
	event:bind_signal("StyleTreeChanged", function(arg)
		local buf, changes = unpack(arg.data)
	end)
end
return M

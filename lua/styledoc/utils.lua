local M = {}

--- 设置全局高亮组
---@param group string
---@param color string
function M.hi(group, color)
	vim.cmd(string.format("hi %s guifg=%s", group, color))
end

--- 映射全局高亮组
---@param group string
---@param link_group string
function M.hilink(group, link_group)
	vim.cmd(string.format("hi link %s %s", group, link_group))
end

--- neovim 创建事件回调
---@param group any
---@param event string
---@param opts string
function M.autocmd(group, event, opts)
	opts["group"] = group
	vim.api.nvim_create_autocmd(event, opts)
end

function M.buf_is_editable(bufnr)
	local bufoptions = vim.api.nvim_buf_get_option(bufnr, "readonly")
	return bufoptions
end

return M

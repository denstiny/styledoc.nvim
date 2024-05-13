local M = {}
local info = require("styledoc.info")
local api = vim.api
local fn = vim.fn

--- 设置全局高亮组
---@param group string
---@param fg string
---@param bg string
function M.hi(group, fg, bg)
	vim.cmd(string.format("hi %s guifg=%s guibg=%s", group, fg, bg))
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
---@param opts table
function M.autocmd(group, event, opts)
	opts["group"] = group
	vim.api.nvim_create_autocmd(event, opts)
end

function M.buf_is_editable(bufnr)
	local bufoptions = vim.api.nvim_buf_get_option(bufnr, "readonly")
	return bufoptions
end

function M.hi_line(bufnr, line, hl, ns_id)
	--M.del_hl(bufnr, line, line + 1)
	local marks = M.get_extmark(bufnr, ns_id, line, line + 1)
	local text = string.rep(" ", fn.winwidth(fn.bufwinnr(bufnr)))
	local opts = {
		virt_text = { { text, hl } },
		hl_eol = true,
		virt_text_pos = "overlay",
	}
	api.nvim_buf_add_highlight(bufnr, ns_id, hl, line, 0, -1)
	local _, text = pcall(
		api.nvim_buf_set_extmark,
		bufnr,
		ns_id,
		line,
		fn.len(fn.getline(line + 1)),
		opts
	)
	if not _ then
		print(text)
	else
		marks:for_each(function(id)
			vim.api.nvim_buf_del_extmark(bufnr, ns_id, id)
		end)
	end
end

function M.get_extmark(bufnr, ns_id, start, end_)
	local items = vim.api.nvim_buf_get_extmarks(
		bufnr,
		ns_id,
		{ start, 0 },
		{ end_, -1 },
		{}
	)
	local marks = M.list()
	for _, mark in ipairs(items) do
		local id = mark[1]
		marks:add(id)
		--vim.api.nvim_buf_del_extmark(bufnr, ns_id, id)
	end
	return marks
end

function M.list()
	local list = {
		_list = {},
		add = function(self, opt)
			table.insert(self._list, opt)
		end,
		for_each = function(self, callback)
			for key, value in pairs(self._list) do
				callback(value)
			end
		end,
	}
	return list
end

--- 清除指定位置的高亮
---@param bufnr
---@param start
---@param end_
function M.del_hl(bufnr, ns_id, start, end_)
	local items = vim.api.nvim_buf_get_extmarks(
		bufnr,
		ns_id,
		{ start, 0 },
		{ end_, -1 },
		{}
	)
	for _, mark in ipairs(items) do
		--vim.notify(vim.inspect(mark))
		local id = mark[1]
		vim.api.nvim_buf_del_extmark(bufnr, ns_id, id)
	end
end

function M.buf_form_window(bufnr)
	--vim.api.nvim_
end
return M

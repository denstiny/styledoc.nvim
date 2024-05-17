local M = {}
local ts_utils = vim.treesitter
local api = vim.api
local fn = vim.fn
local ns_id = vim.api.nvim_create_namespace("code-block")
local info = require("styledoc.info")

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

--- 高亮指定行
---@param bufnr integer
---@param line integer
---@param hl string|integer
function M.hi_line(bufnr, line, hl)
	local marks = M.get_extmark(bufnr, line, line + 1)
	local fn_len = fn.strdisplaywidth(M.get_buf_line(bufnr, line))
	local text = string.rep(" ", fn.winwidth(fn.bufwinnr(bufnr)) - fn_len)
	local opts = {
		virt_text = { { text, hl } },
		hl_eol = true,
		virt_text_pos = "overlay",
	}
	local extmark_id = api.nvim_buf_add_highlight(bufnr, ns_id, hl, line, 0, -1)
	local _, res =
		pcall(api.nvim_buf_set_extmark, bufnr, ns_id, line, fn_len, opts)
	if not _ then
		print(res)
		return nil, nil
	else
		marks:for_each(function(id)
			vim.api.nvim_buf_del_extmark(bufnr, ns_id, id)
		end)
		return extmark_id, res
	end
end

--- 获取指定namespace的所有标记
---@param bufnr
---@return
function M.get_extmark_all(bufnr)
	return M.get_extmark(bufnr, 0, -1)
end

--- 获取指定范围的extmark
---@param bufnr integer
---@param start integer
---@param end_ integer
---@return
function M.get_extmark(bufnr, start, end_)
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

--- 包装的一个list，涵盖foreach 回调
---@return
function M.list()
	local list = {
		_list = {},
		add = function(self, opt)
			table.insert(self._list, opt)
		end,
		add_for_key = function(self, key, opt)
			if not self._list[key] then
				self._list[key] = {}
			end
			table.insert(self._list[key], opt)
		end,
		for_each = function(self, callback)
			for key, value in pairs(self._list) do
				callback(value, key)
			end
		end,
		for_each_form_key = function(self, key, callback)
			for k, value in pairs(self._list[key]) do
				callback(k, value)
			end
		end,
	}
	return list
end

--- 清除指定位置的高亮
---@param bufnr
---@param start
---@param end_
function M.del_hl(bufnr, start, end_)
	local items = vim.api.nvim_buf_get_extmarks(
		bufnr,
		ns_id,
		{ start, 0 },
		{ end_, -1 },
		{}
	)
	for _, mark in ipairs(items) do
		local id = mark[1]
		vim.api.nvim_buf_del_extmark(bufnr, ns_id, id)
	end
end

function M.buf_form_window(bufnr)
	--vim.api.nvim_
end

--- 在指定行设置虚拟文本
---@param bufnr integer
---@param hl integer|string
---@param pos table
---@param text string
function M.set_extmark(bufnr, hl, pos, text)
	if text == "" or text == nil then
		return nil
	end
	local opts = {
		virt_text = { { text, hl } },
		virt_text_pos = "overlay",
	}
	local _, message =
		pcall(api.nvim_buf_set_extmark, bufnr, ns_id, pos.line, pos.col, opts)
	if not _ then
		M.error(message .. vim.inspect(pos))
		return nil
	else
		return message
	end
end

function M.error(text)
	vim.notify(text, vim.log.levels.ERROR, {
		title = "Styledoc",
	})
end

function M.is_line_covered_by_node(bufnr, target_line, node)
	-- 遍历整个树查找是否有节点覆盖这一行
	for n in node:iter_children() do
		if ts_utils.is_in_node_range(n, target_line, 0) then
			return true, n
		end
	end

	return false
end

--- 清理字符串开头和结尾的空格
---@param s
---@return
function M.trim(s)
	local text = s:gsub("^%s*(.-)%s*$", "%1")
	return text, vim.fn.len(text)
end

-- 查找第 {n} 行中 {char} 的位置,返回一个列表 {index}
---@param bufnr integer
---@param line integer
---@param char string
function M.find_char_index_form_bufline(bufnr, line, char)
	local _, find_str =
		pcall(vim.api.nvim_buf_get_lines, bufnr, line, line + 1, true)
	if not _ then
		return
	end
	find_str = find_str[1]
	local positions = {} -- 用来储存所有位置的表
	local start = 1
	while true do
		local found_at = string.find(find_str, char, start, true)
		if found_at then
			table.insert(positions, found_at)
			start = found_at + 1
		else
			break
		end
	end
	return positions
end

--- 替换
---@param bufnr integer
---@param start_row integer
---@param start_col integer
---@param end_row integer
---@param end_col integer
---@param replacement [string]
function M.replaceTextAndKeepCursor(
	bufnr,
	start_row,
	start_col,
	end_row,
	end_col,
	replacement
)
	--local cursor_pos = vim.api.nvim_win_get_cursor(0)
	--vim.api.nvim_win_set_cursor(0, cursor_pos)
	--vim.notify(
	--	string.format(
	--		"cursor: %s\nrepla: %s",
	--		vim.inspect(cursor_pos),
	--		vim.inspect({ start_col, end_col })
	--	)
	--)
	info:coment_change()
	pcall(
		vim.api.nvim_buf_set_text,
		bufnr,
		start_row,
		start_col,
		end_row,
		end_col,
		replacement
	)
end

function M.clear_all_extmark(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

function M.get_buf_line(bufnr, line)
	return table.concat(
		vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false),
		"n"
	)
end
return M

local M = {
	table = { heading = {}, cell = {}, row = {}, maxlen = 0, align = {} },
}
local ts = vim.treesitter
local t = require("styledoc.utils")
local qtable = require("styledoc.query.table")
local qinfo = require("styledoc.query.info")
local qutils = require("styledoc.query.utils")
local config = require("styledoc.config")

function M.draw(bufnr, captures)
	M.table = { heading = {}, cell = {}, row = {}, maxlen = 0, align = {} }
	for capture, node in pairs(captures) do
		local start, end_ = node:start(), node:end_()
		M.style_table(bufnr, start, end_ - 1)
	end
end

--- 渲染表格符号，在渲染之前线删除之前的表格符号
---@param bufnr
---@param start
---@param end_
function M.style_table(bufnr, start, end_)
	-- 渲染分隔线
	local user_conf = config:config()
	local symbols = user_conf.ui.table.symbol

	t.del_hl(bufnr, start, end_)
	for i = start, end_ do
		--- 由于treesitter无法支持符号的索引，所以索性自己去解析table的分隔符号的位置
		local separator_index = t.find_char_index_form_bufline(bufnr, i, "|")
		--t.del_hl(bufnr, i, i)
		for _, n_i in pairs(separator_index or {}) do
			local pos = { line = i, col = n_i - 1 }
			t.set_extmark(bufnr, "Normal", pos, symbols.line)
		end
	end
	-- 渲染对其符号
	align_line = start + 1
	function style_align(align_NE, symbol, anchor)
		for _, n_i in pairs(align_NE or {}) do
			local pos = { line = align_line, col = n_i + anchor }
			t.set_extmark(bufnr, "Normal", pos, symbol)
		end
	end
	--- 左对齐
	local align_left = t.find_char_index_form_bufline(bufnr, align_line, ":-")
	style_align(align_left, symbols.leftalign, -1)
	-- 右对齐
	local align_right = t.find_char_index_form_bufline(bufnr, align_line, "-:")
	style_align(align_right, symbols.rightalign, 0)
end

function M.format_change_table(bufnr)
	M.format_table(bufnr)
end

function M.init(bufnr)
	qutils.get_nodes_table(bufnr, 0, -1, qinfo.table):for_each(M.draw)
end

function M.format_table_all(buf)
	qutils
		.get_nodes_table(buf, 0, -1, qinfo.table)
		:for_each(function(bufnr, captures)
			M.table = { heading = {}, cell = {}, row = {}, maxlen = 0, align = {} }
			for capture, node in pairs(captures) do
				local start, end_ = node:start(), node:end_()
				qtable.table_header(bufnr, start, end_):for_each(M.table_header)
				qtable.table_cell(bufnr, start, end_):for_each(M.table_cell)
				qtable
					.table_delimiter_cell(bufnr, start, end_)
					:for_each(M.table_delimiter_cell)
			end
			M.format_table(bufnr)
		end)
end

function M.table_header(bufnr, captures)
	for capture, node in pairs(captures) do
		local text, len = t.trim(ts.get_node_text(node, bufnr))
		if len > M.table.maxlen then
			M.table.maxlen = len
		end
		table.insert(M.table.heading, { text = text, node = node })
	end
end

-- 遍历本次修改的 coluem
function M.table_cell(bufnr, captures)
	for capture, node in pairs(captures) do
		local text, len = t.trim(ts.get_node_text(node, bufnr))
		if len > M.table.maxlen then
			M.table.maxlen = len
		end
		table.insert(M.table.row, { text = text, node = node })
	end
end

-- 遍历本次修改的分隔符
function M.table_delimiter_cell(bufnr, captures)
	for capture, node in pairs(captures) do
		local text, len = t.trim(ts.get_node_text(node, bufnr))
		if len > M.table.maxlen then
			M.table.maxlen = len
		end
		M.get_table_align(node)
		table.insert(M.table.cell, { text = text, node = node })
	end
end

-- [ 格式化当前buffer的表格 ]
function M.format_table(bufnr)
	local maxlen = M.table.maxlen
	local heading_one_space_index = 0
	--[ 由于通过bufer_set_text无法避免删除渲染的符号，所以提前保存需要格式化的范围，冲洗渲染符号 ]
	local start_line = 0
	local end_line = 0

	-- [ heading ]
	for index, n in ipairs(M.table.heading) do
		local s_row = n.node:start()
		if index == 1 then
			start_line = s_row
		end
		local separator_index = t.find_char_index_form_bufline(bufnr, s_row, "|")
		assert(separator_index, "no find_char_index_form_bufline")
		local align = M.table.align[index]
		if index == 1 then
			heading_one_space_index = separator_index[index] - 1
		end
		t.replaceTextAndKeepCursor(
			bufnr,
			s_row,
			separator_index[index] - 1,
			s_row,
			separator_index[index + 1],
			{ M.format_table_row(n.text, align.left, align.right, maxlen) }
		)
	end

	-- [align row]
	for index, n in ipairs(M.table.cell) do
		local s_row = n.node:start()
		local separator_index = t.find_char_index_form_bufline(bufnr, s_row, "|")
		assert(separator_index)
		local align = M.table.align[index]
		local heading_space_index = 0
		local align_space = ""
		if index == 1 then
			heading_space_index = heading_one_space_index
			if heading_space_index > 1 then
				align_space = string.rep(" ", heading_space_index)
				heading_space_index = 0
			end
		else
			heading_space_index = separator_index[index] - 1
		end
		t.replaceTextAndKeepCursor(
			bufnr,
			s_row,
			heading_space_index,
			s_row,
			separator_index[index + 1],
			{
				align_space
					.. M.format_table_row(n.text, align.left, align.right, maxlen),
			}
		)
	end

	-- [row]
	for index, n in ipairs(M.table.row) do
		local s_row = n.node:start()
		if index == #M.table.row then
			end_line = s_row
		end
		local separator_index = t.find_char_index_form_bufline(bufnr, s_row, "|")
		assert(separator_index)
		i = index % #M.table.align
		if i == 0 then
			i = #M.table.align
		end
		local align = M.table.align[i]
		local heading_space_index = 0
		local align_space = ""
		if i == 1 then
			heading_space_index = heading_one_space_index
			if heading_space_index > 1 then
				align_space = string.rep(" ", heading_space_index)
				heading_space_index = 0
			end
		else
			heading_space_index = separator_index[i] - 1
		end
		t.replaceTextAndKeepCursor(
			bufnr,
			s_row,
			heading_space_index,
			s_row,
			separator_index[i + 1],
			{
				align_space
					.. M.format_table_row(n.text, align.left, align.right, maxlen),
			}
		)
	end

	-- restart style
	M.style_table(bufnr, start_line, end_line)
end

---@param str string
---@param left boolean
---@param right boolean
---@param maxlen integer
---@return string
function M.format_table_row(str, left, right, maxlen)
	local text
	local len = string.len(str)
	if left and right then
		-- 居中显示
		local left_len = math.floor((maxlen - len) / 2) + 1
		local right_len = math.ceil((maxlen - len) / 2) + 1
		text = string.rep(" ", left_len) .. str .. string.rep(" ", right_len)
	elseif right then
		-- 右对齐
		text = string.rep(" ", maxlen - len + 1) .. str .. " "
	else
		-- 左对齐
		text = " " .. str .. string.rep(" ", maxlen - len + 1)
	end
	return "|" .. text .. "|"
end

--- 获取表格对齐方式
---@param node
function M.get_table_align(node)
	local n = node
	if n:type() == "pipe_table_delimiter_cell" then
		local opts = { left = false, right = false }
		if n:child(0):type() == "pipe_table_align_left" then
			opts.left = true
		end
		if n:child(n:child_count() - 1):type() == "pipe_table_align_right" then
			opts.right = true
		end
		table.insert(M.table.align, opts)
	end
end

function M.component_format_event(bufnr) end

return M

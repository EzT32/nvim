-- lua/plugins/manim/scene.lua
local M = {}

-- Name of the class the cursor is in
function M.name()
	local node = vim.treesitter.get_node()
	while node and node:type() ~= "class_definition" do
		node = node:parent()
	end
	return node and vim.treesitter.get_node_text(node:field("name")[1], 0)
end

-- From the comment at/above the cursor to the next comment at the same indent
function M.block()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local start = vim.fn.line(".")
	while start > 1 and not lines[start]:match("^%s*#") do
		start = start - 1
	end
	local indent = lines[start]:match("^(%s*)#")
	if not indent then
		return { vim.api.nvim_get_current_line() }
	end

	local stop = start
	for l = start + 1, #lines do
		local ind = lines[l]:match("^(%s*)%S")
		if ind and (#ind < #indent or (#ind == #indent and lines[l]:match("^%s*#"))) then
			break
		end
		stop = l
	end
	return vim.list_slice(lines, start, stop)
end

return M

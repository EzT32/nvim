-- lua/plugins/manim/manim.lua
local M = {}
local term_buf

local function render(quality)
	local scene = require("plugins.manim.scene").name()
	if not scene then
		return vim.notify("manim: cursor is not inside a class", vim.log.levels.WARN)
	end
	vim.cmd.write()
	local file = vim.api.nvim_buf_get_name(0)

	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_buf_delete(term_buf, { force = true })
	end
	vim.cmd("botright 12new")
	term_buf = vim.api.nvim_get_current_buf()
	vim.fn.jobstart({ "manim", "-p", "-q" .. quality, file, scene }, { term = true })
	vim.cmd.wincmd("p")
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function(ev)
			local head = table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, 20, false), "\n")
			if not head:find("from manim import") then
				return
			end
			local function map(lhs, q, desc)
				vim.keymap.set("n", lhs, function() render(q) end, { buffer = ev.buf, desc = "Manim: " .. desc })
			end
			map("<leader>mr", "l", "render preview (480p)")
			map("<leader>mR", "h", "render final (1080p)")
		end,
	})
end

return M

local M = {}

local function keymaps(buf)
	local session, scene = require("manim.session"), require("manim.scene")
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Manim: " .. desc })
	end

	map("n", "<leader>ms", session.start, "start at cursor")
	map("n", "<leader>mp", function() session.run(scene.block()) end, "run block")
	map("x", "<leader>mp", function()
		local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = "V" })
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
		session.run(lines)
	end, "run selection")
	map("n", "<leader>mR", function() session.send("reload()") end, "reload file")
	map("n", "<leader>mq", function() session.send("exit()") end, "quit")
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function(ev)
			local head = table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, 20, false), "\n")
			if head:find("manimlib") then
				keymaps(ev.buf)
			end
		end,
	})
end

return M

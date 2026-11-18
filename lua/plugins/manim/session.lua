local M = {}
local chan

function M.start()
	local scene = require("manim.scene").name()
	if not scene then
		return vim.notify("manim: cursor is not inside a class", vim.log.levels.WARN)
	end
	vim.cmd.write()
	local file, line = vim.api.nvim_buf_get_name(0), vim.fn.line(".")

	vim.cmd("botright 12new")
	chan = vim.fn.jobstart({ "manimgl", file, scene, "-se", tostring(line) }, {
		term = true,
		on_exit = function()
			chan = nil
		end,
	})
	vim.cmd.wincmd("p")
end

function M.send(cmd)
	if not chan then
		return vim.notify("manim: not running", vim.log.levels.WARN)
	end
	vim.api.nvim_chan_send(chan, cmd .. "\r")
end

function M.run(lines)
	vim.fn.setreg("+", table.concat(lines, "\n"))
	M.send("checkpoint_paste()")
end

return M

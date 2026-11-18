-- lua/plugins/manim/manim.lua
local M = {}
local term_buf

local QUALITY = {
	["1080p30"] = { "--resolution", "1920,1080", "--frame_rate", "30" },
	["1440p60"] = { "--resolution", "2560,1440", "--frame_rate", "60" },
}

-- Run a command in a bottom terminal split, replacing (and stopping) the previous one
local function run_in_term(cmd, on_exit)
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_buf_delete(term_buf, { force = true })
	end
	vim.cmd("botright 12new")
	term_buf = vim.api.nvim_get_current_buf()
	vim.fn.jobstart(cmd, { term = true, on_exit = on_exit })
	vim.cmd.wincmd("p")
	vim.schedule(function()
		vim.cmd.stopinsert()
	end)
end

-- Save and return the file path and the scene under the cursor
local function current_scene()
	local scene = require("plugins.manim.scene").name()
	if not scene then
		vim.notify("manim: cursor is not inside a class", vim.log.levels.WARN)
		return nil
	end
	vim.cmd.write()
	return vim.api.nvim_buf_get_name(0), scene
end

-- Render to video, then show it in the same mpv window
local function render(quality)
	local file, scene = current_scene()
	if not file then
		return
	end
	local media = vim.fs.dirname(file) .. "/media"
	local video = ("%s/videos/%s/%s/%s.mp4"):format(media, vim.fn.fnamemodify(file, ":t:r"), quality, scene)

	local cmd = vim.list_extend({ "manim", "--media_dir", media }, QUALITY[quality])
	vim.list_extend(cmd, { file, scene })
	run_in_term(cmd, function(_, code)
		if code == 0 then
			require("plugins.manim.player").show(video)
		end
	end)
end

-- Live OpenGL window; pressing again restarts it
local function interactive()
	local file, scene = current_scene()
	if not file then
		return
	end
	run_in_term({ "manim", "-p", "--renderer=opengl", file, scene })
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function(ev)
			local head = table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, 20, false), "\n")
			if not head:find("from manim import") then
				return
			end
			local function map(lhs, fn, desc)
				vim.keymap.set("n", lhs, fn, { buffer = ev.buf, desc = "Manim: " .. desc })
			end
			map("<leader>m", function()
				render("1080p30")
			end, "render 1080p30")
			map("<leader>M", function()
				render("1440p60")
			end, "render 1440p60")
			map("<leader>i", interactive, "interactive window")
		end,
	})
end

return M

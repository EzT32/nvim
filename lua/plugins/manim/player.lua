-- lua/plugins/manim/player.lua
local M = {}
local socket = vim.fn.stdpath("run") .. "/manim-mpv.sock"
local job

local function send(cmd)
	local pipe = vim.uv.new_pipe(false)
	pipe:connect(socket, function(err)
		if err then
			return pipe:close()
		end
		pipe:write(vim.json.encode({ command = cmd }) .. "\n", function()
			pipe:close()
		end)
	end)
end

-- Open mpv the first time, then just reload the file in the same window
function M.show(file)
	if job then
		send({ "loadfile", file })
	else
		job = vim.fn.jobstart({ "mpv", "--input-ipc-server=" .. socket, file }, {
			on_exit = function() job = nil end,
		})
	end
end

return M

local os = require("os")
local home = os.getenv("HOME")

-- Check if a file or directory exists at a given path
-- Attribution: https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
local function dir_exists(target)
	local ok, err, code = os.rename(target, target)

	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end

	return ok, err
end

local M = {}

function M.start()
	local ollama_dir = home .. "/.ollama"
	local ok, _ = dir_exists(ollama_dir)
	if not ok then
		os.execute("mkdir " .. ollama_dir)
		print("Created .ollama directory at " .. ollama_dir)
	end
end

function M.run(model)
	return "ollama run " .. model
end

function M.list()
	return "ollama list"
end

return M

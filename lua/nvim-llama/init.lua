local window = require("nvim-llama.window")
local settings = require("nvim-llama.settings")
local ollama = require("nvim-llama.ollama")
local amazonq = require("nvim-llama.amazonq")
local M = {}

M.interactive_llama = function()
	local command = ollama.run(settings.current.model)

	window.create_chat_window()
	vim.fn.termopen(command)
end

M.interactive_q = function()
	local command = amazonq.run()

	window.create_chat_window()
	vim.fn.termopen(command)
end

M.interactive_q_history = function()
	local command = amazonq.run_with_history()

	window.create_chat_window()
	vim.fn.termopen(command)
end

M.interactive_q_git = function()
	local command = amazonq.run_with_git()

	window.create_chat_window()
	vim.fn.termopen(command)
end

local function set_commands()
	vim.api.nvim_create_user_command("Llama", function()
		M.interactive_llama()
	end, {})
	vim.api.nvim_create_user_command("LlamaQ", function()
		M.interactive_q()
	end, {})
	vim.api.nvim_create_user_command("LlamaQhist", function()
		M.interactive_q_history()
	end, {})
	vim.api.nvim_create_user_command("LlamaQgit", function()
		M.interactive_q_git()
	end, {})
end

local function is_ollama_installed()
	-- Use 'command -v' to check if ollama exists in PATH
	local handle = io.popen("command -v ollama")
	if not handle then
		return false, "Failed to execute command check"
	end

	local result = handle:read("*a")
	local success = handle:close()

	-- If command -v returns a path, ollama is installed
	if success and result and #result > 0 then
		return true
	else
		return false, "Ollama is not installed or not in PATH"
	end
end

local function is_ollama_running()
	local handle = io.popen("pgrep -x ollama")
	if not handle then
		return false, "Failed to check Ollama process"
	end

	local result = handle:read("*a")
	local success = handle:close()

	if success and result and #result > 0 then
		return true
	else
		return false, "Ollama service is not running"
	end
end

local function check_ollama()
	local installed, install_err = is_ollama_installed()
	if not installed then
		return false, install_err
	end

	local running, running_err = is_ollama_running()
	if not running then
		return false, running_err
	end

	return true
end

function M.setup(config)
	if config then
		settings.set(config)
	end

	local status, err = pcall(check_ollama)
	if not status then
		print("Error checking Ollama requirements: " .. err)
	end

	status = pcall(ollama.start)
	if not status then
		print("Error checking Ollama status: " .. err)
	end

	set_commands()
end

return M

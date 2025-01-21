local M = {}

function M.run()
	return "q chat"
end

function M.run_with_history()
	return "q chat @history"
end

function M.run_with_git()
	return "q chat @git"
end

return M

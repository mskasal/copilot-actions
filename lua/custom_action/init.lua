local M = {}

-- Function to add a comment on top of a code block and replace it
function M.add_custom_comment_action()
	local bufnr = vim.api.nvim_get_current_buf()

	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local start_row = start_pos[2] - 1
	local end_row = end_pos[2]

	local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)

	table.insert(lines, 1, "-- My custom comment")

	vim.api.nvim_buf_set_lines(bufnr, start_row, end_row, false, lines)
end

-- Function to create a custom code action
local function create_custom_action()
	return {
		title = "My Custom Action",
		action = function()
			M.add_custom_comment_action()
		end,
	}
end

-- Register the custom action with LSP code actions
function M.register_custom_action(client, bufnr)
	local function custom_code_action_handler(params)
		local actions = {}
		local mode = vim.api.nvim_get_mode().mode
		if mode == "v" or mode == "V" or mode == "\x16" then -- Check if in visual mode
			table.insert(actions, create_custom_action())
		end
		return actions
	end

	client.config.commands = client.config.commands or {}
	client.config.commands["CustomCodeAction"] = custom_code_action_handler

	vim.api.nvim_buf_create_user_command(bufnr, "CustomCodeAction", function()
		vim.lsp.buf.execute_command({ command = "CustomCodeAction" })
	end, { range = true, desc = "Run custom code action" })
end

-- Register a custom command
function M.setup()
	vim.api.nvim_create_user_command("AddCustomComment", M.add_custom_comment_action, { range = true })
end

return M

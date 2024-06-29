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
		kind = "quickfix",
		command = {
			title = "My Custom Action",
			command = "custom_action.add_custom_comment_action",
		},
	}
end

-- Register the custom action with LSP code actions
function M.register_custom_action(client, bufnr)
	-- Add a debug print or notification
	print("register_custom_action called for buffer: " .. bufnr)
	vim.notify("Custom action registered for buffer: " .. bufnr, vim.log.levels.INFO)

	local function custom_code_action_handler(params)
		local actions = {}
		local mode = vim.api.nvim_get_mode().mode
		if mode == "v" or mode == "V" or mode == "\x16" then -- Check if in visual mode
			table.insert(actions, create_custom_action())
		end
		return actions
	end

	-- Override the codeAction handler
	client.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers["textDocument/codeAction"], {
		code_action_callback = custom_code_action_handler,
	})

	-- Register the command with Neovim
	vim.api.nvim_buf_create_user_command(bufnr, "AddCustomComment", M.add_custom_comment_action, { range = true })
end

-- Register a global custom command
function M.setup()
	vim.api.nvim_create_user_command("AddCustomComment", M.add_custom_comment_action, { range = true })
end

return M

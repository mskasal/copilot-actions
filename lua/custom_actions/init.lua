local M = {}

-- Function to add a comment on top of a code block and replace it
function M.add_custom_comment_action()
	-- Get the current buffer
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get the selected range
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local start_row = start_pos[2] - 1
	local end_row = end_pos[2]

	-- Get the lines in the selected range
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)

	-- Add a custom comment
	table.insert(lines, 1, "-- My custom comment")

	-- Replace the selected lines with the modified lines
	vim.api.nvim_buf_set_lines(bufnr, start_row, end_row, false, lines)
end

-- Function to create a custom code action
local function create_custom_action()
	return {
		title = "My Custom Action",
		action = M.add_custom_comment_action,
	}
end

-- Register the custom action with LSP code actions
function M.register_custom_action(client, bufnr)
	local function custom_code_action_handler(_, _, params, client_id, _, _)
		local actions = {}
		local mode = vim.api.nvim_get_mode().mode
		if mode == "v" or mode == "V" or mode == "" then -- Check if in visual mode
			table.insert(actions, create_custom_action())
		end
		vim.lsp.util.apply_text_edits(actions, bufnr, client.offset_encoding)
		return actions
	end

	client.handlers["textDocument/codeAction"] = vim.lsp.with(custom_code_action_handler, {})
end

return M

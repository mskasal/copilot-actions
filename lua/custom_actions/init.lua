-- lua/custom_action/init.lua
local M = {}

-- Function to add a comment on top of a code block and replace it
function M.add_custom_comment_action()
	-- Get the current buffer and cursor position
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local row = cursor_pos[1] - 1

	-- Get the text of the current line
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[0]

	-- Add a custom comment
	local comment = "-- My custom comment"

	-- Replace the line with the comment and the original line
	vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { comment, line })
end

-- Register the custom action with LSP code actions
function M.register_custom_action(client)
	client.resolved_capabilities.code_action = true
	vim.lsp.handlers["textDocument/codeAction"] = function(_, _, actions, _, _, _)
		table.insert(actions, {
			title = "My Custom Action",
			action = M.add_custom_comment_action,
		})
		vim.lsp.util.apply_text_edits(actions, bufnr)
	end
end

return M

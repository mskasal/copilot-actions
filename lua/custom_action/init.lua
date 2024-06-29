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

-- Setup function to configure keybindings
function M.setup()
	-- Define a keymap for <leader>gct to execute custom action
	vim.api.nvim_set_keymap(
		"n",
		"<leader>gct",
		':lua require("custom_action").add_custom_comment_action()<CR>',
		{ noremap = true, silent = true }
	)

	-- Optionally, define placeholders for <leader>gce and <leader>gcr
	vim.api.nvim_set_keymap("n", "<leader>gce", "<Plug>(my_custom_placeholder_for_gce)", {})
	vim.api.nvim_set_keymap("n", "<leader>gcr", "<Plug>(my_custom_placeholder_for_gcr)", {})
end

return M

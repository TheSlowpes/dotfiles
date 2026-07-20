-- Org directory from environment variable or default
local org_dir = vim.fn.expand(vim.env.NVIM_ORG_DIR or "~/org")

-- Add plugins with vim.pack (Neovim 0.12+)
vim.pack.add({
	{ src = "https://github.com/nvim-orgmode/orgmode" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-orgmode/org-bullets.nvim" },
	{ src = "https://github.com/chipsenkbeil/org-roam.nvim" },
})

-- Lazy-load all org-related setup only for org buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	once = true,
	callback = function()
		-- Core Orgmode
		require("orgmode").setup({
			org_agenda_files = org_dir .. "/**/*",
			org_default_notes_file = org_dir .. "/inbox.org",

			-- Disable orgmode's default keymaps so your own/global mappings don't conflict
			-- (We keep explicit org-local mappings below.)
			org_default_keys = false,

			-- TODO keywords
			org_todo_keywords = { "TODO", "IN-PROGRESS", "WAITING", "|", "DONE", "CANCELLED" },
			org_todo_keyword_faces = {
				["TODO"] = ":foreground #ff6b6b :weight bold",
				["IN-PROGRESS"] = ":foreground #feca57 :weight bold",
				["WAITING"] = ":foreground #ff9f43 :weight bold",
				["DONE"] = ":foreground #1dd1a1 :weight bold",
				["CANCELLED"] = ":foreground #576574 :weight bold",
			},

			-- Capture templates
			org_capture_templates = {
				t = {
					description = "Task",
					template = "* TODO %?\n  %u",
					target = org_dir .. "/inbox.org",
				},
				n = {
					description = "Note",
					template = "* %?\n  %u",
					target = org_dir .. "/inbox.org",
				},
				j = {
					description = "Journal",
					template = "* %<%Y-%m-%d %H:%M> %?\n",
					target = org_dir .. "/journal/%<%Y-%m-%d>.org",
				},
				m = {
					description = "Meeting",
					template = "* MEETING %?\n  SCHEDULED: %T\n  - Attendees: \n  - Agenda:\n  - Notes:\n  - Action Items:",
					target = org_dir .. "/inbox.org",
				},
				c = {
					description = "Code Snippet",
					template = "* %?\n  %u\n  #+BEGIN_SRC\n\n  #+END_SRC",
					target = org_dir .. "/notes/code.org",
				},
				i = {
					description = "Idea",
					template = "* IDEA %?\n  %u\n  - Context:\n  - Why interesting:",
					target = org_dir .. "/inbox.org",
				},
			},

			-- Archive location
			org_archive_location = org_dir .. "/archive.org::* From %s",

			-- Agenda settings
			org_agenda_span = "week",
			org_agenda_start_on_weekday = 1, -- Monday
			org_deadline_warning_days = 7,

			-- Enable org indent mode
			org_indent_mode = "indent",
			org_startup_indented = true,

			-- Org-file-local mappings only (no global defaults)
			mappings = {
				org = {
					org_toggle_checkbox = "<C-Space>",
					org_cycle = "<TAB>",
					org_global_cycle = "<S-TAB>",
					org_todo = "<S-CR>",
					org_open_at_point = "<CR>",
					org_insert_heading_respect_content = "<C-CR>",
				},
			},
		})

		-- Org Bullets for pretty rendering
		require("org-bullets").setup({
			concealcursor = true,
			symbols = {
				checkboxes = {
					half = { "", "@org.checkbox.halfchecked" },
					done = { "✓", "@org.keyword.done" },
					todo = { " ", "@org.keyword.todo" },
				},
				headlines = { "◉", "○", "◆", "◇", "●" },
			},
		})

		-- Org Roam for Zettelkasten-style notes
		require("org-roam").setup({
			directory = org_dir .. "/roam",
			extensions = {
				dailies = {
					directory = org_dir .. "/journal",
				},
			},
		})
	end,
})

-- Global keymaps (outside org file mappings)
local map = vim.keymap.set
local del = vim.keymap.del

-- Remove/overwrite potential conflicting global keymaps first
local global_conflicts = {
	"<leader>Oa",
	"<leader>Oc",
	"<leader>Ot",
	"<leader>Oi",
	"<leader>Os",
	"<leader>Od",
	"<leader>Or",
	"<leader>OA",
	"<leader>O/",
	"<leader>Of",
	"<leader>On",
	"<leader>Ol",
	"<leader>Ob",
	"<leader>Og",
}
for _, lhs in ipairs(global_conflicts) do
	pcall(del, "n", lhs)
end

-- Re-define your intended global org keymaps
map("n", "<leader>Oa", "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", { desc = "Org Agenda" })
map("n", "<leader>Oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", { desc = "Org Capture" })

map("n", "<leader>Ot", function()
	vim.cmd("edit " .. org_dir .. "/todo.org")
end, { desc = "Open todo.org" })

map("n", "<leader>Oi", function()
	vim.cmd("edit " .. org_dir .. "/inbox.org")
end, { desc = "Open inbox.org" })

map(
	"n",
	"<leader>Os",
	"<cmd>lua require('orgmode').action('org_mappings.org_schedule')<CR>",
	{ desc = "Schedule item" }
)
map("n", "<leader>Od", "<cmd>lua require('orgmode').action('org_mappings.org_deadline')<CR>", { desc = "Set deadline" })
map(
	"n",
	"<leader>Or",
	"<cmd>lua require('orgmode').action('capture.refile_headline_to_destination')<CR>",
	{ desc = "Refile item" }
)
map(
	"n",
	"<leader>OA",
	"<cmd>lua require('orgmode').action('org_mappings.org_archive_subtree')<CR>",
	{ desc = "Archive subtree" }
)

map("n", "<leader>O/", function()
	require("telescope.builtin").live_grep({
		search_dirs = { org_dir },
		prompt_title = "Search Org Files",
	})
end, { desc = "Search org files" })

map("n", "<leader>Of", function()
	require("telescope.builtin").find_files({
		search_dirs = { org_dir },
		prompt_title = "Find Org Files",
	})
end, { desc = "Find org files" })

map("n", "<leader>On", function()
	require("org-roam").api.find_node()
end, { desc = "Org-roam: Find/create node" })

map("n", "<leader>Ol", function()
	require("org-roam").api.insert_node()
end, { desc = "Org-roam: Insert link" })

map("n", "<leader>Ob", function()
	require("org-roam").api.toggle_roam_buffer()
end, { desc = "Org-roam: Toggle backlinks" })

map("n", "<leader>Og", function()
	require("org-roam").api.open_id_at_point()
end, { desc = "Org-roam: Go to node" })

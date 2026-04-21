return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			-- UI-Rendering deaktivieren (render-markdown.nvim übernimmt das)
			ui = { enable = false },
			workspaces = {
				{
					name = "zettelkasten",
					path = "~/Projects/zettelkasten",
				},
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			-- Optional: Daily notes configuration
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
			},
			-- Optional: Templates
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
		},
		keys = {
			{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
			{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open Obsidian Note" },
			{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian" },
			{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's Note" },
		},
	},
}


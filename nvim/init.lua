-- Baseline settings
vim.opt.tabstop = 2        -- Number of spaces a <Tab> counts for
vim.opt.softtabstop = 2    -- Number of spaces for editing (Backspace, etc.)
vim.opt.shiftwidth = 2     -- Number of spaces for auto-indent
vim.opt.expandtab = true   -- Convert tabs to spaces

vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers (optional but popular)

vim.opt.ignorecase = true -- for /
vim.opt.smartcase = true -- unless uppercase given


vim.g.mapleader = ","
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.g.syntax_on = false

-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup({
  { 
    "Shatur/neovim-ayu", 
    config = function()
      require('ayu').setup({
        overrides = {
            Normal = { bg = "None" },
            NormalFloat = { bg = "none" },
            ColorColumn = { bg = "None" },
            SignColumn = { bg = "None" },
            Folded = { bg = "None" },
            FoldColumn = { bg = "None" },
            CursorLine = { bg = "None" },
            CursorColumn = { bg = "None" },
            VertSplit = { bg = "None" },

            Comment           = { bg = "None" },
            ["@comment"]      = { bg = "None" },
            ["@lsp.type.comment"] = { bg = "None" },

            LineNr        = { fg = "#7f8490", bg = "NONE" },  -- dimmer/darker gray
            CursorLineNr  = { fg = "#e5c07b", bg = "NONE", bold = true }, -- highlight current line number
        },
      })
    end
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all", -- or specify languages like {"lua", "python"}
        highlight = { enable = true },
        indent = { enable = true },
          refactor = {
            highlight_definitions = { enable = false },
            highlight_current_scope = { enable = false },
          },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig", -- keep for default server configs & docs
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()

      local servers = { "lua_ls", "pyright", "ts_ls", "bashls", "gopls" }

      -- Install these via Mason (name mapping handled automatically)
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      -- Put per-server overrides in vim.lsp.config(...)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- Enable each server (attaches when a matching filetype opens)
      for _, name in ipairs(servers) do
        vim.lsp.enable(name)
      end
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional icons
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
          relativenumber = true,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        update_focused_file = {
          enable = true,
          update_root = true, -- optional, updates the root folder too
        }
      })
    end,
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
      { "<leader>m", "<cmd>NvimTreeFocus<CR>", desc = "Focus File Tree" },
      { "<leader>F", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal Current File in Tree" }
    }
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local neotest = require("neotest")
      local python_adapter = require("neotest-python")({
        dap = { justMyCode = false },
      })

      -- Custom adapter that uses "devc shell pytest"
      -- local unpack = table.unpack or unpack
      local custom_adapter = {
        name = "neotest-python-devc",
        is_test_file = python_adapter.is_test_file,
        discover_positions = python_adapter.discover_positions,
        results = python_adapter.results,
        root = python_adapter.root,

        build_spec = function(args)
          local spec = python_adapter.build_spec(args)
          spec.command = "devc"
          spec.args = { "shell", "pytest", table.unpack(args.extra_args or {}), spec.context.file }
          return spec
        end,
      }

      neotest.setup({
        adapters = { custom_adapter }
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run test file" })

      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true })
      end, { desc = "Open test output" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        end,
      })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" }
    }
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup({
        callbacks = {
          ["github.com"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
        mappings = nil, -- we'll define our own keymaps
      })

      -- Keymap: Open current file + line on GitHub
      vim.keymap.set("n", "<leader>go", function()
        require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
      end, { desc = "Open file on GitHub" })

      -- Keymap: Copy link to clipboard instead
      vim.keymap.set("n", "<leader>gy", function()
        require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").copy_to_clipboard })
      end, { desc = "Copy GitHub link to clipboard" })
    end,
  },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      -- require"octo".setup()
      require"octo".setup({
        use_local_fs = false,                    -- use local files on right side of reviews
        enable_builtin = true,                   -- shows a list of builtin actions when no action is provided
        default_remote = {"upstream", "origin"}, -- order to try remotes
        ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`. The key part will be interpreted as an anchored Lua pattern.
        picker = "telescope",                    -- or "fzf-lua" or "snacks"
        picker_config = {
          use_emojis = false,                    -- only used by "fzf-lua" picker for now
          mappings = {                           -- mappings for the pickers
            open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            copy_sha = { lhs = "<C-e>", desc = "copy commit SHA to system clipboard" },
            checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
            merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
          },
        },
        comment_icon = "▎",                      -- comment marker
        outdated_icon = "󰅒 ",                    -- outdated indicator
        resolved_icon = " ",                    -- resolved indicator
        reaction_viewer_hint_icon = " ",        -- marker for user reactions
        commands = {},                           -- additional subcommands made available to `Octo` command
        users = "search",                        -- Users for assignees or reviewers. Values: "search" | "mentionable" | "assignable"
        user_icon = " ",                        -- user icon
        ghost_icon = "󰊠 ",                       -- ghost icon
        timeline_marker = " ",                  -- timeline marker
        timeline_indent = 2,                   -- timeline indentation
        use_timeline_icons = true,               -- toggle timeline icons
        timeline_icons = {                       -- the default icons based on timelineItems
          commit = "  ",
          label = "  ",
          reference = " ",
          connected = "  ",
          subissue = "  ",
          cross_reference = "  ",
          parent_issue = "  ",
          pinned = "  ",
          milestone = "  ",
          renamed = "  ",
          merged = { "  ", "OctoPurple" },
          closed = {
            closed = { "  ", "OctoRed" },
            completed = { "  ", "OctoPurple" },
            not_planned = { "  ", "OctoGrey" },
            duplicate = { "  ", "OctoGrey" },
          },
          reopened = { "  ", "OctoGreen" },
          assigned = "  ",
          review_requested = "  ",
        },
        right_bubble_delimiter = "",            -- bubble delimiter
        left_bubble_delimiter = "",             -- bubble delimiter
        github_hostname = "",                    -- GitHub Enterprise host
        snippet_context_lines = 4,               -- number or lines around commented lines
        gh_cmd = "gh",                           -- Command to use when calling Github CLI
        gh_env = {},                             -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
        timeout = 5000,                          -- timeout for requests between the remote server
        default_to_projects_v2 = false,          -- use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
        ui = {
          use_signcolumn = false,                -- show "modified" marks on the sign column
          use_signstatus = true,                 -- show "modified" marks on the status column
        },
        issues = {
          order_by = {                           -- criteria to sort results of `Octo issue list`
            field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
            direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
          }
        },
        reviews = {
          auto_show_threads = true,              -- automatically show comment threads on cursor move
          focus             = "right",           -- focus right buffer on diff open
        },
        runs = {
          icons = {
            pending = "🕖",
            in_progress = "🔄",
            failed = "❌",
            succeeded = "",
            skipped = "⏩",
            cancelled = "✖",
          },
        },
        pull_requests = {
          order_by = {                            -- criteria to sort the results of `Octo pr list`
            field = "CREATED_AT",                 -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
            direction = "DESC"                    -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
          },
          always_select_remote_on_create = false, -- always give prompt to select base remote repo when creating PRs
          use_branch_name_as_title = false        -- sets branch name to be the name for the PR
        },
        notifications = {
          current_repo_only = false,             -- show notifications for current repo only
        },
        file_panel = {
          size = 10,                             -- changed files panel rows
          use_icons = true                       -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
        },
        colors = {                               -- used for highlight groups (see Colors section below)
          white = "#ffffff",
          grey = "#2A354C",
          black = "#000000",
          red = "#fdb8c0",
          dark_red = "#da3633",
          green = "#acf2bd",
          dark_green = "#238636",
          yellow = "#d3c846",
          dark_yellow = "#735c0f",
          blue = "#58A6FF",
          dark_blue = "#0366d6",
          purple = "#6f42c1",
        },
        mappings_disable_default = false,        -- disable default mappings if true, but will still adapt user mappings
        mappings = {
          pull_request = {
            checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
            merge_pr = { lhs = "<localleader>pm", desc = "merge commit PR" },
            squash_and_merge_pr = { lhs = "<localleader>psm", desc = "squash and merge PR" },
            rebase_and_merge_pr = { lhs = "<localleader>prm", desc = "rebase and merge PR" },
            merge_pr_queue = { lhs = "<localleader>pq", desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo)" },
            squash_and_merge_queue = { lhs = "<localleader>psq", desc = "squash and add to merge queue (Merge queue must be enabled in the repo)" },
            rebase_and_merge_queue = { lhs = "<localleader>prq", desc = "rebase and add to merge queue (Merge queue must be enabled in the repo)" },
            list_commits = { lhs = "<localleader>pc", desc = "list PR commits" },
            list_changed_files = { lhs = "<localleader>pf", desc = "list PR changed files" },
            show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
            add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
            remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer request" },
            close_issue = { lhs = "<localleader>ic", desc = "close PR" },
            reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
            list_issues = { lhs = "<localleader>il", desc = "list open issues on same repo" },
            reload = { lhs = "<C-r>", desc = "reload PR" },
            open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            goto_file = { lhs = "gf", desc = "go to file" },
            add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
            create_label = { lhs = "<localleader>lc", desc = "create label" },
            add_label = { lhs = "<localleader>la", desc = "add label" },
            remove_label = { lhs = "<localleader>ld", desc = "remove label" },
            goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            add_reply = { lhs = "<localleader>cr", desc = "add reply" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
            review_start = { lhs = "<localleader>vs", desc = "start a review for the current PR" },
            review_resume = { lhs = "<localleader>vr", desc = "resume a pending review for the current PR" },
            resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
            unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
          },
          review_thread = {
            goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            add_reply = { lhs = "<localleader>cr", desc = "add reply" },
            add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            select_next_entry = { lhs = "]q", desc = "move to next changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
            resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
            unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
          },
          submit_win = {
            approve_review = { lhs = "<C-A>", desc = "approve review", mode = { "n", "i" } },
            comment_review = { lhs = "<C-m>", desc = "comment review", mode = { "n", "i" } },
            request_changes = { lhs = "<C-r>", desc = "request changes review", mode = { "n", "i" } },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab", mode = { "n", "i" } },
          },
          review_diff = {
            submit_review = { lhs = "<localleader>vs", desc = "submit review" },
            discard_review = { lhs = "<localleader>vd", desc = "discard review" },
            add_review_comment = { lhs = "<localleader>ca", desc = "add a new review comment", mode = { "n", "x" } },
            add_review_suggestion = { lhs = "<localleader>sa", desc = "add a new review suggestion", mode = { "n", "x" } },
            focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
            next_thread = { lhs = "]t", desc = "move to next thread" },
            prev_thread = { lhs = "[t", desc = "move to previous thread" },
            select_next_entry = { lhs = "]q", desc = "move to next changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
            goto_file = { lhs = "gf", desc = "go to file" },
          },
          file_panel = {
            submit_review = { lhs = "<localleader>vs", desc = "submit review" },
            discard_review = { lhs = "<localleader>vd", desc = "discard review" },
            next_entry = { lhs = "j", desc = "move to next changed file" },
            prev_entry = { lhs = "k", desc = "move to previous changed file" },
            select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
            refresh_files = { lhs = "R", desc = "refresh changed files panel" },
            focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
            select_next_entry = { lhs = "]q", desc = "move to next changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
          },
          notification = {
            read = { lhs = "<localleader>nr", desc = "mark notification as read" },
            done = { lhs = "<localleader>nd", desc = "mark notification as done" },
            unsubscribe = { lhs = "<localleader>nu", desc = "unsubscribe from notifications" },
          },
        },
      })
    end
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
  "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()

      -- Auto-enter insert mode for ChatGPT input
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match("ChatGPT") or vim.bo.filetype == "chatgpt-input" then
            vim.cmd("startinsert")
          end
        end,
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim", -- optional
      "nvim-telescope/telescope.nvim"
    }
  },
  { 'nvim-mini/mini.nvim', version = false },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
    opts = {
      markdown_inline = {
        checkboxes = {
          unchecked = { text = "○" },
        },
      },
    },
  },
})

-- Telescope keymaps
vim.keymap.set("n", "<C-t>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find Files (Telescope)" })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "Find Buffers" })

-- Quick split shortcuts: vv = vertical split, ss = horizontal split
vim.keymap.set("n", "vv", "<C-w>v", { silent = true })
vim.keymap.set("n", "ss", "<C-w>s", { silent = true })

-- Use system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- LSP-powered Telescope pickers
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find References" })
vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>fi", builtin.lsp_implementations, { desc = "Find Implementations" })
vim.keymap.set("n", "<leader>ft", builtin.lsp_type_definitions, { desc = "Go to Type Definition" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })
vim.keymap.set("n", "<C-]>", builtin.lsp_definitions,
  { noremap = true, silent = true, desc = "Go to LSP definitions (Telescope)" }) -- Override <C-]> globally

-- clear search highlight
vim.keymap.set("n", "//", ":nohlsearch<CR>", {
  noremap = true,
  silent = true,
  desc = "Clear search highlight",
})

-- CSV alginment
-- vim.keymap.set("n", "<leader>ac", ":ArrangeColumn<CR>", { desc = "Align CSV columns" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
end, { desc = "Show diagnostic under cursor" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Octo commands
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr<CR>", { desc = "Open PR for current branch" })
vim.keymap.set("n", "<leader>ol", "<cmd>Octo pr list<CR>", { desc = "List PRs" })

vim.filetype.add({
  extension = {
    ddsql = "sql",
  },
})


-- vim.api.nvim_set_hl(0, "TSDefinition",       { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "TSDefinitionUsage",  { bg = "NONE" })
--
-- -- ~/.config/nvim/lua/colors_overrides.lua
-- local function apply_overrides()
--   local groups = {
--     "Normal", "NormalFloat", "ColorColumn", "SignColumn",
--     "Folded", "FoldColumn", "CursorLine", "CursorColumn", "VertSplit",
--     "Comment", "@comment", "@lsp.type.comment",
--   }
--
--   for _, g in ipairs(groups) do
--     vim.api.nvim_set_hl(0, g, { bg = "NONE", ctermbg = "NONE" })
--   end
-- end
--
-- -- Apply immediately and every time a colorscheme is set
-- apply_overrides()
-- vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_overrides })

-- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
--   local val = result.value
--   if not val.kind then return end
--
--   local msg = ""
--   if val.kind == "begin" then
--     msg = val.title .. " started"
--   elseif val.kind == "report" then
--     msg = val.message or val.title
--   elseif val.kind == "end" then
--     msg = val.title .. " finished"
--   end
--
--   vim.notify("LSP: " .. msg, vim.log.levels.INFO, { title = ctx.client_id })
-- end

require("markview.extras.checkboxes").setup({
    --- Default checkbox state(used when adding checkboxes).
    ---@type string
    default = "X",

    --- Changes how checkboxes are removed.
    ---@type
    ---| "disable" Disables the checkbox.
    ---| "checkbox" Removes the checkbox.
    ---| "list_item" Removes the list item markers too.
    remove_style = "disable",

    --- Various checkbox states.
    ---
    --- States are in sets to quickly change between them
    --- when there are a lot of states.
    ---@type string[][]
    states = {
        { " ", "/", "X" },
        { "<", ">" },
        { "?", "!", "*" },
        { '"' },
        { "l", "b", "i" },
        { "S", "I" },
        { "p", "c" },
        { "f", "k", "w" },
        { "u", "d" }
    }
})

vim.cmd[[colorscheme ayu]]

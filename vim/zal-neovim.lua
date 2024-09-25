
-- ensure nvim version
local nvim_version = vim.version()
if vim.version.lt(nvim_version, { 0, 9, 5 }) then
    vim.notify("This configuration requires Neovim version 0.9.5 or higher", vim.log.levels.ERROR)
    return
end

-- vim options
vim.opt.termguicolors = true
vim.opt.mouse = '' -- No mouse, thank you. Teaches me bad habits

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==== Plugin config ====

local neotree = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    enabled = false,
}

local nvim_tree = {
    'nvim-tree/nvim-tree.lua',
    keys = {
        { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    },
    enabled = false,
}

local lualine = {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        sections = {
            lualine_a = { 'mode' }
        },
        theme = 'tokyonight',
    },
}

local bufferline = {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            show_close_icon = false,
            show_buffer_close_icons = false,
            numbers = 'ordinal',
            color_icons = true,
            separator_style = 'slant',
            always_show_bufferline = true,
            diagnostics = 'nvim_lsp',
            --themeable = true,
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'NvimTree',
                    highlight = 'Directory',
                    separator = true,
                }
            },
        },
        highlights = {
        },
    },
}

local telescope = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup({})
        local telescope_builtin = require('telescope.builtin')
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<leader>ff',  telescope_builtin.find_files, opts)
        vim.keymap.set('n', '<leader>fg',  telescope_builtin.live_grep, opts)
        vim.keymap.set('n', '<leader>fs',  telescope_builtin.lsp_workspace_symbols, opts)
    end
}

local telescope_file_browser = {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim"
    },
    keys = {
        { "<leader>fb", ":Telescope file_browser<CR>" },
    }
}

local cmp = {
    'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources(
                { { name = 'nvim_lsp' } },
                { { name = 'buffer' } }
            ),
        })
    end,
}

local startup = {
    "startup-nvim/startup.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim"
    },
    opts = {
        theme = "dashboard",
    },
}

local neogit = {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader>gi", "<cmd>Neogit<cr>", desc = "Neogit" }
    },
    opts = {
        graph_style = "unicode",
        kind = "tab",
    },
}

local noice = {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
}

local illuminate = {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
}

local indentmini = {
    "nvimdev/indentmini.nvim",
    event = "VeryLazy",
    opts = {
        minlevel = 1,
        char = "│",
    },
}

local vimtex = {
    "lervag/vimtex",
    ft = "tex",
    config = function()
        -- vimtex gets very bitchy if this is not set.
        vim.g.tex_flavor = "latex"
    end,
}

local tokyonight = {
    "folke/tokyonight.nvim",
    opts = {
        style = 'night',
        -- transparent = true,
    },
}

local ledger = {
    "ledger/vim-ledger",
    ft = "ledger",
}

require("lazy").setup({
    "gentoo/gentoo-syntax",
    "neovim/nvim-lspconfig",
    neotree,
    nvim_tree,
    lualine,
    bufferline,
    telescope,
    telescope_file_browser,
    cmp,
    startup,
    neogit,
    noice,
    illuminate,
    indentmini,
    vimtex,
    ledger,
    tokyonight,
})


-- set default colorscheme

vim.cmd[[colorscheme tokyonight]]


-- ==== Line endings etc. ====

-- autmatically strip trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})


-- ==== LSP config =====

-- Use an on_attach function to only map the following keys after the language server attaches to
-- the current buffer
local on_attach = function(client, bufnr)

    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    local telescope_builtin = require('telescope.builtin')
    vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, bufopts)
    vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, bufopts)
    vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, bufopts)

    vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 300,
}

local lspconfig = require('lspconfig')

-- rust-analyzer
--
-- rustup provides no proxy for rust-analyzer, we need to query it's path manually.
function get_rust_analyzer_path()
    local handle = io.popen('rustup which rust-analyzer')
    local output = handle:read('*a')
    local exit = handle:close()
    local ra_path
    if exit then
        ra_path = vim.trim(output)
    else
        ra_path = "rust-analyzer"
    end
    return ra_path
end

lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { get_rust_analyzer_path() },
    settings = {
        ["rust-analyzer"] = {
        }
    }
}

lspconfig.clangd.setup {
    filetypes = { "c", "cpp", "cxx", "cc" },
    on_attach = on_attach,
}

-- remap omnifunc to something sane
-- (not using omnifunc rn, using nvim-cmp instead)
--vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')
--vim.keymap.set('i', '<C-@>', '<C-Space>')


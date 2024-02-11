
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
}

local nvim_tree = {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    },
}

local lualine = {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons'
}

local bufferline = {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
}

local telescope = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
}

local cmp = {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
    }
}

require("lazy").setup({
    "gentoo/gentoo-syntax",
    "tpope/vim-fugitive",
    "lervag/vimtex",
    "ledger/vim-ledger",
    "nvim-tree/nvim-web-devicons",
    "neovim/nvim-lspconfig",
    -- neotree,
    nvim_tree,
    lualine,
    bufferline,
    telescope,
    "folke/tokyonight.nvim",
    cmp,
})

-- colorscheme

require('tokyonight').setup({
    style = 'night',
    --transparent = true,
})
vim.cmd[[colorscheme tokyonight]]

-- require('neo-tree').setup()
require('nvim-tree').setup()

-- vimtex. gets very bitchy if this is not set.
vim.g.tex_flavor = "latex"

-- lualine
local lualine = require('lualine')

local lualine_diagnostics = {
    'diagnostics',
    sources = { 'nvim_lsp' },
    sections = { 'error', 'warn', 'info', 'hint' },
    diagnostics_color = {
        -- Same values as the general color option can be used here.
        error = 'DiagnosticError', -- Changes diagnostics' error color.
        warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
        info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
        hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
    },
    symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
    colored = true,           -- Displays diagnostics status in color if set to true.
    update_in_insert = false, -- Update diagnostics in insert mode.
    always_visible = false,   -- Show diagnostics even if there are none.
}

local lualine_config = {
    sections = {
        lualine_a = { 'mode' }
    },
    theme = 'tokyonight',
}

lualine.setup(lualine_config)

-- bufferline
vim.opt.termguicolors = true
local bufferline = require('bufferline')

local bufferline_options = {
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
}

local bufferline_highlights = {
}

bufferline.setup{ options = bufferline_options, highlights = bufferline_highlights }

-- Telescope

require('telescope').setup{
}
local telescope_builtin = require('telescope.builtin')
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ff',  telescope_builtin.find_files, opts)
vim.keymap.set('n', '<leader>fg',  telescope_builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fs',  telescope_builtin.lsp_workspace_symbols, opts)

-- ==== Line endings etc. ====

-- autmatically strip trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- ==== Nvim options ====

-- No mouse, thank you. Teaches me bad habits
vim.opt.mouse = ''


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
        ra_path= vim.trim(output)
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

-- nvim-cmp (autocompletion engine)
local cmp = require('cmp')
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
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, { { name = 'buffer' } } ),
})

-- remap omnifunc to something sane
-- (not using omnifunc rn, using nvim-cmp instead)
--vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')
--vim.keymap.set('i', '<C-@>', '<C-Space>')


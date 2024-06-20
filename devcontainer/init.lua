-- Install packer
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et ai nosta
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- LSP Plugins
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'mhartington/formatter.nvim',
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
      "folke/trouble.nvim"
    },
  }

  -- Utility Plugins
  use { "elentok/format-on-save.nvim" }
  use {
    "sontungexpt/url-open",
    cmd = "URLOpenUnderCursor",
    config = function()
        local status_ok, url_open = pcall(require, "url-open")
        if not status_ok then
            return
        end
        url_open.setup ({})
    end,
  }

  -- Autocompletion Plugins
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap',
      'rafamadriz/friendly-snippets',
      'ray-x/lsp_signature.nvim',
      'saadparwaiz1/cmp_luasnip',
    },
  }

  use { "L3MON4D3/LuaSnip", run = "make install_jsregexp" }

  -- AI Plugins
  use({
    "jackMort/ChatGPT.nvim",
      config = function()
        require("chatgpt").setup()
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      }
  })

  use({
    "dpayne/CodeGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codegpt.config")
    end
  })

  use({
    "robitx/gp.nvim",
      config = function()
          require("gp").setup({
            hooks = {
              -- example of adding command which writes unit tests for the selected code
              UnitTests = function(gp, params)
                  local template = "I have the following code from {{filename}}:\n\n"
                      .. "```{{filetype}}\n{{selection}}\n```\n\n"
                      .. "Please respond by writing table driven unit tests for the code above."
                  local agent = gp.get_command_agent()
                  gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
              end,
            }
          })
      end,
  })

  -- Go Tests
  use {
    'yanskun/gotests.nvim',
    ft = 'go',
    config = function()
      require('gotests').setup()
    end
  }

  use { -- Test Runner
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "olimorris/neotest-rspec",
      "jfpedroza/neotest-elixir",
      "thenbe/neotest-playwright",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
          require("neotest-jest"),
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            }
          }),
          require("neotest-python")({
            runner = "pytest",
            pytest_discover_instances = true,
          }),
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "RAILS_ENV=test",
                "bundle",
                "exec",
                "rspec",
              })
            end
          }),
        }
      })
    end
  }

  use({ -- Test Coverage
    "andythigpen/nvim-coverage",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup()
    end,
  })

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Procfile treesitter support
  use "technicalpickles/procfile.vim"
  use "norcalli/nvim-colorizer.lua"

  -- Lua
  use {
    "zbirenbaum/neodim",
    event = "LspAttach",
    branch = "v2",
    config = function()
      require("neodim").setup({
        refresh_delay = 75, -- time in ms to wait after typing before refresh diagnostics
        alpha = .75,
        blend_color = "#000000",
        hide = { underline = true, virtual_text = true, signs = true },
        disable = {}, -- table of filetypes to disable neodim
      })
    end,
  }

  -- Typescript
  -- use {
  --   "pmizio/typescript-tools.nvim",
  --   requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("typescript-tools").setup {}
  --   end,
  -- }

  -- Copilot
  --use {
  --  "zbirenbaum/copilot.lua",
  --  cmd = "Copilot",
  --  event = "InsertEnter",
  --  config = function()
  --    require("copilot").setup({
  --      suggestion = { enabled = false },
  --      panel = { enabled = false },
  --    })
  --  end,
  --}

  -- Copilot CMP
  --use {
  --  "zbirenbaum/copilot-cmp",
  --  after = { "copilot.lua" },
  --  config = function ()
  --    require("copilot_cmp").setup()
  --  end
  --}

  -- Go plugins
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua'

  -- Python
  use 'tjdevries/apyrori.nvim'

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use "nvim-lua/plenary.nvim"
  use 'lewis6991/gitsigns.nvim'
  use 'kessejones/git-blame-line.nvim'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {} } -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim'               -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth'                    -- Detect tabstop and shiftwidth automatically
  use { 'nvim-tree/nvim-web-devicons' }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  use { -- Fancier statusline
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Vim Plugins
  use 'echasnovski/mini.move'
  use 'rrethy/vim-illuminate'

  -- Terminal Plugins
  use 'akinsho/toggleterm.nvim'

  use 'Mofiqul/dracula.nvim'

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

vim.g.netrw_nogx = 1

vim.o.list = true
vim.o.path = '**/**'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set Colorscheme
vim.o.termguicolors = true
vim.cmd [[
  syntax enable
  colorscheme dracula
]]

vim.g.python3_host_prog = vim.fn.expand "~/.asdf/shims/python3"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Open URL 
vim.keymap.set({'n', 'v' }, 'gx', '<esc>:URLOpenUnderCursor<cr>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {
      'mode'
    },
    lualine_b = {
      'branch',
      'diff',
      'diagnostics'
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
  }
}

-- Enable Comment.nvim
require('Comment').setup()

require('ibl').setup {
  indent = {
    char = '┊',
    smart_indent_cap = true,
    highlight = {
      "Conditional",
      "Function",
      "Label",
    },
  },
  whitespace = {
    highlight = {
      "Whitespace",
      "NonText"
    }
  },
  scope = {
    enabled = true,
    char = "|",
    highlight = {
      "Conditional",
      "Function",
      "Label"
    },
    show_start = true,
    show_end = false,
  },
}

require('format-on-save').setup({
  experiments = {
    partial_update = 'diff', -- or 'line-by-line'
  }
})

require('apyrori.config').new(
  'name_of_configuration',
  {
    command='grep',

    args = function(text)
        return {'the', 'commands', 'to', 'send', 'to', 'command'}
    end,

    -- results: the results of running the commands. Split on new lines
    -- counts: the counts of the various different import styles. Most common will be used.
    parser  = function(results, counts)
      for _, result in ipairs(results) do
        local split_result = require('apyrori.util').string_split(result, ":", 4)
        local value = split_result[4]

        if counts[value] == nil then
          counts[value] = 0
        end

        counts[value] = counts[value] + 1
      end
    end
  },
  true
)

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('git-blame-line').setup({
  git = {
    default_message = 'Not committed yet',
    blame_format = '%an - %ar - %s'     -- see https://git-scm.com/docs/pretty-formats
  },
  view = {
    left_padding_size = 5,
    enable_cursor_hold = false
  }
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
    theme = 'dracula',
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

require("nvim-dap-virtual-text").setup()

-- Nvim Tree Config
-- See :h nvim-tree
require('nvim-tree').setup({
  disable_netrw = true
})

local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>t', api.tree.toggle, { desc = 'Nvim [T]ree Toggle' })

local function open_nvim_tree(data)
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  vim.cmd.enew()
  vim.cmd.bw(data.buf)
  vim.cmd.cd(data.file)
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Toggle Term Config
require("toggleterm").setup({
  open_mapping = [[<C-t>]],
})

require('go').setup()
require('trouble').setup()

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'elixir',
    'dockerfile',
    'go',
    'lua',
    'javascript',
    'python',
    'rust',
    'ruby',
    'sql',
    'tsx',
    'typescript',
    'help',
    'vim',
    'yaml',
  },
  ignore_install = { 'gdscript' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = {'typescript', 'tsx'},
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = "rounded",
      peek_definition_code = {
        ['<leader>pd'] = '@function.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  sync_install = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

local function diag_signs(signs)
  for _, sign in ipairs(signs) do
    local sign_name = ("DiagnosticSign" .. sign)
    vim.fn.sign_define(sign_name, { numhl = sign_name, text = "\226\151\143", texthl = sign_name })
  end
  return nil
end

diag_signs({ "Error", "Warn", "Hint", "Info" })
vim.diagnostic.config({ float = { border = "rounded", source = "always", style = "minimal" }, severity_sort = true, virtual_text = false })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
  local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(ns, bufnr)
  return true
end

-- Turn on lsp status information
require('fidget').setup()

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


-- Setup neovim lua configuration
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  gopls = {},
  -- erlangls = {},
  pyright = {},
  tsserver = {},
  terraformls = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require'lspconfig'.terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()
require('formatter').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
    --    require "lsp_signature".setup({
    --      bind = true, -- This is mandatory, otherwise border config won't get registered.
    --      handler_opts = {
    --        border = "rounded"
    --      }
    --     })
  end,
}
-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert {
    --["<Tab>"] = vim.schedule_wrap(function(fallback)
    --  if cmp.visible() and has_words_before() then
    --    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --  else
    --    fallback()
    --  end
    --end),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-C'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Shift-Shift>'] = cmp.mapping.close(),
    ['<PageDown>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<PageUp>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    --{ name = "copilot", group_index = 2 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
}

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
  sources = { { name = "buffer" } }
})

cmp.setup.cmdline({ ":" }, {
  mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
  sources = { { name = "cmdline" }, { name = "path" } }
})

require('refactoring').setup()
require('mini.move').setup()
require('nvim-web-devicons').get_icons()
require('nvim-web-devicons').setup(
  { color_icons = true, }
)

--[[This file defines global Vim autocmds (i.e., not related to any particular
plugin - hence the g in this file's name)]]

local m = vim.keymap.set

-----------------------------
-- NVIM-TREE
-----------------------------
-- Open nvim-tree on directory or no-name buffer
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function(args)
    local is_dir = vim.fn.isdirectory(args.file) == 1
    local is_no_name = args.file == '' and vim.bo[args.buf].buftype == ''
    if is_dir then
      vim.cmd.cd(args.file)
      require('nvim-tree.api').tree.open()
      return
    end
    if is_no_name then
      require('nvim-tree.api').tree.toggle { focus = false, find_file = true }
    end
  end,
})

-----------------------------
-- LSP
-----------------------------
vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  callback = function(args)
    local _ = vim.lsp.get_client_by_id(args.data.client_id)

    -- TODO: only add mappings after checking server capabilities

    -- (g)o (i)mplementations
    m('n', 'gi', vim.lsp.buf.implementation, {
      noremap = true,
      desc = '(g)o (i)mplementations of symbol under cursor using LSP',
    })

    -- (g)o (d)efinition
    m('n', 'gd', vim.lsp.buf.definition, {
      noremap = true,
      desc = '(g)o (d)efinition of symbol under cursor using LSP',
    })

    -- (g)o (D)eclaration
    m('n', 'gD', vim.lsp.buf.declaration, {
      noremap = true,
      desc = '(g)o (D)eclaration of symbol under cursor using LSP',
    })

    -- (g)o (r)eferences
    m('n', 'gr', vim.lsp.buf.references, {
      noremap = true,
      desc = '(g)o (r)references of symbol under cursor using LSP',
    })

    -- hover information of symbol under cursor
    m('n', 'K', function()
      vim.lsp.buf.hover { border = 'single' }
    end, {
      noremap = true,
      desc = 'hover information about symbol under cursor using LSP',
    })

    -- toggle (i)nlay (h)ints
    m('n', '<leader>ih', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { noremap = true, desc = 'toggle (i)nlay (h)ints' })

    -- TODO: (t)oggle (c)ode (l)enses

    -- (c)ode (a)ction
    m('n', '<leader>ca', vim.lsp.buf.code_action, {
      noremap = true,
      desc = 'list (c)ode (a)ctions available for symbol under cursor using LSP',
    })

    -- (r)ename (s)ymbol
    m('n', '<leader>rs', vim.lsp.buf.rename, {
      noremap = true,
      desc = '(r)ename (s)ymbol under the cursor and all of its references using LSP',
    })
  end,
})

-------------------------------------------------------------------------------
--------------------------------- ToggleTerm ----------------------------------
-------------------------------------------------------------------------------

require('toggleterm').setup {
  open_mapping = [[<c-\>]],
}

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  callback = function()
    m('t', '<esc>', [[<C-\><C-n>]], { buffer = 0 })
    m('t', 'jk', [[<C-\><C-n>]], { buffer = 0 })
    m('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { buffer = 0 })
    m('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { buffer = 0 })
    m('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { buffer = 0 })
    m('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { buffer = 0 })
    m('t', '<C-w>', [[<C-\><C-n><C-w>]], { buffer = 0 })
  end,
})

-----------------------------
-- NORMAL MODE
-----------------------------

-- Leader key remapping to <Space>
m('', '<Space>', '<Nop>', { noremap = true, silent = true, desc = 'leader key' })

m('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'move to left(h) window' })
m('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'move to down(j) window' })
m('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'move to up(k) window' })
m('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'move to right(l) window' })
m('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true, desc = 'resize window size (Up)wards' })
m('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true, desc = 'resize window size (Down)wards' })
m('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = 'resize window (Left)wards' })
m('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = 'resize window (Right)wards' })
m('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true, desc = 'navigate to right(l) buffer' })
m('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'navigate to left(h) buffer' })
-- move text vertically
m('n', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true })
m('n', '<A-k>', '<Esc>:m .-3<CR>==gi', { noremap = true, silent = true })
m('n', 'J', 'mzJ`z', { noremap = true, silent = true, desc = 'append line below to current line' })
m('n', '<C-d>', '<C-d>zz')
m('n', '<C-u>', '<C-u>zz')
-- m("n", "n", "nzzzv", { noremap = true, silent = false, desc = "append line below to current line" })
-- m("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "append line below to current line" })
m('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '(r)eplace (w)ord' })
m('n', 'Q', '<nop>') -- disable annoying keys
m('n', '"', '<nop>') -- disable annoying keys
m('n', '<leader>vl', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = new_config }
end, { noremap = true, desc = 'toggle (v)irtual (l)ines diagnostics' })
m('n', '<leader>vt', function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = new_config }
end, { noremap = true, desc = 'toggle (v)irtual (t)ext diagnostics' })
m('n', '<leader>ed', vim.diagnostic.open_float, { noremap = true, desc = '(e)xplain (d)iagnostics under cursor' })
m('n', '<leader>qf', vim.diagnostic.setqflist, { noremap = true, desc = '(q)uick (f)ix' })

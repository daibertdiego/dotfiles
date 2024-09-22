require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions

    -- TODO: All of them are right now conflicting with harpoon dialog <leader>h

    -- map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', {desc = 'stage git hunk'})
    -- map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {desc = 'reset git hunk'})
    -- map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    -- map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    -- map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    -- map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
    -- map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    -- map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    -- map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    -- map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    -- map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' }) 
    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Inside hunk motion' })
  end
}


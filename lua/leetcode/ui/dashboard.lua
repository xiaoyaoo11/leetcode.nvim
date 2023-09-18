local utils = require("leetcode.utils")
local gql = require("leetcode.graphql")

local M = {}

local header = {
  type = "text",
  val = {
    [[ /$$                          /$$     /$$$$$$                /$$         ]],
    [[| $$                         | $$    /$$__  $$              | $$         ]],
    [[| $$       /$$$$$$  /$$$$$$ /$$$$$$ | $$  \__/ /$$$$$$  /$$$$$$$ /$$$$$$ ]],
    [[| $$      /$$__  $$/$$__  $|_  $$_/ | $$      /$$__  $$/$$__  $$/$$__  $$]],
    [[| $$     | $$$$$$$| $$$$$$$$ | $$   | $$     | $$  \ $| $$  | $| $$$$$$$$]],
    [[| $$     | $$_____| $$_____/ | $$ /$| $$    $| $$  | $| $$  | $| $$_____/]],
    [[| $$$$$$$|  $$$$$$|  $$$$$$$ |  $$$$|  $$$$$$|  $$$$$$|  $$$$$$|  $$$$$$$]],
    [[|________/\_______/\_______/  \___/  \______/ \______/ \_______/\_______/]],
  },
  opts = {
    position = "center",
    hl = "Keyword",
  },
}

local notifications = {
  type = "text",
  val = {},
  opts = {
    position = "center",
    hl = "DiagnosticInfo",
  },
}

local buttons = {
  type = "group",
  val = {},
  opts = {
    spacing = 1,
  },
}

local footer = {
  type = "text",
  val = {},
  opts = {
    position = "center",
    hl = "Number",
  },
}

function M.setup()
  local user = gql.auth.user_status()
  local is_signed_in = (user ~= nil and user.isSignedIn)

  local alpha = require("alpha")
  local dashboard = require("alpha.themes.dashboard")

  notifications.val = not is_signed_in and { " Sign in to use LeetCode.nvim" } or {}

  buttons.val = is_signed_in
      and {
        dashboard.button(
          "p",
          " " .. " All Problems",
          "<cmd>lua require('leetcode.api').cmd.lc_problems()<CR>"
        ),
        dashboard.button(
          "t",
          "󰃭 " .. " Question of today",
          "<cmd>lua require('leetcode.api').gql.problems.question_of_today()<CR>"
        ),
        dashboard.button("r", " " .. " Recent problems", ""),
        dashboard.button(
          "c",
          "󰆘 " .. " Update cookie",
          "<cmd>lua require('leetcode.utils').prompt_for_cookie()<cr>"
        ),
        dashboard.button(
          "s",
          " " .. " Sign out",
          "<cmd>lua require('leetcode.utils').remove_cookie()<cr>"
        ),
        dashboard.button("q", "󰩈 " .. " Exit LeetCode", "<cmd>qa<CR>"),
      }
    or {
      dashboard.button(
        "s",
        " " .. " Sign in (By Cookie)",
        "<cmd>lua require('leetcode.utils').prompt_for_cookie()<cr>"
      ),
      dashboard.button("q", "󰩈 " .. " Exit LeetCode", "<cmd>qa!<CR>"),
    }

  footer.val = is_signed_in and "Signed in as: " .. user.username or ""

  local section = {
    header = header,
    notifications = notifications,
    buttons = buttons,
    footer = footer,
  }

  local config = {
    layout = {
      -- header
      { type = "padding", val = 4 },
      section.header,

      -- notifications
      { type = "padding", val = 2 },
      section.notifications,
      { type = "padding", val = 2 },

      -- buttons
      section.buttons,

      --footer
      section.footer,
    },
    opts = {
      margin = 5,
    },
  }

  alpha.setup(config)
end

function M.update()
  utils.alpha_move_cursor_top()
  M.setup()
  pcall(vim.cmd, "AlphaRedraw")
end

return M

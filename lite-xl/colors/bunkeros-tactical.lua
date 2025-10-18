-- BunkerOS Tactical Theme for Lite XL
-- Matches the BunkerOS tactical color scheme

local style = require "core.style"
local common = require "core.common"

-- Tactical color palette
local tactical = {
  background       = { common.color "#1C1C1C" },  -- Dark tactical base
  background2      = { common.color "#2B2D2E" },  -- Sidebar/secondary
  background3      = { common.color "#3C4A2F" },  -- Tactical green dark
  
  text             = { common.color "#D4D4D4" },  -- Main text
  caret            = { common.color "#C3B091" },  -- Tactical gold
  accent           = { common.color "#C3B091" },  -- Tactical gold (highlights)
  
  dim              = { common.color "#8A8A8A" },  -- Dimmed text
  divider          = { common.color "#3C4A2F" },  -- Borders
  
  selection        = { common.color "#6B7A5440" },  -- Tactical green, transparent
  line_highlight   = { common.color "#2B2D2E" },    -- Current line
  
  line_number      = { common.color "#6B7A54" },  -- Line numbers (tactical green)
  line_number2     = { common.color "#C3B091" },  -- Current line number (gold)
  
  -- Syntax highlighting (tactical palette)
  syntax = {
    normal   = { common.color "#D4D4D4" },  -- Default text
    symbol   = { common.color "#D4D4D4" },  -- Symbols
    comment  = { common.color "#8A8A8A" },  -- Comments (dim)
    keyword  = { common.color "#C3B091" },  -- Keywords (tactical gold)
    keyword2 = { common.color "#D4A574" },  -- Secondary keywords (lighter gold)
    number   = { common.color "#9EBA8A" },  -- Numbers (light tactical green)
    literal  = { common.color "#9EBA8A" },  -- Literals (light tactical green)
    string   = { common.color "#A8C384" },  -- Strings (tactical green)
    operator = { common.color "#C3B091" },  -- Operators (tactical gold)
    function_name = { common.color "#E8D4B0" },  -- Functions (light gold)
  },
}

-- Apply theme
style.background = tactical.background
style.background2 = tactical.background2
style.background3 = tactical.background3

style.text = tactical.text
style.caret = tactical.caret
style.accent = tactical.accent

style.dim = tactical.dim
style.divider = tactical.divider

style.selection = tactical.selection
style.line_highlight = tactical.line_highlight

style.line_number = tactical.line_number
style.line_number2 = tactical.line_number2

-- Syntax colors
style.syntax = tactical.syntax

-- Scrollbar (tactical green)
style.scrollbar = { common.color "#3C4A2F" }
style.scrollbar2 = { common.color "#6B7A54" }

-- Notifications
style.nagbar = tactical.background2
style.nagbar_text = tactical.text
style.nagbar_dim = tactical.dim

-- Status bar (tactical theme)
style.statusbar_background = tactical.background2
style.statusbar_text = tactical.text
style.statusbar_dim = tactical.dim

-- Tab bar
style.tab_background = tactical.background2
style.tab_active_background = tactical.background3

-- Console/terminal
style.log = {
  ["INFO"]  = tactical.accent,
  ["WARN"]  = { common.color "#D4A574" },  -- Warning (lighter gold)
  ["ERROR"] = { common.color "#C37F7F" },  -- Error (tactical red-ish)
}


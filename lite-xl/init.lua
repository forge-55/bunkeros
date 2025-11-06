-- BunkerOS Lite XL Configuration
-- Tactical, minimalist, focused

local core = require "core"
local config = require "core.config"
local style = require "core.style"

-- Theme
core.reload_module("colors.bunkeros-tactical")

-- General settings
config.fps = 60
config.max_log_items = 80
config.message_timeout = 5
config.animation_rate = 1.0  -- Default speed
config.disabled_transitions = {
  -- Disable only the slowest transitions, keep smooth scrolling
  scroll = false,  -- Keep smooth scrolling (feels professional)
  commandview = true,  -- Instant command palette
  contextmenu = true,  -- Instant menus
  logview = true,  -- Instant log
}

-- Editor preferences
config.line_height = 1.4
config.indent_size = 4
config.tab_type = "soft"  -- Use spaces
config.line_limit = 100
config.scroll_past_end = true  -- Smooth scrolling to end of file

-- Always show line numbers
config.line_numbers = true

-- File browser (tree view)
config.treeview_size = 200 * SCALE

-- Font settings (will use system monospace if not specified)
-- Users can customize by installing Nerd Fonts
-- style.font = renderer.font.load(USERDIR .. "/fonts/FiraCode-Regular.ttf", 14 * SCALE)
-- style.code_font = style.font

-- Tactical focus: minimize distractions
config.borderless = false
config.always_show_tabs = true

-- Keybindings (add BunkerOS-specific shortcuts if needed)
-- Most defaults are sensible, but we can add custom ones here

-- Auto-reload files modified externally (useful for notes synced across devices)
config.autochange_reload = true

-- Save session (remember open files)
config.keep_newline_whitespace = false
config.max_project_files = 2000

-- Status bar configuration
config.statusbar = {
  show = true,
  show_file_path = true,
  show_file_size = false,
  show_line_endings = false,
}

-- Hide mouse when typing (focused experience)
config.mouse_wheel_scroll = 3

-- Highlight matching brackets
config.highlight_current_line = true

-- Scroll past end of file (comfortable note-taking)
config.scroll_past_end = true


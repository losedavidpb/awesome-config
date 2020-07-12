-- cosatheme theme file (based in zenburn awesome theme / anrxc)
-- @author David Parreño Barbuzano

local dpi = require("beautiful.xresources").apply_dpi

-- Global variables
local mytheme_path = os.getenv("HOME").."/.config/awesome/themes/cosatheme/"
local default_theme_path = "/usr/share/awesome/themes/default/"
local zenburn_theme_path = "/usr/share/awesome/themes/zenburn/"

local theme = {}

-- {{{ Main configurations
theme.wallpaper         = mytheme_path .. "wallpaper.jpg"
theme.font              = "Noto Sans Regular 10"
theme.notification_font = "Noto Sans Bold 14"
--- }}}

-- {{{ Colors
theme.fg_normal     = "#e2dde6"
theme.fg_focus      = "#c8c1cd"
theme.fg_urgent     = "#CC9393"
theme.fg_minimize   = "#101010"

theme.bg_normal     = "#1E2320"
theme.bg_focus      = "#3F3F3F"
theme.bg_urgent     = "#3F3F3F"
theme.bg_minimize   = "#101010"
theme.bg_systray    = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = "#37313f"
theme.border_focus  = "#413a4a"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#312c38"
theme.titlebar_bg_normal = "#40394a"
-- }}}

-- {{{ Menu
theme.menu_height = dpi(35)
theme.menu_width  = dpi(200)
-- }}}

-- {{{ Icons

-- {{{ Taglist
theme.taglist_squares_sel   = zenburn_theme_path .. "taglist/squarefz.png"
theme.taglist_squares_unsel = zenburn_theme_path .. "taglist/squarez.png"
-- }}}

-- {{{ Misc
theme.awesome_icon           = zenburn_theme_path .. "awesome-icon.png"
theme.menu_submenu_icon      = default_theme_path .. "submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = zenburn_theme_path .. "layouts/tile.png"
theme.layout_tileleft   = zenburn_theme_path .. "layouts/tileleft.png"
theme.layout_tilebottom = zenburn_theme_path .. "layouts/tilebottom.png"
theme.layout_tiletop    = zenburn_theme_path .. "layouts/tiletop.png"

theme.layout_fairv      = zenburn_theme_path .. "layouts/fairv.png"
theme.layout_fairh      = zenburn_theme_path .. "layouts/fairh.png"

theme.layout_spiral     = zenburn_theme_path .. "layouts/spiral.png"
theme.layout_dwindle    = zenburn_theme_path .. "layouts/dwindle.png"
theme.layout_max        = zenburn_theme_path .. "layouts/max.png"
theme.layout_fullscreen = zenburn_theme_path .. "fullscreen.png"
theme.layout_magnifier  = zenburn_theme_path .. "layouts/magnifier.png"
theme.layout_floating   = zenburn_theme_path .. "layouts/floating.png"

theme.layout_cornernw   = zenburn_theme_path .. "layouts/cornernw.png"
theme.layout_cornerne   = zenburn_theme_path .. "layouts/cornerne.png"
theme.layout_cornersw   = zenburn_theme_path .. "layouts/cornersw.png"
theme.layout_cornerse   = zenburn_theme_path .. "layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = zenburn_theme_path .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = zenburn_theme_path .. "titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = zenburn_theme_path .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = zenburn_theme_path .. "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = zenburn_theme_path .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = zenburn_theme_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = zenburn_theme_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = zenburn_theme_path .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = zenburn_theme_path .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = zenburn_theme_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = zenburn_theme_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = zenburn_theme_path .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = zenburn_theme_path .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = zenburn_theme_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = zenburn_theme_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = zenburn_theme_path .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = zenburn_theme_path .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = zenburn_theme_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = zenburn_theme_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = zenburn_theme_path .. "titlebar/maximized_normal_inactive.png"
-- }}}

-- }}}

theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

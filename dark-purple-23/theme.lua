-- @author losedavidpb (some files are from pro-dark and zenburn themes)
-- pro-dark: https://github.com/4ban/awesome-pro
-- zenburn: https://github.com/awesomeWM/awesome

local theme = {}

-- Global variables
local themepath         = os.getenv("HOME").."/.config/awesome/themes/dark-purple-23/"
local xresources        = require("beautiful.xresources")
local dpi               = xresources.apply_dpi

--- {{{ General colors
local light_white         = "#C8C1CD"
local normal_white        = "#E2DDE6"
local light_gray          = "#585858"
local normal_gray         = "#3F3F3F"
local light_black         = "#1E2320"
local dark_black          = "#101010"
local light_purple        = "#534A5F"
local dark_purple         = "#413A4A"
local strong_dark_purple  = "#37313F"
local normal_pink         = "#CC9393"
--- }}}

-- {{{ Main settings
theme.wallpaper           = themepath .. "background.jpg"
theme.font                = "Noto Sans Regular 10"

--- {{{ Colors
theme.fg_normal     = normal_white
theme.fg_focus      = light_white
theme.fg_urgent     = normal_pink
theme.fg_minimize   = dark_black

theme.bg_normal     = light_black
theme.bg_focus      = normal_gray
theme.bg_urgent     = light_gray
theme.bg_minimize   = dark_black
theme.bg_systray    = light_black
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = light_purple
theme.border_focus  = dark_purple
theme.border_marked = strong_dark_purple
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = dark_black
theme.titlebar_bg_normal = normal_gray
-- }}}

-- {{{ Menu
theme.menu_submenu_icon      = themepath .. "submenu.png"
theme.menu_height            = dpi(35)
theme.menu_width             = dpi(200)
-- }}}

--- {{{ Taglist
local taglist_square_size     = dpi(4)
theme.taglist_squares_sel     = themepath .. "taglist/squarefz.png"
theme.taglist_squares_unsel   = themepath .. "taglist/squarez.png"
--- }}}

-- {{{ Titlebar
theme.titlebar_close_button_normal              = themepath .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themepath .. "titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themepath .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themepath .. "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active        = themepath .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = themepath .. "titlebar/ontop_normal_active.png"

theme.titlebar_ontop_button_focus_inactive      = themepath .. "titlebar/ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_inactive     = themepath .. "titlebar/ontop_normal_inactive.svg"

theme.titlebar_sticky_button_focus_active       = themepath .. "titlebar/sticky_focus_active.svg"
theme.titlebar_sticky_button_normal_active      = themepath .. "titlebar/sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_inactive     = themepath .. "titlebar/sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_inactive    = themepath .. "titlebar/sticky_normal_inactive.svg"

theme.titlebar_floating_button_focus_active     = themepath .. "titlebar/floating_focus_active.svg"
theme.titlebar_floating_button_normal_active    = themepath .. "titlebar/floating_normal_active.svg"
theme.titlebar_floating_button_focus_inactive   = themepath .. "titlebar/floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_inactive  = themepath .. "titlebar/floating_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active    = themepath .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = themepath .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themepath .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themepath .. "titlebar/maximized_normal_inactive.png"
-- }}}

--- {{{ Layouts
theme.layout_fairh                  = themepath .. "layouts/fairh.png"
theme.layout_fairv                  = themepath .. "layouts/fairv.png"

theme.layout_floating               = themepath .. "layouts/floating.png"
theme.layout_magnifier              = themepath .. "layouts/magnifier.png"
theme.layout_max                    = themepath .. "layouts/max.png"
theme.layout_fullscreen             = themepath .. "layouts/fullscreen.png"

theme.layout_tilebottom             = themepath .. "layouts/tilebottom.png"
theme.layout_tileleft               = themepath .. "layouts/tileleft.png"
theme.layout_tile                   = themepath .. "layouts/tile.png"
theme.layout_tiletop                = themepath .. "layouts/tiletop.png"

theme.layout_spiral                 = themepath .. "layouts/spiral.png"
theme.layout_dwindle                = themepath .. "layouts/dwindle.png"

theme.layout_cornernw               = themepath .. "layouts/cornernw.png"
theme.layout_cornerne               = themepath .. "layouts/cornerne.png"
theme.layout_cornersw               = themepath .. "layouts/cornersw.png"
theme.layout_cornerse               = themepath .. "layouts/cornerse.png"
--- }}}

--- {{{ Icons
theme.icon_theme   = nil  -- usr/share/icons and /usr/share/icons/hicolor will be used
theme.awesome_icon = themepath .. "awesome-icon.png"
-- }}}

--- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

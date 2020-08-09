-- @author davidpb-cosa

--- {{{ Useful Awesome libraries
local gears                 = require("gears")
local lain                  = require("lain")
local awful                 = require("awful")
local wibox                 = require("wibox")
local beautiful             = require("beautiful")
local menubar               = require("menubar")
local hotkeys_popup         = require("awful.hotkeys_popup").widget
local naughty               = require("naughty")

require("awful.autofocus")
require("awful.rules")

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local table, tostring, tonumber, type = table, tostring, tonumber, type
local ipairs, string, os = ipairs, string, os
--- }}}

-- {{{ Global functions
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    				 title = "Oops, there were errors during startup!",
    				 text = awesome.startup_errors })
end

-- Error handling after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        				 title = "Oops, an error happened!",
        				 text = tostring(err) })

        in_error = false
    end)
end

-- Helper function
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

-- Wallpaper setter
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper

        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = "#413a4a"
    end
end
-- }}}

-- Naughty presets
naughty.config.defaults.timeout       = 5
naughty.config.defaults.screen        = 1
naughty.config.defaults.position      = "top_right"
naughty.config.defaults.margin        = 8
naughty.config.defaults.gap           = 1
naughty.config.defaults.ontop         = true
naughty.config.defaults.font          = "Meslo LGS Regular 10"
naughty.config.defaults.icon          = nil
naughty.config.defaults.icon_size     = 32
naughty.config.defaults.fg            = beautiful.fg_tooltip
naughty.config.defaults.bg            = beautiful.bg_tooltip
naughty.config.defaults.border_color  = beautiful.border_tooltip
naughty.config.defaults.border_width  = 2
naughty.config.defaults.hover_timeout = nil

-- Layout lain settings
lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

-- {{{ Variable definitions
local themes = {
    "dark-purple-23"      -- 1
    -- insert new themes here
}

local chosen_theme = themes[1]
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. chosen_theme .. "/theme.lua")

-- Common variables and user variables defined
local modkey            = "Mod4"
local altkey            = "Mod1"

local tagnames          = { "main", "browser", "etc" }
local awesomelink       = "https://awesomewm.org/doc/api/index.html"

local home              = os.getenv("HOME")
local browser           = "exo-open --launch WebBrowser --incognito" or "chromium"
local filemanager       = "exo-open --launch FileManager" or "thunar"
local terminal          = "/usr/bin/termite" or os.getenv("TERMINAL")
local editor            = os.getenv("EDITOR") or "nano"
local gui_editor        = "atom" or "mousepad"
local scrlocker         = "xlock"

local spacesep = wibox.widget {
  opacity = 0,
  color = beautiful.bg_focus,
  widget = wibox.widget.separator,
}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
local myawesomemenu = {
  { "hotkeys", function() return false, hotkeys_popup.show_help end },
	{ "manual", browser .. awesomelink },
  { "config", gui_editor .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", awesome.quit },
}

local mydevelopmentmenu = {
  { "Atom", "atom" },
  { "Mousepad", "mousepad" },
  { "Terminal", terminal },
}

local myexitmenu = {
  { "log out", function() awesome.quit() end },
  { "suspend", "systemctl suspend" },
  { "hibernate", "systemctl hibernate" },
  { "reboot", "systemctl reboot" },
  { "shutdown", "poweroff" },
}

local mymainmenu = awful.menu({
    items = {
      { "Awesome", myawesomemenu },
      { "Development", mydevelopmentmenu },
      { "Exit", myexitmenu },
    },
    width = 150
})

local mylauncher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = mymainmenu }
)

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
-- }}}

-- {{{ Wibox

local memwidget = lain.widget.mem {
  settings = function()
    widget:set_text(" "..mem_now.used.."MB ")
  end
}

local cpuwidget = lain.widget.cpu {
  settings = function()
    widget:set_text(" "..cpu_now.usage.."% ")
  end
}

local volumewidget = lain.widget.alsabar {
  followtag = true,
  width = 40,
  margins = 3,
  colors = {
  	background = "#171616",
  	mute = "#c5bdbd",
  	unmute = "#c5bdbd"
  }
}

local mytextclock = wibox.widget.textclock(
  "<span> <b>%H:%M</b> </span>")

local mycalendar = lain.widget.calendar {
  attach_to = { mytextclock },
  notification_preset = {
    font = "Monospace 11",
    fg   = beautiful.fg_normal,
    bg   = beautiful.bg_normal
  }
}

local mykeyboardlayout = awful.widget.keyboardlayout {
  color = beautiful.bg_normal,
  widget = wibox.widget.keyboardlayout,
}
-- }}}

-- Buttons for volume widget
volumewidget.bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click to set max volume level
        os.execute(string.format("%s set %s 100%%", volumewidget.cmd, volumewidget.channel))
        volumewidget.update()
    end),
    awful.button({}, 3, function() -- right click for mute/unmute mode
        os.execute(string.format("%s set %s 0%%", volumewidget.cmd, volumewidget.channel))
        volumewidget.update()
    end),
    awful.button({}, 4, function() -- scroll up to increase volume level
        os.execute(string.format("%s set %s 1%%+", volumewidget.cmd, volumewidget.channel))
        volumewidget.update()
    end),
    awful.button({}, 5, function() -- scroll down to decrease volume level
        os.execute(string.format("%s set %s 1%%-", volumewidget.cmd, volumewidget.channel))
        volumewidget.update()
    end)
))
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1,
    function (c)
      if c == client.focus then
        c.minimized = true
      else
        -- Without this, the following :isvisible() makes no sense
        c.minimized = false

        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end

        -- This will also un-minimize the client, if needed
        client.focus = c
        c:raise()
      end
    end),

  awful.button({ }, 3, client_menu_toggle_fn()),
  awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mylayoutbox:buttons(gears.table.join(
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end))
    )

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      style   = { shape = gears.shape.rounded_rect },
      widget_template = {
        {
          {
            {
              {
                {
                  id     = 'index_role',
                  widget = wibox.widget.textbox,
                },
                visible = false, margins = 4,
                widget  = wibox.container.margin,
              },
              widget = wibox.container.background,
            },
            {
              {
                id     = 'icon_role',
                widget = wibox.widget.imagebox,
              },
              margins = 2,
              widget  = wibox.container.margin,
            },
            {
              id     = 'text_role',
              widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
          },
          left  = 15, right = 15,
          widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,

        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            self:connect_signal('mouse::enter', function()
                if self.bg ~= beautiful.bg_focus then
                    self.backup     = self.bg
                    self.has_backup = true
                end

                self.bg = beautiful.bg_focus
            end)
            self:connect_signal('mouse::leave', function()
                if self.has_backup then self.bg = self.backup end
            end)
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
    },
    buttons = taglist_buttons
   }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
      shape_border_width = 1,
      shape_border_color = '#777777',
      shape  = gears.shape.rounded_bar,
    },
    layout   = {
      spacing = 10,
      layout  = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            {
              id     = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget  = wibox.container.margin,
          },
          {
            id     = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left  = 10, right = 10,
        widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
   },
  }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 28, bg = beautiful.panel, fg = beautiful.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacesep.widget,
            wibox.container.background(s.mytaglist, beautiful.bg_normal),
            wibox.container.background(s.mypromptbox, beautiful.bg_normal),
            spacesep.widget,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox.container.background(volumewidget.bar),
            spacesep.widget,
            wibox.container.background(mykeyboardlayout.widget, beautiful.bg_normal),
            spacesep.widget,
            wibox.container.background(memwidget.widget, beautiful.bg_normal),
            spacesep.widget,
            wibox.container.background(cpuwidget.widget, beautiful.bg_normal),
            spacesep.widget,
            wibox.container.background(mytextclock, beautiful.bg_normal),
            spacesep.widget,
            wibox.container.background(s.mylayoutbox, beautiful.bg_normal),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

  -- Pop-up windows and Awesome reload/quit
  awful.key(
    { modkey, "Control" }, "l", function () os.execute(scrlocker) end,
    {description = "lock screen", group = "hotkeys"}),
  awful.key(
    { modkey, }, "s", hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key(
    { modkey, }, "w", function () mymainmenu:show() end,
    {description = "show main menu", group = "awesome"}),
  awful.key(
    { modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key(
    { modkey, "Control"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

  -- Show/Hide Wibox
  awful.key(
    { modkey }, "b", function ()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.mybottomwibox then s.mybottomwibox.visible = not s.mybottomwibox.visible end
      end
    end,
    {description = "toggle wibox", group = "awesome"}),

  -- Tags
  awful.key(
    { modkey, }, "Left", awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key(
    { modkey, }, "Right", awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key(
    { modkey, }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  -- Brightness
  awful.key(
    { }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 10") end,
    {description = "+10%", group = "hotkeys"}),
  awful.key(
    { }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 10") end,
    {description = "-10%", group = "hotkeys"}),

  -- Clients
  awful.key(
    { modkey, }, "j", function () awful.client.focus.byidx( 1) end,
    {description = "focus next by index", group = "client"}),
  awful.key(
    { modkey, }, "k", function () awful.client.focus.byidx(-1) end,
    {description = "focus previous by index", group = "client"}),

  -- Layout manipulation
  awful.key(
    { modkey, "Control" }, "j", function () awful.client.swap.byidx(1) end,
    {description = "swap with next client by index", group = "client"}),
  awful.key(
    { modkey, "Control" }, "k", function () awful.client.swap.byidx(-1) end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key(
    { modkey, "Control" }, "n", function () local c = awful.client.restore() if c then client.focus = c c:raise() end end,
    {description = "restore minimized", group = "client"}),

  -- Launch programs
  awful.key(
    { modkey, }, "e", function () awful.spawn(filemanager) end,
    {description = "launch filemanager", group = "launcher"}),
  awful.key(
    { modkey }, "r", function () awful.spawn(browser) end,
    {description = "launch Browser", group = "launcher"}),
  awful.key(
    { modkey, }, "t", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key(
    { modkey, }, "y", function () awful.spawn(gui_editor) end,
    {description = "open Atom", group = "launcher"}),

  -- Master layout manipulation
  awful.key(
    { modkey, }, "+", function () awful.tag.incmwfact(0.05) end,
    {description = "increase master width factor", group = "layout"}),
  awful.key(
    { modkey, }, "-", function () awful.tag.incmwfact(-0.05) end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key(
    { modkey, "Control" }, "+", function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key(
    { modkey, "Control" }, "-", function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  awful.key(
    { modkey, "Alt" }, "+", function () awful.tag.incncol( 1, nil, true) end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key(
    { modkey, "Alt" }, "+", function () awful.tag.incncol(-1, nil, true) end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key(
    { modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
    {description = "select previous", group = "layout"}),

  -- Prompt and run Lua code
  awful.key(
    { altkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),
  awful.key(
    { altkey }, "l", function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"})
)

clientkeys = gears.table.join(
  awful.key(
    { modkey, "Shift" }, "m", lain.util.magnify_client,
    {description = "magnify client", group = "client"}),
  awful.key(
    { modkey, }, "f", function (c) c.fullscreen = not c.fullscreen c:raise() end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key(
    { modkey, }, "space",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key(
    { modkey, }, "x", function (c) c:kill() end,
    {description = "close", group = "client"}),
  awful.key(
    { modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key(
    { modkey, }, "n", function (c) c.minimized = true end,
    {description = "minimize", group = "client"}),
  awful.key(
    { modkey, }, "m", function (c) c.maximized = not c.maximized c:raise() end,
    {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 3 do
    globalkeys = gears.table.join(globalkeys,
      -- View tag only.
      awful.key(
        { modkey }, "#" .. i + 3,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
          end,
        {description = "view tag #"..i, group = "tag"}
      ),

      -- Toggle tag display.
      awful.key(
        { modkey, "Control" }, "#" .. i + 3,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then awful.tag.viewtoggle(tag) end
          end,
        {description = "toggle tag #" .. i, group = "tag"}
      ),

      -- Move client to tag.
      awful.key(
        { modkey, "Shift" }, "#" .. i + 3,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then client.focus:move_to_tag(tag) end
            end
          end,
        {description = "move focused client to tag #"..i, group = "tag"}
      ),

      -- Toggle tag on focused client.
      awful.key(
        { modkey, "Control", "Shift" }, "#" .. i + 3,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then client.focus:toggle_tag(tag) end
            end
          end,

        {description = "toggle focused client on tag #" .. i, group = "tag"}
      )
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() mymainmenu:hide() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false,
        screen = awful.screen.preferred,
        titlebars_enabled = true,
        placement = awful.placement.no_overlap +
          awful.placement.no_offscreen +
          awful.placement.centered
        }
     },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true }
    },

    -- Set Chromium to always map on the tag named "2" on screen 1.
    { rule = { class = "Chromium" },
      properties = { screen = 1, tag = "browser" }
    }
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local mytitlebar = awful.titlebar(c, {
      size      = 18,
      bg_normal = '#312c38',
      bg_focus  = '#40394a',
    })

   -- Buttons for the titlebar
   local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 2, function() c:kill() end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  -- Create my titlebar including useful widgets
  mytitlebar : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },

      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right: clasical widget buttons and floating mode
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = "#413a4a" end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

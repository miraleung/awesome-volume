--[[
-- Volume widget for awesomewm 3.5
-- @author miraleung
--]]

local wibox = require("wibox")
local awful = require("awful")

volume_icon = wibox.widget.imagebox()

volume_text = wibox.widget.textbox()
volume_text:set_align("right")

spacer = wibox.widget.textbox()
spacer:set_text("  ")


volume_widget = wibox.layout.fixed.horizontal()
volume_widget:add(volume_text)
volume_widget:add(spacer)
volume_widget:add(volume_icon)

function get_current_path()
   local path = debug.getinfo(2, "S").source:sub(2)
   return path:match("(.*/)")
end

function update_volume(text_widget, icon_widget)
  local fd = io.popen("amixer -D pulse sget Master")
  local pwd = get_current_path()
  local status = fd:read("*all")
  local icons_dir = "icons"
  fd:close()

  local volume = string.match(status, "(%d?%d?%d)%%")
  volume_int = tonumber(volume)
  volume_str = string.format("% 3d", volume)

  icon = "volume_icon_med.png"
  status = string.match(status, "%[(o[^%]]*)%]")

  if string.find(status, "on", 1, true) then
    -- For the volume numbers
    volume_str = volume_str .. "%"
  else
    -- For the mute button
    volume_int = 0
    volume_str = volume_str .. "M"
  end

  if volume_int == 0 then
    icon = "volume_icon_mute.png"
  elseif volume_int < 33 then
    icon = "volume_icon_low.png"
  elseif volume_int < 66 then
    icon = "volume_icon_med.png"
  else
    icon = "volume_icon_high.png"
  end

  text_widget:set_markup(volume_str)
  icon_widget:set_image(pwd .. "/" .. icons_dir .. "/" .. icon)
end

function volume_up()
  awful.util.spawn("amixer -D pulse sset Master 5%+")
end

function volume_down()
  awful.util.spawn("amixer -D pulse sset Master 5%-")
end

function volume_mute()
  awful.util.spawn("amixer -D pulse sset Master toggle")
end

update_volume(volume_text, volume_icon)

local mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_text, volume_icon) end)
mytimer:start()

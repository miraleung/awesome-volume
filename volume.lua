--[[
-- Volume widget for AwesomeWM 3.5
-- @author miraleung
--]]
local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function get_current_path()
   local path = debug.getinfo(2, "S").source:sub(2)
   return path:match("(.*/)")
end

function update_volume(widget)
  local fd = io.popen("amixer -D pulse sget Master")
  local pwd = get_current_path()
  local status = fd:read("*all")
  fd:close()

  local volume = string.match(status, "(%d?%d?%d)%%")
  volume = string.format("% 3d", volume)

  status = string.match(status, "%[(o[^%]]*)%]")

  if string.find(status, "on", 1, true) then
    -- For the volume numbers
    volume = volume .. "%"
  else
    -- For the mute button
    volume = volume .. "M"
  end

  widget:set_markup(volume)
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

update_volume(volume_widget)

mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()

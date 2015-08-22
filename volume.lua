--[[
-- Volume widget for awesomewm 3.5
-- @author miraleung
--]]

local wibox = require("wibox")
local awful = require("awful")

local volume_icon = wibox.widget.imagebox()

local audio_jack_icon = wibox.widget.imagebox()

local volume_text = wibox.widget.textbox()
volume_text:set_align("right")

local spacer = wibox.widget.textbox()
spacer:set_text("  ")

volume_widget = wibox.layout.fixed.horizontal()
volume_widget:add(volume_text)
volume_widget:add(spacer)
volume_widget:add(audio_jack_icon)
volume_widget:add(spacer)
volume_widget:add(volume_icon)

function get_current_path()
   local path = debug.getinfo(2, "S").source:sub(2)
   return path:match("(.*/)")
end

local current_path = get_current_path()

function update_volume()
  local fd = io.popen("amixer -D pulse sget Master")
  local status = fd:read("*all")
  local icons_dir = "icons"
  fd:close()

  local volume = string.match(status, "(%d?%d?%d)%%")
  local volume_int = tonumber(volume)
  local volume_str = string.format("% 3d", volume)

  local speaker_id = status:match("Playback%s%d%s%-%s(%d%d+)")
  local current_output_id = status:match(":%sPlayback%s(%d%d+)")
  local is_audio_jack_in = (speaker_id ~= current_output_id)

  local icon = "volume_icon_med.png"
  local aj_icon = "empty.png"
  status = string.match(status, "%[(o[^%]]*)%]")

  if string.find(status, "on", 1, true) then
    -- For the volume numbers
    volume_str = volume_str .. "%"
  else
    -- For the mute button
    volume_int = 0
    volume_str = volume_str .. "M"
  end

  -- Set icons
  if volume_int == 0 then
    icon = "volume_icon_mute.png"
  elseif volume_int < 33 then
    icon = "volume_icon_low.png"
  elseif volume_int < 66 then
    icon = "volume_icon_med.png"
  else
    icon = "volume_icon_high.png"
  end

  if is_audio_jack_in then
    aj_icon = "volume_icon_headphones.png"
  end

  volume_text:set_markup(volume_str)
  volume_icon:set_image(current_path .. "/" .. icons_dir .. "/" .. icon)
  audio_jack_icon:set_image(current_path .. "/" .. icons_dir .. "/" .. aj_icon)
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
mytimer:connect_signal("timeout", function () update_volume() end)
mytimer:start()

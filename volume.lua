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

function isempty(str)
  return str == nil or str == ""
end

-- Returns the amixer command for checking the headphone jack.
function get_headphone_query()
  local num_cards_cmd = 'grep -nr "[0-9]\\+ \\[" /proc/asound/cards | wc -l'
  local fd = io.popen(num_cards_cmd)
  local num_cards_str = fd:read("*all")
  fd:close()

  local num_cards = tonumber(num_cards_str)
  local curr_card_id = 0
  local control_id = ""
  for i = 0, num_cards, 1 do
    find_controls_cmd = 'amixer -c ' .. tostring(i) .. ' controls | grep "Headphone Jack"'
    fd = io.popen(find_controls_cmd)
    local control_str = fd:read("*all")
    fd:close()
    if not isempty(control_str) then
      curr_card_id = tostring(i)
      control_id = control_str
      io.write(control_str)
      break
    end
  end

  local amixer_headphones_cmd = ""
  if not isempty(control_id) then
    amixer_headphones_cmd = "amixer -c " .. curr_card_id .. " cget " .. control_id
  end

  return amixer_headphones_cmd
end


local current_path = get_current_path()
local query_headphones_cmd = get_headphone_query()

-- Returns true if headphones are plugged in
function is_audio_jack_in()
  if isempty(query_headphones_cmd) then
    return false
  end

  local fd = io.popen(query_headphones_cmd)
  local headphone_status = fd:read("*all")
  fd:close()
  headphone_status = headphone_status:match("values=(o%w+)")
  return headphone_status == "on"
end

function get_volume_icon(volume_int)
  if volume_int == 0 then
    icon = "volume_icon_mute.png"
  elseif volume_int < 33 then
    icon = "volume_icon_low.png"
  elseif volume_int < 66 then
    icon = "volume_icon_med.png"
  else
    icon = "volume_icon_high.png"
  end
  return icon
end

function update_volume()
  local fd = io.popen("amixer -D pulse sget Master")
  local status = fd:read("*all")
  local icons_dir = "icons"
  fd:close()

  local volume = status:match("(%d?%d?%d)%%")
  local volume_int = tonumber(volume)
  local volume_str = string.format("% 3d", volume)

  status = status:match("%[(o[^%]]*)%]")

  if status:find("on", 1, true) then
    -- For the volume numbers
    volume_str = volume_str .. "%"
  else
    -- For the mute button
    volume_int = 0
    volume_str = volume_str .. "M"
  end

  local icon = get_volume_icon(volume_int)
  if is_audio_jack_in() then
    local aj_icon = "volume_icon_headphones.png"
    audio_jack_icon:set_image(current_path .. "/" .. icons_dir .. "/" .. aj_icon)
  else
    audio_jack_icon:set_image(nil)
  end

  volume_text:set_markup(volume_str)
  volume_icon:set_image(current_path .. "/" .. icons_dir .. "/" .. icon)

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

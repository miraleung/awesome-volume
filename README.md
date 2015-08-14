# awesome-volume
A volume widget for [awesomewm](http://awesome.naquadah.org/) 3.5.

## Installation
1. `cd ~/.config/awesome/lib` (awesomewm config directory).
2. `git clone https://github.com/miraleung/awesome-volume.git`
3. In `rc.lua`:
  1. Add to the top:
    ```
    local volume require("lib.awesome-volume.volume")
    ```
  2. After the line `if s == 1 then right_layout:add(wibox.widget.systray()) end`, add
    ```
    right_layout:add(volume_widget)
    ```

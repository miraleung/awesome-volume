# awesome-volume
A volume widget for [awesomewm](http://awesome.naquadah.org/) 3.5.

![awesome-volume](https://cloud.githubusercontent.com/assets/5384433/9268419/9c43f76e-4213-11e5-8392-3b669a8ad8da.png)

## Screenshots
| **Low** | Medium | High | Mute | Headphones |
|:--------|:-------|:-----|:-----|:-----------|
| ![Low volume](https://cloud.githubusercontent.com/assets/5384433/9268417/9c335256-4213-11e5-86e2-2d77efb265f9.png) | ![Medium volume](https://cloud.githubusercontent.com/assets/5384433/9268418/9c4086ce-4213-11e5-9292-ea119ba45ed9.png) | ![High volume](https://cloud.githubusercontent.com/assets/5384433/9268416/9c214412-4213-11e5-8bfa-1a1dd6aa2bff.png) | ![Mute](https://cloud.githubusercontent.com/assets/5384433/9433026/10c623bc-49e1-11e5-8e51-fe4de9280bab.png) | ![Headphones in](https://cloud.githubusercontent.com/assets/5384433/9433014/ebf99078-49e0-11e5-810a-c3e32c9939fb.png) |


## Installation
0. **Dependencies:** [amixer](http://linux.die.net/man/1/amixer) from the `alsa-utils` package.
1. `cd ~/.config/awesome/lib`
2. `git clone https://github.com/miraleung/awesome-volume.git`
3. `cd ..`
4. In `rc.lua`:
  1. Add to the top:

    ```
    local volume require("lib.awesome-volume.volume")
    ```
  2. After the line `if s == 1 then right_layout:add(wibox.widget.systray()) end`, add

    ```
    right_layout:add(volume_widget)
    ```
  3. Add keybindings to the section `globalkeys = awful.util.table.join(...)`:

    ```
    awful.key({ modkey, <Modifier> }, <Key>, function() volume_up() end),
    awful.key({ modkey, <Modifier> }, <Key>, function() volume_down() end),
    awful.key({ modkey, <Modifier> }, <Key>, function() volume_mute() end)
    ```

Icons sourced from [here](https://www.iconfinder.com), widget adapted from [here](https://awesome.naquadah.org/wiki/Volume_control_and_display).

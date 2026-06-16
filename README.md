*YouTube.AHK*

Simple library using UIA controls to do some controls on youtube from anywhere. Play/Pause, Fwd/Bck, Volume control. Does not provide automatic return of focus to previous active window - if you want that a wrapper function would be needed

*convertes.ahk*

A collection of some conversion I often use, mostly between different formats of time (HH:MM:SS, x minutes, y hours, z seconds of a hours, b minutes and c seconds, and such things, also some array convenience functions)

*matchstrings.ahk*

Windows Matchstrings I use, feel free to reuse, nothing special

*mouseAndKeyHelpers.ahk*

To make my code a bit more readable and to quickly experiment with some features

*notifications.ahk*
Provides several types of notifications
- Flyout: A flyout will stay on the screen for the specified duration, either on the top, center or bottom of your screen. If duration is longer than 4 seconds a progress bar until it disappears will also be shown. This can also be set to a value (e.g. if you set volume and provide feedback). I find this a lot better for quick debugging than modal boxes - and it works very well for quick feedback on hotkeys.
- infoScreen: A semi transparant screen. You can assign it a toggle hotkey and it will show on the side of your screen with your specified content

*ScreenBorder.ahk*

Provides functions to create a colored border around your screen, and a blink function

*tapHandlers.ahk*

Has two functions:
- HandleTap: You can assign this to a hotkey using a unique identifier. It will then trigger a function you provide as an argument with at least argument 'n' - where n is the numer of times the key was pressed. You can also provide tooltips for each number of taps
- CumulativeHandleTap: similar to handletap except it sends a total with a custom increment - useful for e.g. setting volume to 30% or 40% with 3 or 4 taps, custom seeks in video, etc.

*volumeControl.ahk*

Depends on external libraries and soundvolumeview
You can control the volume of your installed audio devices from AHK. e.g. cycle between headphones, speakers, etc. and then set the volume for the selected device

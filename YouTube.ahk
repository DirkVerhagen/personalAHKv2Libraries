#Requires AutoHotkey v2.0
#include matchstrings.ahk
#include notifications.ahk
#include ..\..\lib\personalVariables.ahk
#Include ..\..\lib\UIA.ahk
#Include ..\..\lib\UIA_Browser.ahk
if (!WinExist(ffBrowserMatchString)) {
    Run(fireFoxExecutable)
    if (!WinWait(ffBrowserMatchString, , 5000)) {
        MsgBox "Firefox did not start in time, exiting script"
        ExitApp()
    }
}
global DefaultYTBrowserFirefox := UIA_Browser(ffBrowserMatchString)
global errorDuration := 2000


YTgetRunTime(browser := DefaultYTBrowserFirefox) {
    try {
        sliderEl := browser.FindElement({ ClassName: "ytp-progress-bar" })

    }
    catch error as e {  ;probably called with a photo iso movie
        ;flyOut("Could not get YT Fraction")
        return -1
    }
    if (IsInteger(sliderEl)) {
        flyOut("FindElement returned an integer", errorDuration, , 2)
        return -1
    }
    try {
        runTime := sliderEl.RangeValuePattern.Value ;this gives the seconds value of the slider
    }
    catch {
        flyOut "rangeValuePattern did not return runtime", 2000, "bottom"
        return -1
    }
    return Number(runTime)
}

YTgetTotalSeconds(browser := DefaultYTBrowserFirefox) {
    try {
        sliderEl := browser.WaitElement({ ClassName: "ytp-progress-bar" }, 3000)

    }
    catch error as e {
        flyOut("Not able to get total seconds", errorDuration, , 2)
        return -1
    }
    if (IsInteger(sliderEl)) {
        flyOut("FindElement returned an integer", errorDuration, , 2)
        return -1
    }
    try {
        totalSeconds := Number(sliderEl.RangeValuePattern.Maximum)
    }
    catch {
        flyOut("Could not determine total time", errorDuration, , 2)
    }
    return Floor(totalSeconds)
}


/**
 * 
 * @param {UIA_Browser} browser  A UIA Browser object with the element ClassName ytp-progress-bar contained in it
 * @returns {Number | Integer} the number of seconds left for the first ytp-progress-bar found in that browser
 */
YTgetSecondsLeft(browser := DefaultYTBrowserFirefox) {
    runtime := YTgetRunTime(browser)
    lengthInSeconds := YTgetTotalSeconds(browser)
    fraction := runtime / lengthInSeconds
    secondsLeft := lengthInSeconds - (fraction * lengthInSeconds)
    return secondsLeft
}
YTgetFraction(browser := DefaultYTBrowserFirefox) {
    runTime := YTgetRunTime(browser)
    lengthInSeconds := YTgetTotalSeconds(browser)
    fraction := runTime / lengthInSeconds
    return fraction
}
YTActivateYouTube(browserObject := DefaultYTBrowserFirefox) {

    ;WinActivate(YTLibrary_chromeMatchString)
    sleep 500
    try {
        currentURL := browserObject.GetCurrentURL()
    }
    catch {
        flyOut("error fetching url", errorDuration, , 2)
        return
    }
    if (!InStr(currentURL, "youtube")) { ;if the current tab is youtube then youtube incorrectly has tab elements in its page breaking selectTab
        try { ;SelectTab has a tendency to fail, should be replaced
            browserObject.SelectTab("YouTube", 2, false) ;Look for YouTube in the title
            sleep 400 ; Bigger sleep as switching tabs takes time to process unfortunately
        }
        catch error as e {
            flyOut("Could not select youtube tab")
        }
    }
    else {
        sleep 50 ;small sleep to give chance to read URL
    }

}

YTSeek(browser := DefaultYTBrowserFirefox, direction := "forward") {
    YTActivateYouTube(browser)
    try {
        playBUtton := browser.ElementExist({ ClassName: "ytp-play-button ytp-button" })
        if (playBUtton) {
            playBUtton.SetFocus()
            if (direction == "forward")
                Send "l" ; Hotkey for forward
            else
                Send "j" ; Hotkey for backward
        }

    }
    catch error as e {
        flyOut("Method YTSeek failed: " . e.Message, errorDuration, , 2)
    }
}

YTGoTo(browser := DefaultYTBrowserFirefox, n := 0) { ;Goes back to beginning by default
    YTActivateYouTube(browser)
    try {
        playBUtton := browser.ElementExist({ ClassName: "ytp-play-button ytp-button" })
        if (playBUtton) {
            playBUtton.SetFocus()
            Send("" . n)
        }

    }
    catch error as e {
        flyOut("Method YTGoTo failed: " . e.Message)
    }
}

YTChangeVolume(fixedSetting := 200, browser := DefaultYTBrowserFirefox, increment := 10.0) {

    try {
        YTActivateYouTube(browser)
        ; we can use this to try how fast we need to set the wait in activate youtube. If the tab is active virtually none
        try {

            volumePanel := browser.ElementExist({ ClassName: "ytp-volume-panel" })
            if (volumePanel) {
                ;MsgBox(" " . fixedSetting)
                if (fixedSetting > 199) {
                    currentVolume := volumePanel.RangeValuePattern.Value
                    if (increment > 0.0) {
                        newVolume := Min(currentVolume + increment, 100)
                    }
                    else {
                        newVolume := Max(currentVolume + increment, 0)
                    }
                }
                else {
                    newVolume := fixedSetting
                }
                try {
                    browser.JSExecute("document.querySelector('.html5-video-player').setVolume(" . Integer(newVolume) . ");")
                    flyOut("Youtube Volume: " . Integer(newVolume), 1000, "bottom", 1)
                }
                catch error as e {
                    flyOut("Could not execute volume script :" e.Message, errorDuration, , 2)
                }
            }
        }
        catch error as e {
            flyOut("Could not find volume panel :" e.Message, errorDuration, , 2)
        }
    }
    catch error as e {
        flyOut("Could not active youtube during volume change :" e.Message, errorDuration, , 2)
    }


}

YTPlayPause(browser := DefaultYTBrowserFirefox) {

    YTActivateYouTube(browser)

    try {
        playBUtton := browser.ElementExist({ ClassName: "ytp-play-button ytp-button" })
        if (playBUtton) {
            playBUtton.Click()
        }
        else {
            ; we can still try the hotkey, results may vary based on whether activateyoutube succeeeded
            Send("k")
        }
        return 1

    }
    catch error as e {
        flyOut("Could not play/pause YT :" e.Message, errorDuration, , 2)
        return 0
    }
}
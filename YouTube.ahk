#Requires AutoHotkey v2.0

#include notifications.ahk
#Include ..\..\lib\UIA.ahk
#Include ..\..\lib\UIA_Browser.ahk

global YTLibrary_chromeMatchString := "ahk_exe chrome.exe"
global YTlibrary_Chrome := UIA_Browser(YTLibrary_chromeMatchString)



YTgetRunTime(browser := YTLibrary_Chrome) {
    try {
        sliderEl := browser.FindElement({ClassName:"ytp-progress-bar"})
        
    }
    catch error as e {  ;probably called with a photo iso movie
        ;flyOut("Could not get YT Fraction")
        return -1
    }
    if(IsInteger(sliderEl)) {
        flyOut "FindElement returned an integer"
        return -1
    }
    runTime := sliderEl.RangeValuePattern.Value ;this gives the seconds value of the slider
    return runTime * 1
}

YTgetTotalSeconds(browser := YTlibrary_Chrome) {
    try {
        sliderEl := browser.WaitElement({ClassName:"ytp-progress-bar"}, 3000)
        
    }
    catch error as e {
        flyOut("Not able to get total seconds")
        return -1
    }
    if(IsInteger(sliderEl)) {
        flyOut "FindElement returned an integer"
        return -1
    }
    totalSeconds := sliderEl.RangeValuePattern.Maximum
    return totalSeconds * 1
}



/**
 * 
 * @param {UIA_Browser} browser  A UIA Browser object with the element ClassName ytp-progress-bar contained in it
 * @returns {Number | Integer} the number of seconds left for the first ytp-progress-bar found in that browser
 */
YTgetSecondsLeft(browser := YTlibrary_Chrome){
    runtime := YTgetRunTime(browser)
    lengthInSeconds := YTgetTotalSeconds(browser)
    fraction := runtime / lengthInSeconds
    secondsLeft := lengthInSeconds - (fraction * lengthInSeconds)
    return secondsLeft 
}
YTgetFraction(browser := YTlibrary_Chrome) {
    runTime :=  YTgetRunTime(browser)
    lengthInSeconds := YTgetTotalSeconds(browser)
    fraction := runTime / lengthInSeconds
    return fraction
}
YTActivateYouTube(browserObject := YTlibrary_Chrome) {   
    
    WinActivate(YTLibrary_chromeMatchString)
    sleep 500
    try {
        currentURL := browserObject.GetCurrentURL()
    }
    catch {
        flyOut("error fetching url")
        return
    }
    if(!InStr(currentURL,"youtube")) { ;if the current tab is youtube then youtube incorrectly has tab elements in its page breaking selectTab
        try { ;SelectTab has a tendency to fail, should be replaced
            browserObject.SelectTab("YouTube",2,false) ;Look for YouTube in the title
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

YTSeek(browser := YTlibrary_Chrome, direction := "forward"){
    YTActivateYouTube(browser)
    try {
        playBUtton := browser.ElementExist({ClassName:"ytp-play-button ytp-button"})
        if(playBUtton){
            playBUtton.SetFocus()
            if(direction == "forward")
                Send "l" ; Hotkey for forward
            else
                Send "j" ; Hotkey for backward
        }
       
    }    
    catch error as e{
        MsgBox "Method YTSeek failed: " . e.Message
    }
}

YTGoTo(browser := YTlibrary_Chrome, n := 0) { ;Goes back to beginning by default
    YTActivateYouTube(browser)
    try {
        playBUtton := browser.ElementExist({ClassName:"ytp-play-button ytp-button"})
        if(playBUtton){
            playBUtton.SetFocus()
            Send("" . n)
        }
       
    }
    
    catch error as e{
        flyOut("Method YTGoTo failed: " . e.Message)
    }
}

YTChangeVolume(fixedSetting := 200, browser := YTlibrary_Chrome, increment := 10.0) {

    try {
         YTActivateYouTube(browser)
         ; we can use this to try how fast we need to set the wait in activate youtube. If the tab is active virtually none
         try {
            
             volumePanel := browser.ElementExist({ClassName:"ytp-volume-panel"})
             if(volumePanel){
                ;MsgBox(" " . fixedSetting)
                if(fixedSetting > 199) { 
                    currentVolume := volumePanel.RangeValuePattern.Value
                    if(increment > 0.0) {
                        newVolume := Min(currentVolume + increment,100)
                    }
                    else {
                        newVolume := Max(currentVolume + increment,0)
                    }
                }
                else  {
                    newVolume := fixedSetting
                }
                 try {
                     browser.JSExecute("document.querySelector('.html5-video-player').setVolume(" . Integer(newVolume) . ");")
                     flyOut("Youtube Volume: " . Integer(newVolume),1000,"bottom",1)
                     flyOut("Youtube Volume: " . Integer(newVolume),1000,"bottom",2)
                 }
                 catch error as e {
                     MsgBox("Could not execute volume script :" e.Message)
                     }        
                 }
             }
             catch error as e{
                 MsgBox("Could not find volume panel :" e.Message)
             }
         }
         catch error as e{
                 MsgBox("Could not active youtube during volume change :" e.Message)
         }

     
    }

YTPlayPause(browser := YTlibrary_Chrome) {
    
        YTActivateYouTube(browser)
        
        try {
            playBUtton := browser.ElementExist({ClassName:"ytp-play-button ytp-button"})
            if(playBUtton){
                playBUtton.Click()
            }
            else {
                ; we can still try the hotkey, results may vary based on whether activateyoutube succeeeded
                Send("k")
            }
           
        }
        catch error as e{
            flyOut("Could not play/pause YT :" e.Message)
        }
    }
    
    
    
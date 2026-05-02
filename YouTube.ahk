#Requires AutoHotkey v2.0

#include notifications.ahk
#Include ..\..\lib\UIA.ahk
#Include ..\..\lib\UIA_Browser.ahk

global YTLibrary_chromeMatchString := "ahk_exe chrome.exe"
global YTlibrary_Chrome := UIA_Browser(YTLibrary_chromeMatchString)

YTgetFraction(browser := YTlibrary_Chrome) {
    try {
        sliderEl := browser.FindElement({ClassName:"ytp-progress-bar"})
        Sleep(50)
        value := sliderEl.RangeValuePattern.Value ;this gives the seconds value of the slider
        lengthInSeconds := sliderEl.RangeValuePattern.Maximum
        fraction := value / lengthInSeconds
        return fraction
    }
    catch error as e {  
        MsgBox "Could not get YT Fraction :" . e.Message
        return 0
    }
}

YTgetSecondsLeft(browser := YTlibrary_Chrome){
    try {
        sliderEl := browser.FindElement({ClassName:"ytp-progress-bar"})
        Sleep(50)
        value := sliderEl.RangeValuePattern.Value ;this gives the seconds value of the slider
        lengthInSeconds := sliderEl.RangeValuePattern.Maximum
        fraction := value / lengthInSeconds
        secondsLeft := lengthInSeconds - (fraction * lengthInSeconds)
        return secondsLeft  
    }
    catch error as e {  
        ;MsgBox "Could not get YT Seconds Left :" . e.Message
        return 0
    }
}

YTgetTotalSeconds(browser := YTlibrary_Chrome) {
    try {
        sliderEl := browser.FindElement({ClassName:"ytp-progress-bar"})
        
    }
    catch error as e {
        flyOut "Not able to get total seconds: " e.Message
        return -1
    }
    Sleep(50)
    value := sliderEl.RangeValuePattern.Maximum
    return value
}

YTActivateYouTube(browserObject := YTlibrary_Chrome) {   
    currentURL := browserObject.GetCurrentURL()
    WinActivate(YTLibrary_chromeMatchString)
    WinWaitActive(YTLibrary_chromeMatchString)
    if(!InStr(currentURL,"youtube")) { ;if the current tab is youtube then youtube incorrectly has tab elements in its page breaking selectTab
        try { ;SelectTab has a tendency to fail, should be replaced
            browserObject.SelectTab("YouTube",matchMode := 2,caseSensitive:=false) ;Look for YouTube in the title
            sleep 400 ; Bigger sleep as switching tabs takes time to process unfortunately
        }
        catch error as e {
            MsgBox "Could not select youtube tab :" . e.Message
        }
    }
    else {
        sleep 50 ;small sleep to give chance to read URL
    }

}

YTSeek(browser := YTlibrary_Chrome, direction := "forward"){
    currentWindow:=WinExist("A")
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
    WinActivate(currentWindow)
}

YTGoTo(browser := YTlibrary_Chrome, n := 0) { ;Goes back to beginning by default
    currentWindow:=WinExist("A")
    YTActivateYouTube(browser)
    try {
        playBUtton := browser.ElementExist({ClassName:"ytp-play-button ytp-button"})
        if(playBUtton){
            playBUtton.SetFocus()
            Send("" . n)
        }
       
    }
    
    catch error as e{
        MsgBox "Method YTGoTo failed: " . e.Message
    }
    WinActivate(currentWindow)
}

YTChangeVolume(fixedSetting := 200, browser := YTlibrary_Chrome, increment := 10.0) {

    try {
        currentWindow:=WinExist("A")
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
                     flyOut("Youtube Volume: " . Integer(newVolume),1000,"bottom")
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
        WinActivate(currentWindow)
     
    }

YTPlayPause(browser := YTlibrary_Chrome) {
    
        YTActivateYouTube(browser)
        
        try {
            playBUtton := browser.ElementExist({ClassName:"ytp-play-button ytp-button"})
            if(playBUtton){
                playBUtton.Click()
            }
           
        }
        catch error as e{
            MsgBox "Could not play/pas YT :" e.Message
        }
    }
    
    
    
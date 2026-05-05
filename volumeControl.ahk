#include converters.ahk
#include notifications.ahk

global svv := "C:\svol\svcl.exe"
global soundOptions := ["Headphones", "Realtek", "Chrome.exe", "Firefox.exe", "DefaultRenderDevice"]
global soundOptionIndex := 1

reportAllVolumes() {
    global soundOptionIndex
    global soundOptions
    reportString := ""
    for index, item in soundOptions {
        reportString .= " " . getVolume(item) . " : " . item . "`n"

    }
    flyOut(reportString, 5000, "top", 1, true)

}

+NumpadEnter:: reportAllVolumes()
GetVolume(application := "chrome.exe") {


    ; 1. Clear clipboard to ensure we catch the new value
    A_Clipboard := ""

    ; 2. Run SoundVolumeView and pipe the specific column (Volume Percent) to the clipboard
    ; /GetColumnValue syntax: "Item Name/Process" "Column Name"
    RunWait(A_ComSpec ' /c ' svv ' /GetColumnValue "' application '" "Volume Percent" | clip', , "Hide")

    ; 3. Wait up to 1 second for the clipboard to receive the data
    if ClipWait(1) {
        appVol := Trim(A_Clipboard, "`n ") ; Clean up any trailing line breaks
        appVol := SubStr(appVol, 1, 4)
        appVols := StrSplit(appvol, ".")
        numVol := round(appVols[1])
        return numVol
    } else {
        FlyOut("Failed to get volume for " application)
        return -1
    }
}

cycleSoundOptions() {
    global soundOptions
    global soundOptionIndex
    currentItem := soundOptions[soundOptionIndex]
    newIndex := cycleArrayIndex(soundOptions, soundOptionIndex, 1)
    newItem := soundOptions[newIndex]
    soundOptionIndex := newIndex
    flyOut("Volume being set for: " newitem, 2500)
}

changeDeviceVolumeWith(n) {
    global soundOptionIndex
    global soundOptions
    deviceToUpdate := soundOptions[soundOptionIndex]
    command := svv ' /ChangeVolume ' deviceToUpdate ' ' n ''
    Run(command, , "Hide")
    sleep 100
    newVolume := GetVolume(deviceToUpdate)
    FlyOut(deviceToUpdate " Volume: " newVolume . "`%", 1000, "bottom")
}
NumpadEnter:: {
    cycleSoundOptions()
}
NumpadDot & NumpadAdd:: {
    changeDeviceVolumeWith(10)
}
NumpadDot & NumpadSub:: {
    changeDeviceVolumeWith(-10)
}
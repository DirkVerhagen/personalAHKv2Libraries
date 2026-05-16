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

cycleSoundOptions(shift := 1) {
    global soundOptions
    global soundOptionIndex
    newIndex := cycleArrayIndex(soundOptions, soundOptionIndex, shift)
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

AppVol(Target := "A", Level := 0) {
    ; We could use SVV for this but this is for educational purposes
    if (Target ~= "^[-+]?\d+$") {
        Level := Target
        Target := "A"
    } else if (SubStr(Target, -4) = ".exe") {
        Target := "ahk_exe " Target
    }
    try {
        hw := DetectHiddenWindows(true)
        appName := WinGetProcessName(Target)
        DetectHiddenWindows(hw)
    } catch {
        throw TargetError("Target not found.", -1, Target)
    }
    GUID := Buffer(16)
    DllCall("ole32\CLSIDFromString", "Str", "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}", "Ptr", GUID)
    IMMDeviceEnumerator := ComObject("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")
    ComCall(4, IMMDeviceEnumerator, "UInt", 0, "UInt", 1, "Ptr*", &IMMDevice := 0)
    ObjRelease(IMMDeviceEnumerator.Ptr)
    ComCall(3, IMMDevice, "Ptr", GUID, "UInt", 23, "Ptr", 0, "Ptr*", &IAudioSessionManager2 := 0)
    ObjRelease(IMMDevice)
    ComCall(5, IAudioSessionManager2, "Ptr*", &IAudioSessionEnumerator := 0) || DllCall("SetLastError", "UInt", 0)
    ObjRelease(IAudioSessionManager2)
    ComCall(3, IAudioSessionEnumerator, "UInt*", &cSessions := 0)
    loop cSessions {
        ComCall(4, IAudioSessionEnumerator, "Int", A_Index - 1, "Ptr*", &IAudioSessionControl := 0)
        IAudioSessionControl2 := ComObjQuery(IAudioSessionControl, "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}")
        ObjRelease(IAudioSessionControl)
        ComCall(14, IAudioSessionControl2, "UInt*", &pid := 0)
        if (!ProcessExist(pid) or ProcessGetName(pid) != appName) {
            continue
        }
        ISimpleAudioVolume := ComObjQuery(IAudioSessionControl2, "{87CE5498-68D6-44E5-9215-6DA47EF883D8}")
        ComCall(6, ISimpleAudioVolume, "Int*", &isMuted := 0)
        if (isMuted || !Level) {
            ComCall(5, ISimpleAudioVolume, "Int", !isMuted, "Ptr", 0)
        }
        if (Level) {
            ComCall(4, ISimpleAudioVolume, "Float*", &levelOld := 0)
            if (Level ~= "^[-+]") {
                levelNew := Max(0.0, Min(1.0, levelOld + (Level / 100)))
            } else {
                levelNew := Level / 100
            }
            if (levelNew != levelOld) {
                ComCall(3, ISimpleAudioVolume, "Float", levelNew, "Ptr", 0)
            }
        }
        ObjRelease(ISimpleAudioVolume.Ptr)
    }
    return (IsSet(levelOld) ? Round(levelOld * 100) : -1)
}
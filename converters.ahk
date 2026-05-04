

secondsToTimeString(seconds) {
    hours := Floor(seconds / 3600)
    minutes := Floor(Mod(seconds, 3600) / 60)
    seconds := Mod(seconds, 60)

    
    if(seconds < 1) {
        return "No time!"
    }

    if(hours < 1)
        formattedTime := Format("{:02}:{:02}", minutes, seconds) . ""
    else if(hours < 1 and minutes < 1)
        formattedTime := Format("{:02}", seconds) . ""
    else
        formattedTime := Format("{:02}:{:02}:{:02}", hours, minutes, seconds) . ""

    return formattedTime
}

convertShortStringToSeconds(str) {
    if !RegExMatch(str, "(\d+:[\d:]+)", &match)
        return 0
    
    parts := StrSplit(match[1], ":")
    seconds := 0
    
    if (parts.Length == 3) { ; H:MM:SS
        seconds += parts[1] * 3600 ; Uren
        seconds += parts[2] * 60   ; Minuten
        seconds += parts[3]        ; Seconden
    } else if (parts.Length == 2) { ; MM:SS
        seconds += parts[1] * 60   ; Minuten
        seconds += parts[2]        ; Seconden
    }
    
    return seconds
}

convertLongTimeStringToSeconds(str)  {
    totalSec := 0
    
    ; We look at the part after " of " to get the total duration
    if RegExMatch(str, "of (.*)", &match) {
        durationPart := match[1]
        
        ; Extract Hours
        if RegExMatch(durationPart, "(\d+) hour", &h)
            totalSec += h[1] * 3600
            
        ; Extract Minutes
        if RegExMatch(durationPart, "(\d+) minute", &m)
            totalSec += m[1] * 60
            
        ; Extract Seconds
        if RegExMatch(durationPart, "(\d+) second", &s)
            totalSec += s[1]
    }
    else {
        return 0
    }
    
    return totalSec
}

#SuspendExempt true
BoolToStr(val) => val ? "true" : "false"
BoolToEnDisStr(val) => val ? "Enabled" : "Disabled"
BoolToRunSuspendStr(val) => val ? "Running" : "Suspended"
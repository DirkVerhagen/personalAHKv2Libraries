/************************************************************************
 * @description 
 * @author 
 * @date 2026/05/19
 * @version 0.0.0
 ***********************************************************************/

/**
 * 
 * @param seconds total number of seconds
 * @returns {String} Outputs a string formatted as hh:mm:ss (or mm:ss or ss)
 */
secondsToTimeString(seconds) {
    hours := Floor(seconds / 3600)
    minutes := Floor(Mod(seconds, 3600) / 60)
    newSeconds := Floor(Mod(seconds, 60))


    if (seconds < 1) {
        return "No time!"
    }

    if (hours < 1)
        formattedTime := Format("{:02d}:{:02d}", minutes, newSeconds)
    else
        formattedTime := Format("{:02d}:{:02d}:{:02d}", hours, minutes, newSeconds)


    return formattedTime
}
/**
 * Given a string in hh:mm:ss format this function returns the number of seconds
 * @param str A time string in the format hh:mm:ss
 * @returns {Integer} The number of seconds this string represents
 */
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
    } else if (parts.Length == 1) { ; SS
        seconds += parts[1]
    }
    else { ;not able to split the string
        return -1
    }

    return seconds
}

convertLongTimeStringToSeconds(str) {
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

cycleArrayIndex(collection, index, increment := 1) {
    i := index
    i := i + increment
    i += collection.Length
    i := Mod(i - 1, collection.Length) + 1

    return i
}
getNextCycleItem(collection, currentindex) {
    newIndex := cycleArrayIndex(collection, currentindex)

    return collection[newIndex]
}
arrayIndexToMultiSelectString(index, items, cycling := false) {
    output := ""
    if (cycling)
        output .= "< "
    for i, item in items {
        ;; add to the string
        if (i == index) {
            output .= " [" . StrUpper(items[i]) . "]"
        }
        else {
            output .= " " . items[i]
        }
    }
    if (cycling)
        output .= " >"
    return output
}
arrayIndexToCarousselString(index, items) {

    mainItem := items[index]

    leftItemIndex := Mod(index - 2 + items.Length, items.Length) + 1 ; we pretend arrays start at 1 for ahk's sake
    rightItemIndex := Mod(Index, items.Length) + 1
    leftItem := items[leftItemIndex]
    rightItem := items[rightItemIndex]

    carousselString := leftItem . " [" . StrUpper(mainItem) . "] " . rightItem
    return carousselString
}

TimeToSecs(timeString) { ; MIGHT BE DUPLICATE OF CONVERTSHORT....
    ; Removes spaces and other things to keep an TT:TT:[TT] format
    timeString := RegExReplace(timeString, "[^\d:]")
    parts := StrSplit(timeString, ":")

    seconds := 0
    if (parts.Length = 2) { ; MM:SS
        seconds := (Integer(parts[1]) * 60) + Integer(parts[2])
    }
    else if (parts.Length = 3) { ; HH:MM:SS
        seconds := (Integer(parts[1]) * 3600) + (Integer(parts[2]) * 60) + Integer(parts[3])
    }

    return seconds
}
IndexOf(Arr, Value) {
    for i, v in Arr
        if (v = Value)
            return i
    return 0 ; Returns 0 if not found
}
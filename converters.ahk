

secondsToTimeString(seconds) {
    hours := Floor(seconds / 3600)
    minutes := Floor(Mod(seconds, 3600) / 60)
    seconds := Mod(seconds, 60)

    
    if(seconds < 1) {
        return "No time left"
    }

    if(hours < 1)
        formattedTime := Format("{:02}:{:02}" . "", minutes, seconds)
    else if(hours < 1 and minutes < 1)
        formattedTime := Format("{:02}" . "", seconds)
    else
        formattedTime := Format("{:02}:{:02}:{:02}" . "", hours, minutes, seconds)

    return formattedTime
}
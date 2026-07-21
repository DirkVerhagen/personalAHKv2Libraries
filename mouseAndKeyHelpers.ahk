#include notifications.ahk
InstallMouseHook()
InstallKeybdHook()


SmoothScrollDown(n := 3) {
    Critical
    Loop n {
        SendEvent("{WheelDown}")
        Sleep(30)
    }
}
SmoothScrollUp(n := 3) {
    Critical
    Loop n {
        SendEvent("{WheelUp}")
        Sleep(30)
    }
}
keyTimes(key, n) {
    loop n {
        Send("{" key "}")
        sleep 30
    }
}
screenMiddleClick(offsetX := 0, offsetY := 0) {

    MouseMove((A_ScreenWidth / 2) + offsetX, (A_ScreenHeight / 2) + offsetY, 0)
    Click()

}
screenMiddleMove(offsetX := 0, offsetY := 0) {
    MouseMove((A_ScreenWidth / 2) + offsetX, (A_ScreenHeight / 2) + offsetY, 0)
}
mouseReturnPosition(fun) {
    MouseGetPos(&mx, &my)
    fun()
    MouseMove(mx, my, 0)
}

global toWiggle := A_TrayMenu
stopWiggle() {
    global toWiggle
    toWiggle := false
}

startWiggle() {
    global toWiggle
    toWiggle := true
}
mouseWiggle(times := 1, pixels := 1) {
    global toWiggle
    ; don't wiggle if someone is using their mouse
    if (A_TimeIdleMouse < 70) {
        return

    }
    if (!toWiggle)
        return
    loop times {
        MouseMove(-1 * pixels, -1 * pixels, 5, "R")
        MouseMove(1 * pixels, 1 * pixels, 5, "R")
    }

}
MouseLeft(n := 50, speed := 2) {
    MouseMove(-n, 0, speed, "R")
}
MouseRight(n := 50, speed := 2) {
    MouseMove(n, 0, speed, "R")
}
MouseUp(n := 50, speed := 2) {
    MouseMove(0, -n, speed, "R")
}
MouseDown(n := 50, speed := 2) {
    MouseMove(0, n, speed, "R")
}
mouseDoubleClick() {
    stopWiggle()
    Click()
    sleep 50
    Click()
    startWiggle()
}
isMouseNear(x, y, mode := A_CoordModeMouse) {
    currentCoordMode := A_CoordModeMouse
    CoordMode("Mouse", mode)
    MouseGetPos(&mx, &my)
    isNear := false
    if (mx < x + 10 and mx > x - 10 and my > y - 10 and my < y + 10)
        isNear := true
    else
        isNear := false
    CoordMode("Mouse", currentCoordMode)
    return isNear
}
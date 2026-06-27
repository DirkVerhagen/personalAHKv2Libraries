#include notifications.ahk
InstallMouseHook()
InstallKeybdHook()


SmoothScrollDown(n := 3) {
    Loop n {
        SendEvent("{WheelDown}")
        Sleep(40)
    }
}
SmoothScrollUp(n := 3) {
    Loop n {
        SendEvent("{WheelUp}")
        Sleep(40)
    }
}
keyTimes(key, n) {
    loop n {
        Send("{" key "}")
        sleep 30
    }
}
screenMiddleClick() {
    currentCoordMode := A_CoordModeMouse
    CoordMode("Mouse", "Screen")
    MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2, 1)
    Click()
    CoordMode("Mouse", currentCoordMode)
}
screenMiddleMove() {
    currentCoordMode := A_CoordModeMouse
    CoordMode("Mouse", "Screen")
    MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
    CoordMode("Mouse", currentCoordMode)
}
keepWiggling(n := 1) {
    sleep 100 ;allow time for A_TimeIdlePhysical to accumulate)
    while (A_TimeIdlePhysical > 50) {
        mouseWiggle(n)
        sleep 500 ; wiggle 2 times a second
    }
}
mouseWiggle(n := 1) {
    MouseMove(-2 * n, -2 * n, 1, "R")
    MouseMove(2 * n, 2 * n, 1, "R")
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
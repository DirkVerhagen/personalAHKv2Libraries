/************************************************************************
 * @description Library that you can use to create a colored border and have it blink
 * @author 
 * @date 2026/05/10
 * @version 0.0.0
 ***********************************************************************/

/**
 * 
 * @returns Constructor which creates a border with a BackColor as border color. 
 */
BorderGui_Constructor() {
    global borderGui
    t := 10
    borderColor := "7cf28a"

    borderGui := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale +E0x20")
    borderGui.BackColor := borderColor

    ;cut a hole out of the region
    WinSetRegion("0-0 " A_ScreenWidth "-0 " A_ScreenWidth "-" A_ScreenHeight " 0-" A_ScreenHeight " 0-0 " .
        t "-" t " " (A_ScreenWidth - t) "-" t " " (A_ScreenWidth - t) "-" (A_ScreenHeight - t) " " t "-" (A_ScreenHeight - t) " " t "-" t, borderGui)

    return borderGui
}

/**
 * 
 * @param {Integer} n Blink the border N times
 * @param {Color} alertColor The color used to blink. It will toggle between its current color and the alertcolor
 */
borderBlinkAlert(n := 3, alertColor := "ff0000") {
    global borderGui

    currentColor := borderGui.BackColor
    loop n {
        borderGui.BackColor := alertColor
        sleep 500
        borderGui.BackColor := currentColor
        sleep 500
    }

}
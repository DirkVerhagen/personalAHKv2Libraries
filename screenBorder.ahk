/************************************************************************
 * @description Library that you can use to create a colored border and have it blink
 * @author 
 * @date 2026/05/10
 * @version 0.0.0
 ***********************************************************************/

/**
 * 
 * @returns A gui that puts a border around your screen and leaves a hole in the middle
 */
BorderGui_Constructor() {
    global borderGui
    t := 8
    borderColor := "3f8b48"

    borderGui := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale +E0x20")
    borderGui.BackColor := borderColor
    borderGui.Show("Hide")
    ;cut a hole out of the region
    WinSetRegion("0-0 " A_ScreenWidth "-0 " A_ScreenWidth "-" A_ScreenHeight " 0-" A_ScreenHeight " 0-0 " t "-" t " " (A_ScreenWidth - t) "-" t " " (A_ScreenWidth - t) "-" (A_ScreenHeight - t) " " t "-" (A_ScreenHeight - t) " " t "-" t, borderGui)

    return borderGui
}

GeneralBorder_Constructor(width, height, thickness, color) {
    t := thickness
    borderColor := color

    rectangleGui := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale +E0x20")
    rectangleGui.BackColor := borderColor
    ; force a hwnd on this window
    rectangleGui.Show("Hide")
    ;cut a hole out of the region
    WinSetRegion("0-0 " width "-0 " width "-" height " 0-" height " 0-0 " t "-" t " " (width - t) "-" t " " (width - t) "-" (height - t) " " t "-" (height - t) " " t "-" t, rectangleGui)

    return rectangleGui
}

/**
 * This will block the UI for n * 1 second, use SetTimer to avoid.
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
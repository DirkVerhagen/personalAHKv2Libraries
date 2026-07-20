/************************************************************************
 * @description Library that you can use to create a colored border and have it blink
 * @author 
 * @date 2026/05/10
 * @version 0.0.0
 ***********************************************************************/

global MonitorOneLTRBCoords := [0, 0, 0, 0]
global MonitorTwoLTRBCoords := [0, 0, 0, 0]
global MonitorOne := { Width: 0, Height: 1 }
global MonitorTwo := { Width: 0, Height: 1 }
loop MonitorGetCount() {
    MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
    if (A_Index == 2) { ; What we refer to as mon 1 is actually monitor 2 in AHK (and windows)
        MonitorOne := { Width: Right - Left, Height: Bottom - Top }
        MonitorOneLengthHeight := [(Right - Left), (Bottom - Top)]
    }
    else if (A_Index == 1) {
        MonitorTwoLTRBCoords := [Left, Top, Right, Bottom]
        MonitorTwo := { Width: Right - Left, Height: Bottom - Top }
        coordstring := MonitorTwoLTRBCoords[1] . "," . MonitorTwoLTRBCoords[2] . "," . MonitorTwoLTRBCoords[3] . "," . MonitorTwoLTRBCoords[4] . " - " . MonitorTwo.Width . "," . MonitorTwo.Height
        ;MsgBox(coordstring)
    }

}

/**
 * 
 * @returns A gui that puts a border around your screen and leaves a hole in the middle
 */


BorderGui_Constructor(thickness := 8, screen := 1, borderColor := "3f8b48") {
    t := thickness


    thisBorder := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale +E0x20")
    thisBorder.BackColor := borderColor
    thisBorder.Show("Hide")
    thisBorder.borderScreen := screen
    ;cut a hole out of the region
    switch screen {
        case 1:
            WinSetRegion("0-0 " A_ScreenWidth "-0 " A_ScreenWidth "-" A_ScreenHeight " 0-" A_ScreenHeight " 0-0 " t "-" t " " (A_ScreenWidth - t) "-" t " " (A_ScreenWidth - t) "-" (A_ScreenHeight - t) " " t "-" (A_ScreenHeight - t) " " t "-" t, thisBorder)
        case 2:
            WinSetRegion("0-0 " MonitorTwo.Width "-0 " MonitorTwo.Width "-" MonitorTwo.Height " 0-" MonitorTwo.Height " 0-0 " t "-" t " " (MonitorTwo.Width - t) "-" t " " (MonitorTwo.Width - t) "-" (MonitorTwo.Height - t) " " t "-" (MonitorTwo.Height - t) " " t "-" t, thisBorder)
        case 0:
        default:
            WinSetRegion("0-0 " A_ScreenWidth "-0 " A_ScreenWidth "-" A_ScreenHeight " 0-" A_ScreenHeight " 0-0 " t "-" t " " (A_ScreenWidth - t) "-" t " " (A_ScreenWidth - t) "-" (A_ScreenHeight - t) " " t "-" (A_ScreenHeight - t) " " t "-" t, thisBorder)
    }
    thisBorder.DefineProp("borderBlink", { Call: Blink })
    thisBorder.DefineProp("borderToggle", { Call: toggle })
    thisBorder.DefineProp("borderNewColor", { Call: updateColor })

    Blink(alertColor := "DD0000", n := 2, *) {
        loop n {
            thisBorder.BackColor := alertColor
            sleep 500
            thisBorder.BackColor := borderColor
            sleep 500
        }
    }

    updateColor(newColor := "0000AA", *) {
        toggle("off")
        MsgBox(newColor)
        thisBorder.BackColor := newColor
        toggle("on")
    }

    toggle(state := "toggle", *) {
        if (state == "toggle") {
            if (WinExist("ahk_id " thisBorder.Hwnd))
                isVisible := true
            else
                isVisible := false
            isVisible := !isVisible
        }
        else if (state == "on") {
            isVisible := false
        }
        else {
            isVisible := true
        }
        if (isVisible)
            switch screen {
                case 1:
                    thisBorder.Show("noActivate x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)
                case 2:
                    thisBorder.Show("noActivate x" MonitorTwoLTRBCoords[1] " y" MonitorTwoLTRBCoords[2] " w" MonitorTwo.Width " h" MonitorTwo.Height)
            }
        else {
            thisBorder.Show("Hide")
        }
    }

    return thisBorder
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
borderBlinkAlert(borderGui, n := 3, alertColor := "ff0000") {

    currentColor := borderGui.BackColor
    loop n {
        borderGui.BackColor := alertColor
        sleep 500
        borderGui.BackColor := currentColor
        sleep 500
    }

}

setBorderColor(borderGui, color := "ff0000") {
    borderGui.BackColor := color
}
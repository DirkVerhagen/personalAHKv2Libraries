#Requires AutoHotkey v2.0
global MonitorOneLTRBCoords := [0, 0, 0, 0]
global MonitorTwoLTRBCoords := [0, 0, 0, 0]
global MonitorOneLengthHeight := [0, 0]
global MonitorTwoLengthHeight := [0, 0]
global ProgressWidth := 0
loop MonitorGetCount() {
    MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
    if (A_Index == 2) { ; What we refer to as mon 1 is actually monitor 2 in AHK (and windows)
        MonitorOneLTRBCoords := [Left, Top, Right, Bottom]
        MonitorOneLengthHeight := [(Right - Left), (Bottom - Top)]
    }
    else if (A_Index == 1) {
        MonitorTwoLTRBCoords := [Left, Top, Right, Bottom]
        MonitorTwoLengthHeight := [(Right - Left), (Bottom - Top)]
        coordstring := MonitorTwoLTRBCoords[1] . "," . MonitorTwoLTRBCoords[2] . "," . MonitorTwoLTRBCoords[3] . "," . MonitorTwoLTRBCoords[4] . " - " . MonitorTwoLengthHeight[1] . "," . MonitorTwoLengthHeight[2]
    }

}

infoPanel(content := "content", side := "left", keyToToggle := "") {
    if (isSet(infoPanel)) {
        textItem := infoPanel["contenttext"]
        textItem.value := content
    }
    else {
        static infoPanel := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner")
        infoPanel.BackColor := "333333"
        infoPanel.SetFont("cWhite s14", "Segoe UI")
        panelContent := infoPanel.Add("Text", "vcontenttext", content)
        WinSetTransparent(200, infoPanel)
        panelClicked(*) {
            infoPanel.Hide()
        }
    }


    switch side {
        case "left":
            posX := 50
        case "right":
            posX := 3100
    }

    if (keyToToggle != "") {
        Hotkey(keyToToggle, toggleAction)
    }
    static activeWindow := WinGetPID("A")
    toggleAction(key) {
        static isVisible := true
        if (WinActive("ahk_pid " activeWindow)) {
            isVisible := !isVisible
            if (isVisible)
                infoPanel.Hide()
            if (!isVisible)
                infoPanel.Show("x" posX "y100 w300 NoActivate")
        }
        else {
            SendEvent("{" key "}")
        }

    }

    infoPanel.Show("x" posX "y100 w300 NoActivate")
    infoPanel.OnEvent("ContextMenu", panelClicked)

}

flyOut(text := "This is a flyout", duration := 1000, position := "center", screen := 1, sidebar := false, value := 100) {
    ; Create GUI
    positionLowerCase := StrLower(position)
    FlyOut1 := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner")
    FlyOut1.BackColor := "333333"
    FlyOut1.SetFont("cWhite s14", "Segoe UI")
    FlyOut1.Add("Text", "Section", "`n" text "`n")
    FlyOut1.GetClientPos(, , &myFlyOutWidth,)
    FlyOut1.MarginY := 0
    progressBar := FlyOut1.add("Text", "Section x0 w" myFlyOutWidth " h5 Backgrounddab327")
    progressBar.progress := 100
    /*     FlyOut1.OnEvent("Size", FlyOut1Resize)
        FlyOut1Resize(GuiObj, MinMax, Width, Height) {
            progressBar.Move(, , width)
    } */
    WinSetTransparent(200, FlyOut1)
    monitorTwoX := 400 ; ensure it's always set
    if (screen == 0) {
        FlyOut2 := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner")
        FlyOut2.BackColor := "333333"
        FlyOut2.SetFont("cWhite s14", "Segoe UI")
        FlyOut2.Add("Text", , text)

        WinSetTransparent(200, FlyOut2)
    }
    else {
        if (!sideBar)
            monitorTwoX := A_ScreenWidth + 300
        else MonitorTwoX := A_ScreenWidth + 30
    }

    ; determine coordinates for first screen
    if (sideBar) {
        monitorOneX := 30
    }
    else {
        monitorOneX := (A_ScreenWidth / 2) - (myFlyOutWidth / 2)
    }

    ;The Y position we can get from the bottom and top coords rather than in this complicated manner
    ;MonitorTwoY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)

    if (positionLowerCase == "top")
        switch screen {
            case 1:
                posX := monitorOneX
                posY := 100
            case 2:
                posX := monitorTwoX
                posY := MonitorTwoLTRBCoords[1] + 100
            case 0:
                Screen1posX := monitorOneX
                Screen1posY := 100
                Screen2posX := monitorTwoX
                Screen2posY := MonitorTwoLTRBCoords[1] + 100
        }
    else if (positionLowerCase == "center")
        switch screen {
            case 1:
                posX := monitorOneX
                posY := A_ScreenHeight / 2
            case 2:
                posX := monitorTwoX
                posY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2] / 2)
            case 0:
                Screen1posX := monitorOneX
                Screen1posY := A_ScreenHeight / 2
                Screen2posX := monitorTwoX
                Screen2posY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2] / 2)
        }
    else if (positionLowerCase == "bottom")
        switch screen {
            case 1:
                posX := monitorOneX
                posY := A_ScreenHeight - 100
            case 2:
                posX := monitorTwoX
                posY := MonitorTwoLTRBCoords[4] - 100
            case 0:
                Screen1posX := monitorOneX
                Screen1posY := A_ScreenHeight - 100
                Screen2posX := monitorTwoX
                Screen2posY := MonitorTwoLTRBCoords[4] - 100
        }
    else {
        MsgBox "invalid position received"
        posX := 100
        posY := 100
    }

    ; Show the GUI, but do not activate it / set focus
    switch screen {
        case 1:
            FlyOut1.Show("x" monitorOneX " y" posY " NoActivate")
            FlyOut1.GetClientPos(, , &flyOut1Width)
            progressBar.Move(, , flyOut1Width)
        case 2:
            FlyOut1.Show("x" (posX) " y" posY " NoActivate")
            FlyOut1.GetClientPos(, , &flyOut1Width)
            monitorTwoX := (A_ScreenWidth + (MonitorTwoLengthHeight[1] / 2)) - (flyOut1Width / 2)
            FlyOut1.Move(monitorTwoX)
        case 0:
            FlyOut1.Show("x" monitorOneX " y" Screen1posY " NoActivate")
            FlyOut2.Show("x" (Screen2posX) " y" Screen2posY " NoActivate")
            FlyOut1.GetClientPos(, , &flyOut1Width)
            monitorTwoX := (A_ScreenWidth + (MonitorTwoLengthHeight[1] / 2)) - (flyOut1Width / 2)
            FlyOut1.Move(monitorTwoX)

    }
    ; timer to remove it again

    FlyOut1.GetClientPos(, , &initialWidth)
    if (duration > 4000) {
        steps := 20
        progressbarUpdateTime := duration / steps
        progressbar.progress := 100
        stepSize := Round(100 / steps)
        setTimer(ShrinkProgressBar, progressbarUpdateTime)
    }
    else {
        progressBar.progress := value
        progressBar.Move(, , (progressbar.progress / 100) * initialWidth)
    }
    ShrinkProgressBar() {
        if (progressbar.progress <= stepSize) {
            setTimer ShrinkProgressBar, 0
        }
        else {
            progressbar.progress := progressbar.progress - stepSize
            progressBar.Move(, , (progressbar.progress / 100) * initialWidth)
        }
    }
    SetTimer(HideFlyout.Bind(FlyOut1), -duration)
    SetTimer(stopProgressbar, -duration)
    stopProgressbar() {
        SetTimer(ShrinkProgressBar, 0)
    }
    if (Screen == 0)
        SetTimer(HideFlyout.Bind(FlyOut2), -duration)
}

HideFlyout(guiObj) {
    guiObj.Destroy()
}
#Requires AutoHotkey v2.0
global MonitorOneLTRBCoords := [0,0,0,0]
global MonitorTwoLTRBCoords := [0,0,0,0]
global MonitorOneLengthHeight := [0,0]
global MonitorTwoLengthHeight := [0,0]
loop MonitorGetCount() {
    MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
    if(A_Index == 2) { ; What we refer to as mon 1 is actually monitor 2 in AHK (and windows)
        MonitorOneLTRBCoords := [Left,Top,Right,Bottom]
        MonitorOneLengthHeight := [(Right-Left),(Bottom-Top)]
    }
    else if(A_Index == 1){
        MonitorTwoLTRBCoords := [Left,Top,Right,Bottom]
        MonitorTwoLengthHeight := [(Right-Left),(Bottom-Top)]
        coordstring := MonitorTwoLTRBCoords[1] . "," . MonitorTwoLTRBCoords[2] . "," . MonitorTwoLTRBCoords[3] . "," . MonitorTwoLTRBCoords[4] . " - " . MonitorTwoLengthHeight[1] . "," . MonitorTwoLengthHeight[2]
    }

}


flyOut(text := "This is a flyout", duration := 1000, position := "center", screen := 1, sidebar := false) {
    ; Create GUI
    positionLowerCase := StrLower(position)
    MyFlyout := Gui("+MaxSize300x +AlwaysOnTop -Caption +ToolWindow +Owner +MaxSize500x")
    MyFlyout.BackColor := "333333"
    MyFlyout.SetFont("cWhite s14", "Segoe UI")
    MyFlyout.Add("Text",, text)
    MyFlyout.GetClientPos(,,&myFlyOutWidth,)
    WinSetTransparent(200,MyFlyout)
    if(screen == 0){
        secondFlyout := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner +MaxSize500x")
        secondFlyout.BackColor := "333333"
        secondFlyout.SetFont("cWhite s14", "Segoe UI")
        secondFlyout.Add("Text",, text)
        secondFlyout.GetClientPos(,,&secondFlyOutWidth,)
        monitorTwoX := (A_ScreenWidth + (MonitorTwoLengthHeight[1] / 2))-(secondFlyOutWidth/2)
        WinSetTransparent(200,secondFlyout)
    }
    else {
        if(!sideBar)
            monitorTwoX := A_ScreenWidth + 300
        else MonitorTwoX := A_ScreenWidth + 30
    }

    ; determine coordinates for first screen
    if(sideBar) {
        monitorOneX := 30
    }
    else {
        monitorOneX := (A_ScreenWidth/2) - (myFlyOutWidth / 2)
    }
    
    ;The Y position we can get from the bottom and top coords rather than in this complicated manner
    ;MonitorTwoY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)

    if(positionLowerCase =="top")
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

    else if(positionLowerCase == "center")
        switch screen {
            case 1: 
                posX := monitorOneX
                posY := A_ScreenHeight/2
            case 2: 
                posX := monitorTwoX  
                posY :=  MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)
            case 0:
                Screen1posX := monitorOneX
                Screen1posY := A_ScreenHeight/2
                Screen2posX := monitorTwoX  
                Screen2posY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)
        }
    else if(positionLowerCase == "bottom")
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
            MyFlyout.Show("x" monitorOneX " y" posY " NoActivate")
        case 2:
            MyFlyout.Show("x" (posX) " y" posY " NoActivate")
        case 0: 
            MyFlyout.Show("x" monitorOneX " y" Screen1posY " NoActivate")
            secondFlyOut.Show("x" (Screen2posX) " y" Screen2posY " NoActivate")
    
    }
    ; timer to remove it again
    SetTimer(HideFlyout.Bind(MyFlyout), -duration)
    if(Screen == 0)
        SetTimer(HideFlyout.Bind(secondFlyOut), -duration)
}

HideFlyout(guiObj) {
    guiObj.Destroy()
}
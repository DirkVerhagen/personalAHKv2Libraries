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
        flyOut(coordstring,5000,"center",2)
    }

}


flyOut(text := "This is a flyout", duration := 1000, position := "center", screen := 1) {
    ; Create GUI
    static MyFlyout

    positionLowerCase := StrLower(position)
    MyFlyout := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner")
    MyFlyout.BackColor := "333333"
    MyFlyout.SetFont("cWhite s12", "Segoe UI")
    MyFlyout.Add("Text",, text)

    ; Detect coordinates for x screens
    
    monitorTwoX := (A_ScreenWidth + (MonitorTwoLengthHeight[1] / 2))
    MonitorTwoY := MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)
    ;Msgbox "x: " . monitorTwoX . " y: " . MonitorTwoY
    if(positionLowerCase =="top")
        switch screen {
        case 1:
            posX := A_ScreenWidth/2 - 75
            posY := 100
        case 2:
            posX := monitorTwoX
            posY := MonitorTwoLTRBCoords[1] + 100 
        }
    else if(positionLowerCase == "center")
        switch screen {
            case 1: 
                posX := A_ScreenWidth/2 - 75   
                posY := A_ScreenHeight/2
            case 2: 
                posX := monitorTwoX  
                posY :=  MonitorTwoLTRBCoords[2] + (MonitorTwoLengthHeight[2]/2)
        }
    else if(positionLowerCase == "bottom")
        switch screen {
            case 1: 
                posX := A_ScreenWidth/2 - 75   
                posY := A_ScreenHeight - 100
            case 2:
                posX := monitorTwoX  
                posY := MonitorTwoLTRBCoords[4] - 100
        }
    else {
        MsgBox "invalid position received"
        posX := 100
        posY := 100
    }
    
    ; Show the GUI, but do not activate it / set focus
    switch screen {
        case 1:
            MyFlyout.Show("xCenter y" posY " NoActivate")
        case 2:
            MyFlyout.Show("x" (posX) " y" posY " NoActivate")
    
    }
    ; timer to remove it again
    SetTimer(HideFlyout.Bind(MyFlyout), -duration)
}

HideFlyout(guiObj) {
    guiObj.Destroy()
}
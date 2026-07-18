#Include ..\..\Lib\ColorButton.ahk
#include ..\..\Lib\personal\notifications.ahk

activeWindowWrapper(function) {
    LastHwnd := WinExist("A")
    returnValue := function() ;basically we want the function to finish executing
    sleep 200 ; give function some time to finish in case there are UI actions
    WinActivate("ahk_id " . LastHwnd)
    WinWaitActive("ahk_id " . LastHwnd)
}

GetMonitorFromHwnd(hwnd) {
    ; 1. Get the handle of the monitor the window is mostly on (0x2 = MONITOR_DEFAULTTONEAREST)
    hMonitor := DllCall("MonitorFromWindow", "Ptr", hwnd, "UInt", 0x2, "Ptr")

    ; 2. Initialize a buffer to hold the monitor information (40 bytes)
    monitorInfo := Buffer(40, 0)
    NumPut("UInt", 40, monitorInfo) ; cbSize member of MONITORINFO struct

    ; 3. Retrieve the monitor details
    if DllCall("GetMonitorInfo", "Ptr", hMonitor, "Ptr", monitorInfo) {
        ; Extract the screen coordinates (bounding rectangle) of this monitor
        mLeft := NumGet(monitorInfo, 4, "Int")
        mTop := NumGet(monitorInfo, 8, "Int")
        mRight := NumGet(monitorInfo, 12, "Int")
        mBottom := NumGet(monitorInfo, 16, "Int")

        ; 4. Match these coordinates to AHK's monitor list to get the actual monitor number
        Loop MonitorGetCount() {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (mLeft == Left && mTop == Top && mRight == Right && mBottom == Bottom) {
                return A_Index
            }
        }
    }

    return MonitorGetPrimary() ; Fallback to primary monitor if anything fails
}

/**
 * Creates a window with 4 editboxes that you can use to test a function. The window will run the function with 4 parameters as specified and show the returned result if possible
 * @param funObj A function object. If it needs parameters with types that can't be typed or displayed this won't work.
 * @returns {Gui} Returns a gui object to test your function
 */
functionTestWindow(funObj) {
    ; Create the main GUI window
    myGui := Gui("+AlwaysOnTop", "Input Window")

    ; Add a text label
    myGui.Add("Text", "Section", "Function:" funObj.Name)


    ; Add the Input Box (Edit control) and store its object in a variable
    myGui.Add("Text", "Section", "Arguments")
    arg1 := myGui.Add("Edit", "Center w100 Section")
    arg2 := myGui.Add("Edit", "Center w100 ys")
    arg3 := myGui.Add("Edit", "Center w100 ys")
    arg4 := myGui.Add("Edit", "Center w100 ys")

    okBtn := myGui.Add("Button", "w80 x180 Default", "OK")
    okBtn.OnEvent("Click", ProcessInput)

    resultEdit := myGui.Add("Edit", "vresultEdit r3 -WantReturn w500 Section x0")

    ; Show the GUI window
    myGui.Show("y100")

    ; --- Functions ---

    ; This function hamotiondles the button click event
    ProcessInput(guiCtrlObj, info) {

        ; Retrieve the text from the edit control
        params := []

        ; 2. Loop through the edit boxes. If an edit box is empty,
        ;    we push 'unset' to create a literal blank argument spot.
        for editBox in [arg1, arg2, arg3, arg4] {
            if (editBox.Value == "")
                params.Push(unset)
            else
                params.Push(editBox.Value)
        }
        try {
            result := funObj(params*)
            resultEdit.Value := result
        }
        catch error as e {
            errorFlyOut("Function " funObj.Name " returned an error")
            resultEdit.Value := funObj.Name " error:`n)" e.Message
        }

    }
    return myGui
}

inputWindow(callbackFunction, prompt := "Enter:", title := "Provide Input", multiLine := false, input := "") {
    inputWindow := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner", title)
    width := 400
    inputWindow.BackColor := "333333"
    elementBackground := "444444"
    inputWindow.MarginX := 10
    inputWIndow.MarginY := 10
    buttonColor := 0x444444 ; "333333"
    inputWindow.SetFont("c999999 s12", "Segoe UI")
    inputWIndow.OnEvent("Size", setEditFocus)
    inputWindow.add("Text", "x10 w" width " Section", prompt)
    if (multiLine)
        edit := inputWindow.Add("Edit", "x10 w" width " r6 Section WantReturn Background" elementBackground, input)
    else
        edit := inputWindow.Add("Edit", "x10 w" width " r1 Section Background" elementBackground, input)
    edit.Opt("Background" elementBackground)
    startX := (width - 180) / 2
    cancelButton := inputWindow.Add("Button", "x" startX " w60 Section", "&Close")
    cancelButton.SetBackColor(buttonColor)
    cancelButton.OnEvent("Click", cancelFunction)
    okButton := inputWindow.Add("Button", "x+10 ys w100 Default", "&Enter")
    okButton.SetBackColor(buttonColor)
    okButton.OnEvent("Click", okFunction)
    setEditFocus(*) {
        edit.Focus()
    }
    okFunction(*) {
        callbackFunction(edit.Value)
        inputWindow.Destroy()
    }
    cancelFunction(*) {
        callbackFunction("")
        inputWindow.Destroy()
    }

    return inputWindow
}

multiSelectWindow(callbackFunction, options := ["Example Option 1", "Example Option 2"], title := "Provide Input", multiSelect := true, prompt := "Pick some") {
    inputWindow := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner", title)
    width := 400
    inputWindow.BackColor := "333333"
    elementBackground := "444444"
    inputWindow.MarginX := 10
    inputWindow.MarginY := 10
    buttonColor := 0x444444

    inputWindow.SetFont("c999999 s12", "Segoe UI")
    inputWindow.add("Text", "x10 w" width " Section", prompt)

    ; 1. ListView styling: -Hdr hides the column header, Checked gives you checkboxes to toggle with Spacebar
    lvOptions := "vlistSelect x10 w" width " r20 Section Background" elementBackground " -Hdr +LV0x4000"
    if (multiSelect)
        lvOptions .= " Checked" ; Spacebar toggles checkboxes natively!

    listSelect := inputWindow.Add("ListView", lvOptions, ["Options"])

    ; Populate the rows
    for item in options
        listSelect.Add(, item)

    ; Pre-focus the first item so it highlights instantly
    listSelect.Modify(1, "+Focus +Select")

    ; Setup focus rules
    inputWindow.OnEvent("Size", setEditFocus)
    setEditFocus(*) {
        listSelect.Focus()
    }

    ; Buttons layout
    startX := (width - 180) / 2
    cancelButton := inputWindow.Add("Button", "x" startX " w60 Section", "&Close")
    cancelButton.SetBackColor(buttonColor)
    cancelButton.OnEvent("Click", cancelFunction)

    okButton := inputWindow.Add("Button", "x+10 ys w100 Default", "&Enter")
    okButton.SetBackColor(buttonColor)
    okButton.OnEvent("Click", okFunction)

    ; 2. Form submission and evaluation
    okFunction(*) {
        selectedAnswers := []

        if (multiSelect) {
            ; Loop through and gather all checked items
            rowNumber := 0
            loop {
                rowNumber := listSelect.GetNext(rowNumber, "Checked")
                if not rowNumber
                    break
                selectedAnswers.Push(listSelect.GetText(rowNumber))
            }
        } else {
            ; Single select: get the currently focused/selected row
            focusedRow := listSelect.GetNext(0, "Focused")
            if focusedRow
                selectedAnswers.Push(listSelect.GetText(focusedRow))
        }

        callbackFunction(selectedAnswers)
        inputWindow.Destroy()
    }

    cancelFunction(*) {
        callbackFunction([])
        inputWindow.Destroy()
    }

    return inputWindow
}
answerOptions := ["Example Option 1", "Example Option 2", "Example Option 3", "Example Option 4"]

; Define your callback function
registerValues(selectedSubset) {
    if (selectedSubset.Length == 0) {
        MsgBox("No options were selected or the window was closed")
    } else {
        ; Create a display string of chosen items
        chosenList := ""
        for item in selectedSubset
            chosenList .= item . "`n"
        MsgBox("The callback was triggered with the following subset:`n`n" . chosenList)
    }
}

; Construct and display the selection window
;window := multiSelectWindow(registerValues, answerOptions, "Give an answer", true, "Select multiple answers")
;window.Show("x10 y10")

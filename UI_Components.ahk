#Include ..\..\Lib\ColorButton.ahk

activeWindowWrapper(function) {
    LastHwnd := WinExist("A")
    returnValue := function() ;basically we want the function to finish executing
    sleep 200 ; give function some time to finish in case there are UI actions
    WinActivate("ahk_id " . LastHwnd)
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

inputWindow(callbackFunction, prompt := "Enter:", title := "Provide Input", multiLine := false) {
    inputWindow := Gui("+AlwaysOnTop -Caption +ToolWindow +Owner", title)
    inputWindow.BackColor := "333333"
    elementBackground := "444444"
    inputWindow.MarginX := 4
    buttonColor := 0x444444 ; "333333"
    inputWindow.SetFont("c999999 s12", "Segoe UI")

    inputWindow.add("Text", "x10 w200 Section", prompt)
    if (multiLine)
        edit := myGui.Add("Edit", "x10 w400 r6 Section WantReturn Background" elementBackground)
    else
        edit := inputWindow.Add("Edit", "x10 w200 r1 Section Background" elementBackground)
    edit.Opt("Background" elementBackground)
    cancelButton := inputWindow.Add("Button", "x40 w60 Section", "&Close")
    cancelButton.SetBackColor(buttonColor)
    cancelButton.OnEvent("Click", cancelFunction)
    okButton := inputWindow.Add("Button", "x110 ys w100 Default", "&Enter")
    okButton.SetBackColor(buttonColor)
    okButton.OnEvent("Click", okFunction)

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
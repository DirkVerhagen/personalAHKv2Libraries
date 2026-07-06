testGui_Constructor(funObj) {
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
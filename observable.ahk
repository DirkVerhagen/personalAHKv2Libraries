#include ./notifications.ahk


State := Observable()

State.OnChange := (propName, oldVal, newVal) => (
    flyOut("Property '" propName "' changed from : " oldVal " to: " newVal, flyOutDuration_Informational, "top")
    ; TODO Add custom handlers based on propName
)


; --- The Magic Class ---
class Observable {
    __Data := Map()
    OnChange := ""

    ; __Set intercepts ALL new variable assignments automatically
    __Set(Name, Params, Value) {
        oldValue := this.__Data.Has(Name) ? this.__Data[Name] : ""
        this.__Data[Name] := Value

        ; Call the change handler if it exists and the value actually changed
        if (this.OnChange && oldValue !== Value) {
            this.OnChange.(Name, oldValue, Value)
        }
    }

    ; __Get handles reading the variables
    __Get(Name, Params) {
        return this.__Data.Has(Name) ? this.__Data[Name] : ""
    }
}
#include ./notifications.ahk
#Requires AutoHotkey v2.0

class Observable {
    OnChange := ""

    __New() {
        this.DefineProp("__storage", { Value: Map() })
    }

    __Set(Name, Params, Value) {
        if (Name == "OnChange") {
            this.DefineProp("OnChange", { Value: Value })
            return
        }

        oldValue := this.__storage.Has(Name) ? this.__storage[Name] : ""
        this.__storage[Name] := Value

        if (this.OnChange && oldValue !== Value) {
            ; FIX FOR IMAGE_C2AF9E.PNG: Extract the function first!
            ; This prevents AHK from injecting "this" as an implicit 4th parameter.
            handler := this.OnChange
            handler(Name, oldValue, Value)
        }
    }

    __Get(Name, Params) {
        return this.__storage.Has(Name) ? this.__storage[Name] : ""
    }
}
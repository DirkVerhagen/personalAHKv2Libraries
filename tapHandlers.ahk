#Requires AutoHotkey v2.0
#include notifications.ahk

; Would we also be able to create a function that insteaf of n*an increment instead chooses an option from an enum (a generalized cycler if you wil)
; would have a slightly longer delay than the tap function but would be more versatile for things where the user has to make more of a choice than an increment like modes


global tapTimeOut := 200 ;Time in ms to wait for a second tap before executing the function for the first tap
global cumulativeTapTimeOut := 500 ;Time in ms to wait for additional taps before executing the function for the first tap
HandleTap(keyID, actionFunc, optionTexts := ["","","T3","4","5","6?!","Really? 7 Taps?!?"]) {
    static taps := Map() ;number of taps for this particular key
    static timers := Map() ;Timer callbacks for this particular key
    
    if !taps.Has(keyID)
        taps[keyID] := 0
    
    taps[keyID] += 1
    if(optionTexts[taps[keyID]] != "")
        flyOut(optionTexts[taps[keyID]],1000,"bottom")
    
    ;Remove timer if no more tap detected
    if timers.Has(keyID) {
        SetTimer(timers[keyID], 0) 
    }

    ; update timer
    timerTick := () => (
        count := taps[keyID],
        taps[keyID] := 0,
        timers.Delete(keyID), 
        actionFunc(count) ; Execute associated function with number of taps as argument
    )

    timers[keyID] := timerTick
    SetTimer(timerTick, -tapTimeOut)
}

HandleCumulativeTap(keyID, actionFunc, increment, unit) { ; Similar to HandleTap but instead of counting taps it adds up values, so you can for example increase volume by holding a button and then execute an action with the cumulative increase as argument
    static taps := Map() ;number of taps for this particular key
    static timers := Map() ;Timer callbacks for this particular key
    static total := Map() ; Cumulative values for this particular key which should be returned
    
    if !taps.Has(keyID) {
        taps[keyID] := 0
    }    
    if !total.Has(keyID) {
        total[keyID] := 0 ;perhaps later we also want to initialize within a range
    }
    taps[keyID] += 1
    total[keyID] := taps[keyID] * increment ; or however you want to calculate the total, for example you could also have it so that each tap increases the increment (first tap 1*increment, second tap 2*increment etc)   
    flyOut(total[keyID] . " " . unit, 500) ; This is actually the main difference, otherwise you could simply do it with handleTap and determine the increment in the function
    
    ;Remove timer if no more tap detected
    if timers.Has(keyID) {
        SetTimer(timers[keyID], 0) 
    }

    ; update timer
    timerTick := () => (
        count := taps[keyID],
        taps[keyID] := 0,
        totalIncrement := total[keyID],
        total[keyID] := 0,
        incrementUnit := unit,
        timers.Delete(keyID),
        actionFunc(count, totalIncrement,incrementUnit) ; Execute associated function with number of taps as argument and the total value of your increment
    )

    timers[keyID] := timerTick
    SetTimer(timerTick, -cumulativeTapTimeOut) ; also a subtle difference, typically you want this a bit higher than normal taptimeout
}
#include ..\..\lib\UIA.ahk
#include ..\..\lib\UIA_Browser.ahk
#Include notifications.ahk


/**
 * Assumes whatsapp is runnning in a browser, activates that browser and selects the whatsapp  tab. Can return a control's as UIA element as well
 * @param whatsappMatch 
 */
activateWhatsapp(whatsappMatch, control := "") {
    try whatsappBrowser := UIA_Browser(whatsappMatch)
    try {
        try {
            currentTab := whatsappBrowser.getTab()
        }
        catch {
            ; errorFlyOut("Could not get current tab")
            ; assume we are on the whatsapp tab as only whatsapp and youtube fuck up getTab
            if (control == "")
                return
        }
        if (currentTab.Name != "WhatsApp")
            whatsappBrowser.SelectTab("WhatsApp", 1, false)
    }
    catch {
        ; errorFlyOut("Could not select whatsapp Tab")
    }
    if (control == "chatinput") {
        chatInput := whatsappBrowser.ElementExist({ HelpText: "Type a message" })
        if (chatInput) {
            chatInput.Click()
            return chatInput
        }
        else
            return 0
    }
}
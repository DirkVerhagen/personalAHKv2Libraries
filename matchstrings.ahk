#Requires AutoHotkey v2.0

global ffBrowserMatchString := "Mozilla Firefox ahk_exe firefox.exe"
global ffLibraryMatchString := "Library ahk_exe firefox.exe"
global ffBookmarkWindow := "ahk_class MozillaDropShadowWindowClass"
global whatsAppMatchString := "WhatsApp ahk_exe brave.exe"
global liveCaptionsMatchString := "ahk_exe LiveCaptions.exe"
global braveMatchString := "ahk_exe Brave.exe"
global streamKeys := "_stream_keys.ahk ahk_class AutoHotkeyGUI"
global codeMatchString := "Visual Studio Code"
global youTubeMatchString := "YouTube ahk_exe brave.exe"


GroupAdd "firefoxWindows", ffLibraryMatchString
GroupAdd "firefoxWindows", ffBrowserMatchString
GroupAdd "firefoxWindows", FFbookmarkWindow

GroupAdd("ffBrowser", ffBrowserMatchString)
GroupAdd("ffBrowser", , , , ffBookmarkWindow)
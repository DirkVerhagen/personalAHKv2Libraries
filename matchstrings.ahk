#Requires AutoHotkey v2.0

global firefoxMatchString := "Mozilla Firefox ahk_exe firefox.exe"
global firefoxLibraryMatchString := "Library ahk_exe firefox.exe"
global chromeMatchString := "ahk_exe chrome.exe"
global whatsAppMatchString :=  "ahk_exe WhatsApp.Root.exe"

GroupAdd "firefoxWindows", firefoxLibraryMatchString
GroupAdd "firefoxWindows", firefoxMatchString

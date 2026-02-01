SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

F13 & b::Left
F13 & n::Down
F13 & p::Up
F13 & f::Right
F13 & d::Del
F13 & h::BS
F13 & e::End
F13 & a::Home
F13 & Space::
{
    Send "{vkF3sc029}"
}

~Escape::
{
    IME_SET(0)
}

*LAlt:: {
    Send "{Blind}{LAlt down}"
}

*LAlt up:: {
    Send "{Blind}{LAlt up}"
    if (A_PriorKey = "LAlt") {
        Send "{Blind}{vkE8}"
        IME_SET(0)
    }
}

*RAlt:: {
    Send "{Blind}{RAlt down}"
}

*RAlt up:: {
    Send "{Blind}{RAlt up}"
    if (A_PriorKey = "RAlt") {
        Send "{Blind}{vkE8}"
        IME_SET(1)
    }
}

; set IME (0 off/ 1 on) 
; IME_SET(mode) {
;     hwnd := WinGetID("A")
;     ime := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
;     DllCall("SendMessage", "Ptr", ime, "UInt", 0x283, "Ptr", 0x006, "Ptr", mode)
; }
IME_SET(mode) {
    hwnd := WinGetID("A")
    SendMessage(0x283, 0x006, mode, DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr"))
}

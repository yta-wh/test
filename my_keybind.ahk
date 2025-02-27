; 左右 Alt キーの空打ちで IME の OFF/ON を切り替える
;
; 左 Alt キーの空打ちで IME を「英数」に切り替え
; 右 Alt キーの空打ちで IME を「かな」に切り替え
; Alt キーを押している間に他のキーを打つと通常の Alt キーとして動作
;
; Author:     karakaram   http://www.karakaram.com/alt-ime-on-off


#Persistent
#SingleInstance, Force
#NoEnv
#UseHook
#InstallKeybdHook
#InstallMouseHook
#HotkeyInterval, 2000
#MaxHotkeysPerInterval, 200
Process, Priority,, Realtime
SendMode, Input

; Razer Synapseなど、キーカスタマイズ系のツールを併用しているときのエラー対策
#MaxHotkeysPerInterval 350

#Include IME.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetTitleMatchMode, 2  ; 部分一致でウィンドウを認識

^!u::MoveWindow(0, 0, 2, 2)  ; 左上
^!i::MoveWindow(1, 0, 2, 2)  ; 右上
^!j::MoveWindow(0, 1, 2, 2)  ; 左下
^!k::MoveWindow(1, 1, 2, 2)  ; 右下

^!+u::MoveWindow(0, 0, 3, 2)  ; 左上
^!+i::MoveWindow(1, 0, 3, 2)  ; 中央上
^!+o::MoveWindow(2, 0, 3, 2)  ; 右上
^!+j::MoveWindow(0, 1, 3, 2)  ; 左下
^!+k::MoveWindow(1, 1, 3, 2)  ; 下中央
^!+l::MoveWindow(2, 1, 3, 2)  ; 右下

^!Enter::MaximizeWindow()  ; 全画面
^!+Enter::MaximizeHeight()  ; 縦方向最大化

^!Right::MoveSide(1)  ; 右半分
^!Left::MoveSide(0)   ; 左半分
^!Up::MoveTopBottom(0)  ; 上半分
^!Down::MoveTopBottom(1)  ; 下半分

^!=::ScaleWindow(1.1)  ; 拡大
^!-::ScaleWindow(0.9)   ; 縮小


;-------------------------------------------------
; 指定分割位置にウィンドウを移動・リサイズ
;-------------------------------------------------
MoveWindow(xIndex, yIndex, xDiv, yDiv) {
    ; アクティブウィンドウの位置取得
    WinGetPos, winX, winY, winW, winH, A

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        ; モニターの作業領域情報を一度に取得
        SysGet, mon, MonitorWorkArea, %A_Index%
        ; monLeft, monTop, monRight, monBottom が利用可能になる

        if ((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) {
            screenWidth := monRight - monLeft
            screenHeight := monBottom - monTop

            width := screenWidth // xDiv
            height := screenHeight // yDiv
            x := monLeft + (xIndex * width)
            y := monTop + (yIndex * height)

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , x, y, width, height
            return
        }
    }
}


;-------------------------------------------------
; アクティブウィンドウをモニターの全体に拡大
;-------------------------------------------------
MaximizeWindow() {
    WinGetPos, winX, winY, winW, winH, A

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if ((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) {
            screenWidth := monRight - monLeft
            screenHeight := monBottom - monTop

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , monLeft, monTop, screenWidth, screenHeight
            return
        }
    }
}


;-------------------------------------------------
; アクティブウィンドウの横位置はそのままで、縦をモニター全体に拡大
;-------------------------------------------------
MaximizeHeight() {
    WinGetPos, winX, winY, winW, winH, A

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if ((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) {
            screenHeight := monBottom - monTop

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , winX, monTop, winW, screenHeight
            return
        }
    }
}


;-------------------------------------------------
; アクティブウィンドウを左右に配置（半分ずつ）
;-------------------------------------------------
MoveSide(isRight) {
    WinGetPos, winX, winY, winW, winH, A

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if (((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) && false) {
            screenWidth := monRight - monLeft
            screenHeight := monBottom - monTop

            width := screenWidth // 2
            height := screenHeight
            x := monLeft + (isRight * width)
            y := monTop

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , x, y, width, height
            return
        }

        tmp1 := (winX + winW // 2)
        tmp2 := (winY + winH // 2) 
	MsgBox (%winX%, %winY%, %winW%, %winH%) → (%tmp1%, %tmp2%) / %monLeft%, %monRight%, %monTop%, %monBottom%
    }
}


;-------------------------------------------------
; アクティブウィンドウを上下に配置（上下半分）
;-------------------------------------------------
MoveTopBottom(isBottom) {
    WinGetPos, winX, winY, winW, winH, A

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if ((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) {
            screenWidth := monRight - monLeft
            screenHeight := monBottom - monTop

            width := screenWidth
            height := screenHeight // 2
            x := monLeft
            y := monTop + (isBottom * height)

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , x, y, width, height
            return
        }
    }
}


;-------------------------------------------------
; アクティブウィンドウのサイズを拡大・縮小
;-------------------------------------------------
ScaleWindow(factor) {
    WinGetPos, winX, winY, winW, winH, A
    centerX := winX + winW // 2
    centerY := winY + winH // 2

    newW := Round(winW * factor)
    newH := Round(winH * factor)

    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if ((winX + winW // 2) >= monLeft && (winX + winW // 2) <= monRight && (winY + winH // 2) >= monTop && (winY + winH // 2) <= monBottom) {
            newX := centerX - newW // 2
            newY := centerY - newH // 2
            ; ※必要に応じ、ウィンドウが作業領域外に出ないよう制限を加えることも可能

            WinGet, activeWin, ID, A
            WinMove, ahk_id %activeWin%, , newX, newY, newW, newH
            return
        }
    }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


is_target()
{
   return 0
}


; 主要なキーを HotKey に設定し、何もせずパススルーする
*~a::
*~b::
*~c::
*~d::
*~e::
*~f::
*~g::
*~h::
*~i::
*~j::
*~k::
*~l::
*~m::
*~n::
*~o::
*~p::
*~q::
*~r::
*~s::
*~t::
*~u::
*~v::
*~w::
*~x::
*~y::
*~z::
*~1::
*~2::
*~3::
*~4::
*~5::
*~6::
*~7::
*~8::
*~9::
*~0::
*~F1::
*~F2::
*~F3::
*~F4::
*~F5::
*~F6::
*~F7::
*~F8::
*~F9::
*~F10::
*~F11::
*~F12::
*~`::
*~~::
*~!::
*~@::
*~#::
*~$::
*~%::
*~^::
*~&::
*~*::
*~(::
*~)::
*~-::
*~_::
*~=::
*~+::
*~[::
*~{::
*~]::
*~}::
*~\::
*~|::
*~;::
*~'::
*~"::
*~,::
*~<::
*~.::
*~>::
*~/::
*~?::
*~Esc::
*~Tab::
*~Space::
*~Left::
*~Right::
*~Up::
*~Down::
*~Enter::
*~PrintScreen::
*~Delete::
*~Home::
*~End::
*~PgUp::
*~PgDn::
    Return

; メニューのフォーカスを防ぐための処理
*LAlt up::
    Send {Blind}{vkE8}  ; 何もしないダミーキーを送信（Windowsに対してAltキーが押されたと誤認させない）
    Return

*RAlt up::
    Send {Blind}{vkE8}  ; 同上
    Return

LAlt::IME_SET(0)
RAlt::IME_SET(1)

;; delete char
delete_char()
{
  Send {Del}
  global is_pre_spc = 0
  Return
}
delete_backward_char()
{
  Send {BS}
  global is_pre_spc = 0
  Return
}

;; quit command
quit()
{
  Send {ESC}
  global is_pre_spc = 0
  Return
}

;; new line
newline()
{
  Send {Enter}
  global is_pre_spc = 0
  Return
}

;; search
isearch_forward()
{
  Send ^f
  global is_pre_spc = 0
  Return
}

move_beginning_of_line()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{HOME}
  Else
    Send {HOME}
  Return
}
move_end_of_line()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{END}
  Else
    Send {END}
  Return
}
previous_line()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{Up}
  Else
    Send {Up}
  Return
}
next_line()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{Down}
  Else
    Send {Down}
  Return
}
forward_char()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{Right}
  Else
    Send {Right}
  Return
}
backward_char()
{
  global
  if is_pre_spc or GetKeyState("Shift", "P")
    Send +{Left}
  Else
    Send {Left}
  Return
}

;; delete char
^d::
  If is_target()
    Send %A_ThisHotkey%
  Else
    delete_char()
  Return
^h::
  If is_target()
    Send %A_ThisHotkey%
  Else
    delete_backward_char()
  Return


;; move cursor
*^a::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_beginning_of_line()
  Return
*^e::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_end_of_line()
  Return
*^p::
  If is_target()
    Send %A_ThisHotkey%
  Else
    previous_line()
  Return
*^n::
  If is_target()
    Send %A_ThisHotkey%
  Else
    next_line()
  Return
*^b::
  If is_target()
    Send %A_ThisHotkey%
  Else
    backward_char()
  Return
*^f::
  If is_target()
    Send %A_ThisHotkey%
  Else
    forward_char()
  Return  

^@::
  Suspend, Toggle
  Return


;;;;;;;;;;;;;;;;;;;;


^k::
    Send, {Shift down}{End}{Shift up}  ; 行末まで選択
    Sleep 50
    Send, ^c  ; コピー
    ClipWait, 1
    Send, {Del}  ; 削除
    Return

^y::
  Send, ^v
  Return

LAlt & c::
  Send, ^c
  Return

LAlt & v::
  Send, ^v
  Return

LAlt & a::
  Send, ^a
  Return

LAlt & f::
  Send, ^f
  Return

LAlt & s::
  Send, ^s
  Return

LAlt & p::
  Send, ^p
  Return

LAlt & n::
  Send, ^n
  Return

LAlt & x::
  Send, ^x
  Return

LAlt & z::
  Send, ^z
  Return

+^j::
  Send, {F6}
  Return

+^k::
  Send, {F7}
  Return

+^l::
  Send, {F9}
  Return

+^vkBB::
  Send, {F8}
  Return

+^vkBA::
  Send, {F10}
  Return

LAlt & Space::
  Send ^{ESC} 
  Return

:*:zh::←
:*:zj::↓
:*:zk::↑
:*:zl::→


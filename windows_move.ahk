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

MoveWindow(xIndex, yIndex, xDiv, yDiv) {
    SysGet, screenWidth,  16  ; 画面の幅
    SysGet, screenHeight, 17  ; 画面の高さ
    
    width := screenWidth // xDiv  ; ウィンドウの幅
    height := screenHeight // yDiv  ; ウィンドウの高さ
    x := xIndex * width  ; X座標
    y := yIndex * height  ; Y座標
    
    WinGet, activeWin, ID, A
    WinMove, ahk_id %activeWin%, , x, y, width, height
}

MaximizeWindow() {
    SysGet, screenWidth,  16  ; 画面の幅
    SysGet, screenHeight, 17  ; 画面の高さ
    
    WinGet, activeWin, ID, A
    WinMove, ahk_id %activeWin%, , 0, 0, screenWidth, screenHeight
}

MaximizeHeight() {
    SysGet, screenWidth,  16  ; 画面の幅
    SysGet, screenHeight, 17  ; 画面の高さ
    
    WinGetPos, x, , width, , A
    WinGet, activeWin, ID, A
    WinMove, ahk_id %activeWin%, , x, 0, width, screenHeight
}

MoveSide(isRight) {
    SysGet, screenWidth,  16
    SysGet, screenHeight, 17
    
    width := screenWidth // 2
    height := screenHeight + 10
    x := isRight * width
    y := 0
    
    WinGet, activeWin, ID, A
    WinMove, ahk_id %activeWin%, , x, y, width, height
}

MoveTopBottom(isBottom) {
    SysGet, screenWidth,  16
    SysGet, screenHeight, 17
    
    width := screenWidth
    height := screenHeight // 2
    x := 0
    y := isBottom * height
    
    WinGet, activeWin, ID, A
    WinMove, ahk_id %activeWin%, , x, y, width, height
}

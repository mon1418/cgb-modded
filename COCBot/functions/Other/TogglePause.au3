; TogglePause

HotKeySet("{PAUSE}", "TogglePause")

Func TogglePause()
	TogglePauseImpl("Button", "GUI")
EndFunc

Func TogglePauseImpl($Source, $Action)
	Local $BlockInputPausePrev
	If $Action = "GUI" OR ($Action = "Pause" AND NOT $TPaused) OR ($Action = "Resume" AND $TPaused) Then
		$TPaused = NOT $TPaused
		If $TPaused and $Runstate = True Then
			TrayTip($sBotTitle, "", 1)
			TrayTip($sBotTitle, "was Paused!", 1, $TIP_ICONEXCLAMATION)
			Setlog("ClashGameBot was Paused!",$COLOR_RED)
			$iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
			If $pEnabled = 1 AND $pRemote = 1 AND $Source = "Push" Then _Push($iPBVillageName & ": Request to Pause...", "Your request has been received. Bot is now paused")
			If $BlockInputPause>0 Then	 $BlockInputPausePrev=$BlockInputPause
			If $BlockInputPause>0 Then  _BlockInputEx(0,"","",$HWnD)
			GUICtrlSetState($btnPause, $GUI_HIDE)
			GUICtrlSetState($btnResume, $GUI_SHOW)
		ElseIf $TPaused = False And $Runstate = True Then
			TrayTip($sBotTitle, "", 1)
			TrayTip($sBotTitle, "was Resumed.", 1, $TIP_ICONASTERISK)
			Setlog("ClashGameBot was Resumed.",$COLOR_GREEN)
			$sTimer = TimerInit()
			AdlibRegister("SetTime", 1000)
			If $pEnabled = 1 AND $pRemote = 1 AND $Source = "Push" Then _Push($iPBVillageName & ": Request to Resume...", "Your request has been received. Bot is now resumed")
			If $BlockInputPausePrev>0 Then  _BlockInputEx($BlockInputPausePrev,"","",$HWnD)
			If $BlockInputPausePrev>0 Then $BlockInputPausePrev=0
			GUICtrlSetState($btnPause, $GUI_SHOW)
			GUICtrlSetState($btnResume, $GUI_HIDE)
		EndIf
		While $TPaused ; Actual Pause loop
			If _Sleep(100) Then ExitLoop
		WEnd
		; everything below this WEnd is executed when unpaused!
		ZoomOut()
		If _Sleep(250) Then Return
	Else
		If $Action = "Pause" Then
			If $pEnabled = 1 AND $pRemote = 1 AND $Source = "Push" Then _Push($iPBVillageName & ": Request to Pause Failed...", "Your request has been received. Bot was already paused...")
		ElseIf $Action = "Resume" Then
			If $pEnabled = 1 AND $pRemote = 1 AND $Source = "Push" Then _Push($iPBVillageName & ": Request to Resume Failed...", "Your request has been received. Bot was already running...")
		EndIf
	EndIf
EndFunc
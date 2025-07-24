#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.3
 Author:         Caxa Cleanup

 Script Function:
	Clean caxa binary cache in user profile on Windows.
  Use combined with commands.list file, this is just a runner.

#ce ----------------------------------------------------------------------------

#RequireAdmin

#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

Global $_sFileNameCommandsList = "commands.list", _
	$_sFilePathCommandsList = @ScriptDir & '\' & $_sFileNameCommandsList, _
	$_sFileSplitDelimiter = ";;" , _
	$_aCommandsList, _
	$_iCommandsName = 0, _
	$_iCommandsBin = 1, _
	$_iCommandsParameters = 2, _
	$_iCommandsEnabled = 3

_main()

;_main
Func _main()
	ReadCommandsList()
	RunCommandsList($_aCommandsList)
	_HoldConsole()
EndFunc

; _HoldConsole
Func _HoldConsole()
	_ConsoleWrite("+ FINISHED: Press [ENTER] or [CTRL] + C to exit")
    Local $sOutput
    While True
        $sOutput &= ConsoleRead()
		If StringLen($sOutput) > 0 Then ExitLoop
        If @error Then ExitLoop
        Sleep(45)
    WEnd
EndFunc

; RunCommandsList
Func RunCommandsList($aCommandsList)
	Local $iCountCommands = UBound($aCommandsList) - 1, _
		$sCommandEnabled = "enabled"

	_ConsoleWrite("+ INITIALIZING: Reading commands list")

	For $iCommandIndex = 0 To $iCountCommands
		If $aCommandsList[$iCommandIndex][$_iCommandsEnabled] = $sCommandEnabled Then _
			ExecuteCommand($aCommandsList, $iCommandIndex)
	Next
EndFunc

; Execute command
Func ExecuteCommand($aCommandsList, $iCommandIndex)
;~ 	MsgBox(0,0,$aCommandsList[$iCommandIndex][$_iCommandsName])
	_ConsoleWrite("+ COMMAND: " & $aCommandsList[$iCommandIndex][$_iCommandsName])
	_RunWaitWrapper( _
		$aCommandsList[$iCommandIndex][$_iCommandsBin] & " " & _
		$aCommandsList[$iCommandIndex][$_iCommandsParameters] _
	)
EndFunc

; Read commands list
Func ReadCommandsList()
	If FileExists($_sFilePathCommandsList) = 1 Then
		_FileReadToArray($_sFilePathCommandsList, $_aCommandsList, $FRTA_NOCOUNT + $FRTA_ENTIRESPLIT, $_sFileSplitDelimiter)
		If @error > 0 Then _ThrowExceptionExit("+ FATAL ERROR: An error has occurred while reading the file, error " & @error)
	Else
		_ThrowExceptionExit("+ FATAL ERROR: File commands.list doesnt exist")
	EndIf
EndFunc

; Throw exeception and exit script
Func _ThrowExceptionExit($msg)
	MsgBox(0,"Error","There was an error, the application will close now" & @CRLF & $msg)
	_ConsoleWrite($msg)
	Exit
EndFunc

; Console write wrapper
Func _ConsoleWrite($msg)
	ConsoleWrite($msg & @CRLF)
EndFunc

; ShellExecuteWaitWrapper
Func _RunWaitWrapper($command)
;~ 	_ConsoleWrite( _
		RunWait(@ComSpec & " /c """ & $command & "" , "", @SW_HIDE) _
;~ 	)
EndFunc

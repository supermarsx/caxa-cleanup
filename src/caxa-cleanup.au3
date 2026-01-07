#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.3
 Subject:        Caxa Cleanup
 Script Function:
    Clean caxa binary cache in user profile on Windows.
    Reads commands from "commands.list" and executes them sequentially.
#ce ----------------------------------------------------------------------------

#RequireAdmin

#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

; Enums for Command Array Indices
Enum $eCmd_Name = 0, _
		$eCmd_Bin, _
		$eCmd_Params, _
		$eCmd_Enabled

; Global Constants
Global Const $g_sConfigFileName = "commands.list"
Global Const $g_sConfigFilePath = @ScriptDir & '\' & $g_sConfigFileName
Global Const $g_sDelimiter = ";;"

; Global Variables
Global $g_aCommandsList

; Entry Point
_Main()

; ------------------------------------------------------------------------------
; Function:     _Main
; Description:  Main execution controller.
;               1. Reads commands.
;               2. Executes enabled commands.
;               3. Keeps console open.
; ------------------------------------------------------------------------------
Func _Main()
	ReadCommandsList()
	RunCommandsList($g_aCommandsList)
	_HoldConsole()
EndFunc   ;==>_Main

; ------------------------------------------------------------------------------
; Function:     ReadCommandsList
; Description:  Reads the command list file into the global array.
;               Exits on failure.
; ------------------------------------------------------------------------------
Func ReadCommandsList()
	If Not FileExists($g_sConfigFilePath) Then
		_ThrowExceptionExit("! FATAL ERROR: Configuration file not found: " & $g_sConfigFileName)
	EndIf

	_FileReadToArray($g_sConfigFilePath, $g_aCommandsList, $FRTA_NOCOUNT + $FRTA_ENTIRESPLIT, $g_sDelimiter)

	If @error Then
		_ThrowExceptionExit("! FATAL ERROR: Failed to read configuration file. Error code: " & @error)
	EndIf
EndFunc   ;==>ReadCommandsList

; ------------------------------------------------------------------------------
; Function:     RunCommandsList
; Description:  Iterates and executes enabled commands.
; Parameters:   $aList - The array of commands.
; ------------------------------------------------------------------------------
Func RunCommandsList(ByRef $aList)
	_ConsoleWrite("+ INITIALIZING: Processing command list...")

	Local $iCount = UBound($aList) - 1
	Local $sStatusEnabled = "enabled"

	For $i = 0 To $iCount
		If $aList[$i][$eCmd_Enabled] = $sStatusEnabled Then
			ExecuteCommand($aList, $i)
		EndIf
	Next
EndFunc   ;==>RunCommandsList

; ------------------------------------------------------------------------------
; Function:     ExecuteCommand
; Description:  Executes a single command line.
; Parameters:   $aList   - The command array.
;               $iIndex  - Index of the command to run.
; ------------------------------------------------------------------------------
Func ExecuteCommand(ByRef $aList, $iIndex)
	Local $sName = $aList[$iIndex][$eCmd_Name]
	Local $sBin = $aList[$iIndex][$eCmd_Bin]
	Local $sParams = $aList[$iIndex][$eCmd_Params]

	_ConsoleWrite(">> COMMAND: " & $sName)

	Local $iExitCode = _RunWaitWrapper($sBin & " " & $sParams)

	If $iExitCode <> 0 Then
		_ConsoleWrite("!  WARNING: Command returned exit code " & $iExitCode)
	EndIf
EndFunc   ;==>ExecuteCommand

; ------------------------------------------------------------------------------
; Function:     _RunWaitWrapper
; Description:  Wraps RunWait to execute commands via ComSpec (cmd.exe).
;               Runs hidden.
; Parameters:   $sCommand - The command string.
; Returns:      The exit code of the command.
; ------------------------------------------------------------------------------
Func _RunWaitWrapper($sCommand)
	Return RunWait(@ComSpec & " /c """ & $sCommand & """", "", @SW_HIDE)
EndFunc   ;==>_RunWaitWrapper

; ------------------------------------------------------------------------------
; Function:     _HoldConsole
; Description:  Keeps the console window active until manual exit.
; ------------------------------------------------------------------------------
Func _HoldConsole()
	_ConsoleWrite(@CRLF & "+ FINISHED. Press [ENTER] or [CTRL]+C to exit.")

	Local $sInput
	While True
		$sInput &= ConsoleRead()
		If StringLen($sInput) > 0 Or @error Then ExitLoop
		Sleep(50)
	WEnd
EndFunc   ;==>_HoldConsole

; ------------------------------------------------------------------------------
; Function:     _ThrowExceptionExit
; Description:  Reports a fatal error and terminates the script.
; Parameters:   $sMsg - Error message.
; ------------------------------------------------------------------------------
Func _ThrowExceptionExit($sMsg)
	MsgBox($MB_ICONERROR + $MB_TOPMOST, "Error", "Fatal Error Occurred:" & @CRLF & $sMsg)
	_ConsoleWrite($sMsg)
	Exit 1
EndFunc   ;==>_ThrowExceptionExit

; ------------------------------------------------------------------------------
; Function:     _ConsoleWrite
; Description:  Writing helper.
; Parameters:   $sMsg - Message to print.
; ------------------------------------------------------------------------------
Func _ConsoleWrite($sMsg)
	ConsoleWrite($sMsg & @CRLF)
EndFunc   ;==>_ConsoleWrite


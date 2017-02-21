#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Array := Array("1f349","1f4a9","1f47b","1f47e","1f480","1f4a3","1f4a8","2764","1f4a2","1f4a5","1f4a4","1f576","1f525","2728","2b50","1f4a9","1f335","1f33b","1f339","1f331","1f347","1f348","1f34a","1f34b","1f34c","1f34d","1f34e","1f350","1f351","1f352","1f353","1f95d","1f346","1f955","1f336","1f344","1f349","1f30c","1f680","1f308","1f388","1f389","1f3c6","1f3ae","1f579","1f4af","1f41b")


for index, element in Array ; Recommended approach in most cases.
{
    ; Using "Loop", indices must be consecutive numbers from 1 to the number
    ; of elements in the array (or they must be calculated within the loop).
    ; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
    
    ; Using "for", both the index (or "key") and its associated value
    ; are provided, and the index can be *any* value of your choosing.
	
	IfExist, %A_WorkingDir%\36x36\%element%.png
	{
		FileMove, %A_WorkingDir%\36x36\%element%.png, %A_WorkingDir%\36x36\DONE\*.*
	}
	else
	{
		MsgBox, ERROR! 🙀🙀🙀 Missing: %element%
	}
	
}

MsgBox, Done! 👌
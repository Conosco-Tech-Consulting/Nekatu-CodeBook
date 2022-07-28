Const ForReading = 1    
Const ForWriting = 2

strFileName = Wscript.Arguments(0)
strOldText = "\\Ls-wxl4ef\share"
strNewText = "C:\Ls-wxl4ef\share"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(strFileName, ForReading)
strText = objFile.ReadAll
objFile.Close

strNewText = Replace(strText, strOldText, strNewText)
Set objFile = objFSO.OpenTextFile(strFileName, ForWriting)
objFile.WriteLine strNewText
objFile.Close
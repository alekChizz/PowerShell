# @author alexis.f.gonzales
# @Date 11.07.2023
# @Description: Copy files from source folder to destination folder using the reference file

$srcFolderName = "D:\GitHub\PowerShell\FindCopyFile\InputFolder"
$destFolderName = "D:\GitHub\PowerShell\FindCopyFile\OutputFolder"
$referenceFile = "FileList.txt"

#----------------------------------------------------------------------#
#------------------------ DO NOT CHANGE BEYOND ------------------------
#----------------------------------------------------------------------#

function findCopyFile($srcFolderName, $destFolderName, $fileName){
	$findStr = "$($srcFolderName)\$($fileName)"
	$fileList = Get-Childitem -Path $findStr -Recurse
	if ($fileList.length -eq 0) {
		Write-Host " > FILE NOT FOUND - " $fileName -ForegroundColor Red
	} else {
		$i = 0
		foreach($currfile in $fileList) {
			$actualFileName = Split-Path -Path $currfile -Leaf
			if ($i -gt 0) {
				$leafBase = Split-Path -Path $currfile -LeafBase
				$ext = Split-Path -Path $currfile -extension
				$actualFileName = $leafBase + "(" + $i + ")." + $ext
			}
			Copy-Item $currfile -Destination $destFolderName\$actualFileName
			Write-Host " > " $currfile " (COPIED)" -ForegroundColor Green
			$i += 1
		}
	}
}

if (-not (Test-Path .\$referenceFile)) {
	Write-Host "REFERENCE FILE NOT FOUND - $referenceFile" -ForegroundColor Red
	pause
	return
}
if (-not (Test-Path $srcFolderName)) {
	Write-Host "INVALID PATH - $srcFolderName" -ForegroundColor Red
	pause
	return
}
if (-not (Test-Path $destFolderName)) {
	Write-Host "INVALID PATH - $destFolderName" -ForegroundColor Red
	pause
	return
}

foreach($line in Get-Content .\$referenceFile) {
	if ($line -ne "") {
		findCopyFile $srcFolderName $destFolderName $line
	}
}

Write-Host `n" > Process Completed < "`n -ForegroundColor green
pause
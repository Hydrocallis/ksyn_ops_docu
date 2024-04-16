# フォルダをコピーする関数
function Copy-Folder {
    param (
        [string]$SourceFolder,
        [string]$DestinationFolder
    )

    # DestinationFolderが存在しない場合は作成する
    if (-not (Test-Path -Path $DestinationFolder -PathType Container)) {
        New-Item -Path $DestinationFolder -ItemType Directory
    }

    # フォルダ内のファイルとフォルダを再帰的にコピーする
    Get-ChildItem -Path $SourceFolder | ForEach-Object {
        $DestinationPath = Join-Path -Path $DestinationFolder -ChildPath $_.Name
        if ($_.PsIsContainer) {
            Copy-Item -Path $_.FullName -Destination $DestinationPath -Recurse -Force
        } else {
            Copy-Item -Path $_.FullName -Destination $DestinationPath -Force
        }
    }
}

# build/htmlフォルダ内の内容をdocsフォルダにコピーする
$folderName = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
# 確認のためカレントフォルダ名をプリント
Write-Host "Current folder name: $folderName"
Copy-Folder -SourceFolder "$folderName\build\html" -DestinationFolder "$folderName\docs"


# .nojekyllファイルをdocsフォルダに作成する
$nojekyllFilePath = Join-Path -Path "$folderName\docs" -ChildPath ".nojekyll"
if (-not (Test-Path -Path $nojekyllFilePath)) {
    New-Item -Path $nojekyllFilePath -ItemType File
}

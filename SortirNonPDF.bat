@echo off
set "SOURCE=C:\Github\Temp"
set "DEST=C:\Github\a jeter"

if not exist "%DEST%" mkdir "%DEST%"

for /R "%SOURCE%" %%F in (*) do (
    if /I not "%%~xF"==".pdf" (
        move "%%F" "%DEST%"
    )
)

echo Terminé.
pause
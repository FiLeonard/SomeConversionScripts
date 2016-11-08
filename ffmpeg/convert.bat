for /F "delims=;" %%F in (wmvenclist.txt) do (
echo."%%F" | findstr /C:"_enc.mp4" 1>nul
if errorlevel 1 (
ffmpeg.exe  -i "%%F" -crf 23 -maxrate 1500k -bufsize 3200k -threads 4 -vcodec libx264 -vf "scale='min(iw,1024)':-1" "%%~dF%%~pF%%~nF_enc.mp4" && del "%%F")
)

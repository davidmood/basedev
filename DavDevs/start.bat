@echo off
color 0c
echo -
echo Carcara limpando pasta cache aguarde......
echo -
rd /s /q "cache"
timeout 5
test&cls
echo ===-------------------------------===
echo     Essa uma base limpa!!
echo     Carcara Dev_Group
echo     Developed by: ! La Guardia#7711
echo     Discord: discord.gg/g3TgbHUKv2
echo ===-------------------------------===
start ..\build\run.cmd +exec server.cfg +set onesync_enableInfinity 1
exit
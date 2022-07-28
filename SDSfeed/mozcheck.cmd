type "%programfiles%\Mozilla Firefox\greprefs\all.js" | find /i "general.config.filename"
if "%errorlevel%" GEQ "1" (
echo pref("general.config.filename", "mozilla.cfg"^);>>"%programfiles%\Mozilla Firefox\greprefs\all.js"
)
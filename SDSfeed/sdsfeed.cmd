@echo off
cls

set feed=c:\sdsfeed.xml
set list=c:\sdslist.csv
set host=\\10.255.255.14\c$\inetpub\wwwroot\development\SDS\sdsfeed.xml

for /f "tokens=1-5 delims= " %%a in ('now') do set now=%%a, %%c %%b %%e %%d GMT

echo ^<?xml version="1.0" encoding="utf-8"?^> >"%feed%"
echo ^<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom"^> >>"%feed%"
echo ^<atom:link href="http://www.southdevonsound.co.uk/sdsfeed.xml" rel="self" type="application/rss+xml" /^> >>"%feed%"
echo ^<channel^> >>"%feed%"
echo ^<title^>South Devon Sound - Broadcast Schedule^</title^> >>"%feed%"
echo ^<description^>We play the best music from yesterday and today- all day, every day. On South Devon Sound you'll find a show to match virtually all of your moods.^</description^> >>"%feed%"
echo ^<link^>http://www.southdevonsound.co.uk^</link^> >>"%feed%"
echo ^<lastBuildDate^>%now%^</lastBuildDate^> >>"%feed%"

for /f "tokens=1,2,3 delims=#" %%a in (%list%) do (

  echo ^<item^> >>"%feed%"
  echo ^<title^>%%a^</title^> >>"%feed%"
  echo ^<description^>^</description^> >>"%feed%"
  echo ^<pubDate^>%%b^</pubDate^> >>"%feed%"
  echo ^<link^>http://www.southdevonsound.co.uk^</link^> >>"%feed%"
  echo ^<guid^>http://www.southdevonsound.co.uk/#%%c^</guid^> >>"%feed%"
  echo ^</item^> >>"%feed%"

)

echo ^</channel^> >>"%feed%"
echo ^</rss^> >>"%feed%"

copy "%feed%" "%host%" /y
#!/bin/bash
umask 000

# Start MediaBrowser Server
cd /opt/MediaBrowser
exec /sbin/setuser nobody mono /opt/MediaBrowser/MediaBrowser.Server.Mono.exe -programdata /config

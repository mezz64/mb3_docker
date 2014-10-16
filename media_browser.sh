#!/bin/bash
umask 000

# Start MediaBrowser Server
cd /opt/mediabrowser
exec sudo -u nobody "mono /opt/mediabrowser/MediaBrowser.Server.Mono.exe -programdata /config"

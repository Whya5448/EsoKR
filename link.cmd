@echo off
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" /S /Q

mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" "%cd%\gamedata"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" "%cd%\EsoKR"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" "%cd%\EsoUI"
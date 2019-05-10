@echo off
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyAlchemyKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyProvisioningKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DolgubonsLazyWritCreatorKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DestinationsKRPatch" /S /Q

rd "%userprofile%\Documents\Elder Scrolls Online\pts\AddOns\" /S /Q

mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" "%cd%\gamedata"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" "%cd%\EsoKR"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" "%cd%\EsoUI"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyAlchemyKRPatch" "%cd%\DailyAlchemyKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyProvisioningKRPatch" "%cd%\DailyProvisioningKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DolgubonsLazyWritCreatorKRPatch" "%cd%\DolgubonsLazyWritCreatorKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DestinationsKRPatch" "%cd%\DestinationsKRPatch"

mklink /D "%userprofile%\Documents\Elder Scrolls Online\pts\AddOns\" "%userprofile%\Documents\Elder Scrolls Online\live\AddOns"

@echo off
rem 링크든 데이터든 심볼릭 링크를 위해 삭제
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyAlchemyKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyProvisioningKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DolgubonsLazyWritCreatorKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DestinationsKRPatch" /S /Q
rd "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\TamrielTradeCentreKRPatch" /S /Q

rem 심볼릭 링크
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\gamedata" "%cd%\gamedata"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoKR" "%cd%\EsoKR"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\EsoUI" "%cd%\EsoUI"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyAlchemyKRPatch" "%cd%\DailyAlchemyKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DailyProvisioningKRPatch" "%cd%\DailyProvisioningKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DolgubonsLazyWritCreatorKRPatch" "%cd%\DolgubonsLazyWritCreatorKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\DestinationsKRPatch" "%cd%\DestinationsKRPatch"
mklink /D "%userprofile%\Documents\Elder Scrolls Online\live\AddOns\TamrielTradeCentreKRPatch" "%cd%\TamrielTradeCentreKRPatch"

rem PTS 서버 삭제 * 마지막에 \ 붙히면 live 애드온들 다 날아감.
rd "%userprofile%\Documents\Elder Scrolls Online\pts\AddOns" /S /Q

rem PTS 서버 애드온 Live 심볼릭으로 끌어옴
mklink /D "%userprofile%\Documents\Elder Scrolls Online\pts\AddOns\" "%userprofile%\Documents\Elder Scrolls Online\live\AddOns"

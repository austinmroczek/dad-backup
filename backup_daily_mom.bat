@echo off
title Backup Script

rem #################################################
rem # 
rem # The daily backup saves to a folder with date format YYYYMM.
rem # 
rem # When the month changes, that folder stops being updated, creating a monthly backup.
rem # 
rem # TODO: figure out how to ZIP up the old months to save space
rem #
rem #################################################

call:getDate mydate
call:getDayofMonth dayOfMonth
call:getMonthly monthly

:: ############# set locations here ##############

set myfiles="c:\users\shirl"
set myfiles_daily_network="z:\Shirley\Monthly\%monthly%"

echo ####################### check locations exist #############################
call:checkDrive %myfiles%
call:checkDrive %myfiles_daily_network%

echo ##### MIRROR PERSONAL FILES TO NETWORK #####
echo robocopy %myfiles% %myfiles_daily_network% /MIR 

robocopy %myfiles% %myfiles_daily_network% /MIR /FFT /XJD /XF ntuser.* ntuser.dat.* /XD AppData /XD "Application Data" /XD Cookies /XD OneDrive

pause

exit /B

::  ############################################
::  #####            FUNCTIONS             #####
::  ############################################

:checkDrive
  rem ########## check that backup drive exists ##########

  set temp=%1%
  set "dest_drive=%temp:~1,3%"

  if not exist %dest_drive% (
    echo Drive %dest_drive% does not exist.  Could not continue with backup.
    pause
    exit
  ) else (
    rem Drive exists.  Continuing with backups....
  )
exit /B

:getDate
  set "%~1=%date:~10,4%%date:~4,2%%date:~7,2%"
exit /B

:getDayOfMonth
  set "%~1=%date:~7,2%"
exit /B

:getMonthly
  set "%~1=%date:~10,4%%date:~4,2%"
exit /B

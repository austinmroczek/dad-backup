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

set myfiles="c:\users\Joe"
set myfiles_daily_network="z:\Joe\Monthly\%monthly%"

set passwords_filename="passwords.psafe3"
set passwords="C:\Users\joe\Documents\biz\Business Files\Password Safe\"
set passwords_backup="z:\Joe\passwords\"

echo ####################### check locations exist #############################
rem call:checkDrive myfiles
rem call:checkDrive myfiles_daily_network
rem call:checkDrive passwords
rem call:checkDrive passwords_backup

echo ######################## BACKUP PASSWORDS ##########################################
rem copy today's password file to a backup location with date attached
copy %passwords%%passwords_filename% %passwords_backup%%passwords_filename%.%mydate%

echo ##### MIRROR PERSONAL FILES TO NETWORK #####
echo robocopy %myfiles% %myfiles_daily_network% /MIR 

robocopy %myfiles% %myfiles_daily_network% /MIR /FFT /XF ntuser.* ntuser.dat.* /XD AppData /XD "Application Data" /XD Cookies /XD OneDrive

pause

exit /B

::  ############################################
::  #####            FUNCTIONS             #####
::  ############################################

:checkDrive
  rem ########## check that backup drive exists ##########
  set "dest_drive=%1:~1,3%"

  if not exist %dest_drive% (
    echo Drive %dest_drive% does not exist
    pause
    exit
  ) else (
    echo Drive exists.  Continuing with backups....
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


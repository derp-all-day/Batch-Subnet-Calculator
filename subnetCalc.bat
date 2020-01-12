@echo off
@mode con cols=85 lines=27
TITLE Batch Subnet Calculator
::::::::::::::::::::::::::::::::::::
::::A subnet calculator in batch::::
::::::::::::::::::::::::::::::::::::
:::::::::Author: Andrew B.::::::::::
::::::::::::::::::::::::::::::::::::


color 02
:TOP
cls
call :header
echo              X  .  X  .  X  .  X                     255  .  X  .  X  .  X
call :line
echo Welcome to the sunet calculator. First you will be prompted for the octets of the IP
echo then you will be prompted for the octets of the Subnet Mask. And no,it wont let you
echo enter in illegal octet addresses.
echo.
pause > NUL

:ipo1
cls
call :header
echo              X  .  X  .  X  .  X                     255  .  X  .  X  .  X
call :line
Set /P ip_1=IP octet - 1:
if %ip_1% GTR 254 goto ipo1
if %ip_1% LSS 0 goto ipo1

:ipo2
cls
call :header
echo             %ip_1% .  X  .  X  .  X                     255  .  X  .  X  .  X
call :line
Set /P ip_2=IP octet - 2:
if %ip_2% GTR 255 goto ipo2
if %ip_2% LSS 0 goto ipo2

:ipo3
cls
call :header
echo             %ip_1% . %ip_2% .  X  .  X                     255  .  X  .  X  .  X
call :line
Set /P ip_3=IP octet - 3:
if %ip_3% GTR 255 goto ipo3
if %ip_3% LSS 0 goto ipo3

:ipo4
cls
call :header
echo             %ip_1% . %ip_2% . %ip_3% .  X                     255  .  X  .  X  .  X
call :line
Set /P ip_4=IP octet - 4:
if %ip_4% GTR 255 goto ipo4
if %ip_4% LSS 0 goto ipo4

cls
call :header
echo             %ip_1% . %ip_2% . %ip_3% . %ip_4%                    255  .  X  .  X  .  X
call :line
echo Got the ip now, all we need is the subnet Mask. Be sure ot to forget the interesting
echo octet! So obviously the first octet is 255 so we will begin with the next octet...
echo.
pause > NUL

:smo2
cls
call :header
echo             %ip_1% . %ip_2% . %ip_3% . %ip_4%                    255  .  X  .  X  .  X
call :line
Set /P sm_2=Subnet Mask - octet 2:
if %sm_2% GTR 255 goto smo2
if %sm_2% LSS 0 goto ipo2
if %sm_2% LSS 255 goto sm2
goto sm2o
:sm2
set /a sm_3 = 0
set /a sm_4 = 0
goto sigh
:sm2o

:smo3
cls
call :header
echo             %ip_1% . %ip_2% . %ip_3% . %ip_4%                   255  . %sm_2% .  X  .  X
call :line
Set /P sm_3=Subnet Mask - octet 3:
if %sm_3% GTR 255 goto smo3
if %sm_3% LSS 0 goto ipo3
if %sm_3% LSS 255 goto sm3
goto sm3o
:sm3
set /a sm_4 = 0
goto sigh
:sm3o

:smo4
cls
call :header
echo             %ip_1% . %ip_2% . %ip_3% . %ip_4%                   255  . %sm_2% . %sm_3% .  X
call :line
Set /P sm_4=Subnet Mask - octet 4:
if %sm_4% GTR 255 goto smo4
if %sm_4% LSS 0 goto smo4

cls

:sigh

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Now for the math

::Find the class
if %ip_1% LSS 255 set class=E
if %ip_1% LSS 248 set class=D
if %ip_1% LSS 240 set class=C
if %ip_1% LSS 192 set class=B
if %ip_1% LSS 128 set class=A


::Finding the iteresting octet
if not %sm_4% == 0 set /a io = %sm_4%
if not %sm_4% == 0 set /a ion = 4
if not %sm_4% == 0 goto cio
if not %sm_3% == 0 set /a io = %sm_3%
if not %sm_3% == 0 set /a ion = 3
if not %sm_3% == 0 goto cio
if not %sm_2% == 0 set /a io = %sm_2%
if not %sm_2% == 0 set /a ion = 2
if not %sm_2% == 0 goto cio
:cio

::multiply by #
if %io% == 128 set /a mb = 128
if %io% == 192 set /a mb = 64
if %io% == 224 set /a mb = 32
if %io% == 240 set /a mb = 16
if %io% == 248 set /a mb = 8
if %io% == 252 set /a mb = 4
if %io% == 254 set /a mb = 2
if %io% == 255 set /a mb = 1

::current subnet
if %ion% == 4 set /a ipn = %ip_4%
if %ion% == 3 set /a ipn = %ip_3%
if %ion% == 2 set /a ipn = %ip_2%

cls
::ID
set /a fid = %ipn% / %mb%
set /a sid = %fid% * %mb%
set /a sidp = %sid% + %mb% - 1
set /a sidpo = %sid% + 1

::max numbr of subnets
set /a mns = 256 / %mb%

::hosts per subet
::128
if %io% == 128 goto hp-128-%ion%
goto hp-128-out
:hp-128-4
set /a hps = 128
goto hp-128-out
:hp-128-3
set /a hps = 32768
goto hp-128-out
:hp-128-2
set /a hps = 8388608
goto hp-128-out
:hp-128-out
::192
if %io% == 192 goto hp-192-%ion%
goto hp-192-out
:hp-192-4
set /a hps = 64
goto hp-192-outx
:hp-192-3
set /a hps = 16384
goto hp-192-out
:hp-192-2
set /a hps = 4194304
goto hp-192-out
:hp-192-out
::224
if %io% == 224 goto hp-224-%ion%
goto hp-224-out
:hp-224-4
set /a hps = 32
goto hp-224-out
:hp-224-3
set /a hps = 8192
goto hp-224-out
:hp-224-2
set /a hps = 2097152
goto hp-224-out
:hp-224-out
::240
if %io% == 240 goto hp-240-%ion%
goto hp-240-out
:hp-240-4
set /a hps = 16
goto hp-240-out
:hp-240-3
set /a hps = 4096
goto hp-240-out
:hp-240-2
set /a hps = 1048576
goto hp-240-out
:hp-240-out
::248
if %io% == 248 goto hp-248-%ion%
goto hp-248-out
:hp-248-4
set /a hps = 8
goto hp-248-out
:hp-248-3
set /a hps = 2048
goto hp-248-out
:hp-248-2
set /a hps = 524288
goto hp-248-out
:hp-248-out
::252
if %io% == 252 goto hp-252-%ion%
goto hp-252-out
:hp-252-4
set /a hps = 4
goto hp-252-out
:hp-252-3
set /a hps = 1024
goto hp-252-out
:hp-252-2
set /a hps = 262144
goto hp-252-out
:hp-252-out
::254
if %io% == 254 goto hp-254-%ion%
goto hp-254-out
:hp-254-4
set /a hps = 2
goto hp-254-out
:hp-254-3
set /a hps = 512
goto hp-254-out
:hp-254-2
set /a hps = 131072
goto hp-254-out
:hp-254-out
::255
if %io% == 255 goto hp-255-%ion%
goto hp-255-out
:hp-255-4
set /a hps = 1
goto hp-255-out
:hp-255-3
set /a hps = 256
goto hp-255-out
:hp-255-2
set /a hps = 65536
goto hp-255-out
:hp-255-out

cls
@mode con cols=85 lines=40
call :header
echo             %ip_1% . %ip_2% . %ip_3% . %ip_4%                   255  . %sm_2% . %sm_3% . %sm_4%
call :line
echo Class:                        %class%
echo SN Interesting Octet:         %io%
echo Hosts per subnet:             %hps%
echo Number of possile subnets:    %mns%
echo.
echo                        SUBNET SPECIFIC TO SPECIFIED IP ADDRESS
echo ____________________________________________________________________________________
call :SubnetID %sid%
call :BrodcastID %sid%
call :FirstIP %sid%
call :LastIP %sid%
echo.
echo                                  FIRST SUBNET IN RANGE
echo ____________________________________________________________________________________
call :SubnetID 0
call :BrodcastID 0
call :FirstIP 0
call :LastIP 0
pause > NUL
@mode con cols=85 lines=27
goto top

::Functions
:header
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º #####           #                                     ###                        º
echo º #   #   #   #   #       #   #    ###    #            #   #           #      ###  º
echo º ##      #   #   #       ##  #   #   # #####         #         ###    #     #   # º
echo º   ##    #   #   #####   # # #   #####   #     ###   #        #   #   #    #      º
echo º #   #   #   #   #   #   #  ##   #       #            #   #   #   #   #     #   # º
echo º #####   #####   #####   #   #    ###     ##           ###     ### #   ###   ###  º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
echo.
echo           ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»              ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo           º       IP ADDRESS       º              º       Subnet Mask      º
echo           ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼              ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
goto eof

:line
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
goto eof

:SubnetID
if %ion% == 4 echo Subnet ID:                    %ip_1% . %ip_2% . %ip_3% . %~1
if %ion% == 3 echo Subnet ID:                    %ip_1% . %ip_2% . %~1 . 0
if %ion% == 2 echo Subnet ID:                    %ip_1% . %~1 . 0 . 0
goto eof

:BrodcastID
set /a sidp = %~1 + %mb% - 1
if %ion% == 4 echo Brodcast ID:                  %ip_1% . %ip_2% . %ip_3% . %sidp%
if %ion% == 3 echo Brodcast ID:                  %ip_1% . %ip_2% . %sidp% . 255
if %ion% == 2 echo Brodcast ID:                  %ip_1% . %sidp% . 255 . 255
::%sidp% ???
goto eof

:FirstIP
if %ion% == 4 echo First Uesable IP:             %ip_1% . %ip_2% . %ip_3% . %~1
if %ion% == 3 echo First Uesable IP:             %ip_1% . %ip_2% . %~1 . 1
if %ion% == 2 echo First Uesable IP:             %ip_1% . %~1 . 0 . 1
goto eof

:LastIP
set /a sidp = %~1 + %mb% - 1
if %ion% == 4 echo Last Useable IP:              %ip_1% . %ip_2% . %ip_3% . %sidp%
if %ion% == 3 echo Last Useable IP:              %ip_1% . %ip_2% . %sidp% . 254
if %ion% == 2 echo Last Useable IP:              %ip_1% . %sidp% . 255 . 254
goto eof

:eof

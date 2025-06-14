:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    ___                ___ ___ ™                                         ::
::   / __|__ _ _ __  ___|_  )   \                                          ::
::  | (_ / _` | '  \/ -_)/ /| |) |                                         ::
::   \___\__,_|_|_|_\___/___|___/                                          ::
::        Build. Play. Repeat.                                             ::
::                                                                         ::
:: Copyright © 2025-present tinyBigGAMES™ LLC                              ::
:: All Rights Reserved.                                                    ::
::                                                                         ::
:: https://github.com/tinyBigGAMES/Game2D                                  ::
::                                                                         ::
:: BSD 3-Clause License                                                    ::
::                                                                         ::
:: Copyright (c) 2025-present, tinyBigGAMES LLC                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

@TITLE Game2D Video Converter v1.0 (MPG/MPEG1)

:: Initialize variables
set "FFMPEG_EXE=ffmpeg.exe"
set "FFMPEG_PATH="
set "INPUT_FILE="
set "OUTPUT_FILE="
set "VIDEO_QUALITY=11"
set "VIDEO_BITRATE=1500k"
set "AUDIO_CODEC=mp2"
set "ERROR_LEVEL=0"

:: Main menu
:MAIN_MENU
cls
echo.
echo ===============================================================================
echo                      Game2D Video Converter v1.0 (MPG)
echo ===============================================================================
echo.
echo This tool converts video files to Game2D compatible MPEG1 format
echo (MPEG1 video, MP2 audio, 1500k bitrate, quality 11)
echo.
echo Options:
echo   [1] Convert single video file
echo   [2] Batch convert multiple videos
echo   [3] Advanced settings
echo   [4] Help
echo   [0] Exit
echo.
set /p "CHOICE=Enter your choice (0-4): "

if "%CHOICE%"=="1" goto SINGLE_CONVERT
if "%CHOICE%"=="2" goto BATCH_CONVERT
if "%CHOICE%"=="3" goto ADVANCED_SETTINGS
if "%CHOICE%"=="4" goto HELP
if "%CHOICE%"=="0" goto EXIT
echo Invalid choice. Please try again.
pause
goto MAIN_MENU

:: Check if FFmpeg exists
:CHECK_FFMPEG
:: First check if ffmpeg.exe exists in current directory
if exist "%FFMPEG_EXE%" (
    set "FFMPEG_PATH=%FFMPEG_EXE%"
    goto :EOF
)

:: If not found locally, check if it's available in PATH
where ffmpeg.exe >nul 2>&1
if not errorlevel 1 (
    set "FFMPEG_PATH=ffmpeg.exe"
    goto :EOF
)

:: FFmpeg not found anywhere
echo.
echo ERROR: FFmpeg not found!
echo Please ensure ffmpeg.exe is in the same directory as this script or is accessible in the current PATH.
echo You can download FFmpeg from: https://github.com/BtbN/FFmpeg-Builds/releases (win64 version)
echo.
pause
goto MAIN_MENU

:: Single file conversion
:SINGLE_CONVERT
call :CHECK_FFMPEG
cls
echo.
echo ===============================================================================
echo                           Single Video Conversion
echo ===============================================================================
echo.

:GET_INPUT_FILE
echo Enter the input video file path (or drag and drop the file here):
echo Supported formats: MP4, AVI, MKV, MOV, WMV, FLV, WEBM, M4V
echo.
set /p "INPUT_FILE=Input file: "

:: Remove quotes if present
set "INPUT_FILE=%INPUT_FILE:"=%"

:: Validate input file
if "%INPUT_FILE%"=="" (
    echo Error: No input file specified.
    echo.
    pause
    goto GET_INPUT_FILE
)

if not exist "%INPUT_FILE%" (
    echo Error: Input file does not exist: "%INPUT_FILE%"
    echo.
    pause
    goto GET_INPUT_FILE
)

:: Check if input file has video
echo.
echo Checking input file...
"%FFMPEG_PATH%" -i "%INPUT_FILE%" -hide_banner 2>temp_info.txt
findstr /i "video" temp_info.txt >nul
if errorlevel 1 (
    echo Error: No video stream found in the input file.
    del temp_info.txt 2>nul
    echo.
    pause
    goto GET_INPUT_FILE
)

:: Get video resolution info
echo Video file information:
findstr /i "Stream.*Video" temp_info.txt
findstr /i "Stream.*Audio" temp_info.txt
del temp_info.txt 2>nul

:: Get output file
:GET_OUTPUT_FILE
echo.
for %%f in ("%INPUT_FILE%") do set "BASE_NAME=%%~nf"
set "DEFAULT_OUTPUT=%BASE_NAME%_game2d.mpg"
echo Suggested output file: %DEFAULT_OUTPUT%
set /p "OUTPUT_FILE=Output file (press Enter for default): "

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=%DEFAULT_OUTPUT%"

:: Remove quotes if present
set "OUTPUT_FILE=%OUTPUT_FILE:"=%"

:: Ensure .mpg extension
for %%f in ("%OUTPUT_FILE%") do (
    if /i not "%%~xf"==".mpg" (
        set "OUTPUT_FILE=%%~nf.mpg"
        echo Note: Changed extension to .mpg: !OUTPUT_FILE!
    )
)

:: Check if output file already exists
if exist "%OUTPUT_FILE%" (
    echo.
    echo Warning: Output file already exists: "%OUTPUT_FILE%"
    set /p "OVERWRITE=Overwrite? (y/n): "
    if /i not "!OVERWRITE!"=="y" goto GET_OUTPUT_FILE
)

:: Check write permissions
echo test > "%OUTPUT_FILE%" 2>nul
if errorlevel 1 (
    echo Error: Cannot write to output location: "%OUTPUT_FILE%"
    echo.
    pause
    goto GET_OUTPUT_FILE
)
del "%OUTPUT_FILE%" 2>nul

:: Perform conversion
call :CONVERT_FILE "%INPUT_FILE%" "%OUTPUT_FILE%"
pause
goto MAIN_MENU

:: Batch conversion
:BATCH_CONVERT
call :CHECK_FFMPEG
cls
echo.
echo ===============================================================================
echo                           Batch Video Conversion
echo ===============================================================================
echo.
echo Enter the directory containing video files to convert:
set /p "BATCH_DIR=Directory path: "

:: Remove quotes if present
set "BATCH_DIR=%BATCH_DIR:"=%"

if "%BATCH_DIR%"=="" (
    echo Error: No directory specified.
    pause
    goto MAIN_MENU
)

if not exist "%BATCH_DIR%" (
    echo Error: Directory does not exist: "%BATCH_DIR%"
    pause
    goto MAIN_MENU
)

echo.
echo Scanning for supported video files...
set "FILE_COUNT=0"

for %%f in ("%BATCH_DIR%\*.mp4" "%BATCH_DIR%\*.avi" "%BATCH_DIR%\*.mkv" "%BATCH_DIR%\*.mov" "%BATCH_DIR%\*.wmv" "%BATCH_DIR%\*.flv" "%BATCH_DIR%\*.webm" "%BATCH_DIR%\*.m4v") do (
    if exist "%%f" (
        set /a FILE_COUNT+=1
        echo Found: %%~nxf
    )
)

if %FILE_COUNT%==0 (
    echo No supported video files found in the specified directory.
    pause
    goto MAIN_MENU
)

echo.
echo Found %FILE_COUNT% video file(s) to convert.
set /p "CONFIRM=Continue with batch conversion? (y/n): "
if /i not "%CONFIRM%"=="y" goto MAIN_MENU

echo.
echo Starting batch conversion...
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"

for %%f in ("%BATCH_DIR%\*.mp4" "%BATCH_DIR%\*.avi" "%BATCH_DIR%\*.mkv" "%BATCH_DIR%\*.mov" "%BATCH_DIR%\*.wmv" "%BATCH_DIR%\*.flv" "%BATCH_DIR%\*.webm" "%BATCH_DIR%\*.m4v") do (
    if exist "%%f" (
        set "OUTPUT_FILE=%%~dpnf_game2d.mpg"
        echo.
        echo Converting: %%~nxf
        call :CONVERT_FILE "%%f" "!OUTPUT_FILE!" BATCH
        if !ERROR_LEVEL!==0 (
            set /a SUCCESS_COUNT+=1
        ) else (
            set /a ERROR_COUNT+=1
        )
    )
)

echo.
echo ===============================================================================
echo Batch conversion completed!
echo Successfully converted: %SUCCESS_COUNT% file(s)
echo Errors: %ERROR_COUNT% file(s)
echo ===============================================================================
pause
goto MAIN_MENU

:: Advanced settings
:ADVANCED_SETTINGS
cls
echo.
echo ===============================================================================
echo                              Advanced Settings
echo ===============================================================================
echo.
echo Current settings:
echo   Video Quality: %VIDEO_QUALITY% (0=best, 31=worst)
echo   Video Bitrate: %VIDEO_BITRATE%
echo   Audio Codec: %AUDIO_CODEC%
echo.
echo [1] Change video quality (current: %VIDEO_QUALITY%)
echo [2] Change video bitrate (current: %VIDEO_BITRATE%)
echo [3] Change audio codec (current: %AUDIO_CODEC%)
echo [4] Reset to defaults
echo [0] Back to main menu
echo.
set /p "ADV_CHOICE=Enter your choice: "

if "%ADV_CHOICE%"=="1" goto CHANGE_VIDEO_QUALITY
if "%ADV_CHOICE%"=="2" goto CHANGE_VIDEO_BITRATE
if "%ADV_CHOICE%"=="3" goto CHANGE_AUDIO_CODEC
if "%ADV_CHOICE%"=="4" goto RESET_SETTINGS
if "%ADV_CHOICE%"=="0" goto MAIN_MENU
echo Invalid choice.
pause
goto ADVANCED_SETTINGS

:CHANGE_VIDEO_QUALITY
echo.
echo Video quality presets (q:v parameter):
echo   [1] Highest quality (q:v 0)
echo   [2] High quality (q:v 5)
echo   [3] Default quality (q:v 11)
echo   [4] Low quality (q:v 20)
echo   [5] Lowest quality (q:v 31)
echo   [6] Custom (0-31)
echo.
echo Note: Lower values = better quality, larger files
echo       Higher values = lower quality, smaller files
echo.
set /p "VQ_CHOICE=Choose quality preset: "

if "%VQ_CHOICE%"=="1" set "VIDEO_QUALITY=0"
if "%VQ_CHOICE%"=="2" set "VIDEO_QUALITY=5"
if "%VQ_CHOICE%"=="3" set "VIDEO_QUALITY=11"
if "%VQ_CHOICE%"=="4" set "VIDEO_QUALITY=20"
if "%VQ_CHOICE%"=="5" set "VIDEO_QUALITY=31"
if "%VQ_CHOICE%"=="6" (
    set /p "VIDEO_QUALITY=Enter quality value (0-31): "
)
echo Video quality set to: %VIDEO_QUALITY%
pause
goto ADVANCED_SETTINGS

:CHANGE_VIDEO_BITRATE
echo.
echo Video bitrate presets:
echo   [1] Low bitrate (800k)
echo   [2] Default bitrate (1500k)
echo   [3] High bitrate (3000k)
echo   [4] Very high bitrate (5000k)
echo   [5] Custom
echo.
echo Note: Higher bitrates = better quality, larger files
echo.
set /p "VB_CHOICE=Choose bitrate preset: "

if "%VB_CHOICE%"=="1" set "VIDEO_BITRATE=800k"
if "%VB_CHOICE%"=="2" set "VIDEO_BITRATE=1500k"
if "%VB_CHOICE%"=="3" set "VIDEO_BITRATE=3000k"
if "%VB_CHOICE%"=="4" set "VIDEO_BITRATE=5000k"
if "%VB_CHOICE%"=="5" (
    set /p "VIDEO_BITRATE=Enter bitrate (e.g. 2000k): "
)
echo Video bitrate set to: %VIDEO_BITRATE%
pause
goto ADVANCED_SETTINGS

:CHANGE_AUDIO_CODEC
echo.
echo Audio codec options:
echo   [1] MP2 (Default - MPEG1 compatible)
echo   [2] MP3 (More common, may not be fully MPEG1 compliant)
echo.
echo Note: MP2 is recommended for maximum MPEG1 compatibility
echo.
set /p "AC_CHOICE=Choose audio codec: "

if "%AC_CHOICE%"=="1" set "AUDIO_CODEC=mp2"
if "%AC_CHOICE%"=="2" set "AUDIO_CODEC=mp3"
echo Audio codec set to: %AUDIO_CODEC%
pause
goto ADVANCED_SETTINGS

:RESET_SETTINGS
set "VIDEO_QUALITY=11"
set "VIDEO_BITRATE=1500k"
set "AUDIO_CODEC=mp2"
echo Settings reset to defaults.
pause
goto ADVANCED_SETTINGS

:: Help section
:HELP
cls
echo.
echo ===============================================================================
echo                                    Help
echo ===============================================================================
echo.
echo ABOUT:
echo This tool converts video files to Game2D/Pyro compatible MPEG1 format.
echo Output format: MPEG1 video with MP2 audio in MPG container
echo.
echo SUPPORTED INPUT FORMATS:
echo   Video: MP4, AVI, MKV, MOV, WMV, FLV, WEBM, M4V
echo.
echo OUTPUT SPECIFICATIONS:
echo   - Video Codec: MPEG1Video
echo   - Audio Codec: MP2 (default) or MP3
echo   - Container: MPEG (MPG)
echo   - Default Quality: 11 (good balance)
echo   - Default Bitrate: 1500k
echo.
echo QUALITY SETTINGS:
echo   Video Quality (q:v): 0 (best) to 31 (worst)
echo   - Lower values = better quality, larger files
echo   - Higher values = lower quality, smaller files
echo   - Default: 11 (recommended balance)
echo.
echo FEATURES:
echo   - Single file conversion with drag-and-drop support
echo   - Batch conversion of entire directories
echo   - Configurable video quality and bitrate
echo   - Comprehensive error handling and validation
echo   - Progress indication during conversion
echo.
echo REQUIREMENTS:
echo   - FFmpeg.exe must be in the same directory as this script
echo   - Download from: https://ffmpeg.org/download.html
echo.
echo TIPS:
echo   - MPEG1 is an older format with compatibility limitations
echo   - Use quality 11 and 1500k bitrate for most applications
echo   - Lower quality settings reduce file size significantly
echo   - MP2 audio is recommended for maximum compatibility
echo.
echo For support, visit: https://github.com/tinyBigGAMES/Game2D
echo.
pause
goto MAIN_MENU

:: Conversion function
:CONVERT_FILE
set "INPUT=%~1"
set "OUTPUT=%~2"
set "BATCH_MODE=%~3"
set "ERROR_LEVEL=0"

if "%BATCH_MODE%"=="" (
    echo.
    echo ===============================================================================
    echo Converting: %~nx1
    echo Output: %~nx2
    echo Settings: Quality %VIDEO_QUALITY%, Bitrate %VIDEO_BITRATE%, Audio %AUDIO_CODEC%
    echo ===============================================================================
    echo.
    echo Please wait... This may take several minutes for large files.
    echo.
)

:: Perform the conversion
"%FFMPEG_PATH%" -i "%INPUT%" -c:v mpeg1video -q:v %VIDEO_QUALITY% -b:v %VIDEO_BITRATE% -c:a %AUDIO_CODEC% -format mpeg "%OUTPUT%" -loglevel error -stats -y

if errorlevel 1 (
    set "ERROR_LEVEL=1"
    echo.
    echo ERROR: Conversion failed for: %~nx1
    if exist "%OUTPUT%" del "%OUTPUT%"
) else (
    if "%BATCH_MODE%"=="" (
        echo.
        echo SUCCESS: Conversion completed successfully!
        echo Output file: %OUTPUT%
        
        :: Get file sizes for comparison
        for %%i in ("%INPUT%") do set "INPUT_SIZE=%%~zi"
        for %%i in ("%OUTPUT%") do set "OUTPUT_SIZE=%%~zi"
        
        set /a INPUT_MB=!INPUT_SIZE!/1048576
        set /a OUTPUT_MB=!OUTPUT_SIZE!/1048576
        
        echo.
        echo File size comparison:
        echo   Input:  !INPUT_MB! MB
        echo   Output: !OUTPUT_MB! MB
        
        :: Check if output file can be played
        echo.
        echo Verifying output file...
        "%FFMPEG_PATH%" -i "%OUTPUT%" -t 1 -f null - 2>nul
        if errorlevel 1 (
            echo Warning: Output file may have issues. Please test playback.
        ) else (
            echo Output file verification: OK
        )
        
        echo.
        set /p "OPEN_FOLDER=Open output folder? (y/n): "
        if /i "!OPEN_FOLDER!"=="y" (
            for %%f in ("%OUTPUT%") do explorer "%%~dpf"
        )
    ) else (
        echo   SUCCESS: %~nx2
    )
)
goto :EOF

:: Exit
:EXIT
cls
echo.
echo Thank you for using Game2D Video Converter!
echo.
pause
exit /b 0
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

@TITLE Game2D Audio Converter v1.0

:: Initialize variables
set "FFMPEG_EXE=ffmpeg.exe"
set "INPUT_FILE="
set "OUTPUT_FILE="
set "AUDIO_QUALITY=64k"
set "SAMPLE_RATE=48000"
set "ERROR_LEVEL=0"

:: Main menu
:MAIN_MENU
cls
echo.
echo ===============================================================================
echo                        Game2D Audio Converter v1.0
echo ===============================================================================
echo.
echo This tool converts audio/video files to Game2D compatible audio format
echo (48kHz, Vorbis OGG, 64k bitrate)
echo.
echo Options:
echo   [1] Convert single file
echo   [2] Batch convert multiple files
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
if not exist "%FFMPEG_EXE%" (
    echo.
    echo ERROR: FFmpeg not found!
    echo Please ensure ffmpeg.exe is in the same directory as this script or is accessable in the current PATH.
    echo You can download FFmpeg from: https://github.com/BtbN/FFmpeg-Builds/releases (win64 version)
    echo.
    pause
    goto MAIN_MENU
)
goto :EOF

:: Single file conversion
:SINGLE_CONVERT
call :CHECK_FFMPEG
cls
echo.
echo ===============================================================================
echo                           Single File Conversion
echo ===============================================================================
echo.

:GET_INPUT_FILE
echo Enter the input file path (or drag and drop the file here):
echo Supported formats: MP4, AVI, MKV, MOV, MP3, WAV, FLAC, AAC, M4A, WMA
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

:: Check if input file has audio
echo.
echo Checking input file...
"%FFMPEG_EXE%" -i "%INPUT_FILE%" -hide_banner 2>temp_info.txt
findstr /i "audio" temp_info.txt >nul
if errorlevel 1 (
    echo Error: No audio stream found in the input file.
    del temp_info.txt 2>nul
    echo.
    pause
    goto GET_INPUT_FILE
)
del temp_info.txt 2>nul

:: Get output file
:GET_OUTPUT_FILE
echo.
for %%f in ("%INPUT_FILE%") do set "BASE_NAME=%%~nf"
set "DEFAULT_OUTPUT=%BASE_NAME%_game2d.ogg"
echo Suggested output file: %DEFAULT_OUTPUT%
set /p "OUTPUT_FILE=Output file (press Enter for default): "

if "%OUTPUT_FILE%"=="" set "OUTPUT_FILE=%DEFAULT_OUTPUT%"

:: Remove quotes if present
set "OUTPUT_FILE=%OUTPUT_FILE:"=%"

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
echo                           Batch File Conversion
echo ===============================================================================
echo.
echo Enter the directory containing files to convert:
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
echo Scanning for supported files...
set "FILE_COUNT=0"

for %%f in ("%BATCH_DIR%\*.mp4" "%BATCH_DIR%\*.avi" "%BATCH_DIR%\*.mkv" "%BATCH_DIR%\*.mov" "%BATCH_DIR%\*.mp3" "%BATCH_DIR%\*.wav" "%BATCH_DIR%\*.flac" "%BATCH_DIR%\*.aac" "%BATCH_DIR%\*.m4a" "%BATCH_DIR%\*.wma") do (
    if exist "%%f" (
        set /a FILE_COUNT+=1
        echo Found: %%~nxf
    )
)

if %FILE_COUNT%==0 (
    echo No supported files found in the specified directory.
    pause
    goto MAIN_MENU
)

echo.
echo Found %FILE_COUNT% file(s) to convert.
set /p "CONFIRM=Continue with batch conversion? (y/n): "
if /i not "%CONFIRM%"=="y" goto MAIN_MENU

echo.
echo Starting batch conversion...
set "SUCCESS_COUNT=0"
set "ERROR_COUNT=0"

for %%f in ("%BATCH_DIR%\*.mp4" "%BATCH_DIR%\*.avi" "%BATCH_DIR%\*.mkv" "%BATCH_DIR%\*.mov" "%BATCH_DIR%\*.mp3" "%BATCH_DIR%\*.wav" "%BATCH_DIR%\*.flac" "%BATCH_DIR%\*.aac" "%BATCH_DIR%\*.m4a" "%BATCH_DIR%\*.wma") do (
    if exist "%%f" (
        set "OUTPUT_FILE=%%~dpnf_game2d.ogg"
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
echo   Sample Rate: %SAMPLE_RATE% Hz
echo   Audio Quality: %AUDIO_QUALITY%
echo.
echo [1] Change sample rate (current: %SAMPLE_RATE%)
echo [2] Change audio quality (current: %AUDIO_QUALITY%)
echo [3] Reset to defaults
echo [0] Back to main menu
echo.
set /p "ADV_CHOICE=Enter your choice: "

if "%ADV_CHOICE%"=="1" goto CHANGE_SAMPLE_RATE
if "%ADV_CHOICE%"=="2" goto CHANGE_QUALITY
if "%ADV_CHOICE%"=="3" goto RESET_SETTINGS
if "%ADV_CHOICE%"=="0" goto MAIN_MENU
echo Invalid choice.
pause
goto ADVANCED_SETTINGS

:CHANGE_SAMPLE_RATE
echo.
echo Common sample rates:
echo   [1] 44100 Hz (CD quality)
echo   [2] 48000 Hz (Default - recommended for games)
echo   [3] 22050 Hz (Lower quality, smaller files)
echo   [4] Custom
echo.
set /p "SR_CHOICE=Choose sample rate: "

if "%SR_CHOICE%"=="1" set "SAMPLE_RATE=44100"
if "%SR_CHOICE%"=="2" set "SAMPLE_RATE=48000"
if "%SR_CHOICE%"=="3" set "SAMPLE_RATE=22050"
if "%SR_CHOICE%"=="4" (
    set /p "SAMPLE_RATE=Enter custom sample rate: "
)
echo Sample rate set to: %SAMPLE_RATE%
pause
goto ADVANCED_SETTINGS

:CHANGE_QUALITY
echo.
echo Audio quality options:
echo   [1] 32k (Lower quality, smaller files)
echo   [2] 64k (Default - good balance)
echo   [3] 128k (Higher quality, larger files)
echo   [4] 192k (High quality)
echo   [5] Custom
echo.
set /p "Q_CHOICE=Choose quality: "

if "%Q_CHOICE%"=="1" set "AUDIO_QUALITY=32k"
if "%Q_CHOICE%"=="2" set "AUDIO_QUALITY=64k"
if "%Q_CHOICE%"=="3" set "AUDIO_QUALITY=128k"
if "%Q_CHOICE%"=="4" set "AUDIO_QUALITY=192k"
if "%Q_CHOICE%"=="5" (
    set /p "AUDIO_QUALITY=Enter custom bitrate (e.g. 96k): "
)
echo Audio quality set to: %AUDIO_QUALITY%
pause
goto ADVANCED_SETTINGS

:RESET_SETTINGS
set "SAMPLE_RATE=48000"
set "AUDIO_QUALITY=64k"
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
echo This tool converts audio/video files to Game2D compatible format using FFmpeg.
echo Output format: OGG Vorbis, 48kHz sample rate, 64k bitrate (configurable)
echo.
echo SUPPORTED INPUT FORMATS:
echo   Video: MP4, AVI, MKV, MOV (audio will be extracted)
echo   Audio: MP3, WAV, FLAC, AAC, M4A, WMA, OGG
echo.
echo FEATURES:
echo   - Single file conversion with drag-and-drop support
echo   - Batch conversion of entire directories
echo   - Configurable quality settings
echo   - Comprehensive error handling and validation
echo   - Progress indication during conversion
echo.
echo REQUIREMENTS:
echo   - FFmpeg.exe must be in the same directory as this script
echo   - Download from: https://ffmpeg.org/download.html
echo.
echo TIPS:
echo   - You can drag and drop files directly into the input prompt
echo   - Use batch mode for converting multiple files at once
echo   - Adjust quality settings for different file size requirements
echo   - 64k bitrate is recommended for most game audio
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
    echo Settings: %SAMPLE_RATE%Hz, %AUDIO_QUALITY% bitrate
    echo ===============================================================================
    echo.
    echo Please wait...
)

:: Perform the conversion
"%FFMPEG_EXE%" -i "%INPUT%" -ar %SAMPLE_RATE% -vn -c:a libvorbis -b:a %AUDIO_QUALITY% "%OUTPUT%" -loglevel error -stats -y

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
echo Thank you for using Game2D Audio Converter!
echo.
pause
exit /b 0
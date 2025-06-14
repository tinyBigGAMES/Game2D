{===============================================================================
    ___                ___ ___ ™
   / __|__ _ _ __  ___|_  )   \
  | (_ / _` | '  \/ -_)/ /| |) |
   \___\__,_|_|_|_\___/___|___/
        Build. Play. Repeat.

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/Game2D

 BSD 3-Clause License

 Copyright (c) 2025-present, tinyBigGAMES LLC

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
===============================================================================
Game2D.Core - Foundational Framework for 2D Game Development

The core foundation of the Game2D engine providing essential 2D math primitives,
window management, audio playback, texture rendering, I/O operations, and
comprehensive utility functions. This unit serves as the backbone for all other
Game2D components, delivering production-ready tools for building modern 2D games
with optimal performance and cross-platform compatibility.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════
Game2D.Core follows a modular static class architecture with these key systems:

• **Foundation Classes** - Base objects with error handling and lifecycle management
• **Math System** - Optimized 2D/3D vectors, rectangles, and mathematical utilities
• **Window Management** - Cross-platform windowing with OpenGL context and input
• **Audio Engine** - Multi-channel audio with music, sound effects, and spatial audio
• **Texture System** - Hardware-accelerated texture loading, rendering, and management
• **I/O Framework** - File, memory, and archive I/O with encryption support
• **Video Playback** - MPEG video streaming with audio synchronization
• **Utility Functions** - String processing, color manipulation, and helper routines

Key design patterns used:
• Static class pattern for global engine systems (no instantiation required)
• Resource management with automatic cleanup and reference counting
• OpenGL-based hardware acceleration with modern rendering pipeline
• Error handling system with detailed error reporting and recovery

The architecture emphasizes ease of use while providing advanced features for
professional game development, from simple prototypes to commercial releases.

═══════════════════════════════════════════════════════════════════════════════
MATHEMATICAL PRIMITIVES
═══════════════════════════════════════════════════════════════════════════════
Comprehensive 2D/3D math support with optimized operations for game logic:

• **Vector Operations** - Addition, subtraction, normalization, rotation
• **Distance Calculations** - Magnitude, distance between points, dot products
• **Geometric Utilities** - Point-in-shape tests, line intersections, ray casting
• **Interpolation** - Linear interpolation, easing functions, smooth movement
• **Random Generation** - Seeded random numbers, ranges, Boolean generation
• **Angle Mathematics** - Optimized sine/cosine tables, angle differences

BASIC VECTOR USAGE:
  var
    LPlayerPos: Tg2dVec;
    LTargetPos: Tg2dVec;
    LDirection: Tg2dVec;
    LDistance: Single;
  begin
    LPlayerPos := Tg2dVec.Create(100, 200);
    LTargetPos := Tg2dVec.Create(300, 400);

    LDistance := LPlayerPos.Distance(LTargetPos);
    LDirection := LTargetPos;
    LDirection.Subtract(LPlayerPos);
    LDirection.Normalize();

    // Move player towards target
    LDirection.Scale(5.0); // 5 pixels per frame
    LPlayerPos.Add(LDirection);
  end;

GEOMETRIC COLLISION DETECTION:
  var
    LBulletPos: Tg2dVec;
    LEnemyRect: Tg2dRect;
    LExplosionCenter: Tg2dVec;
    LExplosionRadius: Single;
  begin
    LBulletPos := Tg2dVec.Create(150, 180);
    LEnemyRect := Tg2dRect.Create(100, 150, 64, 64);
    LExplosionCenter := Tg2dVec.Create(200, 200);
    LExplosionRadius := 50.0;

    // Check bullet vs enemy collision
    if Tg2dMath.PointInRectangle(LBulletPos, LEnemyRect) then
      WriteLn('Hit enemy!');

    // Check if enemy is in explosion radius
    if Tg2dMath.PointInCircle(LEnemyRect.Pos, LExplosionCenter, LExplosionRadius) then
      WriteLn('Enemy caught in explosion!');
  end;

EASING AND INTERPOLATION:
  var
    LStartHealth: Single;
    LTargetHealth: Single;
    LCurrentHealth: Single;
    LProgress: Single;
  begin
    LStartHealth := 100.0;
    LTargetHealth := 0.0;
    LProgress := 0.7; // 70% through animation

    // Smooth health bar animation
    LCurrentHealth := Tg2dMath.Lerp(LStartHealth, LTargetHealth, LProgress);

    // Bouncy animation effect
    LProgress := Tg2dMath.Ease(LProgress, etOutBounce);
    LCurrentHealth := Tg2dMath.Lerp(LStartHealth, LTargetHealth, LProgress);
  end;

═══════════════════════════════════════════════════════════════════════════════
WINDOW AND GRAPHICS MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
Cross-platform windowing system with hardware-accelerated rendering:

• **Window Creation** - Customizable size, fullscreen, child windows, VSync
• **Input Handling** - Keyboard, mouse, gamepad support with state tracking
• **Rendering Context** - OpenGL setup, viewport management, clear operations
• **Frame Management** - VSync control, frame rate limiting, timing utilities
• **Event Processing** - Window events, resize handling, close callbacks

BASIC WINDOW SETUP:
  var
    LWindow: Tg2dWindow;
    LRunning: Boolean;
  begin
    LWindow := Tg2dWindow.Init('My Game', 800, 600);
    LWindow.SetVSync(True);
    LRunning := True;

    while LRunning and not LWindow.ShouldClose() do
    begin
      LWindow.StartFrame();

      if LWindow.IsReady() then
      begin
        // Handle input
        if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
          LRunning := False;

        if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
          LWindow.ToggleFullscreen();

        // Render
        LWindow.StartDrawing();
          LWindow.Clear(G2D_BLACK);
          LWindow.DrawFilledRect(100, 100, 50, 50, G2D_RED, 0);
        LWindow.EndDrawing();
      end;

      LWindow.EndFrame();
    end;

    LWindow.Free();
  end;

ADVANCED INPUT HANDLING:
  var
    LMousePos: Tg2dVec;
    LGamepadState: Tg2dGamepadState;
  begin
    // Mouse input
    LMousePos := LWindow.GetMousePos();
    if LWindow.GetMouseButton(G2D_MOUSE_BUTTON_LEFT, isPressed) then
      WriteLn('Clicking at: ', LMousePos.X:0:0, ', ', LMousePos.Y:0:0);

    // Gamepad input
    if LWindow.IsGamepadPresent(0) then
    begin
      LGamepadState := LWindow.GetGamepadState(0);
      if LGamepadState.Buttons[G2D_GAMEPAD_BUTTON_A] = isPressed then
        WriteLn('A button pressed');
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
AUDIO SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Professional multi-channel audio engine with comprehensive format support:

• **Music Playback** - Streaming audio, looping, volume control, format support
• **Sound Effects** - Multi-channel mixing, dynamic loading, spatial audio
• **Channel Management** - 16 simultaneous channels, dynamic allocation
• **Format Support** - OGG, MP3, WAV, FLAC through miniaudio integration
• **Archive Integration** - Load audio directly from encrypted ZIP archives

MUSIC AND SOUND SETUP:
  var
    LBulletSound: Integer;
    LExplosionSound: Integer;
  begin
    // Initialize audio system
    Tg2dAudio.Open();

    // Play background music
    Tg2dAudio.PlayMusicFromZipFile('assets.zip', 'music/theme.ogg', 0.7, True);

    // Load sound effects
    LBulletSound := Tg2dAudio.LoadSoundFromZipFile('assets.zip', 'sfx/bullet.wav');
    LExplosionSound := Tg2dAudio.LoadSoundFromZipFile('assets.zip', 'sfx/explosion.ogg');

    // Play sounds during gameplay
    Tg2dAudio.PlaySound(LBulletSound, G2D_AUDIO_CHANNEL_DYNAMIC, 0.5, False);
    Tg2dAudio.PlaySound(LExplosionSound, G2D_AUDIO_CHANNEL_DYNAMIC, 1.0, False);

    // Cleanup
    Tg2dAudio.UnloadSound(LBulletSound);
    Tg2dAudio.UnloadSound(LExplosionSound);
    Tg2dAudio.Close();
  end;

DYNAMIC AUDIO CONTROL:
  var
    LMusicVolume: Single;
  begin
    // Fade music in/out during gameplay
    LMusicVolume := Tg2dAudio.MusicVolume();
    if GameState = gsMenus then
      Tg2dAudio.SetMusicVolume(Tg2dMath.Lerp(LMusicVolume, 1.0, 0.05))
    else if GameState = gsPaused then
      Tg2dAudio.SetMusicVolume(Tg2dMath.Lerp(LMusicVolume, 0.3, 0.05));

    // Control global audio pause
    if GamePaused then
      Tg2dAudio.SetPause(True)
    else
      Tg2dAudio.SetPause(False);
  end;

═══════════════════════════════════════════════════════════════════════════════
TEXTURE SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Hardware-accelerated texture loading and rendering with advanced features:

• **Format Support** - PNG, JPG, BMP, TGA through stb_image integration
• **GPU Optimization** - Hardware texture compression, mipmapping, filtering
• **Batch Rendering** - Optimized sprite batching for maximum performance
• **Memory Management** - Automatic texture cleanup, reference counting
• **Archive Loading** - Direct loading from encrypted ZIP files

TEXTURE LOADING AND RENDERING:
  var
    LPlayerTexture: Tg2dTexture;
    LBackgroundTexture: Tg2dTexture;
    LPlayerPos: Tg2dVec;
  begin
    // Load textures from archive
    LPlayerTexture := Tg2dTexture.Init();
    LPlayerTexture.LoadFromZipFile('assets.zip', 'sprites/player.png');

    LBackgroundTexture := Tg2dTexture.Init();
    LBackgroundTexture.LoadFromZipFile('assets.zip', 'backgrounds/space.jpg');

    LPlayerPos := Tg2dVec.Create(400, 300);

    // Render in game loop
    LWindow.StartDrawing();
      // Tiled background
      LBackgroundTexture.DrawTiled(0, 0, LWindow.GetVirtualSize().Width,
        LWindow.GetVirtualSize().Height);

      // Player sprite with transformations
      LPlayerTexture.Draw(LPlayerPos.X, LPlayerPos.Y, 1.0, 45.0, G2D_WHITE, False, False);
    LWindow.EndDrawing();

    // Cleanup
    LPlayerTexture.Free();
    LBackgroundTexture.Free();
  end;

ADVANCED TEXTURE OPERATIONS:
  var
    LTexture: Tg2dTexture;
    LSourceRect: Tg2dRect;
    LDestRect: Tg2dRect;
  begin
    LTexture := Tg2dTexture.Init();
    LTexture.LoadFromFile('spritesheet.png');

    // Draw specific region (sprite from atlas)
    LSourceRect := Tg2dRect.Create(64, 0, 32, 32); // Source region
    LDestRect := Tg2dRect.Create(100, 100, 64, 64); // Destination (scaled 2x)
    LTexture.DrawRect(LSourceRect, LDestRect, 0, G2D_WHITE, False, False);

    LTexture.Free();
  end;

═══════════════════════════════════════════════════════════════════════════════
I/O SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Comprehensive file and archive I/O with encryption and compression support:

• **File Operations** - Standard file I/O with modern Delphi integration
• **Memory Streams** - In-memory I/O for temporary data and processing
• **Archive Support** - ZIP file reading with password protection
• **Encryption** - AES encryption for secure asset protection
• **Stream Interface** - Unified interface for all I/O operations

FILE AND MEMORY I/O:
  var
    LFileIO: Tg2dFileIO;
    LMemIO: Tg2dMemoryIO;
    LData: array[0..255] of Byte;
    LBytesRead: Int64;
  begin
    // File I/O
    LFileIO := Tg2dFileIO.Create();
    try
      if LFileIO.Open('savegame.dat', iomRead) then
      begin
        LBytesRead := LFileIO.Read(@LData[0], SizeOf(LData));
        WriteLn('Read ', LBytesRead, ' bytes from file');
      end;
    finally
      LFileIO.Free();
    end;

    // Memory I/O
    LMemIO := Tg2dMemoryIO.Create();
    try
      LMemIO.Open(1024); // 1KB buffer
      LMemIO.Write(@LData[0], 256);
      LMemIO.Seek(0, smFromBeginning);
      LMemIO.Read(@LData[0], 256);
    finally
      LMemIO.Free();
    end;
  end;

ARCHIVE OPERATIONS:
  var
    LZipIO: Tg2dZipFileIO;
    LArchiveFiles: TArray<string>;
    LPassword: string;
  begin
    LPassword := 'my_secure_password';

    // Create encrypted archive
    Tg2dZipFileIO.Build('assets.zip', 'assets_folder', LPassword,
      procedure(const AFilename: string; const AProgress: Integer; const ANewFile: Boolean)
      begin
        if ANewFile then
          WriteLn('Adding: ', AFilename);
        WriteLn('Progress: ', AProgress, '%');
      end);

    // Read from archive
    LZipIO := Tg2dZipFileIO.Create();
    try
      if LZipIO.Open('assets.zip', 'config/settings.json', LPassword) then
      begin
        // Process file data...
      end;
    finally
      LZipIO.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
VIDEO PLAYBACK
═══════════════════════════════════════════════════════════════════════════════
MPEG video streaming with synchronized audio and texture integration:

• **Format Support** - MPEG-1 video with audio tracks through PL_MPEG
• **Streaming Playback** - Memory-efficient streaming for large video files
• **Audio Sync** - Synchronized audio playback with video frames
• **Texture Output** - Video frames rendered as textures for integration
• **Callback System** - Status callbacks for video events and state changes

VIDEO PLAYBACK INTEGRATION:
  var
    LVideoCallback: Tg2dVideoStatusCallback;
  begin
    LVideoCallback := procedure(const AStatus: Tg2dVideoStatus;
      const AFilename: string; const AUserData: Pointer)
    begin
      case AStatus of
        vsPlaying: WriteLn('Video started: ', AFilename);
        vsStopped: WriteLn('Video finished: ', AFilename);
        vsError: WriteLn('Video error: ', AFilename);
      end;
    end;

    Tg2dVideo.SetStatusCallback(LVideoCallback, nil);

    // Play video with scaling
    if Tg2dVideo.PlayFromZipFile('assets.zip', 'intro.mpg', 1.0, False) then
    begin
      while Tg2dVideo.Status() = vsPlaying do
      begin
        LWindow.StartFrame();
          LWindow.StartDrawing();
            LWindow.Clear(G2D_BLACK);
            Tg2dVideo.Draw(0, 0, 0.5); // 50% scale
          LWindow.EndDrawing();
        LWindow.EndFrame();
      end;
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION EXAMPLES
═══════════════════════════════════════════════════════════════════════════════
Real-world examples showing how different systems work together:

COMPLETE GAME INITIALIZATION:
  var
    LWindow: Tg2dWindow;
    LFont: Tg2dFont;
    LPlayerTexture: Tg2dTexture;
    LPlayerPos: Tg2dVec;
    LJumpSound: Integer;
  begin
    // Initialize core systems
    LWindow := Tg2dWindow.Init('Platform Game', 1024, 768);
    LWindow.SetVSync(True);

    Tg2dAudio.Open();

    // Load resources from encrypted archive
    LFont := Tg2dFont.Init(LWindow);
    LPlayerTexture := Tg2dTexture.Init();
    LPlayerTexture.LoadFromZipFile('game_assets.zip', 'player.png', 'secret_key');

    LJumpSound := Tg2dAudio.LoadSoundFromZipFile('game_assets.zip', 'jump.wav', 'secret_key');

    Tg2dAudio.PlayMusicFromZipFile('game_assets.zip', 'background.ogg', 0.6, True, 'secret_key');

    LPlayerPos := Tg2dVec.Create(100, 400);

    // Game loop with integrated systems
    while not LWindow.ShouldClose() do
    begin
      LWindow.StartFrame();

      if LWindow.IsReady() then
      begin
        // Input handling
        if LWindow.GetKey(G2D_KEY_SPACE, isWasPressed) then
          Tg2dAudio.PlaySound(LJumpSound, G2D_AUDIO_CHANNEL_DYNAMIC, 0.8, False);

        if LWindow.GetKey(G2D_KEY_LEFT, isPressed) then
          LPlayerPos.X := LPlayerPos.X - 5.0;

        if LWindow.GetKey(G2D_KEY_RIGHT, isPressed) then
          LPlayerPos.X := LPlayerPos.X + 5.0;

        // Rendering
        LWindow.StartDrawing();
          LWindow.Clear(G2D_SKYBLUE);
          LPlayerTexture.Draw(LPlayerPos.X, LPlayerPos.Y, 1.0, 0, G2D_WHITE, False, False);
          LFont.DrawText(LWindow, 10, 10, 0, 16, G2D_WHITE, haLeft,
            'FPS: %d', [LWindow.GetFrameRate()]);
        LWindow.EndDrawing();
      end;

      LWindow.EndFrame();
    end;

    // Cleanup
    Tg2dAudio.UnloadSound(LJumpSound);
    Tg2dAudio.Close();
    LPlayerTexture.Free();
    LFont.Free();
    LWindow.Free();
  end;

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════
• **Hardware Acceleration** - OpenGL 2.1+ with optimized rendering pipeline
• **Batch Rendering** - Automatic sprite batching for optimal draw call reduction
• **Memory Pooling** - Object pooling for frequently allocated resources
• **Optimized Math** - Pre-calculated sine/cosine tables, SIMD-friendly operations
• **Resource Caching** - Intelligent texture and audio caching systems
• **Frame Rate Control** - VSync, frame limiting, and timing optimization

═══════════════════════════════════════════════════════════════════════════════
VIRTUAL METHODS FOR CUSTOMIZATION
═══════════════════════════════════════════════════════════════════════════════
Base classes provide virtual methods for extending functionality:

• **Tg2dObject.OnError()** - Custom error handling implementation
• **I/O Classes** - Virtual Read(), Write(), Seek() methods for custom streams
• **Window Callbacks** - Custom event handling for specialized input processing

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
• **RAII Pattern** - Objects automatically cleanup resources in destructors
• **Reference Counting** - Smart resource management for textures and audio
• **Static Lifetime** - Static classes manage global state automatically
• **Manual Cleanup** - Explicit Free() calls for game objects and resources
• **Error Recovery** - Graceful handling of resource allocation failures

═══════════════════════════════════════════════════════════════════════════════
THREADING CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════
• **Main Thread Only** - All Game2D operations must occur on the main thread
• **Audio Threading** - Internal audio processing uses worker threads safely
• **Resource Loading** - Consider background loading for large assets
• **Frame Timing** - VSync and frame rate control handle threading internally

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════
• **Boolean Return Values** - Success/failure indicators for all operations
• **Exception Safety** - No exceptions thrown; check return values
• **Error Messages** - Detailed error information through Tg2dObject.GetError()
• **Graceful Degradation** - Systems continue operating despite partial failures
• **Resource Validation** - Automatic validation of file formats and data integrity

═══════════════════════════════════════════════════════════════════════════════
COMPLETE EXAMPLE - ASTEROID GAME FOUNDATION
═══════════════════════════════════════════════════════════════════════════════
procedure CreateAsteroidGame();
var
  LWindow: Tg2dWindow;
  LFont: Tg2dFont;
  LShipTexture: Tg2dTexture;
  LShipPos: Tg2dVec;
  LShipVel: Tg2dVec;
  LShipAngle: Single;
  LThrustSound: Integer;
  LShootSound: Integer;
  LBackgroundTexture: Tg2dTexture;
  LHudPos: Tg2dVec;
  LScore: Integer;
begin
  // === INITIALIZATION ===
  LWindow := Tg2dWindow.Init('Asteroid Game', 1024, 768);
  LWindow.SetVSync(True);
  LWindow.SetSizeLimits(640, 480, G2D_DONT_CARE, G2D_DONT_CARE);

  Tg2dAudio.Open();

  // Load all resources from encrypted game archive
  LFont := Tg2dFont.Init(LWindow);

  LShipTexture := Tg2dTexture.Init();
  LShipTexture.LoadFromZipFile('game.zip', 'ship.png', 'game_password');

  LBackgroundTexture := Tg2dTexture.Init();
  LBackgroundTexture.LoadFromZipFile('game.zip', 'starfield.jpg', 'game_password');

  LThrustSound := Tg2dAudio.LoadSoundFromZipFile('game.zip', 'thrust.wav', 'game_password');
  LShootSound := Tg2dAudio.LoadSoundFromZipFile('game.zip', 'laser.wav', 'game_password');

  Tg2dAudio.PlayMusicFromZipFile('game.zip', 'space_theme.ogg', 0.7, True, 'game_password');

  // Initialize game state
  LShipPos := Tg2dVec.Create(512, 384);
  LShipVel := Tg2dVec.Create(0, 0);
  LShipAngle := 0;
  LScore := 0;
  LHudPos := Tg2dVec.Create(10, 10);

  // === MAIN GAME LOOP ===
  while not LWindow.ShouldClose() do
  begin
    LWindow.StartFrame();

    if LWindow.IsReady() then
    begin
      // === INPUT HANDLING ===
      if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
        LWindow.SetShouldClose(True);

      if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
        LWindow.ToggleFullscreen();

      // Ship rotation
      if LWindow.GetKey(G2D_KEY_LEFT, isPressed) then
        LShipAngle := LShipAngle - 5.0;

      if LWindow.GetKey(G2D_KEY_RIGHT, isPressed) then
        LShipAngle := LShipAngle + 5.0;

      // Ship thrust
      if LWindow.GetKey(G2D_KEY_UP, isPressed) then
      begin
        LShipVel.Thrust(LShipAngle, 0.5);
        if LWindow.GetKey(G2D_KEY_UP, isWasPressed) then
          Tg2dAudio.PlaySound(LThrustSound, G2D_AUDIO_CHANNEL_DYNAMIC, 0.6, False);
      end;

      // Shooting
      if LWindow.GetKey(G2D_KEY_SPACE, isWasPressed) then
        Tg2dAudio.PlaySound(LShootSound, G2D_AUDIO_CHANNEL_DYNAMIC, 0.8, False);

      // === GAME PHYSICS ===
      // Apply velocity to position
      LShipPos.Add(LShipVel);

      // Apply drag
      LShipVel.Scale(0.98);

      // Screen wrapping
      if LShipPos.X < 0 then LShipPos.X := LWindow.GetVirtualSize().Width;
      if LShipPos.X > LWindow.GetVirtualSize().Width then LShipPos.X := 0;
      if LShipPos.Y < 0 then LShipPos.Y := LWindow.GetVirtualSize().Height;
      if LShipPos.Y > LWindow.GetVirtualSize().Height then LShipPos.Y := 0;

      // === RENDERING ===
      LWindow.StartDrawing();
        // Scrolling background
        LBackgroundTexture.DrawTiled(0, 0,
          LWindow.GetVirtualSize().Width, LWindow.GetVirtualSize().Height);

        // Ship with rotation
        LShipTexture.Draw(LShipPos.X, LShipPos.Y, 1.0, LShipAngle,
          G2D_WHITE, False, False);

        // HUD
        LHudPos.Assign(10, 10);
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, 18, G2D_WHITE, haLeft,
          'SCORE: %d', [LScore]);
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, 16, G2D_YELLOW, haLeft,
          'FPS: %d', [LWindow.GetFrameRate()]);
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, 14, G2D_CYAN, haLeft,
          'ARROWS: Rotate/Thrust  SPACE: Shoot  ESC: Quit  F11: Fullscreen');

      LWindow.EndDrawing();
    end;

    LWindow.EndFrame();
  end;

  // === CLEANUP ===
  Tg2dAudio.UnloadSound(LThrustSound);
  Tg2dAudio.UnloadSound(LShootSound);
  Tg2dAudio.Close();

  LBackgroundTexture.Free();
  LShipTexture.Free();
  LFont.Free();
  LWindow.Free();
end;

===============================================================================}

unit Game2D.Core;

{$I Game2D.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.Types,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Math,
  Game2D.Deps,
  Game2D.OpenGL,
  Game2D.Common;

//=== VERSION ==================================================================
const
  G2D_MAJOR_VERSION = '0';
  G2D_MINOR_VERSION = '1';
  G2D_PATCH_VERSION = '0';
  G2D_VERSION       = G2D_MAJOR_VERSION + '.' + G2D_MINOR_VERSION + '.' + G2D_PATCH_VERSION;

//=== MATH =====================================================================
const
  pxRAD2DEG = 180.0 / PI;
  pxDEG2RAD = PI / 180.0;
  pxEPSILON = 0.00001;
  pxNaN     =  0.0 / 0.0;

type
  { Tg2dVec }
  Tg2dVec = record
    X: Single;
    Y: Single;
    Z: Single;
    W: Single;
    constructor Create(const AX, AY: Single); overload;
    constructor Create(const AX, AY, AZ: Single); overload;
    constructor Create(const AX, AY, AZ, AW: Single); overload;
    procedure Assign(const AX, AY: Single); overload;
    procedure Assign(const AX, AY, AZ: Single); overload;
    procedure Assign(const AX, AY, AZ, AW: Single); overload;
    procedure Assign(const aVector: Tg2dVec); overload;
    procedure Clear();
    procedure Add(const aVector: Tg2dVec);
    procedure Subtract(const aVector: Tg2dVec);
    procedure Multiply(const aVector: Tg2dVec);
    procedure Divide(const aVector: Tg2dVec);
    function  Magnitude(): Single;
    function  MagnitudeTruncate(const aMaxMagitude: Single): Tg2dVec;
    function  Distance(const AVector: Tg2dVec): Single;
    procedure Normalize();
    function  Angle(const AVector: Tg2dVec): Single;
    procedure Thrust(const AAngle, ASpeed: Single);
    function  MagnitudeSquared(): Single;
    function  DotProduct(const AVector: Tg2dVec): Single;
    procedure Scale(const AValue: Single);
    procedure DivideBy(const AValue: Single);
    function  Project(const AVector: Tg2dVec): Tg2dVec;
    procedure Negate();
  end;

  { Tg2dSize }
  Tg2dSize = record
    Width: Single;
    Height: Single;
    constructor Create(const AWidth, AHeight: Single);
  end;

  { Tg2dRect }
  Tg2dRect = record
    Pos: Tg2dVec;
    Size: Tg2dSize;
    constructor Create(const AX, AY, AWidth, AHeight: Single); overload;
    constructor Create(const APos: Tg2dVec; const ASize: Tg2dSize); overload;
    procedure Assign(const AX, AY, AW, AH: Single); overload;
    procedure Assign(const ARect: Tg2dRect); overload;
    procedure Clear();
    function Intersect(const ARect: Tg2dRect): Boolean;
  end;

  { Tg2dRange }
  Tg2dRange = record
    MinX: Single;
    MinY: Single;
    MaxX: Single;
    MaxY: Single;
    constructor Create(const AMinX, AMinY, AMaxX, AMaxY: Single);
  end;

  { Tg2dEaseType }
  Tg2dEaseType = (
    etLinearTween,
    etInQuad,
    etOutQuad,
    etInOutQuad,
    etInCubic,
    etOutCubic,
    etInOutCubic,
    etInQuart,
    etOutQuart,
    etInOutQuart,
    etInQuint,
    etOutQuint,
    etInOutQuint,
    etInSine,
    etOutSine,
    etInOutSine,
    etInExpo,
    etOutExpo,
    etInOutExpo,
    etInCircle,
    etOutCircle,
    etInOutCircle,
    etInElastic,
    etOutElastic,
    etInOutElastic,
    etInBack,
    etOutBack,
    etInOutBack,
    etInBounce,
    etOutBounce,
    etInOutBounce
  );

  { Tg2dLoopMode }
  Tg2dLoopMode = (
    pxLoopNone,
    pxLoopRepeat,
    pxLoopPingPong,
    pxLoopReverse
  );

  { Tg2dEaseParams }
  Tg2dEaseParams = record
    Amplitude: Double;
    Period: Double;
    Overshoot: Double;
  end;

  { Tg2dLineIntersection }
  Tg2dLineIntersection = (
    liNone,
    liTrue,
    liParallel
  );

  { Tg2dRay }
  Tg2dRay = record
    Origin: Tg2dVec;
    Direction: Tg2dVec;
  end;

  { Tg2dOBB }
  Tg2dOBB = record
    Center: Tg2dVec;
    HalfWidth: Single;
    HalfHeight: Single;
    Rotation: Single;
  end;

  { Tg2dMath }
  Tg2dMath = class(Tg2dStaticObject)
  private class var
    FCosTable: array [0 .. 360] of Single;
    FSinTable: array [0 .. 360] of Single;
  private
    class constructor Create();
    class destructor  Destroy();
  public
    class function  RandomRangeInt(const AMin, AMax: Integer): Integer; static;
    class function  RandomRangeFloat(const AMin, AMax: Single): Single; static;
    class function  RandomBool(): Boolean; static;
    class function  GetRandomSeed(): Integer; static;
    class procedure SetRandomSeed(const AValue: Integer); static;
    class function  AngleCos(const AAngle: Integer): Single; static;
    class function  AngleSin(const AAngle: Integer): Single; static;
    class function  AngleDifference(const ASrcAngle, ADestAngle: Single): Single; static;
    class procedure AngleRotatePos(const AAngle: Single; var AX: Single; var AY: Single); static;
    class function  ClipValueFloat(var AValue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single; static;
    class function  ClipValueInt(var AValue: Integer; const AMin, AMax: Integer; const AWrap: Boolean): Integer; static;
    class function  SameSignExt(const AValue1, AValue2: Integer): Boolean; static;
    class function  SameSignFloat(const AValue1, AValue2: Single): Boolean; static;
    class function  SameValueExt(const AA, AB: Double; const AEpsilon: Double = 0): Boolean; static;
    class function  SameValueFloat(const AA, AB: Single; const AEpsilon: Single = 0): Boolean; static;
    class procedure SmoothMove(var AValue: Single; const AAmount, AMax, ADrag: Single); static;
    class function  Lerp(const AFrom, ATo, ATime: Double): Double; static;
    class function  PointInRectangle(const APoint: Tg2dVec; const ARect: Tg2dRect): Boolean;
    class function  PointInCircle(const APoint, ACenter: Tg2dVec; const ARadius: Single): Boolean;
    class function  PointInTriangle(const APoint, APoint1, APoint2, APoint3: Tg2dVec): Boolean;
    class function  CirclesOverlap(const ACenter1: Tg2dVec; const ARadius1: Single; const ACenter2: Tg2dVec; const ARadius2: Single): Boolean;
    class function  CircleInRectangle(const ACenter: Tg2dVec; const ARadius: Single; const ARect: Tg2dRect): Boolean;
    class function  RectanglesOverlap(const ARect1, ARect2: Tg2dRect): Boolean;
    class function  RectangleIntersection(const ARect1, ARect2: Tg2dRect): Tg2dRect;
    class function  LineIntersection(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Integer; var AX: Integer; var AY: Integer): Tg2dLineIntersection;
    class function  PointToLineDistance(const APoint, ALineStart, ALineEnd: Tg2dVec): Single;
    class function  PointToLineSegmentDistance(const APoint, ALineStart, ALineEnd: Tg2dVec): Single;
    class function  LineSegmentIntersectsCircle(const ALineStart, ALineEnd, ACenter: Tg2dVec; const ARadius: Single): Boolean;
    class function  ClosestPointOnLineSegment(const APoint, ALineStart, ALineEnd: Tg2dVec): Tg2dVec;
    class function  OBBsOverlap(const AOBB1, AOBB2: Tg2dOBB): Boolean;
    class function  PointInConvexPolygon(const APoint: Tg2dVec; const AVertices: array of Tg2dVec): Boolean;
    class function  RayIntersectsAABB(const ARay: Tg2dRay; const ARect: Tg2dRect; out ADistance: Single): Boolean;
    class function  EaseValue(const ACurrentTime, AStartValue, AChangeInValue, ADuration: Double; const AEase: Tg2dEaseType): Double; static;
    class function  EasePosition(const AStartPos, AEndPos, ACurrentPos: Double; const AEase: Tg2dEaseType): Double; static;
    class function  EaseNormalized(const AProgress: Double; const AEase: Tg2dEaseType): Double;
    class function  EaseLerp(const AFrom, ATo: Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
    class function  EaseVector(const AFrom, ATo: Tg2dVec; const AProgress: Double; const AEase: Tg2dEaseType): Tg2dVec;
    class function  EaseSmooth(const AFrom, ATo: Double; const AProgress: Double): Double;
    class function  EaseAngle(const AFrom, ATo: Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
    class function  EaseKeyframes(const AKeyframes: array of Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
    class function  EaseLoop(const ATime, ADuration: Double; const AEase: Tg2dEaseType; const ALoopMode: Tg2dLoopMode): Double;
    class function  EaseStepped(const AFrom, ATo: Double; const AProgress: Double; const ASteps: Integer; const AEase: Tg2dEaseType): Double;
    class function  EaseSpring(const ATime: Double; const AAmplitude: Double = 1.0; const APeriod: Double = 0.3): Double;
    class function  EaseBezier(const AProgress: Double; const AX1, AY1, AX2, AY2: Double): Double;
    class function  EaseWithParams(const AProgress: Double; const AEase: Tg2dEaseType; const AParams: Tg2dEaseParams): Double;
    class function  IfThen(const ACondition: Boolean; const ATrueValue, AFalseValue: string): string; overload; static; inline;
    class function  FloatToStr(const AValue: Single): string; overload; static; inline;


  end;

//=== IO =======================================================================
type
  { Tg2dIO }
  Tg2dIO = class(Tg2dObject)
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  IsOpen(): Boolean; virtual;
    procedure Close(); virtual;
    function  Size(): Int64; virtual;
    function  Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64; virtual;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; virtual;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; virtual;
    function  Pos(): Int64; virtual;
    function  Eos(): Boolean; virtual;
  end;

  { Tg2dMemoryIO }
  Tg2dMemoryIO = class(Tg2dIO)
  protected
    FHandle: TMemoryStream;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function  Open(const AData: Pointer; ASize: Int64): Boolean; overload;
    function  Open(const ASize: Int64): Boolean; overload;
    function  Memory(): Pointer;
    function  SaveToFile(const AFilename: string): Boolean;
  end;

  { Tg2dFileIO }
  Tg2dFileIO = class(Tg2dIO)
  protected
    FHandle: TFileStream;
    FMode: Tg2dIOMode;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function  Open(const AFilename: string; const AMode: Tg2dIOMode): Boolean;
  end;

const
  { G2D_DEFAULT_ZIPFILE_PASSWORD }
  G2D_DEFAULT_ZIPFILE_PASSWORD = 'N^TpjE5/*czG,<ns>$}w;?x_uBm9[JSr{(+FRv7ZW@C-gd3D!PRUgWE4P2/wpm9-dt^Y?e)Az+xsMb@jH"!X`B3ar(yq=nZ_~85<';

type
  { Tg2dZipFileIOBuildProgressCallback }
  Tg2dZipFileIOBuildProgressCallback = reference to procedure(const AFilename: string; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer);

  { Tg2dZipFileIO }
  Tg2dZipFileIO = class(Tg2dIO)
  protected
    FHandle: unzFile;
    FPassword: AnsiString;
    FFilename: AnsiString;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function Open(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    class function Init(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dZipFileIO; static;
    class function Load(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dMemoryIO; static;
    class function Build(const AZipFilename, ADirectoryName: string; const AHandler: Tg2dZipFileIOBuildProgressCallback=nil; const AUserData: Pointer=nil; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
  end;

//=== COLOR ====================================================================
type
  { Tg2dColor }
  Pg2dColor = ^Tg2dColor;
  Tg2dColor = record
    Red: Single;
    Green: Single;
    Blue: Single;
    Alpha: Single;
    constructor Create(const ARed, AGreen, ABlue, AAlpha: Single);
    procedure FromByte(const ARed, AGreen, ABlue, AAlpha: Byte);
    procedure FromFloat(const ARed, AGreen, ABlue, AAlpha: Single);
    procedure Fade(const ATo: Tg2dColor; const APos: Single);
    function  IsEqual(const AColor: Tg2dColor): Boolean;
  end;

{$REGION ' COMMON COLORS '}
const
  G2D_ALICEBLUE           : Tg2dColor = (Red:$F0/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_ANTIQUEWHITE        : Tg2dColor = (Red:$FA/$FF; Green:$EB/$FF; Blue:$D7/$FF; Alpha:$FF/$FF);
  G2D_AQUA                : Tg2dColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_AQUAMARINE          : Tg2dColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$D4/$FF; Alpha:$FF/$FF);
  G2D_AZURE               : Tg2dColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_BEIGE               : Tg2dColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  G2D_BISQUE              : Tg2dColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$C4/$FF; Alpha:$FF/$FF);
  G2D_BLACK               : Tg2dColor = (Red:$00/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_BLANCHEDALMOND      : Tg2dColor = (Red:$FF/$FF; Green:$EB/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  G2D_BLUE                : Tg2dColor = (Red:$00/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_BLUEVIOLET          : Tg2dColor = (Red:$8A/$FF; Green:$2B/$FF; Blue:$E2/$FF; Alpha:$FF/$FF);
  G2D_BROWN               : Tg2dColor = (Red:$A5/$FF; Green:$2A/$FF; Blue:$2A/$FF; Alpha:$FF/$FF);
  G2D_BURLYWOOD           : Tg2dColor = (Red:$DE/$FF; Green:$B8/$FF; Blue:$87/$FF; Alpha:$FF/$FF);
  G2D_CADETBLUE           : Tg2dColor = (Red:$5F/$FF; Green:$9E/$FF; Blue:$A0/$FF; Alpha:$FF/$FF);
  G2D_CHARTREUSE          : Tg2dColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_CHOCOLATE           : Tg2dColor = (Red:$D2/$FF; Green:$69/$FF; Blue:$1E/$FF; Alpha:$FF/$FF);
  G2D_CORAL               : Tg2dColor = (Red:$FF/$FF; Green:$7F/$FF; Blue:$50/$FF; Alpha:$FF/$FF);
  G2D_CORNFLOWERBLUE      : Tg2dColor = (Red:$64/$FF; Green:$95/$FF; Blue:$ED/$FF; Alpha:$FF/$FF);
  G2D_CORNSILK            : Tg2dColor = (Red:$FF/$FF; Green:$F8/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  G2D_CRIMSON             : Tg2dColor = (Red:$DC/$FF; Green:$14/$FF; Blue:$3C/$FF; Alpha:$FF/$FF);
  G2D_CYAN                : Tg2dColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_DARKBLUE            : Tg2dColor = (Red:$00/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  G2D_DARKCYAN            : Tg2dColor = (Red:$00/$FF; Green:$8B/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  G2D_DARKGOLDENROD       : Tg2dColor = (Red:$B8/$FF; Green:$86/$FF; Blue:$0B/$FF; Alpha:$FF/$FF);
  G2D_DARKGRAY            : Tg2dColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  G2D_DARKGREEN           : Tg2dColor = (Red:$00/$FF; Green:$64/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_DARKGREY            : Tg2dColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  G2D_DARKKHAKI           : Tg2dColor = (Red:$BD/$FF; Green:$B7/$FF; Blue:$6B/$FF; Alpha:$FF/$FF);
  G2D_DARKMAGENTA         : Tg2dColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  G2D_DARKOLIVEGREEN      : Tg2dColor = (Red:$55/$FF; Green:$6B/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  G2D_DARKORANGE          : Tg2dColor = (Red:$FF/$FF; Green:$8C/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_DARKORCHID          : Tg2dColor = (Red:$99/$FF; Green:$32/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  G2D_DARKRED             : Tg2dColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_DARKSALMON          : Tg2dColor = (Red:$E9/$FF; Green:$96/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  G2D_DARKSEAGREEN        : Tg2dColor = (Red:$8F/$FF; Green:$BC/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  G2D_DARKSLATEBLUE       : Tg2dColor = (Red:$48/$FF; Green:$3D/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  G2D_DARKSLATEGRAY       : Tg2dColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  G2D_DARKSLATEGREY       : Tg2dColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  G2D_DARKTURQUOISE       : Tg2dColor = (Red:$00/$FF; Green:$CE/$FF; Blue:$D1/$FF; Alpha:$FF/$FF);
  G2D_DARKVIOLET          : Tg2dColor = (Red:$94/$FF; Green:$00/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  G2D_DEEPPINK            : Tg2dColor = (Red:$FF/$FF; Green:$14/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  G2D_DEEPSKYBLUE         : Tg2dColor = (Red:$00/$FF; Green:$BF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_DIMGRAY             : Tg2dColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  G2D_DIMGREY             : Tg2dColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  G2D_DODGERBLUE          : Tg2dColor = (Red:$1E/$FF; Green:$90/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_FIREBRICK           : Tg2dColor = (Red:$B2/$FF; Green:$22/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  G2D_FLORALWHITE         : Tg2dColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  G2D_FORESTGREEN         : Tg2dColor = (Red:$22/$FF; Green:$8B/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  G2D_FUCHSIA             : Tg2dColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_GAINSBORO           : Tg2dColor = (Red:$DC/$FF; Green:$DC/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  G2D_GHOSTWHITE          : Tg2dColor = (Red:$F8/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_GOLD                : Tg2dColor = (Red:$FF/$FF; Green:$D7/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_GOLDENROD           : Tg2dColor = (Red:$DA/$FF; Green:$A5/$FF; Blue:$20/$FF; Alpha:$FF/$FF);
  G2D_GRAY                : Tg2dColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_GREEN               : Tg2dColor = (Red:$00/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_GREENYELLOW         : Tg2dColor = (Red:$AD/$FF; Green:$FF/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  G2D_GREY                : Tg2dColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_HONEYDEW            : Tg2dColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  G2D_HOTPINK             : Tg2dColor = (Red:$FF/$FF; Green:$69/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  G2D_INDIANRED           : Tg2dColor = (Red:$CD/$FF; Green:$5C/$FF; Blue:$5C/$FF; Alpha:$FF/$FF);
  G2D_INDIGO              : Tg2dColor = (Red:$4B/$FF; Green:$00/$FF; Blue:$82/$FF; Alpha:$FF/$FF);
  G2D_IVORY               : Tg2dColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  G2D_KHAKI               : Tg2dColor = (Red:$F0/$FF; Green:$E6/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  G2D_LAVENDER            : Tg2dColor = (Red:$E6/$FF; Green:$E6/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  G2D_LAVENDERBLUSH       : Tg2dColor = (Red:$FF/$FF; Green:$F0/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  G2D_LAWNGREEN           : Tg2dColor = (Red:$7C/$FF; Green:$FC/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_LEMONCHIFFON        : Tg2dColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  G2D_LIGHTBLUE           : Tg2dColor = (Red:$AD/$FF; Green:$D8/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  G2D_LIGHTCORAL          : Tg2dColor = (Red:$F0/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_LIGHTCYAN           : Tg2dColor = (Red:$E0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_LIGHTGOLDENRODYELLOW: Tg2dColor = (Red:$FA/$FF; Green:$FA/$FF; Blue:$D2/$FF; Alpha:$FF/$FF);
  G2D_LIGHTGRAY           : Tg2dColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  G2D_LIGHTGREEN          : Tg2dColor = (Red:$90/$FF; Green:$EE/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  G2D_LIGHTGREY           : Tg2dColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  G2D_LIGHTPINK           : Tg2dColor = (Red:$FF/$FF; Green:$B6/$FF; Blue:$C1/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSALMON         : Tg2dColor = (Red:$FF/$FF; Green:$A0/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSEAGREEN       : Tg2dColor = (Red:$20/$FF; Green:$B2/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSKYBLUE        : Tg2dColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSLATEGRAY      : Tg2dColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSLATEGREY      : Tg2dColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  G2D_LIGHTSTEELBLUE      : Tg2dColor = (Red:$B0/$FF; Green:$C4/$FF; Blue:$DE/$FF; Alpha:$FF/$FF);
  G2D_LIGHTYELLOW         : Tg2dColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$E0/$FF; Alpha:$FF/$FF);
  G2D_LIME                : Tg2dColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_LIMEGREEN           : Tg2dColor = (Red:$32/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  G2D_LINEN               : Tg2dColor = (Red:$FA/$FF; Green:$F0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  G2D_MAGENTA             : Tg2dColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_MAROON              : Tg2dColor = (Red:$80/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMAQUAMARINE    : Tg2dColor = (Red:$66/$FF; Green:$CD/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMBLUE          : Tg2dColor = (Red:$00/$FF; Green:$00/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMORCHID        : Tg2dColor = (Red:$BA/$FF; Green:$55/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMPURPLE        : Tg2dColor = (Red:$93/$FF; Green:$70/$FF; Blue:$DB/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMSEAGREEN      : Tg2dColor = (Red:$3C/$FF; Green:$B3/$FF; Blue:$71/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMSLATEBLUE     : Tg2dColor = (Red:$7B/$FF; Green:$68/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMSPRINGGREEN   : Tg2dColor = (Red:$00/$FF; Green:$FA/$FF; Blue:$9A/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMTURQUOISE     : Tg2dColor = (Red:$48/$FF; Green:$D1/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  G2D_MEDIUMVIOLETRED     : Tg2dColor = (Red:$C7/$FF; Green:$15/$FF; Blue:$85/$FF; Alpha:$FF/$FF);
  G2D_MIDNIGHTBLUE        : Tg2dColor = (Red:$19/$FF; Green:$19/$FF; Blue:$70/$FF; Alpha:$FF/$FF);
  G2D_MINTCREAM           : Tg2dColor = (Red:$F5/$FF; Green:$FF/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  G2D_MISTYROSE           : Tg2dColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  G2D_MOCCASIN            : Tg2dColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$B5/$FF; Alpha:$FF/$FF);
  G2D_NAVAJOWHITE         : Tg2dColor = (Red:$FF/$FF; Green:$DE/$FF; Blue:$AD/$FF; Alpha:$FF/$FF);
  G2D_NAVY                : Tg2dColor = (Red:$00/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_OLDLACE             : Tg2dColor = (Red:$FD/$FF; Green:$F5/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  G2D_OLIVE               : Tg2dColor = (Red:$80/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_OLIVEDRAB           : Tg2dColor = (Red:$6B/$FF; Green:$8E/$FF; Blue:$23/$FF; Alpha:$FF/$FF);
  G2D_ORANGE              : Tg2dColor = (Red:$FF/$FF; Green:$A5/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_ORANGERED           : Tg2dColor = (Red:$FF/$FF; Green:$45/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_ORCHID              : Tg2dColor = (Red:$DA/$FF; Green:$70/$FF; Blue:$D6/$FF; Alpha:$FF/$FF);
  G2D_PALEGOLDENROD       : Tg2dColor = (Red:$EE/$FF; Green:$E8/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  G2D_PALEGREEN           : Tg2dColor = (Red:$98/$FF; Green:$FB/$FF; Blue:$98/$FF; Alpha:$FF/$FF);
  G2D_PALETURQUOISE       : Tg2dColor = (Red:$AF/$FF; Green:$EE/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  G2D_PALEVIOLETRED       : Tg2dColor = (Red:$DB/$FF; Green:$70/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  G2D_PAPAYAWHIP          : Tg2dColor = (Red:$FF/$FF; Green:$EF/$FF; Blue:$D5/$FF; Alpha:$FF/$FF);
  G2D_PEACHPUFF           : Tg2dColor = (Red:$FF/$FF; Green:$DA/$FF; Blue:$B9/$FF; Alpha:$FF/$FF);
  G2D_PERU                : Tg2dColor = (Red:$CD/$FF; Green:$85/$FF; Blue:$3F/$FF; Alpha:$FF/$FF);
  G2D_PINK                : Tg2dColor = (Red:$FF/$FF; Green:$C0/$FF; Blue:$CB/$FF; Alpha:$FF/$FF);
  G2D_PLUM                : Tg2dColor = (Red:$DD/$FF; Green:$A0/$FF; Blue:$DD/$FF; Alpha:$FF/$FF);
  G2D_POWDERBLUE          : Tg2dColor = (Red:$B0/$FF; Green:$E0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  G2D_PURPLE              : Tg2dColor = (Red:$80/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_REBECCAPURPLE       : Tg2dColor = (Red:$66/$FF; Green:$33/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  G2D_RED                 : Tg2dColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_ROSYBROWN           : Tg2dColor = (Red:$BC/$FF; Green:$8F/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  G2D_ROYALBLUE           : Tg2dColor = (Red:$41/$FF; Green:$69/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  G2D_SADDLEBROWN         : Tg2dColor = (Red:$8B/$FF; Green:$45/$FF; Blue:$13/$FF; Alpha:$FF/$FF);
  G2D_SALMON              : Tg2dColor = (Red:$FA/$FF; Green:$80/$FF; Blue:$72/$FF; Alpha:$FF/$FF);
  G2D_SANDYBROWN          : Tg2dColor = (Red:$F4/$FF; Green:$A4/$FF; Blue:$60/$FF; Alpha:$FF/$FF);
  G2D_SEAGREEN            : Tg2dColor = (Red:$2E/$FF; Green:$8B/$FF; Blue:$57/$FF; Alpha:$FF/$FF);
  G2D_SEASHELL            : Tg2dColor = (Red:$FF/$FF; Green:$F5/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  G2D_SIENNA              : Tg2dColor = (Red:$A0/$FF; Green:$52/$FF; Blue:$2D/$FF; Alpha:$FF/$FF);
  G2D_SILVER              : Tg2dColor = (Red:$C0/$FF; Green:$C0/$FF; Blue:$C0/$FF; Alpha:$FF/$FF);
  G2D_SKYBLUE             : Tg2dColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$EB/$FF; Alpha:$FF/$FF);
  G2D_SLATEBLUE           : Tg2dColor = (Red:$6A/$FF; Green:$5A/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  G2D_SLATEGRAY           : Tg2dColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  G2D_SLATEGREY           : Tg2dColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  G2D_SNOW                : Tg2dColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  G2D_SPRINGGREEN         : Tg2dColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$7F/$FF; Alpha:$FF/$FF);
  G2D_STEELBLUE           : Tg2dColor = (Red:$46/$FF; Green:$82/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  G2D_TAN                 : Tg2dColor = (Red:$D2/$FF; Green:$B4/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  G2D_TEAL                : Tg2dColor = (Red:$00/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  G2D_THISTLE             : Tg2dColor = (Red:$D8/$FF; Green:$BF/$FF; Blue:$D8/$FF; Alpha:$FF/$FF);
  G2D_TOMATO              : Tg2dColor = (Red:$FF/$FF; Green:$63/$FF; Blue:$47/$FF; Alpha:$FF/$FF);
  G2D_TURQUOISE           : Tg2dColor = (Red:$40/$FF; Green:$E0/$FF; Blue:$D0/$FF; Alpha:$FF/$FF);
  G2D_VIOLET              : Tg2dColor = (Red:$EE/$FF; Green:$82/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  G2D_WHEAT               : Tg2dColor = (Red:$F5/$FF; Green:$DE/$FF; Blue:$B3/$FF; Alpha:$FF/$FF);
  G2D_WHITE               : Tg2dColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_WHITESMOKE          : Tg2dColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  G2D_YELLOW              : Tg2dColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  G2D_YELLOWGREEN         : Tg2dColor = (Red:$9A/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  G2D_BLANK               : Tg2dColor = (Red:$00;     Green:$00;     Blue:$00;     Alpha:$00);
  G2D_WHITE2              : Tg2dColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  G2D_RED22               : Tg2dColor = (Red:$7E/$FF; Green:$32/$FF; Blue:$3F/$FF; Alpha:255/$FF);
  G2D_COLORKEY            : Tg2dColor = (Red:$FF/$FF; Green:$00;     Blue:$FF/$FF; Alpha:$FF/$FF);
  G2D_OVERLAY1            : Tg2dColor = (Red:$00/$FF; Green:$20/$FF; Blue:$29/$FF; Alpha:$B4/$FF);
  G2D_OVERLAY2            : Tg2dColor = (Red:$01/$FF; Green:$1B/$FF; Blue:$01/$FF; Alpha:255/$FF);
  G2D_DIMWHITE            : Tg2dColor = (Red:$10/$FF; Green:$10/$FF; Blue:$10/$FF; Alpha:$10/$FF);
  G2D_DARKSLATEBROWN      : Tg2dColor = (Red:30/255; Green:31/255; Blue:30/255; Alpha:1/255);
{$ENDREGION}

//=== WINDOW ===================================================================
{$REGION ' KEY CODES '}
const
  G2D_KEY_UNKNOWN = -1;
  G2D_KEY_SPACE = 32;
  G2D_KEY_APOSTROPHE = 39;
  G2D_KEY_COMMA = 44;
  G2D_KEY_MINUS = 45;
  G2D_KEY_PERIOD = 46;
  G2D_KEY_SLASH = 47;
  G2D_KEY_0 = 48;
  G2D_KEY_1 = 49;
  G2D_KEY_2 = 50;
  G2D_KEY_3 = 51;
  G2D_KEY_4 = 52;
  G2D_KEY_5 = 53;
  G2D_KEY_6 = 54;
  G2D_KEY_7 = 55;
  G2D_KEY_8 = 56;
  G2D_KEY_9 = 57;
  G2D_KEY_SEMICOLON = 59;
  G2D_KEY_EQUAL = 61;
  G2D_KEY_A = 65;
  G2D_KEY_B = 66;
  G2D_KEY_C = 67;
  G2D_KEY_D = 68;
  G2D_KEY_E = 69;
  G2D_KEY_F = 70;
  G2D_KEY_G = 71;
  G2D_KEY_H = 72;
  G2D_KEY_I = 73;
  G2D_KEY_J = 74;
  G2D_KEY_K = 75;
  G2D_KEY_L = 76;
  G2D_KEY_M = 77;
  G2D_KEY_N = 78;
  G2D_KEY_O = 79;
  G2D_KEY_P = 80;
  G2D_KEY_Q = 81;
  G2D_KEY_R = 82;
  G2D_KEY_S = 83;
  G2D_KEY_T = 84;
  G2D_KEY_U = 85;
  G2D_KEY_V = 86;
  G2D_KEY_W = 87;
  G2D_KEY_X = 88;
  G2D_KEY_Y = 89;
  G2D_KEY_Z = 90;
  G2D_KEY_LEFT_BRACKET = 91;
  G2D_KEY_BACKSLASH = 92;
  G2D_KEY_RIGHT_BRACKET = 93;
  G2D_KEY_GRAVE_ACCENT = 96;
  G2D_KEY_WORLD_1 = 161;
  G2D_KEY_WORLD_2 = 162;
  G2D_KEY_ESCAPE = 256;
  G2D_KEY_ENTER = 257;
  G2D_KEY_TAB = 258;
  G2D_KEY_BACKSPACE = 259;
  G2D_KEY_INSERT = 260;
  G2D_KEY_DELETE = 261;
  G2D_KEY_RIGHT = 262;
  G2D_KEY_LEFT = 263;
  G2D_KEY_DOWN = 264;
  G2D_KEY_UP = 265;
  G2D_KEY_PAGE_UP = 266;
  G2D_KEY_PAGE_DOWN = 267;
  G2D_KEY_HOME = 268;
  G2D_KEY_END = 269;
  G2D_KEY_CAPS_LOCK = 280;
  G2D_KEY_SCROLL_LOCK = 281;
  G2D_KEY_NUM_LOCK = 282;
  G2D_KEY_PRINT_SCREEN = 283;
  G2D_KEY_PAUSE = 284;
  G2D_KEY_F1 = 290;
  G2D_KEY_F2 = 291;
  G2D_KEY_F3 = 292;
  G2D_KEY_F4 = 293;
  G2D_KEY_F5 = 294;
  G2D_KEY_F6 = 295;
  G2D_KEY_F7 = 296;
  G2D_KEY_F8 = 297;
  G2D_KEY_F9 = 298;
  G2D_KEY_F10 = 299;
  G2D_KEY_F11 = 300;
  G2D_KEY_F12 = 301;
  G2D_KEY_F13 = 302;
  G2D_KEY_F14 = 303;
  G2D_KEY_F15 = 304;
  G2D_KEY_F16 = 305;
  G2D_KEY_F17 = 306;
  G2D_KEY_F18 = 307;
  G2D_KEY_F19 = 308;
  G2D_KEY_F20 = 309;
  G2D_KEY_F21 = 310;
  G2D_KEY_F22 = 311;
  G2D_KEY_F23 = 312;
  G2D_KEY_F24 = 313;
  G2D_KEY_F25 = 314;
  G2D_KEY_KP_0 = 320;
  G2D_KEY_KP_1 = 321;
  G2D_KEY_KP_2 = 322;
  G2D_KEY_KP_3 = 323;
  G2D_KEY_KP_4 = 324;
  G2D_KEY_KP_5 = 325;
  G2D_KEY_KP_6 = 326;
  G2D_KEY_KP_7 = 327;
  G2D_KEY_KP_8 = 328;
  G2D_KEY_KP_9 = 329;
  G2D_KEY_KP_DECIMAL = 330;
  G2D_KEY_KP_DIVIDE = 331;
  G2D_KEY_KP_MULTIPLY = 332;
  G2D_KEY_KP_SUBTRACT = 333;
  G2D_KEY_KP_ADD = 334;
  G2D_KEY_KP_ENTER = 335;
  G2D_KEY_KP_EQUAL = 336;
  G2D_KEY_LEFT_SHIFT = 340;
  G2D_KEY_LEFT_CONTROL = 341;
  G2D_KEY_LEFT_ALT = 342;
  G2D_KEY_LEFT_SUPER = 343;
  G2D_KEY_RIGHT_SHIFT = 344;
  G2D_KEY_RIGHT_CONTROL = 345;
  G2D_KEY_RIGHT_ALT = 346;
  G2D_KEY_RIGHT_SUPER = 347;
  G2D_KEY_MENU = 348;
  G2D_KEY_LAST = G2D_KEY_MENU;
{$ENDREGION}

{$REGION ' MOUSE BUTTONS '}
const
  G2D_MOUSE_BUTTON_1 = 0;
  G2D_MOUSE_BUTTON_2 = 1;
  G2D_MOUSE_BUTTON_3 = 2;
  G2D_MOUSE_BUTTON_4 = 3;
  G2D_MOUSE_BUTTON_5 = 4;
  G2D_MOUSE_BUTTON_6 = 5;
  G2D_MOUSE_BUTTON_7 = 6;
  G2D_MOUSE_BUTTON_8 = 7;
  G2D_MOUSE_BUTTON_LAST = 7;
  G2D_MOUSE_BUTTON_LEFT = 0;
  G2D_MOUSE_BUTTON_RIGHT = 1;
  G2D_MOUSE_BUTTON_MIDDLE = 2;
{$ENDREGION}

{$REGION ' GAMEPADS '}
const
  G2D_GAMEPAD_1 = 0;
  G2D_GAMEPAD_2 = 1;
  G2D_GAMEPAD_3 = 2;
  G2D_GAMEPAD_4 = 3;
  G2D_GAMEPAD_5 = 4;
  G2D_GAMEPAD_6 = 5;
  G2D_GAMEPAD_7 = 6;
  G2D_GAMEPAD_8 = 7;
  G2D_GAMEPAD_9 = 8;
  G2D_GAMEPAD_10 = 9;
  G2D_GAMEPAD_11 = 10;
  G2D_GAMEPAD_12 = 11;
  G2D_GAMEPAD_13 = 12;
  G2D_GAMEPAD_14 = 13;
  G2D_GAMEPAD_15 = 14;
  G2D_GAMEPAD_16 = 15;
  G2D_GAMEPAD_LAST = G2D_GAMEPAD_16;
{$ENDREGION}

{$REGION ' GAMEPAD BUTTONS '}
const
  G2D_GAMEPAD_BUTTON_A = 0;
  G2D_GAMEPAD_BUTTON_B = 1;
  G2D_GAMEPAD_BUTTON_X = 2;
  G2D_GAMEPAD_BUTTON_Y = 3;
  G2D_GAMEPAD_BUTTON_LEFT_BUMPER = 4;
  G2D_GAMEPAD_BUTTON_RIGHT_BUMPER = 5;
  G2D_GAMEPAD_BUTTON_BACK = 6;
  G2D_GAMEPAD_BUTTON_START = 7;
  G2D_GAMEPAD_BUTTON_GUIDE = 8;
  G2D_GAMEPAD_BUTTON_LEFT_THUMB = 9;
  G2D_GAMEPAD_BUTTON_RIGHT_THUMB = 10;
  G2D_GAMEPAD_BUTTON_DPAD_UP = 11;
  G2D_GAMEPAD_BUTTON_DPAD_RIGHT = 12;
  G2D_GAMEPAD_BUTTON_DPAD_DOWN = 13;
  G2D_GAMEPAD_BUTTON_DPAD_LEFT = 14;
  G2D_GAMEPAD_BUTTON_LAST = G2D_GAMEPAD_BUTTON_DPAD_LEFT;
  G2D_GAMEPAD_BUTTON_CROSS = G2D_GAMEPAD_BUTTON_A;
  G2D_GAMEPAD_BUTTON_CIRCLE = G2D_GAMEPAD_BUTTON_B;
  G2D_GAMEPAD_BUTTON_SQUARE = G2D_GAMEPAD_BUTTON_X;
  G2D_AMEPAD_BUTTON_TRIANGLE = G2D_GAMEPAD_BUTTON_Y;
{$ENDREGION}

{$REGION ' GAMEPAD AXIS '}
const
  G2D_GAMEPAD_AXIS_LEFT_X = 0;
  G2D_GAMEPAD_AXIS_LEFT_Y = 1;
  G2D_GAMEPAD_AXIS_RIGHT_X = 2;
  G2D_GAMEPAD_AXIS_RIGHT_Y = 3;
  G2D_GAMEPAD_AXIS_LEFT_TRIGGER = 4;
  G2D_GAMEPAD_AXIS_RIGHT_TRIGGER = 5;
  G2D_GAMEPAD_AXIS_LAST = G2D_GAMEPAD_AXIS_RIGHT_TRIGGER;
{$ENDREGION}

const
  G2D_DEFAULT_WINDOW_WIDTH  = 1920 div 2;
  G2D_DEFAULT_WINDOW_HEIGHT = 1080 div 2;

  G2D_DEFAULT_FPS = 60;

type
  { Tg2dTexture }
  Tg2dTexture = class;

  { TInputState }
  Tg2dInputState = (isPressed, isWasPressed, isWasReleased);

  { TWindow }
  Tg2dWindow = class(Tg2dObject)
  protected type
    TTiming = record
      LastTime: Double;
      TargetTime: Double;
      CurrentTime: Double;
      ElapsedTime: Double;
      RemainingTime: Double;
      LastFPSTime: Double;
      Endtime: double;
      FrameCount: Cardinal;
      Framerate: Cardinal;
      TargetFrameRate: Cardinal;
      DeltaTime: Double;
    end;
  protected
    FParent: HWND;
    FHandle: PGLFWwindow;
    FVirtualSize: Tg2dSize;
    FMaxTextureSize: Integer;
    FIsFullscreen: Boolean;
    FWindowedPosX, FWindowedPosY: Integer;
    FWindowedWidth, FWindowedHeight: Integer;
    FViewport: Tg2dRect;
    FKeyState: array [0..0, G2D_KEY_SPACE..G2D_KEY_LAST] of Boolean;
    FMouseButtonState: array [0..0, G2D_MOUSE_BUTTON_1..G2D_MOUSE_BUTTON_MIDDLE] of Boolean;
    FGamepadButtonState: array[0..0, G2D_GAMEPAD_BUTTON_A..G2D_GAMEPAD_BUTTON_LAST] of Boolean;
    FTiming: TTiming;
    FMouseWheel: Tg2dVec;
    FCurrentRenderTarget: Tg2dTexture;
    FFramebufferID: GLuint;
    FSavedViewport: Tg2dRect;
    FSavedProjectionMatrix: array[0..15] of GLfloat;  // Save projection matrix
    FSavedModelviewMatrix: array[0..15] of GLfloat;   // Save modelview matrix
    FVsync: Boolean;
    FResizable: Boolean;
    FReady: Boolean;
    FTextInputQueue: string;
    FTextInputEnabled: Boolean;
    procedure SetDefaultIcon();
    procedure StartTiming();
    procedure StopTiming();
  public
    property Handle: PGLFWwindow read FHandle;

    constructor Create(); override;
    destructor Destroy(); override;

    function  Open(const ATitle: string; const AVirtualWidth: Cardinal=G2D_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=G2D_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0; const AVsync: Boolean=True; const AResizable: Boolean=True): Boolean;
    procedure Close();

    function  IsReady(): Boolean;
    procedure SetReady(const AReady: Boolean);

    function  GetTitle(): string;
    procedure SetTitle(const ATitle: string);

    procedure SetSizeLimits(const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
    procedure Resize(const AWidth, AHeight: Cardinal);
    procedure ToggleFullscreen();
    function  IsFullscreen(): Boolean;

    function  HasFocus(): Boolean;

    function  GetVirtualSize(): Tg2dSize;
    function  GetSize(): Tg2dSize;
    function  GetScale(): Tg2dSize;
    function  GetMaxTextureSize: Integer;

    function  GetViewport(): Tg2dRect;

    procedure Center();

    function  ShouldClose(): Boolean;
    procedure SetShouldClose(const AClose: Boolean);

    procedure StartFrame();
    procedure EndFrame();

    procedure StartDrawing();
    procedure ResetDrawing();
    procedure EndDrawing();

    procedure Clear(const AColor: Tg2dColor);

    procedure DrawLine(const X1, Y1, X2, Y2: Single; const AColor: Tg2dColor; const AThickness: Single);
    procedure DrawRect(const X, Y, AWidth, AHeight, AThickness: Single; const AColor: Tg2dColor; const AAngle: Single);
    procedure DrawFilledRect(const X, Y, AWidth, AHeight: Single; const AColor: Tg2dColor; const AAngle: Single);
    procedure DrawCircle(const X, Y, ARadius, AThickness: Single; const AColor: Tg2dColor);
    procedure DrawFilledCircle(const X, Y, ARadius: Single; const AColor: Tg2dColor);
    procedure DrawTriangle(const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: Tg2dColor);
    procedure DrawFilledTriangle(const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: Tg2dColor);
    procedure DrawPolygon(const APoints: array of TPoint; const AThickness: Single; const AColor: Tg2dColor);
    procedure DrawFilledPolygon(const APoints: array of TPoint; const AColor: Tg2dColor);
    procedure DrawPolyline(const APoints: array of TPoint; const AThickness: Single; const AColor: Tg2dColor);

    procedure ClearInput();
    function  GetKey(const AKey: Integer; const AState: Tg2dInputState): Boolean;
    function  GetMouseButton(const AButton: Byte; const AState: Tg2dInputState): Boolean;
    procedure GetMousePos(const X, Y: System.PSingle); overload;
    function  GetMousePos(): Tg2dVec; overload;
    procedure SetMousePos(const X, Y: Single);
    function  GetMouseWheel(): Tg2dVec;

    function  GamepadPresent(const AGamepad: Byte): Boolean;
    function  GetGamepadName(const AGamepad: Byte): string;
    function  GetGamepadButton(const AGamepad, AButton: Byte; const AState: Tg2dInputState): Boolean;
    function  GetGamepadAxisValue(const AGamepad, AAxis: Byte): Single;

    function  VirtualToScreen(const X, Y: Single): Tg2dVec;
    function  ScreenToVirtual(const X, Y: Single): Tg2dVec;

    procedure SetTargetFrameRate(const ATargetFrameRate: UInt32=G2D_DEFAULT_FPS);
    function  GetTargetFrameRate(): UInt32;
    function  GetTargetTime(): Double;
    procedure ResetTiming();
    function  GetFrameRate(): UInt32;
    function  GetDeltaTime(): Double;

    procedure SetRenderTarget(const ATexture: Tg2dTexture; const ADisableSmoothing: Boolean = False);
    function  GetRenderTarget(): Tg2dTexture;

    // Text Input Support
    function GetTextInputQueue(): string;
    procedure ClearTextInputQueue();
    procedure EnableTextInput(const AEnable: Boolean);

    // Clipboard Support
    function GetClipboardText(): string;
    procedure SetClipboardText(const AText: string);

    class function  Init(const ATitle: string; const AVirtualWidth: Cardinal=G2D_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=G2D_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0; const AVsync: Boolean=True; const AResizable: Boolean=True): Tg2dWindow; static;
  end;

//=== TEXTURE ==================================================================
  { Tg2dTextureKind }
  Tg2dTextureKind = (
    tkHD,
    tkPixelArt
  );

  { Tg2dTextureBlend }
  Tg2dTextureBlend = (
    tbNone,
    tbAlpha,
    tbAdditiveAlpha
  );

  { Tg2dTextureShareTransformMode }
  Tg2dTextureShareMode = (
    tsmSkip,   // skip properties
    tsmCopy,   // copy properties
    tsmReset   // reset properties
  );

  { Tg2dTexture }
  Tg2dTexture = class(Tg2dObject)
  private type
    PRGBA = ^TRGBA;
    TRGBA = packed record
      R, G, B, A: Byte;
    end;
  private
    FHandle: GLuint;
    FChannels: Integer;
    FSize: Tg2dSize;
    FPivot: Tg2dVec;
    FAnchor: Tg2dVec;
    FBlend: Tg2dTextureBlend;
    FPos: Tg2dVec;
    FScale: Single;
    FColor: Tg2dColor;
    FAngle: Single;
    FHFlip: Boolean;
    FVFlip: Boolean;
    FRegion: Tg2dRect;
    FLock: PByte;
    FKind: Tg2dTextureKind;
    FOwnsHandle: Boolean;
    procedure ConvertMaskToAlpha(Data: Pointer; Width, Height: Integer; MaskColor: Tg2dColor);
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Share(const ATexture: Tg2dTexture; const AShareMode: Tg2dTextureShareMode);
    function  Alloc(const AWidth, AHeight: Integer; const AColor: Tg2dColor): Boolean;
    procedure Fill(const AColor: Tg2dColor);
    function  Load(const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean; overload;
    function  Load(const AIO: Tg2dIO; const AOwnIO: Boolean=True; const AColorKey: Pg2dColor=nil): Boolean; overload;
    function  LoadFromFile(const AFilename: string; const AColorKey: Pg2dColor=nil): Boolean;
    function  LoadFromZipFile(const AZipFilename, AFilename: string; const AColorKey: Pg2dColor=nil; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    function  IsLoaded(): Boolean;
    procedure Unload();
    function  GetHandle(): Cardinal;
    function  GetChannels(): Integer;
    function  GetSize():Tg2dSize;
    function  GetKind(): Tg2dTextureKind;
    procedure SetKind(const AKind: Tg2dTextureKind);
    function  GetPivot(): Tg2dVec;
    procedure SetPivot( const APoint: Tg2dVec); overload;
    procedure SetPivot(const X, Y: Single); overload;
    function  Anchor(): Tg2dVec;
    procedure SetAnchor(const APoint: Tg2dVec); overload;
    procedure SetAnchor(const X, Y: Single); overload;
    function  GetBlend(): Tg2dTextureBlend;
    procedure SetBlend(const AValue: Tg2dTextureBlend);
    function  GetPos(): Tg2dVec;
    procedure SetPos(const APos: Tg2dVec); overload;
    procedure SetPos(const X, Y: Single); overload;
    function  GetScale(): Single;
    procedure SetScale(const AScale: Single);
    function  GetColor(): Tg2dColor;
    procedure SetColor(const AColor: Tg2dColor); overload;
    procedure SetColor(const ARed, AGreen, ABlue, AAlpha: Single); overload;
    function  GetAngle(): Single;
    procedure SetAngle(const AAngle: Single);
    function  GetHFlip(): Boolean;
    procedure SetHFlip(const AFlip: Boolean);
    function  GetVFlip(): Boolean;
    procedure SetVFlip(const AFlip: Boolean);
    function  GetRegion(): Tg2dRect;
    procedure SetRegion(const ARegion: Tg2dRect); overload;
    procedure SetRegion(const X, Y, AWidth, AHeight: Single); overload;
    procedure ResetRegion();
    procedure Draw();
    procedure DrawTiled(const AWindowLogicalWidth, AWindowLogicalHeight, ADeltaX, ADeltaY: Single);
    function  Save(const AFilename: string): Boolean;
    function  Lock(): Boolean;
    procedure Unlock();
    function  GetPixel(const X, Y: Single): Tg2dColor;
    procedure SetPixel(const X, Y: Single; const AColor: Tg2dColor); overload;
    procedure SetPixel(const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte); overload;
    class function Init(const AZipFilename, AFilename: string; const AColorKey: Pg2dColor=nil; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dTexture; static;
    class procedure Delete(const ATexture: GLuint);

    property Handle: GLuint read FHandle;
  end;

//=== SHADER ===================================================================
type
  { Tg2dShaderKind }
  Tg2dShaderKind = (
    skVertex = GL_VERTEX_SHADER,
    skFragment = GL_FRAGMENT_SHADER
  );

const
  G2D_DEFAULT_VERTEX_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'void main() {' + #13#10 +
    '  gl_Position = ftransform();' + #13#10 +
    '  vTexCoord = gl_MultiTexCoord0.xy;' + #13#10 +
    '  vColor = gl_Color;' + #13#10 +
    '}';

  G2D_DEFAULT_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'void main() {' + #13#10 +
    '  if (useTexture) {' + #13#10 +
    '    gl_FragColor = texture2D(mainTexture, vTexCoord) * vColor;' + #13#10 +
    '  } else {' + #13#10 +
    '    gl_FragColor = vColor;' + #13#10 +
    '  }' + #13#10 +
    '}';

type
  { Tg2dShader }
  Tg2dShader = class(Tg2dObject)
  protected
    FVertexShader: GLuint;
    FFragmentShader: GLuint;
    FProgram: GLuint;
    FIsBuilt: Boolean;
    function CompileShader(const AKind: Tg2dShaderKind; const ASource: string): GLuint;
    function GetShaderLog(const AShader: GLuint): string;
    function GetProgramLog(const AProgram: GLuint): string;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    procedure Clear();
    function Load(const AKind: Tg2dShaderKind; const ASource: string): Boolean; overload;
    function Load(const AIO: Tg2dIO; const AKind: Tg2dShaderKind): Boolean; overload;
    function LoadFromFile(const AFilename: string; const AKind: Tg2dShaderKind): Boolean;
    function LoadFromZipFile(const AZipFilename: string; const AFilename: string; const AKind: Tg2dShaderKind; const APassword: string = G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    function Build(): Boolean;
    function Enable(const AEnable: Boolean): Boolean;
    function GetLog(): string;
    function IsBuilt(): Boolean;

    // Uniform setters
    function SetIntUniform(const AName: string; const AValue: Integer): Boolean; overload;
    function SetIntUniform(const AName: string; const ANumComponents: Integer; const AValue: PInteger; const ANumElements: Integer): Boolean; overload;
    function SetFloatUniform(const AName: string; const AValue: Single): Boolean; overload;
    function SetFloatUniform(const AName: string; const ANumComponents: Integer; const AValue: PSingle; const ANumElements: Integer): Boolean; overload;
    function SetBoolUniform(const AName: string; const AValue: Boolean): Boolean;
    function SetTextureUniform(const AName: string; const ATexture: Tg2dTexture; const AUnit: Integer): Boolean;
    function SetVec2Uniform(const AName: string; const AValue: Tg2dVec): Boolean; overload;
    function SetVec2Uniform(const AName: string; const AX: Single; const AY: Single): Boolean; overload;
    function SetVec2Uniform(const AName: string; const ASize: Tg2dSize): Boolean; overload;
    function SetVec3Uniform(const AName: string; const AValue: Tg2dVec): Boolean; overload;
    function SetVec3Uniform(const AName: string; const AX: Single; const AY: Single; const AZ: Single): Boolean; overload;
    function SetVec4Uniform(const AName: string; const AValue: Tg2dVec): Boolean; overload;
    function SetVec4Uniform(const AName: string; const AX: Single; const AY: Single; const AZ: Single; const AW: Single): Boolean; overload;
    function SetColorUniform(const AName: string; const AColor: Tg2dColor): Boolean;
    function SetMatrix4Uniform(const AName: string; const AMatrix: array of Single): Boolean;

    class function Init(const AVertexSource: string; const AFragmentSource: string): Tg2dShader; static;
  end;

//=== FONT =====================================================================
const
  G2D_SDF_VERTEX_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'void main() {' + #13#10 +
    '  gl_Position = ftransform();' + #13#10 +
    '  vTexCoord = gl_MultiTexCoord0.xy;' + #13#10 +
    '  vColor = gl_Color;' + #13#10 +
    '}';

  G2D_SDF_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D uTexture;' + #13#10 +
    'uniform float uSmoothness;' + #13#10 +
    'uniform float uThreshold;' + #13#10 +
    'uniform vec4 uOutlineColor;' + #13#10 +
    'uniform float uOutlineThreshold;' + #13#10 +
    'uniform int uEnableOutline;' + #13#10 +
    'void main() {' + #13#10 +
    '  float dist = texture2D(uTexture, vTexCoord).a;' +
    #13#10 +
    '  float alpha = smoothstep(uThreshold - uSmoothness, uThreshold + uSmoothness, dist);' + #13#10 +
    '  vec4 baseColor = vColor;' + #13#10 +
    '  baseColor.a *= alpha;' + #13#10 +
    '  if ((uEnableOutline != 0) && (uOutlineThreshold > 0.0)) {' + #13#10 +
    '    float outlineAlpha = smoothstep(uOutlineThreshold - uSmoothness, uOutlineThreshold + uSmoothness, dist);' + #13#10 +
    '    vec4 outlineCol = uOutlineColor;' + #13#10 +
    '    outlineCol.a *= outlineAlpha;' + #13#10 +
    '    gl_FragColor = mix(outlineCol, baseColor, alpha);' + #13#10 +
    '  } else {' + #13#10 +
    '    gl_FragColor = baseColor;' + #13#10 +
    '  }' + #13#10 +
    '}';

  G2D_SDF_SIZE_FAST = 24;
  G2D_SDF_SIZE_BALANCED = 32;
  G2D_SDF_SIZE_QUALITY = 48;
  G2D_SDF_SIZE_PREMIUM = 64;
  G2D_SDF_DEFAULT_SIZE = G2D_SDF_SIZE_BALANCED;

type
  { Tg2dFont }
  Tg2dFont = class(Tg2dObject)
  protected const
    DEFAULT_GLYPHS = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~™©←→↑↓';
    SDF_PADDING = 8;
    SDF_ONEDGE_VALUE = 128;
    SDF_PIXEL_DIST_SCALE = 64.0;
  protected type
    PGlyph = ^TGlyph;
    TGlyph = record
      SrcRect: Tg2dRect;
      DstRect: Tg2dRect;
      XAdvance: Single;
      YOffset: Single;
    end;
  protected
    FAtlasSize: Integer;
    FAtlas: Tg2dTexture;
    FBaseLine: Single;
    FLineHeight: Single;
    FGlyph: TDictionary<Integer, TGlyph>;
    FShader: Tg2dShader;
    FSmoothness: Single;
    FThreshold: Single;
    FOutlineColor: Tg2dColor;
    FOutlineThreshold: Single;
    FEnableOutline: Boolean;
    FGeneratedSize: Single;
    FDpiScale: Single;
    procedure InitializeShader();
    procedure SetShaderUniforms();
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  Load(const AWindow: Tg2dWindow; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''): Boolean; overload;
    function  Load(const AWindow: Tg2dWindow; const AIO: Tg2dIO; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''; const AOwnIO: Boolean=True): Boolean; overload;
    function  LoadFromFile(const AWindow: Tg2dWindow; const AFilename: string; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''): Boolean;
    function  LoadFromZipFile(const AWindow: Tg2dWindow; const AZipFilename, AFilename: string; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    procedure Unload();
    procedure DrawText(const AWindow: Tg2dWindow; const AX, AY: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string); overload;
    procedure DrawText(const AWindow: Tg2dWindow; const AX: Single; var AY: Single; const ALineSpace: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string); overload;
    procedure DrawText(const AWindow: Tg2dWindow; const AX, AY: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string; const AArgs: array of const); overload;
    procedure DrawText(const AWindow: Tg2dWindow; const AX: Single; var AY: Single; const ALineSpace: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string; const AArgs: array of const); overload;
    function  TextLength(const AText: string; const AScale: Single = 1.0): Single; overload;
    function  TextLength(const AText: string; const AScale: Single; const AArgs: array of const): Single; overload;
    function  TextHeight(const AScale: Single = 1.0): Single;
    function  LineHeight(const AScale: Single = 1.0): Single;
    function  SaveTexture(const AFilename: string): Boolean;

    // SDF specific properties
    property Smoothness: Single read FSmoothness write FSmoothness;
    property Threshold: Single read FThreshold write FThreshold;
    property OutlineColor: Tg2dColor read FOutlineColor write FOutlineColor;
    property OutlineThreshold: Single read FOutlineThreshold write FOutlineThreshold;
    property EnableOutline: Boolean read FEnableOutline write FEnableOutline;
    property GeneratedSize: Single read FGeneratedSize;
    property DpiScale: Single read FDpiScale;

    // Scale calculation helpers
    function  GetLogicalScale(const ADesiredSize: Single): Single;
    function  GetPhysicalScale(const ADesiredPixelSize: Single): Single;

    class function Init(const AWindow: Tg2dWindow; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''): Tg2dFont; overload; static;
    class function Init(const AWindow: Tg2dWindow; const AZipFilename, AFilename: string; const ASize: Cardinal=G2D_SDF_DEFAULT_SIZE; const AGlyphs: string=''; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dFont; overload; static;
  end;

//=== CAMERA ===================================================================
type
  Tg2dCamera = class(Tg2dObject)
  protected
    FPosition: Tg2dVec;
    FTarget: Tg2dVec;
    FZoom: Single;
    FAngle: Single;
    FOrigin: Tg2dVec;
    FBounds: Tg2dRange;
    FShakeTime: Single;
    FShakeStrength: Single;
    FShakeOffset: Tg2dVec;
    FFollowLerp: Single;
    FIsShaking: Boolean;
    FSavedProjectionMatrix: array[0..15] of GLfloat;
    FSavedModelviewMatrix: array[0..15] of GLfloat;
    FLogicalSize: Tg2dSize;
    FTransformActive: Boolean;
    procedure ClampToBounds();
    procedure UpdateShake(const ADelta: Single);
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  GetPosition(): Tg2dVec;
    procedure SetPosition(const AX, AY: Single);
    function  GetOrigin(): Tg2dVec;
    procedure SetOrigin(const AX, AY: Single);
    function  GetBounds(): Tg2dRange;
    procedure SetBounds(const AMinX, AMinY, AMaxX, AMaxY: Single);
    function  GetLogicalSize(): Tg2dSize;
    procedure SetLogicalSize(const AWidth, AHeight: Single);
    function  GetZoom(): Single;
    procedure SetZoom(const AZoom: Single);
    function  GetAngle(): Single;
    procedure SetAngle(const AAngle: Single);
    function  GetViewRect(): Tg2dRect;
    procedure LookAt(const ATarget: Tg2dVec; const ALerpSpeed: Single);
    procedure Update(const ADelta: Single);
    function  IsShaking(): Boolean;
    procedure ShakeCamera(const ADuration, AStrength: Single);
    procedure BeginTransform();
    procedure EndTransform();
    function  WorldToScreen(const APosition: Tg2dVec): Tg2dVec;
    function  ScreenToWorld(const APosition: Tg2dVec): Tg2dVec;
    procedure MoveRelative(const AX, AY: Single);
    procedure MoveForward(const ADistance: Single);
    procedure MoveBackward(const ADistance: Single);
    procedure MoveLeft(const ADistance: Single);
    procedure MoveRight(const ADistance: Single);
    class function Init(): Tg2dCamera; static;
  end;

//=== AUDIO ====================================================================
const
  G2D_AUDIO_ERROR           = -1;
  G2D_AUDIO_MUSIC_COUNT     = 256;
  G2D_AUDIO_SOUND_COUNT     = 256;
  G2D_AUDIO_CHANNEL_COUNT   = 16;
  G2D_AUDIO_CHANNEL_DYNAMIC = -2;

type
  { Tg2dAudio }
  Tg2dAudio = class(Tg2dStaticObject)
  private type
    PMaVFS = ^TMaVFS;
    TMaVFS = record
    private
      Callbacks: ma_vfs_callbacks;
      IO: Tg2dIO;
    public
      constructor Create(const AIO: Tg2dIO);
    end;
    TMusic = record
      Handle: ma_sound;
      Loaded: Boolean;
      Volume: Single;
      Pan: Single;
    end;
    TSound = record
      Handle: ma_sound;
      InUse: Boolean;
    end;
    TChannel = record
      Handle: ma_sound;
      Reserved: Boolean;
      InUse: Boolean;
      Volume: Single;
    end;
  private class var
    FVFS: Tg2dAudio.TMaVFS;
    FEngineConfig: ma_engine_config;
    FEngine: ma_engine;
    FOpened: Boolean;
    FPaused: Boolean;
    FMusic: TMusic;
    //snd1,snd2,snd3: ma_sound;
    FSound: array[0..G2D_AUDIO_SOUND_COUNT-1] of TSound;
    FChannel: array[0..G2D_AUDIO_CHANNEL_COUNT-1] of TChannel;
  private
    class function FindFreeSoundSlot(): Integer; static;
    class function FindFreeChannelSlot(): Integer; static;
    class function ValidChannel(const AChannel: Integer): Boolean; static;
    class procedure InitData(); static;
    class constructor Create();
    class destructor Destroy();

  public
    class procedure Update(); static;
    class function  Open(): Boolean; static;
    class function  IsOpen(): Boolean; static;
    class procedure Close(); static;
    class function  IsPaused(): Boolean; static;
    class procedure SetPause(const APause: Boolean); static;
    class function  PlayMusic(const AIO: Tg2dIO; const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; static;
    class function  PlayMusicFromFile(const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; static;
    class function  PlayMusicFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
    class procedure UnloadMusic(); static;
    class function  IsMusicLooping(): Boolean; static;
    class procedure SetMusicLooping(const ALoop: Boolean); static;
    class function  MusicVolume(): Single; static;
    class procedure SetMusicVolume(const AVolume: Single); static;
    class function  MusicPan(): Single; static;
    class procedure SetMusicPan(const APan: Single); static;
    class function  LoadSound(const AIO: Tg2dIO; const AFilename: string): Integer; static;
    class function  LoadSoundFromFile(const AFilename: string): Integer; static;
    class function  LoadSoundFromZipFile(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Integer; static;
    class procedure UnloadSound(var ASound: Integer); static;
    class procedure UnloadAllSounds(); static;
    class function  PlaySound(const ASound, AChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer; static;
    class procedure ReserveChannel(const AChannel: Integer; const aReserve: Boolean); static;
    class procedure StopChannel(const AChannel: Integer); static;
    class procedure SetChannelVolume(const AChannel: Integer; const AVolume: Single); static;
    class function  GetChannelVolume(const AChannel: Integer): Single; static;
    class procedure SetChannelPosition(const AChannel: Integer; const X, Y: Single); static;
    class procedure SetChannelLoop(const AChannel: Integer; const ALoop: Boolean); static;
    class function  GetchannelLoop(const AChannel: Integer): Boolean; static;
    class function  GetChannelPlaying(const AChannel: Integer): Boolean; static;
  end;

//=== VIDEO ====================================================================
type
  { Tg2dVideoStatus }
  Tg2dVideoStatus = (
    vsStopped,
    vsPlaying
  );

  { Tg2dVideoStatusCallback }
  Tg2dVideoStatusCallback = reference to procedure(const AStatus: Tg2dVideoStatus; const AFilename: string; const AUserData: Pointer);

  { Tg2dVideo }
  Tg2dVideo = class
  private const
    BUFFERSIZE = 1024;
    CSampleSize = 2304;
    CSampleRate = 44100;
  private class var
    FIO: Tg2dIO;
    FStatus: Tg2dVideoStatus;
    FStatusFlag: Boolean;
    FStaticPlmBuffer: array[0..BUFFERSIZE] of byte;
    FRingBuffer: Tg2dVirtualRingBuffer<Single>;
    FDeviceConfig: ma_device_config;
    FDevice: ma_device;
    FPLM: Pplm_t;
    FVolume: Single;
    FLoop: Boolean;
    FRGBABuffer: array of uint8;
    FTexture: Tg2dTexture;
    FCallback: Tg2dCallback<Tg2dVideoStatusCallback>;
    FFilename: string;
    class procedure OnStatusEvent(); static;
    class constructor Create();
    class destructor Destroy();
  public
    class function  GetStatusCallback(): Tg2dVideoStatusCallback; static;
    class procedure SetStatusCallback(const AHandler: Tg2dVideoStatusCallback; const AUserData: Pointer); static;
    class function  Play(const AIO: Tg2dIO; const AFilename: string; const AVolume: Single; const ALoop: Boolean): Boolean; static;
    class function  PlayFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
    class procedure Stop(); static;
    class function  Update(const AWindow: Tg2dWindow): Boolean; static;
    class procedure Draw(const X, Y, AScale: Single); static;
    class function  Status(): Tg2dVideoStatus; static;
    class function  Volume(): Single; static;
    class procedure SetVolume(const AVolume: Single); static;
    class function  IsLooping(): Boolean; static;
    class procedure SetLooping(const ALoop: Boolean); static;
    class function  GetTexture(): Tg2dTexture; static;
  end;

implementation

//=== MATH =====================================================================
{ Tg2dVec }
constructor Tg2dVec.Create(const AX, AY: Single);
begin
  X := AX;
  Y := AY;
  Z := 0;
  W := 0;
end;

constructor Tg2dVec.Create(const AX, AY, AZ: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := 0;
end;

constructor Tg2dVec.Create(const AX, AY, AZ, AW: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := AW;
end;

procedure Tg2dVec.Assign(const AX, AY: Single);
begin
  X := AX;
  Y := AY;
  Z := 0;
  W := 0;
end;

procedure Tg2dVec.Assign(const AX, AY, AZ: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := 0;
end;

procedure Tg2dVec.Assign(const AX, AY, AZ, AW: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := AW;
end;

procedure Tg2dVec.Assign(const AVector: Tg2dVec);
begin
  Self := AVector;
end;

procedure Tg2dVec.Clear();
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 0;
end;

procedure Tg2dVec.Add(const AVector: Tg2dVec);
begin
  X := X + AVector.X;
  Y := Y + AVector.Y;
end;

procedure Tg2dVec.Subtract(const AVector: Tg2dVec);
begin
  X := X - AVector.X;
  Y := Y - AVector.Y;
end;

procedure Tg2dVec.Multiply(const AVector: Tg2dVec);
begin
  X := X * AVector.X;
  Y := Y * AVector.Y;
end;

procedure Tg2dVec.Divide(const AVector: Tg2dVec);
begin
  X := X / AVector.X;
  Y := Y / AVector.Y;
end;

function  Tg2dVec.Magnitude(): Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function  Tg2dVec.MagnitudeTruncate(const AMaxMagitude: Single): Tg2dVec;
var
  LMaxMagSqrd: Single;
  LVecMagSqrd: Single;
  LTruc: Single;
begin
  Result.Assign(X, Y);
  LMaxMagSqrd := AMaxMagitude * AMaxMagitude;
  LVecMagSqrd := Result.Magnitude();
  if LVecMagSqrd > LMaxMagSqrd then
  begin
    LTruc := (AMaxMagitude / Sqrt(LVecMagSqrd));
    Result.X := Result.X * LTruc;
    Result.Y := Result.Y * LTruc;
  end;
end;

function  Tg2dVec.Distance(const AVector: Tg2dVec): Single;
var
  LDirVec: Tg2dVec;
begin
  LDirVec.X := X - AVector.X;
  LDirVec.Y := Y - AVector.Y;
  Result := LDirVec.Magnitude();
end;

procedure Tg2dVec.Normalize();
var
  LLen, LOOL: Single;
begin
  LLen := self.Magnitude();
  if LLen <> 0 then
  begin
    LOOL := 1.0 / LLen;
    X := X * LOOL;
    Y := Y * LOOL;
  end;
end;

function  Tg2dVec.Angle(const AVector: Tg2dVec): Single;
var
  LXOY: Single;
  LR: Tg2dVec;
begin
  LR.Assign(self);
  LR.Subtract(AVector);
  LR.Normalize;

  if LR.Y = 0 then
  begin
    LR.Y := 0.001;
  end;

  LXOY := LR.X / LR.Y;

  Result := ArcTan(LXOY) * pxRAD2DEG;
  if LR.Y < 0 then
    Result := Result + 180.0;
end;

procedure Tg2dVec.Thrust(const AAngle, ASpeed: Single);
var
  LA: Single;

begin
  LA := AAngle + 90.0;

  Tg2dMath.ClipValueFloat(LA, 0, 360, True);

  X := X + Tg2dMath.AngleCos(Round(LA)) * -(aSpeed);
  Y := Y + Tg2dMath.AngleSin(Round(LA)) * -(aSpeed);
end;

function  Tg2dVec.MagnitudeSquared(): Single;
begin
  Result := (X * X) + (Y * Y);
end;

function  Tg2dVec.DotProduct(const AVector: Tg2dVec): Single;
begin
  Result := (X * AVector.X) + (Y * AVector.Y);
end;

procedure Tg2dVec.Scale(const AValue: Single);
begin
  X := X * AValue;
  Y := Y * AValue;
end;

procedure Tg2dVec.DivideBy(const AValue: Single);
begin
  X := X / AValue;
  Y := Y / AValue;
end;

function  Tg2dVec.Project(const AVector: Tg2dVec): Tg2dVec;
var
  LDP: Single;
begin
  LDP := DotProduct(AVector);
  Result.X := (LDP / (AVector.X * AVector.X + AVector.Y * AVector.Y)) * AVector.X;
  Result.Y := (LDP / (AVector.X * AVector.X + AVector.Y * AVector.Y)) * AVector.Y;
end;

procedure Tg2dVec.Negate();
begin
  X := -X;
  Y := -Y;
end;


{ Tg2dSize }
constructor Tg2dSize.Create(const AWidth, AHeight: Single);
begin
  Width := AWidth;
  Height := AHeight;
end;


{ Tg2dRect }
constructor Tg2dRect.Create(const AX, AY, AWidth, AHeight: Single);
begin
  Pos  := Tg2dVec.Create(AX, AY);
  Size := Tg2dSize.Create(AWidth, AHeight);
end;

constructor Tg2dRect.Create(const APos: Tg2dVec; const ASize: Tg2dSize);
begin
  Pos  := Tg2dVec.Create(APos.X, APos.Y);
  Size := Tg2dSize.Create(ASize.Width, ASize.Height);
end;

procedure Tg2dRect.Assign(const AX, AY, AW, AH: Single);
begin
  Pos.X := AX;
  Pos.Y := AY;
  Size.Width := AW;
  Size.Height := AH;
end;

procedure Tg2dRect.Assign(const ARect: Tg2dRect);
begin
  Pos.X := ARect.Pos.X;
  Pos.Y := ARect.Pos.Y;
  Size.Width := ARect.Size.Width;
  Size.Height := ARect.Size.Height;
end;

procedure Tg2dRect.Clear();
begin
  Pos.X := 0;
  Pos.Y := 0;
  Size.Width := 0;
  Size.Height := 0;
end;

function Tg2dRect.Intersect(const ARect: Tg2dRect): Boolean;
var
  LR1R, LR1B: Single;
  LR2R, LR2B: Single;
begin
  LR1R := Pos.X - (Size.Width - 1);
  LR1B := Pos.Y - (Size.Height - 1);
  LR2R := ARect.Pos.X - (ARect.Size.Width - 1);
  LR2B := ARect.Pos.Y - (ARect.Size.Height - 1);

  Result := (Pos.X < LR2R) and (LR1R > ARect.Pos.X) and (Pos.Y < LR2B) and (LR1B > ARect.Pos.Y);
end;

{ Tg2dRange }
constructor Tg2dRange.Create(const AMinX, AMinY, AMaxX, AMaxY: Single);
begin
  MinX := AMinX;
  MinY := AMinY;
  MaxX := AMaxX;
  MaxY := AMaxY;
end;

{ TpxMath }
class constructor Tg2dMath.Create();
var
  I: Integer;
begin
  inherited;

  System.Randomize();

  for I := 0 to 360 do
  begin
    FCosTable[I] := cos((I * PI / 180.0));
    FSinTable[I] := sin((I * PI / 180.0));
  end;

end;

class destructor  Tg2dMath.Destroy();
begin
  inherited;
end;

function _RandomRange(const aFrom, aTo: Integer): Integer;
var
  LFrom: Integer;
  LTo: Integer;
begin
  LFrom := aFrom;
  LTo := aTo;

  if AFrom > ATo then
    Result := Random(LFrom - LTo) + ATo
  else
    Result := Random(LTo - LFrom) + AFrom;
end;

class function  Tg2dMath.RandomRangeInt(const AMin, AMax: Integer): Integer;
begin
  Result := _RandomRange(AMin, AMax + 1);
end;

class function  Tg2dMath.RandomRangeFloat(const AMin, AMax: Single): Single;
var
  LNum: Single;
begin
  LNum := _RandomRange(0, MaxInt) / MaxInt;
  Result := AMin + (LNum * (AMax - AMin));
end;

class function  Tg2dMath.RandomBool: Boolean;
begin
  Result := Boolean(_RandomRange(0, 2) = 1);
end;

class function  Tg2dMath.GetRandomSeed: Integer;
begin
  Result := System.RandSeed;
end;

class procedure Tg2dMath.SetRandomSeed(const AValue: Integer);
begin
  System.RandSeed := AValue;
end;

class function  Tg2dMath.AngleCos(const AAngle: Integer): Single;
var
  LAngle: Integer;
begin
  LAngle := EnsureRange(AAngle, 0, 360);
  Result := FCosTable[LAngle];
end;

class function  Tg2dMath.AngleSin(const AAngle: Integer): Single;
var
  LAngle: Integer;
begin
  LAngle := EnsureRange(AAngle, 0, 360);
  Result := FSinTable[LAngle];
end;

class function  Tg2dMath.AngleDifference(const ASrcAngle, ADestAngle: Single): Single;
var
  LC: Single;
begin
  LC := ADestAngle - ASrcAngle -
    (Floor((ADestAngle - ASrcAngle) / 360.0) * 360.0);

  if LC >= (360.0 / 2) then
  begin
    LC := LC - 360.0;
  end;
  Result := LC;
end;

class procedure Tg2dMath.AngleRotatePos(const AAngle: Single; var AX: Single; var AY: Single);
var
  LNX, LNY: Single;
  LIA: Integer;
  LAngle: Single;
begin
  LAngle := AAngle;
  ClipValueFloat(LAngle, 0, 359, True);

  LIA := Round(LAngle);

  LNX := AX * FCosTable[LIA] - AY * FSinTable[LIA];
  LNY := AY * FCosTable[LIA] + AX * FSinTable[LIA];

  AX := LNX;
  AY := LNY;
end;

class function  Tg2dMath.ClipValueFloat(var AValue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single;
begin
  if AWrap then
    begin
      if (AValue > AMax) then
      begin
        AValue := AMin + Abs(AValue - AMax);
        if AValue > AMax then
          AValue := AMax;
      end
      else if (AValue < AMin) then
      begin
        AValue := AMax - Abs(AValue - AMin);
        if AValue < AMin then
          AValue := AMin;
      end
    end
  else
    begin
      if AValue < AMin then
        AValue := AMin
      else if AValue > AMax then
        AValue := AMax;
    end;

  Result := AValue;

end;

class function  Tg2dMath.ClipValueInt(var AValue: Integer; const AMin, AMax: Integer; const AWrap: Boolean): Integer;
begin
  if AWrap then
    begin
      if (AValue > AMax) then
      begin
        AValue := AMin + Abs(AValue - AMax);
        if AValue > AMax then
          AValue := AMax;
      end
      else if (AValue < AMin) then
      begin
        AValue := AMax - Abs(AValue - AMin);
        if AValue < AMin then
          AValue := AMin;
      end
    end
  else
    begin
      if AValue < AMin then
        AValue := AMin
      else if AValue > AMax then
        AValue := AMax;
    end;

  Result := AValue;
end;

class function  Tg2dMath.SameSignExt(const AValue1, AValue2: Integer): Boolean;
begin
  if System.Math.Sign(AValue1) = System.Math.Sign(AValue2) then
    Result := True
  else
    Result := False;
end;

class function  Tg2dMath.SameSignFloat(const AValue1, AValue2: Single): Boolean;
begin
  if System.Math.Sign(AValue1) = System.Math.Sign(AValue2) then
    Result := True
  else
    Result := False;
end;

class function  Tg2dMath.SameValueExt(const AA, AB: Double; const AEpsilon: Double): Boolean;
const
  CFuzzFactor = 1000;
  CDoubleResolution   = 1E-15 * CFuzzFactor;
var
  LEpsilon: Double;
begin
  LEpsilon := AEpsilon;
  if LEpsilon = 0 then
    LEpsilon := Max(Min(Abs(AA), Abs(AB)) * CDoubleResolution, CDoubleResolution);
  if AA > AB then
    Result := (AA - AB) <= LEpsilon
  else
    Result := (AB - AA) <= LEpsilon;
end;

class function  Tg2dMath.SameValueFloat(const AA, AB: Single; const AEpsilon: Single): Boolean;
begin
  Result := SameValueExt(AA, AB, AEpsilon);
end;

class procedure Tg2dMath.SmoothMove(var AValue: Single; const AAmount, AMax, ADrag: Single);
var
  LAmt: Single;
begin
  LAmt := AAmount;

  if LAmt > 0 then
  begin
    AValue := AValue + LAmt;
    if AValue > AMax then
      AValue := AMax;
  end else if LAmt < 0 then
  begin
    AValue := AValue + LAmt;
    if AValue < -AMax then
      AValue := -AMax;
  end else
  begin
    if AValue > 0 then
    begin
      AValue := AValue - ADrag;
      if AValue < 0 then
        AValue := 0;
    end else if AValue < 0 then
    begin
      AValue := AValue + ADrag;
      if AValue > 0 then
        AValue := 0;
    end;
  end;
end;

class function  Tg2dMath.Lerp(const AFrom,  ATo, ATime: Double): Double;
begin
  if ATime <= 0.5 then
    Result := AFrom + (ATo - AFrom) * ATime
  else
    Result := ATo - (ATo - AFrom) * (1.0 - ATime);
end;

// FIXED: Basic collision detection routines
class function Tg2dMath.PointInRectangle(const APoint: Tg2dVec; const ARect: Tg2dRect): Boolean;
begin
  Result := (APoint.X >= ARect.Pos.X) and (APoint.X <= (ARect.Pos.X + ARect.Size.Width)) and
            (APoint.Y >= ARect.Pos.Y) and (APoint.Y <= (ARect.Pos.Y + ARect.Size.Height));
end;

class function Tg2dMath.PointInCircle(const APoint, ACenter: Tg2dVec; const ARadius: Single): Boolean;
begin
  Result := CirclesOverlap(APoint, 0, ACenter, ARadius);
end;

class function Tg2dMath.PointInTriangle(const APoint, APoint1, APoint2, APoint3: Tg2dVec): Boolean;
var
  LDenominator: Single;
  LAlpha: Single;
  LBeta: Single;
  LGamma: Single;
begin
  Result := False;

  // Calculate denominator first to check for degenerate triangle
  LDenominator := (APoint2.Y - APoint3.Y) * (APoint1.X - APoint3.X) +
                  (APoint3.X - APoint2.X) * (APoint1.Y - APoint3.Y);

  // Check for degenerate triangle (zero area)
  if Abs(LDenominator) < 1e-10 then Exit;

  LAlpha := ((APoint2.Y - APoint3.Y) * (APoint.X - APoint3.X) +
             (APoint3.X - APoint2.X) * (APoint.Y - APoint3.Y)) / LDenominator;

  LBeta := ((APoint3.Y - APoint1.Y) * (APoint.X - APoint3.X) +
            (APoint1.X - APoint3.X) * (APoint.Y - APoint3.Y)) / LDenominator;

  LGamma := 1.0 - LAlpha - LBeta;

  Result := (LAlpha >= 0) and (LBeta >= 0) and (LGamma >= 0);
end;

class function Tg2dMath.CirclesOverlap(const ACenter1: Tg2dVec; const ARadius1: Single; const ACenter2: Tg2dVec; const ARadius2: Single): Boolean;
var
  LDistanceSquared: Single;
  LRadiusSum: Single;
begin
  // Use squared distance to avoid expensive sqrt
  LDistanceSquared := (ACenter2.X - ACenter1.X) * (ACenter2.X - ACenter1.X) +
                      (ACenter2.Y - ACenter1.Y) * (ACenter2.Y - ACenter1.Y);
  LRadiusSum := ARadius1 + ARadius2;

  Result := LDistanceSquared <= (LRadiusSum * LRadiusSum);
end;

// FIXED: Simplified circle-rectangle collision
class function Tg2dMath.CircleInRectangle(const ACenter: Tg2dVec; const ARadius: Single; const ARect: Tg2dRect): Boolean;
var
  LClosestX: Single;
  LClosestY: Single;
  LDistanceSquared: Single;
begin
  // Find closest point on rectangle to circle center
  LClosestX := ACenter.X;
  if LClosestX < ARect.Pos.X then
    LClosestX := ARect.Pos.X
  else if LClosestX > ARect.Pos.X + ARect.Size.Width then
    LClosestX := ARect.Pos.X + ARect.Size.Width;

  LClosestY := ACenter.Y;
  if LClosestY < ARect.Pos.Y then
    LClosestY := ARect.Pos.Y
  else if LClosestY > ARect.Pos.Y + ARect.Size.Height then
    LClosestY := ARect.Pos.Y + ARect.Size.Height;

  // Check if distance from circle center to closest point is within radius
  LDistanceSquared := (ACenter.X - LClosestX) * (ACenter.X - LClosestX) +
                      (ACenter.Y - LClosestY) * (ACenter.Y - LClosestY);

  Result := LDistanceSquared <= (ARadius * ARadius);
end;

class function Tg2dMath.RectanglesOverlap(const ARect1, ARect2: Tg2dRect): Boolean;
begin
  Result := (ARect1.Pos.X < ARect2.Pos.X + ARect2.Size.Width) and
            (ARect1.Pos.X + ARect1.Size.Width > ARect2.Pos.X) and
            (ARect1.Pos.Y < ARect2.Pos.Y + ARect2.Size.Height) and
            (ARect1.Pos.Y + ARect1.Size.Height > ARect2.Pos.Y);
end;

// FIXED: Simplified rectangle intersection
class function Tg2dMath.RectangleIntersection(const ARect1, ARect2: Tg2dRect): Tg2dRect;
var
  LLeft: Single;
  LTop: Single;
  LRight: Single;
  LBottom: Single;
begin
  Result.Assign(0, 0, 0, 0);

  if not RectanglesOverlap(ARect1, ARect2) then Exit;

  LLeft := Max(ARect1.Pos.X, ARect2.Pos.X);
  LTop := Max(ARect1.Pos.Y, ARect2.Pos.Y);
  LRight := Min(ARect1.Pos.X + ARect1.Size.Width, ARect2.Pos.X + ARect2.Size.Width);
  LBottom := Min(ARect1.Pos.Y + ARect1.Size.Height, ARect2.Pos.Y + ARect2.Size.Height);

  Result.Pos.X := LLeft;
  Result.Pos.Y := LTop;
  Result.Size.Width := LRight - LLeft;
  Result.Size.Height := LBottom - LTop;
end;

// SIMPLIFIED: Line intersection (keeping your implementation but cleaned up)
class function Tg2dMath.LineIntersection(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Integer; var AX: Integer; var AY: Integer): Tg2dLineIntersection;
var
  LAX: Integer;
  LBX: Integer;
  LCX: Integer;
  LAY: Integer;
  LBY: Integer;
  LCY: Integer;
  LD: Integer;
  LE: Integer;
  LF: Integer;
  LNum: Integer;
  LOffset: Integer;
  LX1Lo: Integer;
  LX1Hi: Integer;
  LY1Lo: Integer;
  LY1Hi: Integer;
begin
  Result := liNone;

  LAX := AX2 - AX1;
  LBX := AX3 - AX4;

  // X bound box test
  if LAX < 0 then
  begin
    LX1Lo := AX2;
    LX1Hi := AX1;
  end
  else
  begin
    LX1Hi := AX2;
    LX1Lo := AX1;
  end;

  if LBX > 0 then
  begin
    if (LX1Hi < AX4) or (AX3 < LX1Lo) then Exit;
  end
  else
  begin
    if (LX1Hi < AX3) or (AX4 < LX1Lo) then Exit;
  end;

  LAY := AY2 - AY1;
  LBY := AY3 - AY4;

  // Y bound box test
  if LAY < 0 then
  begin
    LY1Lo := AY2;
    LY1Hi := AY1;
  end
  else
  begin
    LY1Hi := AY2;
    LY1Lo := AY1;
  end;

  if LBY > 0 then
  begin
    if (LY1Hi < AY4) or (AY3 < LY1Lo) then Exit;
  end
  else
  begin
    if (LY1Hi < AY3) or (AY4 < LY1Lo) then Exit;
  end;

  LCX := AX1 - AX3;
  LCY := AY1 - AY3;
  LD := LBY * LCX - LBX * LCY;
  LF := LAY * LBX - LAX * LBY;

  if LF > 0 then
  begin
    if (LD < 0) or (LD > LF) then Exit;
  end
  else
  begin
    if (LD > 0) or (LD < LF) then Exit;
  end;

  LE := LAX * LCY - LAY * LCX;
  if LF > 0 then
  begin
    if (LE < 0) or (LE > LF) then Exit;
  end
  else
  begin
    if (LE > 0) or (LE < LF) then Exit;
  end;

  if LF = 0 then
  begin
    Result := liParallel;
    Exit;
  end;

  LNum := LD * LAX;
  if Sign(LNum) = Sign(LF) then
    LOffset := LF div 2
  else
    LOffset := -LF div 2;
  AX := AX1 + (LNum + LOffset) div LF;

  LNum := LD * LAY;
  if Sign(LNum) = Sign(LF) then
    LOffset := LF div 2
  else
    LOffset := -LF div 2;

  AY := AY1 + (LNum + LOffset) div LF;

  Result := liTrue;
end;

// REMOVED: RadiusOverlap (use CirclesOverlap instead)

// NEW: Additional useful collision routines

// Point to line distance
class function Tg2dMath.PointToLineDistance(const APoint, ALineStart, ALineEnd: Tg2dVec): Single;
var
  LA: Single;
  LB: Single;
  LC: Single;
begin
  LA := ALineEnd.Y - ALineStart.Y;
  LB := ALineStart.X - ALineEnd.X;
  LC := ALineEnd.X * ALineStart.Y - ALineStart.X * ALineEnd.Y;

  Result := Abs(LA * APoint.X + LB * APoint.Y + LC) / Sqrt(LA * LA + LB * LB);
end;

// Point to line segment distance
class function Tg2dMath.PointToLineSegmentDistance(const APoint, ALineStart, ALineEnd: Tg2dVec): Single;
var
  LLength: Single;
  LT: Single;
  LProjection: Tg2dVec;
begin
  LLength := ALineStart.Distance(ALineEnd);
  if LLength < 1e-10 then
  begin
    Result := APoint.Distance(ALineStart);
    Exit;
  end;

  LT := ((APoint.X - ALineStart.X) * (ALineEnd.X - ALineStart.X) +
         (APoint.Y - ALineStart.Y) * (ALineEnd.Y - ALineStart.Y)) / (LLength * LLength);

  if LT < 0 then
    Result := APoint.Distance(ALineStart)
  else if LT > 1 then
    Result := APoint.Distance(ALineEnd)
  else
  begin
    LProjection.X := ALineStart.X + LT * (ALineEnd.X - ALineStart.X);
    LProjection.Y := ALineStart.Y + LT * (ALineEnd.Y - ALineStart.Y);
    Result := APoint.Distance(LProjection);
  end;
end;

// Line segment to circle collision
class function Tg2dMath.LineSegmentIntersectsCircle(const ALineStart, ALineEnd, ACenter: Tg2dVec; const ARadius: Single): Boolean;
begin
  Result := PointToLineSegmentDistance(ACenter, ALineStart, ALineEnd) <= ARadius;
end;

// Closest point on line segment to a point
class function Tg2dMath.ClosestPointOnLineSegment(const APoint, ALineStart, ALineEnd: Tg2dVec): Tg2dVec;
var
  LLength: Single;
  LT: Single;
begin
  LLength := ALineStart.Distance(ALineEnd);
  if LLength < 1e-10 then
  begin
    Result := ALineStart;
    Exit;
  end;

  LT := ((APoint.X - ALineStart.X) * (ALineEnd.X - ALineStart.X) +
         (APoint.Y - ALineStart.Y) * (ALineEnd.Y - ALineStart.Y)) / (LLength * LLength);

  if LT < 0 then
    Result := ALineStart
  else if LT > 1 then
    Result := ALineEnd
  else
  begin
    Result.X := ALineStart.X + LT * (ALineEnd.X - ALineStart.X);
    Result.Y := ALineStart.Y + LT * (ALineEnd.Y - ALineStart.Y);
  end;
end;

class function Tg2dMath.OBBsOverlap(const AOBB1, AOBB2: Tg2dOBB): Boolean;
var
  LCos1: Single;
  LSin1: Single;
  LCos2: Single;
  LSin2: Single;
  LDX: Single;
  LDY: Single;
  LAxis: array[0..3] of Tg2dVec;
  LI: Integer;
  LProjection1: Single;
  LProjection2: Single;
  LRadians1: Single;
  LRadians2: Single;
begin
  // Convert degrees to radians
  LRadians1 := DegToRad(AOBB1.Rotation);
  LRadians2 := DegToRad(AOBB2.Rotation);

  // Get rotation values
  LCos1 := Cos(LRadians1);
  LSin1 := Sin(LRadians1);
  LCos2 := Cos(LRadians2);
  LSin2 := Sin(LRadians2);

  // Vector between centers
  LDX := AOBB2.Center.X - AOBB1.Center.X;
  LDY := AOBB2.Center.Y - AOBB1.Center.Y;

  // Separating axes (4 total: 2 for each OBB)
  LAxis[0].X := LCos1; LAxis[0].Y := LSin1;     // OBB1 X axis
  LAxis[1].X := -LSin1; LAxis[1].Y := LCos1;    // OBB1 Y axis
  LAxis[2].X := LCos2; LAxis[2].Y := LSin2;     // OBB2 X axis
  LAxis[3].X := -LSin2; LAxis[3].Y := LCos2;    // OBB2 Y axis

  // Test each axis
  for LI := 0 to 3 do
  begin
    // Project both OBBs onto this axis
    LProjection1 := Abs(LDX * LAxis[LI].X + LDY * LAxis[LI].Y);
    LProjection2 := Abs(AOBB1.HalfWidth * (LCos1 * LAxis[LI].X + LSin1 * LAxis[LI].Y)) +
                    Abs(AOBB1.HalfHeight * (-LSin1 * LAxis[LI].X + LCos1 * LAxis[LI].Y)) +
                    Abs(AOBB2.HalfWidth * (LCos2 * LAxis[LI].X + LSin2 * LAxis[LI].Y)) +
                    Abs(AOBB2.HalfHeight * (-LSin2 * LAxis[LI].X + LCos2 * LAxis[LI].Y));

    // Check for separation
    if LProjection1 > LProjection2 then
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;


// Polygon collision (simple convex polygon)
class function Tg2dMath.PointInConvexPolygon(const APoint: Tg2dVec; const AVertices: array of Tg2dVec): Boolean;
var
  LI: Integer;
  LJ: Integer;
  LCount: Integer;
begin
  Result := False;
  LCount := Length(AVertices);
  if LCount < 3 then Exit;

  LJ := LCount - 1;
  for LI := 0 to LCount - 1 do
  begin
    if ((AVertices[LI].Y > APoint.Y) <> (AVertices[LJ].Y > APoint.Y)) and
       (APoint.X < (AVertices[LJ].X - AVertices[LI].X) * (APoint.Y - AVertices[LI].Y) /
        (AVertices[LJ].Y - AVertices[LI].Y) + AVertices[LI].X) then
      Result := not Result;
    LJ := LI;
  end;
end;

// Fast AABB vs Ray intersection
class function Tg2dMath.RayIntersectsAABB(const ARay: Tg2dRay; const ARect: Tg2dRect; out ADistance: Single): Boolean;
var
  LInvDirX: Single;
  LInvDirY: Single;
  LT1: Single;
  LT2: Single;
  LTMin: Single;
  LTMax: Single;
  LTemp: Single;
begin
  Result := False;
  ADistance := 0;

  // Avoid division by zero
  if Abs(ARay.Direction.X) < 1e-10 then
    LInvDirX := 1e10
  else
    LInvDirX := 1.0 / ARay.Direction.X;

  if Abs(ARay.Direction.Y) < 1e-10 then
    LInvDirY := 1e10
  else
    LInvDirY := 1.0 / ARay.Direction.Y;

  // Calculate t values for X slabs
  LT1 := (ARect.Pos.X - ARay.Origin.X) * LInvDirX;
  LT2 := (ARect.Pos.X + ARect.Size.Width - ARay.Origin.X) * LInvDirX;

  if LT1 > LT2 then
  begin
    LTemp := LT1;
    LT1 := LT2;
    LT2 := LTemp;
  end;

  LTMin := LT1;
  LTMax := LT2;

  // Calculate t values for Y slabs
  LT1 := (ARect.Pos.Y - ARay.Origin.Y) * LInvDirY;
  LT2 := (ARect.Pos.Y + ARect.Size.Height - ARay.Origin.Y) * LInvDirY;

  if LT1 > LT2 then
  begin
    LTemp := LT1;
    LT1 := LT2;
    LT2 := LTemp;
  end;

  LTMin := Max(LTMin, LT1);
  LTMax := Min(LTMax, LT2);

  if (LTMax >= 0) and (LTMin <= LTMax) then
  begin
    ADistance := LTMin;
    if ADistance < 0 then
      ADistance := LTMax;
    Result := ADistance >= 0;
  end;
end;


class function Tg2dMath.EaseValue(const ACurrentTime, AStartValue, AChangeInValue, ADuration: Double; const AEase: Tg2dEaseType): Double;
var
  LNormalizedTime: Double;
  LHalfDuration: Double;
  LTemp: Double;
begin
  Result := AStartValue;

  // Input validation
  if ADuration <= 0 then Exit;
  if ACurrentTime < 0 then Exit;

  // Clamp current time to duration
  LNormalizedTime := ACurrentTime;
  if LNormalizedTime > ADuration then
    LNormalizedTime := ADuration;

  case AEase of
    etLinearTween:
      begin
        Result := AChangeInValue * LNormalizedTime / ADuration + AStartValue;
      end;

    etInQuad:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        Result := AChangeInValue * LNormalizedTime * LNormalizedTime + AStartValue;
      end;

    etOutQuad:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        Result := -AChangeInValue * LNormalizedTime * (LNormalizedTime - 2) + AStartValue;
      end;

    etInOutQuad:
      begin
        LHalfDuration := ADuration / 2;
        LNormalizedTime := LNormalizedTime / LHalfDuration;
        if LNormalizedTime < 1 then
          Result := AChangeInValue / 2 * LNormalizedTime * LNormalizedTime + AStartValue
        else
        begin
          LNormalizedTime := LNormalizedTime - 1;
          Result := -AChangeInValue / 2 * (LNormalizedTime * (LNormalizedTime - 2) - 1) + AStartValue;
        end;
      end;

    etInCubic:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        Result := AChangeInValue * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue;
      end;

    etOutCubic:
      begin
        LNormalizedTime := (LNormalizedTime / ADuration) - 1;
        Result := AChangeInValue * (LNormalizedTime * LNormalizedTime * LNormalizedTime + 1) + AStartValue;
      end;

    etInOutCubic:
      begin
        LHalfDuration := ADuration / 2;
        LNormalizedTime := LNormalizedTime / LHalfDuration;
        if LNormalizedTime < 1 then
          Result := AChangeInValue / 2 * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue
        else
        begin
          LNormalizedTime := LNormalizedTime - 2;
          Result := AChangeInValue / 2 * (LNormalizedTime * LNormalizedTime * LNormalizedTime + 2) + AStartValue;
        end;
      end;

    etInQuart:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        Result := AChangeInValue * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue;
      end;

    etOutQuart:
      begin
        LNormalizedTime := (LNormalizedTime / ADuration) - 1;
        Result := -AChangeInValue * (LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime - 1) + AStartValue;
      end;

    etInOutQuart:
      begin
        LHalfDuration := ADuration / 2;
        LNormalizedTime := LNormalizedTime / LHalfDuration;
        if LNormalizedTime < 1 then
          Result := AChangeInValue / 2 * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue
        else
        begin
          LNormalizedTime := LNormalizedTime - 2;
          Result := -AChangeInValue / 2 * (LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime - 2) + AStartValue;
        end;
      end;

    etInQuint:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        Result := AChangeInValue * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue;
      end;

    etOutQuint:
      begin
        LNormalizedTime := (LNormalizedTime / ADuration) - 1;
        Result := AChangeInValue * (LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + 1) + AStartValue;
      end;

    etInOutQuint:
      begin
        LHalfDuration := ADuration / 2;
        LNormalizedTime := LNormalizedTime / LHalfDuration;
        if LNormalizedTime < 1 then
          Result := AChangeInValue / 2 * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + AStartValue
        else
        begin
          LNormalizedTime := LNormalizedTime - 2;
          Result := AChangeInValue / 2 * (LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime * LNormalizedTime + 2) + AStartValue;
        end;
      end;

    etInSine:
      begin
        Result := -AChangeInValue * Cos(LNormalizedTime / ADuration * (PI / 2)) + AChangeInValue + AStartValue;
      end;

    etOutSine:
      begin
        Result := AChangeInValue * Sin(LNormalizedTime / ADuration * (PI / 2)) + AStartValue;
      end;

    etInOutSine:
      begin
        Result := -AChangeInValue / 2 * (Cos(PI * LNormalizedTime / ADuration) - 1) + AStartValue;
      end;

    etInExpo:
      begin
        if LNormalizedTime = 0 then
          Result := AStartValue
        else
          Result := AChangeInValue * Power(2, 10 * (LNormalizedTime / ADuration - 1)) + AStartValue;
      end;

    etOutExpo:
      begin
        if LNormalizedTime = ADuration then
          Result := AStartValue + AChangeInValue
        else
          Result := AChangeInValue * (-Power(2, -10 * LNormalizedTime / ADuration) + 1) + AStartValue;
      end;

    etInOutExpo:
      begin
        if LNormalizedTime = 0 then
          Result := AStartValue
        else if LNormalizedTime = ADuration then
          Result := AStartValue + AChangeInValue
        else
        begin
          LHalfDuration := ADuration / 2;
          LNormalizedTime := LNormalizedTime / LHalfDuration;
          if LNormalizedTime < 1 then
            Result := AChangeInValue / 2 * Power(2, 10 * (LNormalizedTime - 1)) + AStartValue
          else
          begin
            LNormalizedTime := LNormalizedTime - 1;
            Result := AChangeInValue / 2 * (-Power(2, -10 * LNormalizedTime) + 2) + AStartValue;
          end;
        end;
      end;

    etInCircle:
      begin
        LNormalizedTime := LNormalizedTime / ADuration;
        LTemp := 1 - LNormalizedTime * LNormalizedTime;
        if LTemp < 0 then LTemp := 0; // Prevent negative sqrt
        Result := -AChangeInValue * (Sqrt(LTemp) - 1) + AStartValue;
      end;

    etOutCircle:
      begin
        LNormalizedTime := (LNormalizedTime / ADuration) - 1;
        LTemp := 1 - LNormalizedTime * LNormalizedTime;
        if LTemp < 0 then LTemp := 0; // Prevent negative sqrt
        Result := AChangeInValue * Sqrt(LTemp) + AStartValue;
      end;

    etInOutCircle:
      begin
        LHalfDuration := ADuration / 2;
        LNormalizedTime := LNormalizedTime / LHalfDuration;
        if LNormalizedTime < 1 then
        begin
          LTemp := 1 - LNormalizedTime * LNormalizedTime;
          if LTemp < 0 then LTemp := 0; // Prevent negative sqrt
          Result := -AChangeInValue / 2 * (Sqrt(LTemp) - 1) + AStartValue;
        end
        else
        begin
          LNormalizedTime := LNormalizedTime - 2;
          LTemp := 1 - LNormalizedTime * LNormalizedTime;
          if LTemp < 0 then LTemp := 0; // Prevent negative sqrt
          Result := AChangeInValue / 2 * (Sqrt(LTemp) + 1) + AStartValue;
        end;
      end;
  end;
end;

class function Tg2dMath.EasePosition(const AStartPos, AEndPos, ACurrentPos: Double; const AEase: Tg2dEaseType): Double;
var
  LProgress: Double;
  LRange: Double;
  LClampedPos: Double;
begin
  Result := AStartPos;

  // Input validation
  if AStartPos = AEndPos then Exit;

  // Calculate range and clamp current position
  LRange := Abs(AEndPos - AStartPos);
  LClampedPos := ACurrentPos;

  // Clamp current position to valid range
  if AStartPos < AEndPos then
  begin
    if LClampedPos < AStartPos then LClampedPos := AStartPos;
    if LClampedPos > AEndPos then LClampedPos := AEndPos;
  end
  else
  begin
    if LClampedPos > AStartPos then LClampedPos := AStartPos;
    if LClampedPos < AEndPos then LClampedPos := AEndPos;
  end;

  // Calculate progress (0 to 100)
  if AStartPos < AEndPos then
    LProgress := ((LClampedPos - AStartPos) / LRange) * 100
  else
    LProgress := ((AStartPos - LClampedPos) / LRange) * 100;

  // Apply easing
  Result := EaseValue(LProgress, 0, 100, 100, AEase);

  // Clamp result to 0-100 range
  if Result < 0 then Result := 0;
  if Result > 100 then Result := 100;
end;

// Normalized easing - returns 0.0 to 1.0 curve value
class function Tg2dMath.EaseNormalized(const AProgress: Double; const AEase: Tg2dEaseType): Double;
var
  LClampedProgress: Double;
begin
  // Clamp progress to 0-1 range
  LClampedProgress := AProgress;
  if LClampedProgress < 0 then LClampedProgress := 0;
  if LClampedProgress > 1 then LClampedProgress := 1;

  // Use existing EaseValue with normalized parameters
  Result := EaseValue(LClampedProgress, 0.0, 1.0, 1.0, AEase);
end;

// Interpolate between any two values with easing
class function Tg2dMath.EaseLerp(const AFrom, ATo: Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
var
  LNormalizedCurve: Double;
begin
  LNormalizedCurve := EaseNormalized(AProgress, AEase);
  Result := AFrom + (ATo - AFrom) * LNormalizedCurve;
end;

// Vector/Point easing
class function Tg2dMath.EaseVector(const AFrom, ATo: Tg2dVec; const AProgress: Double; const AEase: Tg2dEaseType): Tg2dVec;
begin
  Result.X := EaseLerp(AFrom.X, ATo.X, AProgress, AEase);
  Result.Y := EaseLerp(AFrom.Y, ATo.Y, AProgress, AEase);
end;

// Smooth interpolation (smoothstep function - very commonly used)
class function Tg2dMath.EaseSmooth(const AFrom, ATo: Double; const AProgress: Double): Double;
var
  LClampedProgress: Double;
  LSmoothProgress: Double;
begin
  // Clamp progress to 0-1 range
  LClampedProgress := AProgress;
  if LClampedProgress < 0 then LClampedProgress := 0;
  if LClampedProgress > 1 then LClampedProgress := 1;

  // Smoothstep formula: 3t² - 2t³
  LSmoothProgress := LClampedProgress * LClampedProgress * (3.0 - 2.0 * LClampedProgress);

  Result := AFrom + (ATo - AFrom) * LSmoothProgress;
end;

// Angle easing (handles 360° wrapping)
class function Tg2dMath.EaseAngle(const AFrom, ATo: Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
var
  LDifference: Double;
  LNormalizedCurve: Double;
begin
  // Calculate shortest path between angles
  LDifference := ATo - AFrom;

  // Normalize to -180 to 180 range
  while LDifference > 180 do
    LDifference := LDifference - 360;
  while LDifference < -180 do
    LDifference := LDifference + 360;

  LNormalizedCurve := EaseNormalized(AProgress, AEase);
  Result := AFrom + LDifference * LNormalizedCurve;

  // Keep result in 0-360 range
  while Result < 0 do
    Result := Result + 360;
  while Result >= 360 do
    Result := Result - 360;
end;

// Multi-keyframe easing (animate through multiple points)
class function Tg2dMath.EaseKeyframes(const AKeyframes: array of Double; const AProgress: Double; const AEase: Tg2dEaseType): Double;
var
  LSegmentCount: Integer;
  LSegmentIndex: Integer;
  LSegmentProgress: Double;
  LSegmentSize: Double;
begin
  Result := 0.0;

  LSegmentCount := Length(AKeyframes) - 1;
  if LSegmentCount <= 0 then Exit;

  // Clamp progress
  if AProgress <= 0 then
  begin
    Result := AKeyframes[0];
    Exit;
  end;
  if AProgress >= 1 then
  begin
    Result := AKeyframes[High(AKeyframes)];
    Exit;
  end;

  // Find which segment we're in
  LSegmentSize := 1.0 / LSegmentCount;
  LSegmentIndex := Trunc(AProgress / LSegmentSize);

  // Prevent index overflow
  if LSegmentIndex >= LSegmentCount then
    LSegmentIndex := LSegmentCount - 1;

  // Calculate progress within this segment
  LSegmentProgress := (AProgress - (LSegmentIndex * LSegmentSize)) / LSegmentSize;

  // Ease between the two keyframe values
  Result := EaseLerp(AKeyframes[LSegmentIndex], AKeyframes[LSegmentIndex + 1], LSegmentProgress, AEase);
end;

// Looping/repeating animations
class function Tg2dMath.EaseLoop(const ATime, ADuration: Double; const AEase: Tg2dEaseType; const ALoopMode: Tg2dLoopMode): Double;
var
  LNormalizedTime: Double;
  LCycleTime: Double;
  LProgress: Double;
begin
  Result := 0.0;

  if ADuration <= 0 then Exit;

  case ALoopMode of
    pxLoopNone:
      begin
        LProgress := ATime / ADuration;
        if LProgress > 1 then LProgress := 1;
        Result := EaseNormalized(LProgress, AEase);
      end;

    pxLoopRepeat:
      begin
        LCycleTime := Fmod(ATime, ADuration);
        LProgress := LCycleTime / ADuration;
        Result := EaseNormalized(LProgress, AEase);
      end;

    pxLoopPingPong:
      begin
        LNormalizedTime := ATime / ADuration;
        LCycleTime := Fmod(LNormalizedTime, 2.0);
        if LCycleTime <= 1.0 then
          LProgress := LCycleTime
        else
          LProgress := 2.0 - LCycleTime; // Reverse direction
        Result := EaseNormalized(LProgress, AEase);
      end;

    pxLoopReverse:
      begin
        LCycleTime := Fmod(ATime, ADuration);
        LProgress := 1.0 - (LCycleTime / ADuration);
        Result := EaseNormalized(LProgress, AEase);
      end;
  end;
end;

// Stepped/discrete easing (for pixel-perfect or discrete animations)
class function Tg2dMath.EaseStepped(const AFrom, ATo: Double; const AProgress: Double; const ASteps: Integer; const AEase: Tg2dEaseType): Double;
var
  LStepSize: Double;
  LStepIndex: Integer;
  LStepProgress: Double;
begin
  if ASteps <= 1 then
  begin
    Result := EaseLerp(AFrom, ATo, AProgress, AEase);
    Exit;
  end;

  LStepSize := 1.0 / (ASteps - 1);
  LStepIndex := Round(AProgress / LStepSize);

  if LStepIndex >= ASteps then
    LStepIndex := ASteps - 1;

  LStepProgress := LStepIndex * LStepSize;
  Result := EaseLerp(AFrom, ATo, LStepProgress, AEase);
end;

// Spring-based easing (more natural physics motion)
class function Tg2dMath.EaseSpring(const ATime: Double; const AAmplitude: Double = 1.0; const APeriod: Double = 0.3): Double;
var
  LDampening: Double;
  LAngularFreq: Double;
begin
  if ATime <= 0 then
  begin
    Result := 0.0;
    Exit;
  end;
  if ATime >= 1 then
  begin
    Result := 1.0;
    Exit;
  end;

  LDampening := 0.3;
  LAngularFreq := 2 * PI / APeriod;

  Result := 1 - (AAmplitude * Power(2, -10 * ATime) * Sin((ATime - LDampening / 4) * LAngularFreq));
end;

// Bezier curve easing (custom curves)
class function Tg2dMath.EaseBezier(const AProgress: Double; const AX1, AY1, AX2, AY2: Double): Double;
var
  LT: Double;
  LInvT: Double;
begin
  // Simplified cubic bezier calculation
  // For full implementation, you'd need iterative solving
  LT := AProgress;
  LInvT := 1.0 - LT;

  // Cubic bezier: (1-t)³P₀ + 3(1-t)²tP₁ + 3(1-t)t²P₂ + t³P₃
  // Where P₀=(0,0), P₁=(AX1,AY1), P₂=(AX2,AY2), P₃=(1,1)
  Result := 3 * LInvT * LInvT * LT * AY1 +
            3 * LInvT * LT * LT * AY2 +
            LT * LT * LT;
end;

// Easing with overshoot/undershoot control
class function Tg2dMath.EaseWithParams(const AProgress: Double; const AEase: Tg2dEaseType; const AParams: Tg2dEaseParams): Double;
begin
  case AEase of
    etInElastic,
    etOutElastic,
    etInOutElastic:
      Result := EaseSpring(AProgress, AParams.Amplitude, AParams.Period);
    etInBack,
    etOutBack,
    etInOutBack:
      begin
        // Back easing with overshoot parameter
        if AProgress < 0.5 then
          Result := 2 * AProgress * AProgress * ((AParams.Overshoot + 1) * 2 * AProgress - AParams.Overshoot)
        else
          Result := 1 + 2 * (AProgress - 1) * (AProgress - 1) * ((AParams.Overshoot + 1) * 2 * (AProgress - 1) + AParams.Overshoot);
      end;
    else
      Result := EaseNormalized(AProgress, AEase);
  end;
end;

class function Tg2dMath.IfThen(const ACondition: Boolean; const ATrueValue, AFalseValue: string): string;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

class function Tg2dMath.FloatToStr(const AValue: Single): string;
begin
  Result := FormatFloat('0.##', AValue);
end;

//=== IO =======================================================================
{ T2dIO }
constructor Tg2dIO.Create();
begin
  inherited;
end;

destructor Tg2dIO.Destroy();
begin
  Close();

  inherited;
end;

function  Tg2dIO.IsOpen(): Boolean;
begin
  Result := FAlse;
end;

procedure Tg2dIO.Close();
begin
end;

function  Tg2dIO.Size(): Int64;
begin
  Result := -1;
end;

function  Tg2dIO.Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64;
begin
  Result := -1;
end;

function  Tg2dIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
end;

function  Tg2dIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
end;

function  Tg2dIO.Pos(): Int64;
begin
  Result := -1;
end;

function  Tg2dIO.Eos(): Boolean;
begin
  Result := False;
end;

{ Tg2dMemoryIO }
function  Tg2dMemoryIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure Tg2dMemoryIO.Close();
begin
  if Assigned(FHandle) then
  begin
    FHandle.Free();
    FHandle := nil;
  end;
end;

function  Tg2dMemoryIO.Size(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Size;
end;

function  Tg2dMemoryIO.Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Seek(AOffset, Ord(ASeek));
end;

function  Tg2dMemoryIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

 Result := FHandle.Read(AData^, ASize);
end;

function  Tg2dMemoryIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Write(AData^, ASize);
end;

function  Tg2dMemoryIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Position;
end;

function  Tg2dMemoryIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

function  Tg2dMemoryIO.Open(const AData: Pointer; ASize: Int64): Boolean;
begin
  Result := False;
  if Assigned(FHandle) then Exit;

  FHandle := TMemoryStream.Create();
  FHandle.Write(AData^, ASize);
  FHandle.Position := 0;
end;

function  Tg2dMemoryIO.Open(const ASize: Int64): Boolean;
begin
  Result := False;
  if Assigned(FHandle) then Exit;

  FHandle := TMemoryStream.Create();
  FHandle.SetSize(ASize);
  FHandle.Position := 0;
end;

function  Tg2dMemoryIO.Memory(): Pointer;
begin
  Result := nil;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Memory;
end;

function  Tg2dMemoryIO.SaveToFile(const AFilename: string): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  FHandle.SaveToFile(AFilename);
end;

{ Tg2dFileIO }
function  Tg2dFileIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure Tg2dFileIO.Close();
begin
  if Assigned(FHandle) then
  begin
    FHandle.Free();
    FHandle := nil;
  end;
end;

function  Tg2dFileIO.Size(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Size;
end;

function  Tg2dFileIO.Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64;
begin
  Result := FHandle.Seek(AOffset, Ord(ASeek));
end;

function  Tg2dFileIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

 Result := FHandle.Read(AData^, ASize);
end;

function  Tg2dFileIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Write(AData^, ASize);
end;

function  Tg2dFileIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Position;
end;

function  Tg2dFileIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

function Tg2dFileIO.Open(const AFilename: string; const AMode: Tg2dIOMode): Boolean;
var
  LHandle: TFileStream;
  LMode: Tg2dIOMode;
begin
  Result := False;
  LHandle := nil;

  if AFilename.IsEmpty then Exit;

  if not TFile.Exists(AFilename) then
  begin
    Exit;
  end;

  LMode := AMode;

  try
    case AMode of
      iomRead:
      begin
        LHandle := TFile.OpenRead(AFilename);
      end;

      iomWrite:
      begin
        LHandle := TFile.OpenWrite(AFilename);
      end;
    end;
  except
    LHandle := nil;
  end;

  if not Assigned(LHandle) then
  begin
    Exit;
  end;

  FHandle := LHandle;
  FMode := LMode;

  Result := True;
end;

{ Tg2dZipFileIO }
function  Tg2dZipFileIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure Tg2dZipFileIO.Close();
begin
  if not Assigned(FHandle) then Exit;

  Assert(unzCloseCurrentFile(FHandle) = UNZ_OK);
  Assert(unzClose(FHandle) = UNZ_OK);
  FHandle := nil;
end;

function  Tg2dZipFileIO.Size(): Int64;
var
  LInfo: unz_file_info64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  unzGetCurrentFileInfo64(FHandle, @LInfo, nil, 0, nil, 0, nil, 0);
  Result := LInfo.uncompressed_size;
end;

function  Tg2dZipFileIO.Seek(const AOffset: Int64; const ASeek: Tg2dSeekMode): Int64;
const
  CBufferSize = 1024*4;
var
  LFileInfo: unz_file_info64;
  LCurrentOffset, LBytesToRead: UInt64;
  LOffset: Int64;
  LBuffer: TArray<Byte>;

  procedure SeekToLoc;
  begin
    LBytesToRead := UInt64(LOffset) - unztell64(FHandle);
    while LBytesToRead > 0 do
    begin
      if LBytesToRead > CBufferSize then
        unzReadCurrentFile(FHandle, @LBuffer[0], CBufferSize)
      else
        unzReadCurrentFile(FHandle, @LBuffer[0], LBytesToRead);

      LBytesToRead := UInt64(LOffset) - unztell64(FHandle);
    end;
  end;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  if (FHandle = nil) or (unzGetCurrentFileInfo64(FHandle, @LFileInfo, nil, 0, nil, 0, nil, 0) <> UNZ_OK) then
  begin
    Exit;
  end;

  SetLength(LBuffer, CBufferSize);

  LOffset := AOffset;

  LCurrentOffset := unztell64(FHandle);
  if LCurrentOffset = -1 then Exit;

  case ASeek of
    // offset is already relative to the start of the file
    smStart: ;

    // offset is relative to current position
    smCurrent: Inc(LOffset, LCurrentOffset);

    // offset is relative to end of the file
    smEnd: Inc(LOffset, LFileInfo.uncompressed_size);
  else
    Exit;
  end;

  if LOffset < 0 then Exit

  else if AOffset > LCurrentOffset then
    begin
      SeekToLoc();
    end
  else // offset < current_offset
    begin
      unzCloseCurrentFile(FHandle);
      unzLocateFile(FHandle, PAnsiChar(FFilename), 0);
      unzOpenCurrentFilePassword(FHandle, PAnsiChar(FPassword));
      SeekToLoc();
    end;

  Result := unztell64(FHandle);
end;

function  Tg2dZipFileIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := unzReadCurrentFile(FHandle, AData, ASize);
end;

function  Tg2dZipFileIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;
end;

function  Tg2dZipFileIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := unztell64(FHandle);
end;

function  Tg2dZipFileIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

(*
procedure TZipFileIO_BuildProgress(const AFilename: string; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer);
begin
  if aNewFile then PyConsole.PrintLn('', []);
  PyConsole.Print(PyCR+'Adding %s(%d%s)...', [ExtractFileName(string(aFilename)), aProgress, '%']);
end;
*)

procedure TZipFileIO_BuildProgress(const AFilename: string; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer);
begin
  if aNewFile then WriteLn;
  Write(#13+Format('Adding %s(%d%s)...', [ExtractFileName(string(aFilename)), aProgress, '%']));
end;

function Tg2dZipFileIO.Open(const AZipFilename, AFilename: string; const APassword: string): Boolean;
var
  LPassword: PAnsiChar;
  LZipFilename: PAnsiChar;
  LFilename: PAnsiChar;
  LFile: unzFile;
begin
  Result := False;

  LPassword := PAnsiChar(AnsiString(APassword));
  LZipFilename := PAnsiChar(AnsiString(StringReplace(string(AZipFilename), '/', '\', [rfReplaceAll])));
  LFilename := PAnsiChar(AnsiString(StringReplace(string(AFilename), '/', '\', [rfReplaceAll])));

  LFile := unzOpen64(LZipFilename);
  if not Assigned(LFile) then Exit;

  if unzLocateFile(LFile, LFilename, 0) <> UNZ_OK then
  begin
    unzClose(LFile);
    Exit;
  end;

  if unzOpenCurrentFilePassword(LFile, LPassword) <> UNZ_OK then
  begin
    unzClose(LFile);
    Exit;
  end;

  FHandle := LFile;
  FPassword := LPassword;
  FFilename := LFilename;

  Result := True;
end;

class function Tg2dZipFileIO.Init(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dZipFileIO;
begin
  Result := Tg2dZipFileIO.Create();
  if not Result.Open(AZipFilename, AFilename, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

class function Tg2dZipFileIO.Load(const AZipFilename, AFilename: string; const APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Tg2dMemoryIO;
var
  LIO: Tg2dZipFileIO;
begin
  LIO := Tg2dZipFileIO.Init(AZipFilename, AFilename, APassword);
  Result := Tg2dMemoryIO.Create();
  Result.Open(LIO.Size());
  LIO.Read(Result.Memory, LIO.Size);
  LIO.Free();
  Result.Seek(0, smStart);
end;


class function Tg2dZipFileIO.Build(const AZipFilename, ADirectoryName: string; const AHandler: Tg2dZipFileIOBuildProgressCallback; const AUserData: Pointer; const APassword: string): Boolean;
const
  CBufferSize = 1024*4;
var
  LFileList: TStringDynArray;
  LArchive: PAnsiChar;
  LFilename: string;
  LFilename2: PAnsiChar;
  LPassword: PAnsiChar;
  LZipFile: zipFile;
  LZipFileInfo: zip_fileinfo;
  LFile: System.Classes.TStream;
  LCrc: Cardinal;
  LBytesRead: Integer;
  LFileSize: Int64;
  LProgress: Single;
  LNewFile: Boolean;
  LHandler: Tg2dZipFileIOBuildProgressCallback;
  LUserData: Pointer;
  LBuffer: TArray<Byte>;

  function GetCRC32(aStream: System.Classes.TStream): uLong;
  var
    LBytesRead: Integer;
  begin
    Result := crc32(0, nil, 0);
    repeat
      LBytesRead := AStream.Read(LBuffer[0], CBufferSize);
      Result := crc32(Result, PBytef(@LBuffer[0]), LBytesRead);
    until LBytesRead = 0;
  end;
begin
  Result := False;

  // check if directory exists
  if not TDirectory.Exists(ADirectoryName) then Exit;

  SetLength(LBuffer, CBufferSize);

  // init variabls
  FillChar(LZipFileInfo, SizeOf(LZipFileInfo), 0);

  // scan folder and build file list
  LFileList := TDirectory.GetFiles(ADirectoryName, '*',
    TSearchOption.soAllDirectories);

  LArchive := PAnsiChar(AnsiString(AZipFilename));
  LPassword := PAnsiChar(AnsiString(APassword));

  // create a zip file
  LZipFile := zipOpen64(LArchive, APPEND_STATUS_CREATE);

  // init handler
  LHandler := AHandler;
  LUserData := AUserData;

  if not Assigned(LHandler) then
    LHandler := TZipFileIO_BuildProgress;

  // process zip file
  if LZipFile <> nil then
  begin
    // loop through all files in list
    for LFilename in LFileList do
    begin
      // open file
      LFile := TFile.OpenRead(LFilename);

      // get file size
      LFileSize := LFile.Size;

      // get file crc
      LCrc := GetCRC32(LFile);

      // open new file in zip
      LFilename2 := PAnsiChar(AnsiString(LFilename));
      if ZipOpenNewFileInZip3_64(LZipFile, LFilename2, @LZipFileInfo, nil, 0,
        nil, 0, '',  Z_DEFLATED, 9, 0, 15, 9, Z_DEFAULT_STRATEGY,
        LPassword, LCrc, 1) = Z_OK then
      begin
        // make sure we start at star of stream
        LFile.Position := 0;

        LNewFile := True;

        // read through file
        repeat
          // read in a buffer length of file
          LBytesRead := LFile.Read(LBuffer[0], CBufferSize);

          // write buffer out to zip file
          zipWriteInFileInZip(LZipFile, @LBuffer[0], LBytesRead);

          // calc file progress percentage
          LProgress := 100.0 * (LFile.Position / LFileSize);

          // show progress
          if Assigned(LHandler) then
          begin
            LHandler(LFilename, Round(LProgress), LNewFile, LUserData);
          end;

          LNewFile := False;

        until LBytesRead = 0;

        // close file in zip
        zipCloseFileInZip(LZipFile);

        // free file stream
        LFile.Free;
      end;
    end;

    // close zip file
    zipClose(LZipFile, '');
  end;

  // return true if new zip file exits
  Result := TFile.Exists(LFilename);
end;

//=== COLOR ====================================================================
constructor Tg2dColor.Create(const ARed, AGreen, ABlue, AAlpha: Single);
begin
  FromFloat(ARed, AGreen, ABlue, AAlpha);
end;

procedure Tg2dColor.FromByte(const ARed, AGreen, ABlue, AAlpha: Byte);
begin
  Red := EnsureRange(ARed, 0, 255) / $FF;
  Green := EnsureRange(AGreen, 0, 255) / $FF;
  Blue := EnsureRange(ABlue, 0, 255) / $FF;
  Alpha := EnsureRange(AAlpha, 0, 255) / $FF;
end;

procedure  Tg2dColor.FromFloat(const ARed, AGreen, ABlue, AAlpha: Single);
begin
  Red := EnsureRange(ARed, 0, 1);
  Green := EnsureRange(AGreen, 0, 1);
  Blue := EnsureRange(ABlue, 0, 1);
  Alpha := EnsureRange(AAlpha, 0, 1);
end;

procedure  Tg2dColor.Fade(const ATo: Tg2dColor; const APos: Single);
var
  LPos: Single;
begin
  LPos := EnsureRange(APos, 0, 1);
  Red := Red + ((ATo.Red - Red) * LPos);
  Green := Green + ((ATo.Green - Green) * LPos);
  Blue := Blue + ((ATo.Blue - Blue) * LPos);
  Alpha := Alpha + ((ATo.Alpha - Alpha) * LPos);
end;

function  Tg2dColor.IsEqual(const AColor: Tg2dColor): Boolean;
begin
  Result := (Red = AColor.Red) and
            (Green = AColor.Green) and
            (Blue = AColor.Blue) and
            (Alpha = AColor.Alpha);
end;


//=== WINDOW ===================================================================
procedure Window_ResizeCallback(AWindow: PGLFWwindow; AWidth, AHeight: Integer); cdecl;
var
  LWindow: Tg2dWindow;
  LAspectRatio: Single;
  LNewWidth, LNewHeight: Integer;
  LXOffset, LYOffset: Integer;
  LWidth, LHeight: Integer;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  LWidth :=  Round(LWindow.GetVirtualSize().Width);
  LHeight := Round(LWindow.GetVirtualSize().Height);

  // Calculate aspect ratio based on the initial window size
  LAspectRatio := LWidth / LHeight;

  // Adjust the viewport based on the new window size
  if AWidth / LAspectRatio <= AHeight then
  begin
    LNewWidth := AWidth;
    LNewHeight := Round(AWidth / LAspectRatio);
    LXOffset := 0;
    LYOffset := (AHeight - LNewHeight) div 2;
  end
  else
  begin
    LNewWidth := Round(AHeight * LAspectRatio);
    LNewHeight := AHeight;
    LXOffset := (AWidth - LNewWidth) div 2;
    LYOffset := 0;
  end;

  // Set the viewport to maintain the aspect ratio and leave black bars
  glViewport(LXOffset, LYOffset, LNewWidth, LNewHeight);

  // Set the scissor box to match the virtual resolution area
  glScissor(LXOffset, LYOffset, LNewWidth, LNewHeight);

  // Set up the orthographic projection
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, LWidth, LHeight, 0, -1, 1);  // Always map to the virtual coordinates

  // Back to modelview mode
  glMatrixMode(GL_MODELVIEW);

  LWindow.FViewport.pos.x := LXOffset;
  LWindow.FViewport.pos.y := LYOffset;
  LWindow.FViewport.size.Width := LNewWidth;
  LWindow.FViewport.size.Height := LNewHeight;
end;

procedure TWindow_ScrollCallback(AWindow: PGLFWwindow; AOffsetX, AOffsetY: Double); cdecl;
var
  LWindow: Tg2dWindow;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  // Save the scroll offsets
  LWindow.FMouseWheel := Tg2dVec.Create(AOffsetX, AOffsetY);
end;

procedure TWindow_FocusCallback(AWindow: PGLFWwindow; AFocused: Integer); cdecl;
var
  LWindow: Tg2dWindow;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  if AFocused = GLFW_TRUE then
  begin
    LWindow.SetReady(True);
    //Tg2dVideo.
    Tg2dAudio.SetPause(True);
  end
  else
  begin
    LWindow.SetReady(False);
    Tg2dAudio.SetPause(False);
  end;
end;

procedure TWindow_IconifyCallback(AWindow: PGLFWwindow; AIconified: Integer); cdecl;
var
  LWindow: Tg2dWindow;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;
  if AIconified = GLFW_TRUE then
    LWindow.SetReady(False)
  else
    LWindow.SetReady(True);
end;

procedure TWindow_WindowCloseCallback(AWindow: PGLFWwindow); cdecl;
var
  LWindow: Tg2dWindow;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;
  LWindow.SetReady(False);
end;

procedure Tg2dWindow.SetDefaultIcon();
var
  IconHandle: HICON;
begin
  if not Assigned(FHandle) then Exit;

  IconHandle := LoadIcon(GetModuleHandle(nil), 'MAINICON');
  if IconHandle <> 0 then
  begin
    SendMessage(glfwGetWin32Window(FHandle), WM_SETICON, ICON_BIG, IconHandle);
  end;
end;

procedure TWindow_CharCallback(AWindow: PGLFWwindow; ACodepoint: Cardinal); cdecl;
var
  LWindow: Tg2dWindow;
  LChar: WideChar;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  // Only capture text input when enabled (for ImGui text widgets)
  if not LWindow.FTextInputEnabled then Exit;

  // Convert Unicode codepoint to character (filter out control characters)
  if (ACodepoint >= 32) and (ACodepoint <> 127) and (ACodepoint <= $FFFF) then
  begin
    LChar := WideChar(ACodepoint);
    LWindow.FTextInputQueue := LWindow.FTextInputQueue + LChar;
  end;
end;

constructor Tg2dWindow.Create();
begin
  inherited;
end;

destructor Tg2dWindow.Destroy();
begin
  Close();
  inherited;
end;

function  Tg2dWindow.Open(const ATitle: string; const AVirtualWidth: Cardinal; const AVirtualHeight: Cardinal; const AParent: NativeUInt; const AVsync: Boolean; const AResizable: Boolean): Boolean;
var
  LWindow: PGLFWwindow;
  LWidth: Integer;
  LHeight: Integer;
  LHWNative: HWND;
  LStyle: NativeInt;
  LVSync: Boolean;
  LResizable: Boolean;
begin
  Result := False;

  if Assigned(FHandle) then Exit;

  LWidth := AVirtualWidth;
  LHeight := AVirtualHeight;

  LVSync := AVsync;
  LResizable := AResizable;

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);

  // set hints if child or standalone window
  if AParent <> 0 then
    begin
      glfwWindowHint(GLFW_DECORATED, GLFW_FALSE);
      //glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
      LResizable := True;
    end
  else
    begin
      glfwWindowHint(GLFW_SCALE_TO_MONITOR, GLFW_TRUE);
      glfwWindowHint(GLFW_RESIZABLE, Ord(LResizable));
    end;

  glfwWindowHint(GLFW_SAMPLES, 4);

  // Create a windowed mode window and its OpenGL context
  LWindow := glfwCreateWindow(LWidth, LHeight, Tg2dUtils.AsUTF8(ATitle, []), nil, nil);
  if LWindow = nil then Exit;

  // set hints if child or standalone window
  if AParent <> 0 then
  begin
    LHWNative := glfwGetWin32Window(LWindow);
    WinApi.Windows.SetParent(LHWNative, AParent);
    LStyle := GetWindowLong(LHWNative, GWL_STYLE);
    LStyle := LStyle and not WS_POPUP; // remove popup style
    LStyle := LStyle or WS_CHILDWINDOW; // add childwindow style
    SetWindowLong(LHWNative, GWL_STYLE, LStyle);
  end;

  // Make the window's context current
  glfwMakeContextCurrent(LWindow);

  // init OpenGL extensions
  if not LoadOpenGL() then
  begin
    glfwMakeContextCurrent(nil);
    glfwDestroyWindow(LWindow);
    Exit;
  end;

  // Set the resize callback
  glfwSetFramebufferSizeCallback(LWindow, Window_ResizeCallback);

  // Set the mouse scroll callback
  glfwSetScrollCallback(LWindow, TWindow_ScrollCallback);

  glfwSetWindowFocusCallback(LWindow, TWindow_FocusCallback);

  glfwSetWindowIconifyCallback(LWindow, TWindow_IconifyCallback);

  glfwSetWindowCloseCallback(LWindow, TWindow_WindowCloseCallback);

  glfwSetCharCallback(LWindow, TWindow_CharCallback);

  // Enable the scissor test
  glEnable(GL_SCISSOR_TEST);

  // Enable Line Smoothing
  glEnable(GL_LINE_SMOOTH);
  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

  // Enable Polygon Smoothing
  glEnable(GL_POLYGON_SMOOTH);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

  // Enable Point Smoothing
  glEnable(GL_POINT_SMOOTH);
  glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);

  // Enable Multisampling for anti-aliasing (if supported)
  glEnable(GL_MULTISAMPLE);

  FHandle := LWindow;

  glfwGetWindowPos(FHandle, @FWindowedPosX, @FWindowedPosY);
  glfwGetWindowSize(FHandle, @FWindowedWidth, @FWindowedHeight);

  FVirtualSize.Width := LWidth;
  FVirtualSize.Height := LHeight;
  FParent := AParent;

  FVsync := LVSync;
  FResizable := LResizable;

  glGetIntegerv(GL_MAX_TEXTURE_SIZE, @FMaxTextureSize);
  glfwSetInputMode(FHandle, GLFW_STICKY_KEYS, GLFW_TRUE);
  glfwSetInputMode(FHandle, GLFW_STICKY_MOUSE_BUTTONS, GLFW_TRUE);

  if FVsync then
    glfwSwapInterval(1)
  else
    glfwSwapInterval(0);

  glfwSetWindowUserPointer(FHandle, Self);

  if FParent = 0 then
    Center();

  glfwGetWindowSize(FHandle, @LWidth, @LHeight);

  FViewport.pos.x := 0;
  FViewport.pos.x := 0;
  FViewport.size.Width := LWidth;
  FViewport.size.Height := LHeight;

  FTextInputQueue := '';
  FTextInputEnabled := False;

  SetDefaultIcon();

  SetTargetFrameRate(G2D_DEFAULT_FPS);

  FReady := True;
  Result := True;
end;

procedure Tg2dWindow.Close();
begin
  if not Assigned(FHandle) then Exit;
  if FFramebufferID <> 0 then
  begin
    glDeleteFramebuffersEXT(1, @FFramebufferID);
    FFramebufferID := 0;
  end;
  glfwMakeContextCurrent(nil);
  glfwDestroyWindow(FHandle);
  FHandle := nil;
end;

function  Tg2dWindow.IsReady(): Boolean;
begin
  Result := FReady;
end;

procedure Tg2dWindow.SetReady(const AReady: Boolean);
begin
  FReady := AReady;
end;

function  Tg2dWindow.GetTitle(): string;
var
  LHwnd: HWND;
  LLen: Integer;
  LTitle: PChar;
begin
  Result := '';
  if not Assigned(FHandle) then Exit;

  LHwnd := glfwGetWin32Window(FHandle);
  LLen := GetWindowTextLength(LHwnd);
  GetMem(LTitle, LLen + 1);
  try
    GetWindowText(LHwnd, LTitle, LLen + 1);
    Result := string(LTitle);
  finally
    FreeMem(LTitle);
  end;
end;

procedure Tg2dWindow.SetTitle(const ATitle: string);
begin
  if not Assigned(FHandle) then Exit;

  SetWindowText(glfwGetWin32Window(FHandle), ATitle);
end;

procedure Tg2dWindow.Resize(const AWidth, AHeight: Cardinal);
begin
  glfwSetWindowSize(FHandle, AWidth, AHeight);
end;

procedure Tg2dWindow.SetSizeLimits(const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
var
  LScale: Tg2dVec;
  LMinWidth, LMinHeight, LMaxWidth, LMaxHeight: Integer;
begin
  glfwGetWindowContentScale(FHandle, @LScale.x, @LScale.y);

  LMinWidth := AMinWidth;
  LMinHeight := AMinHeight;
  LMaxWidth := AMaxWidth;
  LMaxHeight := AMaxHeight;

  if LMinWidth <> GLFW_DONT_CARE then
    LMinWidth := Round(LMinWidth * LScale.x);

  if LMinHeight <> GLFW_DONT_CARE then
    LMinHeight := Round(LMinHeight * LScale.y);


  if LMaxWidth <> GLFW_DONT_CARE then
    LMaxWidth := Round(LMaxWidth * LScale.x);


  if LMaxHeight <> GLFW_DONT_CARE then
    LMaxHeight := Round(LMaxHeight * LScale.y);

  glfwSetWindowSizeLimits(FHandle,LMinWidth, LMinHeight, LMaxWidth, LMaxHeight);
end;

procedure Tg2dWindow.ToggleFullscreen();
var
  LMonitor: PGLFWmonitor;
  LMode: PGLFWvidmode;
begin
  if not Assigned(FHandle) then Exit;

  if FIsFullscreen then
    begin
      // Switch to windowed mode using the saved window position and size
      glfwSetWindowMonitor(FHandle, nil, FWindowedPosX, FWindowedPosY, FWindowedWidth, FWindowedHeight, 0);
      FIsFullscreen := False;
    end
  else
    begin
      // Get the primary monitor and its video mode
      LMonitor := glfwGetPrimaryMonitor();
      LMode := glfwGetVideoMode(LMonitor);

      // Save the windowed mode position and size
      glfwGetWindowPos(FHandle, @FWindowedPosX, @FWindowedPosY);
      glfwGetWindowSize(FHandle, @FWindowedWidth, @FWindowedHeight);

      // Switch to fullscreen mode at the desktop resolution
      glfwSetWindowMonitor(FHandle, LMonitor, 0, 0, LMode.Width, LMode.Height, LMode.RefreshRate);
      FIsFullscreen := True;
    end;
end;

function  Tg2dWindow.IsFullscreen(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;
  Result := FIsFullscreen;
end;

function  Tg2dWindow.GetVirtualSize(): Tg2dSize;
begin
  Result := Tg2dSize.Create(0, 0);
  if not Assigned(FHandle) then Exit;
  Result := FVirtualSize;
end;

function  Tg2dWindow.HasFocus(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;
  Result := Boolean(glfwGetWindowAttrib(FHandle, GLFW_FOCUSED) = GLFW_TRUE);
end;

function  Tg2dWindow.GetSize(): Tg2dSize;
var
  LWindowWidth, LWindowHeight: Integer;
begin
  Result := Tg2dSize.Create(0, 0);
  if not Assigned(FHandle) then Exit;

  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);
  Result.Width := LWindowWidth;
  Result.Height := LWindowHeight;
end;

function  Tg2dWindow.GetScale(): Tg2dSize;
begin
  Result := Tg2dSize.Create(0, 0);

  if not Assigned(FHandle) then Exit;

  glfwGetWindowContentScale(FHandle, @Result.Width, @Result.Height);
end;

function  Tg2dWindow.GetMaxTextureSize(): Integer;
begin
  Result := FMaxTextureSize;
end;


function  Tg2dWindow.GetViewport(): Tg2dRect;
begin
  Result := Tg2dRect.Create(0, 0, 0, 0);
  if not Assigned(FHandle) then Exit;
  Result := FViewport;
end;

procedure Tg2dWindow.Center();
var
  LMonitor: PGLFWmonitor;
  LVideoMode: PGLFWvidmode;
  LScreenWidth, LScreenHeight: Integer;
  LWindowWidth, LWindowHeight: Integer;
  LPosX, LPosY: Integer;
begin
  if not Assigned(FHandle) then Exit;

  if FIsFullscreen then Exit;

  // Get the primary monitor
  LMonitor := glfwGetPrimaryMonitor;

  // Get the video mode of the monitor (i.e., resolution)
  LVideoMode := glfwGetVideoMode(LMonitor);

  // Get the screen width and height
  LScreenWidth := LVideoMode.width;
  LScreenHeight := LVideoMode.height;

  // Get the window width and height
  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);

  // Calculate the position to center the window
  LPosX := (LScreenWidth - LWindowWidth) div 2;
  LPosY := (LScreenHeight - LWindowHeight) div 2;

  // Set the window position
  glfwSetWindowPos(FHandle, LPosX, LPosY);
end;

function  Tg2dWindow.ShouldClose(): Boolean;
begin
  Result := True;
  if not Assigned(FHandle) then Exit;
  Result := Boolean(glfwWindowShouldClose(FHandle) = GLFW_TRUE);
  if Result then
  begin
    Tg2dUtils.AsyncWaitForAllToTerminate();
  end;
end;

procedure Tg2dWindow.SetShouldClose(const AClose: Boolean);
begin
  if not Assigned(FHandle) then Exit;
  glfwSetWindowShouldClose(FHandle, Ord(AClose))
end;

procedure Tg2dWindow.StartFrame();
begin
  if not Assigned(FHandle) then Exit;

  StartTiming();
  Tg2dVideo.Update(Self);
  Tg2dAudio.Update();
  Tg2dUtils.AsyncProcess();
  glfwPollEvents();
end;

procedure Tg2dWindow.EndFrame();
begin
  if not Assigned(FHandle) then Exit;

  // Reset mouse wheel deltas
  FMouseWheel := Tg2dVec.Create(0, 0);

  StopTiming();
end;

procedure Tg2dWindow.StartDrawing();
begin
  if not Assigned(FHandle) then Exit;

  // Clear the entire screen to black (this will create the black bars)
  glClearColor(0, 0, 0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  ResetDrawing();
end;

procedure Tg2dWindow.ResetDrawing();
begin
  if not Assigned(FHandle) then Exit;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, FVirtualSize.Width, FVirtualSize.Height, 0, -1, 1);  // Set orthographic projection
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

procedure Tg2dWindow.EndDrawing();
begin
  if not Assigned(FHandle) then Exit;
  glfwSwapBuffers(FHandle);
end;

procedure Tg2dWindow.Clear(const AColor: Tg2dColor);
begin
  if not Assigned(FHandle) then Exit;
  glClearColor(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glClear(GL_COLOR_BUFFER_BIT); // Only the viewport area is affected
end;

procedure Tg2dWindow.DrawLine(const X1, Y1, X2, Y2: Single; const AColor: Tg2dColor; const AThickness: Single);
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_LINES);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
  glEnd;
end;

procedure Tg2dWindow.DrawRect(const X, Y, AWidth, AHeight, AThickness: Single; const AColor: Tg2dColor; const AAngle: Single);
var
  LHalfWidth, LHalfHeight: Single;
begin
  if not Assigned(FHandle) then Exit;

  LHalfWidth := AWidth / 2;
  LHalfHeight := AHeight / 2;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);

  glPushMatrix;  // Save the current matrix

  // Translate to the center point
  glTranslatef(X, Y, 0);

  // Rotate around the center
  glRotatef(AAngle, 0, 0, 1);

  glBegin(GL_LINE_LOOP);
    glVertex2f(-LHalfWidth, -LHalfHeight);      // Bottom-left corner
    glVertex2f(LHalfWidth, -LHalfHeight);       // Bottom-right corner
    glVertex2f(LHalfWidth, LHalfHeight);        // Top-right corner
    glVertex2f(-LHalfWidth, LHalfHeight);       // Top-left corner
  glEnd;

  glPopMatrix;  // Restore the original matrix
end;

procedure Tg2dWindow.DrawFilledRect(const X, Y, AWidth, AHeight: Single; const AColor: Tg2dColor; const AAngle: Single);
var
  LHalfWidth, LHalfHeight: Single;
begin
  if not Assigned(FHandle) then Exit;

  LHalfWidth := AWidth / 2;
  LHalfHeight := AHeight / 2;

  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);

  glPushMatrix;  // Save the current matrix

  // Translate to the center point
  glTranslatef(X, Y, 0);

  // Rotate around the center
  glRotatef(AAngle, 0, 0, 1);

  glBegin(GL_QUADS);
    glVertex2f(-LHalfWidth, -LHalfHeight);      // Bottom-left corner
    glVertex2f(LHalfWidth, -LHalfHeight);       // Bottom-right corner
    glVertex2f(LHalfWidth, LHalfHeight);        // Top-right corner
    glVertex2f(-LHalfWidth, LHalfHeight);       // Top-left corner
  glEnd;

  glPopMatrix;  // Restore the original matrix
end;

procedure Tg2dWindow.DrawCircle(const X, Y, ARadius, AThickness: Single; const AColor: Tg2dColor);
var
  I: Integer;
  LX, LY: Single;
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_LINE_LOOP);
    LX := X;
    LY := Y;
    for I := 0 to 360 do
    begin
      glVertex2f(LX + ARadius * Tg2dMath.AngleCos(I), LY - ARadius * Tg2dMath.AngleSin(I));
    end;
  glEnd();
end;

procedure Tg2dWindow.DrawFilledCircle(const X, Y, ARadius: Single; const AColor: Tg2dColor);
var
  I: Integer;
  LX, LY: Single;
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_TRIANGLE_FAN);
    LX := X;
    LY := Y;
    glVertex2f(LX, LY);
    for i := 0 to 360 do
    begin
      glVertex2f(LX + ARadius * Tg2dMath.AngleCos(i), LY + ARadius * Tg2dMath.AngleSin(i));
    end;
  glEnd();
end;

procedure Tg2dWindow.DrawTriangle(const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: Tg2dColor);
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_LINE_LOOP);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
    glVertex2f(X3, Y3);
  glEnd();
end;

procedure Tg2dWindow.DrawFilledTriangle(const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: Tg2dColor);
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_TRIANGLES);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
    glVertex2f(X3, Y3);
  glEnd();
end;

procedure Tg2dWindow.DrawPolygon(const APoints: array of TPoint; const AThickness: Single; const AColor: Tg2dColor);
var
  I: Integer;
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_LINE_LOOP);
    for i := Low(APoints) to High(APoints) do
    begin
      glVertex2f(APoints[i].X, APoints[i].Y);
    end;
  glEnd();
end;

procedure Tg2dWindow.DrawFilledPolygon(const APoints: array of TPoint; const AColor: Tg2dColor);
var
  I: Integer;
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_POLYGON);
  for I := Low(APoints) to High(APoints) do
    begin
      glVertex2f(APoints[i].X, APoints[i].Y);
    end;
  glEnd();
end;

procedure Tg2dWindow.DrawPolyline(const APoints: array of TPoint; const AThickness: Single; const AColor: Tg2dColor);
var
  I: Integer;
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
  glBegin(GL_LINE_STRIP);
    for I := Low(APoints) to High(APoints) do
    begin
      glVertex2f(APoints[i].X, APoints[i].Y);
    end;
  glEnd();
end;

procedure Tg2dWindow.ClearInput();
begin
  if not Assigned(FHandle) then Exit;
  FillChar(FKeyState, SizeOf(FKeyState), 0);
  FillChar(FMouseButtonState, SizeOf(FMouseButtonState), 0);
  FillChar(FGamepadButtonState, SizeOf(FGamepadButtonState), 0);
end;

function  Tg2dWindow.GetKey(const AKey: Integer; const AState: Tg2dInputState): Boolean;

  function IsKeyPressed(const AKey: Integer): Boolean;
  begin
    Result :=  Boolean(glfwGetKey(FHandle, AKey) = GLFW_PRESS);
  end;

begin
  Result := False;

  if not Assigned(FHandle) then Exit;

  if not InRange(AKey,  G2D_KEY_SPACE, G2D_KEY_LAST) then Exit;

  case AState of
    isPressed:
    begin
      Result :=  IsKeyPressed(AKey);
    end;

    isWasPressed:
    begin
      if IsKeyPressed(AKey) and (not FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := True;
        Result := True;
      end
      else if (not IsKeyPressed(AKey)) and (FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := False;
        Result := False;
      end;
    end;

    isWasReleased:
    begin
      if IsKeyPressed(AKey) and (not FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := True;
        Result := False;
      end
      else if (not IsKeyPressed(AKey)) and (FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := False;
        Result := True;
      end;
    end;
  end;
end;

function  Tg2dWindow.GetMouseButton(const AButton: Byte; const AState: Tg2dInputState): Boolean;

  function IsButtonPressed(const AKey: Integer): Boolean;
  begin
    Result :=  Boolean(glfwGetMouseButton(FHandle, AButton) = GLFW_PRESS);
  end;

begin
  Result := False;

  if not Assigned(FHandle) then Exit;
  if not InRange(AButton,  G2D_MOUSE_BUTTON_1, G2D_MOUSE_BUTTON_MIDDLE) then Exit;

  case AState of
    isPressed:
    begin
      Result :=  IsButtonPressed(AButton);
    end;

    isWasPressed:
    begin
      if IsButtonPressed(AButton) and (not FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := True;
        Result := True;
      end
      else if (not IsButtonPressed(AButton)) and (FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := False;
        Result := False;
      end;
    end;

    isWasReleased:
    begin
      if IsButtonPressed(AButton) and (not FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := True;
        Result := False;
      end
      else if (not IsButtonPressed(AButton)) and (FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := False;
        Result := True;
      end;
    end;
  end;
end;

procedure Tg2dWindow.GetMousePos(const X, Y: System.PSingle);
var
  LPos: Tg2dVec;
begin
  if not Assigned(FHandle) then Exit;

  LPos := GetMousePos();

  if Assigned(X) then
    X^ := LPos.x;

  if Assigned(Y) then
    Y^ := LPos.y;
end;

function Tg2dWindow.GetMousePos(): Tg2dVec;
var
  LMouseX, LMouseY: Double;
begin
  if not Assigned(FHandle) then Exit;

  glfwGetCursorPos(FHandle, @LMouseX, @LMouseY);
  Result := VirtualToScreen(LMouseX, LMouseY);
end;

procedure Tg2dWindow.SetMousePos(const X, Y: Single);
var
  LPos: Tg2dVec;
begin
  if not Assigned(FHandle) then Exit;

  LPos := ScreenToVirtual(X, Y);
  glfwSetCursorPos(FHandle, LPos.X, LPos.y);
end;

function  Tg2dWindow.GetMouseWheel(): Tg2dVec;
begin
  Result := Tg2dVec.Create(0,0);
  if not Assigned(FHandle) then Exit;
  Result := FMouseWheel;
end;

function  Tg2dWindow.GamepadPresent(const AGamepad: Byte): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(glfwJoystickIsGamepad(EnsureRange(AGamepad, G2D_GAMEPAD_1, G2D_GAMEPAD_LAST)));
end;

function  Tg2dWindow.GetGamepadName(const AGamepad: Byte): string;
begin
  Result := 'Not present';

  if not Assigned(FHandle) then Exit;
  if not GamepadPresent(AGamepad) then Exit;

  Result := string(glfwGetGamepadName(AGamepad));
end;

function  Tg2dWindow.GetGamepadButton(const AGamepad, AButton: Byte; const AState: Tg2dInputState): Boolean;
var
  LState: GLFWgamepadstate;

  function IsButtonPressed(const AButton: Byte): Boolean;
  begin
    Result :=  Boolean(LState.buttons[AButton]);
  end;

begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  if not Boolean(glfwGetGamepadState(EnsureRange(AGamepad, G2D_GAMEPAD_1, G2D_GAMEPAD_LAST), @LState)) then Exit;

  case AState of
    isPressed:
    begin
      Result :=  IsButtonPressed(AButton);
    end;

    isWasPressed:
    begin
      if IsButtonPressed(AButton) and (not FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := True;
        Result := True;
      end
      else if (not IsButtonPressed(AButton)) and (FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := False;
        Result := False;
      end;
    end;

    isWasReleased:
    begin
      if IsButtonPressed(AButton) and (not FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := True;
        Result := False;
      end
      else if (not IsButtonPressed(AButton)) and (FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := False;
        Result := True;
      end;
    end;
  end;
end;

function  Tg2dWindow.GetGamepadAxisValue(const AGamepad, AAxis: Byte): Single;
var
  LState: GLFWgamepadstate;
begin
  Result := 0;
  if not Assigned(FHandle) then Exit;

  if not Boolean(glfwGetGamepadState(EnsureRange(AGamepad, G2D_GAMEPAD_1, G2D_GAMEPAD_LAST), @LState)) then Exit;
  Result := LState.axes[EnsureRange(AAxis, G2D_GAMEPAD_AXIS_LEFT_X, G2D_GAMEPAD_AXIS_LAST)];
end;

function  Tg2dWindow.VirtualToScreen(const X, Y: Single): Tg2dVec;
var
  LWindowWidth, LWindowHeight: Integer;
  LScreenX, LScreenY: Double;
  LVirtualScreenX, LVirtualScreenY: Double;
  LScaleX, LScaleY, LDpiScaleX, LDpiScaleY: Single;
  LViewportOffsetX, LViewportOffsetY: Double;
begin
  Result.x := 0;
  Result.y := 0;
  if not Assigned(FHandle) then Exit;

  // Get the actual window size
  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);

  // Get the DPI scaling factors (from glfwGetWindowContentScale)
  glfwGetWindowContentScale(FHandle, @LDpiScaleX, @LDpiScaleY);

  // Safety check to avoid invalid DPI scale values
  if (LDpiScaleX = 0) or (LDpiScaleY = 0) then
  begin
    LDpiScaleX := 1.0; // Default to 1.0 if invalid DPI scale is retrieved
    LDpiScaleY := 1.0;
  end;

  // Adjust window size by DPI scaling
  LWindowWidth := Trunc(LWindowWidth / LDpiScaleX);
  LWindowHeight := Trunc(LWindowHeight / LDpiScaleY);

  // Calculate the scaling factors for X and Y axes
  LScaleX := FVirtualSize.Width / FViewport.size.Width;  // Scale based on viewport width
  LScaleY := FVirtualSize.Height / FViewport.size.Height;  // Scale based on viewport height

  // Get the screen position
  LScreenX := X;
  LScreenY := Y;

  // Calculate the viewport offset
  LViewportOffsetX := FViewport.pos.x;
  LViewportOffsetY := FViewport.pos.y;

  // Adjust the mouse position by subtracting the viewport offset
  LScreenX := LScreenX - LViewportOffsetX;
  LScreenY := LScreenY - LViewportOffsetY;

  // Convert the adjusted mouse position to virtual coordinates
  LVirtualScreenX := LScreenX * LScaleX;
  LVirtualScreenY := LScreenY * LScaleY;

  // Clamp the virtual mouse position within the virtual resolution
  Result.x := EnsureRange(LVirtualScreenX, 0, FVirtualSize.Width - 1);
  Result.y := EnsureRange(LVirtualScreenY, 0, FVirtualSize.Height - 1);
end;

function  Tg2dWindow.ScreenToVirtual(const X, Y: Single): Tg2dVec;
var
  LScreenX, LScreenY: Double;
  LScaleX, LScaleY: Single;
  LViewportOffsetX, LViewportOffsetY: Double;
begin
  Result.x := 0;
  Result.y := 0;
  if not Assigned(FHandle) then Exit;

  // Calculate the scaling factors (consistent with GetMousePos)
  LScaleX := FVirtualSize.Width / FViewport.size.Width;
  LScaleY := FVirtualSize.Height / FViewport.size.Height;

  // Calculate the viewport offsets
  LViewportOffsetX := FViewport.pos.x;
  LViewportOffsetY := FViewport.pos.y;

  // Convert virtual coordinates to adjusted screen position
  LScreenX := (X / LScaleX) + LViewportOffsetX;
  LScreenY := (Y / LScaleY) + LViewportOffsetY;

  // Return the virtual screen position
  Result.x := LScreenX;
  Result.y := LScreenY;
end;

procedure Tg2dWindow.StartTiming();
begin
  FTiming.CurrentTime := glfwGetTime();
  FTiming.ElapsedTime := FTiming.CurrentTime - FTiming.LastTime;
end;


procedure Tg2dWindow.StopTiming();
begin
  Inc(FTiming.FrameCount);
  if (FTiming.CurrentTime - FTiming.LastFPSTime >= 1.0) then
  begin
    FTiming.Framerate := FTiming.FrameCount;
    FTiming.LastFPSTime := FTiming.CurrentTime;
    FTiming.FrameCount := 0;
  end;

  // Calculate delta time
  FTiming.DeltaTime := FTiming.CurrentTime - FTiming.LastTime;

  FTiming.LastTime := FTiming.CurrentTime;
  FTiming.RemainingTime := FTiming.TargetTime - (FTiming.CurrentTime - FTiming.LastTime);
  if (FTiming.RemainingTime > 0) then
   begin
      FTiming.Endtime := FTiming.CurrentTime + FTiming.RemainingTime;
      while glfwGetTime() < FTiming.Endtime do
      begin
        // Busy-wait for the remaining time
        Sleep(0); // allow other background tasks to run
      end;
    end;
end;

procedure Tg2dWindow.SetTargetFrameRate(const ATargetFrameRate: UInt32);
begin
  FTiming.LastTime := glfwGetTime();
  FTiming.LastFPSTime := FTiming.LastTime;
  FTiming.TargetFrameRate := ATargetFrameRate;
  FTiming.TargetTime := 1.0 / FTiming.TargetFrameRate;
  FTiming.FrameCount := 0;
  FTiming.Framerate :=0;
  FTiming.Endtime := 0;
end;

function  Tg2dWindow.GetTargetFrameRate(): UInt32;
begin
  Result := FTiming.TargetFrameRate;
end;

function  Tg2dWindow.GetTargetTime(): Double;
begin
  Result := FTiming.TargetTime;
end;

procedure Tg2dWindow.ResetTiming();
begin
  FTiming.LastTime := glfwGetTime();
  FTiming.LastFPSTime := FTiming.LastTime;
  FTiming.TargetTime := 1.0 / FTiming.TargetFrameRate;
  FTiming.FrameCount := 0;
  FTiming.Framerate :=0;
  FTiming.Endtime := 0;
end;

function  Tg2dWindow.GetFrameRate(): UInt32;
begin
  Result := FTiming.Framerate;
end;

function  Tg2dWindow.GetDeltaTime(): Double;
begin
  Result := FTiming.DeltaTime;
end;

class function  Tg2dWindow.Init(const ATitle: string; const AVirtualWidth: Cardinal; const AVirtualHeight: Cardinal; const AParent: NativeUInt; const AVsync: Boolean; const AResizable: Boolean): Tg2dWindow;
begin
  Result := Tg2dWindow.Create();
  if not Result.Open(ATitle, AVirtualWidth, AVirtualHeight, AParent, AVsync, AResizable) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

(*
procedure Tg2dWindow.SetRenderTarget(const ATexture: Tg2dTexture; const ADisableSmoothing: Boolean);
var
  LTextureWidth, LTextureHeight: Integer;
  LAspectRatio: Single;
  LNewWidth, LNewHeight: Integer;
  LXOffset, LYOffset: Integer;
begin
  if not Assigned(FHandle) then Exit;
  // Restore window rendering
  if ATexture = nil then
  begin
    if FFramebufferID <> 0 then
    begin
      glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
      glDeleteFramebuffersEXT(1, @FFramebufferID);
      FFramebufferID := 0;
    end;
    FCurrentRenderTarget := nil;
    FViewport := FSavedViewport;
    // Restore viewport
    glViewport(Round(FViewport.pos.x), Round(FViewport.pos.y), Round(FViewport.size.Width), Round(FViewport.size.Height));
    glScissor(Round(FViewport.pos.x), Round(FViewport.pos.y), Round(FViewport.size.Width), Round(FViewport.size.Height));
    // Restore the saved transform matrices
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(@FSavedProjectionMatrix[0]);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(@FSavedModelviewMatrix[0]);
    // Re-enable all smoothing/antialiasing
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_POLYGON_SMOOTH);
    glEnable(GL_POINT_SMOOTH);
    glEnable(GL_MULTISAMPLE);
    Exit;
  end;
  // Save current state before changing it
  FSavedViewport := FViewport;
  // Save current transform matrices
  glGetFloatv(GL_PROJECTION_MATRIX, @FSavedProjectionMatrix[0]);
  glGetFloatv(GL_MODELVIEW_MATRIX, @FSavedModelviewMatrix[0]);
  // Set texture as render target
  FCurrentRenderTarget := ATexture;
  // Create framebuffer if needed
  if FFramebufferID = 0 then
    glGenFramebuffersEXT(1, @FFramebufferID);
  // Bind framebuffer and attach texture
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FFramebufferID);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, ATexture.Handle, 0);
  // Conditionally disable smoothing based on parameter
  if ADisableSmoothing then
  begin
    glDisable(GL_LINE_SMOOTH);
    glDisable(GL_POLYGON_SMOOTH);
    glDisable(GL_POINT_SMOOTH);
    glDisable(GL_MULTISAMPLE);
  end;
  // Check framebuffer completeness
  if glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) <> GL_FRAMEBUFFER_COMPLETE_EXT then
  begin
    SetError('Framebuffer not complete', []);
    Exit;
  end;
  // Get texture dimensions
  LTextureWidth := Round(ATexture.GetSize().Width);
  LTextureHeight := Round(ATexture.GetSize().Height);
  // Calculate letterbox transform for texture (same logic as window resize)
  LAspectRatio := FVirtualSize.Width / FVirtualSize.Height;
  if LTextureWidth / LAspectRatio <= LTextureHeight then
  begin
    LNewWidth := LTextureWidth;
    LNewHeight := Round(LTextureWidth / LAspectRatio);
    LXOffset := 0;
    LYOffset := (LTextureHeight - LNewHeight) div 2;
  end
  else
  begin
    LNewWidth := Round(LTextureHeight * LAspectRatio);
    LNewHeight := LTextureHeight;
    LXOffset := (LTextureWidth - LNewWidth) div 2;
    LYOffset := 0;
  end;
  // Set viewport for texture
  glViewport(LXOffset, LYOffset, LNewWidth, LNewHeight);
  glScissor(LXOffset, LYOffset, LNewWidth, LNewHeight);
  // Update viewport tracking
  FViewport.pos.X := LXOffset;
  FViewport.pos.Y := LYOffset;
  FViewport.size.Width := LNewWidth;
  FViewport.size.Height := LNewHeight;
  // Set projection matrix - flipped Y for proper texture orientation
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, FVirtualSize.Width, 0, FVirtualSize.Height, -1, 1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;
*)

procedure Tg2dWindow.SetRenderTarget(const ATexture: Tg2dTexture; const ADisableSmoothing: Boolean);
var
  LTextureWidth, LTextureHeight: Integer;
begin
  if not Assigned(FHandle) then Exit;

  // Restore window rendering
  if ATexture = nil then
  begin
    if FFramebufferID <> 0 then
    begin
      glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
      glDeleteFramebuffersEXT(1, @FFramebufferID);
      FFramebufferID := 0;
    end;
    FCurrentRenderTarget := nil;
    FViewport := FSavedViewport;
    // Restore viewport
    glViewport(Round(FViewport.pos.x), Round(FViewport.pos.y), Round(FViewport.size.Width), Round(FViewport.size.Height));
    glScissor(Round(FViewport.pos.x), Round(FViewport.pos.y), Round(FViewport.size.Width), Round(FViewport.size.Height));
    // Restore the saved transform matrices
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(@FSavedProjectionMatrix[0]);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(@FSavedModelviewMatrix[0]);
    // Re-enable all smoothing/antialiasing
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_POLYGON_SMOOTH);
    glEnable(GL_POINT_SMOOTH);
    glEnable(GL_MULTISAMPLE);
    Exit;
  end;

  // Save current state before changing it
  FSavedViewport := FViewport;
  // Save current transform matrices
  glGetFloatv(GL_PROJECTION_MATRIX, @FSavedProjectionMatrix[0]);
  glGetFloatv(GL_MODELVIEW_MATRIX, @FSavedModelviewMatrix[0]);

  // Set texture as render target
  FCurrentRenderTarget := ATexture;

  // Create framebuffer if needed
  if FFramebufferID = 0 then
    glGenFramebuffersEXT(1, @FFramebufferID);

  // Bind framebuffer and attach texture
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FFramebufferID);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, ATexture.Handle, 0);

  // Conditionally disable smoothing based on parameter
  if ADisableSmoothing then
  begin
    glDisable(GL_LINE_SMOOTH);
    glDisable(GL_POLYGON_SMOOTH);
    glDisable(GL_POINT_SMOOTH);
    glDisable(GL_MULTISAMPLE);
  end;

  // Check framebuffer completeness
  if glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) <> GL_FRAMEBUFFER_COMPLETE_EXT then
  begin
    SetError('Framebuffer not complete', []);
    Exit;
  end;

  // Get texture dimensions
  LTextureWidth := Round(ATexture.GetSize().Width);
  LTextureHeight := Round(ATexture.GetSize().Height);

  // Set viewport to use full texture (no letterboxing)
  glViewport(0, 0, LTextureWidth, LTextureHeight);
  glScissor(0, 0, LTextureWidth, LTextureHeight);

  // Update viewport tracking
  FViewport.pos.X := 0;
  FViewport.pos.Y := 0;
  FViewport.size.Width := LTextureWidth;
  FViewport.size.Height := LTextureHeight;

  // Set projection matrix to match texture dimensions
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, LTextureWidth, 0, LTextureHeight, -1, 1);  // Use texture size as virtual resolution
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

function Tg2dWindow.GetRenderTarget(): Tg2dTexture;
begin
  Result := FCurrentRenderTarget;
end;

function Tg2dWindow.GetTextInputQueue(): string;
begin
  Result := FTextInputQueue;
end;

procedure Tg2dWindow.ClearTextInputQueue();
begin
  FTextInputQueue := '';
end;

procedure Tg2dWindow.EnableTextInput(const AEnable: Boolean);
begin
  FTextInputEnabled := AEnable;
  if not AEnable then
    ClearTextInputQueue();
end;

function Tg2dWindow.GetClipboardText(): string;
var
  LClipboardPtr: PAnsiChar;
begin
  Result := '';
  if not Assigned(FHandle) then Exit;

  LClipboardPtr := glfwGetClipboardString(FHandle);
  if Assigned(LClipboardPtr) then
    Result := string(AnsiString(LClipboardPtr));
end;

procedure Tg2dWindow.SetClipboardText(const AText: string);
begin
  if not Assigned(FHandle) then Exit;

  glfwSetClipboardString(FHandle, PAnsiChar(AnsiString(AText)));
end;

//=== TEXTURE ==================================================================
function  Texture_Read(AUser: Pointer; AData: PUTF8Char; ASize: Integer): Integer; cdecl;
var
  LIO: Tg2dIO;
begin
  Result := -1;

  LIO := Tg2dIO(AUser);
  if not Assigned(LIO) then Exit;

  Result := LIO.Read(AData, ASize);
end;

procedure Texture_Skip(AUser: Pointer; AOffset: Integer); cdecl;
var
  LIO: Tg2dIO;
begin
  LIO := Tg2dIO(AUser);
  if not Assigned(LIO) then Exit;

  LIO.Seek(AOffset, smCurrent);
end;

function  Texture_Eof(AUser: Pointer): Integer;  cdecl;
var
  LIO: Tg2dIO;
begin
  Result := -1;

  LIO := Tg2dIO(AUser);
  if not Assigned(LIO) then Exit;

  Result := Ord(LIO.Eos);
end;

procedure Tg2dTexture.ConvertMaskToAlpha(Data: Pointer; Width, Height: Integer; MaskColor: Tg2dColor);
var
  I: Integer;
  LPixelPtr: PRGBA;
begin
  LPixelPtr := PRGBA(Data);
  if not Assigned(LPixelPtr) then Exit;

  for I := 0 to Width * Height - 1 do
  begin
    if (LPixelPtr^.R = Round(MaskColor.Red * 256)) and
       (LPixelPtr^.G = Round(MaskColor.Green * 256)) and
       (LPixelPtr^.B = Round(MaskColor.Blue * 256)) then
      LPixelPtr^.A := 0
    else
      LPixelPtr^.A := 255;

    Inc(LPixelPtr);
  end;
end;

constructor Tg2dTexture.Create();
begin
  inherited;
  FKind := tkHD;
  FOwnsHandle := True;

  SetKind(tkHD);
  SetBlend(tbAlpha);
  SetColor(G2D_WHITE);
  SetScale(1.0);
  SetAngle(0.0);
  SetHFlip(False);
  SetVFlip(False);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetPos(0.0, 0.0);
  ResetRegion();
end;

destructor Tg2dTexture.Destroy();
begin
  Unload();
  inherited;
end;

procedure Tg2dTexture.Share(const ATexture: Tg2dTexture; const AShareMode: Tg2dTextureShareMode);
begin
  if not Assigned(ATexture) then Exit;
  if not ATexture.IsLoaded() then Exit;

  // Unload any existing texture first (respecting current ownership)
  Unload();

  // Share the OpenGL handle and all properties
  FHandle := ATexture.GetHandle();
  FSize := ATexture.GetSize();
  FChannels := ATexture.GetChannels();
  FKind := ATexture.GetKind();
  FOwnsHandle := False;  // We're sharing, so we don't own this handle

  case AShareMode of
    // Skip sharing properties
    tsmSkip:
    begin
    end;

    // Copy all properties
    tsmCopy:
    begin
      FBlend := ATexture.GetBlend();
      FColor := ATexture.GetColor();
      FScale := ATexture.GetScale();
      FAngle := ATexture.GetAngle();
      FHFlip := ATexture.GetHFlip();
      FVFlip := ATexture.GetVFlip();
      FPivot := ATexture.GetPivot();
      FAnchor := ATexture.Anchor();
      FPos := ATexture.GetPos();
      FRegion := ATexture.GetRegion();
    end;

    // Reset properties to defaults
    tsmReset:
    begin
      SetKind(tkHD);
      SetBlend(tbAlpha);
      SetColor(G2D_WHITE);
      SetScale(1.0);
      SetAngle(0.0);
      SetHFlip(False);
      SetVFlip(False);
      SetPivot(0.5, 0.5);
      SetAnchor(0.5, 0.5);
      SetPos(0.0, 0.0);
      ResetRegion();
    end;
  end;
end;

function  Tg2dTexture.Alloc(const AWidth, AHeight: Integer; const AColor: Tg2dColor): Boolean;
var
  LData: array of Byte;
begin
  Result := False;

  if FHandle <> 0 then Exit;

  // init RGBA data
  SetLength(LData, AWidth * AHeight * 4);

  glGenTextures(1, @FHandle);
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // init the texture with transparent pixels
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, AWidth, AHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, @LData[0]);

  // set texture parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  FSize.Width := AWidth;
  FSize.Height := AHeight;
  FChannels := 4;

  SetKind(tkHD);
  SetBlend(tbAlpha);
  SetColor(G2D_WHITE);
  SetScale(1.0);
  SetAngle(0.0);
  SetHFlip(False);
  SetVFlip(False);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetPos(0.0, 0.0);
  ResetRegion();

  glBindTexture(GL_TEXTURE_2D, 0);

  Fill(AColor);

  Result := True;
end;

procedure Tg2dTexture.Fill(const AColor: Tg2dColor);
var
  X,Y,LWidth,LHeight: Integer;
begin
  if FHandle = 0 then Exit;

  LWidth := Round(FSize.Width);
  LHeight := Round(FSize.Height);

  glBindTexture(GL_TEXTURE_2D, FHandle);

  for X := 0 to LWidth-1 do
  begin
    for Y := 0 to LHeight-1 do
    begin
      glTexSubImage2D(GL_TEXTURE_2D, 0, X, Y, 1, 1, GL_RGBA, GL_FLOAT, @AColor);
    end;
  end;

  glBindTexture(GL_TEXTURE_2D, 0);
end;

function  Tg2dTexture.Load(const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean;
begin
  Result := False;

  if FHandle > 0 then Exit;

  if not Alloc(AWidth, AHeight, G2D_BLANK) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, AWidth, AHeight, 0, GL_ALPHA, GL_UNSIGNED_BYTE, ARGBData);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glBindTexture(GL_TEXTURE_2D, 0);

  SetKind(tkHD);

  Result := True;
end;

function  Tg2dTexture.Load(const AIO: Tg2dIO; const AOwnIO: Boolean; const AColorKey: Pg2dColor): Boolean;
var
  LCallbacks: stbi_io_callbacks;
  LData: Pstbi_uc;
  LWidth,LHeight,LChannels: Integer;
  LIO: Tg2dIO;
begin
  Result := False;

  if FHandle > 0 then Exit;

  if not Assigned(AIO) then Exit;

  LIO := AIO;

  LCallbacks.read := Texture_Read;
  LCallbacks.skip := Texture_Skip;
  LCallbacks.eof := Texture_Eof;

  LData := stbi_load_from_callbacks(@LCallbacks, LIO, @LWidth, @LHeight, @LChannels, 4);
  if not Assigned(LData) then Exit;

  if Assigned(AColorKey) then
    ConvertMaskToAlpha(LData, LWidth, LHeight, AColorKey^);

  glGenTextures(1, @FHandle);
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // Set texture parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, LWidth, LHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, LData);

  stbi_image_free(LData);

  FSize.Width := LWidth;
  FSize.Height := LHeight;
  FChannels := LChannels;

  SetKind(tkHD);
  SetBlend(tbAlpha);
  SetColor(G2D_WHITE);
  SetScale(1.0);
  SetAngle(0.0);
  SetHFlip(False);
  SetVFlip(False);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetPos(0.0, 0.0);
  ResetRegion();

  glBindTexture(GL_TEXTURE_2D, 0);

  if AOwnIO then
  begin
    AIO.Free();
  end;

  Result := True;
end;

function  Tg2dTexture.LoadFromFile(const AFilename: string; const AColorKey: Pg2dColor): Boolean;
var
  LIO: Tg2dFileIO;
begin
  Result := False;
  LIO := Tg2dFileIO.Create();
  try
    if not LIO.Open(AFilename, iomRead) then Exit;
    Result := Load(LIO, False, AColorKey);
  finally
    LIO.Free();
  end;
end;

function  Tg2dTexture.LoadFromZipFile(const AZipFilename, AFilename: string; const AColorKey: Pg2dColor; const APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
begin
  Result := False;
  LIO := Tg2dZipFileIO.Create();
  try
    if not LIO.Open(AZipFilename, AFilename, APassword) then Exit;
    Result := Load(LIO, False, AColorkey);
  finally
    LIO.Free();
  end;
end;

function  Tg2dTexture.IsLoaded(): Boolean;
begin
  Result := Boolean(FHandle > 0);
end;

procedure Tg2dTexture.Unload();
begin
  if FHandle > 0 then
  begin
    if FOwnsHandle then  // Only delete if we own it
      glDeleteTextures(1, @FHandle);
  end;
  FHandle := 0;
  // Don't reset FOwnsHandle here - let it keep its state
end;

function  Tg2dTexture.GetHandle(): Cardinal;
begin
  Result := FHandle;
end;

function  Tg2dTexture.GetChannels(): Integer;
begin
  Result := FChannels;
end;

function  Tg2dTexture.GetSize(): Tg2dSize;
begin
  Result := FSize;
end;

function  Tg2dTexture.GetKind(): Tg2dTextureKind;
begin
  Result := FKind;
end;

procedure Tg2dTexture.SetKind(const AKind: Tg2dTextureKind);
begin
  FKind := AKind;
end;

function  Tg2dTexture.GetPivot(): Tg2dVec;
begin
  Result := Tg2dVec.Create(0,0);
  Result := FPivot;
end;

procedure Tg2dTexture.SetPivot(const APoint: Tg2dVec);
begin
  SetPivot(APoint.X, APoint.Y);
end;

procedure Tg2dTexture.SetPivot(const X, Y: Single);
begin
  FPivot.x := EnsureRange(X, 0, 1);
  FPivot.y := EnsureRange(Y, 0, 1);
end;

function  Tg2dTexture.Anchor(): Tg2dVec;
begin
  Result := FAnchor;
end;

procedure Tg2dTexture.SetAnchor(const APoint: Tg2dVec);
begin
  SetAnchor(APoint.x, APoint.y);
end;

procedure Tg2dTexture.SetAnchor(const X, Y: Single);
begin
  FAnchor.x := EnsureRange(X, 0, 1);
  FAnchor.y := EnsureRange(Y, 0, 1);
end;

function  Tg2dTexture.GetBlend(): Tg2dTextureBlend;
begin
  Result := FBlend;
end;

procedure Tg2dTexture.SetBlend(const AValue: Tg2dTextureBlend);
begin
  FBlend := AValue;
end;

function  Tg2dTexture.GetPos(): Tg2dVec;
begin
  Result := FPos;
end;

procedure Tg2dTexture.SetPos(const APos: Tg2dVec);
begin
  FPos := APos;
end;

procedure Tg2dTexture.SetPos(const X, Y: Single);
begin
  FPos.x := X;
  FPos.y := Y;
end;

function  Tg2dTexture.GetScale(): Single;
begin
  Result := FScale;
end;

procedure Tg2dTexture.SetScale(const AScale: Single);
begin
  FScale := AScale;
end;

function  Tg2dTexture.GetColor(): Tg2dColor;
begin
  Result := G2D_BLANK;
  if FHandle = 0 then Exit;
  Result := FColor;
end;

procedure Tg2dTexture.SetColor(const AColor: Tg2dColor);
begin
  FColor := AColor;
end;

procedure Tg2dTexture.SetColor(const ARed, AGreen, ABlue, AAlpha: Single);
begin
  FColor.Red:= EnsureRange(ARed, 0, 1);
  FColor.Green := EnsureRange(AGreen, 0, 1);
  FColor.Blue := EnsureRange(ABlue, 0, 1);
  FColor.Alpha := EnsureRange(AAlpha, 0, 1);
end;

function  Tg2dTexture.GetAngle(): Single;
begin
  Result := FAngle;
end;

procedure Tg2dTexture.SetAngle(const AAngle: Single);
begin
  FAngle := AAngle;
end;

function  Tg2dTexture.GetHFlip(): Boolean;
begin
  Result := FHFlip;
end;

procedure Tg2dTexture.SetHFlip(const AFlip: Boolean);
begin
  FHFlip := AFlip;
end;

function  Tg2dTexture.GetVFlip(): Boolean;
begin
  Result := FVFlip;
end;

procedure Tg2dTexture.SetVFlip(const AFlip: Boolean);
begin
  FVFlip := AFlip;
end;

function  Tg2dTexture.GetRegion(): Tg2dRect;
begin
  Result := FRegion;
end;

procedure Tg2dTexture.SetRegion(const ARegion: Tg2dRect);
begin
  SetRegion(ARegion.pos.x, ARegion.pos.y, ARegion.size.Width, ARegion.size.Height);
end;

procedure Tg2dTexture.SetRegion(const X, Y, AWidth, AHeight: Single);
begin
  FRegion.pos.X := X;
  FRegion.pos.Y := Y;
  FRegion.size.Width := AWidth;
  FRegion.size.Height := AHeight;
end;

procedure Tg2dTexture.ResetRegion();
begin
  FRegion.pos.X := 0;
  FRegion.pos.Y := 0;
  FRegion.size.Width := FSize.Width;
  FRegion.size.Height := FSize.Height;
end;

procedure Tg2dTexture.Draw();
var
  LFlipX: Single;
  LFlipY: Single;
begin
  if FHandle = 0 then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glEnable(GL_TEXTURE_2D);

  // Apply texture parameters
  case FKind of
    tkPixelArt:
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    end;

    tkHD:
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    end;
  end;

  glPushMatrix();

  // Set the color
  glColor4f(FColor.Red, FColor.Green, FColor.Blue, FColor.Alpha);

  // set blending
  case FBlend of
    tbNone: // no blending
    begin
      glDisable(GL_BLEND);
      glBlendFunc(GL_ONE, GL_ZERO);
    end;

    tbAlpha: // alpha blending
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    end;

    tbAdditiveAlpha: // addeditve blending
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    end;
  end;

  // Use the normalized anchor value
  glTranslatef(FPos.X - (FAnchor.X * FRegion.size.Width * FScale), FPos.Y - (FAnchor.Y * FRegion.size.Height * FScale), 0);
  glScalef(FScale, FScale, 1);

  // Apply rotation using the normalized pivot value
  glTranslatef(FPivot.X * FRegion.size.Width, FPivot.Y * FRegion.size.Height, 0);
  glRotatef(FAngle, 0, 0, 1);
  glTranslatef(-FPivot.X * FRegion.size.Width, -FPivot.Y * FRegion.size.Height, 0);

  // Apply flip
  if FHFlip then LFlipX := -1 else LFlipX := 1;
  if FVFlip then LFlipY := -1 else LFlipY := 1;
  glScalef(LFlipX, LFlipY, 1);

  // Adjusted texture coordinates and vertices for the specified rectangle
  glBegin(GL_QUADS);
    glTexCoord2f(FRegion.pos.X/FSize.Width, FRegion.pos.Y/FSize.Height); glVertex2f(0, 0);
    glTexCoord2f((FRegion.pos.X + FRegion.size.Width)/FSize.Width, FRegion.pos.Y/FSize.Height); glVertex2f(FRegion.size.Width, 0);
    glTexCoord2f((FRegion.pos.X + FRegion.size.Width)/FSize.Width, (FRegion.pos.Y + FRegion.size.Height)/FSize.Height); glVertex2f(FRegion.size.Width, FRegion.size.Height);
    glTexCoord2f(FRegion.pos.X/FSize.Width, (FRegion.pos.Y + FRegion.size.Height)/FSize.Height); glVertex2f(0, FRegion.size.Height);
  glEnd();

  glPopMatrix();

  glDisable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, 0);
end;

procedure Tg2dTexture.DrawTiled(const AWindowLogicalWidth, AWindowLogicalHeight, ADeltaX, ADeltaY: Single);
var
  LW,LH    : Integer;
  LOX,LOY  : Integer;
  LPX,LPY  : Single;
  LFX,LFY  : Single;
  LTX,LTY  : Integer;
  LVPW,LVPH: Integer;
  LVR,LVB  : Integer;
  LIX,LIY  : Integer;
begin
  if FHandle = 0 then Exit;

  SetPivot(0, 0);
  SetAnchor(0, 0);

  LVPW := Round(AWindowLogicalWidth);
  LVPH := Round(AWindowLogicalHeight);

  LW := Round(FSize.Width);
  LH := Round(FSize.Height);

  LOX := -LW+1;
  LOY := -LH+1;

  LPX := aDeltaX;
  LPY := aDeltaY;

  LFX := LPX-floor(LPX);
  LFY := LPY-floor(LPY);

  LTX := floor(LPX)-LOX;
  LTY := floor(LPY)-LOY;

  if (LTX>=0) then LTX := LTX mod LW + LOX else LTX := LW - -LTX mod LW + LOX;
  if (LTY>=0) then LTY := LTY mod LH + LOY else LTY := LH - -LTY mod LH + LOY;

  LVR := LVPW;
  LVB := LVPH;
  LIY := LTY;

  while LIY<LVB do
  begin
    LIX := LTX;
    while LIX<LVR do
    begin
      SetPos(LIX+LFX, LIY+LFY);
      Draw();
      LIX := LIX+LW;
    end;
   LIY := LIY+LH;
  end;
end;

function  Tg2dTexture.Save(const AFilename: string): Boolean;
var
  LData: array of Byte;
  LFilename: string;
begin
  Result := False;
  if FHandle = 0 then Exit;

  if AFilename.IsEmpty then Exit;

  // Allocate space for the texture data
  SetLength(LData, Round(FSize.Width * FSize.Height * 4)); // Assuming RGBA format

  // Bind the texture
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // Read the texture data
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, @LData[0]);

  LFilename := TPath.ChangeExtension(AFilename, 'png');

  // Use stb_image_write to save the texture to a PNG file
  Result := Boolean(stbi_write_png(Tg2dUtils.AsUtf8(LFilename, []), Round(FSize.Width), Round(FSize.Height), 4, @LData[0], Round(FSize.Width * 4)));

  // Unbind the texture
  glBindTexture(GL_TEXTURE_2D, 0);
end;

function  Tg2dTexture.Lock(): Boolean;
begin
  Result := False;
  if FHandle = 0 then Exit;

  if Assigned(FLock) then Exit;

  GetMem(FLock, Round(FSize.Width*FSize.Height*4));
  if not Assigned(FLock) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, FLock);
  glBindTexture(GL_TEXTURE_2D, 0);

  Result := True;
end;

procedure Tg2dTexture.Unlock();
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, Round(FSize.Width), Round(FSize.Height), GL_RGBA, GL_UNSIGNED_BYTE, FLock);
  glBindTexture(GL_TEXTURE_2D, 0);
  FreeMem(FLock);
  FLock := nil;
end;

function  Tg2dTexture.GetPixel(const X, Y: Single): Tg2dColor;
var
  LOffset: Integer;
  LPixel: Cardinal;
begin
  Result := G2D_BLANK;
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.Width + X) * 4);
  LPixel := PCardinal(FLock + LOffset)^;

  Result.Alpha := (LPixel shr 24) / $FF;
  Result.Blue := ((LPixel shr 16) and $FF) / $FF;
  Result.Green := ((LPixel shr 8) and $FF) / $FF;
  Result.Red := (LPixel and $FF) / $FF;
end;

procedure Tg2dTexture.SetPixel(const X, Y: Single; const AColor: Tg2dColor);
var
  LOffset: Integer;
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.Width + X) * 4);
  PCardinal(FLock + LOffset)^ :=
    (Round(AColor.Alpha*$FF) shl 24) or
    (Round(AColor.Blue*$FF) shl 16) or
    (Round(AColor.Green*$FF) shl 8) or
    Round(AColor.Red*$FF);
end;

procedure Tg2dTexture.SetPixel(const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte);
var
  LOffset: Integer;
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.Width + X) * 4);
  PCardinal(FLock + LOffset)^ :=
    (AAlpha shl 24) or
    (ABlue shl 16) or
    (AGreen shl 8) or
    ARed;
end;

class function Tg2dTexture.Init(const AZipFilename, AFilename: string; const AColorKey: Pg2dColor; const APassword: string): Tg2dTexture;
begin
  Result := Tg2dTexture.Create();
  if not Result.LoadFromZipFile(AZipFilename, AFilename, AColorKey, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

class procedure Tg2dTexture.Delete(const ATexture: GLuint);
var
  LCurrentTexture: GLuInt;
begin
  // Exit if the texture pointer is not valid.
  if ATexture = 0 then Exit;

  // Save current texture
  glGetIntegerv(GL_TEXTURE_BINDING_2D, @LCurrentTexture);

  // Delete spine texture
  glDeleteTextures(1, @ATexture);

  // Restore current texture
  if LCurrentTexture <> 0 then
  begin
    glBindTexture(GL_TEXTURE_2D, LCurrentTexture);
  end;
end;

//=== SHADER ===================================================================
{ Tg2dShader }
constructor Tg2dShader.Create();
begin
  inherited;
  FVertexShader := 0;
  FFragmentShader := 0;
  FProgram := 0;
  FIsBuilt := False;
end;

destructor Tg2dShader.Destroy();
begin
  Clear();
  inherited;
end;

procedure Tg2dShader.Clear();
begin
  if FProgram <> 0 then
  begin
    glDeleteProgram(FProgram);
    FProgram := 0;
  end;

  if FVertexShader <> 0 then
  begin
    glDeleteShader(FVertexShader);
    FVertexShader := 0;
  end;

  if FFragmentShader <> 0 then
  begin
    glDeleteShader(FFragmentShader);
    FFragmentShader := 0;
  end;

  FIsBuilt := False;
end;

function Tg2dShader.CompileShader(const AKind: Tg2dShaderKind; const ASource: string): GLuint;
var
  LShader: GLuint;
  LSourcePtr: PAnsiChar;
  LCompiled: GLint;
  LLog: string;
begin
  Result := 0;

  if ASource.IsEmpty then
  begin
    SetError('Shader source is empty', []);
    Exit;
  end;

  LShader := glCreateShader(GLenum(AKind));
  if LShader = 0 then
  begin
    SetError('Failed to create shader', []);
    Exit;
  end;

  LSourcePtr := PAnsiChar(AnsiString(ASource));
  glShaderSource(LShader, 1, @LSourcePtr, nil);
  glCompileShader(LShader);

  glGetShaderiv(LShader, GL_COMPILE_STATUS, @LCompiled);
  if LCompiled = GL_FALSE then
  begin
    LLog := GetShaderLog(LShader);
    glDeleteShader(LShader);
    SetError('Shader compilation failed: %s', [LLog]);
    Exit;
  end;

  Result := LShader;
end;

function Tg2dShader.GetShaderLog(const AShader: GLuint): string;
var
  LLength: GLint;
  LLog: PAnsiChar;
begin
  Result := '';

  glGetShaderiv(AShader, GL_INFO_LOG_LENGTH, @LLength);
  if LLength > 0 then
  begin
    GetMem(LLog, LLength);
    try
      glGetShaderInfoLog(AShader, LLength, nil, LLog);
      Result := string(AnsiString(LLog));
    finally
      FreeMem(LLog);
    end;
  end;
end;

function Tg2dShader.GetProgramLog(const AProgram: GLuint): string;
var
  LLength: GLint;
  LLog: PAnsiChar;
begin
  Result := '';

  glGetProgramiv(AProgram, GL_INFO_LOG_LENGTH, @LLength);
  if LLength > 0 then
  begin
    GetMem(LLog, LLength);
    try
      glGetProgramInfoLog(AProgram, LLength, nil, LLog);
      Result := string(AnsiString(LLog));
    finally
      FreeMem(LLog);
    end;
  end;
end;

function Tg2dShader.Load(const AKind: Tg2dShaderKind; const ASource: string): Boolean;
var
  LShader: GLuint;
begin
  Result := False;

  LShader := CompileShader(AKind, ASource);
  if LShader = 0 then Exit;

  case AKind of
    skVertex:
    begin
      if FVertexShader <> 0 then
        glDeleteShader(FVertexShader);
      FVertexShader := LShader;
    end;

    skFragment:
    begin
      if FFragmentShader <> 0 then
        glDeleteShader(FFragmentShader);
      FFragmentShader := LShader;
    end;
  end;

  Result := True;
end;

function Tg2dShader.Load(const AIO: Tg2dIO; const AKind: Tg2dShaderKind): Boolean;
var
  LSource: string;
  LBuffer: TBytes;
  LSize: Int64;
begin
  Result := False;

  if not Assigned(AIO) then
  begin
    SetError('IO object is nil', []);
    Exit;
  end;

  if not AIO.IsOpen() then
  begin
    SetError('IO object is not open', []);
    Exit;
  end;

  LSize := AIO.Size();
  if LSize <= 0 then
  begin
    SetError('Shader file is empty', []);
    Exit;
  end;

  SetLength(LBuffer, LSize);
  if AIO.Read(@LBuffer[0], LSize) <> LSize then
  begin
    SetError('Failed to read shader file', []);
    Exit;
  end;

  LSource := TEncoding.UTF8.GetString(LBuffer);
  Result := Load(AKind, LSource);
end;

function Tg2dShader.LoadFromFile(const AFilename: string; const AKind: Tg2dShaderKind): Boolean;
var
  LIO: Tg2dFileIO;
begin
  Result := False;

  LIO := Tg2dFileIO.Create();
  try
    if not LIO.Open(AFilename, iomRead) then
    begin
      SetError('Failed to open shader file: %s', [AFilename]);
      Exit;
    end;

    Result := Load(LIO, AKind);
  finally
    LIO.Free();
  end;
end;

function Tg2dShader.LoadFromZipFile(const AZipFilename: string; const AFilename: string; const AKind: Tg2dShaderKind; const APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
begin
  Result := False;

  LIO := Tg2dZipFileIO.Create();
  try
    if not LIO.Open(AZipFilename, AFilename, APassword) then
    begin
      SetError('Failed to open shader file from zip: %s/%s', [AZipFilename, AFilename]);
      Exit;
    end;

    Result := Load(LIO, AKind);
  finally
    LIO.Free();
  end;
end;

function Tg2dShader.Build(): Boolean;
var
  LLinked: GLint;
  LLog: string;
begin
  Result := False;
  FIsBuilt := False;

  if (FVertexShader = 0) or (FFragmentShader = 0) then
  begin
    SetError('Both vertex and fragment shaders must be loaded before building', []);
    Exit;
  end;

  if FProgram <> 0 then
    glDeleteProgram(FProgram);

  FProgram := glCreateProgram();
  if FProgram = 0 then
  begin
    SetError('Failed to create shader program', []);
    Exit;
  end;

  glAttachShader(FProgram, FVertexShader);
  glAttachShader(FProgram, FFragmentShader);
  glLinkProgram(FProgram);

  glGetProgramiv(FProgram, GL_LINK_STATUS, @LLinked);
  if LLinked = GL_FALSE then
  begin
    LLog := GetProgramLog(FProgram);
    glDeleteProgram(FProgram);
    FProgram := 0;
    SetError('Shader program linking failed: %s', [LLog]);
    Exit;
  end;

  FIsBuilt := True;
  Result := True;
end;

function Tg2dShader.Enable(const AEnable: Boolean): Boolean;
begin
  Result := False;

  if AEnable then
  begin
    if not FIsBuilt then
    begin
      SetError('Shader must be built before enabling', []);
      Exit;
    end;

    glUseProgram(FProgram);
  end
  else
  begin
    glUseProgram(0);
  end;

  Result := True;
end;

function Tg2dShader.GetLog(): string;
begin
  Result := GetError();
end;

function Tg2dShader.IsBuilt(): Boolean;
begin
  Result := FIsBuilt;
end;

function Tg2dShader.SetIntUniform(const AName: string; const AValue: Integer): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniform1i(LLocation, AValue);
  Result := True;
end;

function Tg2dShader.SetIntUniform(const AName: string; const ANumComponents: Integer; const AValue: PInteger; const ANumElements: Integer): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  if not Assigned(AValue) then
  begin
    SetError('Value pointer is nil', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  case ANumComponents of
    1: glUniform1iv(LLocation, ANumElements, PGLint(AValue));
    2: glUniform2iv(LLocation, ANumElements, PGLint(AValue));
    3: glUniform3iv(LLocation, ANumElements, PGLint(AValue));
    4: glUniform4iv(LLocation, ANumElements, PGLint(AValue));
  else
    SetError('Invalid number of components: %d', [ANumComponents]);
    Exit;
  end;

  Result := True;
end;

function Tg2dShader.SetFloatUniform(const AName: string; const AValue: Single): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniform1f(LLocation, AValue);
  Result := True;
end;

function Tg2dShader.SetFloatUniform(const AName: string; const ANumComponents: Integer; const AValue: PSingle; const ANumElements: Integer): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  if not Assigned(AValue) then
  begin
    SetError('Value pointer is nil', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  case ANumComponents of
    1: glUniform1fv(LLocation, ANumElements, PGLfloat(AValue));
    2: glUniform2fv(LLocation, ANumElements, PGLfloat(AValue));
    3: glUniform3fv(LLocation, ANumElements, PGLfloat(AValue));
    4: glUniform4fv(LLocation, ANumElements, PGLfloat(AValue));
  else
    SetError('Invalid number of components: %d', [ANumComponents]);
    Exit;
  end;

  Result := True;
end;

function Tg2dShader.SetBoolUniform(const AName: string; const AValue: Boolean): Boolean;
begin
  Result := SetIntUniform(AName, Ord(AValue));
end;

function Tg2dShader.SetTextureUniform(const AName: string; const ATexture: Tg2dTexture; const AUnit: Integer): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  if not Assigned(ATexture) then
  begin
    SetError('Texture is nil', []);
    Exit;
  end;

  if not ATexture.IsLoaded() then
  begin
    SetError('Texture is not loaded', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glActiveTexture(GL_TEXTURE0 + AUnit);
  glBindTexture(GL_TEXTURE_2D, ATexture.GetHandle());
  glUniform1i(LLocation, AUnit);

  Result := True;
end;

function Tg2dShader.SetVec2Uniform(const AName: string; const AValue: Tg2dVec): Boolean;
begin
  Result := SetVec2Uniform(AName, AValue.X, AValue.Y);
end;

function Tg2dShader.SetVec2Uniform(const AName: string; const AX: Single; const AY: Single): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniform2f(LLocation, AX, AY);
  Result := True;
end;

function Tg2dShader.SetVec2Uniform(const AName: string; const ASize: Tg2dSize): Boolean;
begin
  Result := SetVec2Uniform(AName, ASize.Width, ASize.Height);
end;

function Tg2dShader.SetVec3Uniform(const AName: string; const AValue: Tg2dVec): Boolean;
begin
  Result := SetVec3Uniform(AName, AValue.X, AValue.Y, AValue.Z);
end;

function Tg2dShader.SetVec3Uniform(const AName: string; const AX: Single; const AY: Single; const AZ: Single): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniform3f(LLocation, AX, AY, AZ);
  Result := True;
end;

function Tg2dShader.SetVec4Uniform(const AName: string; const AValue: Tg2dVec): Boolean;
begin
  Result := SetVec4Uniform(AName, AValue.X, AValue.Y, AValue.Z, AValue.W);
end;


function Tg2dShader.SetVec4Uniform(const AName: string; const AX: Single; const AY: Single; const AZ: Single; const AW: Single): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniform4f(LLocation, AX, AY, AZ, AW);
  Result := True;
end;

function Tg2dShader.SetColorUniform(const AName: string; const AColor: Tg2dColor): Boolean;
begin
  Result := SetVec4Uniform(AName, AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);
end;

function Tg2dShader.SetMatrix4Uniform(const AName: string; const AMatrix: array of Single): Boolean;
var
  LLocation: GLint;
begin
  Result := False;

  if not FIsBuilt then
  begin
    SetError('Shader must be built before setting uniforms', []);
    Exit;
  end;

  if Length(AMatrix) <> 16 then
  begin
    SetError('Matrix must have 16 elements', []);
    Exit;
  end;

  LLocation := glGetUniformLocation(FProgram, PAnsiChar(AnsiString(AName)));
  if LLocation = -1 then
  begin
    SetError('Uniform "%s" not found', [AName]);
    Exit;
  end;

  glUniformMatrix4fv(LLocation, 1, GL_FALSE, @AMatrix[0]);
  Result := True;
end;

class function Tg2dShader.Init(const AVertexSource: string; const AFragmentSource: string): Tg2dShader;
begin
  Result := Tg2dShader.Create();

  if not Result.Load(skVertex, AVertexSource) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;

  if not Result.Load(skFragment, AFragmentSource) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;

  if not Result.Build() then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;
end;

//=== FONT =====================================================================
{ Tg2dFontSDF }
constructor Tg2dFont.Create();
begin
  inherited;
  FGlyph := TDictionary<Integer, TGlyph>.Create();
  FSmoothness := 0.1;
  FThreshold := 0.5;
  FOutlineColor := G2D_BLACK;
  FOutlineThreshold := 0.3;
  FEnableOutline := False;
  FGeneratedSize := 0;
  FDpiScale := 1.0;
end;

destructor Tg2dFont.Destroy();
begin
  Unload();
  FGlyph.Free();
  inherited;
end;

procedure Tg2dFont.InitializeShader();
begin
  if Assigned(FShader) then
    FShader.Free();

  FShader := Tg2dShader.Init(G2D_SDF_VERTEX_SHADER, G2D_SDF_FRAGMENT_SHADER);
  if not Assigned(FShader) then
  begin
    SetError('Failed to create SDF shader', []);
    Exit;
  end;
end;

procedure Tg2dFont.SetShaderUniforms();
begin
  if not Assigned(FShader) then Exit;

  FShader.Enable(True);
  FShader.SetTextureUniform('uTexture', FAtlas, 0);
  FShader.SetFloatUniform('uSmoothness', FSmoothness);
  FShader.SetFloatUniform('uThreshold', FThreshold);
  FShader.SetColorUniform('uOutlineColor', FOutlineColor);
  FShader.SetFloatUniform('uOutlineThreshold', FOutlineThreshold);
  FShader.SetIntUniform('uEnableOutline', Ord(FEnableOutline));
end;

function Tg2dFont.Load(const AWindow: Tg2dWindow; const ASize: Cardinal; const AGlyphs: string): Boolean;
const
  CDefaultFontResName = '55fb2d6c54b44934a3b3bfadbb3a00c8';
var
  LResStream: TResourceStream;
  LIO: Tg2dMemoryIO;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;
  if not Tg2dUtils.ResourceExists(HInstance, CDefaultFontResName) then Exit;

  LResStream := TResourceStream.Create(HInstance, CDefaultFontResName, RT_RCDATA);
  try
    LIO := Tg2dMemoryIO.Create;
    try
      LIO.Open(LResStream.Memory, LResStream.Size);
      Result := Load(AWindow, LIO, ASize, AGlyphs, False);
    finally
      LIO.Free();
    end;
  finally
    LResStream.Free();
  end;
end;

function Tg2dFont.Load(const AWindow: Tg2dWindow; const AIO: Tg2dIO; const ASize: Cardinal; const AGlyphs: string; const AOwnIO: Boolean): Boolean;
var
  LBuffer: Tg2dVirtualBuffer;
  LFileSize: Int64;
  LFontInfo: stbtt_fontinfo;
  LNumOfGlyphs: Integer;
  LGlyphChars: string;
  LCodePoints: array of Integer;
  LAtlasData: array of Byte;
  LI: Integer;
  LX: Integer;
  LY: Integer;
  LGlyph: TGlyph;
  LScale: Single;
  LAscent: Integer;
  LDescent: Integer;
  LLineGap: Integer;
  LSize: Single;
  LMaxTextureSize: Integer;
  LDpiScale: Single;
  LIO: Tg2dIO;
  LGlyphIndex: Integer;
  LAdvanceWidth: Integer;
  LLeftSideBearing: Integer;
  LX0: Integer;
  LY0: Integer;
  LX1: Integer;
  LY1: Integer;
  LGlyphWidth: Integer;
  LGlyphHeight: Integer;
  LAtlasX: Integer;
  LAtlasY: Integer;
  LRowHeight: Integer;
  LCurrentX: Integer;
  LCurrentY: Integer;
  LGlyphSDFData: PByte;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;
  if not Assigned(AIO) then Exit;

  LIO := AIO;
  LDpiScale := AWindow.GetScale().Height;
  LMaxTextureSize := AWindow.GetMaxTextureSize();
  LSize := ASize * LDpiScale;

  FGeneratedSize := ASize;
  FDpiScale := LDpiScale;

  LFileSize := LIO.Size();
  LBuffer := Tg2dVirtualBuffer.Create(LFileSize);
  try
    LIO.Read(LBuffer.Memory, LFileSize);

    if stbtt_InitFont(@LFontInfo, LBuffer.Memory, 0) = 0 then Exit;

    LGlyphChars := DEFAULT_GLYPHS + AGlyphs;
    LGlyphChars := Tg2dUtils.RemoveDuplicates(LGlyphChars);
    LNumOfGlyphs := LGlyphChars.Length;
    SetLength(LCodePoints, LNumOfGlyphs);

    for LI := 1 to LNumOfGlyphs do
    begin
      LCodePoints[LI-1] := Integer(Char(LGlyphChars[LI]));
    end;

    LScale := stbtt_ScaleForMappingEmToPixels(@LFontInfo, LSize);
    stbtt_GetFontVMetrics(@LFontInfo, @LAscent, @LDescent, @LLineGap);
    FBaseline := LAscent * LScale;
    FLineHeight := (LAscent - LDescent + LLineGap) * LScale;

    // Calculate atlas size needed
    FAtlasSize := 256;
    while FAtlasSize <= LMaxTextureSize do
    begin
      // Try to pack glyphs in current atlas size
      LCurrentX := SDF_PADDING;
      LCurrentY := SDF_PADDING;
      LRowHeight := 0;

      for LI := 0 to LNumOfGlyphs - 1 do
      begin
        // Skip space character in atlas size calculation (it has no visual content)
        if LCodePoints[LI] = 32 then Continue;

        LGlyphIndex := stbtt_FindGlyphIndex(@LFontInfo, LCodePoints[LI]);
        if LGlyphIndex = 0 then Continue; // Skip missing glyphs

        stbtt_GetGlyphBox(@LFontInfo, LGlyphIndex, @LX0, @LY0, @LX1, @LY1);

        // Validate glyph box coordinates
        if (LX1 <= LX0) or (LY1 <= LY0) or (LX1 - LX0 > 10000) or (LY1 - LY0 > 10000) then
          Continue; // Skip invalid glyph boxes

        LGlyphWidth := Round((LX1 - LX0) * LScale) + 2 * SDF_PADDING;
        LGlyphHeight := Round((LY1 - LY0) * LScale) + 2 * SDF_PADDING;

        if LCurrentX + LGlyphWidth + SDF_PADDING > FAtlasSize then
        begin
          LCurrentX := SDF_PADDING;
          LCurrentY := LCurrentY + LRowHeight + SDF_PADDING;
          LRowHeight := 0;
        end;

        if LCurrentY + LGlyphHeight + SDF_PADDING > FAtlasSize then
          Break;

        LCurrentX := LCurrentX + LGlyphWidth + SDF_PADDING;
        if LGlyphHeight > LRowHeight then
          LRowHeight := LGlyphHeight;
      end;

      if LI >= LNumOfGlyphs then
        Break;

      FAtlasSize := FAtlasSize * 2;
    end;

    if FAtlasSize > LMaxTextureSize then
    begin
      SetError('Font SDF texture too large. Max size: %d', [LMaxTextureSize]);
      Exit;
    end;

    // Create atlas texture data
    SetLength(LAtlasData, FAtlasSize * FAtlasSize);
    FillChar(LAtlasData[0], Length(LAtlasData), 0);

    // Generate SDF data for each glyph
    FGlyph.Clear();
    LCurrentX := SDF_PADDING;
    LCurrentY := SDF_PADDING;
    LRowHeight := 0;

    for LI := 0 to LNumOfGlyphs - 1 do
    begin
      // Special handling for space character (ASCII 32)
      if LCodePoints[LI] = 32 then
      begin
        stbtt_GetCodepointHMetrics(@LFontInfo, 32, @LAdvanceWidth, @LLeftSideBearing);

        // Create a space glyph entry with zero-size rect but proper advance
        LGlyph.SrcRect.pos.x := 0;
        LGlyph.SrcRect.pos.y := 0;
        LGlyph.SrcRect.size.Width := 0;
        LGlyph.SrcRect.size.Height := 0;

        LGlyph.DstRect.pos.x := 0;
        LGlyph.DstRect.pos.y := 0;
        LGlyph.DstRect.size.Width := 0;
        LGlyph.DstRect.size.Height := 0;

        LGlyph.XAdvance := LAdvanceWidth * LScale;
        LGlyph.YOffset := FBaseline;

        FGlyph.Add(32, LGlyph);
        Continue;
      end;

      LGlyphIndex := stbtt_FindGlyphIndex(@LFontInfo, LCodePoints[LI]);
      if LGlyphIndex = 0 then Continue; // Skip missing glyphs (but not spaces)

      stbtt_GetGlyphHMetrics(@LFontInfo, LGlyphIndex, @LAdvanceWidth, @LLeftSideBearing);
      stbtt_GetGlyphBox(@LFontInfo, LGlyphIndex, @LX0, @LY0, @LX1, @LY1);

      // Validate glyph box coordinates
      if (LX1 <= LX0) or (LY1 <= LY0) or (LX1 - LX0 > 10000) or (LY1 - LY0 > 10000) then
        Continue; // Skip invalid glyph boxes

      LGlyphWidth := Round((LX1 - LX0) * LScale) + 2 * SDF_PADDING;
      LGlyphHeight := Round((LY1 - LY0) * LScale) + 2 * SDF_PADDING;

      if LCurrentX + LGlyphWidth + SDF_PADDING > FAtlasSize then
      begin
        LCurrentX := SDF_PADDING;
        LCurrentY := LCurrentY + LRowHeight + SDF_PADDING;
        LRowHeight := 0;
      end;

      // Generate SDF for this glyph
      LGlyphSDFData := stbtt_GetGlyphSDF(@LFontInfo, LScale, LGlyphIndex, SDF_PADDING,
                                        SDF_ONEDGE_VALUE, SDF_PIXEL_DIST_SCALE,
                                        @LGlyphWidth, @LGlyphHeight, @LX0, @LY0);

      if Assigned(LGlyphSDFData) then
      begin
        // Copy SDF data to atlas
        for LY := 0 to LGlyphHeight - 1 do
        begin
          for LX := 0 to LGlyphWidth - 1 do
          begin
            LAtlasX := LCurrentX + LX;
            LAtlasY := LCurrentY + LY;
            if (LAtlasX < FAtlasSize) and (LAtlasY < FAtlasSize) then
            begin
              LAtlasData[LAtlasY * FAtlasSize + LAtlasX] := PByte(LGlyphSDFData + LY * LGlyphWidth + LX)^;
            end;
          end;
        end;

        // Store glyph metrics
        LGlyph.SrcRect.pos.x := LCurrentX;
        LGlyph.SrcRect.pos.y := LCurrentY;
        LGlyph.SrcRect.size.Width := LGlyphWidth;
        LGlyph.SrcRect.size.Height := LGlyphHeight;

        LGlyph.DstRect.pos.x := LX0 * LScale - SDF_PADDING;
        LGlyph.DstRect.pos.y := -LY1 * LScale - SDF_PADDING;
        LGlyph.DstRect.size.Width := LGlyphWidth;
        LGlyph.DstRect.size.Height := LGlyphHeight;

        LGlyph.XAdvance := LAdvanceWidth * LScale;
        LGlyph.YOffset := FBaseline;

        FGlyph.Add(LCodePoints[LI], LGlyph);

        stbtt_FreeSDF(LGlyphSDFData, nil);
      end;

      LCurrentX := LCurrentX + LGlyphWidth + SDF_PADDING;
      if LGlyphHeight > LRowHeight then
        LRowHeight := LGlyphHeight;
    end;

    // Create texture from atlas data
    FAtlas := Tg2dTexture.Create();
    FAtlas.Load(@LAtlasData[0], FAtlasSize, FAtlasSize);
    FAtlas.SetPivot(0, 0);
    FAtlas.SetAnchor(0, 0);
    FAtlas.SetBlend(tbAlpha);
    FAtlas.SetColor(G2D_WHITE);

    // Initialize shader
    InitializeShader();

    if AOwnIO then
    begin
      LIO.Free();
    end;

    Result := True;

  finally
    LBuffer.Free();
  end;
end;

function Tg2dFont.LoadFromFile(const AWindow: Tg2dWindow; const AFilename: string; const ASize: Cardinal; const AGlyphs: string): Boolean;
var
  LIO: Tg2dFileIO;
begin
  Result := False;
  LIO := Tg2dFileIO.Create();
  try
    if not LIO.Open(AFilename, iomRead) then Exit;
    Result := Load(AWindow, LIO, ASize, AGlyphs, False);
  finally
    LIO.Free();
  end;
end;

function Tg2dFont.LoadFromZipFile(const AWindow: Tg2dWindow; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string; const APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
begin
  Result := False;

  LIO := Tg2dZipFileIO.Create();
  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := Load(AWindow, LIO, ASize, AGlyphs, True);
end;

procedure Tg2dFont.Unload();
begin
  if Assigned(FAtlas) then
  begin
    FAtlas.Free();
    FAtlas := nil;
  end;

  if Assigned(FShader) then
  begin
    FShader.Free();
    FShader := nil;
  end;

  FGlyph.Clear();
end;

procedure Tg2dFont.DrawText(const AWindow: Tg2dWindow; const AX, AY: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string);
var
  LText: string;
  LChar: Integer;
  LGlyph: TGlyph;
  LI: Integer;
  LLen: Integer;
  LX: Single;
  LY: Single;
  LWidth: Single;
  LScaledX: Single;
  LScaledY: Single;
  LScaledWidth: Single;
  LScaledHeight: Single;
  LScaledAdvance: Single;
begin
  if not Assigned(FAtlas) or not Assigned(FShader) then Exit;

  LText := AText;
  LLen := LText.Length;

  LX := AX;
  LY := AY;

  case AHAlign of
    haLeft:
      begin
        // LX is already AX - no change needed
      end;
    haCenter:
      begin
        LWidth := TextLength(AText, AScale);
        LX := AX - (LWidth / 2);  // Center around the provided position
      end;
    haRight:
      begin
        LWidth := TextLength(AText, AScale);
        LX := AX - LWidth;        // End at the provided position
      end;
  end;

  // Enable SDF shader and set uniforms
  SetShaderUniforms();

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, FAtlas.GetHandle());

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  // Set color for fixed pipeline
  glColor4f(AColor.Red, AColor.Green, AColor.Blue, AColor.Alpha);

  for LI := 1 to LLen do
  begin
    LChar := Integer(Char(LText[LI]));
    if FGlyph.TryGetValue(LChar, LGlyph) then
    begin
      // Only render if glyph has actual visual content (not spaces)
      if (LGlyph.SrcRect.size.Width > 0) and (LGlyph.SrcRect.size.Height > 0) then
      begin
        // Apply scale to glyph dimensions and position
        LScaledX := LX + (LGlyph.DstRect.pos.x * AScale);
        LScaledY := LY + (LGlyph.DstRect.pos.y * AScale) + (LGlyph.YOffset * AScale);
        LScaledWidth := LGlyph.DstRect.size.Width * AScale;
        LScaledHeight := LGlyph.DstRect.size.Height * AScale;

        glBegin(GL_QUADS);
          glTexCoord2f(LGlyph.SrcRect.pos.x / FAtlasSize, LGlyph.SrcRect.pos.y / FAtlasSize);
          glVertex2f(LScaledX, LScaledY);

          glTexCoord2f((LGlyph.SrcRect.pos.x + LGlyph.SrcRect.size.Width) / FAtlasSize, LGlyph.SrcRect.pos.y / FAtlasSize);
          glVertex2f(LScaledX + LScaledWidth, LScaledY);

          glTexCoord2f((LGlyph.SrcRect.pos.x + LGlyph.SrcRect.size.Width) / FAtlasSize, (LGlyph.SrcRect.pos.y + LGlyph.SrcRect.size.Height) / FAtlasSize);
          glVertex2f(LScaledX + LScaledWidth, LScaledY + LScaledHeight);

          glTexCoord2f(LGlyph.SrcRect.pos.x / FAtlasSize, (LGlyph.SrcRect.pos.y + LGlyph.SrcRect.size.Height) / FAtlasSize);
          glVertex2f(LScaledX, LScaledY + LScaledHeight);
        glEnd();
      end;

      // Always advance cursor, even for spaces (which have zero visual size)
      LScaledAdvance := LGlyph.XAdvance * AScale;
      LX := LX + LScaledAdvance;
    end;
  end;

  glBindTexture(GL_TEXTURE_2D, 0);
  glDisable(GL_TEXTURE_2D);
  FShader.Enable(False);
end;

procedure Tg2dFont.DrawText(const AWindow: Tg2dWindow; const AX: Single; var AY: Single; const ALineSpace: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string);
begin
  DrawText(AWindow, AX, AY, AScale, AColor, AHAlign, AText);
  AY := AY + (FLineHeight * AScale) + ALineSpace;
end;

procedure Tg2dFont.DrawText(const AWindow: Tg2dWindow; const AX, AY: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string; const AArgs: array of const);
begin
  DrawText(AWindow, AX, AY, AScale, AColor, AHAlign, Format(AText, AArgs));
end;

procedure Tg2dFont.DrawText(const AWindow: Tg2dWindow; const AX: Single; var AY: Single; const ALineSpace: Single; const AScale: Single; const AColor: Tg2dColor; const AHAlign: Tg2dHAlign; const AText: string; const AArgs: array of const);
begin
  DrawText(AWindow, AX, AY, ALineSpace, AScale, AColor, AHAlign, Format(AText, AArgs));
end;

function Tg2dFont.TextLength(const AText: string; const AScale: Single): Single;
var
  LText: string;
  LChar: Integer;
  LGlyph: TGlyph;
  LI: Integer;
  LLen: Integer;
  LWidth: Single;
begin
  Result := 0;
  if not Assigned(FAtlas) then Exit;

  LText := AText;
  LLen := LText.Length;
  LWidth := 0;

  for LI := 1 to LLen do
  begin
    LChar := Integer(Char(LText[LI]));
    if FGlyph.TryGetValue(LChar, LGlyph) then
    begin
      LWidth := LWidth + (LGlyph.XAdvance * AScale);
    end;
  end;

  Result := LWidth;
end;

function Tg2dFont.TextLength(const AText: string; const AScale: Single; const AArgs: array of const): Single;
begin
  Result := TextLength(Format(AText, AArgs), AScale);
end;

function Tg2dFont.TextHeight(const AScale: Single): Single;
begin
  Result := 0;
  if not Assigned(FAtlas) then Exit;
  Result := FBaseLine * AScale;
end;

function Tg2dFont.LineHeight(const AScale: Single): Single;
begin
  Result := 0;
  if not Assigned(FAtlas) then Exit;
  Result := FLineHeight * AScale;
end;

function Tg2dFont.SaveTexture(const AFilename: string): Boolean;
begin
  Result := False;
  if not Assigned(FAtlas) then Exit;
  if AFilename.IsEmpty then Exit;
  Result := FAtlas.Save(AFilename);
end;

function Tg2dFont.GetLogicalScale(const ADesiredSize: Single): Single;
begin
  if FGeneratedSize > 0 then
    Result := ADesiredSize / FGeneratedSize  // No DPI scaling here!
  else
    Result := 1.0;
end;

function Tg2dFont.GetPhysicalScale(const ADesiredPixelSize: Single): Single;
begin
  if FGeneratedSize > 0 then
    Result := (ADesiredPixelSize / FDpiScale) / FGeneratedSize
  else
    Result := 1.0;
end;

class function Tg2dFont.Init(const AWindow: Tg2dWindow; const ASize: Cardinal; const AGlyphs: string): Tg2dFont;
begin
  Result := Tg2dFont.Create();
  if not Result.Load(AWindow, ASize, AGlyphs) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

class function Tg2dFont.Init(const AWindow: Tg2dWindow; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string; const APassword: string): Tg2dFont;
begin
  Result := Tg2dFont.Create();
  if not Result.LoadFromZipFile(AWindow, AZipFilename, AFilename, ASize, AGlyphs, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

//=== CAMERA ===================================================================
{ Tg2dCamera }
constructor Tg2dCamera.Create();
begin
  inherited;
  FPosition.Assign(0, 0);
  FTarget.Assign(0, 0);
  FZoom := 1.0;
  FAngle := 0.0;
  FOrigin.Assign(0, 0);
  FBounds.Create(-MaxSingle, -MaxSingle, MaxSingle, MaxSingle);
  FShakeTime := 0.0;
  FShakeStrength := 0.0;
  FShakeOffset.Assign(0, 0);
  FFollowLerp := 0.0;
  FIsShaking := False;
  FLogicalSize.Create(1280, 720);
  FTransformActive := False;
end;

destructor Tg2dCamera.Destroy();
begin
  if FTransformActive then
    EndTransform();
  inherited;
end;

procedure Tg2dCamera.ClampToBounds();
var
  LHalfWidth: Single;
  LHalfHeight: Single;
begin
  LHalfWidth := (FLogicalSize.Width / 2) / FZoom;
  LHalfHeight := (FLogicalSize.Height / 2) / FZoom;

  if FPosition.X - LHalfWidth < FBounds.MinX then
    FPosition.X := FBounds.MinX + LHalfWidth;
  if FPosition.X + LHalfWidth > FBounds.MaxX then
    FPosition.X := FBounds.MaxX - LHalfWidth;

  if FPosition.Y - LHalfHeight < FBounds.MinY then
    FPosition.Y := FBounds.MinY + LHalfHeight;
  if FPosition.Y + LHalfHeight > FBounds.MaxY then
    FPosition.Y := FBounds.MaxY - LHalfHeight;
end;

procedure Tg2dCamera.UpdateShake(const ADelta: Single);
begin
  if FIsShaking then
  begin
    FShakeTime := FShakeTime - ADelta;
    if FShakeTime <= 0 then
    begin
      FIsShaking := False;
      FShakeOffset.Assign(0, 0);
    end
    else
    begin
      FShakeOffset.X := Tg2dMath.RandomRangeFloat(-FShakeStrength, FShakeStrength);
      FShakeOffset.Y := Tg2dMath.RandomRangeFloat(-FShakeStrength, FShakeStrength);
    end;
  end;
end;

function Tg2dCamera.GetPosition(): Tg2dVec;
begin
  Result := FPosition;
end;

procedure Tg2dCamera.SetPosition(const AX, AY: Single);
begin
  FPosition.Assign(AX, AY);
  FTarget.Assign(AX, AY);
  ClampToBounds();
end;

function Tg2dCamera.GetOrigin(): Tg2dVec;
begin
  Result := FOrigin;
end;

procedure Tg2dCamera.SetOrigin(const AX, AY: Single);
begin
  FOrigin.Assign(EnsureRange(AX, 0.0, 1.0), EnsureRange(AY, 0.0, 1.0));
end;

function Tg2dCamera.GetBounds(): Tg2dRange;
begin
  Result := FBounds;
end;

procedure Tg2dCamera.SetBounds(const AMinX, AMinY, AMaxX, AMaxY: Single);
begin
  FBounds.Create(AMinX, AMinY, AMaxX, AMaxY);
  ClampToBounds();
end;

function Tg2dCamera.GetLogicalSize(): Tg2dSize;
begin
  Result := FLogicalSize;
end;

procedure Tg2dCamera.SetLogicalSize(const AWidth, AHeight: Single);
begin
  FLogicalSize.Create(AWidth, AHeight);
end;

function Tg2dCamera.GetZoom(): Single;
begin
  Result := FZoom;
end;

procedure Tg2dCamera.SetZoom(const AZoom: Single);
begin
  FZoom := EnsureRange(AZoom, 0.05, 100.0);
  ClampToBounds();
end;

function Tg2dCamera.GetAngle(): Single;
begin
  Result := FAngle;
end;

procedure Tg2dCamera.SetAngle(const AAngle: Single);
var
  LAngle: Single;
begin
  LAngle := AAngle;
  Tg2dMath.ClipValueFloat(LAngle, 0, 360, True);
  FAngle := LAngle;
end;

function Tg2dCamera.GetViewRect(): Tg2dRect;
var
  LHalfWidth: Single;
  LHalfHeight: Single;
begin
  LHalfWidth := (FLogicalSize.Width / 2) / FZoom;
  LHalfHeight := (FLogicalSize.Height / 2) / FZoom;

  Result.Create(
    FPosition.X - LHalfWidth,
    FPosition.Y - LHalfHeight,
    LHalfWidth * 2,
    LHalfHeight * 2
  );
end;

procedure Tg2dCamera.LookAt(const ATarget: Tg2dVec; const ALerpSpeed: Single);
begin
  FTarget.Assign(ATarget);
  FFollowLerp := EnsureRange(ALerpSpeed, 0.0, 1.0);
end;

procedure Tg2dCamera.Update(const ADelta: Single);
begin
  if FFollowLerp > 0 then
  begin
    FPosition.X := Tg2dMath.Lerp(FPosition.X, FTarget.X, FFollowLerp);
    FPosition.Y := Tg2dMath.Lerp(FPosition.Y, FTarget.Y, FFollowLerp);
    ClampToBounds();
  end;

  UpdateShake(ADelta);
end;

function Tg2dCamera.IsShaking(): Boolean;
begin
  Result := FIsShaking;
end;

procedure Tg2dCamera.ShakeCamera(const ADuration, AStrength: Single);
begin
  FShakeTime := ADuration;
  FShakeStrength := AStrength;
  FIsShaking := True;
end;

procedure Tg2dCamera.BeginTransform();
var
  LCameraX: Single;
  LCameraY: Single;
  LOriginX: Single;
  LOriginY: Single;
begin
  if FTransformActive then Exit;

  glGetFloatv(GL_PROJECTION_MATRIX, @FSavedProjectionMatrix[0]);
  glGetFloatv(GL_MODELVIEW_MATRIX, @FSavedModelviewMatrix[0]);

  LCameraX := FPosition.X + FShakeOffset.X;
  LCameraY := FPosition.Y + FShakeOffset.Y;

  LOriginX := FOrigin.X * FLogicalSize.Width;
  LOriginY := FOrigin.Y * FLogicalSize.Height;

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glTranslatef(LOriginX, LOriginY, 0);
  glScalef(FZoom, FZoom, 1);
  glRotatef(FAngle, 0, 0, 1);
  glTranslatef(-LCameraX, -LCameraY, 0);

  FTransformActive := True;
end;

procedure Tg2dCamera.EndTransform();
begin
  if not FTransformActive then Exit;

  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@FSavedProjectionMatrix[0]);
  glMatrixMode(GL_MODELVIEW);
  glLoadMatrixf(@FSavedModelviewMatrix[0]);

  FTransformActive := False;
end;

function Tg2dCamera.WorldToScreen(const APosition: Tg2dVec): Tg2dVec;
var
  LRelativeX: Single;
  LRelativeY: Single;
  LCameraX: Single;
  LCameraY: Single;
  LCos: Single;
  LSin: Single;
  LRotatedX: Single;
  LRotatedY: Single;
  LScreenX: Single;
  LScreenY: Single;
begin
  LCameraX := FPosition.X + FShakeOffset.X;
  LCameraY := FPosition.Y + FShakeOffset.Y;

  LRelativeX := APosition.X - LCameraX;
  LRelativeY := APosition.Y - LCameraY;

  if FAngle <> 0 then
  begin
    LCos := Tg2dMath.AngleCos(Round(FAngle));
    LSin := Tg2dMath.AngleSin(Round(FAngle));
    LRotatedX := LRelativeX * LCos - LRelativeY * LSin;
    LRotatedY := LRelativeX * LSin + LRelativeY * LCos;
  end
  else
  begin
    LRotatedX := LRelativeX;
    LRotatedY := LRelativeY;
  end;

  LScreenX := (LRotatedX * FZoom) + (FOrigin.X * FLogicalSize.Width);
  LScreenY := (LRotatedY * FZoom) + (FOrigin.Y * FLogicalSize.Height);

  Result.Assign(LScreenX, LScreenY);
end;

function Tg2dCamera.ScreenToWorld(const APosition: Tg2dVec): Tg2dVec;
var
  LRelativeX: Single;
  LRelativeY: Single;
  LCameraX: Single;
  LCameraY: Single;
  LCos: Single;
  LSin: Single;
  LRotatedX: Single;
  LRotatedY: Single;
  LWorldX: Single;
  LWorldY: Single;
  LInverseAngle: Integer;
begin
  LCameraX := FPosition.X + FShakeOffset.X;
  LCameraY := FPosition.Y + FShakeOffset.Y;

  LRelativeX := (APosition.X - (FOrigin.X * FLogicalSize.Width)) / FZoom;
  LRelativeY := (APosition.Y - (FOrigin.Y * FLogicalSize.Height)) / FZoom;

  if FAngle <> 0 then
  begin
    LInverseAngle := Round(-FAngle);
    Tg2dMath.ClipValueInt(LInverseAngle, 0, 360, True);
    LCos := Tg2dMath.AngleCos(LInverseAngle);
    LSin := Tg2dMath.AngleSin(LInverseAngle);
    LRotatedX := LRelativeX * LCos - LRelativeY * LSin;
    LRotatedY := LRelativeX * LSin + LRelativeY * LCos;
  end
  else
  begin
    LRotatedX := LRelativeX;
    LRotatedY := LRelativeY;
  end;

  LWorldX := LRotatedX + LCameraX;
  LWorldY := LRotatedY + LCameraY;

  Result.Assign(LWorldX, LWorldY);
end;

procedure Tg2dCamera.MoveRelative(const AX, AY: Single);
var
  LCos: Single;
  LSin: Single;
  LNewX: Single;
  LNewY: Single;
begin
  if (AX = 0) and (AY = 0) then Exit;

  LCos := Tg2dMath.AngleCos(Round(FAngle));
  LSin := Tg2dMath.AngleSin(Round(FAngle));

  LNewX := AX * LCos - AY * LSin;
  LNewY := AX * LSin + AY * LCos;

  FPosition.X := FPosition.X + LNewX;
  FPosition.Y := FPosition.Y + LNewY;
  FTarget.Assign(FPosition);

  ClampToBounds();
end;

procedure Tg2dCamera.MoveForward(const ADistance: Single);
begin
  MoveRelative(0, ADistance);
end;

procedure Tg2dCamera.MoveBackward(const ADistance: Single);
begin
  MoveRelative(0, -ADistance);
end;

procedure Tg2dCamera.MoveLeft(const ADistance: Single);
begin
  MoveRelative(-ADistance, 0);
end;

procedure Tg2dCamera.MoveRight(const ADistance: Single);
begin
  MoveRelative(ADistance, 0);
end;

class function Tg2dCamera.Init(): Tg2dCamera;
begin
  Result := Tg2dCamera.Create();
end;

//=== AUDIO ====================================================================
{ TMaVPS }
function TMaVFS_OnOpen(AVFS: Pma_vfs; const AFilename: PUTF8Char; AOpenMode: ma_uint32; AFile: Pma_vfs_file): ma_result; cdecl;
var
  LIO: Tg2dIO;
begin
  Result := MA_ERROR;
  LIO :=  Tg2dAudio.PMaVFS(AVFS).IO;
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen() then Exit;
  AFile^ := LIO;
  Result := MA_SUCCESS;
end;

function TMaVFS_OnOpenW(AVFS: Pma_vfs; const AFilename: PWideChar; AOpenMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
begin
  Result := MA_ERROR;
end;

function TMaVFS_OnClose(AVFS: Pma_vfs; file_: ma_vfs_file): ma_result; cdecl;
var
  LIO: Tg2dIO;
begin
  Result := MA_ERROR;
  LIO := Tg2dIO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LIO.Free();
  Result := MA_SUCCESS;
end;

function TMaVFS_OnRead(AVFS: Pma_vfs; file_: ma_vfs_file; AData: Pointer; ASizeInBytes: NativeUInt; ABytesRead: PNativeUInt): ma_result; cdecl;
var
  LIO: Tg2dIO;
  LResult: Int64;
begin
  Result := MA_ERROR;
  LIO := Tg2dIO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LResult := LIO.Read(AData, ASizeInBytes);
  if LResult < 0 then Exit;
  ABytesRead^ := LResult;
  Result := MA_SUCCESS;
end;

function TMaVFS_OnWrite(AVFS: Pma_vfs; AVFSFile: ma_vfs_file; const AData: Pointer; ASizeInBytes: NativeUInt; ABytesWritten: PNativeUInt): ma_result; cdecl;
begin
  Result := MA_ERROR;
end;

function TMaVFS_OnSeek(AVFS: Pma_vfs; file_: ma_vfs_file; AOffset: ma_int64;
  AOrigin: ma_seek_origin): ma_result; cdecl;
var
  LIO: Tg2dIO;
begin
  Result := MA_ERROR;
  LIO := Tg2dIO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LIO.Seek(AOffset, Tg2dSeekMode(AOrigin));
  Result := MA_SUCCESS;
end;

function TMaVFS_OnTell(AVFS: Pma_vfs; file_: ma_vfs_file; ACursor: Pma_int64): ma_result; cdecl;
var
  LIO: Tg2dIO;
begin
  Result := MA_ERROR;
  LIO := Tg2dIO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  ACursor^ := LIO.Pos();
  Result := MA_SUCCESS;
end;

function TMaVFS_OnInfo(AVFS: Pma_vfs; AVFSFile: ma_vfs_file; AInfo: Pma_file_info): ma_result; cdecl;
var
  LIO: Tg2dIO;
  LResult: Int64;
begin
  Result := MA_ERROR;
  LIO := Tg2dIO(AVFSFile);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;

  LResult := LIO.Size;
  if LResult < 0 then Exit;

  AInfo.sizeInBytes := LResult;
  Result := MA_SUCCESS;
end;

constructor Tg2dAudio.TMaVFS.Create(const AIO: Tg2dIO);
begin
  Self := Default(TMaVFS);
  Callbacks.onopen := TMaVFS_OnOpen;
  Callbacks.onOpenW := TMaVFS_OnOpenW;
  Callbacks.onRead := TMaVFS_OnRead;
  Callbacks.onWrite := TMaVFS_OnWrite;
  Callbacks.onclose := TMaVFS_OnClose;
  Callbacks.onread := TMaVFS_OnRead;
  Callbacks.onseek := TMaVFS_OnSeek;
  Callbacks.onTell := TMaVFS_OnTell;
  Callbacks.onInfo := TMaVFS_OnInfo;
  IO := AIO;
end;

class function Tg2dAudio.FindFreeSoundSlot(): Integer;
var
  I: Integer;
begin
  Result := G2D_AUDIO_ERROR;
  for I := 0 to G2D_AUDIO_SOUND_COUNT-1 do
  begin
    if not FSound[I].InUse then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

class function Tg2dAudio.FindFreeChannelSlot(): Integer;
var
  I: Integer;
begin
  Result := G2D_AUDIO_ERROR;
  for I := 0 to G2D_AUDIO_SOUND_COUNT-1 do
  begin
    if (not FChannel[I].InUse) and (not FChannel[I].Reserved) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

class function Tg2dAudio.ValidChannel(const AChannel: Integer): Boolean;
begin
  Result := False;
  if not InRange(AChannel, 0, G2D_AUDIO_CHANNEL_COUNT-1) then Exit;
  if not FChannel[AChannel].InUse then Exit;
  Result := True;
end;

class constructor Tg2dAudio.Create();
begin
  inherited;
end;

class destructor Tg2dAudio.Destroy();
begin
  Close();
  inherited;
end;

class function  Tg2dAudio.Open(): Boolean;
begin
  Result := False;
  if IsOpen() then Exit;

  FVFS := TMaVFS.Create(nil);
  FEngineConfig := ma_engine_config_init;
  FEngineConfig.pResourceManagerVFS := @FVFS;
  if ma_engine_init(@FEngineConfig, @FEngine) <> MA_SUCCESS then Exit;

  FOpened := True;
  Result := IsOpen();
end;

class procedure Tg2dAudio.Close();
begin
  if not IsOpen() then Exit;
  UnloadMusic();
  UnloadAllSounds();
  ma_engine_uninit(@FEngine);
  InitData;
end;

class function Tg2dAudio.IsOpen(): Boolean;
begin
  Result := FOpened;
end;

class procedure Tg2dAudio.InitData();
var
  I: Integer;
begin
  FEngine := Default(ma_engine);

  for I := Low(FSound) to High(FSound) do
    FSound[I] := Default(TSound);

  for I := Low(FChannel) to High(FChannel) do
    FChannel[i] := Default(TChannel);

  FOpened := False;
  FPaused := False;
end;

class procedure Tg2dAudio.Update();
var
  I: Integer;
begin
  if not IsOpen() then Exit;

  // check channels
  for I := 0 to G2D_AUDIO_CHANNEL_COUNT-1 do
  begin
    if FChannel[I].InUse then
    begin
      if ma_sound_is_playing(@FChannel[I].Handle) = MA_FALSE then
      begin
        ma_sound_uninit(@FChannel[I].Handle);
        FChannel[I].InUse := False;
      end;
    end;
  end;
end;

class function  Tg2dAudio.IsPaused(): Boolean;
begin
  Result := FPaused;
end;

class procedure Tg2dAudio.SetPause(const APause: Boolean);
begin
  if not IsOpen() then Exit;

  case aPause of
    True:
    begin
      if ma_engine_stop(@FEngine) = MA_SUCCESS then
        FPaused := aPause;
    end;

    False:
    begin
      if ma_engine_start(@FEngine) = MA_SUCCESS then
        FPaused := aPause;
    end;
  end;
end;

class function  Tg2dAudio.PlayMusic(const AIO: Tg2dIO; const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single): Boolean;
begin
  Result := FAlse;
  if not IsOpen then Exit;
  if not Assigned(AIO) then Exit;
  UnloadMusic();
  FVFS.IO := AIO;
  if ma_sound_init_from_file(@FEngine, Tg2dUtils.AsUtf8(AFilename, []), Ord(MA_SOUND_FLAG_STREAM), nil,
    nil, @FMusic.Handle) <> MA_SUCCESS then
  FVFS.IO := nil;
  ma_sound_start(@FMusic);
  FMusic.Loaded := True;
  SetMusicLooping(ALoop);
  SetMusicVolume(AVolume);
  SetMusicPan(APan);
end;

class function  Tg2dAudio.PlayMusicFromFile(const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single): Boolean;
var
  LIO: Tg2dFileIO;
begin
  Result := False;
  //if not IGet(IFileIO, LIO) then Exit;
  LIO := Tg2dFileIO.Create();
  if not LIO.Open(AFilename,iomRead) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := PlayMusic(LIO, AFilename, AVolume, ALoop, APan);
end;

class function  Tg2dAudio.PlayMusicFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single; const APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
begin
  Result := False;
  LIO := Tg2dZipFileIO.Create();

  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;
  Result := PlayMusic(LIO, AFilename, AVolume, ALoop, APan);
end;

class procedure Tg2dAudio.UnloadMusic();
begin
  if not IsOpen() then Exit;
  if not FMusic.Loaded then Exit;
  ma_sound_stop(@FMusic.Handle);
  ma_sound_uninit(@FMusic.Handle);
  FMusic.Loaded := False;
end;

class function  Tg2dAudio.IsMusicLooping(): Boolean;
begin
  Result := False;
  if not IsOpen() then Exit;
  Result := Boolean(ma_sound_is_looping(@FMusic.Handle));
end;

class procedure Tg2dAudio.SetMusicLooping(const ALoop: Boolean);
begin
  if not IsOpen() then Exit;
  ma_sound_set_looping(@FMusic.Handle, Ord(ALoop))
end;

class function  Tg2dAudio.MusicVolume(): Single;
begin
  Result := 0;
  if not IsOpen() then Exit;
  Result := FMusic.Volume;
end;

class procedure Tg2dAudio.SetMusicVolume(const AVolume: Single);
begin
  if not IsOpen() then Exit;
  FMusic.Volume := AVolume;
  ma_sound_set_volume(@FMusic.Handle, Tg2dUtils.LogarithmicVolume(AVolume));
end;

class function  Tg2dAudio.MusicPan(): Single;
begin
  Result := 0;
  if not IsOpen() then Exit;

  Result := ma_sound_get_pan(@FMusic.Handle);
end;

class procedure Tg2dAudio.SetMusicPan(const APan: Single);
begin
  if not IsOpen() then Exit;

  ma_sound_set_pan(@FMusic.Handle, EnsureRange(APan, -1, 1));
end;

class function  Tg2dAudio.LoadSound(const AIO: Tg2dIO; const AFilename: string): Integer;
var
  LResult: Integer;
begin
  Result := G2D_AUDIO_ERROR;
  if not FOpened then Exit;
  if FPaused then Exit;
  LResult := FindFreeSoundSlot;
  if LResult = G2D_AUDIO_ERROR then Exit;

  FVFS.IO := AIO;
  if ma_sound_init_from_file(@FEngine, Tg2dUtils.AsUtf8(AFilename, []), 0, nil, nil,
    @FSound[LResult].Handle) <> MA_SUCCESS then Exit;
  FVFS.IO := nil;
  FSound[LResult].InUse := True;
  Result := LResult;
end;

class function  Tg2dAudio.LoadSoundFromFile(const AFilename: string): Integer;
var
  LIO: Tg2dFileIO;
begin
  Result := -1;
  if not IsOpen() then Exit;

  LIO := Tg2dFileIO.Create();
  try
    if not LIO.Open(AFilename, iomRead) then Exit;
    Result := LoadSound(LIO, AFilename);
  finally
    LIO.Free();
  end;
end;

class function  Tg2dAudio.LoadSoundFromZipFile(const AZipFilename, AFilename: string; const APassword: string): Integer;
var
  LIO: Tg2dZipFileIO;
begin
  Result := -1;
  if not IsOpen() then Exit;

  LIO := Tg2dZipFileIO.Create();
  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := LoadSound(LIO, AFilename);
end;

class procedure Tg2dAudio.UnloadSound(var aSound: Integer);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aSound, 0, G2D_AUDIO_SOUND_COUNT-1) then Exit;
  ma_sound_uninit(@FSound[aSound].Handle);
  FSound[aSound].InUse := False;
  aSound := G2D_AUDIO_ERROR;
end;

class procedure Tg2dAudio.UnloadAllSounds();
var
  I: Integer;
begin
  if not IsOpen() then Exit;

  // close all channels
  for I := 0 to G2D_AUDIO_CHANNEL_COUNT-1 do
  begin
    if FChannel[I].InUse then
    begin
      ma_sound_stop(@FChannel[I].Handle);
      ma_sound_uninit(@FChannel[I].Handle);
    end;
  end;

  // close all sound buffers
  for I := 0 to G2D_AUDIO_SOUND_COUNT-1 do
  begin
    if FSound[I].InUse then
    begin
      ma_sound_uninit(@FSound[I].Handle);
    end;
  end;

end;

class function  Tg2dAudio.PlaySound(const aSound, aChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer;
var
  LResult: Integer;
begin
  Result := G2D_AUDIO_ERROR;

  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aSound, 0, G2D_AUDIO_SOUND_COUNT-1) then Exit;

  if aChannel = G2D_AUDIO_CHANNEL_DYNAMIC then
    LResult := FindFreeChannelSlot
  else
    begin
      LResult := aChannel;
      if not InRange(aChannel, 0, G2D_AUDIO_CHANNEL_COUNT-1) then Exit;
      StopChannel(LResult);
    end;
  if LResult = G2D_AUDIO_ERROR then Exit;
  if ma_sound_init_copy(@FEngine, @FSound[ASound].Handle, 0, nil,
    @FChannel[LResult].Handle) <> MA_SUCCESS then Exit;
  FChannel[LResult].InUse := True;

  SetChannelVolume(LResult, aVolume);
  SetChannelPosition(LResult, 0, 0);
  SetChannelLoop(LResult, aLoop);

  if ma_sound_start(@FChannel[LResult].Handle) <> MA_SUCCESS then
  begin
    StopChannel(LResult);
    LResult := G2D_AUDIO_ERROR;
  end;

  Result := LResult;
end;

class procedure Tg2dAudio.ReserveChannel(const aChannel: Integer; const aReserve: Boolean);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aChannel, 0, G2D_AUDIO_CHANNEL_COUNT-1) then Exit;
  FChannel[aChannel].Reserved := aReserve;
end;

class procedure Tg2dAudio.StopChannel(const aChannel: Integer);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_uninit(@FChannel[aChannel].Handle);
  FChannel[aChannel].InUse := False;
end;

class procedure Tg2dAudio.SetChannelVolume(const aChannel: Integer; const AVolume: Single);
var
  LVolume: Single;
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aVolume, 0, 1) then Exit;
  if not ValidChannel(aChannel) then Exit;

  FChannel[aChannel].Volume := aVolume;
  LVolume := Tg2dUtils.LogarithmicVolume(AVolume);
  ma_sound_set_volume(@FChannel[aChannel].Handle, LVolume);
end;

class function  Tg2dAudio.GetChannelVolume(const aChannel: Integer): Single;
begin
Result := 0;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;
  Result := FChannel[aChannel].Volume;
end;

class procedure Tg2dAudio.SetChannelPosition(const aChannel: Integer; const X, Y: Single);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_set_position(@FChannel[aChannel].Handle, X, 0, Y);
end;

class procedure Tg2dAudio.SetChannelLoop(const aChannel: Integer;
  const ALoop: Boolean);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_set_looping(@FChannel[aChannel].Handle, Ord(aLoop));
end;

class function  Tg2dAudio.GetchannelLoop(const aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  Result := Boolean(ma_sound_is_looping(@FChannel[aChannel].Handle));
end;

class function  Tg2dAudio.GetChannelPlaying(const aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  Result := Boolean(ma_sound_is_playing(@FChannel[aChannel].Handle));
end;

//=== VIDEO ====================================================================
procedure Tg2dVideo_MADataCallback(ADevice: Pma_device; AOutput: Pointer; AInput: Pointer; AFrameCount: ma_uint32); cdecl;
var
  LReadPtr: PSingle;
  LFramesNeeded: Integer;
begin
  LFramesNeeded := AFrameCount * 2;
  LReadPtr := PSingle(Tg2dVideo.FRingBuffer.DirectReadPointer(LFramesNeeded));

  if Tg2dVideo.FRingBuffer.AvailableBytes >= LFramesNeeded then
    begin
      Move(LReadPtr^, AOutput^, LFramesNeeded * SizeOf(Single));
    end
  else
    begin
      FillChar(AOutput^, LFramesNeeded * SizeOf(Single), 0);
    end;
end;

procedure Tg2dVideo_PLMAudioDecodeCallback(APLM: Pplm_t; ASamples: Pplm_samples_t; AUserData: Pointer); cdecl;
begin
  Tg2dVideo.FRingBuffer.Write(ASamples^.interleaved, ASamples^.count*2);
end;

procedure Tg2dVideo_PLMVideoDecodeCallback(APLM: Pplm_t; AFrame: Pplm_frame_t; AUserData: Pointer); cdecl;
begin
  // convert YUV to RGBA

  plm_frame_to_rgba(AFrame, @Tg2dVideo.FRGBABuffer[0], Round(Tg2dVideo.GetTexture().GetSize().Width*4));

  // update OGL texture
  glBindTexture(GL_TEXTURE_2D, Tg2dVideo.FTexture.GetHandle());
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, AFrame^.width, AFrame^.height, GL_RGBA, GL_UNSIGNED_BYTE, Tg2dVideo.FRGBABuffer);
end;

procedure Tg2dVideo_PLMLoadBufferCallback(ABuffer: pplm_buffer_t; AUserData: pointer); cdecl;
var
  LBytesRead: Int64;
begin
  // read data from inputstream
  LBytesRead := Tg2dVideo.FIO.Read(@Tg2dVideo.FStaticPlmBuffer[0], Tg2dVideo.BUFFERSIZE);

  // push LBytesRead to PLM buffer
  if LBytesRead > 0 then
    begin
      plm_buffer_write(aBuffer, @Tg2dVideo.FStaticPlmBuffer[0], LBytesRead);
    end
  else
    begin
      // set status to stopped
      Tg2dVideo.FStatus := vsStopped;
      Tg2dVideo.FStatusFlag := True;
    end;
end;

class procedure Tg2dVideo.OnStatusEvent();
begin
  if Assigned(FCallback.Handler) then
  begin
    FCallback.Handler(FStatus, FFilename, FCallback.UserData);
  end;
end;

class constructor Tg2dVideo.Create();
begin
  inherited;
end;

class destructor Tg2dVideo.Destroy();
begin
  Stop();

  inherited;
end;

class function  Tg2dVideo.GetStatusCallback(): Tg2dVideoStatusCallback;
begin
  Result := FCallback.Handler;
end;

class procedure Tg2dVideo.SetStatusCallback(const AHandler: Tg2dVideoStatusCallback; const AUserData: Pointer);
begin
  FCallback.Handler := AHandler;
  FCallback.UserData := AUserData;
end;

class function  Tg2dVideo.Play(const AIO: Tg2dIO;  const AFilename: string; const AVolume: Single; const ALoop: Boolean): Boolean;
var
  LBuffer: Pplm_buffer_t;
begin
  Result := False;

  Stop();

  // set volume & loop status
  FVolume := AVolume;
  FLoop := ALoop;

  // init ringbuffer
  FRingBuffer := Tg2dVirtualRingBuffer<Single>.Create(CSampleRate*2);
  if not Assigned(FRingBuffer) then Exit;

  // init device for audio playback
  FDeviceConfig := ma_device_config_init(ma_device_type_playback);
  FDeviceConfig.playback.format := ma_format_f32;
  FDeviceConfig.playback.channels := 2;
  FDeviceConfig.sampleRate := CSampleRate;
  FDeviceConfig.dataCallback := @Tg2dVideo_MADataCallback;
  if ma_device_init(nil, @FDeviceConfig, @FDevice) <> MA_SUCCESS then Exit;
  ma_device_start(@FDevice);
  SetVolume(AVolume);

  // set the input stream
  FIO := AIO;
  FFilename := AFilename;
  FStatus := vsPlaying;
  FStatusFlag := False;
  OnStatusEvent();

  // init plm buffer
  LBuffer := plm_buffer_create_with_capacity(BUFFERSIZE);
  if not Assigned(LBuffer) then
  begin
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  plm_buffer_set_load_callback(LBuffer, Tg2dVideo_PLMLoadBufferCallback, Tg2dVideo);
  FPLM := plm_create_with_buffer(LBuffer, 1);
  if not Assigned(FPLM) then
  begin
    plm_buffer_destroy(LBuffer);
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  // create video render texture
  FTexture := Tg2dTexture.Create;
  FTexture.SetBlend(tbNone);
  FTexture.Alloc(plm_get_width(FPLM), plm_get_height(FPLM), G2D_BLANK);

  // alloc the video rgba buffer
  SetLength(FRGBABuffer,
    Round(FTexture.GetSize.Width*FTexture.GetSize.Height*4));
  if not Assigned(FRGBABuffer) then
  begin
    plm_buffer_destroy(LBuffer);
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  // set the audio lead time
  plm_set_audio_lead_time(FPLM, (CSampleSize*2)/FDeviceConfig.sampleRate);

  // set audio/video callbacks
  plm_set_audio_decode_callback(FPLM, Tg2dVideo_PLMAudioDecodeCallback, Tg2dVideo);
  plm_set_video_decode_callback(FPLM, Tg2dVideo_PLMVideoDecodeCallback, Tg2dVideo);

  FTexture.SetPivot(0, 0);
  FTexture.SetAnchor(0, 0);
  FTexture.SetBlend(tbNone);

  // return OK
  Result := True;
end;

class function  Tg2dVideo.PlayFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
begin
  Result := False;

  LIO := Tg2dZipFileIO.Create();
  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := Play(LIO, AFilename, AVolume, ALoop);
end;

class procedure Tg2dVideo.Stop();
begin
  if not Assigned(FPLM) then Exit;

  ma_device_stop(@FDevice);
  ma_device_uninit(@FDevice);

  plm_destroy(FPLM);

  //FIO.Free;
  FIO.Free();
  FTexture.Free;
  FRingBuffer.Free;

  FPLM := nil;
  FRingBuffer := nil;
  FStatus := vsStopped;
  FTexture := nil;
end;

class function  Tg2dVideo.Update(const AWindow: Tg2dWindow): Boolean;
begin
  Result := False;
  if not Assigned(FPLM) then Exit;
  if FStatusFlag then
  begin
    FStatusFlag := False;
    OnStatusEvent();
  end;

  if FStatus = vsStopped then
  begin
    ma_device_stop(@FDevice);

    if FLoop then
    begin
      plm_rewind(FPLM);
      FIO.Seek(0, smStart);
      FRingBuffer.Clear;
      ma_device_start(@FDevice);
      SetVolume(FVolume);
      FStatus := vsPlaying;
      plm_decode(FPLM, AWindow.GetTargetTime());
      OnStatusEvent();
      Exit;
    end;
    Result := True;
    Exit;
  end;

  plm_decode(FPLM, AWindow.GetTargetTime());
end;

class procedure Tg2dVideo.Draw(const X, Y, AScale: Single);
begin
  //if FStatus <> vsPlaying then Exit;
  FTexture.SetPos(X, Y);
  FTexture.SetScale(AScale);
  FTexture.Draw();
end;

class function  Tg2dVideo.Status(): Tg2dVideoStatus;
begin
  Result := FStatus;
end;

class function  Tg2dVideo.Volume(): Single;
begin
  Result := FVolume;
end;

class procedure Tg2dVideo.SetVolume(const AVolume: Single);
begin
  FVolume := EnsureRange(AVolume, 0, 1);
  ma_device_set_master_volume(@FDevice, Tg2dUtils.LogarithmicVolume(FVolume));
end;

class function  Tg2dVideo.IsLooping(): Boolean;
begin
  Result := FLoop;
end;

class procedure Tg2dVideo.SetLooping(const ALoop: Boolean);
begin
  FLoop := ALoop;
end;

class function  Tg2dVideo.GetTexture(): Tg2dTexture;
begin
  Result := FTexture;
end;

//=== UNITINIT =================================================================
initialization
begin
  ReportMemoryLeaksOnShutdown := True;
  if glfwInit() <> GLFW_TRUE then
  begin
    Halt(1);
  end;
end;

finalization
begin
  glfwTerminate();
end;

end.



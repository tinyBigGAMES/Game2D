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
Game2D.Deps - External C Library Dependencies & Bindings

This unit provides Pascal bindings to essential C libraries used throughout the
Game2D framework. It serves as the foundation layer that exposes carefully
selected, battle-tested C libraries for graphics, audio, input, file I/O,
collision detection, networking, and database operations. All dependencies are
statically linked and require no external DLLs or installation.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════

The dependencies unit follows a clean separation pattern:

• **Function Pointer Declarations** - All C library functions exposed as Pascal procedure/function variables
• **Type Definitions** - Pascal equivalents of C structures and enums
• **Constants** - Enumeration values and configuration flags
• **Dynamic Loading** - Runtime binding via GetExports() procedure
• **No Implementation** - Pure interface unit with external C library calls

Key design principles:
• Zero-overhead bindings with direct C library access
• Static linking eliminates DLL dependencies
• Consistent Pascal naming conventions with C interoperability
• Type-safe interfaces preventing common C programming errors
• Comprehensive coverage of library functionality

═══════════════════════════════════════════════════════════════════════════════
C LIBRARY DEPENDENCIES SUMMARY
═══════════════════════════════════════════════════════════════════════════════

This unit provides bindings to the following proven C libraries:

• **GLFW 3.4** - Multi-platform windowing and input
  GitHub: https://github.com/glfw/glfw
  Purpose: Window creation, OpenGL context management, input handling

• **Dear ImGui** - Immediate mode GUI library
  GitHub: https://github.com/ocornut/imgui
  Purpose: Developer tools, debug interfaces, runtime UI

• **STB Libraries** - Single-header utility libraries
  GitHub: https://github.com/nothings/stb
  Purpose: Image loading (stb_image), font rendering (stb_truetype),
  rectangle packing (stb_rect_pack)

• **SQLite 3** - Embedded SQL database engine
  GitHub: https://github.com/sqlite/sqlite
  Purpose: Local data storage, configuration, game saves

• **miniaudio** - Cross-platform audio library
  GitHub: https://github.com/mackron/miniaudio
  Purpose: Audio playback, capture, mixing, effects

• **cute_headers (cute_c2)** - 2D collision detection
  GitHub: https://github.com/RandyGaul/cute_headers
  Purpose: Shape collision, raycasting, spatial queries

• **zlib/minizip** - Compression and archive support
  Purpose: Asset compression, save file compression

• **pl_mpeg** - MPEG1 video decoder
  Purpose: Video playback for cutscenes and backgrounds

═══════════════════════════════════════════════════════════════════════════════
WINDOWING & INPUT - GLFW
═══════════════════════════════════════════════════════════════════════════════

GLFW provides the foundation for window management and input handling:

• Cross-platform window creation and management
• OpenGL context creation and management
• Keyboard, mouse, and gamepad input
• Multi-monitor support with DPI awareness
• Event-driven callback system

BASIC WINDOW CREATION:
  var
    LWindow: PGLFWwindow;
  begin
    glfwInit();
    LWindow := glfwCreateWindow(800, 600, 'Game Title', nil, nil);
    glfwMakeContextCurrent(LWindow);

    while not glfwWindowShouldClose(LWindow) do
    begin
      glfwPollEvents();
      // Render here
      glfwSwapBuffers(LWindow);
    end;

    glfwTerminate();
  end;

INPUT HANDLING:
  procedure KeyCallback(AWindow: PGLFWwindow; AKey, AScancode, AAction, AMods: Integer); cdecl;
  begin
    if (AKey = GLFW_KEY_ESCAPE) and (AAction = GLFW_PRESS) then
      glfwSetWindowShouldClose(AWindow, GLFW_TRUE);
  end;

  // Set callback
  glfwSetKeyCallback(LWindow, @KeyCallback);

═══════════════════════════════════════════════════════════════════════════════
IMMEDIATE MODE GUI - DEAR IMGUI
═══════════════════════════════════════════════════════════════════════════════

Dear ImGui enables rapid development of debug tools and runtime interfaces:

• Immediate mode paradigm - no retained state
• Rich widget set with automatic layout
• Docking and multi-viewport support
• Custom rendering backend integration
• Extensive theming and styling options

BASIC IMGUI USAGE:
  begin
    igNewFrame();

    if igBegin('Debug Panel', nil, 0) then
    begin
      igText('FPS: %.1f', [1.0 / LDeltaTime]);
      igSliderFloat('Volume', @LVolume, 0.0, 1.0, '%.2f', 0);

      if igButton('Reset Game', ImVec2(0, 0)) then
        ResetGameState();
    end;
    igEnd();

    igRender();
    ImGui_ImplOpenGL2_RenderDrawData(igGetDrawData(), 800, 600);
  end;

CUSTOM WIDGETS:
  if igCollapsingHeader('Graphics Settings', 0) then
  begin
    igCheckbox('VSync', @LVSyncEnabled);
    igCombo('Quality', @LQualityIndex, 'Low'#0'Medium'#0'High'#0#0, 3);
    igColorEdit3('Clear Color', @LClearColor[0], 0);
  end;

═══════════════════════════════════════════════════════════════════════════════
IMAGE & FONT LOADING - STB LIBRARIES
═══════════════════════════════════════════════════════════════════════════════

STB libraries provide essential media loading capabilities:

• **stb_image** - Load PNG, JPG, TGA, BMP, PSD, GIF, HDR, PIC
• **stb_image_write** - Save PNG, JPG, TGA, BMP images
• **stb_truetype** - TTF/OTF font rasterization
• **stb_rect_pack** - Efficient rectangle packing for atlases

IMAGE LOADING EXAMPLE:
  var
    LWidth, LHeight, LChannels: Integer;
    LData: PByte;
  begin
    LData := stbi_load('texture.png', @LWidth, @LHeight, @LChannels, 4);
    if Assigned(LData) then
    begin
      // Create OpenGL texture from LData
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, LWidth, LHeight, 0,
                   GL_RGBA, GL_UNSIGNED_BYTE, LData);
      stbi_image_free(LData);
    end;
  end;

FONT RENDERING:
  var
    LFontBuffer: TBytes;
    LBakedChars: array[0..95] of stbtt_bakedchar;
    LBitmap: array[0..511, 0..511] of Byte;
  begin
    // Load font file to LFontBuffer
    stbtt_BakeFontBitmap(@LFontBuffer[0], 0, 16.0, @LBitmap[0], 512, 512,
                         32, 96, @LBakedChars[0]);
    // Upload LBitmap to texture and use LBakedChars for rendering
  end;

═══════════════════════════════════════════════════════════════════════════════
DATABASE OPERATIONS - SQLITE
═══════════════════════════════════════════════════════════════════════════════

SQLite provides robust local data storage with full SQL support:

• ACID-compliant transactions
• Complex queries with joins and indexes
• Prepared statements for performance
• Blob storage for binary data
• Full-text search capabilities

DATABASE OPERATIONS:
  var
    LDatabase: PSQLite3;
    LStatement: Psqlite3_stmt;
    LResult: Integer;
  begin
    LResult := sqlite3_open('game.db', @LDatabase);
    if LResult = SQLITE_OK then
    begin
      // Create table
      sqlite3_exec(LDatabase,
        'CREATE TABLE IF NOT EXISTS scores (id INTEGER PRIMARY KEY, ' +
        'player TEXT, score INTEGER, level INTEGER)', nil, nil, nil);

      // Insert data with prepared statement
      sqlite3_prepare_v2(LDatabase,
        'INSERT INTO scores (player, score, level) VALUES (?, ?, ?)',
        -1, @LStatement, nil);

      sqlite3_bind_text(LStatement, 1, 'Player1', -1, nil);
      sqlite3_bind_int(LStatement, 2, 1000);
      sqlite3_bind_int(LStatement, 3, 5);
      sqlite3_step(LStatement);
      sqlite3_finalize(LStatement);

      sqlite3_close(LDatabase);
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
AUDIO SYSTEM - MINIAUDIO
═══════════════════════════════════════════════════════════════════════════════

miniaudio provides comprehensive audio capabilities:

• Cross-platform audio playback and capture
• Multiple audio formats (WAV, FLAC, MP3, OGG)
• Real-time audio mixing and effects
• 3D spatial audio positioning
• Low-latency audio processing

AUDIO PLAYBACK:
  var
    LEngine: ma_engine;
    LSound: ma_sound;
  begin
    ma_engine_init(nil, @LEngine);

    // Load and play sound
    ma_sound_init_from_file(@LEngine, 'explosion.wav', 0, nil, nil, @LSound);
    ma_sound_start(@LSound);

    // Set volume and position
    ma_sound_set_volume(@LSound, 0.5);
    ma_sound_set_position(@LSound, 1.0, 0.0, 0.0); // Right channel

    // Cleanup
    ma_sound_uninit(@LSound);
    ma_engine_uninit(@LEngine);
  end;

REAL-TIME AUDIO GENERATION:
  procedure AudioCallback(const ADevice: Pma_device; AOutput: Pointer;
    const AInput: Pointer; AFrameCount: ma_uint32); cdecl;
  var
    LSampleIndex: ma_uint32;
    LFrequency: Single;
    LSample: Single;
  begin
    LFrequency := 440.0; // A4 note
    for LSampleIndex := 0 to AFrameCount - 1 do
    begin
      LSample := Sin(2.0 * Pi * LFrequency * LSampleIndex / 44100.0);
      PSingle(AOutput)[LSampleIndex] := LSample;
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
2D COLLISION DETECTION - CUTE_C2
═══════════════════════════════════════════════════════════════════════════════

cute_c2 provides fast 2D collision detection with multiple primitive types:

• Circles, AABBs, capsules, convex polygons
• Boolean collision tests and manifold generation
• Raycasting and shape sweeping
• GJK-based closest point queries
• Time-of-impact calculations

COLLISION DETECTION:
  var
    LCircle: c2Circle;
    LBox: c2AABB;
    LIsColliding: Integer;
    LManifold: c2Manifold;
  begin
    // Setup shapes
    LCircle.p := c2V(100.0, 100.0);
    LCircle.r := 25.0;

    LBox.min := c2V(80.0, 80.0);
    LBox.max := c2V(120.0, 120.0);

    // Check collision
    LIsColliding := c2CircletoAABB(LCircle, LBox);

    // Get detailed collision info
    c2CircletoAABBManifold(LCircle, LBox, @LManifold);
    if LManifold.count > 0 then
    begin
      // Access contact points and normal
      LContactPoint := LManifold.contact_points[0];
      LNormal := LManifold.n;
    end;
  end;

RAYCASTING:
  var
    LRay: c2Ray;
    LRaycast: c2Raycast;
    LHit: Integer;
  begin
    LRay.p := c2V(0.0, 0.0);    // Ray origin
    LRay.d := c2V(1.0, 0.0);    // Ray direction (normalized)
    LRay.t := 100.0;            // Ray length

    LHit := c2RaytoCircle(LRay, LCircle, @LRaycast);
    if LHit <> 0 then
    begin
      LHitPoint := c2Impact(LRay, LRaycast.t);
      LHitNormal := LRaycast.n;
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPRESSION & ARCHIVES - ZLIB/MINIZIP
═══════════════════════════════════════════════════════════════════════════════

Compression support for asset management and save files:

• DEFLATE compression algorithm
• ZIP archive reading and writing
• Streaming compression for large files
• Memory-based compression operations

COMPRESSION EXAMPLE:
  var
    LSource: TBytes;
    LCompressed: TBytes;
    LCompSize: uLong;
  begin
    // Compress data
    LCompSize := compressBound(Length(LSource));
    SetLength(LCompressed, LCompSize);

    if compress(@LCompressed[0], @LCompSize, @LSource[0], Length(LSource)) = Z_OK then
    begin
      SetLength(LCompressed, LCompSize);
      // Use compressed data
    end;
  end;

ZIP ARCHIVE ACCESS:
  var
    LZipFile: unzFile;
    LFileInfo: unz_file_info64;
    LBuffer: TBytes;
  begin
    LZipFile := unzOpen64('assets.zip');
    if Assigned(LZipFile) then
    begin
      if unzLocateFile(LZipFile, 'texture.png', 0) = UNZ_OK then
      begin
        unzGetCurrentFileInfo64(LZipFile, @LFileInfo, nil, 0, nil, 0, nil, 0);
        SetLength(LBuffer, LFileInfo.uncompressed_size);

        unzOpenCurrentFilePassword(LZipFile, nil);
        unzReadCurrentFile(LZipFile, @LBuffer[0], Length(LBuffer));
        unzCloseCurrentFile(LZipFile);
      end;
      unzClose(LZipFile);
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION EXAMPLES
═══════════════════════════════════════════════════════════════════════════════

GAME LOOP WITH MULTIPLE SYSTEMS:
  var
    LWindow: PGLFWwindow;
    LEngine: ma_engine;
    LDatabase: PSQLite3;
  begin
    // Initialize all systems
    glfwInit();
    LWindow := glfwCreateWindow(800, 600, 'Game2D Example', nil, nil);
    glfwMakeContextCurrent(LWindow);

    ma_engine_init(nil, @LEngine);
    sqlite3_open('game.db', @LDatabase);

    // Setup ImGui
    igCreateContext(nil);
    ImGui_ImplGlfw_InitForOpenGL(LWindow, True);
    ImGui_ImplOpenGL2_Init();

    // Main game loop
    while not glfwWindowShouldClose(LWindow) do
    begin
      glfwPollEvents();

      // Update game logic
      UpdateGameState();
      UpdatePhysics(); // Using cute_c2

      // Render frame
      glClear(GL_COLOR_BUFFER_BIT);
      RenderGame();

      // Render debug UI
      ImGui_ImplOpenGL2_NewFrame();
      ImGui_ImplGlfw_NewFrame();
      igNewFrame();
      RenderDebugUI();
      igRender();
      ImGui_ImplOpenGL2_RenderDrawData(igGetDrawData(), 800, 600);

      glfwSwapBuffers(LWindow);
    end;

    // Cleanup
    sqlite3_close(LDatabase);
    ma_engine_uninit(@LEngine);
    ImGui_ImplOpenGL2_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    igDestroyContext(nil);
    glfwTerminate();
  end;

═══════════════════════════════════════════════════════════════════════════════
LIBRARY INITIALIZATION
═══════════════════════════════════════════════════════════════════════════════

All function pointers must be loaded before use via the GetExports procedure:

INITIALIZATION PATTERN:
  procedure InitializeGame2D();
  var
    LDLLHandle: THandle;
  begin
    // Load the compiled C libraries DLL
    LDLLHandle := LoadLibrary('Game2DDeps.dll');
    if LDLLHandle = 0 then
      raise Exception.Create('Failed to load Game2D dependencies');

    // Bind all function pointers
    GetExports(LDLLHandle);

    // Now all library functions are available for use
    glfwInit();
    // ... other initialization
  end;

The GetExports procedure handles binding of all function pointers from:
• GLFW windowing functions
• ImGui interface functions
• STB image/font loading functions
• SQLite database functions
• miniaudio playback functions
• cute_c2 collision functions
• zlib compression functions

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════

• **Function Pointer Overhead** - Minimal impact compared to DLL calls
• **Memory Management** - C libraries require manual memory cleanup
• **Static Linking** - Larger executable but eliminates runtime dependencies
• **Initialization Cost** - One-time GetExports call at startup
• **Threading** - Most libraries are not thread-safe; use from main thread

MEMORY MANAGEMENT BEST PRACTICES:
  // Always free C library allocated memory
  LImageData := stbi_load('image.png', @LWidth, @LHeight, @LChannels, 4);
  try
    // Use image data
  finally
    stbi_image_free(LImageData); // Required!
  end;

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════

Most C libraries use different error reporting mechanisms:

• **GLFW** - Use glfwGetError() and error callbacks
• **SQLite** - Check return codes against SQLITE_OK
• **miniaudio** - Check ma_result return values
• **STB** - Check for nil pointer returns
• **cute_c2** - Boolean return values for collision tests

ERROR CHECKING PATTERN:
  var
    LResult: ma_result;
  begin
    LResult := ma_engine_init(nil, @LEngine);
    if LResult <> MA_SUCCESS then
      raise Exception.CreateFmt('Audio init failed: %d', [Integer(LResult)]);
  end;

===============================================================================}

unit Game2D.Deps;

{$I Game2D.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  WinApi.Winsock2,
  WinApi.Windows;

const
  RGFW_EXPORT = 1;
  PLM_NO_STDIO = 1;
  NK_INCLUDE_FIXED_TYPES = 1;
  NK_INCLUDE_STANDARD_IO = 1;
  NK_INCLUDE_STANDARD_VARARGS = 1;
  NK_INCLUDE_DEFAULT_ALLOCATOR = 1;
  NK_INCLUDE_VERTEX_BUFFER_OUTPUT = 1;
  NK_INCLUDE_FONT_BAKING = 1;
  NK_INCLUDE_DEFAULT_FONT = 1;
  GLFW_EXPOSE_NATIVE_WIN32 = 1;
  CIMGUI_DEFINE_ENUMS_AND_STRUCTS = 1;
  STDX_NETWORK_VERSION_MAJOR = 1;
  STDX_NETWORK_VERSION_MINOR = 0;
  STDX_NETWORK_VERSION_PATCH = 0;
  STDX_IO_VERSION = (STDX_NETWORK_VERSION_MAJOR*10000+STDX_NETWORK_VERSION_MINOR*100+STDX_NETWORK_VERSION_PATCH);
  GLFW_VERSION_MAJOR = 3;
  GLFW_VERSION_MINOR = 5;
  GLFW_VERSION_REVISION = 0;
  GLFW_TRUE = 1;
  GLFW_FALSE = 0;
  GLFW_RELEASE = 0;
  GLFW_PRESS = 1;
  GLFW_REPEAT = 2;
  GLFW_HAT_CENTERED = 0;
  GLFW_HAT_UP = 1;
  GLFW_HAT_RIGHT = 2;
  GLFW_HAT_DOWN = 4;
  GLFW_HAT_LEFT = 8;
  GLFW_HAT_RIGHT_UP = (GLFW_HAT_RIGHT or GLFW_HAT_UP);
  GLFW_HAT_RIGHT_DOWN = (GLFW_HAT_RIGHT or GLFW_HAT_DOWN);
  GLFW_HAT_LEFT_UP = (GLFW_HAT_LEFT or GLFW_HAT_UP);
  GLFW_HAT_LEFT_DOWN = (GLFW_HAT_LEFT or GLFW_HAT_DOWN);
  GLFW_KEY_UNKNOWN = -1;
  GLFW_KEY_SPACE = 32;
  GLFW_KEY_APOSTROPHE = 39;
  GLFW_KEY_COMMA = 44;
  GLFW_KEY_MINUS = 45;
  GLFW_KEY_PERIOD = 46;
  GLFW_KEY_SLASH = 47;
  GLFW_KEY_0 = 48;
  GLFW_KEY_1 = 49;
  GLFW_KEY_2 = 50;
  GLFW_KEY_3 = 51;
  GLFW_KEY_4 = 52;
  GLFW_KEY_5 = 53;
  GLFW_KEY_6 = 54;
  GLFW_KEY_7 = 55;
  GLFW_KEY_8 = 56;
  GLFW_KEY_9 = 57;
  GLFW_KEY_SEMICOLON = 59;
  GLFW_KEY_EQUAL = 61;
  GLFW_KEY_A = 65;
  GLFW_KEY_B = 66;
  GLFW_KEY_C = 67;
  GLFW_KEY_D = 68;
  GLFW_KEY_E = 69;
  GLFW_KEY_F = 70;
  GLFW_KEY_G = 71;
  GLFW_KEY_H = 72;
  GLFW_KEY_I = 73;
  GLFW_KEY_J = 74;
  GLFW_KEY_K = 75;
  GLFW_KEY_L = 76;
  GLFW_KEY_M = 77;
  GLFW_KEY_N = 78;
  GLFW_KEY_O = 79;
  GLFW_KEY_P = 80;
  GLFW_KEY_Q = 81;
  GLFW_KEY_R = 82;
  GLFW_KEY_S = 83;
  GLFW_KEY_T = 84;
  GLFW_KEY_U = 85;
  GLFW_KEY_V = 86;
  GLFW_KEY_W = 87;
  GLFW_KEY_X = 88;
  GLFW_KEY_Y = 89;
  GLFW_KEY_Z = 90;
  GLFW_KEY_LEFT_BRACKET = 91;
  GLFW_KEY_BACKSLASH = 92;
  GLFW_KEY_RIGHT_BRACKET = 93;
  GLFW_KEY_GRAVE_ACCENT = 96;
  GLFW_KEY_WORLD_1 = 161;
  GLFW_KEY_WORLD_2 = 162;
  GLFW_KEY_ESCAPE = 256;
  GLFW_KEY_ENTER = 257;
  GLFW_KEY_TAB = 258;
  GLFW_KEY_BACKSPACE = 259;
  GLFW_KEY_INSERT = 260;
  GLFW_KEY_DELETE = 261;
  GLFW_KEY_RIGHT = 262;
  GLFW_KEY_LEFT = 263;
  GLFW_KEY_DOWN = 264;
  GLFW_KEY_UP = 265;
  GLFW_KEY_PAGE_UP = 266;
  GLFW_KEY_PAGE_DOWN = 267;
  GLFW_KEY_HOME = 268;
  GLFW_KEY_END = 269;
  GLFW_KEY_CAPS_LOCK = 280;
  GLFW_KEY_SCROLL_LOCK = 281;
  GLFW_KEY_NUM_LOCK = 282;
  GLFW_KEY_PRINT_SCREEN = 283;
  GLFW_KEY_PAUSE = 284;
  GLFW_KEY_F1 = 290;
  GLFW_KEY_F2 = 291;
  GLFW_KEY_F3 = 292;
  GLFW_KEY_F4 = 293;
  GLFW_KEY_F5 = 294;
  GLFW_KEY_F6 = 295;
  GLFW_KEY_F7 = 296;
  GLFW_KEY_F8 = 297;
  GLFW_KEY_F9 = 298;
  GLFW_KEY_F10 = 299;
  GLFW_KEY_F11 = 300;
  GLFW_KEY_F12 = 301;
  GLFW_KEY_F13 = 302;
  GLFW_KEY_F14 = 303;
  GLFW_KEY_F15 = 304;
  GLFW_KEY_F16 = 305;
  GLFW_KEY_F17 = 306;
  GLFW_KEY_F18 = 307;
  GLFW_KEY_F19 = 308;
  GLFW_KEY_F20 = 309;
  GLFW_KEY_F21 = 310;
  GLFW_KEY_F22 = 311;
  GLFW_KEY_F23 = 312;
  GLFW_KEY_F24 = 313;
  GLFW_KEY_F25 = 314;
  GLFW_KEY_KP_0 = 320;
  GLFW_KEY_KP_1 = 321;
  GLFW_KEY_KP_2 = 322;
  GLFW_KEY_KP_3 = 323;
  GLFW_KEY_KP_4 = 324;
  GLFW_KEY_KP_5 = 325;
  GLFW_KEY_KP_6 = 326;
  GLFW_KEY_KP_7 = 327;
  GLFW_KEY_KP_8 = 328;
  GLFW_KEY_KP_9 = 329;
  GLFW_KEY_KP_DECIMAL = 330;
  GLFW_KEY_KP_DIVIDE = 331;
  GLFW_KEY_KP_MULTIPLY = 332;
  GLFW_KEY_KP_SUBTRACT = 333;
  GLFW_KEY_KP_ADD = 334;
  GLFW_KEY_KP_ENTER = 335;
  GLFW_KEY_KP_EQUAL = 336;
  GLFW_KEY_LEFT_SHIFT = 340;
  GLFW_KEY_LEFT_CONTROL = 341;
  GLFW_KEY_LEFT_ALT = 342;
  GLFW_KEY_LEFT_SUPER = 343;
  GLFW_KEY_RIGHT_SHIFT = 344;
  GLFW_KEY_RIGHT_CONTROL = 345;
  GLFW_KEY_RIGHT_ALT = 346;
  GLFW_KEY_RIGHT_SUPER = 347;
  GLFW_KEY_MENU = 348;
  GLFW_KEY_LAST = GLFW_KEY_MENU;
  GLFW_MOD_SHIFT = $0001;
  GLFW_MOD_CONTROL = $0002;
  GLFW_MOD_ALT = $0004;
  GLFW_MOD_SUPER = $0008;
  GLFW_MOD_CAPS_LOCK = $0010;
  GLFW_MOD_NUM_LOCK = $0020;
  GLFW_MOUSE_BUTTON_1 = 0;
  GLFW_MOUSE_BUTTON_2 = 1;
  GLFW_MOUSE_BUTTON_3 = 2;
  GLFW_MOUSE_BUTTON_4 = 3;
  GLFW_MOUSE_BUTTON_5 = 4;
  GLFW_MOUSE_BUTTON_6 = 5;
  GLFW_MOUSE_BUTTON_7 = 6;
  GLFW_MOUSE_BUTTON_8 = 7;
  GLFW_MOUSE_BUTTON_LAST = GLFW_MOUSE_BUTTON_8;
  GLFW_MOUSE_BUTTON_LEFT = GLFW_MOUSE_BUTTON_1;
  GLFW_MOUSE_BUTTON_RIGHT = GLFW_MOUSE_BUTTON_2;
  GLFW_MOUSE_BUTTON_MIDDLE = GLFW_MOUSE_BUTTON_3;
  GLFW_JOYSTICK_1 = 0;
  GLFW_JOYSTICK_2 = 1;
  GLFW_JOYSTICK_3 = 2;
  GLFW_JOYSTICK_4 = 3;
  GLFW_JOYSTICK_5 = 4;
  GLFW_JOYSTICK_6 = 5;
  GLFW_JOYSTICK_7 = 6;
  GLFW_JOYSTICK_8 = 7;
  GLFW_JOYSTICK_9 = 8;
  GLFW_JOYSTICK_10 = 9;
  GLFW_JOYSTICK_11 = 10;
  GLFW_JOYSTICK_12 = 11;
  GLFW_JOYSTICK_13 = 12;
  GLFW_JOYSTICK_14 = 13;
  GLFW_JOYSTICK_15 = 14;
  GLFW_JOYSTICK_16 = 15;
  GLFW_JOYSTICK_LAST = GLFW_JOYSTICK_16;
  GLFW_GAMEPAD_BUTTON_A = 0;
  GLFW_GAMEPAD_BUTTON_B = 1;
  GLFW_GAMEPAD_BUTTON_X = 2;
  GLFW_GAMEPAD_BUTTON_Y = 3;
  GLFW_GAMEPAD_BUTTON_LEFT_BUMPER = 4;
  GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER = 5;
  GLFW_GAMEPAD_BUTTON_BACK = 6;
  GLFW_GAMEPAD_BUTTON_START = 7;
  GLFW_GAMEPAD_BUTTON_GUIDE = 8;
  GLFW_GAMEPAD_BUTTON_LEFT_THUMB = 9;
  GLFW_GAMEPAD_BUTTON_RIGHT_THUMB = 10;
  GLFW_GAMEPAD_BUTTON_DPAD_UP = 11;
  GLFW_GAMEPAD_BUTTON_DPAD_RIGHT = 12;
  GLFW_GAMEPAD_BUTTON_DPAD_DOWN = 13;
  GLFW_GAMEPAD_BUTTON_DPAD_LEFT = 14;
  GLFW_GAMEPAD_BUTTON_LAST = GLFW_GAMEPAD_BUTTON_DPAD_LEFT;
  GLFW_GAMEPAD_BUTTON_CROSS = GLFW_GAMEPAD_BUTTON_A;
  GLFW_GAMEPAD_BUTTON_CIRCLE = GLFW_GAMEPAD_BUTTON_B;
  GLFW_GAMEPAD_BUTTON_SQUARE = GLFW_GAMEPAD_BUTTON_X;
  GLFW_GAMEPAD_BUTTON_TRIANGLE = GLFW_GAMEPAD_BUTTON_Y;
  GLFW_GAMEPAD_AXIS_LEFT_X = 0;
  GLFW_GAMEPAD_AXIS_LEFT_Y = 1;
  GLFW_GAMEPAD_AXIS_RIGHT_X = 2;
  GLFW_GAMEPAD_AXIS_RIGHT_Y = 3;
  GLFW_GAMEPAD_AXIS_LEFT_TRIGGER = 4;
  GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER = 5;
  GLFW_GAMEPAD_AXIS_LAST = GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER;
  GLFW_NO_ERROR = 0;
  GLFW_NOT_INITIALIZED = $00010001;
  GLFW_NO_CURRENT_CONTEXT = $00010002;
  GLFW_INVALID_ENUM = $00010003;
  GLFW_INVALID_VALUE = $00010004;
  GLFW_OUT_OF_MEMORY = $00010005;
  GLFW_API_UNAVAILABLE = $00010006;
  GLFW_VERSION_UNAVAILABLE = $00010007;
  GLFW_PLATFORM_ERROR = $00010008;
  GLFW_FORMAT_UNAVAILABLE = $00010009;
  GLFW_NO_WINDOW_CONTEXT = $0001000A;
  GLFW_CURSOR_UNAVAILABLE = $0001000B;
  GLFW_FEATURE_UNAVAILABLE = $0001000C;
  GLFW_FEATURE_UNIMPLEMENTED = $0001000D;
  GLFW_PLATFORM_UNAVAILABLE = $0001000E;
  GLFW_FOCUSED = $00020001;
  GLFW_ICONIFIED = $00020002;
  GLFW_RESIZABLE = $00020003;
  GLFW_VISIBLE = $00020004;
  GLFW_DECORATED = $00020005;
  GLFW_AUTO_ICONIFY = $00020006;
  GLFW_FLOATING = $00020007;
  GLFW_MAXIMIZED = $00020008;
  GLFW_CENTER_CURSOR = $00020009;
  GLFW_TRANSPARENT_FRAMEBUFFER = $0002000A;
  GLFW_HOVERED = $0002000B;
  GLFW_FOCUS_ON_SHOW = $0002000C;
  GLFW_MOUSE_PASSTHROUGH = $0002000D;
  GLFW_POSITION_X = $0002000E;
  GLFW_POSITION_Y = $0002000F;
  GLFW_RED_BITS = $00021001;
  GLFW_GREEN_BITS = $00021002;
  GLFW_BLUE_BITS = $00021003;
  GLFW_ALPHA_BITS = $00021004;
  GLFW_DEPTH_BITS = $00021005;
  GLFW_STENCIL_BITS = $00021006;
  GLFW_ACCUM_RED_BITS = $00021007;
  GLFW_ACCUM_GREEN_BITS = $00021008;
  GLFW_ACCUM_BLUE_BITS = $00021009;
  GLFW_ACCUM_ALPHA_BITS = $0002100A;
  GLFW_AUX_BUFFERS = $0002100B;
  GLFW_STEREO = $0002100C;
  GLFW_SAMPLES = $0002100D;
  GLFW_SRGB_CAPABLE = $0002100E;
  GLFW_REFRESH_RATE = $0002100F;
  GLFW_DOUBLEBUFFER = $00021010;
  GLFW_CLIENT_API = $00022001;
  GLFW_CONTEXT_VERSION_MAJOR = $00022002;
  GLFW_CONTEXT_VERSION_MINOR = $00022003;
  GLFW_CONTEXT_REVISION = $00022004;
  GLFW_CONTEXT_ROBUSTNESS = $00022005;
  GLFW_OPENGL_FORWARD_COMPAT = $00022006;
  GLFW_CONTEXT_DEBUG = $00022007;
  GLFW_OPENGL_DEBUG_CONTEXT = GLFW_CONTEXT_DEBUG;
  GLFW_OPENGL_PROFILE = $00022008;
  GLFW_CONTEXT_RELEASE_BEHAVIOR = $00022009;
  GLFW_CONTEXT_NO_ERROR = $0002200A;
  GLFW_CONTEXT_CREATION_API = $0002200B;
  GLFW_SCALE_TO_MONITOR = $0002200C;
  GLFW_SCALE_FRAMEBUFFER = $0002200D;
  GLFW_COCOA_RETINA_FRAMEBUFFER = $00023001;
  GLFW_COCOA_FRAME_NAME = $00023002;
  GLFW_COCOA_GRAPHICS_SWITCHING = $00023003;
  GLFW_X11_CLASS_NAME = $00024001;
  GLFW_X11_INSTANCE_NAME = $00024002;
  GLFW_WIN32_KEYBOARD_MENU = $00025001;
  GLFW_WIN32_SHOWDEFAULT = $00025002;
  GLFW_WAYLAND_APP_ID = $00026001;
  GLFW_NO_API = 0;
  GLFW_OPENGL_API = $00030001;
  GLFW_OPENGL_ES_API = $00030002;
  GLFW_NO_ROBUSTNESS = 0;
  GLFW_NO_RESET_NOTIFICATION = $00031001;
  GLFW_LOSE_CONTEXT_ON_RESET = $00031002;
  GLFW_OPENGL_ANY_PROFILE = 0;
  GLFW_OPENGL_CORE_PROFILE = $00032001;
  GLFW_OPENGL_COMPAT_PROFILE = $00032002;
  GLFW_CURSOR = $00033001;
  GLFW_STICKY_KEYS = $00033002;
  GLFW_STICKY_MOUSE_BUTTONS = $00033003;
  GLFW_LOCK_KEY_MODS = $00033004;
  GLFW_RAW_MOUSE_MOTION = $00033005;
  GLFW_UNLIMITED_MOUSE_BUTTONS = $00033006;
  GLFW_CURSOR_NORMAL = $00034001;
  GLFW_CURSOR_HIDDEN = $00034002;
  GLFW_CURSOR_DISABLED = $00034003;
  GLFW_CURSOR_CAPTURED = $00034004;
  GLFW_ANY_RELEASE_BEHAVIOR = 0;
  GLFW_RELEASE_BEHAVIOR_FLUSH = $00035001;
  GLFW_RELEASE_BEHAVIOR_NONE = $00035002;
  GLFW_NATIVE_CONTEXT_API = $00036001;
  GLFW_EGL_CONTEXT_API = $00036002;
  GLFW_OSMESA_CONTEXT_API = $00036003;
  GLFW_ANGLE_PLATFORM_TYPE_NONE = $00037001;
  GLFW_ANGLE_PLATFORM_TYPE_OPENGL = $00037002;
  GLFW_ANGLE_PLATFORM_TYPE_OPENGLES = $00037003;
  GLFW_ANGLE_PLATFORM_TYPE_D3D9 = $00037004;
  GLFW_ANGLE_PLATFORM_TYPE_D3D11 = $00037005;
  GLFW_ANGLE_PLATFORM_TYPE_VULKAN = $00037007;
  GLFW_ANGLE_PLATFORM_TYPE_METAL = $00037008;
  GLFW_WAYLAND_PREFER_LIBDECOR = $00038001;
  GLFW_WAYLAND_DISABLE_LIBDECOR = $00038002;
  GLFW_ANY_POSITION = $80000000;
  GLFW_ARROW_CURSOR = $00036001;
  GLFW_IBEAM_CURSOR = $00036002;
  GLFW_CROSSHAIR_CURSOR = $00036003;
  GLFW_POINTING_HAND_CURSOR = $00036004;
  GLFW_RESIZE_EW_CURSOR = $00036005;
  GLFW_RESIZE_NS_CURSOR = $00036006;
  GLFW_RESIZE_NWSE_CURSOR = $00036007;
  GLFW_RESIZE_NESW_CURSOR = $00036008;
  GLFW_RESIZE_ALL_CURSOR = $00036009;
  GLFW_NOT_ALLOWED_CURSOR = $0003600A;
  GLFW_HRESIZE_CURSOR = GLFW_RESIZE_EW_CURSOR;
  GLFW_VRESIZE_CURSOR = GLFW_RESIZE_NS_CURSOR;
  GLFW_HAND_CURSOR = GLFW_POINTING_HAND_CURSOR;
  GLFW_CONNECTED = $00040001;
  GLFW_DISCONNECTED = $00040002;
  GLFW_JOYSTICK_HAT_BUTTONS = $00050001;
  GLFW_ANGLE_PLATFORM_TYPE = $00050002;
  GLFW_PLATFORM = $00050003;
  GLFW_COCOA_CHDIR_RESOURCES = $00051001;
  GLFW_COCOA_MENUBAR = $00051002;
  GLFW_X11_XCB_VULKAN_SURFACE = $00052001;
  GLFW_WAYLAND_LIBDECOR = $00053001;
  GLFW_ANY_PLATFORM = $00060000;
  GLFW_PLATFORM_WIN32 = $00060001;
  GLFW_PLATFORM_COCOA = $00060002;
  GLFW_PLATFORM_WAYLAND = $00060003;
  GLFW_PLATFORM_X11 = $00060004;
  GLFW_PLATFORM_NULL = $00060005;
  GLFW_DONT_CARE = -1;
  Z_ERRNO = -1;
  Z_OK = 0;
  Z_DEFLATED = 8;
  Z_DEFAULT_STRATEGY = 0;
  ZIP_OK = (0);
  ZIP_EOF = (0);
  ZIP_ERRNO = (Z_ERRNO);
  ZIP_PARAMERROR = (-102);
  ZIP_BADZIPFILE = (-103);
  ZIP_INTERNALERROR = (-104);
  UNZ_OK = (0);
  UNZ_END_OF_LIST_OF_FILE = (-100);
  UNZ_ERRNO = (Z_ERRNO);
  UNZ_EOF = (0);
  UNZ_PARAMERROR = (-102);
  UNZ_BADZIPFILE = (-103);
  UNZ_INTERNALERROR = (-104);
  UNZ_CRCERROR = (-105);
  APPEND_STATUS_CREATE = (0);
  APPEND_STATUS_CREATEAFTER = (1);
  APPEND_STATUS_ADDINZIP = (2);
  C2_MAX_POLYGON_VERTS = 8;
  MA_VERSION_MAJOR = 0;
  MA_VERSION_MINOR = 11;
  MA_VERSION_REVISION = 22;
  MA_SIZEOF_PTR = 8;
  MA_TRUE = 1;
  MA_FALSE = 0;
  SIZE_MAX = $ffffffffffffffff;
  MA_SIZE_MAX = SIZE_MAX;
  MA_SIMD_ALIGNMENT = 32;
  MA_MIN_CHANNELS = 1;
  MA_MAX_CHANNELS = 254;
  MA_MAX_FILTER_ORDER = 8;
  MA_MAX_LOG_CALLBACKS = 4;
  MA_CHANNEL_INDEX_NULL = 255;
  MA_DATA_SOURCE_SELF_MANAGED_RANGE_AND_LOOP_POINT = $00000001;
  MA_DATA_FORMAT_FLAG_EXCLUSIVE_MODE = (1 shl 1);
  MA_MAX_DEVICE_NAME_LENGTH = 255;
  MA_RESOURCE_MANAGER_MAX_JOB_THREAD_COUNT = 64;
  MA_MAX_NODE_BUS_COUNT = 254;
  MA_MAX_NODE_LOCAL_BUS_COUNT = 2;
  MA_NODE_BUS_COUNT_UNKNOWN = 255;
  MA_ENGINE_MAX_LISTENERS = 4;
  MA_SOUND_SOURCE_CHANNEL_COUNT = $FFFFFFFF;
  PLM_PACKET_INVALID_TS = -1;
  PLM_AUDIO_SAMPLES_PER_FRAME = 1152;
  PLM_BUFFER_DEFAULT_SIZE = (128*1024);
  SQLITE_VERSION = '3.50.0';
  SQLITE_VERSION_NUMBER = 3050000;
  SQLITE_SOURCE_ID = '2025-05-29 14:26:00 dfc790f998f450d9c35e3ba1c8c89c17466cb559f87b0239e4aab9d34e28f742';
  SQLITE_OK = 0;
  SQLITE_ERROR = 1;
  SQLITE_INTERNAL = 2;
  SQLITE_PERM = 3;
  SQLITE_ABORT = 4;
  SQLITE_BUSY = 5;
  SQLITE_LOCKED = 6;
  SQLITE_NOMEM = 7;
  SQLITE_READONLY = 8;
  SQLITE_INTERRUPT = 9;
  SQLITE_IOERR = 10;
  SQLITE_CORRUPT = 11;
  SQLITE_NOTFOUND = 12;
  SQLITE_FULL = 13;
  SQLITE_CANTOPEN = 14;
  SQLITE_PROTOCOL = 15;
  SQLITE_EMPTY = 16;
  SQLITE_SCHEMA = 17;
  SQLITE_TOOBIG = 18;
  SQLITE_CONSTRAINT = 19;
  SQLITE_MISMATCH = 20;
  SQLITE_MISUSE = 21;
  SQLITE_NOLFS = 22;
  SQLITE_AUTH = 23;
  SQLITE_FORMAT = 24;
  SQLITE_RANGE = 25;
  SQLITE_NOTADB = 26;
  SQLITE_NOTICE = 27;
  SQLITE_WARNING = 28;
  SQLITE_ROW = 100;
  SQLITE_DONE = 101;
  SQLITE_ERROR_MISSING_COLLSEQ = (SQLITE_ERROR or (1 shl 8));
  SQLITE_ERROR_RETRY = (SQLITE_ERROR or (2 shl 8));
  SQLITE_ERROR_SNAPSHOT = (SQLITE_ERROR or (3 shl 8));
  SQLITE_IOERR_READ = (SQLITE_IOERR or (1 shl 8));
  SQLITE_IOERR_SHORT_READ = (SQLITE_IOERR or (2 shl 8));
  SQLITE_IOERR_WRITE = (SQLITE_IOERR or (3 shl 8));
  SQLITE_IOERR_FSYNC = (SQLITE_IOERR or (4 shl 8));
  SQLITE_IOERR_DIR_FSYNC = (SQLITE_IOERR or (5 shl 8));
  SQLITE_IOERR_TRUNCATE = (SQLITE_IOERR or (6 shl 8));
  SQLITE_IOERR_FSTAT = (SQLITE_IOERR or (7 shl 8));
  SQLITE_IOERR_UNLOCK = (SQLITE_IOERR or (8 shl 8));
  SQLITE_IOERR_RDLOCK = (SQLITE_IOERR or (9 shl 8));
  SQLITE_IOERR_DELETE = (SQLITE_IOERR or (10 shl 8));
  SQLITE_IOERR_BLOCKED = (SQLITE_IOERR or (11 shl 8));
  SQLITE_IOERR_NOMEM = (SQLITE_IOERR or (12 shl 8));
  SQLITE_IOERR_ACCESS = (SQLITE_IOERR or (13 shl 8));
  SQLITE_IOERR_CHECKRESERVEDLOCK = (SQLITE_IOERR or (14 shl 8));
  SQLITE_IOERR_LOCK = (SQLITE_IOERR or (15 shl 8));
  SQLITE_IOERR_CLOSE = (SQLITE_IOERR or (16 shl 8));
  SQLITE_IOERR_DIR_CLOSE = (SQLITE_IOERR or (17 shl 8));
  SQLITE_IOERR_SHMOPEN = (SQLITE_IOERR or (18 shl 8));
  SQLITE_IOERR_SHMSIZE = (SQLITE_IOERR or (19 shl 8));
  SQLITE_IOERR_SHMLOCK = (SQLITE_IOERR or (20 shl 8));
  SQLITE_IOERR_SHMMAP = (SQLITE_IOERR or (21 shl 8));
  SQLITE_IOERR_SEEK = (SQLITE_IOERR or (22 shl 8));
  SQLITE_IOERR_DELETE_NOENT = (SQLITE_IOERR or (23 shl 8));
  SQLITE_IOERR_MMAP = (SQLITE_IOERR or (24 shl 8));
  SQLITE_IOERR_GETTEMPPATH = (SQLITE_IOERR or (25 shl 8));
  SQLITE_IOERR_CONVPATH = (SQLITE_IOERR or (26 shl 8));
  SQLITE_IOERR_VNODE = (SQLITE_IOERR or (27 shl 8));
  SQLITE_IOERR_AUTH = (SQLITE_IOERR or (28 shl 8));
  SQLITE_IOERR_BEGIN_ATOMIC = (SQLITE_IOERR or (29 shl 8));
  SQLITE_IOERR_COMMIT_ATOMIC = (SQLITE_IOERR or (30 shl 8));
  SQLITE_IOERR_ROLLBACK_ATOMIC = (SQLITE_IOERR or (31 shl 8));
  SQLITE_IOERR_DATA = (SQLITE_IOERR or (32 shl 8));
  SQLITE_IOERR_CORRUPTFS = (SQLITE_IOERR or (33 shl 8));
  SQLITE_IOERR_IN_PAGE = (SQLITE_IOERR or (34 shl 8));
  SQLITE_LOCKED_SHAREDCACHE = (SQLITE_LOCKED or (1 shl 8));
  SQLITE_LOCKED_VTAB = (SQLITE_LOCKED or (2 shl 8));
  SQLITE_BUSY_RECOVERY = (SQLITE_BUSY or (1 shl 8));
  SQLITE_BUSY_SNAPSHOT = (SQLITE_BUSY or (2 shl 8));
  SQLITE_BUSY_TIMEOUT = (SQLITE_BUSY or (3 shl 8));
  SQLITE_CANTOPEN_NOTEMPDIR = (SQLITE_CANTOPEN or (1 shl 8));
  SQLITE_CANTOPEN_ISDIR = (SQLITE_CANTOPEN or (2 shl 8));
  SQLITE_CANTOPEN_FULLPATH = (SQLITE_CANTOPEN or (3 shl 8));
  SQLITE_CANTOPEN_CONVPATH = (SQLITE_CANTOPEN or (4 shl 8));
  SQLITE_CANTOPEN_DIRTYWAL = (SQLITE_CANTOPEN or (5 shl 8));
  SQLITE_CANTOPEN_SYMLINK = (SQLITE_CANTOPEN or (6 shl 8));
  SQLITE_CORRUPT_VTAB = (SQLITE_CORRUPT or (1 shl 8));
  SQLITE_CORRUPT_SEQUENCE = (SQLITE_CORRUPT or (2 shl 8));
  SQLITE_CORRUPT_INDEX = (SQLITE_CORRUPT or (3 shl 8));
  SQLITE_READONLY_RECOVERY = (SQLITE_READONLY or (1 shl 8));
  SQLITE_READONLY_CANTLOCK = (SQLITE_READONLY or (2 shl 8));
  SQLITE_READONLY_ROLLBACK = (SQLITE_READONLY or (3 shl 8));
  SQLITE_READONLY_DBMOVED = (SQLITE_READONLY or (4 shl 8));
  SQLITE_READONLY_CANTINIT = (SQLITE_READONLY or (5 shl 8));
  SQLITE_READONLY_DIRECTORY = (SQLITE_READONLY or (6 shl 8));
  SQLITE_ABORT_ROLLBACK = (SQLITE_ABORT or (2 shl 8));
  SQLITE_CONSTRAINT_CHECK = (SQLITE_CONSTRAINT or (1 shl 8));
  SQLITE_CONSTRAINT_COMMITHOOK = (SQLITE_CONSTRAINT or (2 shl 8));
  SQLITE_CONSTRAINT_FOREIGNKEY = (SQLITE_CONSTRAINT or (3 shl 8));
  SQLITE_CONSTRAINT_FUNCTION = (SQLITE_CONSTRAINT or (4 shl 8));
  SQLITE_CONSTRAINT_NOTNULL = (SQLITE_CONSTRAINT or (5 shl 8));
  SQLITE_CONSTRAINT_PRIMARYKEY = (SQLITE_CONSTRAINT or (6 shl 8));
  SQLITE_CONSTRAINT_TRIGGER = (SQLITE_CONSTRAINT or (7 shl 8));
  SQLITE_CONSTRAINT_UNIQUE = (SQLITE_CONSTRAINT or (8 shl 8));
  SQLITE_CONSTRAINT_VTAB = (SQLITE_CONSTRAINT or (9 shl 8));
  SQLITE_CONSTRAINT_ROWID = (SQLITE_CONSTRAINT or (10 shl 8));
  SQLITE_CONSTRAINT_PINNED = (SQLITE_CONSTRAINT or (11 shl 8));
  SQLITE_CONSTRAINT_DATATYPE = (SQLITE_CONSTRAINT or (12 shl 8));
  SQLITE_NOTICE_RECOVER_WAL = (SQLITE_NOTICE or (1 shl 8));
  SQLITE_NOTICE_RECOVER_ROLLBACK = (SQLITE_NOTICE or (2 shl 8));
  SQLITE_NOTICE_RBU = (SQLITE_NOTICE or (3 shl 8));
  SQLITE_WARNING_AUTOINDEX = (SQLITE_WARNING or (1 shl 8));
  SQLITE_AUTH_USER = (SQLITE_AUTH or (1 shl 8));
  SQLITE_OK_LOAD_PERMANENTLY = (SQLITE_OK or (1 shl 8));
  SQLITE_OK_SYMLINK = (SQLITE_OK or (2 shl 8));
  SQLITE_OPEN_READONLY = $00000001;
  SQLITE_OPEN_READWRITE = $00000002;
  SQLITE_OPEN_CREATE = $00000004;
  SQLITE_OPEN_DELETEONCLOSE = $00000008;
  SQLITE_OPEN_EXCLUSIVE = $00000010;
  SQLITE_OPEN_AUTOPROXY = $00000020;
  SQLITE_OPEN_URI = $00000040;
  SQLITE_OPEN_MEMORY = $00000080;
  SQLITE_OPEN_MAIN_DB = $00000100;
  SQLITE_OPEN_TEMP_DB = $00000200;
  SQLITE_OPEN_TRANSIENT_DB = $00000400;
  SQLITE_OPEN_MAIN_JOURNAL = $00000800;
  SQLITE_OPEN_TEMP_JOURNAL = $00001000;
  SQLITE_OPEN_SUBJOURNAL = $00002000;
  SQLITE_OPEN_SUPER_JOURNAL = $00004000;
  SQLITE_OPEN_NOMUTEX = $00008000;
  SQLITE_OPEN_FULLMUTEX = $00010000;
  SQLITE_OPEN_SHAREDCACHE = $00020000;
  SQLITE_OPEN_PRIVATECACHE = $00040000;
  SQLITE_OPEN_WAL = $00080000;
  SQLITE_OPEN_NOFOLLOW = $01000000;
  SQLITE_OPEN_EXRESCODE = $02000000;
  SQLITE_OPEN_MASTER_JOURNAL = $00004000;
  SQLITE_IOCAP_ATOMIC = $00000001;
  SQLITE_IOCAP_ATOMIC512 = $00000002;
  SQLITE_IOCAP_ATOMIC1K = $00000004;
  SQLITE_IOCAP_ATOMIC2K = $00000008;
  SQLITE_IOCAP_ATOMIC4K = $00000010;
  SQLITE_IOCAP_ATOMIC8K = $00000020;
  SQLITE_IOCAP_ATOMIC16K = $00000040;
  SQLITE_IOCAP_ATOMIC32K = $00000080;
  SQLITE_IOCAP_ATOMIC64K = $00000100;
  SQLITE_IOCAP_SAFE_APPEND = $00000200;
  SQLITE_IOCAP_SEQUENTIAL = $00000400;
  SQLITE_IOCAP_UNDELETABLE_WHEN_OPEN = $00000800;
  SQLITE_IOCAP_POWERSAFE_OVERWRITE = $00001000;
  SQLITE_IOCAP_IMMUTABLE = $00002000;
  SQLITE_IOCAP_BATCH_ATOMIC = $00004000;
  SQLITE_IOCAP_SUBPAGE_READ = $00008000;
  SQLITE_LOCK_NONE = 0;
  SQLITE_LOCK_SHARED = 1;
  SQLITE_LOCK_RESERVED = 2;
  SQLITE_LOCK_PENDING = 3;
  SQLITE_LOCK_EXCLUSIVE = 4;
  SQLITE_SYNC_NORMAL = $00002;
  SQLITE_SYNC_FULL = $00003;
  SQLITE_SYNC_DATAONLY = $00010;
  SQLITE_FCNTL_LOCKSTATE = 1;
  SQLITE_FCNTL_GET_LOCKPROXYFILE = 2;
  SQLITE_FCNTL_SET_LOCKPROXYFILE = 3;
  SQLITE_FCNTL_LAST_ERRNO = 4;
  SQLITE_FCNTL_SIZE_HINT = 5;
  SQLITE_FCNTL_CHUNK_SIZE = 6;
  SQLITE_FCNTL_FILE_POINTER = 7;
  SQLITE_FCNTL_SYNC_OMITTED = 8;
  SQLITE_FCNTL_WIN32_AV_RETRY = 9;
  SQLITE_FCNTL_PERSIST_WAL = 10;
  SQLITE_FCNTL_OVERWRITE = 11;
  SQLITE_FCNTL_VFSNAME = 12;
  SQLITE_FCNTL_POWERSAFE_OVERWRITE = 13;
  SQLITE_FCNTL_PRAGMA = 14;
  SQLITE_FCNTL_BUSYHANDLER = 15;
  SQLITE_FCNTL_TEMPFILENAME = 16;
  SQLITE_FCNTL_MMAP_SIZE = 18;
  SQLITE_FCNTL_TRACE = 19;
  SQLITE_FCNTL_HAS_MOVED = 20;
  SQLITE_FCNTL_SYNC = 21;
  SQLITE_FCNTL_COMMIT_PHASETWO = 22;
  SQLITE_FCNTL_WIN32_SET_HANDLE = 23;
  SQLITE_FCNTL_WAL_BLOCK = 24;
  SQLITE_FCNTL_ZIPVFS = 25;
  SQLITE_FCNTL_RBU = 26;
  SQLITE_FCNTL_VFS_POINTER = 27;
  SQLITE_FCNTL_JOURNAL_POINTER = 28;
  SQLITE_FCNTL_WIN32_GET_HANDLE = 29;
  SQLITE_FCNTL_PDB = 30;
  SQLITE_FCNTL_BEGIN_ATOMIC_WRITE = 31;
  SQLITE_FCNTL_COMMIT_ATOMIC_WRITE = 32;
  SQLITE_FCNTL_ROLLBACK_ATOMIC_WRITE = 33;
  SQLITE_FCNTL_LOCK_TIMEOUT = 34;
  SQLITE_FCNTL_DATA_VERSION = 35;
  SQLITE_FCNTL_SIZE_LIMIT = 36;
  SQLITE_FCNTL_CKPT_DONE = 37;
  SQLITE_FCNTL_RESERVE_BYTES = 38;
  SQLITE_FCNTL_CKPT_START = 39;
  SQLITE_FCNTL_EXTERNAL_READER = 40;
  SQLITE_FCNTL_CKSM_FILE = 41;
  SQLITE_FCNTL_RESET_CACHE = 42;
  SQLITE_FCNTL_NULL_IO = 43;
  SQLITE_FCNTL_BLOCK_ON_CONNECT = 44;
  SQLITE_GET_LOCKPROXYFILE = SQLITE_FCNTL_GET_LOCKPROXYFILE;
  SQLITE_SET_LOCKPROXYFILE = SQLITE_FCNTL_SET_LOCKPROXYFILE;
  SQLITE_LAST_ERRNO = SQLITE_FCNTL_LAST_ERRNO;
  SQLITE_ACCESS_EXISTS = 0;
  SQLITE_ACCESS_READWRITE = 1;
  SQLITE_ACCESS_READ = 2;
  SQLITE_SHM_UNLOCK = 1;
  SQLITE_SHM_LOCK = 2;
  SQLITE_SHM_SHARED = 4;
  SQLITE_SHM_EXCLUSIVE = 8;
  SQLITE_SHM_NLOCK = 8;
  SQLITE_CONFIG_SINGLETHREAD = 1;
  SQLITE_CONFIG_MULTITHREAD = 2;
  SQLITE_CONFIG_SERIALIZED = 3;
  SQLITE_CONFIG_MALLOC = 4;
  SQLITE_CONFIG_GETMALLOC = 5;
  SQLITE_CONFIG_SCRATCH = 6;
  SQLITE_CONFIG_PAGECACHE = 7;
  SQLITE_CONFIG_HEAP = 8;
  SQLITE_CONFIG_MEMSTATUS = 9;
  SQLITE_CONFIG_MUTEX = 10;
  SQLITE_CONFIG_GETMUTEX = 11;
  SQLITE_CONFIG_LOOKASIDE = 13;
  SQLITE_CONFIG_PCACHE = 14;
  SQLITE_CONFIG_GETPCACHE = 15;
  SQLITE_CONFIG_LOG = 16;
  SQLITE_CONFIG_URI = 17;
  SQLITE_CONFIG_PCACHE2 = 18;
  SQLITE_CONFIG_GETPCACHE2 = 19;
  SQLITE_CONFIG_COVERING_INDEX_SCAN = 20;
  SQLITE_CONFIG_SQLLOG = 21;
  SQLITE_CONFIG_MMAP_SIZE = 22;
  SQLITE_CONFIG_WIN32_HEAPSIZE = 23;
  SQLITE_CONFIG_PCACHE_HDRSZ = 24;
  SQLITE_CONFIG_PMASZ = 25;
  SQLITE_CONFIG_STMTJRNL_SPILL = 26;
  SQLITE_CONFIG_SMALL_MALLOC = 27;
  SQLITE_CONFIG_SORTERREF_SIZE = 28;
  SQLITE_CONFIG_MEMDB_MAXSIZE = 29;
  SQLITE_CONFIG_ROWID_IN_VIEW = 30;
  SQLITE_DBCONFIG_MAINDBNAME = 1000;
  SQLITE_DBCONFIG_LOOKASIDE = 1001;
  SQLITE_DBCONFIG_ENABLE_FKEY = 1002;
  SQLITE_DBCONFIG_ENABLE_TRIGGER = 1003;
  SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER = 1004;
  SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION = 1005;
  SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE = 1006;
  SQLITE_DBCONFIG_ENABLE_QPSG = 1007;
  SQLITE_DBCONFIG_TRIGGER_EQP = 1008;
  SQLITE_DBCONFIG_RESET_DATABASE = 1009;
  SQLITE_DBCONFIG_DEFENSIVE = 1010;
  SQLITE_DBCONFIG_WRITABLE_SCHEMA = 1011;
  SQLITE_DBCONFIG_LEGACY_ALTER_TABLE = 1012;
  SQLITE_DBCONFIG_DQS_DML = 1013;
  SQLITE_DBCONFIG_DQS_DDL = 1014;
  SQLITE_DBCONFIG_ENABLE_VIEW = 1015;
  SQLITE_DBCONFIG_LEGACY_FILE_FORMAT = 1016;
  SQLITE_DBCONFIG_TRUSTED_SCHEMA = 1017;
  SQLITE_DBCONFIG_STMT_SCANSTATUS = 1018;
  SQLITE_DBCONFIG_REVERSE_SCANORDER = 1019;
  SQLITE_DBCONFIG_ENABLE_ATTACH_CREATE = 1020;
  SQLITE_DBCONFIG_ENABLE_ATTACH_WRITE = 1021;
  SQLITE_DBCONFIG_ENABLE_COMMENTS = 1022;
  SQLITE_DBCONFIG_MAX = 1022;
  SQLITE_SETLK_BLOCK_ON_CONNECT = $01;
  SQLITE_DENY = 1;
  SQLITE_IGNORE = 2;
  SQLITE_CREATE_INDEX = 1;
  SQLITE_CREATE_TABLE = 2;
  SQLITE_CREATE_TEMP_INDEX = 3;
  SQLITE_CREATE_TEMP_TABLE = 4;
  SQLITE_CREATE_TEMP_TRIGGER = 5;
  SQLITE_CREATE_TEMP_VIEW = 6;
  SQLITE_CREATE_TRIGGER = 7;
  SQLITE_CREATE_VIEW = 8;
  SQLITE_DELETE = 9;
  SQLITE_DROP_INDEX = 10;
  SQLITE_DROP_TABLE = 11;
  SQLITE_DROP_TEMP_INDEX = 12;
  SQLITE_DROP_TEMP_TABLE = 13;
  SQLITE_DROP_TEMP_TRIGGER = 14;
  SQLITE_DROP_TEMP_VIEW = 15;
  SQLITE_DROP_TRIGGER = 16;
  SQLITE_DROP_VIEW = 17;
  SQLITE_INSERT = 18;
  SQLITE_PRAGMA = 19;
  SQLITE_READ = 20;
  SQLITE_SELECT = 21;
  SQLITE_TRANSACTION = 22;
  SQLITE_UPDATE = 23;
  SQLITE_ATTACH = 24;
  SQLITE_DETACH = 25;
  SQLITE_ALTER_TABLE = 26;
  SQLITE_REINDEX = 27;
  SQLITE_ANALYZE = 28;
  SQLITE_CREATE_VTABLE = 29;
  SQLITE_DROP_VTABLE = 30;
  SQLITE_FUNCTION = 31;
  SQLITE_SAVEPOINT = 32;
  SQLITE_COPY = 0;
  SQLITE_RECURSIVE = 33;
  SQLITE_TRACE_STMT = $01;
  SQLITE_TRACE_PROFILE = $02;
  SQLITE_TRACE_ROW = $04;
  SQLITE_TRACE_CLOSE = $08;
  SQLITE_LIMIT_LENGTH = 0;
  SQLITE_LIMIT_SQL_LENGTH = 1;
  SQLITE_LIMIT_COLUMN = 2;
  SQLITE_LIMIT_EXPR_DEPTH = 3;
  SQLITE_LIMIT_COMPOUND_SELECT = 4;
  SQLITE_LIMIT_VDBE_OP = 5;
  SQLITE_LIMIT_FUNCTION_ARG = 6;
  SQLITE_LIMIT_ATTACHED = 7;
  SQLITE_LIMIT_LIKE_PATTERN_LENGTH = 8;
  SQLITE_LIMIT_VARIABLE_NUMBER = 9;
  SQLITE_LIMIT_TRIGGER_DEPTH = 10;
  SQLITE_LIMIT_WORKER_THREADS = 11;
  SQLITE_PREPARE_PERSISTENT = $01;
  SQLITE_PREPARE_NORMALIZE = $02;
  SQLITE_PREPARE_NO_VTAB = $04;
  SQLITE_PREPARE_DONT_LOG = $10;
  SQLITE_INTEGER = 1;
  SQLITE_FLOAT = 2;
  SQLITE_BLOB = 4;
  SQLITE_NULL = 5;
  SQLITE_TEXT = 3;
  SQLITE3_TEXT = 3;
  SQLITE_UTF8 = 1;
  SQLITE_UTF16LE = 2;
  SQLITE_UTF16BE = 3;
  SQLITE_UTF16 = 4;
  SQLITE_ANY = 5;
  SQLITE_UTF16_ALIGNED = 8;
  SQLITE_DETERMINISTIC = $000000800;
  SQLITE_DIRECTONLY = $000080000;
  SQLITE_SUBTYPE = $000100000;
  SQLITE_INNOCUOUS = $000200000;
  SQLITE_RESULT_SUBTYPE = $001000000;
  SQLITE_SELFORDER1 = $002000000;
  SQLITE_WIN32_DATA_DIRECTORY_TYPE = 1;
  SQLITE_WIN32_TEMP_DIRECTORY_TYPE = 2;
  SQLITE_TXN_NONE = 0;
  SQLITE_TXN_READ = 1;
  SQLITE_TXN_WRITE = 2;
  SQLITE_INDEX_SCAN_UNIQUE = $00000001;
  SQLITE_INDEX_SCAN_HEX = $00000002;
  SQLITE_INDEX_CONSTRAINT_EQ = 2;
  SQLITE_INDEX_CONSTRAINT_GT = 4;
  SQLITE_INDEX_CONSTRAINT_LE = 8;
  SQLITE_INDEX_CONSTRAINT_LT = 16;
  SQLITE_INDEX_CONSTRAINT_GE = 32;
  SQLITE_INDEX_CONSTRAINT_MATCH = 64;
  SQLITE_INDEX_CONSTRAINT_LIKE = 65;
  SQLITE_INDEX_CONSTRAINT_GLOB = 66;
  SQLITE_INDEX_CONSTRAINT_REGEXP = 67;
  SQLITE_INDEX_CONSTRAINT_NE = 68;
  SQLITE_INDEX_CONSTRAINT_ISNOT = 69;
  SQLITE_INDEX_CONSTRAINT_ISNOTNULL = 70;
  SQLITE_INDEX_CONSTRAINT_ISNULL = 71;
  SQLITE_INDEX_CONSTRAINT_IS = 72;
  SQLITE_INDEX_CONSTRAINT_LIMIT = 73;
  SQLITE_INDEX_CONSTRAINT_OFFSET = 74;
  SQLITE_INDEX_CONSTRAINT_FUNCTION = 150;
  SQLITE_MUTEX_FAST = 0;
  SQLITE_MUTEX_RECURSIVE = 1;
  SQLITE_MUTEX_STATIC_MAIN = 2;
  SQLITE_MUTEX_STATIC_MEM = 3;
  SQLITE_MUTEX_STATIC_MEM2 = 4;
  SQLITE_MUTEX_STATIC_OPEN = 4;
  SQLITE_MUTEX_STATIC_PRNG = 5;
  SQLITE_MUTEX_STATIC_LRU = 6;
  SQLITE_MUTEX_STATIC_LRU2 = 7;
  SQLITE_MUTEX_STATIC_PMEM = 7;
  SQLITE_MUTEX_STATIC_APP1 = 8;
  SQLITE_MUTEX_STATIC_APP2 = 9;
  SQLITE_MUTEX_STATIC_APP3 = 10;
  SQLITE_MUTEX_STATIC_VFS1 = 11;
  SQLITE_MUTEX_STATIC_VFS2 = 12;
  SQLITE_MUTEX_STATIC_VFS3 = 13;
  SQLITE_MUTEX_STATIC_MASTER = 2;
  SQLITE_TESTCTRL_FIRST = 5;
  SQLITE_TESTCTRL_PRNG_SAVE = 5;
  SQLITE_TESTCTRL_PRNG_RESTORE = 6;
  SQLITE_TESTCTRL_PRNG_RESET = 7;
  SQLITE_TESTCTRL_FK_NO_ACTION = 7;
  SQLITE_TESTCTRL_BITVEC_TEST = 8;
  SQLITE_TESTCTRL_FAULT_INSTALL = 9;
  SQLITE_TESTCTRL_BENIGN_MALLOC_HOOKS = 10;
  SQLITE_TESTCTRL_PENDING_BYTE = 11;
  SQLITE_TESTCTRL_ASSERT = 12;
  SQLITE_TESTCTRL_ALWAYS = 13;
  SQLITE_TESTCTRL_RESERVE = 14;
  SQLITE_TESTCTRL_JSON_SELFCHECK = 14;
  SQLITE_TESTCTRL_OPTIMIZATIONS = 15;
  SQLITE_TESTCTRL_ISKEYWORD = 16;
  SQLITE_TESTCTRL_GETOPT = 16;
  SQLITE_TESTCTRL_SCRATCHMALLOC = 17;
  SQLITE_TESTCTRL_INTERNAL_FUNCTIONS = 17;
  SQLITE_TESTCTRL_LOCALTIME_FAULT = 18;
  SQLITE_TESTCTRL_EXPLAIN_STMT = 19;
  SQLITE_TESTCTRL_ONCE_RESET_THRESHOLD = 19;
  SQLITE_TESTCTRL_NEVER_CORRUPT = 20;
  SQLITE_TESTCTRL_VDBE_COVERAGE = 21;
  SQLITE_TESTCTRL_BYTEORDER = 22;
  SQLITE_TESTCTRL_ISINIT = 23;
  SQLITE_TESTCTRL_SORTER_MMAP = 24;
  SQLITE_TESTCTRL_IMPOSTER = 25;
  SQLITE_TESTCTRL_PARSER_COVERAGE = 26;
  SQLITE_TESTCTRL_RESULT_INTREAL = 27;
  SQLITE_TESTCTRL_PRNG_SEED = 28;
  SQLITE_TESTCTRL_EXTRA_SCHEMA_CHECKS = 29;
  SQLITE_TESTCTRL_SEEK_COUNT = 30;
  SQLITE_TESTCTRL_TRACEFLAGS = 31;
  SQLITE_TESTCTRL_TUNE = 32;
  SQLITE_TESTCTRL_LOGEST = 33;
  SQLITE_TESTCTRL_USELONGDOUBLE = 34;
  SQLITE_TESTCTRL_LAST = 34;
  SQLITE_STATUS_MEMORY_USED = 0;
  SQLITE_STATUS_PAGECACHE_USED = 1;
  SQLITE_STATUS_PAGECACHE_OVERFLOW = 2;
  SQLITE_STATUS_SCRATCH_USED = 3;
  SQLITE_STATUS_SCRATCH_OVERFLOW = 4;
  SQLITE_STATUS_MALLOC_SIZE = 5;
  SQLITE_STATUS_PARSER_STACK = 6;
  SQLITE_STATUS_PAGECACHE_SIZE = 7;
  SQLITE_STATUS_SCRATCH_SIZE = 8;
  SQLITE_STATUS_MALLOC_COUNT = 9;
  SQLITE_DBSTATUS_LOOKASIDE_USED = 0;
  SQLITE_DBSTATUS_CACHE_USED = 1;
  SQLITE_DBSTATUS_SCHEMA_USED = 2;
  SQLITE_DBSTATUS_STMT_USED = 3;
  SQLITE_DBSTATUS_LOOKASIDE_HIT = 4;
  SQLITE_DBSTATUS_LOOKASIDE_MISS_SIZE = 5;
  SQLITE_DBSTATUS_LOOKASIDE_MISS_FULL = 6;
  SQLITE_DBSTATUS_CACHE_HIT = 7;
  SQLITE_DBSTATUS_CACHE_MISS = 8;
  SQLITE_DBSTATUS_CACHE_WRITE = 9;
  SQLITE_DBSTATUS_DEFERRED_FKS = 10;
  SQLITE_DBSTATUS_CACHE_USED_SHARED = 11;
  SQLITE_DBSTATUS_CACHE_SPILL = 12;
  SQLITE_DBSTATUS_MAX = 12;
  SQLITE_STMTSTATUS_FULLSCAN_STEP = 1;
  SQLITE_STMTSTATUS_SORT = 2;
  SQLITE_STMTSTATUS_AUTOINDEX = 3;
  SQLITE_STMTSTATUS_VM_STEP = 4;
  SQLITE_STMTSTATUS_REPREPARE = 5;
  SQLITE_STMTSTATUS_RUN = 6;
  SQLITE_STMTSTATUS_FILTER_MISS = 7;
  SQLITE_STMTSTATUS_FILTER_HIT = 8;
  SQLITE_STMTSTATUS_MEMUSED = 99;
  SQLITE_CHECKPOINT_PASSIVE = 0;
  SQLITE_CHECKPOINT_FULL = 1;
  SQLITE_CHECKPOINT_RESTART = 2;
  SQLITE_CHECKPOINT_TRUNCATE = 3;
  SQLITE_VTAB_CONSTRAINT_SUPPORT = 1;
  SQLITE_VTAB_INNOCUOUS = 2;
  SQLITE_VTAB_DIRECTONLY = 3;
  SQLITE_VTAB_USES_ALL_SCHEMAS = 4;
  SQLITE_ROLLBACK = 1;
  SQLITE_FAIL = 3;
  SQLITE_REPLACE = 5;
  SQLITE_SCANSTAT_NLOOP = 0;
  SQLITE_SCANSTAT_NVISIT = 1;
  SQLITE_SCANSTAT_EST = 2;
  SQLITE_SCANSTAT_NAME = 3;
  SQLITE_SCANSTAT_EXPLAIN = 4;
  SQLITE_SCANSTAT_SELECTID = 5;
  SQLITE_SCANSTAT_PARENTID = 6;
  SQLITE_SCANSTAT_NCYCLE = 7;
  SQLITE_SCANSTAT_COMPLEX = $0001;
  SQLITE_SERIALIZE_NOCOPY = $001;
  SQLITE_DESERIALIZE_FREEONCLOSE = 1;
  SQLITE_DESERIALIZE_RESIZEABLE = 2;
  SQLITE_DESERIALIZE_READONLY = 4;
  NOT_WITHIN = 0;
  PARTLY_WITHIN = 1;
  FULLY_WITHIN = 2;
  FTS5_TOKENIZE_QUERY = $0001;
  FTS5_TOKENIZE_PREFIX = $0002;
  FTS5_TOKENIZE_DOCUMENT = $0004;
  FTS5_TOKENIZE_AUX = $0008;
  FTS5_TOKEN_COLOCATED = $0001;
  STBI_VERSION = 1;
  STB_RECT_PACK_VERSION = 1;
  STBRP__MAXVAL = $7fffffff;
  STBTT_MACSTYLE_DONTCARE = 0;
  STBTT_MACSTYLE_BOLD = 1;
  STBTT_MACSTYLE_ITALIC = 2;
  STBTT_MACSTYLE_UNDERSCORE = 4;
  STBTT_MACSTYLE_NONE = 8;
  IM_UNICODE_CODEPOINT_MAX = $FFFF;
  IMGUI_HAS_DOCK = 1;
  ImDrawCallback_ResetRenderState = -8;

type
  XAddressFamily = Integer;
  PXAddressFamily = ^XAddressFamily;

const
  X_NET_AF_IPV4 = 1;
  X_NET_AF_IPV6 = 2;

type
  XSocketType = Integer;
  PXSocketType = ^XSocketType;

const
  X_NET_SOCK_STREAM = 1;
  X_NET_SOCK_DGRAM = 2;

type
  C2_TYPE = Integer;
  PC2_TYPE = ^C2_TYPE;

const
  C2_TYPE_NONE = 0;
  C2_TYPE_CIRCLE = 1;
  C2_TYPE_AABB = 2;
  C2_TYPE_CAPSULE = 3;
  C2_TYPE_POLY = 4;

type
  ma_log_level = Integer;
  Pma_log_level = ^ma_log_level;

const
  MA_LOG_LEVEL_DEBUG = 4;
  MA_LOG_LEVEL_INFO = 3;
  MA_LOG_LEVEL_WARNING = 2;
  MA_LOG_LEVEL_ERROR = 1;

type
  _ma_channel_position = Integer;
  P_ma_channel_position = ^_ma_channel_position;

const
  MA_CHANNEL_NONE = 0;
  MA_CHANNEL_MONO = 1;
  MA_CHANNEL_FRONT_LEFT = 2;
  MA_CHANNEL_FRONT_RIGHT = 3;
  MA_CHANNEL_FRONT_CENTER = 4;
  MA_CHANNEL_LFE = 5;
  MA_CHANNEL_BACK_LEFT = 6;
  MA_CHANNEL_BACK_RIGHT = 7;
  MA_CHANNEL_FRONT_LEFT_CENTER = 8;
  MA_CHANNEL_FRONT_RIGHT_CENTER = 9;
  MA_CHANNEL_BACK_CENTER = 10;
  MA_CHANNEL_SIDE_LEFT = 11;
  MA_CHANNEL_SIDE_RIGHT = 12;
  MA_CHANNEL_TOP_CENTER = 13;
  MA_CHANNEL_TOP_FRONT_LEFT = 14;
  MA_CHANNEL_TOP_FRONT_CENTER = 15;
  MA_CHANNEL_TOP_FRONT_RIGHT = 16;
  MA_CHANNEL_TOP_BACK_LEFT = 17;
  MA_CHANNEL_TOP_BACK_CENTER = 18;
  MA_CHANNEL_TOP_BACK_RIGHT = 19;
  MA_CHANNEL_AUX_0 = 20;
  MA_CHANNEL_AUX_1 = 21;
  MA_CHANNEL_AUX_2 = 22;
  MA_CHANNEL_AUX_3 = 23;
  MA_CHANNEL_AUX_4 = 24;
  MA_CHANNEL_AUX_5 = 25;
  MA_CHANNEL_AUX_6 = 26;
  MA_CHANNEL_AUX_7 = 27;
  MA_CHANNEL_AUX_8 = 28;
  MA_CHANNEL_AUX_9 = 29;
  MA_CHANNEL_AUX_10 = 30;
  MA_CHANNEL_AUX_11 = 31;
  MA_CHANNEL_AUX_12 = 32;
  MA_CHANNEL_AUX_13 = 33;
  MA_CHANNEL_AUX_14 = 34;
  MA_CHANNEL_AUX_15 = 35;
  MA_CHANNEL_AUX_16 = 36;
  MA_CHANNEL_AUX_17 = 37;
  MA_CHANNEL_AUX_18 = 38;
  MA_CHANNEL_AUX_19 = 39;
  MA_CHANNEL_AUX_20 = 40;
  MA_CHANNEL_AUX_21 = 41;
  MA_CHANNEL_AUX_22 = 42;
  MA_CHANNEL_AUX_23 = 43;
  MA_CHANNEL_AUX_24 = 44;
  MA_CHANNEL_AUX_25 = 45;
  MA_CHANNEL_AUX_26 = 46;
  MA_CHANNEL_AUX_27 = 47;
  MA_CHANNEL_AUX_28 = 48;
  MA_CHANNEL_AUX_29 = 49;
  MA_CHANNEL_AUX_30 = 50;
  MA_CHANNEL_AUX_31 = 51;
  MA_CHANNEL_LEFT = 2;
  MA_CHANNEL_RIGHT = 3;
  MA_CHANNEL_POSITION_COUNT = 52;

type
  ma_result = Integer;
  Pma_result = ^ma_result;

const
  MA_SUCCESS = 0;
  MA_ERROR = -1;
  MA_INVALID_ARGS = -2;
  MA_INVALID_OPERATION = -3;
  MA_OUT_OF_MEMORY = -4;
  MA_OUT_OF_RANGE = -5;
  MA_ACCESS_DENIED = -6;
  MA_DOES_NOT_EXIST = -7;
  MA_ALREADY_EXISTS = -8;
  MA_TOO_MANY_OPEN_FILES = -9;
  MA_INVALID_FILE = -10;
  MA_TOO_BIG = -11;
  MA_PATH_TOO_LONG = -12;
  MA_NAME_TOO_LONG = -13;
  MA_NOT_DIRECTORY = -14;
  MA_IS_DIRECTORY = -15;
  MA_DIRECTORY_NOT_EMPTY = -16;
  MA_AT_END = -17;
  MA_NO_SPACE = -18;
  MA_BUSY = -19;
  MA_IO_ERROR = -20;
  MA_INTERRUPT = -21;
  MA_UNAVAILABLE = -22;
  MA_ALREADY_IN_USE = -23;
  MA_BAD_ADDRESS = -24;
  MA_BAD_SEEK = -25;
  MA_BAD_PIPE = -26;
  MA_DEADLOCK = -27;
  MA_TOO_MANY_LINKS = -28;
  MA_NOT_IMPLEMENTED = -29;
  MA_NO_MESSAGE = -30;
  MA_BAD_MESSAGE = -31;
  MA_NO_DATA_AVAILABLE = -32;
  MA_INVALID_DATA = -33;
  MA_TIMEOUT = -34;
  MA_NO_NETWORK = -35;
  MA_NOT_UNIQUE = -36;
  MA_NOT_SOCKET = -37;
  MA_NO_ADDRESS = -38;
  MA_BAD_PROTOCOL = -39;
  MA_PROTOCOL_UNAVAILABLE = -40;
  MA_PROTOCOL_NOT_SUPPORTED = -41;
  MA_PROTOCOL_FAMILY_NOT_SUPPORTED = -42;
  MA_ADDRESS_FAMILY_NOT_SUPPORTED = -43;
  MA_SOCKET_NOT_SUPPORTED = -44;
  MA_CONNECTION_RESET = -45;
  MA_ALREADY_CONNECTED = -46;
  MA_NOT_CONNECTED = -47;
  MA_CONNECTION_REFUSED = -48;
  MA_NO_HOST = -49;
  MA_IN_PROGRESS = -50;
  MA_CANCELLED = -51;
  MA_MEMORY_ALREADY_MAPPED = -52;
  MA_CRC_MISMATCH = -100;
  MA_FORMAT_NOT_SUPPORTED = -200;
  MA_DEVICE_TYPE_NOT_SUPPORTED = -201;
  MA_SHARE_MODE_NOT_SUPPORTED = -202;
  MA_NO_BACKEND = -203;
  MA_NO_DEVICE = -204;
  MA_API_NOT_FOUND = -205;
  MA_INVALID_DEVICE_CONFIG = -206;
  MA_LOOP = -207;
  MA_BACKEND_NOT_ENABLED = -208;
  MA_DEVICE_NOT_INITIALIZED = -300;
  MA_DEVICE_ALREADY_INITIALIZED = -301;
  MA_DEVICE_NOT_STARTED = -302;
  MA_DEVICE_NOT_STOPPED = -303;
  MA_FAILED_TO_INIT_BACKEND = -400;
  MA_FAILED_TO_OPEN_BACKEND_DEVICE = -401;
  MA_FAILED_TO_START_BACKEND_DEVICE = -402;
  MA_FAILED_TO_STOP_BACKEND_DEVICE = -403;

type
  ma_stream_format = Integer;
  Pma_stream_format = ^ma_stream_format;

const
  ma_stream_format_pcm = 0;

type
  ma_stream_layout = Integer;
  Pma_stream_layout = ^ma_stream_layout;

const
  ma_stream_layout_interleaved = 0;
  ma_stream_layout_deinterleaved = 1;

type
  ma_dither_mode = Integer;
  Pma_dither_mode = ^ma_dither_mode;

const
  ma_dither_mode_none = 0;
  ma_dither_mode_rectangle = 1;
  ma_dither_mode_triangle = 2;

type
  ma_format = Integer;
  Pma_format = ^ma_format;

const
  ma_format_unknown = 0;
  ma_format_u8 = 1;
  ma_format_s16 = 2;
  ma_format_s24 = 3;
  ma_format_s32 = 4;
  ma_format_f32 = 5;
  ma_format_count = 6;

type
  ma_standard_sample_rate = Integer;
  Pma_standard_sample_rate = ^ma_standard_sample_rate;

const
  ma_standard_sample_rate_48000 = 48000;
  ma_standard_sample_rate_44100 = 44100;
  ma_standard_sample_rate_32000 = 32000;
  ma_standard_sample_rate_24000 = 24000;
  ma_standard_sample_rate_22050 = 22050;
  ma_standard_sample_rate_88200 = 88200;
  ma_standard_sample_rate_96000 = 96000;
  ma_standard_sample_rate_176400 = 176400;
  ma_standard_sample_rate_192000 = 192000;
  ma_standard_sample_rate_16000 = 16000;
  ma_standard_sample_rate_11025 = 11025;
  ma_standard_sample_rate_8000 = 8000;
  ma_standard_sample_rate_352800 = 352800;
  ma_standard_sample_rate_384000 = 384000;
  ma_standard_sample_rate_min = 8000;
  ma_standard_sample_rate_max = 384000;
  ma_standard_sample_rate_count = 14;

type
  ma_channel_mix_mode = Integer;
  Pma_channel_mix_mode = ^ma_channel_mix_mode;

const
  ma_channel_mix_mode_rectangular = 0;
  ma_channel_mix_mode_simple = 1;
  ma_channel_mix_mode_custom_weights = 2;
  ma_channel_mix_mode_default = 0;

type
  ma_standard_channel_map = Integer;
  Pma_standard_channel_map = ^ma_standard_channel_map;

const
  ma_standard_channel_map_microsoft = 0;
  ma_standard_channel_map_alsa = 1;
  ma_standard_channel_map_rfc3551 = 2;
  ma_standard_channel_map_flac = 3;
  ma_standard_channel_map_vorbis = 4;
  ma_standard_channel_map_sound4 = 5;
  ma_standard_channel_map_sndio = 6;
  ma_standard_channel_map_webaudio = 3;
  ma_standard_channel_map_default = 0;

type
  ma_performance_profile = Integer;
  Pma_performance_profile = ^ma_performance_profile;

const
  ma_performance_profile_low_latency = 0;
  ma_performance_profile_conservative = 1;

type
  ma_thread_priority = Integer;
  Pma_thread_priority = ^ma_thread_priority;

const
  ma_thread_priority_idle = -5;
  ma_thread_priority_lowest = -4;
  ma_thread_priority_low = -3;
  ma_thread_priority_normal = -2;
  ma_thread_priority_high = -1;
  ma_thread_priority_highest = 0;
  ma_thread_priority_realtime = 1;
  ma_thread_priority_default = 0;

type
  ma_pan_mode = Integer;
  Pma_pan_mode = ^ma_pan_mode;

const
  ma_pan_mode_balance = 0;
  ma_pan_mode_pan = 1;

type
  ma_attenuation_model = Integer;
  Pma_attenuation_model = ^ma_attenuation_model;

const
  ma_attenuation_model_none = 0;
  ma_attenuation_model_inverse = 1;
  ma_attenuation_model_linear = 2;
  ma_attenuation_model_exponential = 3;

type
  ma_positioning = Integer;
  Pma_positioning = ^ma_positioning;

const
  ma_positioning_absolute = 0;
  ma_positioning_relative = 1;

type
  ma_handedness = Integer;
  Pma_handedness = ^ma_handedness;

const
  ma_handedness_right = 0;
  ma_handedness_left = 1;

type
  ma_resample_algorithm = Integer;
  Pma_resample_algorithm = ^ma_resample_algorithm;

const
  ma_resample_algorithm_linear = 0;
  ma_resample_algorithm_custom = 1;

type
  ma_channel_conversion_path = Integer;
  Pma_channel_conversion_path = ^ma_channel_conversion_path;

const
  ma_channel_conversion_path_unknown = 0;
  ma_channel_conversion_path_passthrough = 1;
  ma_channel_conversion_path_mono_out = 2;
  ma_channel_conversion_path_mono_in = 3;
  ma_channel_conversion_path_shuffle = 4;
  ma_channel_conversion_path_weights = 5;

type
  ma_mono_expansion_mode = Integer;
  Pma_mono_expansion_mode = ^ma_mono_expansion_mode;

const
  ma_mono_expansion_mode_duplicate = 0;
  ma_mono_expansion_mode_average = 1;
  ma_mono_expansion_mode_stereo_only = 2;
  ma_mono_expansion_mode_default = 0;

type
  ma_data_converter_execution_path = Integer;
  Pma_data_converter_execution_path = ^ma_data_converter_execution_path;

const
  ma_data_converter_execution_path_passthrough = 0;
  ma_data_converter_execution_path_format_only = 1;
  ma_data_converter_execution_path_channels_only = 2;
  ma_data_converter_execution_path_resample_only = 3;
  ma_data_converter_execution_path_resample_first = 4;
  ma_data_converter_execution_path_channels_first = 5;

type
  ma_job_type = Integer;
  Pma_job_type = ^ma_job_type;

const
  MA_JOB_TYPE_QUIT = 0;
  MA_JOB_TYPE_CUSTOM = 1;
  MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_BUFFER_NODE = 2;
  MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_BUFFER_NODE = 3;
  MA_JOB_TYPE_RESOURCE_MANAGER_PAGE_DATA_BUFFER_NODE = 4;
  MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_BUFFER = 5;
  MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_BUFFER = 6;
  MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_STREAM = 7;
  MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_STREAM = 8;
  MA_JOB_TYPE_RESOURCE_MANAGER_PAGE_DATA_STREAM = 9;
  MA_JOB_TYPE_RESOURCE_MANAGER_SEEK_DATA_STREAM = 10;
  MA_JOB_TYPE_DEVICE_AAUDIO_REROUTE = 11;
  MA_JOB_TYPE_COUNT = 12;

type
  ma_job_queue_flags = Integer;
  Pma_job_queue_flags = ^ma_job_queue_flags;

const
  MA_JOB_QUEUE_FLAG_NON_BLOCKING = 1;

const
  MA_JOB_TYPE_RESOURCE_MANAGER_QUEUE_FLAG_NON_BLOCKING = MA_JOB_QUEUE_FLAG_NON_BLOCKING;

type
  ma_device_state = Integer;
  Pma_device_state = ^ma_device_state;

const
  ma_device_state_uninitialized = 0;
  ma_device_state_stopped = 1;
  ma_device_state_started = 2;
  ma_device_state_starting = 3;
  ma_device_state_stopping = 4;

type
  ma_backend = Integer;
  Pma_backend = ^ma_backend;

const
  ma_backend_wasapi = 0;
  ma_backend_dsound = 1;
  ma_backend_winmm = 2;
  ma_backend_coreaudio = 3;
  ma_backend_sndio = 4;
  ma_backend_audio4 = 5;
  ma_backend_oss = 6;
  ma_backend_pulseaudio = 7;
  ma_backend_alsa = 8;
  ma_backend_jack = 9;
  ma_backend_aaudio = 10;
  ma_backend_opensl = 11;
  ma_backend_webaudio = 12;
  ma_backend_custom = 13;
  ma_backend_null = 14;

type
  ma_device_notification_type = Integer;
  Pma_device_notification_type = ^ma_device_notification_type;

const
  ma_device_notification_type_started = 0;
  ma_device_notification_type_stopped = 1;
  ma_device_notification_type_rerouted = 2;
  ma_device_notification_type_interruption_began = 3;
  ma_device_notification_type_interruption_ended = 4;
  ma_device_notification_type_unlocked = 5;

type
  ma_device_type = Integer;
  Pma_device_type = ^ma_device_type;

const
  ma_device_type_playback = 1;
  ma_device_type_capture = 2;
  ma_device_type_duplex = 3;
  ma_device_type_loopback = 4;

type
  ma_share_mode = Integer;
  Pma_share_mode = ^ma_share_mode;

const
  ma_share_mode_shared = 0;
  ma_share_mode_exclusive = 1;

type
  ma_ios_session_category = Integer;
  Pma_ios_session_category = ^ma_ios_session_category;

const
  ma_ios_session_category_default = 0;
  ma_ios_session_category_none = 1;
  ma_ios_session_category_ambient = 2;
  ma_ios_session_category_solo_ambient = 3;
  ma_ios_session_category_playback = 4;
  ma_ios_session_category_record = 5;
  ma_ios_session_category_play_and_record = 6;
  ma_ios_session_category_multi_route = 7;

type
  ma_ios_session_category_option = Integer;
  Pma_ios_session_category_option = ^ma_ios_session_category_option;

const
  ma_ios_session_category_option_mix_with_others = 1;
  ma_ios_session_category_option_duck_others = 2;
  ma_ios_session_category_option_allow_bluetooth = 4;
  ma_ios_session_category_option_default_to_speaker = 8;
  ma_ios_session_category_option_interrupt_spoken_audio_and_mix_with_others = 17;
  ma_ios_session_category_option_allow_bluetooth_a2dp = 32;
  ma_ios_session_category_option_allow_air_play = 64;

type
  ma_opensl_stream_type = Integer;
  Pma_opensl_stream_type = ^ma_opensl_stream_type;

const
  ma_opensl_stream_type_default = 0;
  ma_opensl_stream_type_voice = 1;
  ma_opensl_stream_type_system = 2;
  ma_opensl_stream_type_ring = 3;
  ma_opensl_stream_type_media = 4;
  ma_opensl_stream_type_alarm = 5;
  ma_opensl_stream_type_notification = 6;

type
  ma_opensl_recording_preset = Integer;
  Pma_opensl_recording_preset = ^ma_opensl_recording_preset;

const
  ma_opensl_recording_preset_default = 0;
  ma_opensl_recording_preset_generic = 1;
  ma_opensl_recording_preset_camcorder = 2;
  ma_opensl_recording_preset_voice_recognition = 3;
  ma_opensl_recording_preset_voice_communication = 4;
  ma_opensl_recording_preset_voice_unprocessed = 5;

type
  ma_wasapi_usage = Integer;
  Pma_wasapi_usage = ^ma_wasapi_usage;

const
  ma_wasapi_usage_default = 0;
  ma_wasapi_usage_games = 1;
  ma_wasapi_usage_pro_audio = 2;

type
  ma_aaudio_usage = Integer;
  Pma_aaudio_usage = ^ma_aaudio_usage;

const
  ma_aaudio_usage_default = 0;
  ma_aaudio_usage_media = 1;
  ma_aaudio_usage_voice_communication = 2;
  ma_aaudio_usage_voice_communication_signalling = 3;
  ma_aaudio_usage_alarm = 4;
  ma_aaudio_usage_notification = 5;
  ma_aaudio_usage_notification_ringtone = 6;
  ma_aaudio_usage_notification_event = 7;
  ma_aaudio_usage_assistance_accessibility = 8;
  ma_aaudio_usage_assistance_navigation_guidance = 9;
  ma_aaudio_usage_assistance_sonification = 10;
  ma_aaudio_usage_game = 11;
  ma_aaudio_usage_assitant = 12;
  ma_aaudio_usage_emergency = 13;
  ma_aaudio_usage_safety = 14;
  ma_aaudio_usage_vehicle_status = 15;
  ma_aaudio_usage_announcement = 16;

type
  ma_aaudio_content_type = Integer;
  Pma_aaudio_content_type = ^ma_aaudio_content_type;

const
  ma_aaudio_content_type_default = 0;
  ma_aaudio_content_type_speech = 1;
  ma_aaudio_content_type_music = 2;
  ma_aaudio_content_type_movie = 3;
  ma_aaudio_content_type_sonification = 4;

type
  ma_aaudio_input_preset = Integer;
  Pma_aaudio_input_preset = ^ma_aaudio_input_preset;

const
  ma_aaudio_input_preset_default = 0;
  ma_aaudio_input_preset_generic = 1;
  ma_aaudio_input_preset_camcorder = 2;
  ma_aaudio_input_preset_voice_recognition = 3;
  ma_aaudio_input_preset_voice_communication = 4;
  ma_aaudio_input_preset_unprocessed = 5;
  ma_aaudio_input_preset_voice_performance = 6;

type
  ma_aaudio_allowed_capture_policy = Integer;
  Pma_aaudio_allowed_capture_policy = ^ma_aaudio_allowed_capture_policy;

const
  ma_aaudio_allow_capture_default = 0;
  ma_aaudio_allow_capture_by_all = 1;
  ma_aaudio_allow_capture_by_system = 2;
  ma_aaudio_allow_capture_by_none = 3;

type
  ma_open_mode_flags = Integer;
  Pma_open_mode_flags = ^ma_open_mode_flags;

const
  MA_OPEN_MODE_READ = 1;
  MA_OPEN_MODE_WRITE = 2;

type
  ma_seek_origin = Integer;
  Pma_seek_origin = ^ma_seek_origin;

const
  ma_seek_origin_start = 0;
  ma_seek_origin_current = 1;
  ma_seek_origin_end = 2;

type
  ma_encoding_format = Integer;
  Pma_encoding_format = ^ma_encoding_format;

const
  ma_encoding_format_unknown = 0;
  ma_encoding_format_wav = 1;
  ma_encoding_format_flac = 2;
  ma_encoding_format_mp3 = 3;
  ma_encoding_format_vorbis = 4;

type
  ma_waveform_type = Integer;
  Pma_waveform_type = ^ma_waveform_type;

const
  ma_waveform_type_sine = 0;
  ma_waveform_type_square = 1;
  ma_waveform_type_triangle = 2;
  ma_waveform_type_sawtooth = 3;

type
  ma_noise_type = Integer;
  Pma_noise_type = ^ma_noise_type;

const
  ma_noise_type_white = 0;
  ma_noise_type_pink = 1;
  ma_noise_type_brownian = 2;

type
  ma_resource_manager_data_source_flags = Integer;
  Pma_resource_manager_data_source_flags = ^ma_resource_manager_data_source_flags;

const
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_STREAM = 1;
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_DECODE = 2;
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_ASYNC = 4;
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_WAIT_INIT = 8;
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_UNKNOWN_LENGTH = 16;
  MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_LOOPING = 32;

type
  ma_resource_manager_flags = Integer;
  Pma_resource_manager_flags = ^ma_resource_manager_flags;

const
  MA_RESOURCE_MANAGER_FLAG_NON_BLOCKING = 1;
  MA_RESOURCE_MANAGER_FLAG_NO_THREADING = 2;

type
  ma_resource_manager_data_supply_type = Integer;
  Pma_resource_manager_data_supply_type = ^ma_resource_manager_data_supply_type;

const
  ma_resource_manager_data_supply_type_unknown = 0;
  ma_resource_manager_data_supply_type_encoded = 1;
  ma_resource_manager_data_supply_type_decoded = 2;
  ma_resource_manager_data_supply_type_decoded_paged = 3;

type
  ma_node_flags = Integer;
  Pma_node_flags = ^ma_node_flags;

const
  MA_NODE_FLAG_PASSTHROUGH = 1;
  MA_NODE_FLAG_CONTINUOUS_PROCESSING = 2;
  MA_NODE_FLAG_ALLOW_NULL_INPUT = 4;
  MA_NODE_FLAG_DIFFERENT_PROCESSING_RATES = 8;
  MA_NODE_FLAG_SILENT_OUTPUT = 16;

type
  ma_node_state = Integer;
  Pma_node_state = ^ma_node_state;

const
  ma_node_state_started = 0;
  ma_node_state_stopped = 1;

type
  ma_sound_flags = Integer;
  Pma_sound_flags = ^ma_sound_flags;

const
  MA_SOUND_FLAG_STREAM = 1;
  MA_SOUND_FLAG_DECODE = 2;
  MA_SOUND_FLAG_ASYNC = 4;
  MA_SOUND_FLAG_WAIT_INIT = 8;
  MA_SOUND_FLAG_UNKNOWN_LENGTH = 16;
  MA_SOUND_FLAG_LOOPING = 32;
  MA_SOUND_FLAG_NO_DEFAULT_ATTACHMENT = 4096;
  MA_SOUND_FLAG_NO_PITCH = 8192;
  MA_SOUND_FLAG_NO_SPATIALIZATION = 16384;

type
  ma_engine_node_type = Integer;
  Pma_engine_node_type = ^ma_engine_node_type;

const
  ma_engine_node_type_sound = 0;
  ma_engine_node_type_group = 1;

const
  STBI_default = 0;
  STBI_grey = 1;
  STBI_grey_alpha = 2;
  STBI_rgb = 3;
  STBI_rgb_alpha = 4;

const
  STBRP_HEURISTIC_Skyline_default = 0;
  STBRP_HEURISTIC_Skyline_BL_sortHeight = 0;
  STBRP_HEURISTIC_Skyline_BF_sortHeight = 1;

const
  STBTT_vmove = 1;
  STBTT_vline = 2;
  STBTT_vcurve = 3;
  STBTT_vcubic = 4;

const
  STBTT_PLATFORM_ID_UNICODE = 0;
  STBTT_PLATFORM_ID_MAC = 1;
  STBTT_PLATFORM_ID_ISO = 2;
  STBTT_PLATFORM_ID_MICROSOFT = 3;

const
  STBTT_UNICODE_EID_UNICODE_1_0 = 0;
  STBTT_UNICODE_EID_UNICODE_1_1 = 1;
  STBTT_UNICODE_EID_ISO_10646 = 2;
  STBTT_UNICODE_EID_UNICODE_2_0_BMP = 3;
  STBTT_UNICODE_EID_UNICODE_2_0_FULL = 4;

const
  STBTT_MS_EID_SYMBOL = 0;
  STBTT_MS_EID_UNICODE_BMP = 1;
  STBTT_MS_EID_SHIFTJIS = 2;
  STBTT_MS_EID_UNICODE_FULL = 10;

const
  STBTT_MAC_EID_ROMAN = 0;
  STBTT_MAC_EID_ARABIC = 4;
  STBTT_MAC_EID_JAPANESE = 1;
  STBTT_MAC_EID_HEBREW = 5;
  STBTT_MAC_EID_CHINESE_TRAD = 2;
  STBTT_MAC_EID_GREEK = 6;
  STBTT_MAC_EID_KOREAN = 3;
  STBTT_MAC_EID_RUSSIAN = 7;

const
  STBTT_MS_LANG_ENGLISH = 1033;
  STBTT_MS_LANG_ITALIAN = 1040;
  STBTT_MS_LANG_CHINESE = 2052;
  STBTT_MS_LANG_JAPANESE = 1041;
  STBTT_MS_LANG_DUTCH = 1043;
  STBTT_MS_LANG_KOREAN = 1042;
  STBTT_MS_LANG_FRENCH = 1036;
  STBTT_MS_LANG_RUSSIAN = 1049;
  STBTT_MS_LANG_GERMAN = 1031;
  STBTT_MS_LANG_SPANISH = 1033;
  STBTT_MS_LANG_HEBREW = 1037;
  STBTT_MS_LANG_SWEDISH = 1053;

const
  STBTT_MAC_LANG_ENGLISH = 0;
  STBTT_MAC_LANG_JAPANESE = 11;
  STBTT_MAC_LANG_ARABIC = 12;
  STBTT_MAC_LANG_KOREAN = 23;
  STBTT_MAC_LANG_DUTCH = 4;
  STBTT_MAC_LANG_RUSSIAN = 32;
  STBTT_MAC_LANG_FRENCH = 1;
  STBTT_MAC_LANG_SPANISH = 6;
  STBTT_MAC_LANG_GERMAN = 2;
  STBTT_MAC_LANG_SWEDISH = 5;
  STBTT_MAC_LANG_HEBREW = 10;
  STBTT_MAC_LANG_CHINESE_SIMPLIFIED = 33;
  STBTT_MAC_LANG_ITALIAN = 3;
  STBTT_MAC_LANG_CHINESE_TRAD = 19;

type
  ImGuiWindowFlags_ = Integer;
  PImGuiWindowFlags_ = ^ImGuiWindowFlags_;

const
  ImGuiWindowFlags_None = 0;
  ImGuiWindowFlags_NoTitleBar = 1;
  ImGuiWindowFlags_NoResize = 2;
  ImGuiWindowFlags_NoMove = 4;
  ImGuiWindowFlags_NoScrollbar = 8;
  ImGuiWindowFlags_NoScrollWithMouse = 16;
  ImGuiWindowFlags_NoCollapse = 32;
  ImGuiWindowFlags_AlwaysAutoResize = 64;
  ImGuiWindowFlags_NoBackground = 128;
  ImGuiWindowFlags_NoSavedSettings = 256;
  ImGuiWindowFlags_NoMouseInputs = 512;
  ImGuiWindowFlags_MenuBar = 1024;
  ImGuiWindowFlags_HorizontalScrollbar = 2048;
  ImGuiWindowFlags_NoFocusOnAppearing = 4096;
  ImGuiWindowFlags_NoBringToFrontOnFocus = 8192;
  ImGuiWindowFlags_AlwaysVerticalScrollbar = 16384;
  ImGuiWindowFlags_AlwaysHorizontalScrollbar = 32768;
  ImGuiWindowFlags_NoNavInputs = 65536;
  ImGuiWindowFlags_NoNavFocus = 131072;
  ImGuiWindowFlags_UnsavedDocument = 262144;
  ImGuiWindowFlags_NoDocking = 524288;
  ImGuiWindowFlags_NoNav = 196608;
  ImGuiWindowFlags_NoDecoration = 43;
  ImGuiWindowFlags_NoInputs = 197120;
  ImGuiWindowFlags_DockNodeHost = 8388608;
  ImGuiWindowFlags_ChildWindow = 16777216;
  ImGuiWindowFlags_Tooltip = 33554432;
  ImGuiWindowFlags_Popup = 67108864;
  ImGuiWindowFlags_Modal = 134217728;
  ImGuiWindowFlags_ChildMenu = 268435456;

type
  ImGuiChildFlags_ = Integer;
  PImGuiChildFlags_ = ^ImGuiChildFlags_;

const
  ImGuiChildFlags_None = 0;
  ImGuiChildFlags_Borders = 1;
  ImGuiChildFlags_AlwaysUseWindowPadding = 2;
  ImGuiChildFlags_ResizeX = 4;
  ImGuiChildFlags_ResizeY = 8;
  ImGuiChildFlags_AutoResizeX = 16;
  ImGuiChildFlags_AutoResizeY = 32;
  ImGuiChildFlags_AlwaysAutoResize = 64;
  ImGuiChildFlags_FrameStyle = 128;
  ImGuiChildFlags_NavFlattened = 256;

type
  ImGuiItemFlags_ = Integer;
  PImGuiItemFlags_ = ^ImGuiItemFlags_;

const
  ImGuiItemFlags_None = 0;
  ImGuiItemFlags_NoTabStop = 1;
  ImGuiItemFlags_NoNav = 2;
  ImGuiItemFlags_NoNavDefaultFocus = 4;
  ImGuiItemFlags_ButtonRepeat = 8;
  ImGuiItemFlags_AutoClosePopups = 16;
  ImGuiItemFlags_AllowDuplicateId = 32;

type
  ImGuiInputTextFlags_ = Integer;
  PImGuiInputTextFlags_ = ^ImGuiInputTextFlags_;

const
  ImGuiInputTextFlags_None = 0;
  ImGuiInputTextFlags_CharsDecimal = 1;
  ImGuiInputTextFlags_CharsHexadecimal = 2;
  ImGuiInputTextFlags_CharsScientific = 4;
  ImGuiInputTextFlags_CharsUppercase = 8;
  ImGuiInputTextFlags_CharsNoBlank = 16;
  ImGuiInputTextFlags_AllowTabInput = 32;
  ImGuiInputTextFlags_EnterReturnsTrue = 64;
  ImGuiInputTextFlags_EscapeClearsAll = 128;
  ImGuiInputTextFlags_CtrlEnterForNewLine = 256;
  ImGuiInputTextFlags_ReadOnly = 512;
  ImGuiInputTextFlags_Password = 1024;
  ImGuiInputTextFlags_AlwaysOverwrite = 2048;
  ImGuiInputTextFlags_AutoSelectAll = 4096;
  ImGuiInputTextFlags_ParseEmptyRefVal = 8192;
  ImGuiInputTextFlags_DisplayEmptyRefVal = 16384;
  ImGuiInputTextFlags_NoHorizontalScroll = 32768;
  ImGuiInputTextFlags_NoUndoRedo = 65536;
  ImGuiInputTextFlags_ElideLeft = 131072;
  ImGuiInputTextFlags_CallbackCompletion = 262144;
  ImGuiInputTextFlags_CallbackHistory = 524288;
  ImGuiInputTextFlags_CallbackAlways = 1048576;
  ImGuiInputTextFlags_CallbackCharFilter = 2097152;
  ImGuiInputTextFlags_CallbackResize = 4194304;
  ImGuiInputTextFlags_CallbackEdit = 8388608;

type
  ImGuiTreeNodeFlags_ = Integer;
  PImGuiTreeNodeFlags_ = ^ImGuiTreeNodeFlags_;

const
  ImGuiTreeNodeFlags_None = 0;
  ImGuiTreeNodeFlags_Selected = 1;
  ImGuiTreeNodeFlags_Framed = 2;
  ImGuiTreeNodeFlags_AllowOverlap = 4;
  ImGuiTreeNodeFlags_NoTreePushOnOpen = 8;
  ImGuiTreeNodeFlags_NoAutoOpenOnLog = 16;
  ImGuiTreeNodeFlags_DefaultOpen = 32;
  ImGuiTreeNodeFlags_OpenOnDoubleClick = 64;
  ImGuiTreeNodeFlags_OpenOnArrow = 128;
  ImGuiTreeNodeFlags_Leaf = 256;
  ImGuiTreeNodeFlags_Bullet = 512;
  ImGuiTreeNodeFlags_FramePadding = 1024;
  ImGuiTreeNodeFlags_SpanAvailWidth = 2048;
  ImGuiTreeNodeFlags_SpanFullWidth = 4096;
  ImGuiTreeNodeFlags_SpanLabelWidth = 8192;
  ImGuiTreeNodeFlags_SpanAllColumns = 16384;
  ImGuiTreeNodeFlags_LabelSpanAllColumns = 32768;
  ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 131072;
  ImGuiTreeNodeFlags_CollapsingHeader = 26;

type
  ImGuiPopupFlags_ = Integer;
  PImGuiPopupFlags_ = ^ImGuiPopupFlags_;

const
  ImGuiPopupFlags_None = 0;
  ImGuiPopupFlags_MouseButtonLeft = 0;
  ImGuiPopupFlags_MouseButtonRight = 1;
  ImGuiPopupFlags_MouseButtonMiddle = 2;
  ImGuiPopupFlags_MouseButtonMask_ = 31;
  ImGuiPopupFlags_MouseButtonDefault_ = 1;
  ImGuiPopupFlags_NoReopen = 32;
  ImGuiPopupFlags_NoOpenOverExistingPopup = 128;
  ImGuiPopupFlags_NoOpenOverItems = 256;
  ImGuiPopupFlags_AnyPopupId = 1024;
  ImGuiPopupFlags_AnyPopupLevel = 2048;
  ImGuiPopupFlags_AnyPopup = 3072;

type
  ImGuiSelectableFlags_ = Integer;
  PImGuiSelectableFlags_ = ^ImGuiSelectableFlags_;

const
  ImGuiSelectableFlags_None = 0;
  ImGuiSelectableFlags_NoAutoClosePopups = 1;
  ImGuiSelectableFlags_SpanAllColumns = 2;
  ImGuiSelectableFlags_AllowDoubleClick = 4;
  ImGuiSelectableFlags_Disabled = 8;
  ImGuiSelectableFlags_AllowOverlap = 16;
  ImGuiSelectableFlags_Highlight = 32;

type
  ImGuiComboFlags_ = Integer;
  PImGuiComboFlags_ = ^ImGuiComboFlags_;

const
  ImGuiComboFlags_None = 0;
  ImGuiComboFlags_PopupAlignLeft = 1;
  ImGuiComboFlags_HeightSmall = 2;
  ImGuiComboFlags_HeightRegular = 4;
  ImGuiComboFlags_HeightLarge = 8;
  ImGuiComboFlags_HeightLargest = 16;
  ImGuiComboFlags_NoArrowButton = 32;
  ImGuiComboFlags_NoPreview = 64;
  ImGuiComboFlags_WidthFitPreview = 128;
  ImGuiComboFlags_HeightMask_ = 30;

type
  ImGuiTabBarFlags_ = Integer;
  PImGuiTabBarFlags_ = ^ImGuiTabBarFlags_;

const
  ImGuiTabBarFlags_None = 0;
  ImGuiTabBarFlags_Reorderable = 1;
  ImGuiTabBarFlags_AutoSelectNewTabs = 2;
  ImGuiTabBarFlags_TabListPopupButton = 4;
  ImGuiTabBarFlags_NoCloseWithMiddleMouseButton = 8;
  ImGuiTabBarFlags_NoTabListScrollingButtons = 16;
  ImGuiTabBarFlags_NoTooltip = 32;
  ImGuiTabBarFlags_DrawSelectedOverline = 64;
  ImGuiTabBarFlags_FittingPolicyResizeDown = 128;
  ImGuiTabBarFlags_FittingPolicyScroll = 256;
  ImGuiTabBarFlags_FittingPolicyMask_ = 384;
  ImGuiTabBarFlags_FittingPolicyDefault_ = 128;

type
  ImGuiTabItemFlags_ = Integer;
  PImGuiTabItemFlags_ = ^ImGuiTabItemFlags_;

const
  ImGuiTabItemFlags_None = 0;
  ImGuiTabItemFlags_UnsavedDocument = 1;
  ImGuiTabItemFlags_SetSelected = 2;
  ImGuiTabItemFlags_NoCloseWithMiddleMouseButton = 4;
  ImGuiTabItemFlags_NoPushId = 8;
  ImGuiTabItemFlags_NoTooltip = 16;
  ImGuiTabItemFlags_NoReorder = 32;
  ImGuiTabItemFlags_Leading = 64;
  ImGuiTabItemFlags_Trailing = 128;
  ImGuiTabItemFlags_NoAssumedClosure = 256;

type
  ImGuiFocusedFlags_ = Integer;
  PImGuiFocusedFlags_ = ^ImGuiFocusedFlags_;

const
  ImGuiFocusedFlags_None = 0;
  ImGuiFocusedFlags_ChildWindows = 1;
  ImGuiFocusedFlags_RootWindow = 2;
  ImGuiFocusedFlags_AnyWindow = 4;
  ImGuiFocusedFlags_NoPopupHierarchy = 8;
  ImGuiFocusedFlags_DockHierarchy = 16;
  ImGuiFocusedFlags_RootAndChildWindows = 3;

type
  ImGuiHoveredFlags_ = Integer;
  PImGuiHoveredFlags_ = ^ImGuiHoveredFlags_;

const
  ImGuiHoveredFlags_None = 0;
  ImGuiHoveredFlags_ChildWindows = 1;
  ImGuiHoveredFlags_RootWindow = 2;
  ImGuiHoveredFlags_AnyWindow = 4;
  ImGuiHoveredFlags_NoPopupHierarchy = 8;
  ImGuiHoveredFlags_DockHierarchy = 16;
  ImGuiHoveredFlags_AllowWhenBlockedByPopup = 32;
  ImGuiHoveredFlags_AllowWhenBlockedByActiveItem = 128;
  ImGuiHoveredFlags_AllowWhenOverlappedByItem = 256;
  ImGuiHoveredFlags_AllowWhenOverlappedByWindow = 512;
  ImGuiHoveredFlags_AllowWhenDisabled = 1024;
  ImGuiHoveredFlags_NoNavOverride = 2048;
  ImGuiHoveredFlags_AllowWhenOverlapped = 768;
  ImGuiHoveredFlags_RectOnly = 928;
  ImGuiHoveredFlags_RootAndChildWindows = 3;
  ImGuiHoveredFlags_ForTooltip = 4096;
  ImGuiHoveredFlags_Stationary = 8192;
  ImGuiHoveredFlags_DelayNone = 16384;
  ImGuiHoveredFlags_DelayShort = 32768;
  ImGuiHoveredFlags_DelayNormal = 65536;
  ImGuiHoveredFlags_NoSharedDelay = 131072;

type
  ImGuiDockNodeFlags_ = Integer;
  PImGuiDockNodeFlags_ = ^ImGuiDockNodeFlags_;

const
  ImGuiDockNodeFlags_None = 0;
  ImGuiDockNodeFlags_KeepAliveOnly = 1;
  ImGuiDockNodeFlags_NoDockingOverCentralNode = 4;
  ImGuiDockNodeFlags_PassthruCentralNode = 8;
  ImGuiDockNodeFlags_NoDockingSplit = 16;
  ImGuiDockNodeFlags_NoResize = 32;
  ImGuiDockNodeFlags_AutoHideTabBar = 64;
  ImGuiDockNodeFlags_NoUndocking = 128;

type
  ImGuiDragDropFlags_ = Integer;
  PImGuiDragDropFlags_ = ^ImGuiDragDropFlags_;

const
  ImGuiDragDropFlags_None = 0;
  ImGuiDragDropFlags_SourceNoPreviewTooltip = 1;
  ImGuiDragDropFlags_SourceNoDisableHover = 2;
  ImGuiDragDropFlags_SourceNoHoldToOpenOthers = 4;
  ImGuiDragDropFlags_SourceAllowNullID = 8;
  ImGuiDragDropFlags_SourceExtern = 16;
  ImGuiDragDropFlags_PayloadAutoExpire = 32;
  ImGuiDragDropFlags_PayloadNoCrossContext = 64;
  ImGuiDragDropFlags_PayloadNoCrossProcess = 128;
  ImGuiDragDropFlags_AcceptBeforeDelivery = 1024;
  ImGuiDragDropFlags_AcceptNoDrawDefaultRect = 2048;
  ImGuiDragDropFlags_AcceptNoPreviewTooltip = 4096;
  ImGuiDragDropFlags_AcceptPeekOnly = 3072;

type
  ImGuiDataType_ = Integer;
  PImGuiDataType_ = ^ImGuiDataType_;

const
  ImGuiDataType_S8 = 0;
  ImGuiDataType_U8 = 1;
  ImGuiDataType_S16 = 2;
  ImGuiDataType_U16 = 3;
  ImGuiDataType_S32 = 4;
  ImGuiDataType_U32 = 5;
  ImGuiDataType_S64 = 6;
  ImGuiDataType_U64 = 7;
  ImGuiDataType_Float = 8;
  ImGuiDataType_Double = 9;
  ImGuiDataType_Bool = 10;
  ImGuiDataType_String = 11;
  ImGuiDataType_COUNT = 12;

type
  ImGuiDir = Integer;
  PImGuiDir = ^ImGuiDir;

const
  ImGuiDir_None = -1;
  ImGuiDir_Left = 0;
  ImGuiDir_Right = 1;
  ImGuiDir_Up = 2;
  ImGuiDir_Down = 3;
  ImGuiDir_COUNT = 4;

type
  ImGuiSortDirection = Integer;
  PImGuiSortDirection = ^ImGuiSortDirection;

const
  ImGuiSortDirection_None = 0;
  ImGuiSortDirection_Ascending = 1;
  ImGuiSortDirection_Descending = 2;

type
  ImGuiKey = Integer;
  PImGuiKey = ^ImGuiKey;

const
  ImGuiKey_None = 0;
  ImGuiKey_NamedKey_BEGIN = 512;
  ImGuiKey_Tab = 512;
  ImGuiKey_LeftArrow = 513;
  ImGuiKey_RightArrow = 514;
  ImGuiKey_UpArrow = 515;
  ImGuiKey_DownArrow = 516;
  ImGuiKey_PageUp = 517;
  ImGuiKey_PageDown = 518;
  ImGuiKey_Home = 519;
  ImGuiKey_End = 520;
  ImGuiKey_Insert = 521;
  ImGuiKey_Delete = 522;
  ImGuiKey_Backspace = 523;
  ImGuiKey_Space = 524;
  ImGuiKey_Enter = 525;
  ImGuiKey_Escape = 526;
  ImGuiKey_LeftCtrl = 527;
  ImGuiKey_LeftShift = 528;
  ImGuiKey_LeftAlt = 529;
  ImGuiKey_LeftSuper = 530;
  ImGuiKey_RightCtrl = 531;
  ImGuiKey_RightShift = 532;
  ImGuiKey_RightAlt = 533;
  ImGuiKey_RightSuper = 534;
  ImGuiKey_Menu = 535;
  ImGuiKey_0 = 536;
  ImGuiKey_1 = 537;
  ImGuiKey_2 = 538;
  ImGuiKey_3 = 539;
  ImGuiKey_4 = 540;
  ImGuiKey_5 = 541;
  ImGuiKey_6 = 542;
  ImGuiKey_7 = 543;
  ImGuiKey_8 = 544;
  ImGuiKey_9 = 545;
  ImGuiKey_A = 546;
  ImGuiKey_B = 547;
  ImGuiKey_C = 548;
  ImGuiKey_D = 549;
  ImGuiKey_E = 550;
  ImGuiKey_F = 551;
  ImGuiKey_G = 552;
  ImGuiKey_H = 553;
  ImGuiKey_I = 554;
  ImGuiKey_J = 555;
  ImGuiKey_K = 556;
  ImGuiKey_L = 557;
  ImGuiKey_M = 558;
  ImGuiKey_N = 559;
  ImGuiKey_O = 560;
  ImGuiKey_P = 561;
  ImGuiKey_Q = 562;
  ImGuiKey_R = 563;
  ImGuiKey_S = 564;
  ImGuiKey_T = 565;
  ImGuiKey_U = 566;
  ImGuiKey_V = 567;
  ImGuiKey_W = 568;
  ImGuiKey_X = 569;
  ImGuiKey_Y = 570;
  ImGuiKey_Z = 571;
  ImGuiKey_F1 = 572;
  ImGuiKey_F2 = 573;
  ImGuiKey_F3 = 574;
  ImGuiKey_F4 = 575;
  ImGuiKey_F5 = 576;
  ImGuiKey_F6 = 577;
  ImGuiKey_F7 = 578;
  ImGuiKey_F8 = 579;
  ImGuiKey_F9 = 580;
  ImGuiKey_F10 = 581;
  ImGuiKey_F11 = 582;
  ImGuiKey_F12 = 583;
  ImGuiKey_F13 = 584;
  ImGuiKey_F14 = 585;
  ImGuiKey_F15 = 586;
  ImGuiKey_F16 = 587;
  ImGuiKey_F17 = 588;
  ImGuiKey_F18 = 589;
  ImGuiKey_F19 = 590;
  ImGuiKey_F20 = 591;
  ImGuiKey_F21 = 592;
  ImGuiKey_F22 = 593;
  ImGuiKey_F23 = 594;
  ImGuiKey_F24 = 595;
  ImGuiKey_Apostrophe = 596;
  ImGuiKey_Comma = 597;
  ImGuiKey_Minus = 598;
  ImGuiKey_Period = 599;
  ImGuiKey_Slash = 600;
  ImGuiKey_Semicolon = 601;
  ImGuiKey_Equal = 602;
  ImGuiKey_LeftBracket = 603;
  ImGuiKey_Backslash = 604;
  ImGuiKey_RightBracket = 605;
  ImGuiKey_GraveAccent = 606;
  ImGuiKey_CapsLock = 607;
  ImGuiKey_ScrollLock = 608;
  ImGuiKey_NumLock = 609;
  ImGuiKey_PrintScreen = 610;
  ImGuiKey_Pause = 611;
  ImGuiKey_Keypad0 = 612;
  ImGuiKey_Keypad1 = 613;
  ImGuiKey_Keypad2 = 614;
  ImGuiKey_Keypad3 = 615;
  ImGuiKey_Keypad4 = 616;
  ImGuiKey_Keypad5 = 617;
  ImGuiKey_Keypad6 = 618;
  ImGuiKey_Keypad7 = 619;
  ImGuiKey_Keypad8 = 620;
  ImGuiKey_Keypad9 = 621;
  ImGuiKey_KeypadDecimal = 622;
  ImGuiKey_KeypadDivide = 623;
  ImGuiKey_KeypadMultiply = 624;
  ImGuiKey_KeypadSubtract = 625;
  ImGuiKey_KeypadAdd = 626;
  ImGuiKey_KeypadEnter = 627;
  ImGuiKey_KeypadEqual = 628;
  ImGuiKey_AppBack = 629;
  ImGuiKey_AppForward = 630;
  ImGuiKey_Oem102 = 631;
  ImGuiKey_GamepadStart = 632;
  ImGuiKey_GamepadBack = 633;
  ImGuiKey_GamepadFaceLeft = 634;
  ImGuiKey_GamepadFaceRight = 635;
  ImGuiKey_GamepadFaceUp = 636;
  ImGuiKey_GamepadFaceDown = 637;
  ImGuiKey_GamepadDpadLeft = 638;
  ImGuiKey_GamepadDpadRight = 639;
  ImGuiKey_GamepadDpadUp = 640;
  ImGuiKey_GamepadDpadDown = 641;
  ImGuiKey_GamepadL1 = 642;
  ImGuiKey_GamepadR1 = 643;
  ImGuiKey_GamepadL2 = 644;
  ImGuiKey_GamepadR2 = 645;
  ImGuiKey_GamepadL3 = 646;
  ImGuiKey_GamepadR3 = 647;
  ImGuiKey_GamepadLStickLeft = 648;
  ImGuiKey_GamepadLStickRight = 649;
  ImGuiKey_GamepadLStickUp = 650;
  ImGuiKey_GamepadLStickDown = 651;
  ImGuiKey_GamepadRStickLeft = 652;
  ImGuiKey_GamepadRStickRight = 653;
  ImGuiKey_GamepadRStickUp = 654;
  ImGuiKey_GamepadRStickDown = 655;
  ImGuiKey_MouseLeft = 656;
  ImGuiKey_MouseRight = 657;
  ImGuiKey_MouseMiddle = 658;
  ImGuiKey_MouseX1 = 659;
  ImGuiKey_MouseX2 = 660;
  ImGuiKey_MouseWheelX = 661;
  ImGuiKey_MouseWheelY = 662;
  ImGuiKey_ReservedForModCtrl = 663;
  ImGuiKey_ReservedForModShift = 664;
  ImGuiKey_ReservedForModAlt = 665;
  ImGuiKey_ReservedForModSuper = 666;
  ImGuiKey_NamedKey_END = 667;
  ImGuiMod_None = 0;
  ImGuiMod_Ctrl = 4096;
  ImGuiMod_Shift = 8192;
  ImGuiMod_Alt = 16384;
  ImGuiMod_Super = 32768;
  ImGuiMod_Mask_ = 61440;
  ImGuiKey_NamedKey_COUNT = 155;

type
  ImGuiInputFlags_ = Integer;
  PImGuiInputFlags_ = ^ImGuiInputFlags_;

const
  ImGuiInputFlags_None = 0;
  ImGuiInputFlags_Repeat = 1;
  ImGuiInputFlags_RouteActive = 1024;
  ImGuiInputFlags_RouteFocused = 2048;
  ImGuiInputFlags_RouteGlobal = 4096;
  ImGuiInputFlags_RouteAlways = 8192;
  ImGuiInputFlags_RouteOverFocused = 16384;
  ImGuiInputFlags_RouteOverActive = 32768;
  ImGuiInputFlags_RouteUnlessBgFocused = 65536;
  ImGuiInputFlags_RouteFromRootWindow = 131072;
  ImGuiInputFlags_Tooltip = 262144;

type
  ImGuiConfigFlags_ = Integer;
  PImGuiConfigFlags_ = ^ImGuiConfigFlags_;

const
  ImGuiConfigFlags_None = 0;
  ImGuiConfigFlags_NavEnableKeyboard = 1;
  ImGuiConfigFlags_NavEnableGamepad = 2;
  ImGuiConfigFlags_NoMouse = 16;
  ImGuiConfigFlags_NoMouseCursorChange = 32;
  ImGuiConfigFlags_NoKeyboard = 64;
  ImGuiConfigFlags_DockingEnable = 128;
  ImGuiConfigFlags_ViewportsEnable = 1024;
  ImGuiConfigFlags_DpiEnableScaleViewports = 16384;
  ImGuiConfigFlags_DpiEnableScaleFonts = 32768;
  ImGuiConfigFlags_IsSRGB = 1048576;
  ImGuiConfigFlags_IsTouchScreen = 2097152;

type
  ImGuiBackendFlags_ = Integer;
  PImGuiBackendFlags_ = ^ImGuiBackendFlags_;

const
  ImGuiBackendFlags_None = 0;
  ImGuiBackendFlags_HasGamepad = 1;
  ImGuiBackendFlags_HasMouseCursors = 2;
  ImGuiBackendFlags_HasSetMousePos = 4;
  ImGuiBackendFlags_RendererHasVtxOffset = 8;
  ImGuiBackendFlags_PlatformHasViewports = 1024;
  ImGuiBackendFlags_HasMouseHoveredViewport = 2048;
  ImGuiBackendFlags_RendererHasViewports = 4096;

type
  ImGuiCol_ = Integer;
  PImGuiCol_ = ^ImGuiCol_;

const
  ImGuiCol_Text = 0;
  ImGuiCol_TextDisabled = 1;
  ImGuiCol_WindowBg = 2;
  ImGuiCol_ChildBg = 3;
  ImGuiCol_PopupBg = 4;
  ImGuiCol_Border = 5;
  ImGuiCol_BorderShadow = 6;
  ImGuiCol_FrameBg = 7;
  ImGuiCol_FrameBgHovered = 8;
  ImGuiCol_FrameBgActive = 9;
  ImGuiCol_TitleBg = 10;
  ImGuiCol_TitleBgActive = 11;
  ImGuiCol_TitleBgCollapsed = 12;
  ImGuiCol_MenuBarBg = 13;
  ImGuiCol_ScrollbarBg = 14;
  ImGuiCol_ScrollbarGrab = 15;
  ImGuiCol_ScrollbarGrabHovered = 16;
  ImGuiCol_ScrollbarGrabActive = 17;
  ImGuiCol_CheckMark = 18;
  ImGuiCol_SliderGrab = 19;
  ImGuiCol_SliderGrabActive = 20;
  ImGuiCol_Button = 21;
  ImGuiCol_ButtonHovered = 22;
  ImGuiCol_ButtonActive = 23;
  ImGuiCol_Header = 24;
  ImGuiCol_HeaderHovered = 25;
  ImGuiCol_HeaderActive = 26;
  ImGuiCol_Separator = 27;
  ImGuiCol_SeparatorHovered = 28;
  ImGuiCol_SeparatorActive = 29;
  ImGuiCol_ResizeGrip = 30;
  ImGuiCol_ResizeGripHovered = 31;
  ImGuiCol_ResizeGripActive = 32;
  ImGuiCol_TabHovered = 33;
  ImGuiCol_Tab = 34;
  ImGuiCol_TabSelected = 35;
  ImGuiCol_TabSelectedOverline = 36;
  ImGuiCol_TabDimmed = 37;
  ImGuiCol_TabDimmedSelected = 38;
  ImGuiCol_TabDimmedSelectedOverline = 39;
  ImGuiCol_DockingPreview = 40;
  ImGuiCol_DockingEmptyBg = 41;
  ImGuiCol_PlotLines = 42;
  ImGuiCol_PlotLinesHovered = 43;
  ImGuiCol_PlotHistogram = 44;
  ImGuiCol_PlotHistogramHovered = 45;
  ImGuiCol_TableHeaderBg = 46;
  ImGuiCol_TableBorderStrong = 47;
  ImGuiCol_TableBorderLight = 48;
  ImGuiCol_TableRowBg = 49;
  ImGuiCol_TableRowBgAlt = 50;
  ImGuiCol_TextLink = 51;
  ImGuiCol_TextSelectedBg = 52;
  ImGuiCol_DragDropTarget = 53;
  ImGuiCol_NavCursor = 54;
  ImGuiCol_NavWindowingHighlight = 55;
  ImGuiCol_NavWindowingDimBg = 56;
  ImGuiCol_ModalWindowDimBg = 57;
  ImGuiCol_COUNT = 58;

type
  ImGuiStyleVar_ = Integer;
  PImGuiStyleVar_ = ^ImGuiStyleVar_;

const
  ImGuiStyleVar_Alpha = 0;
  ImGuiStyleVar_DisabledAlpha = 1;
  ImGuiStyleVar_WindowPadding = 2;
  ImGuiStyleVar_WindowRounding = 3;
  ImGuiStyleVar_WindowBorderSize = 4;
  ImGuiStyleVar_WindowMinSize = 5;
  ImGuiStyleVar_WindowTitleAlign = 6;
  ImGuiStyleVar_ChildRounding = 7;
  ImGuiStyleVar_ChildBorderSize = 8;
  ImGuiStyleVar_PopupRounding = 9;
  ImGuiStyleVar_PopupBorderSize = 10;
  ImGuiStyleVar_FramePadding = 11;
  ImGuiStyleVar_FrameRounding = 12;
  ImGuiStyleVar_FrameBorderSize = 13;
  ImGuiStyleVar_ItemSpacing = 14;
  ImGuiStyleVar_ItemInnerSpacing = 15;
  ImGuiStyleVar_IndentSpacing = 16;
  ImGuiStyleVar_CellPadding = 17;
  ImGuiStyleVar_ScrollbarSize = 18;
  ImGuiStyleVar_ScrollbarRounding = 19;
  ImGuiStyleVar_GrabMinSize = 20;
  ImGuiStyleVar_GrabRounding = 21;
  ImGuiStyleVar_ImageBorderSize = 22;
  ImGuiStyleVar_TabRounding = 23;
  ImGuiStyleVar_TabBorderSize = 24;
  ImGuiStyleVar_TabBarBorderSize = 25;
  ImGuiStyleVar_TabBarOverlineSize = 26;
  ImGuiStyleVar_TableAngledHeadersAngle = 27;
  ImGuiStyleVar_TableAngledHeadersTextAlign = 28;
  ImGuiStyleVar_ButtonTextAlign = 29;
  ImGuiStyleVar_SelectableTextAlign = 30;
  ImGuiStyleVar_SeparatorTextBorderSize = 31;
  ImGuiStyleVar_SeparatorTextAlign = 32;
  ImGuiStyleVar_SeparatorTextPadding = 33;
  ImGuiStyleVar_DockingSeparatorSize = 34;
  ImGuiStyleVar_COUNT = 35;

type
  ImGuiButtonFlags_ = Integer;
  PImGuiButtonFlags_ = ^ImGuiButtonFlags_;

const
  ImGuiButtonFlags_None = 0;
  ImGuiButtonFlags_MouseButtonLeft = 1;
  ImGuiButtonFlags_MouseButtonRight = 2;
  ImGuiButtonFlags_MouseButtonMiddle = 4;
  ImGuiButtonFlags_MouseButtonMask_ = 7;
  ImGuiButtonFlags_EnableNav = 8;

type
  ImGuiColorEditFlags_ = Integer;
  PImGuiColorEditFlags_ = ^ImGuiColorEditFlags_;

const
  ImGuiColorEditFlags_None = 0;
  ImGuiColorEditFlags_NoAlpha = 2;
  ImGuiColorEditFlags_NoPicker = 4;
  ImGuiColorEditFlags_NoOptions = 8;
  ImGuiColorEditFlags_NoSmallPreview = 16;
  ImGuiColorEditFlags_NoInputs = 32;
  ImGuiColorEditFlags_NoTooltip = 64;
  ImGuiColorEditFlags_NoLabel = 128;
  ImGuiColorEditFlags_NoSidePreview = 256;
  ImGuiColorEditFlags_NoDragDrop = 512;
  ImGuiColorEditFlags_NoBorder = 1024;
  ImGuiColorEditFlags_AlphaOpaque = 2048;
  ImGuiColorEditFlags_AlphaNoBg = 4096;
  ImGuiColorEditFlags_AlphaPreviewHalf = 8192;
  ImGuiColorEditFlags_AlphaBar = 65536;
  ImGuiColorEditFlags_HDR = 524288;
  ImGuiColorEditFlags_DisplayRGB = 1048576;
  ImGuiColorEditFlags_DisplayHSV = 2097152;
  ImGuiColorEditFlags_DisplayHex = 4194304;
  ImGuiColorEditFlags_Uint8 = 8388608;
  ImGuiColorEditFlags_Float = 16777216;
  ImGuiColorEditFlags_PickerHueBar = 33554432;
  ImGuiColorEditFlags_PickerHueWheel = 67108864;
  ImGuiColorEditFlags_InputRGB = 134217728;
  ImGuiColorEditFlags_InputHSV = 268435456;
  ImGuiColorEditFlags_DefaultOptions_ = 177209344;
  ImGuiColorEditFlags_AlphaMask_ = 14338;
  ImGuiColorEditFlags_DisplayMask_ = 7340032;
  ImGuiColorEditFlags_DataTypeMask_ = 25165824;
  ImGuiColorEditFlags_PickerMask_ = 100663296;
  ImGuiColorEditFlags_InputMask_ = 402653184;

type
  ImGuiSliderFlags_ = Integer;
  PImGuiSliderFlags_ = ^ImGuiSliderFlags_;

const
  ImGuiSliderFlags_None = 0;
  ImGuiSliderFlags_Logarithmic = 32;
  ImGuiSliderFlags_NoRoundToFormat = 64;
  ImGuiSliderFlags_NoInput = 128;
  ImGuiSliderFlags_WrapAround = 256;
  ImGuiSliderFlags_ClampOnInput = 512;
  ImGuiSliderFlags_ClampZeroRange = 1024;
  ImGuiSliderFlags_NoSpeedTweaks = 2048;
  ImGuiSliderFlags_AlwaysClamp = 1536;
  ImGuiSliderFlags_InvalidMask_ = 1879048207;

type
  ImGuiMouseButton_ = Integer;
  PImGuiMouseButton_ = ^ImGuiMouseButton_;

const
  ImGuiMouseButton_Left = 0;
  ImGuiMouseButton_Right = 1;
  ImGuiMouseButton_Middle = 2;
  ImGuiMouseButton_COUNT = 5;

type
  ImGuiMouseCursor_ = Integer;
  PImGuiMouseCursor_ = ^ImGuiMouseCursor_;

const
  ImGuiMouseCursor_None = -1;
  ImGuiMouseCursor_Arrow = 0;
  ImGuiMouseCursor_TextInput = 1;
  ImGuiMouseCursor_ResizeAll = 2;
  ImGuiMouseCursor_ResizeNS = 3;
  ImGuiMouseCursor_ResizeEW = 4;
  ImGuiMouseCursor_ResizeNESW = 5;
  ImGuiMouseCursor_ResizeNWSE = 6;
  ImGuiMouseCursor_Hand = 7;
  ImGuiMouseCursor_Wait = 8;
  ImGuiMouseCursor_Progress = 9;
  ImGuiMouseCursor_NotAllowed = 10;
  ImGuiMouseCursor_COUNT = 11;

type
  ImGuiMouseSource = Integer;
  PImGuiMouseSource = ^ImGuiMouseSource;

const
  ImGuiMouseSource_Mouse = 0;
  ImGuiMouseSource_TouchScreen = 1;
  ImGuiMouseSource_Pen = 2;
  ImGuiMouseSource_COUNT = 3;

type
  ImGuiCond_ = Integer;
  PImGuiCond_ = ^ImGuiCond_;

const
  ImGuiCond_None = 0;
  ImGuiCond_Always = 1;
  ImGuiCond_Once = 2;
  ImGuiCond_FirstUseEver = 4;
  ImGuiCond_Appearing = 8;

type
  ImGuiTableFlags_ = Integer;
  PImGuiTableFlags_ = ^ImGuiTableFlags_;

const
  ImGuiTableFlags_None = 0;
  ImGuiTableFlags_Resizable = 1;
  ImGuiTableFlags_Reorderable = 2;
  ImGuiTableFlags_Hideable = 4;
  ImGuiTableFlags_Sortable = 8;
  ImGuiTableFlags_NoSavedSettings = 16;
  ImGuiTableFlags_ContextMenuInBody = 32;
  ImGuiTableFlags_RowBg = 64;
  ImGuiTableFlags_BordersInnerH = 128;
  ImGuiTableFlags_BordersOuterH = 256;
  ImGuiTableFlags_BordersInnerV = 512;
  ImGuiTableFlags_BordersOuterV = 1024;
  ImGuiTableFlags_BordersH = 384;
  ImGuiTableFlags_BordersV = 1536;
  ImGuiTableFlags_BordersInner = 640;
  ImGuiTableFlags_BordersOuter = 1280;
  ImGuiTableFlags_Borders = 1920;
  ImGuiTableFlags_NoBordersInBody = 2048;
  ImGuiTableFlags_NoBordersInBodyUntilResize = 4096;
  ImGuiTableFlags_SizingFixedFit = 8192;
  ImGuiTableFlags_SizingFixedSame = 16384;
  ImGuiTableFlags_SizingStretchProp = 24576;
  ImGuiTableFlags_SizingStretchSame = 32768;
  ImGuiTableFlags_NoHostExtendX = 65536;
  ImGuiTableFlags_NoHostExtendY = 131072;
  ImGuiTableFlags_NoKeepColumnsVisible = 262144;
  ImGuiTableFlags_PreciseWidths = 524288;
  ImGuiTableFlags_NoClip = 1048576;
  ImGuiTableFlags_PadOuterX = 2097152;
  ImGuiTableFlags_NoPadOuterX = 4194304;
  ImGuiTableFlags_NoPadInnerX = 8388608;
  ImGuiTableFlags_ScrollX = 16777216;
  ImGuiTableFlags_ScrollY = 33554432;
  ImGuiTableFlags_SortMulti = 67108864;
  ImGuiTableFlags_SortTristate = 134217728;
  ImGuiTableFlags_HighlightHoveredColumn = 268435456;
  ImGuiTableFlags_SizingMask_ = 57344;

type
  ImGuiTableColumnFlags_ = Integer;
  PImGuiTableColumnFlags_ = ^ImGuiTableColumnFlags_;

const
  ImGuiTableColumnFlags_None = 0;
  ImGuiTableColumnFlags_Disabled = 1;
  ImGuiTableColumnFlags_DefaultHide = 2;
  ImGuiTableColumnFlags_DefaultSort = 4;
  ImGuiTableColumnFlags_WidthStretch = 8;
  ImGuiTableColumnFlags_WidthFixed = 16;
  ImGuiTableColumnFlags_NoResize = 32;
  ImGuiTableColumnFlags_NoReorder = 64;
  ImGuiTableColumnFlags_NoHide = 128;
  ImGuiTableColumnFlags_NoClip = 256;
  ImGuiTableColumnFlags_NoSort = 512;
  ImGuiTableColumnFlags_NoSortAscending = 1024;
  ImGuiTableColumnFlags_NoSortDescending = 2048;
  ImGuiTableColumnFlags_NoHeaderLabel = 4096;
  ImGuiTableColumnFlags_NoHeaderWidth = 8192;
  ImGuiTableColumnFlags_PreferSortAscending = 16384;
  ImGuiTableColumnFlags_PreferSortDescending = 32768;
  ImGuiTableColumnFlags_IndentEnable = 65536;
  ImGuiTableColumnFlags_IndentDisable = 131072;
  ImGuiTableColumnFlags_AngledHeader = 262144;
  ImGuiTableColumnFlags_IsEnabled = 16777216;
  ImGuiTableColumnFlags_IsVisible = 33554432;
  ImGuiTableColumnFlags_IsSorted = 67108864;
  ImGuiTableColumnFlags_IsHovered = 134217728;
  ImGuiTableColumnFlags_WidthMask_ = 24;
  ImGuiTableColumnFlags_IndentMask_ = 196608;
  ImGuiTableColumnFlags_StatusMask_ = 251658240;
  ImGuiTableColumnFlags_NoDirectResize_ = 1073741824;

type
  ImGuiTableRowFlags_ = Integer;
  PImGuiTableRowFlags_ = ^ImGuiTableRowFlags_;

const
  ImGuiTableRowFlags_None = 0;
  ImGuiTableRowFlags_Headers = 1;

type
  ImGuiTableBgTarget_ = Integer;
  PImGuiTableBgTarget_ = ^ImGuiTableBgTarget_;

const
  ImGuiTableBgTarget_None = 0;
  ImGuiTableBgTarget_RowBg0 = 1;
  ImGuiTableBgTarget_RowBg1 = 2;
  ImGuiTableBgTarget_CellBg = 3;

type
  ImGuiMultiSelectFlags_ = Integer;
  PImGuiMultiSelectFlags_ = ^ImGuiMultiSelectFlags_;

const
  ImGuiMultiSelectFlags_None = 0;
  ImGuiMultiSelectFlags_SingleSelect = 1;
  ImGuiMultiSelectFlags_NoSelectAll = 2;
  ImGuiMultiSelectFlags_NoRangeSelect = 4;
  ImGuiMultiSelectFlags_NoAutoSelect = 8;
  ImGuiMultiSelectFlags_NoAutoClear = 16;
  ImGuiMultiSelectFlags_NoAutoClearOnReselect = 32;
  ImGuiMultiSelectFlags_BoxSelect1d = 64;
  ImGuiMultiSelectFlags_BoxSelect2d = 128;
  ImGuiMultiSelectFlags_BoxSelectNoScroll = 256;
  ImGuiMultiSelectFlags_ClearOnEscape = 512;
  ImGuiMultiSelectFlags_ClearOnClickVoid = 1024;
  ImGuiMultiSelectFlags_ScopeWindow = 2048;
  ImGuiMultiSelectFlags_ScopeRect = 4096;
  ImGuiMultiSelectFlags_SelectOnClick = 8192;
  ImGuiMultiSelectFlags_SelectOnClickRelease = 16384;
  ImGuiMultiSelectFlags_NavWrapX = 65536;

type
  ImGuiSelectionRequestType = Integer;
  PImGuiSelectionRequestType = ^ImGuiSelectionRequestType;

const
  ImGuiSelectionRequestType_None = 0;
  ImGuiSelectionRequestType_SetAll = 1;
  ImGuiSelectionRequestType_SetRange = 2;

type
  ImDrawFlags_ = Integer;
  PImDrawFlags_ = ^ImDrawFlags_;

const
  ImDrawFlags_None = 0;
  ImDrawFlags_Closed = 1;
  ImDrawFlags_RoundCornersTopLeft = 16;
  ImDrawFlags_RoundCornersTopRight = 32;
  ImDrawFlags_RoundCornersBottomLeft = 64;
  ImDrawFlags_RoundCornersBottomRight = 128;
  ImDrawFlags_RoundCornersNone = 256;
  ImDrawFlags_RoundCornersTop = 48;
  ImDrawFlags_RoundCornersBottom = 192;
  ImDrawFlags_RoundCornersLeft = 80;
  ImDrawFlags_RoundCornersRight = 160;
  ImDrawFlags_RoundCornersAll = 240;
  ImDrawFlags_RoundCornersDefault_ = 240;
  ImDrawFlags_RoundCornersMask_ = 496;

type
  ImDrawListFlags_ = Integer;
  PImDrawListFlags_ = ^ImDrawListFlags_;

const
  ImDrawListFlags_None = 0;
  ImDrawListFlags_AntiAliasedLines = 1;
  ImDrawListFlags_AntiAliasedLinesUseTex = 2;
  ImDrawListFlags_AntiAliasedFill = 4;
  ImDrawListFlags_AllowVtxOffset = 8;

type
  ImFontAtlasFlags_ = Integer;
  PImFontAtlasFlags_ = ^ImFontAtlasFlags_;

const
  ImFontAtlasFlags_None = 0;
  ImFontAtlasFlags_NoPowerOfTwoHeight = 1;
  ImFontAtlasFlags_NoMouseCursors = 2;
  ImFontAtlasFlags_NoBakedLines = 4;

type
  ImGuiViewportFlags_ = Integer;
  PImGuiViewportFlags_ = ^ImGuiViewportFlags_;

const
  ImGuiViewportFlags_None = 0;
  ImGuiViewportFlags_IsPlatformWindow = 1;
  ImGuiViewportFlags_IsPlatformMonitor = 2;
  ImGuiViewportFlags_OwnedByApp = 4;
  ImGuiViewportFlags_NoDecoration = 8;
  ImGuiViewportFlags_NoTaskBarIcon = 16;
  ImGuiViewportFlags_NoFocusOnAppearing = 32;
  ImGuiViewportFlags_NoFocusOnClick = 64;
  ImGuiViewportFlags_NoInputs = 128;
  ImGuiViewportFlags_NoRendererClear = 256;
  ImGuiViewportFlags_NoAutoMerge = 512;
  ImGuiViewportFlags_TopMost = 1024;
  ImGuiViewportFlags_CanHostOtherWindows = 2048;
  ImGuiViewportFlags_IsMinimized = 4096;
  ImGuiViewportFlags_IsFocused = 8192;

type
  ImGuiDataTypePrivate_ = Integer;
  PImGuiDataTypePrivate_ = ^ImGuiDataTypePrivate_;

const
  ImGuiDataType_Pointer = 12;
  ImGuiDataType_ID = 13;

type
  ImGuiItemFlagsPrivate_ = Integer;
  PImGuiItemFlagsPrivate_ = ^ImGuiItemFlagsPrivate_;

const
  ImGuiItemFlags_Disabled = 1024;
  ImGuiItemFlags_ReadOnly = 2048;
  ImGuiItemFlags_MixedValue = 4096;
  ImGuiItemFlags_NoWindowHoverableCheck = 8192;
  ImGuiItemFlags_AllowOverlap = 16384;
  ImGuiItemFlags_NoNavDisableMouseHover = 32768;
  ImGuiItemFlags_NoMarkEdited = 65536;
  ImGuiItemFlags_Inputable = 1048576;
  ImGuiItemFlags_HasSelectionUserData = 2097152;
  ImGuiItemFlags_IsMultiSelect = 4194304;
  ImGuiItemFlags_Default_ = 16;

type
  ImGuiItemStatusFlags_ = Integer;
  PImGuiItemStatusFlags_ = ^ImGuiItemStatusFlags_;

const
  ImGuiItemStatusFlags_None = 0;
  ImGuiItemStatusFlags_HoveredRect = 1;
  ImGuiItemStatusFlags_HasDisplayRect = 2;
  ImGuiItemStatusFlags_Edited = 4;
  ImGuiItemStatusFlags_ToggledSelection = 8;
  ImGuiItemStatusFlags_ToggledOpen = 16;
  ImGuiItemStatusFlags_HasDeactivated = 32;
  ImGuiItemStatusFlags_Deactivated = 64;
  ImGuiItemStatusFlags_HoveredWindow = 128;
  ImGuiItemStatusFlags_Visible = 256;
  ImGuiItemStatusFlags_HasClipRect = 512;
  ImGuiItemStatusFlags_HasShortcut = 1024;

type
  ImGuiHoveredFlagsPrivate_ = Integer;
  PImGuiHoveredFlagsPrivate_ = ^ImGuiHoveredFlagsPrivate_;

const
  ImGuiHoveredFlags_DelayMask_ = 245760;
  ImGuiHoveredFlags_AllowedMaskForIsWindowHovered = 12479;
  ImGuiHoveredFlags_AllowedMaskForIsItemHovered = 262048;

type
  ImGuiInputTextFlagsPrivate_ = Integer;
  PImGuiInputTextFlagsPrivate_ = ^ImGuiInputTextFlagsPrivate_;

const
  ImGuiInputTextFlags_Multiline = 67108864;
  ImGuiInputTextFlags_MergedItem = 134217728;
  ImGuiInputTextFlags_LocalizeDecimalPoint = 268435456;

type
  ImGuiButtonFlagsPrivate_ = Integer;
  PImGuiButtonFlagsPrivate_ = ^ImGuiButtonFlagsPrivate_;

const
  ImGuiButtonFlags_PressedOnClick = 16;
  ImGuiButtonFlags_PressedOnClickRelease = 32;
  ImGuiButtonFlags_PressedOnClickReleaseAnywhere = 64;
  ImGuiButtonFlags_PressedOnRelease = 128;
  ImGuiButtonFlags_PressedOnDoubleClick = 256;
  ImGuiButtonFlags_PressedOnDragDropHold = 512;
  ImGuiButtonFlags_FlattenChildren = 2048;
  ImGuiButtonFlags_AllowOverlap = 4096;
  ImGuiButtonFlags_AlignTextBaseLine = 32768;
  ImGuiButtonFlags_NoKeyModsAllowed = 65536;
  ImGuiButtonFlags_NoHoldingActiveId = 131072;
  ImGuiButtonFlags_NoNavFocus = 262144;
  ImGuiButtonFlags_NoHoveredOnFocus = 524288;
  ImGuiButtonFlags_NoSetKeyOwner = 1048576;
  ImGuiButtonFlags_NoTestKeyOwner = 2097152;
  ImGuiButtonFlags_PressedOnMask_ = 1008;
  ImGuiButtonFlags_PressedOnDefault_ = 32;

type
  ImGuiComboFlagsPrivate_ = Integer;
  PImGuiComboFlagsPrivate_ = ^ImGuiComboFlagsPrivate_;

const
  ImGuiComboFlags_CustomPreview = 1048576;

type
  ImGuiSliderFlagsPrivate_ = Integer;
  PImGuiSliderFlagsPrivate_ = ^ImGuiSliderFlagsPrivate_;

const
  ImGuiSliderFlags_Vertical = 1048576;
  ImGuiSliderFlags_ReadOnly = 2097152;

type
  ImGuiSelectableFlagsPrivate_ = Integer;
  PImGuiSelectableFlagsPrivate_ = ^ImGuiSelectableFlagsPrivate_;

const
  ImGuiSelectableFlags_NoHoldingActiveID = 1048576;
  ImGuiSelectableFlags_SelectOnNav = 2097152;
  ImGuiSelectableFlags_SelectOnClick = 4194304;
  ImGuiSelectableFlags_SelectOnRelease = 8388608;
  ImGuiSelectableFlags_SpanAvailWidth = 16777216;
  ImGuiSelectableFlags_SetNavIdOnHover = 33554432;
  ImGuiSelectableFlags_NoPadWithHalfSpacing = 67108864;
  ImGuiSelectableFlags_NoSetKeyOwner = 134217728;

type
  ImGuiTreeNodeFlagsPrivate_ = Integer;
  PImGuiTreeNodeFlagsPrivate_ = ^ImGuiTreeNodeFlagsPrivate_;

const
  ImGuiTreeNodeFlags_ClipLabelForTrailingButton = 268435456;
  ImGuiTreeNodeFlags_UpsideDownArrow = 536870912;
  ImGuiTreeNodeFlags_OpenOnMask_ = 192;

type
  ImGuiSeparatorFlags_ = Integer;
  PImGuiSeparatorFlags_ = ^ImGuiSeparatorFlags_;

const
  ImGuiSeparatorFlags_None = 0;
  ImGuiSeparatorFlags_Horizontal = 1;
  ImGuiSeparatorFlags_Vertical = 2;
  ImGuiSeparatorFlags_SpanAllColumns = 4;

type
  ImGuiFocusRequestFlags_ = Integer;
  PImGuiFocusRequestFlags_ = ^ImGuiFocusRequestFlags_;

const
  ImGuiFocusRequestFlags_None = 0;
  ImGuiFocusRequestFlags_RestoreFocusedChild = 1;
  ImGuiFocusRequestFlags_UnlessBelowModal = 2;

type
  ImGuiTextFlags_ = Integer;
  PImGuiTextFlags_ = ^ImGuiTextFlags_;

const
  ImGuiTextFlags_None = 0;
  ImGuiTextFlags_NoWidthForLargeClippedText = 1;

type
  ImGuiTooltipFlags_ = Integer;
  PImGuiTooltipFlags_ = ^ImGuiTooltipFlags_;

const
  ImGuiTooltipFlags_None = 0;
  ImGuiTooltipFlags_OverridePrevious = 2;

type
  ImGuiLayoutType_ = Integer;
  PImGuiLayoutType_ = ^ImGuiLayoutType_;

const
  ImGuiLayoutType_Horizontal = 0;
  ImGuiLayoutType_Vertical = 1;

type
  ImGuiLogFlags_ = Integer;
  PImGuiLogFlags_ = ^ImGuiLogFlags_;

const
  ImGuiLogFlags_None = 0;
  ImGuiLogFlags_OutputTTY = 1;
  ImGuiLogFlags_OutputFile = 2;
  ImGuiLogFlags_OutputBuffer = 4;
  ImGuiLogFlags_OutputClipboard = 8;
  ImGuiLogFlags_OutputMask_ = 15;

type
  ImGuiAxis = Integer;
  PImGuiAxis = ^ImGuiAxis;

const
  ImGuiAxis_None = -1;
  ImGuiAxis_X = 0;
  ImGuiAxis_Y = 1;

type
  ImGuiPlotType = Integer;
  PImGuiPlotType = ^ImGuiPlotType;

const
  ImGuiPlotType_Lines = 0;
  ImGuiPlotType_Histogram = 1;

type
  ImGuiWindowRefreshFlags_ = Integer;
  PImGuiWindowRefreshFlags_ = ^ImGuiWindowRefreshFlags_;

const
  ImGuiWindowRefreshFlags_None = 0;
  ImGuiWindowRefreshFlags_TryToAvoidRefresh = 1;
  ImGuiWindowRefreshFlags_RefreshOnHover = 2;
  ImGuiWindowRefreshFlags_RefreshOnFocus = 4;

type
  ImGuiNextWindowDataFlags_ = Integer;
  PImGuiNextWindowDataFlags_ = ^ImGuiNextWindowDataFlags_;

const
  ImGuiNextWindowDataFlags_None = 0;
  ImGuiNextWindowDataFlags_HasPos = 1;
  ImGuiNextWindowDataFlags_HasSize = 2;
  ImGuiNextWindowDataFlags_HasContentSize = 4;
  ImGuiNextWindowDataFlags_HasCollapsed = 8;
  ImGuiNextWindowDataFlags_HasSizeConstraint = 16;
  ImGuiNextWindowDataFlags_HasFocus = 32;
  ImGuiNextWindowDataFlags_HasBgAlpha = 64;
  ImGuiNextWindowDataFlags_HasScroll = 128;
  ImGuiNextWindowDataFlags_HasWindowFlags = 256;
  ImGuiNextWindowDataFlags_HasChildFlags = 512;
  ImGuiNextWindowDataFlags_HasRefreshPolicy = 1024;
  ImGuiNextWindowDataFlags_HasViewport = 2048;
  ImGuiNextWindowDataFlags_HasDock = 4096;
  ImGuiNextWindowDataFlags_HasWindowClass = 8192;

type
  ImGuiNextItemDataFlags_ = Integer;
  PImGuiNextItemDataFlags_ = ^ImGuiNextItemDataFlags_;

const
  ImGuiNextItemDataFlags_None = 0;
  ImGuiNextItemDataFlags_HasWidth = 1;
  ImGuiNextItemDataFlags_HasOpen = 2;
  ImGuiNextItemDataFlags_HasShortcut = 4;
  ImGuiNextItemDataFlags_HasRefVal = 8;
  ImGuiNextItemDataFlags_HasStorageID = 16;

type
  ImGuiPopupPositionPolicy = Integer;
  PImGuiPopupPositionPolicy = ^ImGuiPopupPositionPolicy;

const
  ImGuiPopupPositionPolicy_Default = 0;
  ImGuiPopupPositionPolicy_ComboBox = 1;
  ImGuiPopupPositionPolicy_Tooltip = 2;

type
  ImGuiInputEventType = Integer;
  PImGuiInputEventType = ^ImGuiInputEventType;

const
  ImGuiInputEventType_None = 0;
  ImGuiInputEventType_MousePos = 1;
  ImGuiInputEventType_MouseWheel = 2;
  ImGuiInputEventType_MouseButton = 3;
  ImGuiInputEventType_MouseViewport = 4;
  ImGuiInputEventType_Key = 5;
  ImGuiInputEventType_Text = 6;
  ImGuiInputEventType_Focus = 7;
  ImGuiInputEventType_COUNT = 8;

type
  ImGuiInputSource = Integer;
  PImGuiInputSource = ^ImGuiInputSource;

const
  ImGuiInputSource_None = 0;
  ImGuiInputSource_Mouse = 1;
  ImGuiInputSource_Keyboard = 2;
  ImGuiInputSource_Gamepad = 3;
  ImGuiInputSource_COUNT = 4;

type
  ImGuiInputFlagsPrivate_ = Integer;
  PImGuiInputFlagsPrivate_ = ^ImGuiInputFlagsPrivate_;

const
  ImGuiInputFlags_RepeatRateDefault = 2;
  ImGuiInputFlags_RepeatRateNavMove = 4;
  ImGuiInputFlags_RepeatRateNavTweak = 8;
  ImGuiInputFlags_RepeatUntilRelease = 16;
  ImGuiInputFlags_RepeatUntilKeyModsChange = 32;
  ImGuiInputFlags_RepeatUntilKeyModsChangeFromNone = 64;
  ImGuiInputFlags_RepeatUntilOtherKeyPress = 128;
  ImGuiInputFlags_LockThisFrame = 1048576;
  ImGuiInputFlags_LockUntilRelease = 2097152;
  ImGuiInputFlags_CondHovered = 4194304;
  ImGuiInputFlags_CondActive = 8388608;
  ImGuiInputFlags_CondDefault_ = 12582912;
  ImGuiInputFlags_RepeatRateMask_ = 14;
  ImGuiInputFlags_RepeatUntilMask_ = 240;
  ImGuiInputFlags_RepeatMask_ = 255;
  ImGuiInputFlags_CondMask_ = 12582912;
  ImGuiInputFlags_RouteTypeMask_ = 15360;
  ImGuiInputFlags_RouteOptionsMask_ = 245760;
  ImGuiInputFlags_SupportedByIsKeyPressed = 255;
  ImGuiInputFlags_SupportedByIsMouseClicked = 1;
  ImGuiInputFlags_SupportedByShortcut = 261375;
  ImGuiInputFlags_SupportedBySetNextItemShortcut = 523519;
  ImGuiInputFlags_SupportedBySetKeyOwner = 3145728;
  ImGuiInputFlags_SupportedBySetItemKeyOwner = 15728640;

type
  ImGuiActivateFlags_ = Integer;
  PImGuiActivateFlags_ = ^ImGuiActivateFlags_;

const
  ImGuiActivateFlags_None = 0;
  ImGuiActivateFlags_PreferInput = 1;
  ImGuiActivateFlags_PreferTweak = 2;
  ImGuiActivateFlags_TryToPreserveState = 4;
  ImGuiActivateFlags_FromTabbing = 8;
  ImGuiActivateFlags_FromShortcut = 16;

type
  ImGuiScrollFlags_ = Integer;
  PImGuiScrollFlags_ = ^ImGuiScrollFlags_;

const
  ImGuiScrollFlags_None = 0;
  ImGuiScrollFlags_KeepVisibleEdgeX = 1;
  ImGuiScrollFlags_KeepVisibleEdgeY = 2;
  ImGuiScrollFlags_KeepVisibleCenterX = 4;
  ImGuiScrollFlags_KeepVisibleCenterY = 8;
  ImGuiScrollFlags_AlwaysCenterX = 16;
  ImGuiScrollFlags_AlwaysCenterY = 32;
  ImGuiScrollFlags_NoScrollParent = 64;
  ImGuiScrollFlags_MaskX_ = 21;
  ImGuiScrollFlags_MaskY_ = 42;

type
  ImGuiNavRenderCursorFlags_ = Integer;
  PImGuiNavRenderCursorFlags_ = ^ImGuiNavRenderCursorFlags_;

const
  ImGuiNavRenderCursorFlags_None = 0;
  ImGuiNavRenderCursorFlags_Compact = 2;
  ImGuiNavRenderCursorFlags_AlwaysDraw = 4;
  ImGuiNavRenderCursorFlags_NoRounding = 8;

type
  ImGuiNavMoveFlags_ = Integer;
  PImGuiNavMoveFlags_ = ^ImGuiNavMoveFlags_;

const
  ImGuiNavMoveFlags_None = 0;
  ImGuiNavMoveFlags_LoopX = 1;
  ImGuiNavMoveFlags_LoopY = 2;
  ImGuiNavMoveFlags_WrapX = 4;
  ImGuiNavMoveFlags_WrapY = 8;
  ImGuiNavMoveFlags_WrapMask_ = 15;
  ImGuiNavMoveFlags_AllowCurrentNavId = 16;
  ImGuiNavMoveFlags_AlsoScoreVisibleSet = 32;
  ImGuiNavMoveFlags_ScrollToEdgeY = 64;
  ImGuiNavMoveFlags_Forwarded = 128;
  ImGuiNavMoveFlags_DebugNoResult = 256;
  ImGuiNavMoveFlags_FocusApi = 512;
  ImGuiNavMoveFlags_IsTabbing = 1024;
  ImGuiNavMoveFlags_IsPageMove = 2048;
  ImGuiNavMoveFlags_Activate = 4096;
  ImGuiNavMoveFlags_NoSelect = 8192;
  ImGuiNavMoveFlags_NoSetNavCursorVisible = 16384;
  ImGuiNavMoveFlags_NoClearActiveId = 32768;

type
  ImGuiNavLayer = Integer;
  PImGuiNavLayer = ^ImGuiNavLayer;

const
  ImGuiNavLayer_Main = 0;
  ImGuiNavLayer_Menu = 1;
  ImGuiNavLayer_COUNT = 2;

type
  ImGuiTypingSelectFlags_ = Integer;
  PImGuiTypingSelectFlags_ = ^ImGuiTypingSelectFlags_;

const
  ImGuiTypingSelectFlags_None = 0;
  ImGuiTypingSelectFlags_AllowBackspace = 1;
  ImGuiTypingSelectFlags_AllowSingleCharMode = 2;

type
  ImGuiOldColumnFlags_ = Integer;
  PImGuiOldColumnFlags_ = ^ImGuiOldColumnFlags_;

const
  ImGuiOldColumnFlags_None = 0;
  ImGuiOldColumnFlags_NoBorder = 1;
  ImGuiOldColumnFlags_NoResize = 2;
  ImGuiOldColumnFlags_NoPreserveWidths = 4;
  ImGuiOldColumnFlags_NoForceWithinWindow = 8;
  ImGuiOldColumnFlags_GrowParentContentsSize = 16;

type
  ImGuiDockNodeFlagsPrivate_ = Integer;
  PImGuiDockNodeFlagsPrivate_ = ^ImGuiDockNodeFlagsPrivate_;

const
  ImGuiDockNodeFlags_DockSpace = 1024;
  ImGuiDockNodeFlags_CentralNode = 2048;
  ImGuiDockNodeFlags_NoTabBar = 4096;
  ImGuiDockNodeFlags_HiddenTabBar = 8192;
  ImGuiDockNodeFlags_NoWindowMenuButton = 16384;
  ImGuiDockNodeFlags_NoCloseButton = 32768;
  ImGuiDockNodeFlags_NoResizeX = 65536;
  ImGuiDockNodeFlags_NoResizeY = 131072;
  ImGuiDockNodeFlags_DockedWindowsInFocusRoute = 262144;
  ImGuiDockNodeFlags_NoDockingSplitOther = 524288;
  ImGuiDockNodeFlags_NoDockingOverMe = 1048576;
  ImGuiDockNodeFlags_NoDockingOverOther = 2097152;
  ImGuiDockNodeFlags_NoDockingOverEmpty = 4194304;
  ImGuiDockNodeFlags_NoDocking = 7864336;
  ImGuiDockNodeFlags_SharedFlagsInheritMask_ = -1;
  ImGuiDockNodeFlags_NoResizeFlagsMask_ = 196640;
  ImGuiDockNodeFlags_LocalFlagsTransferMask_ = 260208;
  ImGuiDockNodeFlags_SavedFlagsMask_ = 261152;

type
  ImGuiDataAuthority_ = Integer;
  PImGuiDataAuthority_ = ^ImGuiDataAuthority_;

const
  ImGuiDataAuthority_Auto = 0;
  ImGuiDataAuthority_DockNode = 1;
  ImGuiDataAuthority_Window = 2;

type
  ImGuiDockNodeState = Integer;
  PImGuiDockNodeState = ^ImGuiDockNodeState;

const
  ImGuiDockNodeState_Unknown = 0;
  ImGuiDockNodeState_HostWindowHiddenBecauseSingleWindow = 1;
  ImGuiDockNodeState_HostWindowHiddenBecauseWindowsAreResizing = 2;
  ImGuiDockNodeState_HostWindowVisible = 3;

type
  ImGuiWindowDockStyleCol = Integer;
  PImGuiWindowDockStyleCol = ^ImGuiWindowDockStyleCol;

const
  ImGuiWindowDockStyleCol_Text = 0;
  ImGuiWindowDockStyleCol_TabHovered = 1;
  ImGuiWindowDockStyleCol_TabFocused = 2;
  ImGuiWindowDockStyleCol_TabSelected = 3;
  ImGuiWindowDockStyleCol_TabSelectedOverline = 4;
  ImGuiWindowDockStyleCol_TabDimmed = 5;
  ImGuiWindowDockStyleCol_TabDimmedSelected = 6;
  ImGuiWindowDockStyleCol_TabDimmedSelectedOverline = 7;
  ImGuiWindowDockStyleCol_COUNT = 8;

type
  ImGuiLocKey = Integer;
  PImGuiLocKey = ^ImGuiLocKey;

const
  ImGuiLocKey_VersionStr = 0;
  ImGuiLocKey_TableSizeOne = 1;
  ImGuiLocKey_TableSizeAllFit = 2;
  ImGuiLocKey_TableSizeAllDefault = 3;
  ImGuiLocKey_TableResetOrder = 4;
  ImGuiLocKey_WindowingMainMenuBar = 5;
  ImGuiLocKey_WindowingPopup = 6;
  ImGuiLocKey_WindowingUntitled = 7;
  ImGuiLocKey_OpenLink_s = 8;
  ImGuiLocKey_CopyLink = 9;
  ImGuiLocKey_DockingHideTabBar = 10;
  ImGuiLocKey_DockingHoldShiftToDock = 11;
  ImGuiLocKey_DockingDragToUndockOrMoveNode = 12;
  ImGuiLocKey_COUNT = 13;

type
  ImGuiDebugLogFlags_ = Integer;
  PImGuiDebugLogFlags_ = ^ImGuiDebugLogFlags_;

const
  ImGuiDebugLogFlags_None = 0;
  ImGuiDebugLogFlags_EventError = 1;
  ImGuiDebugLogFlags_EventActiveId = 2;
  ImGuiDebugLogFlags_EventFocus = 4;
  ImGuiDebugLogFlags_EventPopup = 8;
  ImGuiDebugLogFlags_EventNav = 16;
  ImGuiDebugLogFlags_EventClipper = 32;
  ImGuiDebugLogFlags_EventSelection = 64;
  ImGuiDebugLogFlags_EventIO = 128;
  ImGuiDebugLogFlags_EventFont = 256;
  ImGuiDebugLogFlags_EventInputRouting = 512;
  ImGuiDebugLogFlags_EventDocking = 1024;
  ImGuiDebugLogFlags_EventViewport = 2048;
  ImGuiDebugLogFlags_EventMask_ = 4095;
  ImGuiDebugLogFlags_OutputToTTY = 1048576;
  ImGuiDebugLogFlags_OutputToTestEngine = 2097152;

type
  ImGuiContextHookType = Integer;
  PImGuiContextHookType = ^ImGuiContextHookType;

const
  ImGuiContextHookType_NewFramePre = 0;
  ImGuiContextHookType_NewFramePost = 1;
  ImGuiContextHookType_EndFramePre = 2;
  ImGuiContextHookType_EndFramePost = 3;
  ImGuiContextHookType_RenderPre = 4;
  ImGuiContextHookType_RenderPost = 5;
  ImGuiContextHookType_Shutdown = 6;
  ImGuiContextHookType_PendingRemoval_ = 7;

type
  ImGuiTabBarFlagsPrivate_ = Integer;
  PImGuiTabBarFlagsPrivate_ = ^ImGuiTabBarFlagsPrivate_;

const
  ImGuiTabBarFlags_DockNode = 1048576;
  ImGuiTabBarFlags_IsFocused = 2097152;
  ImGuiTabBarFlags_SaveSettings = 4194304;

type
  ImGuiTabItemFlagsPrivate_ = Integer;
  PImGuiTabItemFlagsPrivate_ = ^ImGuiTabItemFlagsPrivate_;

const
  ImGuiTabItemFlags_SectionMask_ = 192;
  ImGuiTabItemFlags_NoCloseButton = 1048576;
  ImGuiTabItemFlags_Button = 2097152;
  ImGuiTabItemFlags_Invisible = 4194304;
  ImGuiTabItemFlags_Unsorted = 8388608;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PPPUTF8Char = ^PPUTF8Char;
  PPByte = ^PByte;
  PPInteger = ^PInteger;
  PPSingle = ^PSingle;
  PPDouble = ^PDouble;
  PUInt32 = ^UInt32;
  PInt8 = ^Int8;
  PNativeUInt = ^NativeUInt;
  PUInt8 = ^UInt8;
  PWideChar = ^WideChar;
  PPointer = ^Pointer;
  PXAddress = ^XAddress;
  PXNetAdapter = ^XNetAdapter;
  PXNetAdapterInfo = ^XNetAdapterInfo;
  PGLFWvidmode = ^GLFWvidmode;
  PGLFWgammaramp = ^GLFWgammaramp;
  PGLFWimage = ^GLFWimage;
  PGLFWgamepadstate = ^GLFWgamepadstate;
  PGLFWallocator = ^GLFWallocator;
  Ptm_zip_s = ^tm_zip_s;
  Pzip_fileinfo = ^zip_fileinfo;
  Ptm_unz_s = ^tm_unz_s;
  Punz_file_info64_s = ^unz_file_info64_s;
  Pc2v = ^c2v;
  Pc2r = ^c2r;
  Pc2m = ^c2m;
  Pc2x = ^c2x;
  Pc2h = ^c2h;
  Pc2Circle = ^c2Circle;
  Pc2AABB = ^c2AABB;
  Pc2Capsule = ^c2Capsule;
  Pc2Poly = ^c2Poly;
  Pc2Ray = ^c2Ray;
  Pc2Raycast = ^c2Raycast;
  Pc2Manifold = ^c2Manifold;
  Pc2GJKCache = ^c2GJKCache;
  Pc2TOIResult = ^c2TOIResult;
  Pma_allocation_callbacks = ^ma_allocation_callbacks;
  Pma_lcg = ^ma_lcg;
  Pma_atomic_uint32 = ^ma_atomic_uint32;
  Pma_atomic_int32 = ^ma_atomic_int32;
  Pma_atomic_uint64 = ^ma_atomic_uint64;
  Pma_atomic_float = ^ma_atomic_float;
  Pma_atomic_bool32 = ^ma_atomic_bool32;
  Pma_log_callback = ^ma_log_callback;
  Pma_log = ^ma_log;
  Pma_biquad_config = ^ma_biquad_config;
  Pma_biquad = ^ma_biquad;
  Pma_lpf1_config = ^ma_lpf1_config;
  Pma_lpf1 = ^ma_lpf1;
  Pma_lpf2 = ^ma_lpf2;
  Pma_lpf_config = ^ma_lpf_config;
  Pma_lpf = ^ma_lpf;
  Pma_hpf1_config = ^ma_hpf1_config;
  Pma_hpf1 = ^ma_hpf1;
  Pma_hpf2 = ^ma_hpf2;
  Pma_hpf_config = ^ma_hpf_config;
  Pma_hpf = ^ma_hpf;
  Pma_bpf2_config = ^ma_bpf2_config;
  Pma_bpf2 = ^ma_bpf2;
  Pma_bpf_config = ^ma_bpf_config;
  Pma_bpf = ^ma_bpf;
  Pma_notch2_config = ^ma_notch2_config;
  Pma_notch2 = ^ma_notch2;
  Pma_peak2_config = ^ma_peak2_config;
  Pma_peak2 = ^ma_peak2;
  Pma_loshelf2_config = ^ma_loshelf2_config;
  Pma_loshelf2 = ^ma_loshelf2;
  Pma_hishelf2_config = ^ma_hishelf2_config;
  Pma_hishelf2 = ^ma_hishelf2;
  Pma_delay_config = ^ma_delay_config;
  Pma_delay = ^ma_delay;
  Pma_gainer_config = ^ma_gainer_config;
  Pma_gainer = ^ma_gainer;
  Pma_panner_config = ^ma_panner_config;
  Pma_panner = ^ma_panner;
  Pma_fader_config = ^ma_fader_config;
  Pma_fader = ^ma_fader;
  Pma_vec3f = ^ma_vec3f;
  Pma_atomic_vec3f = ^ma_atomic_vec3f;
  Pma_spatializer_listener_config = ^ma_spatializer_listener_config;
  Pma_spatializer_listener = ^ma_spatializer_listener;
  Pma_spatializer_config = ^ma_spatializer_config;
  Pma_spatializer = ^ma_spatializer;
  Pma_linear_resampler_config = ^ma_linear_resampler_config;
  Pma_linear_resampler = ^ma_linear_resampler;
  Pma_resampling_backend_vtable = ^ma_resampling_backend_vtable;
  Pma_resampler_config = ^ma_resampler_config;
  Pma_resampler = ^ma_resampler;
  Pma_channel_converter_config = ^ma_channel_converter_config;
  Pma_channel_converter = ^ma_channel_converter;
  Pma_data_converter_config = ^ma_data_converter_config;
  Pma_data_converter = ^ma_data_converter;
  Pma_data_source_vtable = ^ma_data_source_vtable;
  Pma_data_source_config = ^ma_data_source_config;
  Pma_data_source_base = ^ma_data_source_base;
  Pma_audio_buffer_ref = ^ma_audio_buffer_ref;
  Pma_audio_buffer_config = ^ma_audio_buffer_config;
  Pma_audio_buffer = ^ma_audio_buffer;
  PPma_audio_buffer = ^Pma_audio_buffer;
  Pma_paged_audio_buffer_page = ^ma_paged_audio_buffer_page;
  PPma_paged_audio_buffer_page = ^Pma_paged_audio_buffer_page;
  Pma_paged_audio_buffer_data = ^ma_paged_audio_buffer_data;
  Pma_paged_audio_buffer_config = ^ma_paged_audio_buffer_config;
  Pma_paged_audio_buffer = ^ma_paged_audio_buffer;
  Pma_rb = ^ma_rb;
  Pma_pcm_rb = ^ma_pcm_rb;
  Pma_duplex_rb = ^ma_duplex_rb;
  Pma_fence = ^ma_fence;
  Pma_async_notification_callbacks = ^ma_async_notification_callbacks;
  Pma_async_notification_poll = ^ma_async_notification_poll;
  Pma_async_notification_event = ^ma_async_notification_event;
  Pma_slot_allocator_config = ^ma_slot_allocator_config;
  Pma_slot_allocator_group = ^ma_slot_allocator_group;
  Pma_slot_allocator = ^ma_slot_allocator;
  Pma_job = ^ma_job;
  Pma_job_queue_config = ^ma_job_queue_config;
  Pma_job_queue = ^ma_job_queue;
  Pma_atomic_device_state = ^ma_atomic_device_state;
  Pma_IMMNotificationClient = ^ma_IMMNotificationClient;
  Pma_device_job_thread_config = ^ma_device_job_thread_config;
  Pma_device_job_thread = ^ma_device_job_thread;
  Pma_device_notification = ^ma_device_notification;
  Pma_device_info = ^ma_device_info;
  PPma_device_info = ^Pma_device_info;
  Pma_device_config = ^ma_device_config;
  Pma_device_descriptor = ^ma_device_descriptor;
  Pma_backend_callbacks = ^ma_backend_callbacks;
  Pma_context_config = ^ma_context_config;
  Pma_context_command__wasapi = ^ma_context_command__wasapi;
  Pma_context = ^ma_context;
  Pma_device = ^ma_device;
  Pma_file_info = ^ma_file_info;
  Pma_vfs_callbacks = ^ma_vfs_callbacks;
  Pma_default_vfs = ^ma_default_vfs;
  Pma_decoding_backend_config = ^ma_decoding_backend_config;
  Pma_decoding_backend_vtable = ^ma_decoding_backend_vtable;
  PPma_decoding_backend_vtable = ^Pma_decoding_backend_vtable;
  Pma_decoder_config = ^ma_decoder_config;
  Pma_decoder = ^ma_decoder;
  Pma_encoder_config = ^ma_encoder_config;
  Pma_encoder = ^ma_encoder;
  Pma_waveform_config = ^ma_waveform_config;
  Pma_waveform = ^ma_waveform;
  Pma_pulsewave_config = ^ma_pulsewave_config;
  Pma_pulsewave = ^ma_pulsewave;
  Pma_noise_config = ^ma_noise_config;
  Pma_noise = ^ma_noise;
  Pma_resource_manager_pipeline_stage_notification = ^ma_resource_manager_pipeline_stage_notification;
  Pma_resource_manager_pipeline_notifications = ^ma_resource_manager_pipeline_notifications;
  Pma_resource_manager_data_source_config = ^ma_resource_manager_data_source_config;
  Pma_resource_manager_data_supply = ^ma_resource_manager_data_supply;
  Pma_resource_manager_data_buffer_node = ^ma_resource_manager_data_buffer_node;
  Pma_resource_manager_data_buffer = ^ma_resource_manager_data_buffer;
  Pma_resource_manager_data_stream = ^ma_resource_manager_data_stream;
  Pma_resource_manager_data_source = ^ma_resource_manager_data_source;
  Pma_resource_manager_config = ^ma_resource_manager_config;
  Pma_resource_manager = ^ma_resource_manager;
  Pma_stack = ^ma_stack;
  Pma_node_vtable = ^ma_node_vtable;
  Pma_node_config = ^ma_node_config;
  Pma_node_output_bus = ^ma_node_output_bus;
  Pma_node_input_bus = ^ma_node_input_bus;
  Pma_node_base = ^ma_node_base;
  Pma_node_graph_config = ^ma_node_graph_config;
  Pma_node_graph = ^ma_node_graph;
  Pma_data_source_node_config = ^ma_data_source_node_config;
  Pma_data_source_node = ^ma_data_source_node;
  Pma_splitter_node_config = ^ma_splitter_node_config;
  Pma_splitter_node = ^ma_splitter_node;
  Pma_biquad_node_config = ^ma_biquad_node_config;
  Pma_biquad_node = ^ma_biquad_node;
  Pma_lpf_node_config = ^ma_lpf_node_config;
  Pma_lpf_node = ^ma_lpf_node;
  Pma_hpf_node_config = ^ma_hpf_node_config;
  Pma_hpf_node = ^ma_hpf_node;
  Pma_bpf_node_config = ^ma_bpf_node_config;
  Pma_bpf_node = ^ma_bpf_node;
  Pma_notch_node_config = ^ma_notch_node_config;
  Pma_notch_node = ^ma_notch_node;
  Pma_peak_node_config = ^ma_peak_node_config;
  Pma_peak_node = ^ma_peak_node;
  Pma_loshelf_node_config = ^ma_loshelf_node_config;
  Pma_loshelf_node = ^ma_loshelf_node;
  Pma_hishelf_node_config = ^ma_hishelf_node_config;
  Pma_hishelf_node = ^ma_hishelf_node;
  Pma_delay_node_config = ^ma_delay_node_config;
  Pma_delay_node = ^ma_delay_node;
  Pma_engine_node_config = ^ma_engine_node_config;
  Pma_engine_node = ^ma_engine_node;
  Pma_sound_config = ^ma_sound_config;
  Pma_sound = ^ma_sound;
  Pma_sound_inlined = ^ma_sound_inlined;
  Pma_engine_config = ^ma_engine_config;
  Pma_engine = ^ma_engine;
  Pplm_packet_t = ^plm_packet_t;
  Pplm_plane_t = ^plm_plane_t;
  Pplm_frame_t = ^plm_frame_t;
  Pplm_samples_t = ^plm_samples_t;
  Psqlite3_file = ^sqlite3_file;
  Psqlite3_io_methods = ^sqlite3_io_methods;
  Psqlite3_vfs = ^sqlite3_vfs;
  Psqlite3_mem_methods = ^sqlite3_mem_methods;
  Psqlite3_module = ^sqlite3_module;
  Psqlite3_index_constraint = ^sqlite3_index_constraint;
  Psqlite3_index_orderby = ^sqlite3_index_orderby;
  Psqlite3_index_constraint_usage = ^sqlite3_index_constraint_usage;
  Psqlite3_index_info = ^sqlite3_index_info;
  Psqlite3_vtab = ^sqlite3_vtab;
  PPsqlite3_vtab = ^Psqlite3_vtab;
  Psqlite3_vtab_cursor = ^sqlite3_vtab_cursor;
  PPsqlite3_vtab_cursor = ^Psqlite3_vtab_cursor;
  Psqlite3_mutex_methods = ^sqlite3_mutex_methods;
  Psqlite3_pcache_page = ^sqlite3_pcache_page;
  Psqlite3_pcache_methods2 = ^sqlite3_pcache_methods2;
  Psqlite3_pcache_methods = ^sqlite3_pcache_methods;
  Psqlite3_snapshot = ^sqlite3_snapshot;
  PPsqlite3_snapshot = ^Psqlite3_snapshot;
  Psqlite3_rtree_geometry = ^sqlite3_rtree_geometry;
  Psqlite3_rtree_query_info = ^sqlite3_rtree_query_info;
  PFts5PhraseIter = ^Fts5PhraseIter;
  PFts5ExtensionApi = ^Fts5ExtensionApi;
  Pfts5_tokenizer_v2 = ^fts5_tokenizer_v2;
  PPfts5_tokenizer_v2 = ^Pfts5_tokenizer_v2;
  Pfts5_tokenizer = ^fts5_tokenizer;
  Pfts5_api = ^fts5_api;
  Psqlite3_api_routines = ^sqlite3_api_routines;
  Pstbi_io_callbacks = ^stbi_io_callbacks;
  Pstbrp_rect = ^stbrp_rect;
  Pstbrp_node = ^stbrp_node;
  Pstbrp_context = ^stbrp_context;
  Pstbtt__buf = ^stbtt__buf;
  Pstbtt_bakedchar = ^stbtt_bakedchar;
  Pstbtt_aligned_quad = ^stbtt_aligned_quad;
  Pstbtt_packedchar = ^stbtt_packedchar;
  Pstbtt_pack_range = ^stbtt_pack_range;
  Pstbtt_pack_context = ^stbtt_pack_context;
  Pstbtt_fontinfo = ^stbtt_fontinfo;
  Pstbtt_kerningentry = ^stbtt_kerningentry;
  Pstbtt_vertex = ^stbtt_vertex;
  PPstbtt_vertex = ^Pstbtt_vertex;
  Pstbtt__bitmap = ^stbtt__bitmap;
  PImVector_const_charPtr = ^ImVector_const_charPtr;
  PImVec2 = ^ImVec2;
  PImVec4 = ^ImVec4;
  PImGuiTableSortSpecs = ^ImGuiTableSortSpecs;
  PImGuiTableColumnSortSpecs = ^ImGuiTableColumnSortSpecs;
  PImGuiStyle = ^ImGuiStyle;
  PImGuiKeyData = ^ImGuiKeyData;
  PImVector_ImWchar = ^ImVector_ImWchar;
  PImGuiIO = ^ImGuiIO;
  PImGuiInputTextCallbackData = ^ImGuiInputTextCallbackData;
  PImGuiSizeCallbackData = ^ImGuiSizeCallbackData;
  PImGuiWindowClass = ^ImGuiWindowClass;
  PImGuiPayload = ^ImGuiPayload;
  PImGuiOnceUponAFrame = ^ImGuiOnceUponAFrame;
  PImGuiTextRange = ^ImGuiTextRange;
  PImVector_ImGuiTextRange = ^ImVector_ImGuiTextRange;
  PImGuiTextFilter = ^ImGuiTextFilter;
  PImVector_char = ^ImVector_char;
  PImGuiTextBuffer = ^ImGuiTextBuffer;
  PImGuiStoragePair = ^ImGuiStoragePair;
  PImVector_ImGuiStoragePair = ^ImVector_ImGuiStoragePair;
  PImGuiStorage = ^ImGuiStorage;
  PImGuiListClipper = ^ImGuiListClipper;
  PImColor = ^ImColor;
  PImVector_ImGuiSelectionRequest = ^ImVector_ImGuiSelectionRequest;
  PImGuiMultiSelectIO = ^ImGuiMultiSelectIO;
  PImGuiSelectionRequest = ^ImGuiSelectionRequest;
  PImGuiSelectionBasicStorage = ^ImGuiSelectionBasicStorage;
  PImGuiSelectionExternalStorage = ^ImGuiSelectionExternalStorage;
  PImDrawCmd = ^ImDrawCmd;
  PImDrawVert = ^ImDrawVert;
  PImDrawCmdHeader = ^ImDrawCmdHeader;
  PImVector_ImDrawCmd = ^ImVector_ImDrawCmd;
  PImVector_ImDrawIdx = ^ImVector_ImDrawIdx;
  PImDrawChannel = ^ImDrawChannel;
  PImVector_ImDrawChannel = ^ImVector_ImDrawChannel;
  PImDrawListSplitter = ^ImDrawListSplitter;
  PImVector_ImDrawVert = ^ImVector_ImDrawVert;
  PImVector_ImVec2 = ^ImVector_ImVec2;
  PImVector_ImVec4 = ^ImVector_ImVec4;
  PImVector_ImTextureID = ^ImVector_ImTextureID;
  PImVector_ImU8 = ^ImVector_ImU8;
  PImDrawList = ^ImDrawList;
  PPImDrawList = ^PImDrawList;
  PImVector_ImDrawListPtr = ^ImVector_ImDrawListPtr;
  PImDrawData = ^ImDrawData;
  PImFontConfig = ^ImFontConfig;
  PImFontGlyph = ^ImFontGlyph;
  PImVector_ImU32 = ^ImVector_ImU32;
  PImFontGlyphRangesBuilder = ^ImFontGlyphRangesBuilder;
  PImFontAtlasCustomRect = ^ImFontAtlasCustomRect;
  PImVector_ImFontPtr = ^ImVector_ImFontPtr;
  PImVector_ImFontAtlasCustomRect = ^ImVector_ImFontAtlasCustomRect;
  PImVector_ImFontConfig = ^ImVector_ImFontConfig;
  PImFontAtlas = ^ImFontAtlas;
  PImVector_float = ^ImVector_float;
  PImVector_ImU16 = ^ImVector_ImU16;
  PImVector_ImFontGlyph = ^ImVector_ImFontGlyph;
  PImFont = ^ImFont;
  PPImFont = ^PImFont;
  PImGuiViewport = ^ImGuiViewport;
  PPImGuiViewport = ^PImGuiViewport;
  PImVector_ImGuiPlatformMonitor = ^ImVector_ImGuiPlatformMonitor;
  PImVector_ImGuiViewportPtr = ^ImVector_ImGuiViewportPtr;
  PImGuiPlatformIO = ^ImGuiPlatformIO;
  PImGuiPlatformMonitor = ^ImGuiPlatformMonitor;
  PImGuiPlatformImeData = ^ImGuiPlatformImeData;
  PImVec1 = ^ImVec1;
  PImVec2ih = ^ImVec2ih;
  PImRect = ^ImRect;
  PImBitVector = ^ImBitVector;
  PImVector_int = ^ImVector_int;
  PImGuiTextIndex = ^ImGuiTextIndex;
  PImDrawListSharedData = ^ImDrawListSharedData;
  PImDrawDataBuilder = ^ImDrawDataBuilder;
  PImGuiStyleVarInfo = ^ImGuiStyleVarInfo;
  PImGuiColorMod = ^ImGuiColorMod;
  PImGuiStyleMod = ^ImGuiStyleMod;
  PImGuiDataTypeStorage = ^ImGuiDataTypeStorage;
  PImGuiDataTypeInfo = ^ImGuiDataTypeInfo;
  PImGuiComboPreviewData = ^ImGuiComboPreviewData;
  PImGuiGroupData = ^ImGuiGroupData;
  PImGuiMenuColumns = ^ImGuiMenuColumns;
  PImGuiInputTextDeactivatedState = ^ImGuiInputTextDeactivatedState;
  PImGuiInputTextState = ^ImGuiInputTextState;
  PImGuiNextWindowData = ^ImGuiNextWindowData;
  PImGuiNextItemData = ^ImGuiNextItemData;
  PImGuiLastItemData = ^ImGuiLastItemData;
  PImGuiTreeNodeStackData = ^ImGuiTreeNodeStackData;
  PImGuiErrorRecoveryState = ^ImGuiErrorRecoveryState;
  PImGuiWindowStackData = ^ImGuiWindowStackData;
  PImGuiShrinkWidthItem = ^ImGuiShrinkWidthItem;
  PImGuiPtrOrIndex = ^ImGuiPtrOrIndex;
  PImGuiDeactivatedItemData = ^ImGuiDeactivatedItemData;
  PImGuiPopupData = ^ImGuiPopupData;
  PImBitArray_ImGuiKey_NamedKey_COUNT__lessImGuiKey_NamedKey_BEGIN = ^ImBitArray_ImGuiKey_NamedKey_COUNT__lessImGuiKey_NamedKey_BEGIN;
  PImGuiInputEventMousePos = ^ImGuiInputEventMousePos;
  PImGuiInputEventMouseWheel = ^ImGuiInputEventMouseWheel;
  PImGuiInputEventMouseButton = ^ImGuiInputEventMouseButton;
  PImGuiInputEventMouseViewport = ^ImGuiInputEventMouseViewport;
  PImGuiInputEventKey = ^ImGuiInputEventKey;
  PImGuiInputEventText = ^ImGuiInputEventText;
  PImGuiInputEventAppFocused = ^ImGuiInputEventAppFocused;
  PImGuiInputEvent = ^ImGuiInputEvent;
  PImGuiKeyRoutingData = ^ImGuiKeyRoutingData;
  PImVector_ImGuiKeyRoutingData = ^ImVector_ImGuiKeyRoutingData;
  PImGuiKeyRoutingTable = ^ImGuiKeyRoutingTable;
  PImGuiKeyOwnerData = ^ImGuiKeyOwnerData;
  PImGuiListClipperRange = ^ImGuiListClipperRange;
  PImVector_ImGuiListClipperRange = ^ImVector_ImGuiListClipperRange;
  PImGuiListClipperData = ^ImGuiListClipperData;
  PImGuiNavItemData = ^ImGuiNavItemData;
  PImGuiFocusScopeData = ^ImGuiFocusScopeData;
  PImGuiTypingSelectRequest = ^ImGuiTypingSelectRequest;
  PImGuiTypingSelectState = ^ImGuiTypingSelectState;
  PImGuiOldColumnData = ^ImGuiOldColumnData;
  PImVector_ImGuiOldColumnData = ^ImVector_ImGuiOldColumnData;
  PImGuiOldColumns = ^ImGuiOldColumns;
  PImGuiBoxSelectState = ^ImGuiBoxSelectState;
  PImGuiMultiSelectTempData = ^ImGuiMultiSelectTempData;
  PImGuiMultiSelectState = ^ImGuiMultiSelectState;
  PImVector_ImGuiWindowPtr = ^ImVector_ImGuiWindowPtr;
  PImGuiDockNode = ^ImGuiDockNode;
  PImGuiWindowDockStyle = ^ImGuiWindowDockStyle;
  PImVector_ImGuiDockRequest = ^ImVector_ImGuiDockRequest;
  PImVector_ImGuiDockNodeSettings = ^ImVector_ImGuiDockNodeSettings;
  PImGuiDockContext = ^ImGuiDockContext;
  PImGuiViewportP = ^ImGuiViewportP;
  PPImGuiViewportP = ^PImGuiViewportP;
  PImGuiWindowSettings = ^ImGuiWindowSettings;
  PImGuiSettingsHandler = ^ImGuiSettingsHandler;
  PImGuiLocEntry = ^ImGuiLocEntry;
  PImGuiDebugAllocEntry = ^ImGuiDebugAllocEntry;
  PImGuiDebugAllocInfo = ^ImGuiDebugAllocInfo;
  PImGuiMetricsConfig = ^ImGuiMetricsConfig;
  PImGuiStackLevelInfo = ^ImGuiStackLevelInfo;
  PImVector_ImGuiStackLevelInfo = ^ImVector_ImGuiStackLevelInfo;
  PImGuiIDStackTool = ^ImGuiIDStackTool;
  PImGuiContextHook = ^ImGuiContextHook;
  PImVector_ImGuiInputEvent = ^ImVector_ImGuiInputEvent;
  PImVector_ImGuiWindowStackData = ^ImVector_ImGuiWindowStackData;
  PImVector_ImGuiColorMod = ^ImVector_ImGuiColorMod;
  PImVector_ImGuiStyleMod = ^ImVector_ImGuiStyleMod;
  PImVector_ImGuiFocusScopeData = ^ImVector_ImGuiFocusScopeData;
  PImVector_ImGuiItemFlags = ^ImVector_ImGuiItemFlags;
  PImVector_ImGuiGroupData = ^ImVector_ImGuiGroupData;
  PImVector_ImGuiPopupData = ^ImVector_ImGuiPopupData;
  PImVector_ImGuiTreeNodeStackData = ^ImVector_ImGuiTreeNodeStackData;
  PImVector_ImGuiViewportPPtr = ^ImVector_ImGuiViewportPPtr;
  PImVector_unsigned_char = ^ImVector_unsigned_char;
  PImVector_ImGuiListClipperData = ^ImVector_ImGuiListClipperData;
  PImVector_ImGuiTableTempData = ^ImVector_ImGuiTableTempData;
  PImVector_ImGuiTable = ^ImVector_ImGuiTable;
  PImPool_ImGuiTable = ^ImPool_ImGuiTable;
  PImVector_ImGuiTabBar = ^ImVector_ImGuiTabBar;
  PImPool_ImGuiTabBar = ^ImPool_ImGuiTabBar;
  PImVector_ImGuiPtrOrIndex = ^ImVector_ImGuiPtrOrIndex;
  PImVector_ImGuiShrinkWidthItem = ^ImVector_ImGuiShrinkWidthItem;
  PImVector_ImGuiMultiSelectTempData = ^ImVector_ImGuiMultiSelectTempData;
  PImVector_ImGuiMultiSelectState = ^ImVector_ImGuiMultiSelectState;
  PImPool_ImGuiMultiSelectState = ^ImPool_ImGuiMultiSelectState;
  PImVector_ImGuiID = ^ImVector_ImGuiID;
  PImVector_ImGuiSettingsHandler = ^ImVector_ImGuiSettingsHandler;
  PImChunkStream_ImGuiWindowSettings = ^ImChunkStream_ImGuiWindowSettings;
  PImChunkStream_ImGuiTableSettings = ^ImChunkStream_ImGuiTableSettings;
  PImVector_ImGuiContextHook = ^ImVector_ImGuiContextHook;
  PImGuiContext = ^ImGuiContext;
  PImGuiWindowTempData = ^ImGuiWindowTempData;
  PImVector_ImGuiOldColumns = ^ImVector_ImGuiOldColumns;
  PImGuiWindow = ^ImGuiWindow;
  PPImGuiWindow = ^PImGuiWindow;
  PImGuiTabItem = ^ImGuiTabItem;
  PImVector_ImGuiTabItem = ^ImVector_ImGuiTabItem;
  PImGuiTabBar = ^ImGuiTabBar;
  PImGuiTableColumn = ^ImGuiTableColumn;
  PImGuiTableCellData = ^ImGuiTableCellData;
  PImGuiTableHeaderData = ^ImGuiTableHeaderData;
  PImGuiTableInstanceData = ^ImGuiTableInstanceData;
  PImSpan_ImGuiTableColumn = ^ImSpan_ImGuiTableColumn;
  PImSpan_ImGuiTableColumnIdx = ^ImSpan_ImGuiTableColumnIdx;
  PImSpan_ImGuiTableCellData = ^ImSpan_ImGuiTableCellData;
  PImVector_ImGuiTableInstanceData = ^ImVector_ImGuiTableInstanceData;
  PImVector_ImGuiTableColumnSortSpecs = ^ImVector_ImGuiTableColumnSortSpecs;
  PImGuiTable = ^ImGuiTable;
  PImVector_ImGuiTableHeaderData = ^ImVector_ImGuiTableHeaderData;
  PImGuiTableTempData = ^ImGuiTableTempData;
  PImGuiTableColumnSettings = ^ImGuiTableColumnSettings;
  PImGuiTableSettings = ^ImGuiTableSettings;
  PImFontBuilderIO = ^ImFontBuilderIO;

  XSocket = TSOCKET;
  PXSocket = ^XSocket;
  socklen_t = Int32;

  XAddress = record
    family: Int32;
    addrlen: socklen_t;
    addr: sockaddr_storage;
  end;

  XNetAdapter = record
    name: array [0..127] of Int8;
  end;

  XNetAdapterInfo = record
    name: array [0..127] of Int8;
    description: array [0..255] of Int8;
    mac: array [0..17] of Int8;
    ipv4: array [0..15] of Int8;
    ipv6: array [0..45] of Int8;
    speed_bps: UInt64;
    is_wireless: Boolean;
    mtu: Int32;
    ifindex: UInt32;
  end;

  GLFWglproc = procedure(); cdecl;

  GLFWvkproc = procedure(); cdecl;
  PGLFWmonitor = Pointer;
  PPGLFWmonitor = ^PGLFWmonitor;
  PGLFWwindow = Pointer;
  PPGLFWwindow = ^PGLFWwindow;
  PGLFWcursor = Pointer;
  PPGLFWcursor = ^PGLFWcursor;

  GLFWallocatefun = function(size: NativeUInt; user: Pointer): Pointer; cdecl;

  GLFWreallocatefun = function(block: Pointer; size: NativeUInt; user: Pointer): Pointer; cdecl;

  GLFWdeallocatefun = procedure(block: Pointer; user: Pointer); cdecl;

  GLFWerrorfun = procedure(error_code: Integer; const description: PUTF8Char); cdecl;

  GLFWwindowposfun = procedure(window: PGLFWwindow; xpos: Integer; ypos: Integer); cdecl;

  GLFWwindowsizefun = procedure(window: PGLFWwindow; width: Integer; height: Integer); cdecl;

  GLFWwindowclosefun = procedure(window: PGLFWwindow); cdecl;

  GLFWwindowrefreshfun = procedure(window: PGLFWwindow); cdecl;

  GLFWwindowfocusfun = procedure(window: PGLFWwindow; focused: Integer); cdecl;

  GLFWwindowiconifyfun = procedure(window: PGLFWwindow; iconified: Integer); cdecl;

  GLFWwindowmaximizefun = procedure(window: PGLFWwindow; maximized: Integer); cdecl;

  GLFWframebuffersizefun = procedure(window: PGLFWwindow; width: Integer; height: Integer); cdecl;

  GLFWwindowcontentscalefun = procedure(window: PGLFWwindow; xscale: Single; yscale: Single); cdecl;

  GLFWmousebuttonfun = procedure(window: PGLFWwindow; button: Integer; action: Integer; mods: Integer); cdecl;

  GLFWcursorposfun = procedure(window: PGLFWwindow; xpos: Double; ypos: Double); cdecl;

  GLFWcursorenterfun = procedure(window: PGLFWwindow; entered: Integer); cdecl;

  GLFWscrollfun = procedure(window: PGLFWwindow; xoffset: Double; yoffset: Double); cdecl;

  GLFWkeyfun = procedure(window: PGLFWwindow; key: Integer; scancode: Integer; action: Integer; mods: Integer); cdecl;

  GLFWcharfun = procedure(window: PGLFWwindow; codepoint: Cardinal); cdecl;

  GLFWcharmodsfun = procedure(window: PGLFWwindow; codepoint: Cardinal; mods: Integer); cdecl;

  GLFWdropfun = procedure(window: PGLFWwindow; path_count: Integer; paths: PPUTF8Char); cdecl;

  GLFWmonitorfun = procedure(monitor: PGLFWmonitor; event: Integer); cdecl;

  GLFWjoystickfun = procedure(jid: Integer; event: Integer); cdecl;

  GLFWvidmode = record
    width: Integer;
    height: Integer;
    redBits: Integer;
    greenBits: Integer;
    blueBits: Integer;
    refreshRate: Integer;
  end;

  GLFWgammaramp = record
    red: PWord;
    green: PWord;
    blue: PWord;
    size: Cardinal;
  end;

  GLFWimage = record
    width: Integer;
    height: Integer;
    pixels: PByte;
  end;

  GLFWgamepadstate = record
    buttons: array [0..14] of Byte;
    axes: array [0..5] of Single;
  end;

  GLFWallocator = record
    allocate: GLFWallocatefun;
    reallocate: GLFWreallocatefun;
    deallocate: GLFWdeallocatefun;
    user: Pointer;
  end;

  voidp = Pointer;
  unzFile = voidp;
  zipFile = voidp;
  uInt = Cardinal;
  uLong = Longword;
  Bytef = &Byte;
  PBytef = ^Bytef;

  tm_zip_s = record
    tm_sec: Integer;
    tm_min: Integer;
    tm_hour: Integer;
    tm_mday: Integer;
    tm_mon: Integer;
    tm_year: Integer;
  end;

  tm_zip = tm_zip_s;

  zip_fileinfo = record
    tmz_date: tm_zip;
    dosDate: uLong;
    internal_fa: uLong;
    external_fa: uLong;
  end;

  tm_unz_s = record
    tm_sec: Integer;
    tm_min: Integer;
    tm_hour: Integer;
    tm_mday: Integer;
    tm_mon: Integer;
    tm_year: Integer;
  end;

  tm_unz = tm_unz_s;

  unz_file_info64_s = record
    version: uLong;
    version_needed: uLong;
    flag: uLong;
    compression_method: uLong;
    dosDate: uLong;
    crc: uLong;
    compressed_size: UInt64;
    uncompressed_size: UInt64;
    size_filename: uLong;
    size_file_extra: uLong;
    size_file_comment: uLong;
    disk_num_start: uLong;
    internal_fa: uLong;
    external_fa: uLong;
    tmu_date: tm_unz;
  end;

  unz_file_info64 = unz_file_info64_s;
  Punz_file_info64 = ^unz_file_info64;

  c2v = record
    x: Single;
    y: Single;
  end;

  c2r = record
    c: Single;
    s: Single;
  end;

  c2m = record
    x: c2v;
    y: c2v;
  end;

  c2x = record
    p: c2v;
    r: c2r;
  end;

  c2h = record
    n: c2v;
    d: Single;
  end;

  c2Circle = record
    p: c2v;
    r: Single;
  end;

  c2AABB = record
    min: c2v;
    max: c2v;
  end;

  c2Capsule = record
    a: c2v;
    b: c2v;
    r: Single;
  end;

  c2Poly = record
    count: Integer;
    verts: array [0..7] of c2v;
    norms: array [0..7] of c2v;
  end;

  c2Ray = record
    p: c2v;
    d: c2v;
    t: Single;
  end;

  c2Raycast = record
    t: Single;
    n: c2v;
  end;

  c2Manifold = record
    count: Integer;
    depths: array [0..1] of Single;
    contact_points: array [0..1] of c2v;
    n: c2v;
  end;

  c2GJKCache = record
    metric: Single;
    count: Integer;
    iA: array [0..2] of Integer;
    iB: array [0..2] of Integer;
    &div: Single;
  end;

  c2TOIResult = record
    hit: Integer;
    toi: Single;
    n: c2v;
    p: c2v;
    iterations: Integer;
  end;

  ma_int8 = UTF8Char;
  ma_uint8 = Byte;
  Pma_uint8 = ^ma_uint8;
  ma_int16 = Smallint;
  Pma_int16 = ^ma_int16;
  ma_uint16 = Word;
  ma_int32 = Integer;
  Pma_int32 = ^ma_int32;
  PPma_int32 = ^Pma_int32;
  ma_uint32 = Cardinal;
  Pma_uint32 = ^ma_uint32;
  ma_int64 = Int64;
  Pma_int64 = ^ma_int64;
  ma_uint64 = UInt64;
  Pma_uint64 = ^ma_uint64;
  ma_uintptr = ma_uint64;
  ma_bool8 = ma_uint8;
  ma_bool32 = ma_uint32;
  ma_float = Single;
  ma_double = Double;
  ma_handle = Pointer;
  ma_ptr = Pointer;
  Pma_ptr = ^ma_ptr;
  ma_proc = Pointer;
  ma_wchar_win32 = WideChar;
  ma_channel = ma_uint8;
  Pma_channel = ^ma_channel;

  ma_allocation_callbacks = record
    pUserData: Pointer;
    onMalloc: function(sz: NativeUInt; pUserData: Pointer): Pointer; cdecl;
    onRealloc: function(p: Pointer; sz: NativeUInt; pUserData: Pointer): Pointer; cdecl;
    onFree: procedure(p: Pointer; pUserData: Pointer); cdecl;
  end;

  ma_lcg = record
    state: ma_int32;
  end;

  ma_atomic_uint32 = record
    value: ma_uint32;
  end;

  ma_atomic_int32 = record
    value: ma_int32;
  end;

  ma_atomic_uint64 = record
    value: ma_uint64;
  end;

  ma_atomic_float = record
    value: ma_float;
  end;

  ma_atomic_bool32 = record
    value: ma_bool32;
  end;

  ma_spinlock = ma_uint32;
  Pma_spinlock = ^ma_spinlock;
  ma_thread = ma_handle;
  ma_mutex = ma_handle;
  Pma_mutex = ^ma_mutex;
  ma_event = ma_handle;
  Pma_event = ^ma_event;
  ma_semaphore = ma_handle;
  Pma_semaphore = ^ma_semaphore;

  ma_log_callback_proc = procedure(pUserData: Pointer; level: ma_uint32; const pMessage: PUTF8Char); cdecl;

  ma_log_callback = record
    onLog: ma_log_callback_proc;
    pUserData: Pointer;
  end;

  ma_log = record
    callbacks: array [0..3] of ma_log_callback;
    callbackCount: ma_uint32;
    allocationCallbacks: ma_allocation_callbacks;
    lock: ma_mutex;
  end;

  Pma_biquad_coefficient = ^ma_biquad_coefficient;
  ma_biquad_coefficient = record
    case Integer of
      0: (f32: Single);
      1: (s32: ma_int32);
  end;

  ma_biquad_config = record
    format: ma_format;
    channels: ma_uint32;
    b0: Double;
    b1: Double;
    b2: Double;
    a0: Double;
    a1: Double;
    a2: Double;
  end;

  ma_biquad = record
    format: ma_format;
    channels: ma_uint32;
    b0: ma_biquad_coefficient;
    b1: ma_biquad_coefficient;
    b2: ma_biquad_coefficient;
    a1: ma_biquad_coefficient;
    a2: ma_biquad_coefficient;
    pR1: Pma_biquad_coefficient;
    pR2: Pma_biquad_coefficient;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_lpf1_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    q: Double;
  end;

  ma_lpf2_config = ma_lpf1_config;
  Pma_lpf2_config = ^ma_lpf2_config;

  ma_lpf1 = record
    format: ma_format;
    channels: ma_uint32;
    a: ma_biquad_coefficient;
    pR1: Pma_biquad_coefficient;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_lpf2 = record
    bq: ma_biquad;
  end;

  ma_lpf_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    order: ma_uint32;
  end;

  ma_lpf = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    lpf1Count: ma_uint32;
    lpf2Count: ma_uint32;
    pLPF1: Pma_lpf1;
    pLPF2: Pma_lpf2;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_hpf1_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    q: Double;
  end;

  ma_hpf2_config = ma_hpf1_config;
  Pma_hpf2_config = ^ma_hpf2_config;

  ma_hpf1 = record
    format: ma_format;
    channels: ma_uint32;
    a: ma_biquad_coefficient;
    pR1: Pma_biquad_coefficient;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_hpf2 = record
    bq: ma_biquad;
  end;

  ma_hpf_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    order: ma_uint32;
  end;

  ma_hpf = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    hpf1Count: ma_uint32;
    hpf2Count: ma_uint32;
    pHPF1: Pma_hpf1;
    pHPF2: Pma_hpf2;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_bpf2_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    q: Double;
  end;

  ma_bpf2 = record
    bq: ma_biquad;
  end;

  ma_bpf_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cutoffFrequency: Double;
    order: ma_uint32;
  end;

  ma_bpf = record
    format: ma_format;
    channels: ma_uint32;
    bpf2Count: ma_uint32;
    pBPF2: Pma_bpf2;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_notch2_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    q: Double;
    frequency: Double;
  end;

  ma_notch_config = ma_notch2_config;
  Pma_notch_config = ^ma_notch_config;

  ma_notch2 = record
    bq: ma_biquad;
  end;

  ma_peak2_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    gainDB: Double;
    q: Double;
    frequency: Double;
  end;

  ma_peak_config = ma_peak2_config;
  Pma_peak_config = ^ma_peak_config;

  ma_peak2 = record
    bq: ma_biquad;
  end;

  ma_loshelf2_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    gainDB: Double;
    shelfSlope: Double;
    frequency: Double;
  end;

  ma_loshelf_config = ma_loshelf2_config;
  Pma_loshelf_config = ^ma_loshelf_config;

  ma_loshelf2 = record
    bq: ma_biquad;
  end;

  ma_hishelf2_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    gainDB: Double;
    shelfSlope: Double;
    frequency: Double;
  end;

  ma_hishelf_config = ma_hishelf2_config;
  Pma_hishelf_config = ^ma_hishelf_config;

  ma_hishelf2 = record
    bq: ma_biquad;
  end;

  ma_delay_config = record
    channels: ma_uint32;
    sampleRate: ma_uint32;
    delayInFrames: ma_uint32;
    delayStart: ma_bool32;
    wet: Single;
    dry: Single;
    decay: Single;
  end;

  ma_delay = record
    config: ma_delay_config;
    cursor: ma_uint32;
    bufferSizeInFrames: ma_uint32;
    pBuffer: PSingle;
  end;

  ma_gainer_config = record
    channels: ma_uint32;
    smoothTimeInFrames: ma_uint32;
  end;

  ma_gainer = record
    config: ma_gainer_config;
    t: ma_uint32;
    masterVolume: Single;
    pOldGains: PSingle;
    pNewGains: PSingle;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_panner_config = record
    format: ma_format;
    channels: ma_uint32;
    mode: ma_pan_mode;
    pan: Single;
  end;

  ma_panner = record
    format: ma_format;
    channels: ma_uint32;
    mode: ma_pan_mode;
    pan: Single;
  end;

  ma_fader_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
  end;

  ma_fader = record
    config: ma_fader_config;
    volumeBeg: Single;
    volumeEnd: Single;
    lengthInFrames: ma_uint64;
    cursorInFrames: ma_int64;
  end;

  ma_vec3f = record
    x: Single;
    y: Single;
    z: Single;
  end;

  ma_atomic_vec3f = record
    v: ma_vec3f;
    lock: ma_spinlock;
  end;

  ma_spatializer_listener_config = record
    channelsOut: ma_uint32;
    pChannelMapOut: Pma_channel;
    handedness: ma_handedness;
    coneInnerAngleInRadians: Single;
    coneOuterAngleInRadians: Single;
    coneOuterGain: Single;
    speedOfSound: Single;
    worldUp: ma_vec3f;
  end;

  ma_spatializer_listener = record
    config: ma_spatializer_listener_config;
    position: ma_atomic_vec3f;
    direction: ma_atomic_vec3f;
    velocity: ma_atomic_vec3f;
    isEnabled: ma_bool32;
    _ownsHeap: ma_bool32;
    _pHeap: Pointer;
  end;

  ma_spatializer_config = record
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    pChannelMapIn: Pma_channel;
    attenuationModel: ma_attenuation_model;
    positioning: ma_positioning;
    handedness: ma_handedness;
    minGain: Single;
    maxGain: Single;
    minDistance: Single;
    maxDistance: Single;
    rolloff: Single;
    coneInnerAngleInRadians: Single;
    coneOuterAngleInRadians: Single;
    coneOuterGain: Single;
    dopplerFactor: Single;
    directionalAttenuationFactor: Single;
    minSpatializationChannelGain: Single;
    gainSmoothTimeInFrames: ma_uint32;
  end;

  ma_spatializer = record
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    pChannelMapIn: Pma_channel;
    attenuationModel: ma_attenuation_model;
    positioning: ma_positioning;
    handedness: ma_handedness;
    minGain: Single;
    maxGain: Single;
    minDistance: Single;
    maxDistance: Single;
    rolloff: Single;
    coneInnerAngleInRadians: Single;
    coneOuterAngleInRadians: Single;
    coneOuterGain: Single;
    dopplerFactor: Single;
    directionalAttenuationFactor: Single;
    gainSmoothTimeInFrames: ma_uint32;
    position: ma_atomic_vec3f;
    direction: ma_atomic_vec3f;
    velocity: ma_atomic_vec3f;
    dopplerPitch: Single;
    minSpatializationChannelGain: Single;
    gainer: ma_gainer;
    pNewChannelGainsOut: PSingle;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_linear_resampler_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRateIn: ma_uint32;
    sampleRateOut: ma_uint32;
    lpfOrder: ma_uint32;
    lpfNyquistFactor: Double;
  end;

  P_anonymous_type_10 = ^_anonymous_type_10;
  _anonymous_type_10 = record
    case Integer of
      0: (f32: PSingle);
      1: (s16: Pma_int16);
  end;

  P_anonymous_type_11 = ^_anonymous_type_11;
  _anonymous_type_11 = record
    case Integer of
      0: (f32: PSingle);
      1: (s16: Pma_int16);
  end;

  ma_linear_resampler = record
    config: ma_linear_resampler_config;
    inAdvanceInt: ma_uint32;
    inAdvanceFrac: ma_uint32;
    inTimeInt: ma_uint32;
    inTimeFrac: ma_uint32;
    x0: _anonymous_type_10;
    x1: _anonymous_type_11;
    lpf: ma_lpf;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  Pma_resampling_backend = Pointer;
  PPma_resampling_backend = ^Pma_resampling_backend;

  ma_resampling_backend_vtable = record
    onGetHeapSize: function(pUserData: Pointer; const pConfig: Pma_resampler_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
    onInit: function(pUserData: Pointer; const pConfig: Pma_resampler_config; pHeap: Pointer; ppBackend: PPma_resampling_backend): ma_result; cdecl;
    onUninit: procedure(pUserData: Pointer; pBackend: Pma_resampling_backend; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
    onProcess: function(pUserData: Pointer; pBackend: Pma_resampling_backend; const pFramesIn: Pointer; pFrameCountIn: Pma_uint64; pFramesOut: Pointer; pFrameCountOut: Pma_uint64): ma_result; cdecl;
    onSetRate: function(pUserData: Pointer; pBackend: Pma_resampling_backend; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_result; cdecl;
    onGetInputLatency: function(pUserData: Pointer; const pBackend: Pma_resampling_backend): ma_uint64; cdecl;
    onGetOutputLatency: function(pUserData: Pointer; const pBackend: Pma_resampling_backend): ma_uint64; cdecl;
    onGetRequiredInputFrameCount: function(pUserData: Pointer; const pBackend: Pma_resampling_backend; outputFrameCount: ma_uint64; pInputFrameCount: Pma_uint64): ma_result; cdecl;
    onGetExpectedOutputFrameCount: function(pUserData: Pointer; const pBackend: Pma_resampling_backend; inputFrameCount: ma_uint64; pOutputFrameCount: Pma_uint64): ma_result; cdecl;
    onReset: function(pUserData: Pointer; pBackend: Pma_resampling_backend): ma_result; cdecl;
  end;

  P_anonymous_type_12 = ^_anonymous_type_12;
  _anonymous_type_12 = record
    lpfOrder: ma_uint32;
  end;

  ma_resampler_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRateIn: ma_uint32;
    sampleRateOut: ma_uint32;
    algorithm: ma_resample_algorithm;
    pBackendVTable: Pma_resampling_backend_vtable;
    pBackendUserData: Pointer;
    linear: _anonymous_type_12;
  end;

  P_anonymous_type_13 = ^_anonymous_type_13;
  _anonymous_type_13 = record
    case Integer of
      0: (linear: ma_linear_resampler);
  end;

  ma_resampler = record
    pBackend: Pma_resampling_backend;
    pBackendVTable: Pma_resampling_backend_vtable;
    pBackendUserData: Pointer;
    format: ma_format;
    channels: ma_uint32;
    sampleRateIn: ma_uint32;
    sampleRateOut: ma_uint32;
    state: _anonymous_type_13;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_channel_converter_config = record
    format: ma_format;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    pChannelMapIn: Pma_channel;
    pChannelMapOut: Pma_channel;
    mixingMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    ppWeights: PPSingle;
  end;

  P_anonymous_type_14 = ^_anonymous_type_14;
  _anonymous_type_14 = record
    case Integer of
      0: (f32: PPSingle);
      1: (s16: PPma_int32);
  end;

  ma_channel_converter = record
    format: ma_format;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    mixingMode: ma_channel_mix_mode;
    conversionPath: ma_channel_conversion_path;
    pChannelMapIn: Pma_channel;
    pChannelMapOut: Pma_channel;
    pShuffleTable: Pma_uint8;
    weights: _anonymous_type_14;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_data_converter_config = record
    formatIn: ma_format;
    formatOut: ma_format;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    sampleRateIn: ma_uint32;
    sampleRateOut: ma_uint32;
    pChannelMapIn: Pma_channel;
    pChannelMapOut: Pma_channel;
    ditherMode: ma_dither_mode;
    channelMixMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    ppChannelWeights: PPSingle;
    allowDynamicSampleRate: ma_bool32;
    resampling: ma_resampler_config;
  end;

  ma_data_converter = record
    formatIn: ma_format;
    formatOut: ma_format;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    sampleRateIn: ma_uint32;
    sampleRateOut: ma_uint32;
    ditherMode: ma_dither_mode;
    executionPath: ma_data_converter_execution_path;
    channelConverter: ma_channel_converter;
    resampler: ma_resampler;
    hasPreFormatConversion: ma_bool8;
    hasPostFormatConversion: ma_bool8;
    hasChannelConverter: ma_bool8;
    hasResampler: ma_bool8;
    isPassthrough: ma_bool8;
    _ownsHeap: ma_bool8;
    _pHeap: Pointer;
  end;

  Pma_data_source = Pointer;
  PPma_data_source = ^Pma_data_source;

  ma_data_source_vtable = record
    onRead: function(pDataSource: Pma_data_source; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
    onSeek: function(pDataSource: Pma_data_source; frameIndex: ma_uint64): ma_result; cdecl;
    onGetDataFormat: function(pDataSource: Pma_data_source; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
    onGetCursor: function(pDataSource: Pma_data_source; pCursor: Pma_uint64): ma_result; cdecl;
    onGetLength: function(pDataSource: Pma_data_source; pLength: Pma_uint64): ma_result; cdecl;
    onSetLooping: function(pDataSource: Pma_data_source; isLooping: ma_bool32): ma_result; cdecl;
    flags: ma_uint32;
  end;

  ma_data_source_get_next_proc = function(pDataSource: Pma_data_source): Pma_data_source; cdecl;

  ma_data_source_config = record
    vtable: Pma_data_source_vtable;
  end;

  ma_data_source_base = record
    vtable: Pma_data_source_vtable;
    rangeBegInFrames: ma_uint64;
    rangeEndInFrames: ma_uint64;
    loopBegInFrames: ma_uint64;
    loopEndInFrames: ma_uint64;
    pCurrent: Pma_data_source;
    pNext: Pma_data_source;
    onGetNext: ma_data_source_get_next_proc;
    isLooping: ma_bool32;
  end;

  ma_audio_buffer_ref = record
    ds: ma_data_source_base;
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    cursor: ma_uint64;
    sizeInFrames: ma_uint64;
    pData: Pointer;
  end;

  ma_audio_buffer_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    sizeInFrames: ma_uint64;
    pData: Pointer;
    allocationCallbacks: ma_allocation_callbacks;
  end;

  ma_audio_buffer = record
    ref: ma_audio_buffer_ref;
    allocationCallbacks: ma_allocation_callbacks;
    ownsData: ma_bool32;
    _pExtraData: array [0..0] of ma_uint8;
  end;

  ma_paged_audio_buffer_page = record
    pNext: Pma_paged_audio_buffer_page;
    sizeInFrames: ma_uint64;
    pAudioData: array [0..0] of ma_uint8;
  end;

  ma_paged_audio_buffer_data = record
    format: ma_format;
    channels: ma_uint32;
    head: ma_paged_audio_buffer_page;
    pTail: Pma_paged_audio_buffer_page;
  end;

  ma_paged_audio_buffer_config = record
    pData: Pma_paged_audio_buffer_data;
  end;

  ma_paged_audio_buffer = record
    ds: ma_data_source_base;
    pData: Pma_paged_audio_buffer_data;
    pCurrent: Pma_paged_audio_buffer_page;
    relativeCursor: ma_uint64;
    absoluteCursor: ma_uint64;
  end;

  ma_rb = record
    pBuffer: Pointer;
    subbufferSizeInBytes: ma_uint32;
    subbufferCount: ma_uint32;
    subbufferStrideInBytes: ma_uint32;
    encodedReadOffset: ma_uint32;
    encodedWriteOffset: ma_uint32;
    ownsBuffer: ma_bool8;
    clearOnWriteAcquire: ma_bool8;
    allocationCallbacks: ma_allocation_callbacks;
  end;

  ma_pcm_rb = record
    ds: ma_data_source_base;
    rb: ma_rb;
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
  end;

  ma_duplex_rb = record
    rb: ma_pcm_rb;
  end;

  ma_fence = record
    e: ma_event;
    counter: ma_uint32;
  end;

  Pma_async_notification = Pointer;
  PPma_async_notification = ^Pma_async_notification;

  ma_async_notification_callbacks = record
    onSignal: procedure(pNotification: Pma_async_notification); cdecl;
  end;

  ma_async_notification_poll = record
    cb: ma_async_notification_callbacks;
    signalled: ma_bool32;
  end;

  ma_async_notification_event = record
    cb: ma_async_notification_callbacks;
    e: ma_event;
  end;

  ma_slot_allocator_config = record
    capacity: ma_uint32;
  end;

  ma_slot_allocator_group = record
    bitfield: ma_uint32;
  end;

  ma_slot_allocator = record
    pGroups: Pma_slot_allocator_group;
    pSlots: Pma_uint32;
    count: ma_uint32;
    capacity: ma_uint32;
    _ownsHeap: ma_bool32;
    _pHeap: Pointer;
  end;

  ma_job_proc = function(pJob: Pma_job): ma_result; cdecl;

  P_anonymous_type_15 = ^_anonymous_type_15;
  _anonymous_type_15 = record
    code: ma_uint16;
    slot: ma_uint16;
    refcount: ma_uint32;
  end;

  P_anonymous_type_16 = ^_anonymous_type_16;
  _anonymous_type_16 = record
    case Integer of
      0: (breakup: _anonymous_type_15);
      1: (allocation: ma_uint64);
  end;

  P_anonymous_type_17 = ^_anonymous_type_17;
  _anonymous_type_17 = record
    proc: ma_job_proc;
    data0: ma_uintptr;
    data1: ma_uintptr;
  end;

  P_anonymous_type_18 = ^_anonymous_type_18;
  _anonymous_type_18 = record
    pResourceManager: Pointer;
    pDataBufferNode: Pointer;
    pFilePath: PUTF8Char;
    pFilePathW: PWideChar;
    flags: ma_uint32;
    pInitNotification: Pma_async_notification;
    pDoneNotification: Pma_async_notification;
    pInitFence: Pma_fence;
    pDoneFence: Pma_fence;
  end;

  P_anonymous_type_19 = ^_anonymous_type_19;
  _anonymous_type_19 = record
    pResourceManager: Pointer;
    pDataBufferNode: Pointer;
    pDoneNotification: Pma_async_notification;
    pDoneFence: Pma_fence;
  end;

  P_anonymous_type_20 = ^_anonymous_type_20;
  _anonymous_type_20 = record
    pResourceManager: Pointer;
    pDataBufferNode: Pointer;
    pDecoder: Pointer;
    pDoneNotification: Pma_async_notification;
    pDoneFence: Pma_fence;
  end;

  P_anonymous_type_21 = ^_anonymous_type_21;
  _anonymous_type_21 = record
    pDataBuffer: Pointer;
    pInitNotification: Pma_async_notification;
    pDoneNotification: Pma_async_notification;
    pInitFence: Pma_fence;
    pDoneFence: Pma_fence;
    rangeBegInPCMFrames: ma_uint64;
    rangeEndInPCMFrames: ma_uint64;
    loopPointBegInPCMFrames: ma_uint64;
    loopPointEndInPCMFrames: ma_uint64;
    isLooping: ma_uint32;
  end;

  P_anonymous_type_22 = ^_anonymous_type_22;
  _anonymous_type_22 = record
    pDataBuffer: Pointer;
    pDoneNotification: Pma_async_notification;
    pDoneFence: Pma_fence;
  end;

  P_anonymous_type_23 = ^_anonymous_type_23;
  _anonymous_type_23 = record
    pDataStream: Pointer;
    pFilePath: PUTF8Char;
    pFilePathW: PWideChar;
    initialSeekPoint: ma_uint64;
    pInitNotification: Pma_async_notification;
    pInitFence: Pma_fence;
  end;

  P_anonymous_type_24 = ^_anonymous_type_24;
  _anonymous_type_24 = record
    pDataStream: Pointer;
    pDoneNotification: Pma_async_notification;
    pDoneFence: Pma_fence;
  end;

  P_anonymous_type_25 = ^_anonymous_type_25;
  _anonymous_type_25 = record
    pDataStream: Pointer;
    pageIndex: ma_uint32;
  end;

  P_anonymous_type_26 = ^_anonymous_type_26;
  _anonymous_type_26 = record
    pDataStream: Pointer;
    frameIndex: ma_uint64;
  end;

  P_anonymous_type_27 = ^_anonymous_type_27;
  _anonymous_type_27 = record
    case Integer of
      0: (loadDataBufferNode: _anonymous_type_18);
      1: (freeDataBufferNode: _anonymous_type_19);
      2: (pageDataBufferNode: _anonymous_type_20);
      3: (loadDataBuffer: _anonymous_type_21);
      4: (freeDataBuffer: _anonymous_type_22);
      5: (loadDataStream: _anonymous_type_23);
      6: (freeDataStream: _anonymous_type_24);
      7: (pageDataStream: _anonymous_type_25);
      8: (seekDataStream: _anonymous_type_26);
  end;

  P_anonymous_type_28 = ^_anonymous_type_28;
  _anonymous_type_28 = record
    pDevice: Pointer;
    deviceType: ma_uint32;
  end;

  P_anonymous_type_29 = ^_anonymous_type_29;
  _anonymous_type_29 = record
    case Integer of
      0: (reroute: _anonymous_type_28);
  end;

  P_anonymous_type_30 = ^_anonymous_type_30;
  _anonymous_type_30 = record
    case Integer of
      0: (aaudio: _anonymous_type_29);
  end;

  P_anonymous_type_31 = ^_anonymous_type_31;
  _anonymous_type_31 = record
    case Integer of
      0: (custom: _anonymous_type_17);
      1: (resourceManager: _anonymous_type_27);
      2: (device: _anonymous_type_30);
  end;

  ma_job = record
    toc: _anonymous_type_16;
    next: ma_uint64;
    order: ma_uint32;
    data: _anonymous_type_31;
  end;

  ma_job_queue_config = record
    flags: ma_uint32;
    capacity: ma_uint32;
  end;

  ma_job_queue = record
    flags: ma_uint32;
    capacity: ma_uint32;
    head: ma_uint64;
    tail: ma_uint64;
    sem: ma_semaphore;
    allocator: ma_slot_allocator;
    pJobs: Pma_job;
    lock: ma_spinlock;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_atomic_device_state = record
    value: ma_device_state;
  end;

  ma_IMMNotificationClient = record
    lpVtbl: Pointer;
    counter: ma_uint32;
    pDevice: Pma_device;
  end;

  ma_device_job_thread_config = record
    noThread: ma_bool32;
    jobQueueCapacity: ma_uint32;
    jobQueueFlags: ma_uint32;
  end;

  ma_device_job_thread = record
    thread: ma_thread;
    jobQueue: ma_job_queue;
    _hasThread: ma_bool32;
  end;

  P_anonymous_type_32 = ^_anonymous_type_32;
  _anonymous_type_32 = record
    _unused: Integer;
  end;

  P_anonymous_type_33 = ^_anonymous_type_33;
  _anonymous_type_33 = record
    _unused: Integer;
  end;

  P_anonymous_type_34 = ^_anonymous_type_34;
  _anonymous_type_34 = record
    _unused: Integer;
  end;

  P_anonymous_type_35 = ^_anonymous_type_35;
  _anonymous_type_35 = record
    _unused: Integer;
  end;

  P_anonymous_type_36 = ^_anonymous_type_36;
  _anonymous_type_36 = record
    case Integer of
      0: (started: _anonymous_type_32);
      1: (stopped: _anonymous_type_33);
      2: (rerouted: _anonymous_type_34);
      3: (interruption: _anonymous_type_35);
  end;

  ma_device_notification = record
    pDevice: Pma_device;
    &type: ma_device_notification_type;
    data: _anonymous_type_36;
  end;

  ma_device_notification_proc = procedure(const pNotification: Pma_device_notification); cdecl;

  ma_device_data_proc = procedure(pDevice: Pma_device; pOutput: Pointer; const pInput: Pointer; frameCount: ma_uint32); cdecl;

  ma_stop_proc = procedure(pDevice: Pma_device); cdecl;

  ma_timer = record
    case Integer of
      0: (counter: ma_int64);
      1: (counterD: Double);
  end;

  P_anonymous_type_37 = ^_anonymous_type_37;
  _anonymous_type_37 = record
    case Integer of
      0: (i: Integer);
      1: (s: array [0..255] of UTF8Char);
      2: (p: Pointer);
  end;

  Pma_device_id = ^ma_device_id;
  ma_device_id = record
    case Integer of
      0: (wasapi: array [0..63] of ma_wchar_win32);
      1: (dsound: array [0..15] of ma_uint8);
      2: (winmm: ma_uint32);
      3: (alsa: array [0..255] of UTF8Char);
      4: (pulse: array [0..255] of UTF8Char);
      5: (jack: Integer);
      6: (coreaudio: array [0..255] of UTF8Char);
      7: (sndio: array [0..255] of UTF8Char);
      8: (audio4: array [0..255] of UTF8Char);
      9: (oss: array [0..63] of UTF8Char);
      10: (aaudio: ma_int32);
      11: (opensl: ma_uint32);
      12: (webaudio: array [0..31] of UTF8Char);
      13: (custom: _anonymous_type_37);
      14: (nullbackend: Integer);
  end;

  P_anonymous_type_38 = ^_anonymous_type_38;
  _anonymous_type_38 = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    flags: ma_uint32;
  end;

  ma_device_info = record
    id: ma_device_id;
    name: array [0..255] of UTF8Char;
    isDefault: ma_bool32;
    nativeDataFormatCount: ma_uint32;
    nativeDataFormats: array [0..63] of _anonymous_type_38;
  end;

  P_anonymous_type_39 = ^_anonymous_type_39;
  _anonymous_type_39 = record
    pDeviceID: Pma_device_id;
    format: ma_format;
    channels: ma_uint32;
    pChannelMap: Pma_channel;
    channelMixMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    shareMode: ma_share_mode;
  end;

  P_anonymous_type_40 = ^_anonymous_type_40;
  _anonymous_type_40 = record
    pDeviceID: Pma_device_id;
    format: ma_format;
    channels: ma_uint32;
    pChannelMap: Pma_channel;
    channelMixMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    shareMode: ma_share_mode;
  end;

  P_anonymous_type_41 = ^_anonymous_type_41;
  _anonymous_type_41 = record
    usage: ma_wasapi_usage;
    noAutoConvertSRC: ma_bool8;
    noDefaultQualitySRC: ma_bool8;
    noAutoStreamRouting: ma_bool8;
    noHardwareOffloading: ma_bool8;
    loopbackProcessID: ma_uint32;
    loopbackProcessExclude: ma_bool8;
  end;

  P_anonymous_type_42 = ^_anonymous_type_42;
  _anonymous_type_42 = record
    noMMap: ma_bool32;
    noAutoFormat: ma_bool32;
    noAutoChannels: ma_bool32;
    noAutoResample: ma_bool32;
  end;

  P_anonymous_type_43 = ^_anonymous_type_43;
  _anonymous_type_43 = record
    pStreamNamePlayback: PUTF8Char;
    pStreamNameCapture: PUTF8Char;
    channelMap: Integer;
  end;

  P_anonymous_type_44 = ^_anonymous_type_44;
  _anonymous_type_44 = record
    allowNominalSampleRateChange: ma_bool32;
  end;

  P_anonymous_type_45 = ^_anonymous_type_45;
  _anonymous_type_45 = record
    streamType: ma_opensl_stream_type;
    recordingPreset: ma_opensl_recording_preset;
    enableCompatibilityWorkarounds: ma_bool32;
  end;

  P_anonymous_type_46 = ^_anonymous_type_46;
  _anonymous_type_46 = record
    usage: ma_aaudio_usage;
    contentType: ma_aaudio_content_type;
    inputPreset: ma_aaudio_input_preset;
    allowedCapturePolicy: ma_aaudio_allowed_capture_policy;
    noAutoStartAfterReroute: ma_bool32;
    enableCompatibilityWorkarounds: ma_bool32;
    allowSetBufferCapacity: ma_bool32;
  end;

  ma_device_config = record
    deviceType: ma_device_type;
    sampleRate: ma_uint32;
    periodSizeInFrames: ma_uint32;
    periodSizeInMilliseconds: ma_uint32;
    periods: ma_uint32;
    performanceProfile: ma_performance_profile;
    noPreSilencedOutputBuffer: ma_bool8;
    noClip: ma_bool8;
    noDisableDenormals: ma_bool8;
    noFixedSizedCallback: ma_bool8;
    dataCallback: ma_device_data_proc;
    notificationCallback: ma_device_notification_proc;
    stopCallback: ma_stop_proc;
    pUserData: Pointer;
    resampling: ma_resampler_config;
    playback: _anonymous_type_39;
    capture: _anonymous_type_40;
    wasapi: _anonymous_type_41;
    alsa: _anonymous_type_42;
    pulse: _anonymous_type_43;
    coreaudio: _anonymous_type_44;
    opensl: _anonymous_type_45;
    aaudio: _anonymous_type_46;
  end;

  ma_enum_devices_callback_proc = function(pContext: Pma_context; deviceType: ma_device_type; const pInfo: Pma_device_info; pUserData: Pointer): ma_bool32; cdecl;

  ma_device_descriptor = record
    pDeviceID: Pma_device_id;
    shareMode: ma_share_mode;
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    channelMap: array [0..253] of ma_channel;
    periodSizeInFrames: ma_uint32;
    periodSizeInMilliseconds: ma_uint32;
    periodCount: ma_uint32;
  end;

  ma_backend_callbacks = record
    onContextInit: function(pContext: Pma_context; const pConfig: Pma_context_config; pCallbacks: Pma_backend_callbacks): ma_result; cdecl;
    onContextUninit: function(pContext: Pma_context): ma_result; cdecl;
    onContextEnumerateDevices: function(pContext: Pma_context; callback: ma_enum_devices_callback_proc; pUserData: Pointer): ma_result; cdecl;
    onContextGetDeviceInfo: function(pContext: Pma_context; deviceType: ma_device_type; const pDeviceID: Pma_device_id; pDeviceInfo: Pma_device_info): ma_result; cdecl;
    onDeviceInit: function(pDevice: Pma_device; const pConfig: Pma_device_config; pDescriptorPlayback: Pma_device_descriptor; pDescriptorCapture: Pma_device_descriptor): ma_result; cdecl;
    onDeviceUninit: function(pDevice: Pma_device): ma_result; cdecl;
    onDeviceStart: function(pDevice: Pma_device): ma_result; cdecl;
    onDeviceStop: function(pDevice: Pma_device): ma_result; cdecl;
    onDeviceRead: function(pDevice: Pma_device; pFrames: Pointer; frameCount: ma_uint32; pFramesRead: Pma_uint32): ma_result; cdecl;
    onDeviceWrite: function(pDevice: Pma_device; const pFrames: Pointer; frameCount: ma_uint32; pFramesWritten: Pma_uint32): ma_result; cdecl;
    onDeviceDataLoop: function(pDevice: Pma_device): ma_result; cdecl;
    onDeviceDataLoopWakeup: function(pDevice: Pma_device): ma_result; cdecl;
    onDeviceGetInfo: function(pDevice: Pma_device; &type: ma_device_type; pDeviceInfo: Pma_device_info): ma_result; cdecl;
  end;

  P_anonymous_type_47 = ^_anonymous_type_47;
  _anonymous_type_47 = record
    hWnd: ma_handle;
  end;

  P_anonymous_type_48 = ^_anonymous_type_48;
  _anonymous_type_48 = record
    useVerboseDeviceEnumeration: ma_bool32;
  end;

  P_anonymous_type_49 = ^_anonymous_type_49;
  _anonymous_type_49 = record
    pApplicationName: PUTF8Char;
    pServerName: PUTF8Char;
    tryAutoSpawn: ma_bool32;
  end;

  P_anonymous_type_50 = ^_anonymous_type_50;
  _anonymous_type_50 = record
    sessionCategory: ma_ios_session_category;
    sessionCategoryOptions: ma_uint32;
    noAudioSessionActivate: ma_bool32;
    noAudioSessionDeactivate: ma_bool32;
  end;

  P_anonymous_type_51 = ^_anonymous_type_51;
  _anonymous_type_51 = record
    pClientName: PUTF8Char;
    tryStartServer: ma_bool32;
  end;

  ma_context_config = record
    pLog: Pma_log;
    threadPriority: ma_thread_priority;
    threadStackSize: NativeUInt;
    pUserData: Pointer;
    allocationCallbacks: ma_allocation_callbacks;
    dsound: _anonymous_type_47;
    alsa: _anonymous_type_48;
    pulse: _anonymous_type_49;
    coreaudio: _anonymous_type_50;
    jack: _anonymous_type_51;
    custom: ma_backend_callbacks;
  end;

  P_anonymous_type_52 = ^_anonymous_type_52;
  _anonymous_type_52 = record
    _unused: Integer;
  end;

  P_anonymous_type_53 = ^_anonymous_type_53;
  _anonymous_type_53 = record
    deviceType: ma_device_type;
    pAudioClient: Pointer;
    ppAudioClientService: PPointer;
    pResult: Pma_result;
  end;

  P_anonymous_type_54 = ^_anonymous_type_54;
  _anonymous_type_54 = record
    pDevice: Pma_device;
    deviceType: ma_device_type;
  end;

  P_anonymous_type_55 = ^_anonymous_type_55;
  _anonymous_type_55 = record
    case Integer of
      0: (quit: _anonymous_type_52);
      1: (createAudioClient: _anonymous_type_53);
      2: (releaseAudioClient: _anonymous_type_54);
  end;

  ma_context_command__wasapi = record
    code: Integer;
    pEvent: Pma_event;
    data: _anonymous_type_55;
  end;

  P_anonymous_type_56 = ^_anonymous_type_56;
  _anonymous_type_56 = record
    commandThread: ma_thread;
    commandLock: ma_mutex;
    commandSem: ma_semaphore;
    commandIndex: ma_uint32;
    commandCount: ma_uint32;
    commands: array [0..3] of ma_context_command__wasapi;
    hAvrt: ma_handle;
    AvSetMmThreadCharacteristicsA: ma_proc;
    AvRevertMmThreadcharacteristics: ma_proc;
    hMMDevapi: ma_handle;
    ActivateAudioInterfaceAsync: ma_proc;
  end;

  P_anonymous_type_57 = ^_anonymous_type_57;
  _anonymous_type_57 = record
    hWnd: ma_handle;
    hDSoundDLL: ma_handle;
    DirectSoundCreate: ma_proc;
    DirectSoundEnumerateA: ma_proc;
    DirectSoundCaptureCreate: ma_proc;
    DirectSoundCaptureEnumerateA: ma_proc;
  end;

  P_anonymous_type_58 = ^_anonymous_type_58;
  _anonymous_type_58 = record
    hWinMM: ma_handle;
    waveOutGetNumDevs: ma_proc;
    waveOutGetDevCapsA: ma_proc;
    waveOutOpen: ma_proc;
    waveOutClose: ma_proc;
    waveOutPrepareHeader: ma_proc;
    waveOutUnprepareHeader: ma_proc;
    waveOutWrite: ma_proc;
    waveOutReset: ma_proc;
    waveInGetNumDevs: ma_proc;
    waveInGetDevCapsA: ma_proc;
    waveInOpen: ma_proc;
    waveInClose: ma_proc;
    waveInPrepareHeader: ma_proc;
    waveInUnprepareHeader: ma_proc;
    waveInAddBuffer: ma_proc;
    waveInStart: ma_proc;
    waveInReset: ma_proc;
  end;

  P_anonymous_type_59 = ^_anonymous_type_59;
  _anonymous_type_59 = record
    jackSO: ma_handle;
    jack_client_open: ma_proc;
    jack_client_close: ma_proc;
    jack_client_name_size: ma_proc;
    jack_set_process_callback: ma_proc;
    jack_set_buffer_size_callback: ma_proc;
    jack_on_shutdown: ma_proc;
    jack_get_sample_rate: ma_proc;
    jack_get_buffer_size: ma_proc;
    jack_get_ports: ma_proc;
    jack_activate: ma_proc;
    jack_deactivate: ma_proc;
    jack_connect: ma_proc;
    jack_port_register: ma_proc;
    jack_port_name: ma_proc;
    jack_port_get_buffer: ma_proc;
    jack_free: ma_proc;
    pClientName: PUTF8Char;
    tryStartServer: ma_bool32;
  end;

  P_anonymous_type_60 = ^_anonymous_type_60;
  _anonymous_type_60 = record
    _unused: Integer;
  end;

  P_anonymous_type_61 = ^_anonymous_type_61;
  _anonymous_type_61 = record
    case Integer of
      0: (wasapi: _anonymous_type_56);
      1: (dsound: _anonymous_type_57);
      2: (winmm: _anonymous_type_58);
      3: (jack: _anonymous_type_59);
      4: (null_backend: _anonymous_type_60);
  end;

  P_anonymous_type_62 = ^_anonymous_type_62;
  _anonymous_type_62 = record
    hOle32DLL: ma_handle;
    CoInitialize: ma_proc;
    CoInitializeEx: ma_proc;
    CoUninitialize: ma_proc;
    CoCreateInstance: ma_proc;
    CoTaskMemFree: ma_proc;
    PropVariantClear: ma_proc;
    StringFromGUID2: ma_proc;
    hUser32DLL: ma_handle;
    GetForegroundWindow: ma_proc;
    GetDesktopWindow: ma_proc;
    hAdvapi32DLL: ma_handle;
    RegOpenKeyExA: ma_proc;
    RegCloseKey: ma_proc;
    RegQueryValueExA: ma_proc;
    CoInitializeResult: Longint;
  end;

  P_anonymous_type_63 = ^_anonymous_type_63;
  _anonymous_type_63 = record
    case Integer of
      0: (win32: _anonymous_type_62);
      1: (_unused: Integer);
  end;

  ma_context = record
    callbacks: ma_backend_callbacks;
    backend: ma_backend;
    pLog: Pma_log;
    log: ma_log;
    threadPriority: ma_thread_priority;
    threadStackSize: NativeUInt;
    pUserData: Pointer;
    allocationCallbacks: ma_allocation_callbacks;
    deviceEnumLock: ma_mutex;
    deviceInfoLock: ma_mutex;
    deviceInfoCapacity: ma_uint32;
    playbackDeviceInfoCount: ma_uint32;
    captureDeviceInfoCount: ma_uint32;
    pDeviceInfos: Pma_device_info;
    f15: _anonymous_type_61;
    f16: _anonymous_type_63;
  end;

  P_anonymous_type_64 = ^_anonymous_type_64;
  _anonymous_type_64 = record
    lpfOrder: ma_uint32;
  end;

  P_anonymous_type_65 = ^_anonymous_type_65;
  _anonymous_type_65 = record
    algorithm: ma_resample_algorithm;
    pBackendVTable: Pma_resampling_backend_vtable;
    pBackendUserData: Pointer;
    linear: _anonymous_type_64;
  end;

  P_anonymous_type_66 = ^_anonymous_type_66;
  _anonymous_type_66 = record
    pID: Pma_device_id;
    id: ma_device_id;
    name: array [0..255] of UTF8Char;
    shareMode: ma_share_mode;
    format: ma_format;
    channels: ma_uint32;
    channelMap: array [0..253] of ma_channel;
    internalFormat: ma_format;
    internalChannels: ma_uint32;
    internalSampleRate: ma_uint32;
    internalChannelMap: array [0..253] of ma_channel;
    internalPeriodSizeInFrames: ma_uint32;
    internalPeriods: ma_uint32;
    channelMixMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    converter: ma_data_converter;
    pIntermediaryBuffer: Pointer;
    intermediaryBufferCap: ma_uint32;
    intermediaryBufferLen: ma_uint32;
    pInputCache: Pointer;
    inputCacheCap: ma_uint64;
    inputCacheConsumed: ma_uint64;
    inputCacheRemaining: ma_uint64;
  end;

  P_anonymous_type_67 = ^_anonymous_type_67;
  _anonymous_type_67 = record
    pID: Pma_device_id;
    id: ma_device_id;
    name: array [0..255] of UTF8Char;
    shareMode: ma_share_mode;
    format: ma_format;
    channels: ma_uint32;
    channelMap: array [0..253] of ma_channel;
    internalFormat: ma_format;
    internalChannels: ma_uint32;
    internalSampleRate: ma_uint32;
    internalChannelMap: array [0..253] of ma_channel;
    internalPeriodSizeInFrames: ma_uint32;
    internalPeriods: ma_uint32;
    channelMixMode: ma_channel_mix_mode;
    calculateLFEFromSpatialChannels: ma_bool32;
    converter: ma_data_converter;
    pIntermediaryBuffer: Pointer;
    intermediaryBufferCap: ma_uint32;
    intermediaryBufferLen: ma_uint32;
  end;

  P_anonymous_type_68 = ^_anonymous_type_68;
  _anonymous_type_68 = record
    pAudioClientPlayback: ma_ptr;
    pAudioClientCapture: ma_ptr;
    pRenderClient: ma_ptr;
    pCaptureClient: ma_ptr;
    pDeviceEnumerator: ma_ptr;
    notificationClient: ma_IMMNotificationClient;
    hEventPlayback: ma_handle;
    hEventCapture: ma_handle;
    actualBufferSizeInFramesPlayback: ma_uint32;
    actualBufferSizeInFramesCapture: ma_uint32;
    originalPeriodSizeInFrames: ma_uint32;
    originalPeriodSizeInMilliseconds: ma_uint32;
    originalPeriods: ma_uint32;
    originalPerformanceProfile: ma_performance_profile;
    periodSizeInFramesPlayback: ma_uint32;
    periodSizeInFramesCapture: ma_uint32;
    pMappedBufferCapture: Pointer;
    mappedBufferCaptureCap: ma_uint32;
    mappedBufferCaptureLen: ma_uint32;
    pMappedBufferPlayback: Pointer;
    mappedBufferPlaybackCap: ma_uint32;
    mappedBufferPlaybackLen: ma_uint32;
    isStartedCapture: ma_atomic_bool32;
    isStartedPlayback: ma_atomic_bool32;
    loopbackProcessID: ma_uint32;
    loopbackProcessExclude: ma_bool8;
    noAutoConvertSRC: ma_bool8;
    noDefaultQualitySRC: ma_bool8;
    noHardwareOffloading: ma_bool8;
    allowCaptureAutoStreamRouting: ma_bool8;
    allowPlaybackAutoStreamRouting: ma_bool8;
    isDetachedPlayback: ma_bool8;
    isDetachedCapture: ma_bool8;
    usage: ma_wasapi_usage;
    hAvrtHandle: Pointer;
    rerouteLock: ma_mutex;
  end;

  P_anonymous_type_69 = ^_anonymous_type_69;
  _anonymous_type_69 = record
    pPlayback: ma_ptr;
    pPlaybackPrimaryBuffer: ma_ptr;
    pPlaybackBuffer: ma_ptr;
    pCapture: ma_ptr;
    pCaptureBuffer: ma_ptr;
  end;

  P_anonymous_type_70 = ^_anonymous_type_70;
  _anonymous_type_70 = record
    hDevicePlayback: ma_handle;
    hDeviceCapture: ma_handle;
    hEventPlayback: ma_handle;
    hEventCapture: ma_handle;
    fragmentSizeInFrames: ma_uint32;
    iNextHeaderPlayback: ma_uint32;
    iNextHeaderCapture: ma_uint32;
    headerFramesConsumedPlayback: ma_uint32;
    headerFramesConsumedCapture: ma_uint32;
    pWAVEHDRPlayback: Pma_uint8;
    pWAVEHDRCapture: Pma_uint8;
    pIntermediaryBufferPlayback: Pma_uint8;
    pIntermediaryBufferCapture: Pma_uint8;
    _pHeapData: Pma_uint8;
  end;

  P_anonymous_type_71 = ^_anonymous_type_71;
  _anonymous_type_71 = record
    pClient: ma_ptr;
    ppPortsPlayback: Pma_ptr;
    ppPortsCapture: Pma_ptr;
    pIntermediaryBufferPlayback: PSingle;
    pIntermediaryBufferCapture: PSingle;
  end;

  P_anonymous_type_72 = ^_anonymous_type_72;
  _anonymous_type_72 = record
    deviceThread: ma_thread;
    operationEvent: ma_event;
    operationCompletionEvent: ma_event;
    operationSemaphore: ma_semaphore;
    operation: ma_uint32;
    operationResult: ma_result;
    timer: ma_timer;
    priorRunTime: Double;
    currentPeriodFramesRemainingPlayback: ma_uint32;
    currentPeriodFramesRemainingCapture: ma_uint32;
    lastProcessedFramePlayback: ma_uint64;
    lastProcessedFrameCapture: ma_uint64;
    isStarted: ma_atomic_bool32;
  end;

  P_anonymous_type_73 = ^_anonymous_type_73;
  _anonymous_type_73 = record
    case Integer of
      0: (wasapi: _anonymous_type_68);
      1: (dsound: _anonymous_type_69);
      2: (winmm: _anonymous_type_70);
      3: (jack: _anonymous_type_71);
      4: (null_device: _anonymous_type_72);
  end;

  ma_device = record
    pContext: Pma_context;
    &type: ma_device_type;
    sampleRate: ma_uint32;
    state: ma_atomic_device_state;
    onData: ma_device_data_proc;
    onNotification: ma_device_notification_proc;
    onStop: ma_stop_proc;
    pUserData: Pointer;
    startStopLock: ma_mutex;
    wakeupEvent: ma_event;
    startEvent: ma_event;
    stopEvent: ma_event;
    thread: ma_thread;
    workResult: ma_result;
    isOwnerOfContext: ma_bool8;
    noPreSilencedOutputBuffer: ma_bool8;
    noClip: ma_bool8;
    noDisableDenormals: ma_bool8;
    noFixedSizedCallback: ma_bool8;
    masterVolumeFactor: ma_atomic_float;
    duplexRB: ma_duplex_rb;
    resampling: _anonymous_type_65;
    playback: _anonymous_type_66;
    capture: _anonymous_type_67;
    f25: _anonymous_type_73;
  end;

  Pma_vfs = Pointer;
  PPma_vfs = ^Pma_vfs;
  ma_vfs_file = ma_handle;
  Pma_vfs_file = ^ma_vfs_file;

  ma_file_info = record
    sizeInBytes: ma_uint64;
  end;

  ma_vfs_callbacks = record
    onOpen: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; openMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
    onOpenW: function(pVFS: Pma_vfs; const pFilePath: PWideChar; openMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
    onClose: function(pVFS: Pma_vfs; &file: ma_vfs_file): ma_result; cdecl;
    onRead: function(pVFS: Pma_vfs; &file: ma_vfs_file; pDst: Pointer; sizeInBytes: NativeUInt; pBytesRead: PNativeUInt): ma_result; cdecl;
    onWrite: function(pVFS: Pma_vfs; &file: ma_vfs_file; const pSrc: Pointer; sizeInBytes: NativeUInt; pBytesWritten: PNativeUInt): ma_result; cdecl;
    onSeek: function(pVFS: Pma_vfs; &file: ma_vfs_file; offset: ma_int64; origin: ma_seek_origin): ma_result; cdecl;
    onTell: function(pVFS: Pma_vfs; &file: ma_vfs_file; pCursor: Pma_int64): ma_result; cdecl;
    onInfo: function(pVFS: Pma_vfs; &file: ma_vfs_file; pInfo: Pma_file_info): ma_result; cdecl;
  end;

  ma_default_vfs = record
    cb: ma_vfs_callbacks;
    allocationCallbacks: ma_allocation_callbacks;
  end;

  ma_read_proc = function(pUserData: Pointer; pBufferOut: Pointer; bytesToRead: NativeUInt; pBytesRead: PNativeUInt): ma_result; cdecl;

  ma_seek_proc = function(pUserData: Pointer; offset: ma_int64; origin: ma_seek_origin): ma_result; cdecl;

  ma_tell_proc = function(pUserData: Pointer; pCursor: Pma_int64): ma_result; cdecl;

  ma_decoding_backend_config = record
    preferredFormat: ma_format;
    seekPointCount: ma_uint32;
  end;

  ma_decoding_backend_vtable = record
    onInit: function(pUserData: Pointer; onRead: ma_read_proc; onSeek: ma_seek_proc; onTell: ma_tell_proc; pReadSeekTellUserData: Pointer; const pConfig: Pma_decoding_backend_config; const pAllocationCallbacks: Pma_allocation_callbacks; ppBackend: PPma_data_source): ma_result; cdecl;
    onInitFile: function(pUserData: Pointer; const pFilePath: PUTF8Char; const pConfig: Pma_decoding_backend_config; const pAllocationCallbacks: Pma_allocation_callbacks; ppBackend: PPma_data_source): ma_result; cdecl;
    onInitFileW: function(pUserData: Pointer; const pFilePath: PWideChar; const pConfig: Pma_decoding_backend_config; const pAllocationCallbacks: Pma_allocation_callbacks; ppBackend: PPma_data_source): ma_result; cdecl;
    onInitMemory: function(pUserData: Pointer; const pData: Pointer; dataSize: NativeUInt; const pConfig: Pma_decoding_backend_config; const pAllocationCallbacks: Pma_allocation_callbacks; ppBackend: PPma_data_source): ma_result; cdecl;
    onUninit: procedure(pUserData: Pointer; pBackend: Pma_data_source; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  end;

  ma_decoder_read_proc = function(pDecoder: Pma_decoder; pBufferOut: Pointer; bytesToRead: NativeUInt; pBytesRead: PNativeUInt): ma_result; cdecl;

  ma_decoder_seek_proc = function(pDecoder: Pma_decoder; byteOffset: ma_int64; origin: ma_seek_origin): ma_result; cdecl;

  ma_decoder_tell_proc = function(pDecoder: Pma_decoder; pCursor: Pma_int64): ma_result; cdecl;

  ma_decoder_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    pChannelMap: Pma_channel;
    channelMixMode: ma_channel_mix_mode;
    ditherMode: ma_dither_mode;
    resampling: ma_resampler_config;
    allocationCallbacks: ma_allocation_callbacks;
    encodingFormat: ma_encoding_format;
    seekPointCount: ma_uint32;
    ppCustomBackendVTables: PPma_decoding_backend_vtable;
    customBackendCount: ma_uint32;
    pCustomBackendUserData: Pointer;
  end;

  P_anonymous_type_74 = ^_anonymous_type_74;
  _anonymous_type_74 = record
    pVFS: Pma_vfs;
    &file: ma_vfs_file;
  end;

  P_anonymous_type_75 = ^_anonymous_type_75;
  _anonymous_type_75 = record
    pData: Pma_uint8;
    dataSize: NativeUInt;
    currentReadPos: NativeUInt;
  end;

  P_anonymous_type_76 = ^_anonymous_type_76;
  _anonymous_type_76 = record
    case Integer of
      0: (vfs: _anonymous_type_74);
      1: (memory: _anonymous_type_75);
  end;

  ma_decoder = record
    ds: ma_data_source_base;
    pBackend: Pma_data_source;
    pBackendVTable: Pma_decoding_backend_vtable;
    pBackendUserData: Pointer;
    onRead: ma_decoder_read_proc;
    onSeek: ma_decoder_seek_proc;
    onTell: ma_decoder_tell_proc;
    pUserData: Pointer;
    readPointerInPCMFrames: ma_uint64;
    outputFormat: ma_format;
    outputChannels: ma_uint32;
    outputSampleRate: ma_uint32;
    converter: ma_data_converter;
    pInputCache: Pointer;
    inputCacheCap: ma_uint64;
    inputCacheConsumed: ma_uint64;
    inputCacheRemaining: ma_uint64;
    allocationCallbacks: ma_allocation_callbacks;
    data: _anonymous_type_76;
  end;

  ma_encoder_write_proc = function(pEncoder: Pma_encoder; const pBufferIn: Pointer; bytesToWrite: NativeUInt; pBytesWritten: PNativeUInt): ma_result; cdecl;

  ma_encoder_seek_proc = function(pEncoder: Pma_encoder; offset: ma_int64; origin: ma_seek_origin): ma_result; cdecl;

  ma_encoder_init_proc = function(pEncoder: Pma_encoder): ma_result; cdecl;

  ma_encoder_uninit_proc = procedure(pEncoder: Pma_encoder); cdecl;

  ma_encoder_write_pcm_frames_proc = function(pEncoder: Pma_encoder; const pFramesIn: Pointer; frameCount: ma_uint64; pFramesWritten: Pma_uint64): ma_result; cdecl;

  ma_encoder_config = record
    encodingFormat: ma_encoding_format;
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    allocationCallbacks: ma_allocation_callbacks;
  end;

  P_anonymous_type_77 = ^_anonymous_type_77;
  _anonymous_type_77 = record
    pVFS: Pma_vfs;
    &file: ma_vfs_file;
  end;

  P_anonymous_type_78 = ^_anonymous_type_78;
  _anonymous_type_78 = record
    case Integer of
      0: (vfs: _anonymous_type_77);
  end;

  ma_encoder = record
    config: ma_encoder_config;
    onWrite: ma_encoder_write_proc;
    onSeek: ma_encoder_seek_proc;
    onInit: ma_encoder_init_proc;
    onUninit: ma_encoder_uninit_proc;
    onWritePCMFrames: ma_encoder_write_pcm_frames_proc;
    pUserData: Pointer;
    pInternalEncoder: Pointer;
    data: _anonymous_type_78;
  end;

  ma_waveform_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    &type: ma_waveform_type;
    amplitude: Double;
    frequency: Double;
  end;

  ma_waveform = record
    ds: ma_data_source_base;
    config: ma_waveform_config;
    advance: Double;
    time: Double;
  end;

  ma_pulsewave_config = record
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    dutyCycle: Double;
    amplitude: Double;
    frequency: Double;
  end;

  ma_pulsewave = record
    waveform: ma_waveform;
    config: ma_pulsewave_config;
  end;

  ma_noise_config = record
    format: ma_format;
    channels: ma_uint32;
    &type: ma_noise_type;
    seed: ma_int32;
    amplitude: Double;
    duplicateChannels: ma_bool32;
  end;

  P_anonymous_type_79 = ^_anonymous_type_79;
  _anonymous_type_79 = record
    bin: PPDouble;
    accumulation: PDouble;
    counter: Pma_uint32;
  end;

  P_anonymous_type_80 = ^_anonymous_type_80;
  _anonymous_type_80 = record
    accumulation: PDouble;
  end;

  P_anonymous_type_81 = ^_anonymous_type_81;
  _anonymous_type_81 = record
    case Integer of
      0: (pink: _anonymous_type_79);
      1: (brownian: _anonymous_type_80);
  end;

  ma_noise = record
    ds: ma_data_source_base;
    config: ma_noise_config;
    lcg: ma_lcg;
    state: _anonymous_type_81;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_resource_manager_pipeline_stage_notification = record
    pNotification: Pma_async_notification;
    pFence: Pma_fence;
  end;

  ma_resource_manager_pipeline_notifications = record
    init: ma_resource_manager_pipeline_stage_notification;
    done: ma_resource_manager_pipeline_stage_notification;
  end;

  ma_resource_manager_data_source_config = record
    pFilePath: PUTF8Char;
    pFilePathW: PWideChar;
    pNotifications: Pma_resource_manager_pipeline_notifications;
    initialSeekPointInPCMFrames: ma_uint64;
    rangeBegInPCMFrames: ma_uint64;
    rangeEndInPCMFrames: ma_uint64;
    loopPointBegInPCMFrames: ma_uint64;
    loopPointEndInPCMFrames: ma_uint64;
    flags: ma_uint32;
    isLooping: ma_bool32;
  end;

  P_anonymous_type_82 = ^_anonymous_type_82;
  _anonymous_type_82 = record
    pData: Pointer;
    sizeInBytes: NativeUInt;
  end;

  P_anonymous_type_83 = ^_anonymous_type_83;
  _anonymous_type_83 = record
    pData: Pointer;
    totalFrameCount: ma_uint64;
    decodedFrameCount: ma_uint64;
    format: ma_format;
    channels: ma_uint32;
    sampleRate: ma_uint32;
  end;

  P_anonymous_type_84 = ^_anonymous_type_84;
  _anonymous_type_84 = record
    data: ma_paged_audio_buffer_data;
    decodedFrameCount: ma_uint64;
    sampleRate: ma_uint32;
  end;

  P_anonymous_type_85 = ^_anonymous_type_85;
  _anonymous_type_85 = record
    case Integer of
      0: (encoded: _anonymous_type_82);
      1: (decoded: _anonymous_type_83);
      2: (decodedPaged: _anonymous_type_84);
  end;

  ma_resource_manager_data_supply = record
    &type: ma_resource_manager_data_supply_type;
    backend: _anonymous_type_85;
  end;

  ma_resource_manager_data_buffer_node = record
    hashedName32: ma_uint32;
    refCount: ma_uint32;
    result: ma_result;
    executionCounter: ma_uint32;
    executionPointer: ma_uint32;
    isDataOwnedByResourceManager: ma_bool32;
    data: ma_resource_manager_data_supply;
    pParent: Pma_resource_manager_data_buffer_node;
    pChildLo: Pma_resource_manager_data_buffer_node;
    pChildHi: Pma_resource_manager_data_buffer_node;
  end;

  P_anonymous_type_86 = ^_anonymous_type_86;
  _anonymous_type_86 = record
    case Integer of
      0: (decoder: ma_decoder);
      1: (buffer: ma_audio_buffer);
      2: (pagedBuffer: ma_paged_audio_buffer);
  end;

  ma_resource_manager_data_buffer = record
    ds: ma_data_source_base;
    pResourceManager: Pma_resource_manager;
    pNode: Pma_resource_manager_data_buffer_node;
    flags: ma_uint32;
    executionCounter: ma_uint32;
    executionPointer: ma_uint32;
    seekTargetInPCMFrames: ma_uint64;
    seekToCursorOnNextRead: ma_bool32;
    result: ma_result;
    isLooping: ma_bool32;
    isConnectorInitialized: ma_atomic_bool32;
    connector: _anonymous_type_86;
  end;

  ma_resource_manager_data_stream = record
    ds: ma_data_source_base;
    pResourceManager: Pma_resource_manager;
    flags: ma_uint32;
    decoder: ma_decoder;
    isDecoderInitialized: ma_bool32;
    totalLengthInPCMFrames: ma_uint64;
    relativeCursor: ma_uint32;
    absoluteCursor: ma_uint64;
    currentPageIndex: ma_uint32;
    executionCounter: ma_uint32;
    executionPointer: ma_uint32;
    isLooping: ma_bool32;
    pPageData: Pointer;
    pageFrameCount: array [0..1] of ma_uint32;
    result: ma_result;
    isDecoderAtEnd: ma_bool32;
    isPageValid: array [0..1] of ma_bool32;
    seekCounter: ma_bool32;
  end;

  P_anonymous_type_87 = ^_anonymous_type_87;
  _anonymous_type_87 = record
    case Integer of
      0: (buffer: ma_resource_manager_data_buffer);
      1: (stream: ma_resource_manager_data_stream);
  end;

  ma_resource_manager_data_source = record
    backend: _anonymous_type_87;
    flags: ma_uint32;
    executionCounter: ma_uint32;
    executionPointer: ma_uint32;
  end;

  ma_resource_manager_config = record
    allocationCallbacks: ma_allocation_callbacks;
    pLog: Pma_log;
    decodedFormat: ma_format;
    decodedChannels: ma_uint32;
    decodedSampleRate: ma_uint32;
    jobThreadCount: ma_uint32;
    jobThreadStackSize: NativeUInt;
    jobQueueCapacity: ma_uint32;
    flags: ma_uint32;
    pVFS: Pma_vfs;
    ppCustomDecodingBackendVTables: PPma_decoding_backend_vtable;
    customDecodingBackendCount: ma_uint32;
    pCustomDecodingBackendUserData: Pointer;
  end;

  ma_resource_manager = record
    config: ma_resource_manager_config;
    pRootDataBufferNode: Pma_resource_manager_data_buffer_node;
    dataBufferBSTLock: ma_mutex;
    jobThreads: array [0..63] of ma_thread;
    jobQueue: ma_job_queue;
    defaultVFS: ma_default_vfs;
    log: ma_log;
  end;

  ma_stack = record
    offset: NativeUInt;
    sizeInBytes: NativeUInt;
    _data: array [0..0] of Byte;
  end;

  Pma_node = Pointer;
  PPma_node = ^Pma_node;

  ma_node_vtable = record
    onProcess: procedure(pNode: Pma_node; ppFramesIn: PPSingle; pFrameCountIn: Pma_uint32; ppFramesOut: PPSingle; pFrameCountOut: Pma_uint32); cdecl;
    onGetRequiredInputFrameCount: function(pNode: Pma_node; outputFrameCount: ma_uint32; pInputFrameCount: Pma_uint32): ma_result; cdecl;
    inputBusCount: ma_uint8;
    outputBusCount: ma_uint8;
    flags: ma_uint32;
  end;

  ma_node_config = record
    vtable: Pma_node_vtable;
    initialState: ma_node_state;
    inputBusCount: ma_uint32;
    outputBusCount: ma_uint32;
    pInputChannels: Pma_uint32;
    pOutputChannels: Pma_uint32;
  end;

  ma_node_output_bus = record
    pNode: Pma_node;
    outputBusIndex: ma_uint8;
    channels: ma_uint8;
    inputNodeInputBusIndex: ma_uint8;
    flags: ma_uint32;
    refCount: ma_uint32;
    isAttached: ma_bool32;
    lock: ma_spinlock;
    volume: Single;
    pNext: Pma_node_output_bus;
    pPrev: Pma_node_output_bus;
    pInputNode: Pma_node;
  end;

  ma_node_input_bus = record
    head: ma_node_output_bus;
    nextCounter: ma_uint32;
    lock: ma_spinlock;
    channels: ma_uint8;
  end;

  ma_node_base = record
    pNodeGraph: Pma_node_graph;
    vtable: Pma_node_vtable;
    inputBusCount: ma_uint32;
    outputBusCount: ma_uint32;
    pInputBuses: Pma_node_input_bus;
    pOutputBuses: Pma_node_output_bus;
    pCachedData: PSingle;
    cachedDataCapInFramesPerBus: ma_uint16;
    cachedFrameCountOut: ma_uint16;
    cachedFrameCountIn: ma_uint16;
    consumedFrameCountIn: ma_uint16;
    state: ma_node_state;
    stateTimes: array [0..1] of ma_uint64;
    localTime: ma_uint64;
    _inputBuses: array [0..1] of ma_node_input_bus;
    _outputBuses: array [0..1] of ma_node_output_bus;
    _pHeap: Pointer;
    _ownsHeap: ma_bool32;
  end;

  ma_node_graph_config = record
    channels: ma_uint32;
    processingSizeInFrames: ma_uint32;
    preMixStackSizeInBytes: NativeUInt;
  end;

  ma_node_graph = record
    base: ma_node_base;
    endpoint: ma_node_base;
    pProcessingCache: PSingle;
    processingCacheFramesRemaining: ma_uint32;
    processingSizeInFrames: ma_uint32;
    isReading: ma_bool32;
    pPreMixStack: Pma_stack;
  end;

  ma_data_source_node_config = record
    nodeConfig: ma_node_config;
    pDataSource: Pma_data_source;
  end;

  ma_data_source_node = record
    base: ma_node_base;
    pDataSource: Pma_data_source;
  end;

  ma_splitter_node_config = record
    nodeConfig: ma_node_config;
    channels: ma_uint32;
    outputBusCount: ma_uint32;
  end;

  ma_splitter_node = record
    base: ma_node_base;
  end;

  ma_biquad_node_config = record
    nodeConfig: ma_node_config;
    biquad: ma_biquad_config;
  end;

  ma_biquad_node = record
    baseNode: ma_node_base;
    biquad: ma_biquad;
  end;

  ma_lpf_node_config = record
    nodeConfig: ma_node_config;
    lpf: ma_lpf_config;
  end;

  ma_lpf_node = record
    baseNode: ma_node_base;
    lpf: ma_lpf;
  end;

  ma_hpf_node_config = record
    nodeConfig: ma_node_config;
    hpf: ma_hpf_config;
  end;

  ma_hpf_node = record
    baseNode: ma_node_base;
    hpf: ma_hpf;
  end;

  ma_bpf_node_config = record
    nodeConfig: ma_node_config;
    bpf: ma_bpf_config;
  end;

  ma_bpf_node = record
    baseNode: ma_node_base;
    bpf: ma_bpf;
  end;

  ma_notch_node_config = record
    nodeConfig: ma_node_config;
    notch: ma_notch_config;
  end;

  ma_notch_node = record
    baseNode: ma_node_base;
    notch: ma_notch2;
  end;

  ma_peak_node_config = record
    nodeConfig: ma_node_config;
    peak: ma_peak_config;
  end;

  ma_peak_node = record
    baseNode: ma_node_base;
    peak: ma_peak2;
  end;

  ma_loshelf_node_config = record
    nodeConfig: ma_node_config;
    loshelf: ma_loshelf_config;
  end;

  ma_loshelf_node = record
    baseNode: ma_node_base;
    loshelf: ma_loshelf2;
  end;

  ma_hishelf_node_config = record
    nodeConfig: ma_node_config;
    hishelf: ma_hishelf_config;
  end;

  ma_hishelf_node = record
    baseNode: ma_node_base;
    hishelf: ma_hishelf2;
  end;

  ma_delay_node_config = record
    nodeConfig: ma_node_config;
    delay: ma_delay_config;
  end;

  ma_delay_node = record
    baseNode: ma_node_base;
    delay: ma_delay;
  end;

  ma_engine_node_config = record
    pEngine: Pma_engine;
    &type: ma_engine_node_type;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    sampleRate: ma_uint32;
    volumeSmoothTimeInPCMFrames: ma_uint32;
    monoExpansionMode: ma_mono_expansion_mode;
    isPitchDisabled: ma_bool8;
    isSpatializationDisabled: ma_bool8;
    pinnedListenerIndex: ma_uint8;
  end;

  P_anonymous_type_88 = ^_anonymous_type_88;
  _anonymous_type_88 = record
    volumeBeg: ma_atomic_float;
    volumeEnd: ma_atomic_float;
    fadeLengthInFrames: ma_atomic_uint64;
    absoluteGlobalTimeInFrames: ma_atomic_uint64;
  end;

  ma_engine_node = record
    baseNode: ma_node_base;
    pEngine: Pma_engine;
    sampleRate: ma_uint32;
    volumeSmoothTimeInPCMFrames: ma_uint32;
    monoExpansionMode: ma_mono_expansion_mode;
    fader: ma_fader;
    resampler: ma_linear_resampler;
    spatializer: ma_spatializer;
    panner: ma_panner;
    volumeGainer: ma_gainer;
    volume: ma_atomic_float;
    pitch: Single;
    oldPitch: Single;
    oldDopplerPitch: Single;
    isPitchDisabled: ma_bool32;
    isSpatializationDisabled: ma_bool32;
    pinnedListenerIndex: ma_uint32;
    fadeSettings: _anonymous_type_88;
    _ownsHeap: ma_bool8;
    _pHeap: Pointer;
  end;

  ma_sound_end_proc = procedure(pUserData: Pointer; pSound: Pma_sound); cdecl;

  ma_sound_config = record
    pFilePath: PUTF8Char;
    pFilePathW: PWideChar;
    pDataSource: Pma_data_source;
    pInitialAttachment: Pma_node;
    initialAttachmentInputBusIndex: ma_uint32;
    channelsIn: ma_uint32;
    channelsOut: ma_uint32;
    monoExpansionMode: ma_mono_expansion_mode;
    flags: ma_uint32;
    volumeSmoothTimeInPCMFrames: ma_uint32;
    initialSeekPointInPCMFrames: ma_uint64;
    rangeBegInPCMFrames: ma_uint64;
    rangeEndInPCMFrames: ma_uint64;
    loopPointBegInPCMFrames: ma_uint64;
    loopPointEndInPCMFrames: ma_uint64;
    endCallback: ma_sound_end_proc;
    pEndCallbackUserData: Pointer;
    initNotifications: ma_resource_manager_pipeline_notifications;
    pDoneFence: Pma_fence;
    isLooping: ma_bool32;
  end;

  ma_sound = record
    engineNode: ma_engine_node;
    pDataSource: Pma_data_source;
    seekTarget: ma_uint64;
    atEnd: ma_bool32;
    endCallback: ma_sound_end_proc;
    pEndCallbackUserData: Pointer;
    ownsDataSource: ma_bool8;
    pResourceManagerDataSource: Pma_resource_manager_data_source;
  end;

  ma_sound_inlined = record
    sound: ma_sound;
    pNext: Pma_sound_inlined;
    pPrev: Pma_sound_inlined;
  end;

  ma_sound_group_config = ma_sound_config;
  Pma_sound_group_config = ^ma_sound_group_config;
  ma_sound_group = ma_sound;
  Pma_sound_group = ^ma_sound_group;

  ma_engine_process_proc = procedure(pUserData: Pointer; pFramesOut: PSingle; frameCount: ma_uint64); cdecl;

  ma_engine_config = record
    pResourceManager: Pma_resource_manager;
    pContext: Pma_context;
    pDevice: Pma_device;
    pPlaybackDeviceID: Pma_device_id;
    dataCallback: ma_device_data_proc;
    notificationCallback: ma_device_notification_proc;
    pLog: Pma_log;
    listenerCount: ma_uint32;
    channels: ma_uint32;
    sampleRate: ma_uint32;
    periodSizeInFrames: ma_uint32;
    periodSizeInMilliseconds: ma_uint32;
    gainSmoothTimeInFrames: ma_uint32;
    gainSmoothTimeInMilliseconds: ma_uint32;
    defaultVolumeSmoothTimeInPCMFrames: ma_uint32;
    preMixStackSizeInBytes: ma_uint32;
    allocationCallbacks: ma_allocation_callbacks;
    noAutoStart: ma_bool32;
    noDevice: ma_bool32;
    monoExpansionMode: ma_mono_expansion_mode;
    pResourceManagerVFS: Pma_vfs;
    onProcess: ma_engine_process_proc;
    pProcessUserData: Pointer;
  end;

  ma_engine = record
    nodeGraph: ma_node_graph;
    pResourceManager: Pma_resource_manager;
    pDevice: Pma_device;
    pLog: Pma_log;
    sampleRate: ma_uint32;
    listenerCount: ma_uint32;
    listeners: array [0..3] of ma_spatializer_listener;
    allocationCallbacks: ma_allocation_callbacks;
    ownsResourceManager: ma_bool8;
    ownsDevice: ma_bool8;
    inlinedSoundLock: ma_spinlock;
    pInlinedSoundHead: Pma_sound_inlined;
    inlinedSoundCount: ma_uint32;
    gainSmoothTimeInFrames: ma_uint32;
    defaultVolumeSmoothTimeInPCMFrames: ma_uint32;
    monoExpansionMode: ma_mono_expansion_mode;
    onProcess: ma_engine_process_proc;
    pProcessUserData: Pointer;
  end;

  Pplm_t = Pointer;
  PPplm_t = ^Pplm_t;
  Pplm_buffer_t = Pointer;
  PPplm_buffer_t = ^Pplm_buffer_t;
  Pplm_demux_t = Pointer;
  PPplm_demux_t = ^Pplm_demux_t;
  Pplm_video_t = Pointer;
  PPplm_video_t = ^Pplm_video_t;
  Pplm_audio_t = Pointer;
  PPplm_audio_t = ^Pplm_audio_t;

  plm_packet_t = record
    &type: Integer;
    pts: Double;
    length: NativeUInt;
    data: PUInt8;
  end;

  plm_plane_t = record
    width: Cardinal;
    height: Cardinal;
    data: PUInt8;
  end;

  plm_frame_t = record
    time: Double;
    width: Cardinal;
    height: Cardinal;
    y: plm_plane_t;
    cr: plm_plane_t;
    cb: plm_plane_t;
  end;

  plm_video_decode_callback = procedure(self: Pplm_t; frame: Pplm_frame_t; user: Pointer); cdecl;

  plm_samples_t = record
    time: Double;
    count: Cardinal;
    interleaved: array [0..2303] of Single;
  end;

  plm_audio_decode_callback = procedure(self: Pplm_t; samples: Pplm_samples_t; user: Pointer); cdecl;

  plm_buffer_load_callback = procedure(self: Pplm_buffer_t; user: Pointer); cdecl;

  plm_buffer_seek_callback = procedure(self: Pplm_buffer_t; offset: NativeUInt; user: Pointer); cdecl;

  plm_buffer_tell_callback = function(self: Pplm_buffer_t; user: Pointer): NativeUInt; cdecl;
  Psqlite3 = Pointer;
  PPsqlite3 = ^Psqlite3;
  sqlite_int64 = Int64;
  sqlite_uint64 = UInt64;
  sqlite3_int64 = sqlite_int64;
  Psqlite3_int64 = ^sqlite3_int64;
  sqlite3_uint64 = sqlite_uint64;

  sqlite3_callback = function(p1: Pointer; p2: Integer; p3: PPUTF8Char; p4: PPUTF8Char): Integer; cdecl;

  sqlite3_file = record
    pMethods: Psqlite3_io_methods;
  end;

  sqlite3_io_methods = record
    iVersion: Integer;
    xClose: function(p1: Psqlite3_file): Integer; cdecl;
    xRead: function(p1: Psqlite3_file; p2: Pointer; iAmt: Integer; iOfst: sqlite3_int64): Integer; cdecl;
    xWrite: function(p1: Psqlite3_file; const p2: Pointer; iAmt: Integer; iOfst: sqlite3_int64): Integer; cdecl;
    xTruncate: function(p1: Psqlite3_file; size: sqlite3_int64): Integer; cdecl;
    xSync: function(p1: Psqlite3_file; flags: Integer): Integer; cdecl;
    xFileSize: function(p1: Psqlite3_file; pSize: Psqlite3_int64): Integer; cdecl;
    xLock: function(p1: Psqlite3_file; p2: Integer): Integer; cdecl;
    xUnlock: function(p1: Psqlite3_file; p2: Integer): Integer; cdecl;
    xCheckReservedLock: function(p1: Psqlite3_file; pResOut: PInteger): Integer; cdecl;
    xFileControl: function(p1: Psqlite3_file; op: Integer; pArg: Pointer): Integer; cdecl;
    xSectorSize: function(p1: Psqlite3_file): Integer; cdecl;
    xDeviceCharacteristics: function(p1: Psqlite3_file): Integer; cdecl;
    xShmMap: function(p1: Psqlite3_file; iPg: Integer; pgsz: Integer; p4: Integer; p5: PPointer): Integer; cdecl;
    xShmLock: function(p1: Psqlite3_file; offset: Integer; n: Integer; flags: Integer): Integer; cdecl;
    xShmBarrier: procedure(p1: Psqlite3_file); cdecl;
    xShmUnmap: function(p1: Psqlite3_file; deleteFlag: Integer): Integer; cdecl;
    xFetch: function(p1: Psqlite3_file; iOfst: sqlite3_int64; iAmt: Integer; pp: PPointer): Integer; cdecl;
    xUnfetch: function(p1: Psqlite3_file; iOfst: sqlite3_int64; p: Pointer): Integer; cdecl;
  end;

  Psqlite3_mutex = Pointer;
  PPsqlite3_mutex = ^Psqlite3_mutex;
  sqlite3_filename = PUTF8Char;

  sqlite3_syscall_ptr = procedure(); cdecl;

  Pvoid = Pointer;
  sqlite3_vfs = record
    iVersion: Integer;
    szOsFile: Integer;
    mxPathname: Integer;
    pNext: Psqlite3_vfs;
    zName: PUTF8Char;
    pAppData: Pointer;
    xOpen: function(p1: Psqlite3_vfs; zName: sqlite3_filename; p3: Psqlite3_file; flags: Integer; pOutFlags: PInteger): Integer; cdecl;
    xDelete: function(p1: Psqlite3_vfs; const zName: PUTF8Char; syncDir: Integer): Integer; cdecl;
    xAccess: function(p1: Psqlite3_vfs; const zName: PUTF8Char; flags: Integer; pResOut: PInteger): Integer; cdecl;
    xFullPathname: function(p1: Psqlite3_vfs; const zName: PUTF8Char; nOut: Integer; zOut: PUTF8Char): Integer; cdecl;
    xDlOpen: function(p1: Psqlite3_vfs; const zFilename: PUTF8Char): Pointer; cdecl;
    xDlError: procedure(p1: Psqlite3_vfs; nByte: Integer; zErrMsg: PUTF8Char); cdecl;
    xDlSym: function(p1: Psqlite3_vfs; p2: Pointer; const zSymbol: PUTF8Char): Pvoid; cdecl;
    xDlClose: procedure(p1: Psqlite3_vfs; p2: Pointer); cdecl;
    xRandomness: function(p1: Psqlite3_vfs; nByte: Integer; zOut: PUTF8Char): Integer; cdecl;
    xSleep: function(p1: Psqlite3_vfs; microseconds: Integer): Integer; cdecl;
    xCurrentTime: function(p1: Psqlite3_vfs; p2: PDouble): Integer; cdecl;
    xGetLastError: function(p1: Psqlite3_vfs; p2: Integer; p3: PUTF8Char): Integer; cdecl;
    xCurrentTimeInt64: function(p1: Psqlite3_vfs; p2: Psqlite3_int64): Integer; cdecl;
    xSetSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char; p3: sqlite3_syscall_ptr): Integer; cdecl;
    xGetSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char): sqlite3_syscall_ptr; cdecl;
    xNextSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char): PUTF8Char; cdecl;
  end;

  sqlite3_mem_methods = record
    xMalloc: function(p1: Integer): Pointer; cdecl;
    xFree: procedure(p1: Pointer); cdecl;
    xRealloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
    xSize: function(p1: Pointer): Integer; cdecl;
    xRoundup: function(p1: Integer): Integer; cdecl;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    pAppData: Pointer;
  end;

  Psqlite3_stmt = Pointer;
  PPsqlite3_stmt = ^Psqlite3_stmt;
  Psqlite3_value = Pointer;
  PPsqlite3_value = ^Psqlite3_value;
  Psqlite3_context = Pointer;
  PPsqlite3_context = ^Psqlite3_context;

  sqlite3_destructor_type = procedure(p1: Pointer); cdecl;

  PPvoid = ^Pvoid;
  TpxFunc = procedure(pCtx: Psqlite3_context; n: Integer; apVal: PPsqlite3_value);
  sqlite3_module = record
    iVersion: Integer;
    xCreate: function(p1: Psqlite3; pAux: Pointer; argc: Integer; const argv: PPUTF8Char; ppVTab: PPsqlite3_vtab; p6: PPUTF8Char): Integer; cdecl;
    xConnect: function(p1: Psqlite3; pAux: Pointer; argc: Integer; const argv: PPUTF8Char; ppVTab: PPsqlite3_vtab; p6: PPUTF8Char): Integer; cdecl;
    xBestIndex: function(pVTab: Psqlite3_vtab; p2: Psqlite3_index_info): Integer; cdecl;
    xDisconnect: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xDestroy: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xOpen: function(pVTab: Psqlite3_vtab; ppCursor: PPsqlite3_vtab_cursor): Integer; cdecl;
    xClose: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xFilter: function(p1: Psqlite3_vtab_cursor; idxNum: Integer; const idxStr: PUTF8Char; argc: Integer; argv: PPsqlite3_value): Integer; cdecl;
    xNext: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xEof: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xColumn: function(p1: Psqlite3_vtab_cursor; p2: Psqlite3_context; p3: Integer): Integer; cdecl;
    xRowid: function(p1: Psqlite3_vtab_cursor; pRowid: Psqlite3_int64): Integer; cdecl;
    xUpdate: function(p1: Psqlite3_vtab; p2: Integer; p3: PPsqlite3_value; p4: Psqlite3_int64): Integer; cdecl;
    xBegin: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xSync: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xCommit: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xRollback: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xFindFunction: function(pVtab: Psqlite3_vtab; nArg: Integer; zName: PAnsiChar; var pxFunc: TpxFunc; var ppArg: Pointer): Integer; cdecl;
    xRename: function(pVtab: Psqlite3_vtab; const zNew: PUTF8Char): Integer; cdecl;
    xSavepoint: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xRelease: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xRollbackTo: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xShadowName: function(const p1: PUTF8Char): Integer; cdecl;
    xIntegrity: function(pVTab: Psqlite3_vtab; const zSchema: PUTF8Char; const zTabName: PUTF8Char; mFlags: Integer; pzErr: PPUTF8Char): Integer; cdecl;
  end;

  sqlite3_index_constraint = record
    iColumn: Integer;
    op: Byte;
    usable: Byte;
    iTermOffset: Integer;
  end;

  sqlite3_index_orderby = record
    iColumn: Integer;
    desc: Byte;
  end;

  sqlite3_index_constraint_usage = record
    argvIndex: Integer;
    omit: Byte;
  end;

  sqlite3_index_info = record
    nConstraint: Integer;
    aConstraint: Psqlite3_index_constraint;
    nOrderBy: Integer;
    aOrderBy: Psqlite3_index_orderby;
    aConstraintUsage: Psqlite3_index_constraint_usage;
    idxNum: Integer;
    idxStr: PUTF8Char;
    needToFreeIdxStr: Integer;
    orderByConsumed: Integer;
    estimatedCost: Double;
    estimatedRows: sqlite3_int64;
    idxFlags: Integer;
    colUsed: sqlite3_uint64;
  end;

  sqlite3_vtab = record
    pModule: Psqlite3_module;
    nRef: Integer;
    zErrMsg: PUTF8Char;
  end;

  sqlite3_vtab_cursor = record
    pVtab: Psqlite3_vtab;
  end;

  Psqlite3_blob = Pointer;
  PPsqlite3_blob = ^Psqlite3_blob;

  sqlite3_mutex_methods = record
    xMutexInit: function(): Integer; cdecl;
    xMutexEnd: function(): Integer; cdecl;
    xMutexAlloc: function(p1: Integer): Psqlite3_mutex; cdecl;
    xMutexFree: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexEnter: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexTry: function(p1: Psqlite3_mutex): Integer; cdecl;
    xMutexLeave: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexHeld: function(p1: Psqlite3_mutex): Integer; cdecl;
    xMutexNotheld: function(p1: Psqlite3_mutex): Integer; cdecl;
  end;

  Psqlite3_str = Pointer;
  PPsqlite3_str = ^Psqlite3_str;
  Psqlite3_pcache = Pointer;
  PPsqlite3_pcache = ^Psqlite3_pcache;

  sqlite3_pcache_page = record
    pBuf: Pointer;
    pExtra: Pointer;
  end;

  sqlite3_pcache_methods2 = record
    iVersion: Integer;
    pArg: Pointer;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    xCreate: function(szPage: Integer; szExtra: Integer; bPurgeable: Integer): Psqlite3_pcache; cdecl;
    xCachesize: procedure(p1: Psqlite3_pcache; nCachesize: Integer); cdecl;
    xPagecount: function(p1: Psqlite3_pcache): Integer; cdecl;
    xFetch: function(p1: Psqlite3_pcache; key: Cardinal; createFlag: Integer): Psqlite3_pcache_page; cdecl;
    xUnpin: procedure(p1: Psqlite3_pcache; p2: Psqlite3_pcache_page; discard: Integer); cdecl;
    xRekey: procedure(p1: Psqlite3_pcache; p2: Psqlite3_pcache_page; oldKey: Cardinal; newKey: Cardinal); cdecl;
    xTruncate: procedure(p1: Psqlite3_pcache; iLimit: Cardinal); cdecl;
    xDestroy: procedure(p1: Psqlite3_pcache); cdecl;
    xShrink: procedure(p1: Psqlite3_pcache); cdecl;
  end;

  sqlite3_pcache_methods = record
    pArg: Pointer;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    xCreate: function(szPage: Integer; bPurgeable: Integer): Psqlite3_pcache; cdecl;
    xCachesize: procedure(p1: Psqlite3_pcache; nCachesize: Integer); cdecl;
    xPagecount: function(p1: Psqlite3_pcache): Integer; cdecl;
    xFetch: function(p1: Psqlite3_pcache; key: Cardinal; createFlag: Integer): Pointer; cdecl;
    xUnpin: procedure(p1: Psqlite3_pcache; p2: Pointer; discard: Integer); cdecl;
    xRekey: procedure(p1: Psqlite3_pcache; p2: Pointer; oldKey: Cardinal; newKey: Cardinal); cdecl;
    xTruncate: procedure(p1: Psqlite3_pcache; iLimit: Cardinal); cdecl;
    xDestroy: procedure(p1: Psqlite3_pcache); cdecl;
  end;

  Psqlite3_backup = Pointer;
  PPsqlite3_backup = ^Psqlite3_backup;

  sqlite3_snapshot = record
    hidden: array [0..47] of Byte;
  end;

  sqlite3_rtree_dbl = Double;
  Psqlite3_rtree_dbl = ^sqlite3_rtree_dbl;

  sqlite3_rtree_geometry = record
    pContext: Pointer;
    nParam: Integer;
    aParam: Psqlite3_rtree_dbl;
    pUser: Pointer;
    xDelUser: procedure(p1: Pointer); cdecl;
  end;

  sqlite3_rtree_query_info = record
    pContext: Pointer;
    nParam: Integer;
    aParam: Psqlite3_rtree_dbl;
    pUser: Pointer;
    xDelUser: procedure(p1: Pointer); cdecl;
    aCoord: Psqlite3_rtree_dbl;
    anQueue: PCardinal;
    nCoord: Integer;
    iLevel: Integer;
    mxLevel: Integer;
    iRowid: sqlite3_int64;
    rParentScore: sqlite3_rtree_dbl;
    eParentWithin: Integer;
    eWithin: Integer;
    rScore: sqlite3_rtree_dbl;
    apSqlParam: PPsqlite3_value;
  end;

  PFts5Context = Pointer;
  PPFts5Context = ^PFts5Context;

  fts5_extension_function = procedure(const pApi: PFts5ExtensionApi; pFts: PFts5Context; pCtx: Psqlite3_context; nVal: Integer; apVal: PPsqlite3_value); cdecl;

  Fts5PhraseIter = record
    a: PByte;
    b: PByte;
  end;

  Fts5ExtensionApi = record
    iVersion: Integer;
    xUserData: function(p1: PFts5Context): Pointer; cdecl;
    xColumnCount: function(p1: PFts5Context): Integer; cdecl;
    xRowCount: function(p1: PFts5Context; pnRow: Psqlite3_int64): Integer; cdecl;
    xColumnTotalSize: function(p1: PFts5Context; iCol: Integer; pnToken: Psqlite3_int64): Integer; cdecl;
    xTokenize: function(p1: PFts5Context; const pText: PUTF8Char; nText: Integer; pCtx: Pointer; xToken: Pointer): Integer; cdecl;
    xPhraseCount: function(p1: PFts5Context): Integer; cdecl;
    xPhraseSize: function(p1: PFts5Context; iPhrase: Integer): Integer; cdecl;
    xInstCount: function(p1: PFts5Context; pnInst: PInteger): Integer; cdecl;
    xInst: function(p1: PFts5Context; iIdx: Integer; piPhrase: PInteger; piCol: PInteger; piOff: PInteger): Integer; cdecl;
    xRowid: function(p1: PFts5Context): sqlite3_int64; cdecl;
    xColumnText: function(p1: PFts5Context; iCol: Integer; pz: PPUTF8Char; pn: PInteger): Integer; cdecl;
    xColumnSize: function(p1: PFts5Context; iCol: Integer; pnToken: PInteger): Integer; cdecl;
    xQueryPhrase: function(p1: PFts5Context; iPhrase: Integer; pUserData: Pointer; p4: Pointer): Integer; cdecl;
    xSetAuxdata: function(p1: PFts5Context; pAux: Pointer; xDelete: Pointer): Integer; cdecl;
    xGetAuxdata: function(p1: PFts5Context; bClear: Integer): Pointer; cdecl;
    xPhraseFirst: function(p1: PFts5Context; iPhrase: Integer; p3: PFts5PhraseIter; p4: PInteger; p5: PInteger): Integer; cdecl;
    xPhraseNext: procedure(p1: PFts5Context; p2: PFts5PhraseIter; piCol: PInteger; piOff: PInteger); cdecl;
    xPhraseFirstColumn: function(p1: PFts5Context; iPhrase: Integer; p3: PFts5PhraseIter; p4: PInteger): Integer; cdecl;
    xPhraseNextColumn: procedure(p1: PFts5Context; p2: PFts5PhraseIter; piCol: PInteger); cdecl;
    xQueryToken: function(p1: PFts5Context; iPhrase: Integer; iToken: Integer; ppToken: PPUTF8Char; pnToken: PInteger): Integer; cdecl;
    xInstToken: function(p1: PFts5Context; iIdx: Integer; iToken: Integer; p4: PPUTF8Char; p5: PInteger): Integer; cdecl;
    xColumnLocale: function(p1: PFts5Context; iCol: Integer; pz: PPUTF8Char; pn: PInteger): Integer; cdecl;
    xTokenize_v2: function(p1: PFts5Context; const pText: PUTF8Char; nText: Integer; const pLocale: PUTF8Char; nLocale: Integer; pCtx: Pointer; xToken: Pointer): Integer; cdecl;
  end;

  PFts5Tokenizer = Pointer;
  PPFts5Tokenizer = ^PFts5Tokenizer;

  fts5_tokenizer_v2 = record
    iVersion: Integer;
    xCreate: function(p1: Pointer; azArg: PPUTF8Char; nArg: Integer; ppOut: PPFts5Tokenizer): Integer; cdecl;
    xDelete: procedure(p1: PFts5Tokenizer); cdecl;
    xTokenize: function(p1: PFts5Tokenizer; pCtx: Pointer; flags: Integer; const pText: PUTF8Char; nText: Integer; const pLocale: PUTF8Char; nLocale: Integer; xToken: Pointer): Integer; cdecl;
  end;

  fts5_tokenizer = record
    xCreate: function(p1: Pointer; azArg: PPUTF8Char; nArg: Integer; ppOut: PPFts5Tokenizer): Integer; cdecl;
    xDelete: procedure(p1: PFts5Tokenizer); cdecl;
    xTokenize: function(p1: PFts5Tokenizer; pCtx: Pointer; flags: Integer; const pText: PUTF8Char; nText: Integer; xToken: Pointer): Integer; cdecl;
  end;

  fts5_api = record
    iVersion: Integer;
    xCreateTokenizer: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; pTokenizer: Pfts5_tokenizer; xDestroy: Pointer): Integer; cdecl;
    xFindTokenizer: function(pApi: Pfts5_api; const zName: PUTF8Char; ppUserData: PPointer; pTokenizer: Pfts5_tokenizer): Integer; cdecl;
    xCreateFunction: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; xFunction: fts5_extension_function; xDestroy: Pointer): Integer; cdecl;
    xCreateTokenizer_v2: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; pTokenizer: Pfts5_tokenizer_v2; xDestroy: Pointer): Integer; cdecl;
    xFindTokenizer_v2: function(pApi: Pfts5_api; const zName: PUTF8Char; ppUserData: PPointer; ppTokenizer: PPfts5_tokenizer_v2): Integer; cdecl;
  end;

  sqlite3_api_routines = record
    aggregate_context: function(p1: Psqlite3_context; nBytes: Integer): Pointer; cdecl;
    aggregate_count: function(p1: Psqlite3_context): Integer; cdecl;
    bind_blob: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; n: Integer; p5: Pointer): Integer; cdecl;
    bind_double: function(p1: Psqlite3_stmt; p2: Integer; p3: Double): Integer; cdecl;
    bind_int: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    bind_int64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite_int64): Integer; cdecl;
    bind_null: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
    bind_parameter_count: function(p1: Psqlite3_stmt): Integer; cdecl;
    bind_parameter_index: function(p1: Psqlite3_stmt; const zName: PUTF8Char): Integer; cdecl;
    bind_parameter_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    bind_text: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; n: Integer; p5: Pointer): Integer; cdecl;
    bind_text16: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: Integer; p5: Pointer): Integer; cdecl;
    bind_value: function(p1: Psqlite3_stmt; p2: Integer; const p3: Psqlite3_value): Integer; cdecl;
    busy_handler: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    busy_timeout: function(p1: Psqlite3; ms: Integer): Integer; cdecl;
    changes: function(p1: Psqlite3): Integer; cdecl;
    close: function(p1: Psqlite3): Integer; cdecl;
    collation_needed: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    collation_needed16: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    column_blob: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
    column_bytes: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_bytes16: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    column_database_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_database_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_decltype: function(p1: Psqlite3_stmt; i: Integer): PUTF8Char; cdecl;
    column_decltype16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_double: function(p1: Psqlite3_stmt; iCol: Integer): Double; cdecl;
    column_int: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_int64: function(p1: Psqlite3_stmt; iCol: Integer): sqlite_int64; cdecl;
    column_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_origin_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_origin_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_table_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_table_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_text: function(p1: Psqlite3_stmt; iCol: Integer): PByte; cdecl;
    column_text16: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
    column_type: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_value: function(p1: Psqlite3_stmt; iCol: Integer): Psqlite3_value; cdecl;
    commit_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    complete: function(const sql: PUTF8Char): Integer; cdecl;
    complete16: function(const sql: Pointer): Integer; cdecl;
    create_collation: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer; p5: Pointer): Integer; cdecl;
    create_collation16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Pointer; p5: Pointer): Integer; cdecl;
    create_function: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer): Integer; cdecl;
    create_function16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer): Integer; cdecl;
    create_module: function(p1: Psqlite3; const p2: PUTF8Char; const p3: Psqlite3_module; p4: Pointer): Integer; cdecl;
    data_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    db_handle: function(p1: Psqlite3_stmt): Psqlite3; cdecl;
    declare_vtab: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    enable_shared_cache: function(p1: Integer): Integer; cdecl;
    errcode: function(db: Psqlite3): Integer; cdecl;
    errmsg: function(p1: Psqlite3): PUTF8Char; cdecl;
    errmsg16: function(p1: Psqlite3): Pointer; cdecl;
    exec: function(p1: Psqlite3; const p2: PUTF8Char; p3: sqlite3_callback; p4: Pointer; p5: PPUTF8Char): Integer; cdecl;
    expired: function(p1: Psqlite3_stmt): Integer; cdecl;
    finalize: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    free: procedure(p1: Pointer); cdecl;
    free_table: procedure(result: PPUTF8Char); cdecl;
    get_autocommit: function(p1: Psqlite3): Integer; cdecl;
    get_auxdata: function(p1: Psqlite3_context; p2: Integer): Pointer; cdecl;
    get_table: function(p1: Psqlite3; const p2: PUTF8Char; p3: PPPUTF8Char; p4: PInteger; p5: PInteger; p6: PPUTF8Char): Integer; cdecl;
    global_recover: function(): Integer; cdecl;
    interruptx: procedure(p1: Psqlite3); cdecl;
    last_insert_rowid: function(p1: Psqlite3): sqlite_int64; cdecl;
    libversion: function(): PUTF8Char; cdecl;
    libversion_number: function(): Integer; cdecl;
    malloc: function(p1: Integer): Pointer; cdecl;
    mprintf: function(const p1: PUTF8Char): PUTF8Char varargs; cdecl;
    open: function(const p1: PUTF8Char; p2: PPsqlite3): Integer; cdecl;
    open16: function(const p1: Pointer; p2: PPsqlite3): Integer; cdecl;
    prepare: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PPsqlite3_stmt; p5: PPUTF8Char): Integer; cdecl;
    prepare16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: PPsqlite3_stmt; p5: PPointer): Integer; cdecl;
    profile: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    progress_handler: procedure(p1: Psqlite3; p2: Integer; p3: Pointer; p4: Pointer); cdecl;
    realloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
    reset: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    result_blob: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_double: procedure(p1: Psqlite3_context; p2: Double); cdecl;
    result_error: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer); cdecl;
    result_error16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer); cdecl;
    result_int: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    result_int64: procedure(p1: Psqlite3_context; p2: sqlite_int64); cdecl;
    result_null: procedure(p1: Psqlite3_context); cdecl;
    result_text: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer; p4: Pointer); cdecl;
    result_text16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_text16be: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_text16le: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_value: procedure(p1: Psqlite3_context; p2: Psqlite3_value); cdecl;
    rollback_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    set_authorizer: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    set_auxdata: procedure(p1: Psqlite3_context; p2: Integer; p3: Pointer; p4: Pointer); cdecl;
    xsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char): PUTF8Char varargs; cdecl;
    step: function(p1: Psqlite3_stmt): Integer; cdecl;
    table_column_metadata: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; const p4: PUTF8Char; p5: PPUTF8Char; p6: PPUTF8Char; p7: PInteger; p8: PInteger; p9: PInteger): Integer; cdecl;
    thread_cleanup: procedure(); cdecl;
    total_changes: function(p1: Psqlite3): Integer; cdecl;
    trace: function(p1: Psqlite3; xTrace: Pointer; p3: Pointer): Pointer; cdecl;
    transfer_bindings: function(p1: Psqlite3_stmt; p2: Psqlite3_stmt): Integer; cdecl;
    update_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    user_data: function(p1: Psqlite3_context): Pointer; cdecl;
    value_blob: function(p1: Psqlite3_value): Pointer; cdecl;
    value_bytes: function(p1: Psqlite3_value): Integer; cdecl;
    value_bytes16: function(p1: Psqlite3_value): Integer; cdecl;
    value_double: function(p1: Psqlite3_value): Double; cdecl;
    value_int: function(p1: Psqlite3_value): Integer; cdecl;
    value_int64: function(p1: Psqlite3_value): sqlite_int64; cdecl;
    value_numeric_type: function(p1: Psqlite3_value): Integer; cdecl;
    value_text: function(p1: Psqlite3_value): PByte; cdecl;
    value_text16: function(p1: Psqlite3_value): Pointer; cdecl;
    value_text16be: function(p1: Psqlite3_value): Pointer; cdecl;
    value_text16le: function(p1: Psqlite3_value): Pointer; cdecl;
    value_type: function(p1: Psqlite3_value): Integer; cdecl;
    vmprintf: function(const p1: PUTF8Char; p2: Pointer): PUTF8Char; cdecl;
    overload_function: function(p1: Psqlite3; const zFuncName: PUTF8Char; nArg: Integer): Integer; cdecl;
    prepare_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PPsqlite3_stmt; p5: PPUTF8Char): Integer; cdecl;
    prepare16_v2: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: PPsqlite3_stmt; p5: PPointer): Integer; cdecl;
    clear_bindings: function(p1: Psqlite3_stmt): Integer; cdecl;
    create_module_v2: function(p1: Psqlite3; const p2: PUTF8Char; const p3: Psqlite3_module; p4: Pointer; xDestroy: Pointer): Integer; cdecl;
    bind_zeroblob: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    blob_bytes: function(p1: Psqlite3_blob): Integer; cdecl;
    blob_close: function(p1: Psqlite3_blob): Integer; cdecl;
    blob_open: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; const p4: PUTF8Char; p5: sqlite3_int64; p6: Integer; p7: PPsqlite3_blob): Integer; cdecl;
    blob_read: function(p1: Psqlite3_blob; p2: Pointer; p3: Integer; p4: Integer): Integer; cdecl;
    blob_write: function(p1: Psqlite3_blob; const p2: Pointer; p3: Integer; p4: Integer): Integer; cdecl;
    create_collation_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer; p5: Pointer; p6: Pointer): Integer; cdecl;
    file_control: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer): Integer; cdecl;
    memory_highwater: function(p1: Integer): sqlite3_int64; cdecl;
    memory_used: function(): sqlite3_int64; cdecl;
    mutex_alloc: function(p1: Integer): Psqlite3_mutex; cdecl;
    mutex_enter: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_free: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_leave: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_try: function(p1: Psqlite3_mutex): Integer; cdecl;
    open_v2: function(const p1: PUTF8Char; p2: PPsqlite3; p3: Integer; const p4: PUTF8Char): Integer; cdecl;
    release_memory: function(p1: Integer): Integer; cdecl;
    result_error_nomem: procedure(p1: Psqlite3_context); cdecl;
    result_error_toobig: procedure(p1: Psqlite3_context); cdecl;
    sleep: function(p1: Integer): Integer; cdecl;
    soft_heap_limit: procedure(p1: Integer); cdecl;
    vfs_find: function(const p1: PUTF8Char): Psqlite3_vfs; cdecl;
    vfs_register: function(p1: Psqlite3_vfs; p2: Integer): Integer; cdecl;
    vfs_unregister: function(p1: Psqlite3_vfs): Integer; cdecl;
    xthreadsafe: function(): Integer; cdecl;
    result_zeroblob: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    result_error_code: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    test_control: function(p1: Integer): Integer varargs; cdecl;
    randomness: procedure(p1: Integer; p2: Pointer); cdecl;
    context_db_handle: function(p1: Psqlite3_context): Psqlite3; cdecl;
    extended_result_codes: function(p1: Psqlite3; p2: Integer): Integer; cdecl;
    limit: function(p1: Psqlite3; p2: Integer; p3: Integer): Integer; cdecl;
    next_stmt: function(p1: Psqlite3; p2: Psqlite3_stmt): Psqlite3_stmt; cdecl;
    sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    status: function(p1: Integer; p2: PInteger; p3: PInteger; p4: Integer): Integer; cdecl;
    backup_finish: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_init: function(p1: Psqlite3; const p2: PUTF8Char; p3: Psqlite3; const p4: PUTF8Char): Psqlite3_backup; cdecl;
    backup_pagecount: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_remaining: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_step: function(p1: Psqlite3_backup; p2: Integer): Integer; cdecl;
    compileoption_get: function(p1: Integer): PUTF8Char; cdecl;
    compileoption_used: function(const p1: PUTF8Char): Integer; cdecl;
    create_function_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer; xDestroy: Pointer): Integer; cdecl;
    db_config: function(p1: Psqlite3; p2: Integer): Integer varargs; cdecl;
    db_mutex: function(p1: Psqlite3): Psqlite3_mutex; cdecl;
    db_status: function(p1: Psqlite3; p2: Integer; p3: PInteger; p4: PInteger; p5: Integer): Integer; cdecl;
    extended_errcode: function(p1: Psqlite3): Integer; cdecl;
    log: procedure(p1: Integer; const p2: PUTF8Char) varargs; cdecl;
    soft_heap_limit64: function(p1: sqlite3_int64): sqlite3_int64; cdecl;
    sourceid: function(): PUTF8Char; cdecl;
    stmt_status: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    strnicmp: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
    unlock_notify: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    wal_autocheckpoint: function(p1: Psqlite3; p2: Integer): Integer; cdecl;
    wal_checkpoint: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    wal_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    blob_reopen: function(p1: Psqlite3_blob; p2: sqlite3_int64): Integer; cdecl;
    vtab_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
    vtab_on_conflict: function(p1: Psqlite3): Integer; cdecl;
    close_v2: function(p1: Psqlite3): Integer; cdecl;
    db_filename: function(p1: Psqlite3; const p2: PUTF8Char): PUTF8Char; cdecl;
    db_readonly: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    db_release_memory: function(p1: Psqlite3): Integer; cdecl;
    errstr: function(p1: Integer): PUTF8Char; cdecl;
    stmt_busy: function(p1: Psqlite3_stmt): Integer; cdecl;
    stmt_readonly: function(p1: Psqlite3_stmt): Integer; cdecl;
    stricmp: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
    uri_boolean: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
    uri_int64: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: sqlite3_int64): sqlite3_int64; cdecl;
    uri_parameter: function(const p1: PUTF8Char; const p2: PUTF8Char): PUTF8Char; cdecl;
    xvsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char; p4: Pointer): PUTF8Char; cdecl;
    wal_checkpoint_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PInteger; p5: PInteger): Integer; cdecl;
    auto_extension: function(p1: Pointer): Integer; cdecl;
    bind_blob64: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: sqlite3_uint64; p5: Pointer): Integer; cdecl;
    bind_text64: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: sqlite3_uint64; p5: Pointer; p6: Byte): Integer; cdecl;
    cancel_auto_extension: function(p1: Pointer): Integer; cdecl;
    load_extension: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; p4: PPUTF8Char): Integer; cdecl;
    malloc64: function(p1: sqlite3_uint64): Pointer; cdecl;
    msize: function(p1: Pointer): sqlite3_uint64; cdecl;
    realloc64: function(p1: Pointer; p2: sqlite3_uint64): Pointer; cdecl;
    reset_auto_extension: procedure(); cdecl;
    result_blob64: procedure(p1: Psqlite3_context; const p2: Pointer; p3: sqlite3_uint64; p4: Pointer); cdecl;
    result_text64: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: sqlite3_uint64; p4: Pointer; p5: Byte); cdecl;
    strglob: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
    value_dup: function(const p1: Psqlite3_value): Psqlite3_value; cdecl;
    value_free: procedure(p1: Psqlite3_value); cdecl;
    result_zeroblob64: function(p1: Psqlite3_context; p2: sqlite3_uint64): Integer; cdecl;
    bind_zeroblob64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_uint64): Integer; cdecl;
    value_subtype: function(p1: Psqlite3_value): Cardinal; cdecl;
    result_subtype: procedure(p1: Psqlite3_context; p2: Cardinal); cdecl;
    status64: function(p1: Integer; p2: Psqlite3_int64; p3: Psqlite3_int64; p4: Integer): Integer; cdecl;
    strlike: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Cardinal): Integer; cdecl;
    db_cacheflush: function(p1: Psqlite3): Integer; cdecl;
    system_errno: function(p1: Psqlite3): Integer; cdecl;
    trace_v2: function(p1: Psqlite3; p2: Cardinal; p3: Pointer; p4: Pointer): Integer; cdecl;
    expanded_sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    set_last_insert_rowid: procedure(p1: Psqlite3; p2: sqlite3_int64); cdecl;
    prepare_v3: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Cardinal; p5: PPsqlite3_stmt; p6: PPUTF8Char): Integer; cdecl;
    prepare16_v3: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Cardinal; p5: PPsqlite3_stmt; p6: PPointer): Integer; cdecl;
    bind_pointer: function(p1: Psqlite3_stmt; p2: Integer; p3: Pointer; const p4: PUTF8Char; p5: Pointer): Integer; cdecl;
    result_pointer: procedure(p1: Psqlite3_context; p2: Pointer; const p3: PUTF8Char; p4: Pointer); cdecl;
    value_pointer: function(p1: Psqlite3_value; const p2: PUTF8Char): Pointer; cdecl;
    vtab_nochange: function(p1: Psqlite3_context): Integer; cdecl;
    value_nochange: function(p1: Psqlite3_value): Integer; cdecl;
    vtab_collation: function(p1: Psqlite3_index_info; p2: Integer): PUTF8Char; cdecl;
    keyword_count: function(): Integer; cdecl;
    keyword_name: function(p1: Integer; p2: PPUTF8Char; p3: PInteger): Integer; cdecl;
    keyword_check: function(const p1: PUTF8Char; p2: Integer): Integer; cdecl;
    str_new: function(p1: Psqlite3): Psqlite3_str; cdecl;
    str_finish: function(p1: Psqlite3_str): PUTF8Char; cdecl;
    str_appendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char) varargs; cdecl;
    str_vappendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char; p3: Pointer); cdecl;
    str_append: procedure(p1: Psqlite3_str; const zIn: PUTF8Char; N: Integer); cdecl;
    str_appendall: procedure(p1: Psqlite3_str; const zIn: PUTF8Char); cdecl;
    str_appendchar: procedure(p1: Psqlite3_str; N: Integer; C: UTF8Char); cdecl;
    str_reset: procedure(p1: Psqlite3_str); cdecl;
    str_errcode: function(p1: Psqlite3_str): Integer; cdecl;
    str_length: function(p1: Psqlite3_str): Integer; cdecl;
    str_value: function(p1: Psqlite3_str): PUTF8Char; cdecl;
    create_window_function: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xStep: Pointer; xFinal: Pointer; xValue: Pointer; xInv: Pointer; xDestroy: Pointer): Integer; cdecl;
    normalized_sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    stmt_isexplain: function(p1: Psqlite3_stmt): Integer; cdecl;
    value_frombind: function(p1: Psqlite3_value): Integer; cdecl;
    drop_modules: function(p1: Psqlite3; p2: PPUTF8Char): Integer; cdecl;
    hard_heap_limit64: function(p1: sqlite3_int64): sqlite3_int64; cdecl;
    uri_key: function(const p1: PUTF8Char; p2: Integer): PUTF8Char; cdecl;
    filename_database: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    filename_journal: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    filename_wal: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    create_filename: function(const p1: PUTF8Char; const p2: PUTF8Char; const p3: PUTF8Char; p4: Integer; p5: PPUTF8Char): PUTF8Char; cdecl;
    free_filename: procedure(const p1: PUTF8Char); cdecl;
    database_file_object: function(const p1: PUTF8Char): Psqlite3_file; cdecl;
    txn_state: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
    total_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
    autovacuum_pages: function(p1: Psqlite3; p2: Pointer; p3: Pointer; p4: Pointer): Integer; cdecl;
    error_offset: function(p1: Psqlite3): Integer; cdecl;
    vtab_rhs_value: function(p1: Psqlite3_index_info; p2: Integer; p3: PPsqlite3_value): Integer; cdecl;
    vtab_distinct: function(p1: Psqlite3_index_info): Integer; cdecl;
    vtab_in: function(p1: Psqlite3_index_info; p2: Integer; p3: Integer): Integer; cdecl;
    vtab_in_first: function(p1: Psqlite3_value; p2: PPsqlite3_value): Integer; cdecl;
    vtab_in_next: function(p1: Psqlite3_value; p2: PPsqlite3_value): Integer; cdecl;
    deserialize: function(p1: Psqlite3; const p2: PUTF8Char; p3: PByte; p4: sqlite3_int64; p5: sqlite3_int64; p6: Cardinal): Integer; cdecl;
    serialize: function(p1: Psqlite3; const p2: PUTF8Char; p3: Psqlite3_int64; p4: Cardinal): PByte; cdecl;
    db_name: function(p1: Psqlite3; p2: Integer): PUTF8Char; cdecl;
    value_encoding: function(p1: Psqlite3_value): Integer; cdecl;
    is_interrupted: function(p1: Psqlite3): Integer; cdecl;
    stmt_explain: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
    get_clientdata: function(p1: Psqlite3; const p2: PUTF8Char): Pointer; cdecl;
    set_clientdata: function(p1: Psqlite3; const p2: PUTF8Char; p3: Pointer; p4: Pointer): Integer; cdecl;
    setlk_timeout: function(p1: Psqlite3; p2: Integer; p3: Integer): Integer; cdecl;
  end;

  sqlite3_loadext_entry = function(db: Psqlite3; pzErrMsg: PPUTF8Char; const pThunk: Psqlite3_api_routines): Integer; cdecl;
  stbi_uc = Byte;
  Pstbi_uc = ^stbi_uc;
  stbi_us = Word;
  Pstbi_us = ^stbi_us;

  stbi_io_callbacks = record
    read: function(user: Pointer; data: PUTF8Char; size: Integer): Integer; cdecl;
    skip: procedure(user: Pointer; n: Integer); cdecl;
    eof: function(user: Pointer): Integer; cdecl;
  end;

  Pstbi_write_func = procedure(context: Pointer; data: Pointer; size: Integer); cdecl;
  stbrp_coord = Integer;

  stbrp_rect = record
    id: Integer;
    w: stbrp_coord;
    h: stbrp_coord;
    x: stbrp_coord;
    y: stbrp_coord;
    was_packed: Integer;
  end;

  stbrp_node = record
    x: stbrp_coord;
    y: stbrp_coord;
    next: Pstbrp_node;
  end;

  stbrp_context = record
    width: Integer;
    height: Integer;
    align: Integer;
    init_mode: Integer;
    heuristic: Integer;
    num_nodes: Integer;
    active_head: Pstbrp_node;
    free_head: Pstbrp_node;
    extra: array [0..1] of stbrp_node;
  end;

  stbtt__buf = record
    data: PByte;
    cursor: Integer;
    size: Integer;
  end;

  stbtt_bakedchar = record
    x0: Word;
    y0: Word;
    x1: Word;
    y1: Word;
    xoff: Single;
    yoff: Single;
    xadvance: Single;
  end;

  stbtt_aligned_quad = record
    x0: Single;
    y0: Single;
    s0: Single;
    t0: Single;
    x1: Single;
    y1: Single;
    s1: Single;
    t1: Single;
  end;

  stbtt_packedchar = record
    x0: Word;
    y0: Word;
    x1: Word;
    y1: Word;
    xoff: Single;
    yoff: Single;
    xadvance: Single;
    xoff2: Single;
    yoff2: Single;
  end;

  stbtt_pack_range = record
    font_size: Single;
    first_unicode_codepoint_in_range: Integer;
    array_of_unicode_codepoints: PInteger;
    num_chars: Integer;
    chardata_for_range: Pstbtt_packedchar;
    h_oversample: Byte;
    v_oversample: Byte;
  end;

  stbtt_pack_context = record
    user_allocator_context: Pointer;
    pack_info: Pointer;
    width: Integer;
    height: Integer;
    stride_in_bytes: Integer;
    padding: Integer;
    skip_missing: Integer;
    h_oversample: Cardinal;
    v_oversample: Cardinal;
    pixels: PByte;
    nodes: Pointer;
  end;

  stbtt_fontinfo = record
    userdata: Pointer;
    data: PByte;
    fontstart: Integer;
    numGlyphs: Integer;
    loca: Integer;
    head: Integer;
    glyf: Integer;
    hhea: Integer;
    hmtx: Integer;
    kern: Integer;
    gpos: Integer;
    svg: Integer;
    index_map: Integer;
    indexToLocFormat: Integer;
    cff: stbtt__buf;
    charstrings: stbtt__buf;
    gsubrs: stbtt__buf;
    subrs: stbtt__buf;
    fontdicts: stbtt__buf;
    fdselect: stbtt__buf;
  end;

  stbtt_kerningentry = record
    glyph1: Integer;
    glyph2: Integer;
    advance: Integer;
  end;

  stbtt_vertex = record
    x: Smallint;
    y: Smallint;
    cx: Smallint;
    cy: Smallint;
    cx1: Smallint;
    cy1: Smallint;
    &type: Byte;
    padding: Byte;
  end;

  stbtt__bitmap = record
    w: Integer;
    h: Integer;
    stride: Integer;
    pixels: PByte;
  end;

  ImU64 = UInt64;
  PImU64 = ^ImU64;
  PImGuiDockRequest = Pointer;
  PPImGuiDockRequest = ^PImGuiDockRequest;
  PImGuiDockNodeSettings = Pointer;
  PPImGuiDockNodeSettings = ^PImGuiDockNodeSettings;
  PImGuiInputTextDeactivateData = Pointer;
  PPImGuiInputTextDeactivateData = ^PImGuiInputTextDeactivateData;
  PImGuiTableColumnsSettings = Pointer;
  PPImGuiTableColumnsSettings = ^PImGuiTableColumnsSettings;
  PSTB_TexteditState = Pointer;
  PPSTB_TexteditState = ^PSTB_TexteditState;

  ImVector_const_charPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPUTF8Char;
  end;

  ImGuiID = Cardinal;
  PImGuiID = ^ImGuiID;
  ImS8 = UTF8Char;
  ImU8 = Byte;
  PImU8 = ^ImU8;
  ImS16 = Smallint;
  ImU16 = Word;
  PImU16 = ^ImU16;
  ImS32 = Integer;
  ImU32 = Cardinal;
  PImU32 = ^ImU32;
  ImS64 = Int64;
  PImS64 = ^ImS64;
  ImGuiCol = Integer;
  ImGuiCond = Integer;
  ImGuiDataType = Integer;
  ImGuiMouseButton = Integer;
  ImGuiMouseCursor = Integer;
  ImGuiStyleVar = Integer;
  ImGuiTableBgTarget = Integer;
  ImDrawFlags = Integer;
  ImDrawListFlags = Integer;
  ImFontAtlasFlags = Integer;
  ImGuiBackendFlags = Integer;
  ImGuiButtonFlags = Integer;
  PImGuiButtonFlags = ^ImGuiButtonFlags;
  ImGuiChildFlags = Integer;
  ImGuiColorEditFlags = Integer;
  ImGuiConfigFlags = Integer;
  ImGuiComboFlags = Integer;
  ImGuiDockNodeFlags = Integer;
  ImGuiDragDropFlags = Integer;
  ImGuiFocusedFlags = Integer;
  ImGuiHoveredFlags = Integer;
  ImGuiInputFlags = Integer;
  ImGuiInputTextFlags = Integer;
  ImGuiItemFlags = Integer;
  PImGuiItemFlags = ^ImGuiItemFlags;
  ImGuiKeyChord = Integer;
  ImGuiPopupFlags = Integer;
  ImGuiMultiSelectFlags = Integer;
  ImGuiSelectableFlags = Integer;
  ImGuiSliderFlags = Integer;
  ImGuiTabBarFlags = Integer;
  ImGuiTabItemFlags = Integer;
  ImGuiTableFlags = Integer;
  ImGuiTableColumnFlags = Integer;
  ImGuiTableRowFlags = Integer;
  ImGuiTreeNodeFlags = Integer;
  ImGuiViewportFlags = Integer;
  ImGuiWindowFlags = Integer;
  ImWchar32 = Cardinal;
  ImWchar16 = Word;
  ImWchar = ImWchar16;
  PImWchar = ^ImWchar;
  ImGuiSelectionUserData = ImS64;

  ImGuiInputTextCallback = function(data: PImGuiInputTextCallbackData): Integer; cdecl;

  ImGuiSizeCallback = procedure(data: PImGuiSizeCallbackData); cdecl;

  ImGuiMemAllocFunc = function(sz: NativeUInt; user_data: Pointer): Pointer; cdecl;
  PImGuiMemAllocFunc = ^ImGuiMemAllocFunc;

  ImGuiMemFreeFunc = procedure(ptr: Pointer; user_data: Pointer); cdecl;
  PImGuiMemFreeFunc = ^ImGuiMemFreeFunc;

  ImVec2 = record
    x: Single;
    y: Single;
  end;

  ImVec4 = record
    x: Single;
    y: Single;
    z: Single;
    w: Single;
  end;

  ImTextureID = ImU64;
  PImTextureID = ^ImTextureID;

  ImGuiTableSortSpecs = record
    Specs: PImGuiTableColumnSortSpecs;
    SpecsCount: Integer;
    SpecsDirty: Boolean;
  end;

  ImGuiTableColumnSortSpecs = record
    ColumnUserID: ImGuiID;
    ColumnIndex: ImS16;
    SortOrder: ImS16;
    SortDirection: ImGuiSortDirection;
  end;

  ImGuiStyle = record
    Alpha: Single;
    DisabledAlpha: Single;
    WindowPadding: ImVec2;
    WindowRounding: Single;
    WindowBorderSize: Single;
    WindowBorderHoverPadding: Single;
    WindowMinSize: ImVec2;
    WindowTitleAlign: ImVec2;
    WindowMenuButtonPosition: ImGuiDir;
    ChildRounding: Single;
    ChildBorderSize: Single;
    PopupRounding: Single;
    PopupBorderSize: Single;
    FramePadding: ImVec2;
    FrameRounding: Single;
    FrameBorderSize: Single;
    ItemSpacing: ImVec2;
    ItemInnerSpacing: ImVec2;
    CellPadding: ImVec2;
    TouchExtraPadding: ImVec2;
    IndentSpacing: Single;
    ColumnsMinSpacing: Single;
    ScrollbarSize: Single;
    ScrollbarRounding: Single;
    GrabMinSize: Single;
    GrabRounding: Single;
    LogSliderDeadzone: Single;
    ImageBorderSize: Single;
    TabRounding: Single;
    TabBorderSize: Single;
    TabCloseButtonMinWidthSelected: Single;
    TabCloseButtonMinWidthUnselected: Single;
    TabBarBorderSize: Single;
    TabBarOverlineSize: Single;
    TableAngledHeadersAngle: Single;
    TableAngledHeadersTextAlign: ImVec2;
    ColorButtonPosition: ImGuiDir;
    ButtonTextAlign: ImVec2;
    SelectableTextAlign: ImVec2;
    SeparatorTextBorderSize: Single;
    SeparatorTextAlign: ImVec2;
    SeparatorTextPadding: ImVec2;
    DisplayWindowPadding: ImVec2;
    DisplaySafeAreaPadding: ImVec2;
    DockingSeparatorSize: Single;
    MouseCursorScale: Single;
    AntiAliasedLines: Boolean;
    AntiAliasedLinesUseTex: Boolean;
    AntiAliasedFill: Boolean;
    CurveTessellationTol: Single;
    CircleTessellationMaxError: Single;
    Colors: array [0..57] of ImVec4;
    HoverStationaryDelay: Single;
    HoverDelayShort: Single;
    HoverDelayNormal: Single;
    HoverFlagsForTooltipMouse: ImGuiHoveredFlags;
    HoverFlagsForTooltipNav: ImGuiHoveredFlags;
  end;

  ImGuiKeyData = record
    Down: Boolean;
    DownDuration: Single;
    DownDurationPrev: Single;
    AnalogValue: Single;
  end;

  ImVector_ImWchar = record
    Size: Integer;
    Capacity: Integer;
    Data: PImWchar;
  end;

  ImGuiIO = record
    ConfigFlags: ImGuiConfigFlags;
    BackendFlags: ImGuiBackendFlags;
    DisplaySize: ImVec2;
    DeltaTime: Single;
    IniSavingRate: Single;
    IniFilename: PUTF8Char;
    LogFilename: PUTF8Char;
    UserData: Pointer;
    Fonts: PImFontAtlas;
    FontGlobalScale: Single;
    FontAllowUserScaling: Boolean;
    FontDefault: PImFont;
    DisplayFramebufferScale: ImVec2;
    ConfigNavSwapGamepadButtons: Boolean;
    ConfigNavMoveSetMousePos: Boolean;
    ConfigNavCaptureKeyboard: Boolean;
    ConfigNavEscapeClearFocusItem: Boolean;
    ConfigNavEscapeClearFocusWindow: Boolean;
    ConfigNavCursorVisibleAuto: Boolean;
    ConfigNavCursorVisibleAlways: Boolean;
    ConfigDockingNoSplit: Boolean;
    ConfigDockingWithShift: Boolean;
    ConfigDockingAlwaysTabBar: Boolean;
    ConfigDockingTransparentPayload: Boolean;
    ConfigViewportsNoAutoMerge: Boolean;
    ConfigViewportsNoTaskBarIcon: Boolean;
    ConfigViewportsNoDecoration: Boolean;
    ConfigViewportsNoDefaultParent: Boolean;
    MouseDrawCursor: Boolean;
    ConfigMacOSXBehaviors: Boolean;
    ConfigInputTrickleEventQueue: Boolean;
    ConfigInputTextCursorBlink: Boolean;
    ConfigInputTextEnterKeepActive: Boolean;
    ConfigDragClickToInputText: Boolean;
    ConfigWindowsResizeFromEdges: Boolean;
    ConfigWindowsMoveFromTitleBarOnly: Boolean;
    ConfigWindowsCopyContentsWithCtrlC: Boolean;
    ConfigScrollbarScrollByPage: Boolean;
    ConfigMemoryCompactTimer: Single;
    MouseDoubleClickTime: Single;
    MouseDoubleClickMaxDist: Single;
    MouseDragThreshold: Single;
    KeyRepeatDelay: Single;
    KeyRepeatRate: Single;
    ConfigErrorRecovery: Boolean;
    ConfigErrorRecoveryEnableAssert: Boolean;
    ConfigErrorRecoveryEnableDebugLog: Boolean;
    ConfigErrorRecoveryEnableTooltip: Boolean;
    ConfigDebugIsDebuggerPresent: Boolean;
    ConfigDebugHighlightIdConflicts: Boolean;
    ConfigDebugHighlightIdConflictsShowItemPicker: Boolean;
    ConfigDebugBeginReturnValueOnce: Boolean;
    ConfigDebugBeginReturnValueLoop: Boolean;
    ConfigDebugIgnoreFocusLoss: Boolean;
    ConfigDebugIniSettings: Boolean;
    BackendPlatformName: PUTF8Char;
    BackendRendererName: PUTF8Char;
    BackendPlatformUserData: Pointer;
    BackendRendererUserData: Pointer;
    BackendLanguageUserData: Pointer;
    WantCaptureMouse: Boolean;
    WantCaptureKeyboard: Boolean;
    WantTextInput: Boolean;
    WantSetMousePos: Boolean;
    WantSaveIniSettings: Boolean;
    NavActive: Boolean;
    NavVisible: Boolean;
    Framerate: Single;
    MetricsRenderVertices: Integer;
    MetricsRenderIndices: Integer;
    MetricsRenderWindows: Integer;
    MetricsActiveWindows: Integer;
    MouseDelta: ImVec2;
    Ctx: PImGuiContext;
    MousePos: ImVec2;
    MouseDown: array [0..4] of Boolean;
    MouseWheel: Single;
    MouseWheelH: Single;
    MouseSource: ImGuiMouseSource;
    MouseHoveredViewport: ImGuiID;
    KeyCtrl: Boolean;
    KeyShift: Boolean;
    KeyAlt: Boolean;
    KeySuper: Boolean;
    KeyMods: ImGuiKeyChord;
    KeysData: array [0..154] of ImGuiKeyData;
    WantCaptureMouseUnlessPopupClose: Boolean;
    MousePosPrev: ImVec2;
    MouseClickedPos: array [0..4] of ImVec2;
    MouseClickedTime: array [0..4] of Double;
    MouseClicked: array [0..4] of Boolean;
    MouseDoubleClicked: array [0..4] of Boolean;
    MouseClickedCount: array [0..4] of ImU16;
    MouseClickedLastCount: array [0..4] of ImU16;
    MouseReleased: array [0..4] of Boolean;
    MouseReleasedTime: array [0..4] of Double;
    MouseDownOwned: array [0..4] of Boolean;
    MouseDownOwnedUnlessPopupClose: array [0..4] of Boolean;
    MouseWheelRequestAxisSwap: Boolean;
    MouseCtrlLeftAsRightClick: Boolean;
    MouseDownDuration: array [0..4] of Single;
    MouseDownDurationPrev: array [0..4] of Single;
    MouseDragMaxDistanceAbs: array [0..4] of ImVec2;
    MouseDragMaxDistanceSqr: array [0..4] of Single;
    PenPressure: Single;
    AppFocusLost: Boolean;
    AppAcceptingEvents: Boolean;
    InputQueueSurrogate: ImWchar16;
    InputQueueCharacters: ImVector_ImWchar;
  end;

  ImGuiInputTextCallbackData = record
    Ctx: PImGuiContext;
    EventFlag: ImGuiInputTextFlags;
    Flags: ImGuiInputTextFlags;
    UserData: Pointer;
    EventChar: ImWchar;
    EventKey: ImGuiKey;
    Buf: PUTF8Char;
    BufTextLen: Integer;
    BufSize: Integer;
    BufDirty: Boolean;
    CursorPos: Integer;
    SelectionStart: Integer;
    SelectionEnd: Integer;
  end;

  ImGuiSizeCallbackData = record
    UserData: Pointer;
    Pos: ImVec2;
    CurrentSize: ImVec2;
    DesiredSize: ImVec2;
  end;

  ImGuiWindowClass = record
    ClassId: ImGuiID;
    ParentViewportId: ImGuiID;
    FocusRouteParentWindowId: ImGuiID;
    ViewportFlagsOverrideSet: ImGuiViewportFlags;
    ViewportFlagsOverrideClear: ImGuiViewportFlags;
    TabItemFlagsOverrideSet: ImGuiTabItemFlags;
    DockNodeFlagsOverrideSet: ImGuiDockNodeFlags;
    DockingAlwaysTabBar: Boolean;
    DockingAllowUnclassed: Boolean;
  end;

  ImGuiPayload = record
    Data: Pointer;
    DataSize: Integer;
    SourceId: ImGuiID;
    SourceParentId: ImGuiID;
    DataFrameCount: Integer;
    DataType: array [0..32] of UTF8Char;
    Preview: Boolean;
    Delivery: Boolean;
  end;

  ImGuiOnceUponAFrame = record
    RefFrame: Integer;
  end;

  ImGuiTextRange = record
    b: PUTF8Char;
    e: PUTF8Char;
  end;

  ImVector_ImGuiTextRange = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTextRange;
  end;

  ImGuiTextFilter = record
    InputBuf: array [0..255] of UTF8Char;
    Filters: ImVector_ImGuiTextRange;
    CountGrep: Integer;
  end;

  ImVector_char = record
    Size: Integer;
    Capacity: Integer;
    Data: PUTF8Char;
  end;

  ImGuiTextBuffer = record
    Buf: ImVector_char;
  end;

  P_anonymous_type_89 = ^_anonymous_type_89;
  _anonymous_type_89 = record
    case Integer of
      0: (val_i: Integer);
      1: (val_f: Single);
      2: (val_p: Pointer);
  end;

  ImGuiStoragePair = record
    key: ImGuiID;
    f2: _anonymous_type_89;
  end;

  ImVector_ImGuiStoragePair = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiStoragePair;
  end;

  ImGuiStorage = record
    Data: ImVector_ImGuiStoragePair;
  end;

  ImGuiListClipper = record
    Ctx: PImGuiContext;
    DisplayStart: Integer;
    DisplayEnd: Integer;
    ItemsCount: Integer;
    ItemsHeight: Single;
    StartPosY: Single;
    StartSeekOffsetY: Double;
    TempData: Pointer;
  end;

  ImColor = record
    Value: ImVec4;
  end;

  ImVector_ImGuiSelectionRequest = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiSelectionRequest;
  end;

  ImGuiMultiSelectIO = record
    Requests: ImVector_ImGuiSelectionRequest;
    RangeSrcItem: ImGuiSelectionUserData;
    NavIdItem: ImGuiSelectionUserData;
    NavIdSelected: Boolean;
    RangeSrcReset: Boolean;
    ItemsCount: Integer;
  end;

  ImGuiSelectionRequest = record
    &Type: ImGuiSelectionRequestType;
    Selected: Boolean;
    RangeDirection: ImS8;
    RangeFirstItem: ImGuiSelectionUserData;
    RangeLastItem: ImGuiSelectionUserData;
  end;

  ImGuiSelectionBasicStorage = record
    Size: Integer;
    PreserveOrder: Boolean;
    UserData: Pointer;
    AdapterIndexToStorageId: function(self: PImGuiSelectionBasicStorage; idx: Integer): ImGuiID; cdecl;
    _SelectionOrder: Integer;
    _Storage: ImGuiStorage;
  end;

  ImGuiSelectionExternalStorage = record
    UserData: Pointer;
    AdapterSetItemSelected: procedure(self: PImGuiSelectionExternalStorage; idx: Integer; selected: Boolean); cdecl;
  end;

  ImDrawIdx = Word;
  PImDrawIdx = ^ImDrawIdx;

  ImDrawCallback = procedure(const parent_list: PImDrawList; const cmd: PImDrawCmd); cdecl;

  ImDrawCmd = record
    ClipRect: ImVec4;
    TextureId: ImTextureID;
    VtxOffset: Cardinal;
    IdxOffset: Cardinal;
    ElemCount: Cardinal;
    UserCallback: ImDrawCallback;
    UserCallbackData: Pointer;
    UserCallbackDataSize: Integer;
    UserCallbackDataOffset: Integer;
  end;

  ImDrawVert = record
    pos: ImVec2;
    uv: ImVec2;
    col: ImU32;
  end;

  ImDrawCmdHeader = record
    ClipRect: ImVec4;
    TextureId: ImTextureID;
    VtxOffset: Cardinal;
  end;

  ImVector_ImDrawCmd = record
    Size: Integer;
    Capacity: Integer;
    Data: PImDrawCmd;
  end;

  ImVector_ImDrawIdx = record
    Size: Integer;
    Capacity: Integer;
    Data: PImDrawIdx;
  end;

  ImDrawChannel = record
    _CmdBuffer: ImVector_ImDrawCmd;
    _IdxBuffer: ImVector_ImDrawIdx;
  end;

  ImVector_ImDrawChannel = record
    Size: Integer;
    Capacity: Integer;
    Data: PImDrawChannel;
  end;

  ImDrawListSplitter = record
    _Current: Integer;
    _Count: Integer;
    _Channels: ImVector_ImDrawChannel;
  end;

  ImVector_ImDrawVert = record
    Size: Integer;
    Capacity: Integer;
    Data: PImDrawVert;
  end;

  ImVector_ImVec2 = record
    Size: Integer;
    Capacity: Integer;
    Data: PImVec2;
  end;

  ImVector_ImVec4 = record
    Size: Integer;
    Capacity: Integer;
    Data: PImVec4;
  end;

  ImVector_ImTextureID = record
    Size: Integer;
    Capacity: Integer;
    Data: PImTextureID;
  end;

  ImVector_ImU8 = record
    Size: Integer;
    Capacity: Integer;
    Data: PImU8;
  end;

  ImDrawList = record
    CmdBuffer: ImVector_ImDrawCmd;
    IdxBuffer: ImVector_ImDrawIdx;
    VtxBuffer: ImVector_ImDrawVert;
    Flags: ImDrawListFlags;
    _VtxCurrentIdx: Cardinal;
    _Data: PImDrawListSharedData;
    _VtxWritePtr: PImDrawVert;
    _IdxWritePtr: PImDrawIdx;
    _Path: ImVector_ImVec2;
    _CmdHeader: ImDrawCmdHeader;
    _Splitter: ImDrawListSplitter;
    _ClipRectStack: ImVector_ImVec4;
    _TextureIdStack: ImVector_ImTextureID;
    _CallbacksDataBuf: ImVector_ImU8;
    _FringeScale: Single;
    _OwnerName: PUTF8Char;
  end;

  ImVector_ImDrawListPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPImDrawList;
  end;

  ImDrawData = record
    Valid: Boolean;
    CmdListsCount: Integer;
    TotalIdxCount: Integer;
    TotalVtxCount: Integer;
    CmdLists: ImVector_ImDrawListPtr;
    DisplayPos: ImVec2;
    DisplaySize: ImVec2;
    FramebufferScale: ImVec2;
    OwnerViewport: PImGuiViewport;
  end;

  ImFontConfig = record
    FontData: Pointer;
    FontDataSize: Integer;
    FontDataOwnedByAtlas: Boolean;
    MergeMode: Boolean;
    PixelSnapH: Boolean;
    FontNo: Integer;
    OversampleH: Integer;
    OversampleV: Integer;
    SizePixels: Single;
    GlyphOffset: ImVec2;
    GlyphRanges: PImWchar;
    GlyphMinAdvanceX: Single;
    GlyphMaxAdvanceX: Single;
    GlyphExtraAdvanceX: Single;
    FontBuilderFlags: Cardinal;
    RasterizerMultiply: Single;
    RasterizerDensity: Single;
    EllipsisChar: ImWchar;
    Name: array [0..39] of UTF8Char;
    DstFont: PImFont;
  end;

  ImFontGlyph = record
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property Colored: Cardinal index $0001 read GetData0Value write SetData0Value; // 1 bits at offset 0 in Data0
    property Visible: Cardinal index $0101 read GetData0Value write SetData0Value; // 1 bits at offset 1 in Data0
    property Codepoint: Cardinal index $021E read GetData0Value write SetData0Value; // 30 bits at offset 2 in Data0
  var
    AdvanceX: Single;
    X0: Single;
    Y0: Single;
    X1: Single;
    Y1: Single;
    U0: Single;
    V0: Single;
    U1: Single;
    V1: Single;
  end;

  ImVector_ImU32 = record
    Size: Integer;
    Capacity: Integer;
    Data: PImU32;
  end;

  ImFontGlyphRangesBuilder = record
    UsedChars: ImVector_ImU32;
  end;

  ImFontAtlasCustomRect = record
    X: Word;
    Y: Word;
    Width: Word;
    Height: Word;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property GlyphID: Cardinal index $001F read GetData0Value write SetData0Value; // 31 bits at offset 0 in Data0
    property GlyphColored: Cardinal index $1F01 read GetData0Value write SetData0Value; // 1 bits at offset 31 in Data0
  var
    GlyphAdvanceX: Single;
    GlyphOffset: ImVec2;
    Font: PImFont;
  end;

  ImVector_ImFontPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPImFont;
  end;

  ImVector_ImFontAtlasCustomRect = record
    Size: Integer;
    Capacity: Integer;
    Data: PImFontAtlasCustomRect;
  end;

  ImVector_ImFontConfig = record
    Size: Integer;
    Capacity: Integer;
    Data: PImFontConfig;
  end;

  ImFontAtlas = record
    Flags: ImFontAtlasFlags;
    TexID: ImTextureID;
    TexDesiredWidth: Integer;
    TexGlyphPadding: Integer;
    UserData: Pointer;
    Locked: Boolean;
    TexReady: Boolean;
    TexPixelsUseColors: Boolean;
    TexPixelsAlpha8: PByte;
    TexPixelsRGBA32: PCardinal;
    TexWidth: Integer;
    TexHeight: Integer;
    TexUvScale: ImVec2;
    TexUvWhitePixel: ImVec2;
    Fonts: ImVector_ImFontPtr;
    CustomRects: ImVector_ImFontAtlasCustomRect;
    Sources: ImVector_ImFontConfig;
    TexUvLines: array [0..32] of ImVec4;
    FontBuilderIO: PImFontBuilderIO;
    FontBuilderFlags: Cardinal;
    PackIdMouseCursors: Integer;
    PackIdLines: Integer;
  end;

  ImVector_float = record
    Size: Integer;
    Capacity: Integer;
    Data: PSingle;
  end;

  ImVector_ImU16 = record
    Size: Integer;
    Capacity: Integer;
    Data: PImU16;
  end;

  ImVector_ImFontGlyph = record
    Size: Integer;
    Capacity: Integer;
    Data: PImFontGlyph;
  end;

  ImFont = record
    IndexAdvanceX: ImVector_float;
    FallbackAdvanceX: Single;
    FontSize: Single;
    IndexLookup: ImVector_ImU16;
    Glyphs: ImVector_ImFontGlyph;
    FallbackGlyph: PImFontGlyph;
    ContainerAtlas: PImFontAtlas;
    Sources: PImFontConfig;
    SourcesCount: Smallint;
    EllipsisCharCount: Smallint;
    EllipsisChar: ImWchar;
    FallbackChar: ImWchar;
    EllipsisWidth: Single;
    EllipsisCharStep: Single;
    Scale: Single;
    Ascent: Single;
    Descent: Single;
    MetricsTotalSurface: Integer;
    DirtyLookupTables: Boolean;
    Used8kPagesMap: array [0..0] of ImU8;
  end;

  ImGuiViewport = record
    ID: ImGuiID;
    Flags: ImGuiViewportFlags;
    Pos: ImVec2;
    Size: ImVec2;
    WorkPos: ImVec2;
    WorkSize: ImVec2;
    DpiScale: Single;
    ParentViewportId: ImGuiID;
    DrawData: PImDrawData;
    RendererUserData: Pointer;
    PlatformUserData: Pointer;
    PlatformHandle: Pointer;
    PlatformHandleRaw: Pointer;
    PlatformWindowCreated: Boolean;
    PlatformRequestMove: Boolean;
    PlatformRequestResize: Boolean;
    PlatformRequestClose: Boolean;
  end;

  ImVector_ImGuiPlatformMonitor = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiPlatformMonitor;
  end;

  ImVector_ImGuiViewportPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPImGuiViewport;
  end;

  ImGuiPlatformIO = record
    Platform_GetClipboardTextFn: function(ctx: PImGuiContext): PUTF8Char; cdecl;
    Platform_SetClipboardTextFn: procedure(ctx: PImGuiContext; const text: PUTF8Char); cdecl;
    Platform_ClipboardUserData: Pointer;
    Platform_OpenInShellFn: function(ctx: PImGuiContext; const path: PUTF8Char): Boolean; cdecl;
    Platform_OpenInShellUserData: Pointer;
    Platform_SetImeDataFn: procedure(ctx: PImGuiContext; viewport: PImGuiViewport; data: PImGuiPlatformImeData); cdecl;
    Platform_ImeUserData: Pointer;
    Platform_LocaleDecimalPoint: ImWchar;
    Renderer_RenderState: Pointer;
    Platform_CreateWindow: procedure(vp: PImGuiViewport); cdecl;
    Platform_DestroyWindow: procedure(vp: PImGuiViewport); cdecl;
    Platform_ShowWindow: procedure(vp: PImGuiViewport); cdecl;
    Platform_SetWindowPos: procedure(vp: PImGuiViewport; pos: ImVec2); cdecl;
    Platform_GetWindowPos: function(vp: PImGuiViewport): ImVec2; cdecl;
    Platform_SetWindowSize: procedure(vp: PImGuiViewport; size: ImVec2); cdecl;
    Platform_GetWindowSize: function(vp: PImGuiViewport): ImVec2; cdecl;
    Platform_SetWindowFocus: procedure(vp: PImGuiViewport); cdecl;
    Platform_GetWindowFocus: function(vp: PImGuiViewport): Boolean; cdecl;
    Platform_GetWindowMinimized: function(vp: PImGuiViewport): Boolean; cdecl;
    Platform_SetWindowTitle: procedure(vp: PImGuiViewport; const str: PUTF8Char); cdecl;
    Platform_SetWindowAlpha: procedure(vp: PImGuiViewport; alpha: Single); cdecl;
    Platform_UpdateWindow: procedure(vp: PImGuiViewport); cdecl;
    Platform_RenderWindow: procedure(vp: PImGuiViewport; render_arg: Pointer); cdecl;
    Platform_SwapBuffers: procedure(vp: PImGuiViewport; render_arg: Pointer); cdecl;
    Platform_GetWindowDpiScale: function(vp: PImGuiViewport): Single; cdecl;
    Platform_OnChangedViewport: procedure(vp: PImGuiViewport); cdecl;
    Platform_GetWindowWorkAreaInsets: function(vp: PImGuiViewport): ImVec4; cdecl;
    Platform_CreateVkSurface: function(vp: PImGuiViewport; vk_inst: ImU64; const vk_allocators: Pointer; out_vk_surface: PImU64): Integer; cdecl;
    Renderer_CreateWindow: procedure(vp: PImGuiViewport); cdecl;
    Renderer_DestroyWindow: procedure(vp: PImGuiViewport); cdecl;
    Renderer_SetWindowSize: procedure(vp: PImGuiViewport; size: ImVec2); cdecl;
    Renderer_RenderWindow: procedure(vp: PImGuiViewport; render_arg: Pointer); cdecl;
    Renderer_SwapBuffers: procedure(vp: PImGuiViewport; render_arg: Pointer); cdecl;
    Monitors: ImVector_ImGuiPlatformMonitor;
    Viewports: ImVector_ImGuiViewportPtr;
  end;

  ImGuiPlatformMonitor = record
    MainPos: ImVec2;
    MainSize: ImVec2;
    WorkPos: ImVec2;
    WorkSize: ImVec2;
    DpiScale: Single;
    PlatformHandle: Pointer;
  end;

  ImGuiPlatformImeData = record
    WantVisible: Boolean;
    InputPos: ImVec2;
    InputLineHeight: Single;
  end;

  ImGuiDataAuthority = Integer;
  ImGuiLayoutType = Integer;
  ImGuiActivateFlags = Integer;
  ImGuiDebugLogFlags = Integer;
  ImGuiFocusRequestFlags = Integer;
  ImGuiItemStatusFlags = Integer;
  ImGuiOldColumnFlags = Integer;
  ImGuiLogFlags = Integer;
  ImGuiNavRenderCursorFlags = Integer;
  ImGuiNavMoveFlags = Integer;
  ImGuiNextItemDataFlags = Integer;
  ImGuiNextWindowDataFlags = Integer;
  ImGuiScrollFlags = Integer;
  ImGuiSeparatorFlags = Integer;
  ImGuiTextFlags = Integer;
  ImGuiTooltipFlags = Integer;
  ImGuiTypingSelectFlags = Integer;
  ImGuiWindowRefreshFlags = Integer;
  ImFileHandle = PPointer;

  ImVec1 = record
    x: Single;
  end;

  ImVec2ih = record
    x: Smallint;
    y: Smallint;
  end;

  ImRect = record
    Min: ImVec2;
    Max: ImVec2;
  end;

  ImBitArrayPtr = PImU32;

  ImBitVector = record
    Storage: ImVector_ImU32;
  end;

  ImPoolIdx = Integer;

  ImVector_int = record
    Size: Integer;
    Capacity: Integer;
    Data: PInteger;
  end;

  ImGuiTextIndex = record
    LineOffsets: ImVector_int;
    EndOffset: Integer;
  end;

  ImDrawListSharedData = record
    TexUvWhitePixel: ImVec2;
    TexUvLines: PImVec4;
    Font: PImFont;
    FontSize: Single;
    FontScale: Single;
    CurveTessellationTol: Single;
    CircleSegmentMaxError: Single;
    InitialFringeScale: Single;
    InitialFlags: ImDrawListFlags;
    ClipRectFullscreen: ImVec4;
    TempBuffer: ImVector_ImVec2;
    ArcFastVtx: array [0..47] of ImVec2;
    ArcFastRadiusCutoff: Single;
    CircleSegmentCounts: array [0..63] of ImU8;
  end;

  ImDrawDataBuilder = record
    Layers: array [0..1] of PImVector_ImDrawListPtr;
    LayerData1: ImVector_ImDrawListPtr;
  end;

  ImGuiStyleVarInfo = record
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property Count: Cardinal index $0008 read GetData0Value write SetData0Value; // 8 bits at offset 0 in Data0
    property DataType: Cardinal index $0808 read GetData0Value write SetData0Value; // 8 bits at offset 8 in Data0
    property Offset: Cardinal index $1010 read GetData0Value write SetData0Value; // 16 bits at offset 16 in Data0
  end;

  ImGuiColorMod = record
    Col: ImGuiCol;
    BackupValue: ImVec4;
  end;

  P_anonymous_type_90 = ^_anonymous_type_90;
  _anonymous_type_90 = record
    case Integer of
      0: (BackupInt: array [0..1] of Integer);
      1: (BackupFloat: array [0..1] of Single);
  end;

  ImGuiStyleMod = record
    VarIdx: ImGuiStyleVar;
    f2: _anonymous_type_90;
  end;

  ImGuiDataTypeStorage = record
    Data: array [0..7] of ImU8;
  end;

  ImGuiDataTypeInfo = record
    Size: NativeUInt;
    Name: PUTF8Char;
    PrintFmt: PUTF8Char;
    ScanFmt: PUTF8Char;
  end;

  ImGuiComboPreviewData = record
    PreviewRect: ImRect;
    BackupCursorPos: ImVec2;
    BackupCursorMaxPos: ImVec2;
    BackupCursorPosPrevLine: ImVec2;
    BackupPrevLineTextBaseOffset: Single;
    BackupLayout: ImGuiLayoutType;
  end;

  ImGuiGroupData = record
    WindowID: ImGuiID;
    BackupCursorPos: ImVec2;
    BackupCursorMaxPos: ImVec2;
    BackupCursorPosPrevLine: ImVec2;
    BackupIndent: ImVec1;
    BackupGroupOffset: ImVec1;
    BackupCurrLineSize: ImVec2;
    BackupCurrLineTextBaseOffset: Single;
    BackupActiveIdIsAlive: ImGuiID;
    BackupDeactivatedIdIsAlive: Boolean;
    BackupHoveredIdIsAlive: Boolean;
    BackupIsSameLine: Boolean;
    EmitItem: Boolean;
  end;

  ImGuiMenuColumns = record
    TotalWidth: ImU32;
    NextTotalWidth: ImU32;
    Spacing: ImU16;
    OffsetIcon: ImU16;
    OffsetLabel: ImU16;
    OffsetShortcut: ImU16;
    OffsetMark: ImU16;
    Widths: array [0..3] of ImU16;
  end;

  ImGuiInputTextDeactivatedState = record
    ID: ImGuiID;
    TextA: ImVector_char;
  end;

  PImStbTexteditState = Pointer;
  PPImStbTexteditState = ^PImStbTexteditState;

  ImGuiInputTextState = record
    Ctx: PImGuiContext;
    Stb: PImStbTexteditState;
    Flags: ImGuiInputTextFlags;
    ID: ImGuiID;
    TextLen: Integer;
    TextSrc: PUTF8Char;
    TextA: ImVector_char;
    TextToRevertTo: ImVector_char;
    CallbackTextBackup: ImVector_char;
    BufCapacity: Integer;
    Scroll: ImVec2;
    CursorAnim: Single;
    CursorFollow: Boolean;
    SelectedAllMouseLock: Boolean;
    Edited: Boolean;
    WantReloadUserBuf: Boolean;
    ReloadSelectionStart: Integer;
    ReloadSelectionEnd: Integer;
  end;

  ImGuiNextWindowData = record
    HasFlags: ImGuiNextWindowDataFlags;
    PosCond: ImGuiCond;
    SizeCond: ImGuiCond;
    CollapsedCond: ImGuiCond;
    DockCond: ImGuiCond;
    PosVal: ImVec2;
    PosPivotVal: ImVec2;
    SizeVal: ImVec2;
    ContentSizeVal: ImVec2;
    ScrollVal: ImVec2;
    WindowFlags: ImGuiWindowFlags;
    ChildFlags: ImGuiChildFlags;
    PosUndock: Boolean;
    CollapsedVal: Boolean;
    SizeConstraintRect: ImRect;
    SizeCallback: ImGuiSizeCallback;
    SizeCallbackUserData: Pointer;
    BgAlphaVal: Single;
    ViewportId: ImGuiID;
    DockId: ImGuiID;
    WindowClass: ImGuiWindowClass;
    MenuBarOffsetMinVal: ImVec2;
    RefreshFlagsVal: ImGuiWindowRefreshFlags;
  end;

  ImGuiNextItemData = record
    HasFlags: ImGuiNextItemDataFlags;
    ItemFlags: ImGuiItemFlags;
    FocusScopeId: ImGuiID;
    SelectionUserData: ImGuiSelectionUserData;
    Width: Single;
    Shortcut: ImGuiKeyChord;
    ShortcutFlags: ImGuiInputFlags;
    OpenVal: Boolean;
    OpenCond: ImU8;
    RefVal: ImGuiDataTypeStorage;
    StorageId: ImGuiID;
  end;

  ImGuiLastItemData = record
    ID: ImGuiID;
    ItemFlags: ImGuiItemFlags;
    StatusFlags: ImGuiItemStatusFlags;
    Rect: ImRect;
    NavRect: ImRect;
    DisplayRect: ImRect;
    ClipRect: ImRect;
    Shortcut: ImGuiKeyChord;
  end;

  ImGuiTreeNodeStackData = record
    ID: ImGuiID;
    TreeFlags: ImGuiTreeNodeFlags;
    ItemFlags: ImGuiItemFlags;
    NavRect: ImRect;
  end;

  ImGuiErrorRecoveryState = record
    SizeOfWindowStack: Smallint;
    SizeOfIDStack: Smallint;
    SizeOfTreeStack: Smallint;
    SizeOfColorStack: Smallint;
    SizeOfStyleVarStack: Smallint;
    SizeOfFontStack: Smallint;
    SizeOfFocusScopeStack: Smallint;
    SizeOfGroupStack: Smallint;
    SizeOfItemFlagsStack: Smallint;
    SizeOfBeginPopupStack: Smallint;
    SizeOfDisabledStack: Smallint;
  end;

  ImGuiWindowStackData = record
    Window: PImGuiWindow;
    ParentLastItemDataBackup: ImGuiLastItemData;
    StackSizesInBegin: ImGuiErrorRecoveryState;
    DisabledOverrideReenable: Boolean;
    DisabledOverrideReenableAlphaBackup: Single;
  end;

  ImGuiShrinkWidthItem = record
    Index: Integer;
    Width: Single;
    InitialWidth: Single;
  end;

  ImGuiPtrOrIndex = record
    Ptr: Pointer;
    Index: Integer;
  end;

  ImGuiDeactivatedItemData = record
    ID: ImGuiID;
    ElapseFrame: Integer;
    HasBeenEditedBefore: Boolean;
    IsAlive: Boolean;
  end;

  ImGuiPopupData = record
    PopupId: ImGuiID;
    Window: PImGuiWindow;
    RestoreNavWindow: PImGuiWindow;
    ParentNavLayer: Integer;
    OpenFrameCount: Integer;
    OpenParentId: ImGuiID;
    OpenPopupPos: ImVec2;
    OpenMousePos: ImVec2;
  end;

  ImBitArray_ImGuiKey_NamedKey_COUNT__lessImGuiKey_NamedKey_BEGIN = record
    Storage: array [0..4] of ImU32;
  end;

  ImBitArrayForNamedKeys = ImBitArray_ImGuiKey_NamedKey_COUNT__lessImGuiKey_NamedKey_BEGIN;

  ImGuiInputEventMousePos = record
    PosX: Single;
    PosY: Single;
    MouseSource: ImGuiMouseSource;
  end;

  ImGuiInputEventMouseWheel = record
    WheelX: Single;
    WheelY: Single;
    MouseSource: ImGuiMouseSource;
  end;

  ImGuiInputEventMouseButton = record
    Button: Integer;
    Down: Boolean;
    MouseSource: ImGuiMouseSource;
  end;

  ImGuiInputEventMouseViewport = record
    HoveredViewportID: ImGuiID;
  end;

  ImGuiInputEventKey = record
    Key: ImGuiKey;
    Down: Boolean;
    AnalogValue: Single;
  end;

  ImGuiInputEventText = record
    Char: Cardinal;
  end;

  ImGuiInputEventAppFocused = record
    Focused: Boolean;
  end;

  P_anonymous_type_91 = ^_anonymous_type_91;
  _anonymous_type_91 = record
    case Integer of
      0: (MousePos: ImGuiInputEventMousePos);
      1: (MouseWheel: ImGuiInputEventMouseWheel);
      2: (MouseButton: ImGuiInputEventMouseButton);
      3: (MouseViewport: ImGuiInputEventMouseViewport);
      4: (Key: ImGuiInputEventKey);
      5: (Text: ImGuiInputEventText);
      6: (AppFocused: ImGuiInputEventAppFocused);
  end;

  ImGuiInputEvent = record
    &Type: ImGuiInputEventType;
    Source: ImGuiInputSource;
    EventId: ImU32;
    f4: _anonymous_type_91;
    AddedByTestEngine: Boolean;
  end;

  ImGuiKeyRoutingIndex = ImS16;

  ImGuiKeyRoutingData = record
    NextEntryIndex: ImGuiKeyRoutingIndex;
    Mods: ImU16;
    RoutingCurrScore: ImU8;
    RoutingNextScore: ImU8;
    RoutingCurr: ImGuiID;
    RoutingNext: ImGuiID;
  end;

  ImVector_ImGuiKeyRoutingData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiKeyRoutingData;
  end;

  ImGuiKeyRoutingTable = record
    Index: array [0..154] of ImGuiKeyRoutingIndex;
    Entries: ImVector_ImGuiKeyRoutingData;
    EntriesNext: ImVector_ImGuiKeyRoutingData;
  end;

  ImGuiKeyOwnerData = record
    OwnerCurr: ImGuiID;
    OwnerNext: ImGuiID;
    LockThisFrame: Boolean;
    LockUntilRelease: Boolean;
  end;

  ImGuiListClipperRange = record
    Min: Integer;
    Max: Integer;
    PosToIndexConvert: Boolean;
    PosToIndexOffsetMin: ImS8;
    PosToIndexOffsetMax: ImS8;
  end;

  ImVector_ImGuiListClipperRange = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiListClipperRange;
  end;

  ImGuiListClipperData = record
    ListClipper: PImGuiListClipper;
    LossynessOffset: Single;
    StepNo: Integer;
    ItemsFrozen: Integer;
    Ranges: ImVector_ImGuiListClipperRange;
  end;

  ImGuiNavItemData = record
    Window: PImGuiWindow;
    ID: ImGuiID;
    FocusScopeId: ImGuiID;
    RectRel: ImRect;
    ItemFlags: ImGuiItemFlags;
    DistBox: Single;
    DistCenter: Single;
    DistAxial: Single;
    SelectionUserData: ImGuiSelectionUserData;
  end;

  ImGuiFocusScopeData = record
    ID: ImGuiID;
    WindowID: ImGuiID;
  end;

  ImGuiTypingSelectRequest = record
    Flags: ImGuiTypingSelectFlags;
    SearchBufferLen: Integer;
    SearchBuffer: PUTF8Char;
    SelectRequest: Boolean;
    SingleCharMode: Boolean;
    SingleCharSize: ImS8;
  end;

  ImGuiTypingSelectState = record
    Request: ImGuiTypingSelectRequest;
    SearchBuffer: array [0..63] of UTF8Char;
    FocusScope: ImGuiID;
    LastRequestFrame: Integer;
    LastRequestTime: Single;
    SingleCharModeLock: Boolean;
  end;

  ImGuiOldColumnData = record
    OffsetNorm: Single;
    OffsetNormBeforeResize: Single;
    Flags: ImGuiOldColumnFlags;
    ClipRect: ImRect;
  end;

  ImVector_ImGuiOldColumnData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiOldColumnData;
  end;

  ImGuiOldColumns = record
    ID: ImGuiID;
    Flags: ImGuiOldColumnFlags;
    IsFirstFrame: Boolean;
    IsBeingResized: Boolean;
    Current: Integer;
    Count: Integer;
    OffMinX: Single;
    OffMaxX: Single;
    LineMinY: Single;
    LineMaxY: Single;
    HostCursorPosY: Single;
    HostCursorMaxPosX: Single;
    HostInitialClipRect: ImRect;
    HostBackupClipRect: ImRect;
    HostBackupParentWorkRect: ImRect;
    Columns: ImVector_ImGuiOldColumnData;
    Splitter: ImDrawListSplitter;
  end;

  ImGuiBoxSelectState = record
    ID: ImGuiID;
    IsActive: Boolean;
    IsStarting: Boolean;
    IsStartedFromVoid: Boolean;
    IsStartedSetNavIdOnce: Boolean;
    RequestClear: Boolean;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property KeyMods: Cardinal index $0010 read GetData0Value write SetData0Value; // 16 bits at offset 0 in Data0
  var
    StartPosRel: ImVec2;
    EndPosRel: ImVec2;
    ScrollAccum: ImVec2;
    Window: PImGuiWindow;
    UnclipMode: Boolean;
    UnclipRect: ImRect;
    BoxSelectRectPrev: ImRect;
    BoxSelectRectCurr: ImRect;
  end;

  ImGuiMultiSelectTempData = record
    IO: ImGuiMultiSelectIO;
    Storage: PImGuiMultiSelectState;
    FocusScopeId: ImGuiID;
    Flags: ImGuiMultiSelectFlags;
    ScopeRectMin: ImVec2;
    BackupCursorMaxPos: ImVec2;
    LastSubmittedItem: ImGuiSelectionUserData;
    BoxSelectId: ImGuiID;
    KeyMods: ImGuiKeyChord;
    LoopRequestSetAll: ImS8;
    IsEndIO: Boolean;
    IsFocused: Boolean;
    IsKeyboardSetRange: Boolean;
    NavIdPassedBy: Boolean;
    RangeSrcPassedBy: Boolean;
    RangeDstPassedBy: Boolean;
  end;

  ImGuiMultiSelectState = record
    Window: PImGuiWindow;
    ID: ImGuiID;
    LastFrameActive: Integer;
    LastSelectionSize: Integer;
    RangeSelected: ImS8;
    NavIdSelected: ImS8;
    RangeSrcItem: ImGuiSelectionUserData;
    NavIdItem: ImGuiSelectionUserData;
  end;

  ImVector_ImGuiWindowPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPImGuiWindow;
  end;

  ImGuiDockNode = record
    ID: ImGuiID;
    SharedFlags: ImGuiDockNodeFlags;
    LocalFlags: ImGuiDockNodeFlags;
    LocalFlagsInWindows: ImGuiDockNodeFlags;
    MergedFlags: ImGuiDockNodeFlags;
    State: ImGuiDockNodeState;
    ParentNode: PImGuiDockNode;
    ChildNodes: array [0..1] of PImGuiDockNode;
    Windows: ImVector_ImGuiWindowPtr;
    TabBar: PImGuiTabBar;
    Pos: ImVec2;
    Size: ImVec2;
    SizeRef: ImVec2;
    SplitAxis: ImGuiAxis;
    WindowClass: ImGuiWindowClass;
    LastBgColor: ImU32;
    HostWindow: PImGuiWindow;
    VisibleWindow: PImGuiWindow;
    CentralNode: PImGuiDockNode;
    OnlyNodeWithWindows: PImGuiDockNode;
    CountNodeWithWindows: Integer;
    LastFrameAlive: Integer;
    LastFrameActive: Integer;
    LastFrameFocused: Integer;
    LastFocusedNodeId: ImGuiID;
    SelectedTabId: ImGuiID;
    WantCloseTabId: ImGuiID;
    RefViewportId: ImGuiID;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property AuthorityForPos: Cardinal index $0003 read GetData0Value write SetData0Value; // 3 bits at offset 0 in Data0
    property AuthorityForSize: Cardinal index $0303 read GetData0Value write SetData0Value; // 3 bits at offset 3 in Data0
    property AuthorityForViewport: Cardinal index $0603 read GetData0Value write SetData0Value; // 3 bits at offset 6 in Data0
    property IsVisible: Cardinal index $901 read GetData0Value write SetData0Value; // 1 bits at offset 9 in Data0
    property IsFocused: Cardinal index $A01 read GetData0Value write SetData0Value; // 1 bits at offset 10 in Data0
    property IsBgDrawnThisFrame: Cardinal index $B01 read GetData0Value write SetData0Value; // 1 bits at offset 11 in Data0
    property HasCloseButton: Cardinal index $C01 read GetData0Value write SetData0Value; // 1 bits at offset 12 in Data0
    property HasWindowMenuButton: Cardinal index $D01 read GetData0Value write SetData0Value; // 1 bits at offset 13 in Data0
    property HasCentralNodeChild: Cardinal index $E01 read GetData0Value write SetData0Value; // 1 bits at offset 14 in Data0
    property WantCloseAll: Cardinal index $F01 read GetData0Value write SetData0Value; // 1 bits at offset 15 in Data0
    property WantLockSizeOnce: Cardinal index $1001 read GetData0Value write SetData0Value; // 1 bits at offset 16 in Data0
    property WantMouseMove: Cardinal index $1101 read GetData0Value write SetData0Value; // 1 bits at offset 17 in Data0
    property WantHiddenTabBarUpdate: Cardinal index $1201 read GetData0Value write SetData0Value; // 1 bits at offset 18 in Data0
    property WantHiddenTabBarToggle: Cardinal index $1301 read GetData0Value write SetData0Value; // 1 bits at offset 19 in Data0
  end;

  ImGuiWindowDockStyle = record
    Colors: array [0..7] of ImU32;
  end;

  ImVector_ImGuiDockRequest = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiDockRequest;
  end;

  ImVector_ImGuiDockNodeSettings = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiDockNodeSettings;
  end;

  ImGuiDockContext = record
    Nodes: ImGuiStorage;
    Requests: ImVector_ImGuiDockRequest;
    NodesSettings: ImVector_ImGuiDockNodeSettings;
    WantFullRebuild: Boolean;
  end;

  ImGuiViewportP = record
    _ImGuiViewport: ImGuiViewport;
    Window: PImGuiWindow;
    Idx: Integer;
    LastFrameActive: Integer;
    LastFocusedStampCount: Integer;
    LastNameHash: ImGuiID;
    LastPos: ImVec2;
    LastSize: ImVec2;
    Alpha: Single;
    LastAlpha: Single;
    LastFocusedHadNavWindow: Boolean;
    PlatformMonitor: Smallint;
    BgFgDrawListsLastFrame: array [0..1] of Integer;
    BgFgDrawLists: array [0..1] of PImDrawList;
    DrawDataP: ImDrawData;
    DrawDataBuilder: ImDrawDataBuilder;
    LastPlatformPos: ImVec2;
    LastPlatformSize: ImVec2;
    LastRendererSize: ImVec2;
    WorkInsetMin: ImVec2;
    WorkInsetMax: ImVec2;
    BuildWorkInsetMin: ImVec2;
    BuildWorkInsetMax: ImVec2;
  end;

  ImGuiWindowSettings = record
    ID: ImGuiID;
    Pos: ImVec2ih;
    Size: ImVec2ih;
    ViewportPos: ImVec2ih;
    ViewportId: ImGuiID;
    DockId: ImGuiID;
    ClassId: ImGuiID;
    DockOrder: Smallint;
    Collapsed: Boolean;
    IsChild: Boolean;
    WantApply: Boolean;
    WantDelete: Boolean;
  end;

  ImGuiSettingsHandler = record
    TypeName: PUTF8Char;
    TypeHash: ImGuiID;
    ClearAllFn: procedure(ctx: PImGuiContext; handler: PImGuiSettingsHandler); cdecl;
    ReadInitFn: procedure(ctx: PImGuiContext; handler: PImGuiSettingsHandler); cdecl;
    ReadOpenFn: function(ctx: PImGuiContext; handler: PImGuiSettingsHandler; const name: PUTF8Char): Pointer; cdecl;
    ReadLineFn: procedure(ctx: PImGuiContext; handler: PImGuiSettingsHandler; entry: Pointer; const line: PUTF8Char); cdecl;
    ApplyAllFn: procedure(ctx: PImGuiContext; handler: PImGuiSettingsHandler); cdecl;
    WriteAllFn: procedure(ctx: PImGuiContext; handler: PImGuiSettingsHandler; out_buf: PImGuiTextBuffer); cdecl;
    UserData: Pointer;
  end;

  ImGuiLocEntry = record
    Key: ImGuiLocKey;
    Text: PUTF8Char;
  end;

  ImGuiErrorCallback = procedure(ctx: PImGuiContext; user_data: Pointer; const msg: PUTF8Char); cdecl;

  ImGuiDebugAllocEntry = record
    FrameCount: Integer;
    AllocCount: ImS16;
    FreeCount: ImS16;
  end;

  ImGuiDebugAllocInfo = record
    TotalAllocCount: Integer;
    TotalFreeCount: Integer;
    LastEntriesIdx: ImS16;
    LastEntriesBuf: array [0..5] of ImGuiDebugAllocEntry;
  end;

  ImGuiMetricsConfig = record
    ShowDebugLog: Boolean;
    ShowIDStackTool: Boolean;
    ShowWindowsRects: Boolean;
    ShowWindowsBeginOrder: Boolean;
    ShowTablesRects: Boolean;
    ShowDrawCmdMesh: Boolean;
    ShowDrawCmdBoundingBoxes: Boolean;
    ShowTextEncodingViewer: Boolean;
    ShowDockingNodes: Boolean;
    ShowWindowsRectsType: Integer;
    ShowTablesRectsType: Integer;
    HighlightMonitorIdx: Integer;
    HighlightViewportID: ImGuiID;
  end;

  ImGuiStackLevelInfo = record
    ID: ImGuiID;
    QueryFrameCount: ImS8;
    QuerySuccess: Boolean;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property DataType: Cardinal index $0008 read GetData0Value write SetData0Value; // 8 bits at offset 0 in Data0
  var
    Desc: array [0..56] of UTF8Char;
  end;

  ImVector_ImGuiStackLevelInfo = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiStackLevelInfo;
  end;

  ImGuiIDStackTool = record
    LastActiveFrame: Integer;
    StackLevel: Integer;
    QueryId: ImGuiID;
    Results: ImVector_ImGuiStackLevelInfo;
    CopyToClipboardOnCtrlC: Boolean;
    CopyToClipboardLastTime: Single;
    ResultPathBuf: ImGuiTextBuffer;
  end;

  ImGuiContextHookCallback = procedure(ctx: PImGuiContext; hook: PImGuiContextHook); cdecl;

  ImGuiContextHook = record
    HookId: ImGuiID;
    &Type: ImGuiContextHookType;
    Owner: ImGuiID;
    Callback: ImGuiContextHookCallback;
    UserData: Pointer;
  end;

  ImVector_ImGuiInputEvent = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiInputEvent;
  end;

  ImVector_ImGuiWindowStackData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiWindowStackData;
  end;

  ImVector_ImGuiColorMod = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiColorMod;
  end;

  ImVector_ImGuiStyleMod = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiStyleMod;
  end;

  ImVector_ImGuiFocusScopeData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiFocusScopeData;
  end;

  ImVector_ImGuiItemFlags = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiItemFlags;
  end;

  ImVector_ImGuiGroupData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiGroupData;
  end;

  ImVector_ImGuiPopupData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiPopupData;
  end;

  ImVector_ImGuiTreeNodeStackData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTreeNodeStackData;
  end;

  ImVector_ImGuiViewportPPtr = record
    Size: Integer;
    Capacity: Integer;
    Data: PPImGuiViewportP;
  end;

  ImVector_unsigned_char = record
    Size: Integer;
    Capacity: Integer;
    Data: PByte;
  end;

  ImVector_ImGuiListClipperData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiListClipperData;
  end;

  ImVector_ImGuiTableTempData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTableTempData;
  end;

  ImVector_ImGuiTable = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTable;
  end;

  ImPool_ImGuiTable = record
    Buf: ImVector_ImGuiTable;
    Map: ImGuiStorage;
    FreeIdx: ImPoolIdx;
    AliveCount: ImPoolIdx;
  end;

  ImVector_ImGuiTabBar = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTabBar;
  end;

  ImPool_ImGuiTabBar = record
    Buf: ImVector_ImGuiTabBar;
    Map: ImGuiStorage;
    FreeIdx: ImPoolIdx;
    AliveCount: ImPoolIdx;
  end;

  ImVector_ImGuiPtrOrIndex = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiPtrOrIndex;
  end;

  ImVector_ImGuiShrinkWidthItem = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiShrinkWidthItem;
  end;

  ImVector_ImGuiMultiSelectTempData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiMultiSelectTempData;
  end;

  ImVector_ImGuiMultiSelectState = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiMultiSelectState;
  end;

  ImPool_ImGuiMultiSelectState = record
    Buf: ImVector_ImGuiMultiSelectState;
    Map: ImGuiStorage;
    FreeIdx: ImPoolIdx;
    AliveCount: ImPoolIdx;
  end;

  ImVector_ImGuiID = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiID;
  end;

  ImVector_ImGuiSettingsHandler = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiSettingsHandler;
  end;

  ImChunkStream_ImGuiWindowSettings = record
    Buf: ImVector_char;
  end;

  ImChunkStream_ImGuiTableSettings = record
    Buf: ImVector_char;
  end;

  ImVector_ImGuiContextHook = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiContextHook;
  end;

  ImGuiContext = record
    Initialized: Boolean;
    FontAtlasOwnedByContext: Boolean;
    IO: ImGuiIO;
    PlatformIO: ImGuiPlatformIO;
    Style: ImGuiStyle;
    ConfigFlagsCurrFrame: ImGuiConfigFlags;
    ConfigFlagsLastFrame: ImGuiConfigFlags;
    Font: PImFont;
    FontSize: Single;
    FontBaseSize: Single;
    FontScale: Single;
    CurrentDpiScale: Single;
    DrawListSharedData: ImDrawListSharedData;
    Time: Double;
    FrameCount: Integer;
    FrameCountEnded: Integer;
    FrameCountPlatformEnded: Integer;
    FrameCountRendered: Integer;
    WithinEndChildID: ImGuiID;
    WithinFrameScope: Boolean;
    WithinFrameScopeWithImplicitWindow: Boolean;
    GcCompactAll: Boolean;
    TestEngineHookItems: Boolean;
    TestEngine: Pointer;
    ContextName: array [0..15] of UTF8Char;
    InputEventsQueue: ImVector_ImGuiInputEvent;
    InputEventsTrail: ImVector_ImGuiInputEvent;
    InputEventsNextMouseSource: ImGuiMouseSource;
    InputEventsNextEventId: ImU32;
    Windows: ImVector_ImGuiWindowPtr;
    WindowsFocusOrder: ImVector_ImGuiWindowPtr;
    WindowsTempSortBuffer: ImVector_ImGuiWindowPtr;
    CurrentWindowStack: ImVector_ImGuiWindowStackData;
    WindowsById: ImGuiStorage;
    WindowsActiveCount: Integer;
    WindowsBorderHoverPadding: Single;
    DebugBreakInWindow: ImGuiID;
    CurrentWindow: PImGuiWindow;
    HoveredWindow: PImGuiWindow;
    HoveredWindowUnderMovingWindow: PImGuiWindow;
    HoveredWindowBeforeClear: PImGuiWindow;
    MovingWindow: PImGuiWindow;
    WheelingWindow: PImGuiWindow;
    WheelingWindowRefMousePos: ImVec2;
    WheelingWindowStartFrame: Integer;
    WheelingWindowScrolledFrame: Integer;
    WheelingWindowReleaseTimer: Single;
    WheelingWindowWheelRemainder: ImVec2;
    WheelingAxisAvg: ImVec2;
    DebugDrawIdConflicts: ImGuiID;
    DebugHookIdInfo: ImGuiID;
    HoveredId: ImGuiID;
    HoveredIdPreviousFrame: ImGuiID;
    HoveredIdPreviousFrameItemCount: Integer;
    HoveredIdTimer: Single;
    HoveredIdNotActiveTimer: Single;
    HoveredIdAllowOverlap: Boolean;
    HoveredIdIsDisabled: Boolean;
    ItemUnclipByLog: Boolean;
    ActiveId: ImGuiID;
    ActiveIdIsAlive: ImGuiID;
    ActiveIdTimer: Single;
    ActiveIdIsJustActivated: Boolean;
    ActiveIdAllowOverlap: Boolean;
    ActiveIdNoClearOnFocusLoss: Boolean;
    ActiveIdHasBeenPressedBefore: Boolean;
    ActiveIdHasBeenEditedBefore: Boolean;
    ActiveIdHasBeenEditedThisFrame: Boolean;
    ActiveIdFromShortcut: Boolean;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property ActiveIdMouseButton: Cardinal index $0008 read GetData0Value write SetData0Value; // 8 bits at offset 0 in Data0
  var
    ActiveIdClickOffset: ImVec2;
    ActiveIdWindow: PImGuiWindow;
    ActiveIdSource: ImGuiInputSource;
    ActiveIdPreviousFrame: ImGuiID;
    DeactivatedItemData: ImGuiDeactivatedItemData;
    ActiveIdValueOnActivation: ImGuiDataTypeStorage;
    LastActiveId: ImGuiID;
    LastActiveIdTimer: Single;
    LastKeyModsChangeTime: Double;
    LastKeyModsChangeFromNoneTime: Double;
    LastKeyboardKeyPressTime: Double;
    KeysMayBeCharInput: ImBitArrayForNamedKeys;
    KeysOwnerData: array [0..154] of ImGuiKeyOwnerData;
    KeysRoutingTable: ImGuiKeyRoutingTable;
    ActiveIdUsingNavDirMask: ImU32;
    ActiveIdUsingAllKeyboardKeys: Boolean;
    DebugBreakInShortcutRouting: ImGuiKeyChord;
    CurrentFocusScopeId: ImGuiID;
    CurrentItemFlags: ImGuiItemFlags;
    DebugLocateId: ImGuiID;
    NextItemData: ImGuiNextItemData;
    LastItemData: ImGuiLastItemData;
    NextWindowData: ImGuiNextWindowData;
    DebugShowGroupRects: Boolean;
    DebugFlashStyleColorIdx: ImGuiCol;
    ColorStack: ImVector_ImGuiColorMod;
    StyleVarStack: ImVector_ImGuiStyleMod;
    FontStack: ImVector_ImFontPtr;
    FocusScopeStack: ImVector_ImGuiFocusScopeData;
    ItemFlagsStack: ImVector_ImGuiItemFlags;
    GroupStack: ImVector_ImGuiGroupData;
    OpenPopupStack: ImVector_ImGuiPopupData;
    BeginPopupStack: ImVector_ImGuiPopupData;
    TreeNodeStack: ImVector_ImGuiTreeNodeStackData;
    Viewports: ImVector_ImGuiViewportPPtr;
    CurrentViewport: PImGuiViewportP;
    MouseViewport: PImGuiViewportP;
    MouseLastHoveredViewport: PImGuiViewportP;
    PlatformLastFocusedViewportId: ImGuiID;
    FallbackMonitor: ImGuiPlatformMonitor;
    PlatformMonitorsFullWorkRect: ImRect;
    ViewportCreatedCount: Integer;
    PlatformWindowsCreatedCount: Integer;
    ViewportFocusedStampCount: Integer;
    NavCursorVisible: Boolean;
    NavHighlightItemUnderNav: Boolean;
    NavMousePosDirty: Boolean;
    NavIdIsAlive: Boolean;
    NavId: ImGuiID;
    NavWindow: PImGuiWindow;
    NavFocusScopeId: ImGuiID;
    NavLayer: ImGuiNavLayer;
    NavActivateId: ImGuiID;
    NavActivateDownId: ImGuiID;
    NavActivatePressedId: ImGuiID;
    NavActivateFlags: ImGuiActivateFlags;
    NavFocusRoute: ImVector_ImGuiFocusScopeData;
    NavHighlightActivatedId: ImGuiID;
    NavHighlightActivatedTimer: Single;
    NavNextActivateId: ImGuiID;
    NavNextActivateFlags: ImGuiActivateFlags;
    NavInputSource: ImGuiInputSource;
    NavLastValidSelectionUserData: ImGuiSelectionUserData;
    NavCursorHideFrames: ImS8;
    NavAnyRequest: Boolean;
    NavInitRequest: Boolean;
    NavInitRequestFromMove: Boolean;
    NavInitResult: ImGuiNavItemData;
    NavMoveSubmitted: Boolean;
    NavMoveScoringItems: Boolean;
    NavMoveForwardToNextFrame: Boolean;
    NavMoveFlags: ImGuiNavMoveFlags;
    NavMoveScrollFlags: ImGuiScrollFlags;
    NavMoveKeyMods: ImGuiKeyChord;
    NavMoveDir: ImGuiDir;
    NavMoveDirForDebug: ImGuiDir;
    NavMoveClipDir: ImGuiDir;
    NavScoringRect: ImRect;
    NavScoringNoClipRect: ImRect;
    NavScoringDebugCount: Integer;
    NavTabbingDir: Integer;
    NavTabbingCounter: Integer;
    NavMoveResultLocal: ImGuiNavItemData;
    NavMoveResultLocalVisible: ImGuiNavItemData;
    NavMoveResultOther: ImGuiNavItemData;
    NavTabbingResultFirst: ImGuiNavItemData;
    NavJustMovedFromFocusScopeId: ImGuiID;
    NavJustMovedToId: ImGuiID;
    NavJustMovedToFocusScopeId: ImGuiID;
    NavJustMovedToKeyMods: ImGuiKeyChord;
    NavJustMovedToIsTabbing: Boolean;
    NavJustMovedToHasSelectionData: Boolean;
    ConfigNavWindowingKeyNext: ImGuiKeyChord;
    ConfigNavWindowingKeyPrev: ImGuiKeyChord;
    NavWindowingTarget: PImGuiWindow;
    NavWindowingTargetAnim: PImGuiWindow;
    NavWindowingListWindow: PImGuiWindow;
    NavWindowingTimer: Single;
    NavWindowingHighlightAlpha: Single;
    NavWindowingToggleLayer: Boolean;
    NavWindowingToggleKey: ImGuiKey;
    NavWindowingAccumDeltaPos: ImVec2;
    NavWindowingAccumDeltaSize: ImVec2;
    DimBgRatio: Single;
    DragDropActive: Boolean;
    DragDropWithinSource: Boolean;
    DragDropWithinTarget: Boolean;
    DragDropSourceFlags: ImGuiDragDropFlags;
    DragDropSourceFrameCount: Integer;
    DragDropMouseButton: Integer;
    DragDropPayload: ImGuiPayload;
    DragDropTargetRect: ImRect;
    DragDropTargetClipRect: ImRect;
    DragDropTargetId: ImGuiID;
    DragDropAcceptFlags: ImGuiDragDropFlags;
    DragDropAcceptIdCurrRectSurface: Single;
    DragDropAcceptIdCurr: ImGuiID;
    DragDropAcceptIdPrev: ImGuiID;
    DragDropAcceptFrameCount: Integer;
    DragDropHoldJustPressedId: ImGuiID;
    DragDropPayloadBufHeap: ImVector_unsigned_char;
    DragDropPayloadBufLocal: array [0..15] of Byte;
    ClipperTempDataStacked: Integer;
    ClipperTempData: ImVector_ImGuiListClipperData;
    CurrentTable: PImGuiTable;
    DebugBreakInTable: ImGuiID;
    TablesTempDataStacked: Integer;
    TablesTempData: ImVector_ImGuiTableTempData;
    Tables: ImPool_ImGuiTable;
    TablesLastTimeActive: ImVector_float;
    DrawChannelsTempMergeBuffer: ImVector_ImDrawChannel;
    CurrentTabBar: PImGuiTabBar;
    TabBars: ImPool_ImGuiTabBar;
    CurrentTabBarStack: ImVector_ImGuiPtrOrIndex;
    ShrinkWidthBuffer: ImVector_ImGuiShrinkWidthItem;
    BoxSelectState: ImGuiBoxSelectState;
    CurrentMultiSelect: PImGuiMultiSelectTempData;
    MultiSelectTempDataStacked: Integer;
    MultiSelectTempData: ImVector_ImGuiMultiSelectTempData;
    MultiSelectStorage: ImPool_ImGuiMultiSelectState;
    HoverItemDelayId: ImGuiID;
    HoverItemDelayIdPreviousFrame: ImGuiID;
    HoverItemDelayTimer: Single;
    HoverItemDelayClearTimer: Single;
    HoverItemUnlockedStationaryId: ImGuiID;
    HoverWindowUnlockedStationaryId: ImGuiID;
    MouseCursor: ImGuiMouseCursor;
    MouseStationaryTimer: Single;
    MouseLastValidPos: ImVec2;
    InputTextState: ImGuiInputTextState;
    InputTextDeactivatedState: ImGuiInputTextDeactivatedState;
    InputTextPasswordFont: ImFont;
    TempInputId: ImGuiID;
    DataTypeZeroValue: ImGuiDataTypeStorage;
    BeginMenuDepth: Integer;
    BeginComboDepth: Integer;
    ColorEditOptions: ImGuiColorEditFlags;
    ColorEditCurrentID: ImGuiID;
    ColorEditSavedID: ImGuiID;
    ColorEditSavedHue: Single;
    ColorEditSavedSat: Single;
    ColorEditSavedColor: ImU32;
    ColorPickerRef: ImVec4;
    ComboPreviewData: ImGuiComboPreviewData;
    WindowResizeBorderExpectedRect: ImRect;
    WindowResizeRelativeMode: Boolean;
    ScrollbarSeekMode: Smallint;
    ScrollbarClickDeltaToGrabCenter: Single;
    SliderGrabClickOffset: Single;
    SliderCurrentAccum: Single;
    SliderCurrentAccumDirty: Boolean;
    DragCurrentAccumDirty: Boolean;
    DragCurrentAccum: Single;
    DragSpeedDefaultRatio: Single;
    DisabledAlphaBackup: Single;
    DisabledStackSize: Smallint;
    TooltipOverrideCount: Smallint;
    TooltipPreviousWindow: PImGuiWindow;
    ClipboardHandlerData: ImVector_char;
    MenusIdSubmittedThisFrame: ImVector_ImGuiID;
    TypingSelectState: ImGuiTypingSelectState;
    PlatformImeData: ImGuiPlatformImeData;
    PlatformImeDataPrev: ImGuiPlatformImeData;
    PlatformImeViewport: ImGuiID;
    DockContext: ImGuiDockContext;
    DockNodeWindowMenuHandler: procedure(ctx: PImGuiContext; node: PImGuiDockNode; tab_bar: PImGuiTabBar); cdecl;
    SettingsLoaded: Boolean;
    SettingsDirtyTimer: Single;
    SettingsIniData: ImGuiTextBuffer;
    SettingsHandlers: ImVector_ImGuiSettingsHandler;
    SettingsWindows: ImChunkStream_ImGuiWindowSettings;
    SettingsTables: ImChunkStream_ImGuiTableSettings;
    Hooks: ImVector_ImGuiContextHook;
    HookIdNext: ImGuiID;
    LocalizationTable: array [0..12] of PUTF8Char;
    LogEnabled: Boolean;
    LogFlags: ImGuiLogFlags;
    LogWindow: PImGuiWindow;
    LogFile: ImFileHandle;
    LogBuffer: ImGuiTextBuffer;
    LogNextPrefix: PUTF8Char;
    LogNextSuffix: PUTF8Char;
    LogLinePosY: Single;
    LogLineFirstItem: Boolean;
    LogDepthRef: Integer;
    LogDepthToExpand: Integer;
    LogDepthToExpandDefault: Integer;
    ErrorCallback: ImGuiErrorCallback;
    ErrorCallbackUserData: Pointer;
    ErrorTooltipLockedPos: ImVec2;
    ErrorFirst: Boolean;
    ErrorCountCurrentFrame: Integer;
    StackSizesInNewFrame: ImGuiErrorRecoveryState;
    StackSizesInBeginForCurrentWindow: PImGuiErrorRecoveryState;
    DebugDrawIdConflictsCount: Integer;
    DebugLogFlags: ImGuiDebugLogFlags;
    DebugLogBuf: ImGuiTextBuffer;
    DebugLogIndex: ImGuiTextIndex;
    DebugLogSkippedErrors: Integer;
    DebugLogAutoDisableFlags: ImGuiDebugLogFlags;
    DebugLogAutoDisableFrames: ImU8;
    DebugLocateFrames: ImU8;
    DebugBreakInLocateId: Boolean;
    DebugBreakKeyChord: ImGuiKeyChord;
    DebugBeginReturnValueCullDepth: ImS8;
    DebugItemPickerActive: Boolean;
    DebugItemPickerMouseButton: ImU8;
    DebugItemPickerBreakId: ImGuiID;
    DebugFlashStyleColorTime: Single;
    DebugFlashStyleColorBackup: ImVec4;
    DebugMetricsConfig: ImGuiMetricsConfig;
    DebugIDStackTool: ImGuiIDStackTool;
    DebugAllocInfo: ImGuiDebugAllocInfo;
    DebugHoveredDockNode: PImGuiDockNode;
    FramerateSecPerFrame: array [0..59] of Single;
    FramerateSecPerFrameIdx: Integer;
    FramerateSecPerFrameCount: Integer;
    FramerateSecPerFrameAccum: Single;
    WantCaptureMouseNextFrame: Integer;
    WantCaptureKeyboardNextFrame: Integer;
    WantTextInputNextFrame: Integer;
    TempBuffer: ImVector_char;
    TempKeychordName: array [0..63] of UTF8Char;
  end;

  ImGuiWindowTempData = record
    CursorPos: ImVec2;
    CursorPosPrevLine: ImVec2;
    CursorStartPos: ImVec2;
    CursorMaxPos: ImVec2;
    IdealMaxPos: ImVec2;
    CurrLineSize: ImVec2;
    PrevLineSize: ImVec2;
    CurrLineTextBaseOffset: Single;
    PrevLineTextBaseOffset: Single;
    IsSameLine: Boolean;
    IsSetPos: Boolean;
    Indent: ImVec1;
    ColumnsOffset: ImVec1;
    GroupOffset: ImVec1;
    CursorStartPosLossyness: ImVec2;
    NavLayerCurrent: ImGuiNavLayer;
    NavLayersActiveMask: Smallint;
    NavLayersActiveMaskNext: Smallint;
    NavIsScrollPushableX: Boolean;
    NavHideHighlightOneFrame: Boolean;
    NavWindowHasScrollY: Boolean;
    MenuBarAppending: Boolean;
    MenuBarOffset: ImVec2;
    MenuColumns: ImGuiMenuColumns;
    TreeDepth: Integer;
    TreeHasStackDataDepthMask: ImU32;
    ChildWindows: ImVector_ImGuiWindowPtr;
    StateStorage: PImGuiStorage;
    CurrentColumns: PImGuiOldColumns;
    CurrentTableIdx: Integer;
    LayoutType: ImGuiLayoutType;
    ParentLayoutType: ImGuiLayoutType;
    ModalDimBgColor: ImU32;
    WindowItemStatusFlags: ImGuiItemStatusFlags;
    ChildItemStatusFlags: ImGuiItemStatusFlags;
    DockTabItemStatusFlags: ImGuiItemStatusFlags;
    DockTabItemRect: ImRect;
    ItemWidth: Single;
    TextWrapPos: Single;
    ItemWidthStack: ImVector_float;
    TextWrapPosStack: ImVector_float;
  end;

  ImVector_ImGuiOldColumns = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiOldColumns;
  end;

  ImGuiWindow = record
    Ctx: PImGuiContext;
    Name: PUTF8Char;
    ID: ImGuiID;
    Flags: ImGuiWindowFlags;
    FlagsPreviousFrame: ImGuiWindowFlags;
    ChildFlags: ImGuiChildFlags;
    WindowClass: ImGuiWindowClass;
    Viewport: PImGuiViewportP;
    ViewportId: ImGuiID;
    ViewportPos: ImVec2;
    ViewportAllowPlatformMonitorExtend: Integer;
    Pos: ImVec2;
    Size: ImVec2;
    SizeFull: ImVec2;
    ContentSize: ImVec2;
    ContentSizeIdeal: ImVec2;
    ContentSizeExplicit: ImVec2;
    WindowPadding: ImVec2;
    WindowRounding: Single;
    WindowBorderSize: Single;
    TitleBarHeight: Single;
    MenuBarHeight: Single;
    DecoOuterSizeX1: Single;
    DecoOuterSizeY1: Single;
    DecoOuterSizeX2: Single;
    DecoOuterSizeY2: Single;
    DecoInnerSizeX1: Single;
    DecoInnerSizeY1: Single;
    NameBufLen: Integer;
    MoveId: ImGuiID;
    TabId: ImGuiID;
    ChildId: ImGuiID;
    PopupId: ImGuiID;
    Scroll: ImVec2;
    ScrollMax: ImVec2;
    ScrollTarget: ImVec2;
    ScrollTargetCenterRatio: ImVec2;
    ScrollTargetEdgeSnapDist: ImVec2;
    ScrollbarSizes: ImVec2;
    ScrollbarX: Boolean;
    ScrollbarY: Boolean;
    ScrollbarXStabilizeEnabled: Boolean;
    ScrollbarXStabilizeToggledHistory: ImU8;
    ViewportOwned: Boolean;
    Active: Boolean;
    WasActive: Boolean;
    WriteAccessed: Boolean;
    Collapsed: Boolean;
    WantCollapseToggle: Boolean;
    SkipItems: Boolean;
    SkipRefresh: Boolean;
    Appearing: Boolean;
    Hidden: Boolean;
    IsFallbackWindow: Boolean;
    IsExplicitChild: Boolean;
    HasCloseButton: Boolean;
    ResizeBorderHovered: UTF8Char;
    ResizeBorderHeld: UTF8Char;
    BeginCount: Smallint;
    BeginCountPreviousFrame: Smallint;
    BeginOrderWithinParent: Smallint;
    BeginOrderWithinContext: Smallint;
    FocusOrder: Smallint;
    AutoFitFramesX: ImS8;
    AutoFitFramesY: ImS8;
    AutoFitOnlyGrows: Boolean;
    AutoPosLastDirection: ImGuiDir;
    HiddenFramesCanSkipItems: ImS8;
    HiddenFramesCannotSkipItems: ImS8;
    HiddenFramesForRenderOnly: ImS8;
    DisableInputsFrames: ImS8;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property SetWindowPosAllowFlags: Cardinal index $0008 read GetData0Value write SetData0Value; // 8 bits at offset 0 in Data0
    property SetWindowSizeAllowFlags: Cardinal index $0808 read GetData0Value write SetData0Value; // 8 bits at offset 8 in Data0
    property SetWindowCollapsedAllowFlags: Cardinal index $1008 read GetData0Value write SetData0Value; // 8 bits at offset 16 in Data0
    property SetWindowDockAllowFlags: Cardinal index $1808 read GetData0Value write SetData0Value; // 8 bits at offset 24 in Data0
  var
    SetWindowPosVal: ImVec2;
    SetWindowPosPivot: ImVec2;
    IDStack: ImVector_ImGuiID;
    DC: ImGuiWindowTempData;
    OuterRectClipped: ImRect;
    InnerRect: ImRect;
    InnerClipRect: ImRect;
    WorkRect: ImRect;
    ParentWorkRect: ImRect;
    ClipRect: ImRect;
    ContentRegionRect: ImRect;
    HitTestHoleSize: ImVec2ih;
    HitTestHoleOffset: ImVec2ih;
    LastFrameActive: Integer;
    LastFrameJustFocused: Integer;
    LastTimeActive: Single;
    ItemWidthDefault: Single;
    StateStorage: ImGuiStorage;
    ColumnsStorage: ImVector_ImGuiOldColumns;
    FontWindowScale: Single;
    FontWindowScaleParents: Single;
    FontDpiScale: Single;
    FontRefSize: Single;
    SettingsOffset: Integer;
    DrawList: PImDrawList;
    DrawListInst: ImDrawList;
    ParentWindow: PImGuiWindow;
    ParentWindowInBeginStack: PImGuiWindow;
    RootWindow: PImGuiWindow;
    RootWindowPopupTree: PImGuiWindow;
    RootWindowDockTree: PImGuiWindow;
    RootWindowForTitleBarHighlight: PImGuiWindow;
    RootWindowForNav: PImGuiWindow;
    ParentWindowForFocusRoute: PImGuiWindow;
    NavLastChildNavWindow: PImGuiWindow;
    NavLastIds: array [0..1] of ImGuiID;
    NavRectRel: array [0..1] of ImRect;
    NavPreferredScoringPosRel: array [0..1] of ImVec2;
    NavRootFocusScopeId: ImGuiID;
    MemoryDrawListIdxCapacity: Integer;
    MemoryDrawListVtxCapacity: Integer;
    MemoryCompacted: Boolean;
  private
    Data1: Cardinal;
    function GetData1Value(const AIndex: Integer): Cardinal;
    procedure SetData1Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property DockIsActive: Cardinal index $1 read GetData1Value write SetData1Value; // 1 bits at offset 0 in Data1
    property DockNodeIsVisible: Cardinal index $101 read GetData1Value write SetData1Value; // 1 bits at offset 1 in Data1
    property DockTabIsVisible: Cardinal index $201 read GetData1Value write SetData1Value; // 1 bits at offset 2 in Data1
    property DockTabWantClose: Cardinal index $301 read GetData1Value write SetData1Value; // 1 bits at offset 3 in Data1
  var
    DockOrder: Smallint;
    DockStyle: ImGuiWindowDockStyle;
    DockNode: PImGuiDockNode;
    DockNodeAsHost: PImGuiDockNode;
    DockId: ImGuiID;
  end;

  ImGuiTabItem = record
    ID: ImGuiID;
    Flags: ImGuiTabItemFlags;
    Window: PImGuiWindow;
    LastFrameVisible: Integer;
    LastFrameSelected: Integer;
    Offset: Single;
    Width: Single;
    ContentWidth: Single;
    RequestedWidth: Single;
    NameOffset: ImS32;
    BeginOrder: ImS16;
    IndexDuringLayout: ImS16;
    WantClose: Boolean;
  end;

  ImVector_ImGuiTabItem = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTabItem;
  end;

  ImGuiTabBar = record
    Window: PImGuiWindow;
    Tabs: ImVector_ImGuiTabItem;
    Flags: ImGuiTabBarFlags;
    ID: ImGuiID;
    SelectedTabId: ImGuiID;
    NextSelectedTabId: ImGuiID;
    VisibleTabId: ImGuiID;
    CurrFrameVisible: Integer;
    PrevFrameVisible: Integer;
    BarRect: ImRect;
    CurrTabsContentsHeight: Single;
    PrevTabsContentsHeight: Single;
    WidthAllTabs: Single;
    WidthAllTabsIdeal: Single;
    ScrollingAnim: Single;
    ScrollingTarget: Single;
    ScrollingTargetDistToVisibility: Single;
    ScrollingSpeed: Single;
    ScrollingRectMinX: Single;
    ScrollingRectMaxX: Single;
    SeparatorMinX: Single;
    SeparatorMaxX: Single;
    ReorderRequestTabId: ImGuiID;
    ReorderRequestOffset: ImS16;
    BeginCount: ImS8;
    WantLayout: Boolean;
    VisibleTabWasSubmitted: Boolean;
    TabsAddedNew: Boolean;
    TabsActiveCount: ImS16;
    LastTabItemIdx: ImS16;
    ItemSpacingY: Single;
    FramePadding: ImVec2;
    BackupCursorPos: ImVec2;
    TabsNames: ImGuiTextBuffer;
  end;

  ImGuiTableColumnIdx = ImS16;
  PImGuiTableColumnIdx = ^ImGuiTableColumnIdx;
  ImGuiTableDrawChannelIdx = ImU16;

  ImGuiTableColumn = record
    Flags: ImGuiTableColumnFlags;
    WidthGiven: Single;
    MinX: Single;
    MaxX: Single;
    WidthRequest: Single;
    WidthAuto: Single;
    WidthMax: Single;
    StretchWeight: Single;
    InitStretchWeightOrWidth: Single;
    ClipRect: ImRect;
    UserID: ImGuiID;
    WorkMinX: Single;
    WorkMaxX: Single;
    ItemWidth: Single;
    ContentMaxXFrozen: Single;
    ContentMaxXUnfrozen: Single;
    ContentMaxXHeadersUsed: Single;
    ContentMaxXHeadersIdeal: Single;
    NameOffset: ImS16;
    DisplayOrder: ImGuiTableColumnIdx;
    IndexWithinEnabledSet: ImGuiTableColumnIdx;
    PrevEnabledColumn: ImGuiTableColumnIdx;
    NextEnabledColumn: ImGuiTableColumnIdx;
    SortOrder: ImGuiTableColumnIdx;
    DrawChannelCurrent: ImGuiTableDrawChannelIdx;
    DrawChannelFrozen: ImGuiTableDrawChannelIdx;
    DrawChannelUnfrozen: ImGuiTableDrawChannelIdx;
    IsEnabled: Boolean;
    IsUserEnabled: Boolean;
    IsUserEnabledNextFrame: Boolean;
    IsVisibleX: Boolean;
    IsVisibleY: Boolean;
    IsRequestOutput: Boolean;
    IsSkipItems: Boolean;
    IsPreserveWidthAuto: Boolean;
    NavLayerCurrent: ImS8;
    AutoFitQueue: ImU8;
    CannotSkipItemsQueue: ImU8;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property SortDirection: Cardinal index $2 read GetData0Value write SetData0Value; // 2 bits at offset 0 in Data0
    property SortDirectionsAvailCount: Cardinal index $202 read GetData0Value write SetData0Value; // 2 bits at offset 2 in Data0
    property SortDirectionsAvailMask: Cardinal index $404 read GetData0Value write SetData0Value; // 4 bits at offset 4 in Data0
  var
    SortDirectionsAvailList: ImU8;
  end;

  ImGuiTableCellData = record
    BgColor: ImU32;
    Column: ImGuiTableColumnIdx;
  end;

  ImGuiTableHeaderData = record
    Index: ImGuiTableColumnIdx;
    TextColor: ImU32;
    BgColor0: ImU32;
    BgColor1: ImU32;
  end;

  ImGuiTableInstanceData = record
    TableInstanceID: ImGuiID;
    LastOuterHeight: Single;
    LastTopHeadersRowHeight: Single;
    LastFrozenHeight: Single;
    HoveredRowLast: Integer;
    HoveredRowNext: Integer;
  end;

  ImSpan_ImGuiTableColumn = record
    Data: PImGuiTableColumn;
    DataEnd: PImGuiTableColumn;
  end;

  ImSpan_ImGuiTableColumnIdx = record
    Data: PImGuiTableColumnIdx;
    DataEnd: PImGuiTableColumnIdx;
  end;

  ImSpan_ImGuiTableCellData = record
    Data: PImGuiTableCellData;
    DataEnd: PImGuiTableCellData;
  end;

  ImVector_ImGuiTableInstanceData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTableInstanceData;
  end;

  ImVector_ImGuiTableColumnSortSpecs = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTableColumnSortSpecs;
  end;

  ImGuiTable = record
    ID: ImGuiID;
    Flags: ImGuiTableFlags;
    RawData: Pointer;
    TempData: PImGuiTableTempData;
    Columns: ImSpan_ImGuiTableColumn;
    DisplayOrderToIndex: ImSpan_ImGuiTableColumnIdx;
    RowCellData: ImSpan_ImGuiTableCellData;
    EnabledMaskByDisplayOrder: ImBitArrayPtr;
    EnabledMaskByIndex: ImBitArrayPtr;
    VisibleMaskByIndex: ImBitArrayPtr;
    SettingsLoadedFlags: ImGuiTableFlags;
    SettingsOffset: Integer;
    LastFrameActive: Integer;
    ColumnsCount: Integer;
    CurrentRow: Integer;
    CurrentColumn: Integer;
    InstanceCurrent: ImS16;
    InstanceInteracted: ImS16;
    RowPosY1: Single;
    RowPosY2: Single;
    RowMinHeight: Single;
    RowCellPaddingY: Single;
    RowTextBaseline: Single;
    RowIndentOffsetX: Single;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property RowFlags: Cardinal index $0010 read GetData0Value write SetData0Value; // 16 bits at offset 0 in Data0
    property LastRowFlags: Cardinal index $1010 read GetData0Value write SetData0Value; // 16 bits at offset 16 in Data0
  var
    RowBgColorCounter: Integer;
    RowBgColor: array [0..1] of ImU32;
    BorderColorStrong: ImU32;
    BorderColorLight: ImU32;
    BorderX1: Single;
    BorderX2: Single;
    HostIndentX: Single;
    MinColumnWidth: Single;
    OuterPaddingX: Single;
    CellPaddingX: Single;
    CellSpacingX1: Single;
    CellSpacingX2: Single;
    InnerWidth: Single;
    ColumnsGivenWidth: Single;
    ColumnsAutoFitWidth: Single;
    ColumnsStretchSumWeights: Single;
    ResizedColumnNextWidth: Single;
    ResizeLockMinContentsX2: Single;
    RefScale: Single;
    AngledHeadersHeight: Single;
    AngledHeadersSlope: Single;
    OuterRect: ImRect;
    InnerRect: ImRect;
    WorkRect: ImRect;
    InnerClipRect: ImRect;
    BgClipRect: ImRect;
    Bg0ClipRectForDrawCmd: ImRect;
    Bg2ClipRectForDrawCmd: ImRect;
    HostClipRect: ImRect;
    HostBackupInnerClipRect: ImRect;
    OuterWindow: PImGuiWindow;
    InnerWindow: PImGuiWindow;
    ColumnsNames: ImGuiTextBuffer;
    DrawSplitter: PImDrawListSplitter;
    InstanceDataFirst: ImGuiTableInstanceData;
    InstanceDataExtra: ImVector_ImGuiTableInstanceData;
    SortSpecsSingle: ImGuiTableColumnSortSpecs;
    SortSpecsMulti: ImVector_ImGuiTableColumnSortSpecs;
    SortSpecs: ImGuiTableSortSpecs;
    SortSpecsCount: ImGuiTableColumnIdx;
    ColumnsEnabledCount: ImGuiTableColumnIdx;
    ColumnsEnabledFixedCount: ImGuiTableColumnIdx;
    DeclColumnsCount: ImGuiTableColumnIdx;
    AngledHeadersCount: ImGuiTableColumnIdx;
    HoveredColumnBody: ImGuiTableColumnIdx;
    HoveredColumnBorder: ImGuiTableColumnIdx;
    HighlightColumnHeader: ImGuiTableColumnIdx;
    AutoFitSingleColumn: ImGuiTableColumnIdx;
    ResizedColumn: ImGuiTableColumnIdx;
    LastResizedColumn: ImGuiTableColumnIdx;
    HeldHeaderColumn: ImGuiTableColumnIdx;
    ReorderColumn: ImGuiTableColumnIdx;
    ReorderColumnDir: ImGuiTableColumnIdx;
    LeftMostEnabledColumn: ImGuiTableColumnIdx;
    RightMostEnabledColumn: ImGuiTableColumnIdx;
    LeftMostStretchedColumn: ImGuiTableColumnIdx;
    RightMostStretchedColumn: ImGuiTableColumnIdx;
    ContextPopupColumn: ImGuiTableColumnIdx;
    FreezeRowsRequest: ImGuiTableColumnIdx;
    FreezeRowsCount: ImGuiTableColumnIdx;
    FreezeColumnsRequest: ImGuiTableColumnIdx;
    FreezeColumnsCount: ImGuiTableColumnIdx;
    RowCellDataCurrent: ImGuiTableColumnIdx;
    DummyDrawChannel: ImGuiTableDrawChannelIdx;
    Bg2DrawChannelCurrent: ImGuiTableDrawChannelIdx;
    Bg2DrawChannelUnfrozen: ImGuiTableDrawChannelIdx;
    NavLayer: ImS8;
    IsLayoutLocked: Boolean;
    IsInsideRow: Boolean;
    IsInitializing: Boolean;
    IsSortSpecsDirty: Boolean;
    IsUsingHeaders: Boolean;
    IsContextPopupOpen: Boolean;
    DisableDefaultContextMenu: Boolean;
    IsSettingsRequestLoad: Boolean;
    IsSettingsDirty: Boolean;
    IsDefaultDisplayOrder: Boolean;
    IsResetAllRequest: Boolean;
    IsResetDisplayOrderRequest: Boolean;
    IsUnfrozenRows: Boolean;
    IsDefaultSizingPolicy: Boolean;
    IsActiveIdAliveBeforeTable: Boolean;
    IsActiveIdInTable: Boolean;
    HasScrollbarYCurr: Boolean;
    HasScrollbarYPrev: Boolean;
    MemoryCompacted: Boolean;
    HostSkipItems: Boolean;
  end;

  ImVector_ImGuiTableHeaderData = record
    Size: Integer;
    Capacity: Integer;
    Data: PImGuiTableHeaderData;
  end;

  ImGuiTableTempData = record
    TableIndex: Integer;
    LastTimeActive: Single;
    AngledHeadersExtraWidth: Single;
    AngledHeadersRequests: ImVector_ImGuiTableHeaderData;
    UserOuterSize: ImVec2;
    DrawSplitter: ImDrawListSplitter;
    HostBackupWorkRect: ImRect;
    HostBackupParentWorkRect: ImRect;
    HostBackupPrevLineSize: ImVec2;
    HostBackupCurrLineSize: ImVec2;
    HostBackupCursorMaxPos: ImVec2;
    HostBackupColumnsOffset: ImVec1;
    HostBackupItemWidth: Single;
    HostBackupItemWidthStackSize: Integer;
  end;

  ImGuiTableColumnSettings = record
    WidthOrWeight: Single;
    UserID: ImGuiID;
    Index: ImGuiTableColumnIdx;
    DisplayOrder: ImGuiTableColumnIdx;
    SortOrder: ImGuiTableColumnIdx;
  private
    Data0: Cardinal;
    function GetData0Value(const AIndex: Integer): Cardinal;
    procedure SetData0Value(const AIndex: Integer; const AValue: Cardinal);
  public
    property SortDirection: Cardinal index $2 read GetData0Value write SetData0Value; // 2 bits at offset 0 in Data0
    property IsEnabled: Cardinal index $202 read GetData0Value write SetData0Value; // 2 bits at offset 2 in Data0
    property IsStretch: Cardinal index $401 read GetData0Value write SetData0Value; // 1 bits at offset 4 in Data0
  end;

  ImGuiTableSettings = record
    ID: ImGuiID;
    SaveFlags: ImGuiTableFlags;
    RefScale: Single;
    ColumnsCount: ImGuiTableColumnIdx;
    ColumnsCountMax: ImGuiTableColumnIdx;
    WantApply: Boolean;
  end;

  ImFontBuilderIO = record
    FontBuilder_Build: function(atlas: PImFontAtlas): Boolean; cdecl;
  end;

const
  PLM_DEMUX_PACKET_PRIVATE: Integer = $BD;
  PLM_DEMUX_PACKET_AUDIO_1: Integer = $C0;
  PLM_DEMUX_PACKET_AUDIO_2: Integer = $C1;
  PLM_DEMUX_PACKET_AUDIO_3: Integer = $C2;
  PLM_DEMUX_PACKET_AUDIO_4: Integer = $C3;
  PLM_DEMUX_PACKET_VIDEO_1: Integer = $E0;

type
  sqlite3_exec_callback = function(p1: Pointer; p2: Integer; p3: PPUTF8Char; p4: PPUTF8Char): Integer; cdecl;

type
  sqlite3_busy_handler_ = function(p1: Pointer; p2: Integer): Integer; cdecl;

type
  sqlite3_set_authorizer_xAuth = function(p1: Pointer; p2: Integer; const p3: PUTF8Char; const p4: PUTF8Char; const p5: PUTF8Char; const p6: PUTF8Char): Integer; cdecl;

type
  sqlite3_trace_xTrace = procedure(p1: Pointer; const p2: PUTF8Char); cdecl;

type
  sqlite3_profile_xProfile = procedure(p1: Pointer; const p2: PUTF8Char; p3: sqlite3_uint64); cdecl;

type
  sqlite3_trace_v2_xCallback = function(p1: Cardinal; p2: Pointer; p3: Pointer; p4: Pointer): Integer; cdecl;

type
  sqlite3_progress_handler_ = function(p1: Pointer): Integer; cdecl;

type
  sqlite3_bind_blob_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_blob64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text16_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_pointer_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_function_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function16_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function16_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function16_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function_v2_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_v2_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_v2_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_window_function_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_window_function_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_window_function_xValue = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_window_function_xInverse = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_window_function_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_memory_alarm_ = procedure(p1: Pointer; p2: sqlite3_int64; p3: Integer); cdecl;

type
  sqlite3_set_auxdata_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_set_clientdata_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_blob_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_blob64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16le_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16be_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_pointer_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_collation_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_create_collation_v2_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_create_collation_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_collation16_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_collation_needed_ = procedure(p1: Pointer; p2: Psqlite3; eTextRep: Integer; const p4: PUTF8Char); cdecl;

type
  sqlite3_collation_needed16_ = procedure(p1: Pointer; p2: Psqlite3; eTextRep: Integer; const p4: Pointer); cdecl;

type
  sqlite3_commit_hook_ = function(p1: Pointer): Integer; cdecl;

type
  sqlite3_rollback_hook_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_autovacuum_pages_1 = function(p1: Pointer; const p2: PUTF8Char; p3: Cardinal; p4: Cardinal; p5: Cardinal): Cardinal; cdecl;

type
  sqlite3_autovacuum_pages_2 = procedure(p1: Pointer); cdecl;

type
  sqlite3_update_hook_ = procedure(p1: Pointer; p2: Integer; const p3: PUTF8Char; const p4: PUTF8Char; p5: sqlite3_int64); cdecl;

type
  sqlite3_auto_extension_xEntryPoint = procedure(); cdecl;

type
  sqlite3_cancel_auto_extension_xEntryPoint = procedure(); cdecl;

type
  sqlite3_create_module_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_wal_hook_ = function(p1: Pointer; p2: Psqlite3; const p3: PUTF8Char; p4: Integer): Integer; cdecl;

type
  igCombo_FnStrPtr_getter = function(user_data: Pointer; idx: Integer): PUTF8Char; cdecl;

type
  igListBox_FnStrPtr_getter = function(user_data: Pointer; idx: Integer): PUTF8Char; cdecl;

type
  igPlotLines_FnFloatPtr_values_getter = function(data: Pointer; idx: Integer): Single; cdecl;

type
  igPlotHistogram_FnFloatPtr_values_getter = function(data: Pointer; idx: Integer): Single; cdecl;

type
  igImQsort_compare_func = function(const p1: Pointer; const p2: Pointer): Integer; cdecl;

type
  igTypingSelectFindMatch_get_item_name_func = function(p1: Pointer; p2: Integer): PUTF8Char; cdecl;

type
  igTypingSelectFindNextSingleCharMatch_get_item_name_func = function(p1: Pointer; p2: Integer): PUTF8Char; cdecl;

type
  igTypingSelectFindBestLeadingMatch_get_item_name_func = function(p1: Pointer; p2: Integer): PUTF8Char; cdecl;

type
  igPlotEx_values_getter = function(data: Pointer; idx: Integer): Single; cdecl;

type
  ImGuiPlatformIO_Set_Platform_GetWindowPos_user_callback = procedure(vp: PImGuiViewport; out_pos: PImVec2); cdecl;

type
  ImGuiPlatformIO_Set_Platform_GetWindowSize_user_callback = procedure(vp: PImGuiViewport; out_size: PImVec2); cdecl;

var
  x_net_init: function(): Boolean; cdecl;
  x_net_shutdown: procedure(); cdecl;
  x_net_socket_is_valid: function(sock: XSocket): Boolean; cdecl;
  x_net_close: procedure(sock: XSocket); cdecl;
  x_net_set_nonblocking: function(sock: XSocket; nonblocking: Int32): Int32; cdecl;
  x_net_socket: function(family: XAddressFamily; &type: XSocketType): XSocket; cdecl;
  x_net_socket_tcp4: function(): XSocket; cdecl;
  x_net_socket_tcp6: function(): XSocket; cdecl;
  x_net_socket_udp4: function(): XSocket; cdecl;
  x_net_socket_udp6: function(): XSocket; cdecl;
  x_net_bind: function(sock: XSocket; const addr: PXAddress): Boolean; cdecl;
  x_net_bind_any: function(sock: XSocket; family: XAddressFamily; port: UInt16): Boolean; cdecl;
  x_net_bind_any_udp: function(sock: XSocket): Boolean; cdecl;
  x_net_bind_any_udp6: function(sock: XSocket): Boolean; cdecl;
  x_net_listen: function(sock: XSocket; backlog: Int32): Boolean; cdecl;
  x_net_accept: function(sock: XSocket; out_addr: PXAddress): XSocket; cdecl;
  x_net_connect: function(sock: XSocket; const addr: PXAddress): Int32; cdecl;
  x_net_send: function(sock: XSocket; const buf: Pointer; len: NativeUInt): NativeUInt; cdecl;
  x_net_recv: function(sock: XSocket; buf: Pointer; len: NativeUInt): NativeUInt; cdecl;
  x_net_sendto: function(sock: XSocket; const buf: Pointer; len: NativeUInt; const addr: PXAddress): NativeUInt; cdecl;
  x_net_recvfrom: function(sock: XSocket; buf: Pointer; len: NativeUInt; out_addr: PXAddress): NativeUInt; cdecl;
  x_net_select: function(read_sockets: PXSocket; read_count: Int32; timeout_ms: Int32): Int32; cdecl;
  x_net_poll: function(sock: XSocket; events: Int32; timeout_ms: Int32): Int32; cdecl;
  x_net_resolve: function(const host: PInt8; const port: PInt8; family: XAddressFamily; out_addr: PXAddress): Boolean; cdecl;
  x_net_parse_ip: function(family: XAddressFamily; const ip: PInt8; out_addr: Pointer): Int32; cdecl;
  x_net_format_address: function(const addr: PXAddress; out_str: PUTF8Char; maxlen: Int32): Int32; cdecl;
  x_net_address_clear: procedure(addr: PXAddress); cdecl;
  x_net_address_any: procedure(out_addr: PXAddress; family: Int32; port: UInt16); cdecl;
  x_net_address_from_ip_port: function(const ip: PInt8; port: UInt16; out_addr: PXAddress): Int32; cdecl;
  x_net_address_equal: function(const a: PXAddress; const b: PXAddress): Int32; cdecl;
  x_net_address_to_string: function(const addr: PXAddress; buf: PUTF8Char; buf_len: Int32): Int32; cdecl;
  x_net_dns_resolve: function(const hostname: PInt8; family: XAddressFamily; out_addr: PXAddress): Int32; cdecl;
  x_net_join_multicast_ipv4: function(sock: XSocket; const group: PInt8): Boolean; cdecl;
  x_net_leave_multicast_ipv4: function(sock: XSocket; const group: PInt8): Boolean; cdecl;
  x_net_join_multicast_ipv6: function(sock: XSocket; const multicast_ip: PInt8; ifindex: UInt32): Boolean; cdecl;
  x_net_leave_multicast_ipv6: function(sock: XSocket; const multicast_ip: PInt8; ifindex: UInt32): Boolean; cdecl;
  x_net_join_multicast_ipv4_addr: function(sock: XSocket; const group_addr: PXAddress): Boolean; cdecl;
  x_net_leave_multicast_ipv4_addr: function(sock: XSocket; const group_addr: PXAddress): Boolean; cdecl;
  x_net_enable_broadcast: function(sock: XSocket; enable: Boolean): Boolean; cdecl;
  x_net_get_adapter_count: function(): Int32; cdecl;
  x_net_list_adapters: function(out_adapters: PXNetAdapter; max_adapters: Int32): Int32; cdecl;
  x_net_get_adapter_info: function(const name: PInt8; out_info: PXNetAdapterInfo): Boolean; cdecl;
  x_net_get_last_error: function(): Int32; cdecl;
  x_net_get_last_error_message: function(buf: PUTF8Char; buf_len: Int32): Int32; cdecl;
  glfwInit: function(): Integer; cdecl;
  glfwTerminate: procedure(); cdecl;
  glfwInitHint: procedure(hint: Integer; value: Integer); cdecl;
  glfwInitAllocator: procedure(const allocator: PGLFWallocator); cdecl;
  glfwGetVersion: procedure(major: PInteger; minor: PInteger; rev: PInteger); cdecl;
  glfwGetVersionString: function(): PUTF8Char; cdecl;
  glfwGetError: function(description: PPUTF8Char): Integer; cdecl;
  glfwSetErrorCallback: function(callback: GLFWerrorfun): GLFWerrorfun; cdecl;
  glfwGetPlatform: function(): Integer; cdecl;
  glfwPlatformSupported: function(&platform: Integer): Integer; cdecl;
  glfwGetMonitors: function(count: PInteger): PPGLFWmonitor; cdecl;
  glfwGetPrimaryMonitor: function(): PGLFWmonitor; cdecl;
  glfwGetMonitorPos: procedure(monitor: PGLFWmonitor; xpos: PInteger; ypos: PInteger); cdecl;
  glfwGetMonitorWorkarea: procedure(monitor: PGLFWmonitor; xpos: PInteger; ypos: PInteger; width: PInteger; height: PInteger); cdecl;
  glfwGetMonitorPhysicalSize: procedure(monitor: PGLFWmonitor; widthMM: PInteger; heightMM: PInteger); cdecl;
  glfwGetMonitorContentScale: procedure(monitor: PGLFWmonitor; xscale: PSingle; yscale: PSingle); cdecl;
  glfwGetMonitorName: function(monitor: PGLFWmonitor): PUTF8Char; cdecl;
  glfwSetMonitorUserPointer: procedure(monitor: PGLFWmonitor; pointer: Pointer); cdecl;
  glfwGetMonitorUserPointer: function(monitor: PGLFWmonitor): Pointer; cdecl;
  glfwSetMonitorCallback: function(callback: GLFWmonitorfun): GLFWmonitorfun; cdecl;
  glfwGetVideoModes: function(monitor: PGLFWmonitor; count: PInteger): PGLFWvidmode; cdecl;
  glfwGetVideoMode: function(monitor: PGLFWmonitor): PGLFWvidmode; cdecl;
  glfwSetGamma: procedure(monitor: PGLFWmonitor; gamma: Single); cdecl;
  glfwGetGammaRamp: function(monitor: PGLFWmonitor): PGLFWgammaramp; cdecl;
  glfwSetGammaRamp: procedure(monitor: PGLFWmonitor; const ramp: PGLFWgammaramp); cdecl;
  glfwDefaultWindowHints: procedure(); cdecl;
  glfwWindowHint: procedure(hint: Integer; value: Integer); cdecl;
  glfwWindowHintString: procedure(hint: Integer; const value: PUTF8Char); cdecl;
  glfwCreateWindow: function(width: Integer; height: Integer; const title: PUTF8Char; monitor: PGLFWmonitor; share: PGLFWwindow): PGLFWwindow; cdecl;
  glfwDestroyWindow: procedure(window: PGLFWwindow); cdecl;
  glfwWindowShouldClose: function(window: PGLFWwindow): Integer; cdecl;
  glfwSetWindowShouldClose: procedure(window: PGLFWwindow; value: Integer); cdecl;
  glfwGetWindowTitle: function(window: PGLFWwindow): PUTF8Char; cdecl;
  glfwSetWindowTitle: procedure(window: PGLFWwindow; const title: PUTF8Char); cdecl;
  glfwSetWindowIcon: procedure(window: PGLFWwindow; count: Integer; const images: PGLFWimage); cdecl;
  glfwGetWindowPos: procedure(window: PGLFWwindow; xpos: PInteger; ypos: PInteger); cdecl;
  glfwSetWindowPos: procedure(window: PGLFWwindow; xpos: Integer; ypos: Integer); cdecl;
  glfwGetWindowSize: procedure(window: PGLFWwindow; width: PInteger; height: PInteger); cdecl;
  glfwSetWindowSizeLimits: procedure(window: PGLFWwindow; minwidth: Integer; minheight: Integer; maxwidth: Integer; maxheight: Integer); cdecl;
  glfwSetWindowAspectRatio: procedure(window: PGLFWwindow; numer: Integer; denom: Integer); cdecl;
  glfwSetWindowSize: procedure(window: PGLFWwindow; width: Integer; height: Integer); cdecl;
  glfwGetFramebufferSize: procedure(window: PGLFWwindow; width: PInteger; height: PInteger); cdecl;
  glfwGetWindowFrameSize: procedure(window: PGLFWwindow; left: PInteger; top: PInteger; right: PInteger; bottom: PInteger); cdecl;
  glfwGetWindowContentScale: procedure(window: PGLFWwindow; xscale: PSingle; yscale: PSingle); cdecl;
  glfwGetWindowOpacity: function(window: PGLFWwindow): Single; cdecl;
  glfwSetWindowOpacity: procedure(window: PGLFWwindow; opacity: Single); cdecl;
  glfwIconifyWindow: procedure(window: PGLFWwindow); cdecl;
  glfwRestoreWindow: procedure(window: PGLFWwindow); cdecl;
  glfwMaximizeWindow: procedure(window: PGLFWwindow); cdecl;
  glfwShowWindow: procedure(window: PGLFWwindow); cdecl;
  glfwHideWindow: procedure(window: PGLFWwindow); cdecl;
  glfwFocusWindow: procedure(window: PGLFWwindow); cdecl;
  glfwRequestWindowAttention: procedure(window: PGLFWwindow); cdecl;
  glfwGetWindowMonitor: function(window: PGLFWwindow): PGLFWmonitor; cdecl;
  glfwSetWindowMonitor: procedure(window: PGLFWwindow; monitor: PGLFWmonitor; xpos: Integer; ypos: Integer; width: Integer; height: Integer; refreshRate: Integer); cdecl;
  glfwGetWindowAttrib: function(window: PGLFWwindow; attrib: Integer): Integer; cdecl;
  glfwSetWindowAttrib: procedure(window: PGLFWwindow; attrib: Integer; value: Integer); cdecl;
  glfwSetWindowUserPointer: procedure(window: PGLFWwindow; pointer: Pointer); cdecl;
  glfwGetWindowUserPointer: function(window: PGLFWwindow): Pointer; cdecl;
  glfwSetWindowPosCallback: function(window: PGLFWwindow; callback: GLFWwindowposfun): GLFWwindowposfun; cdecl;
  glfwSetWindowSizeCallback: function(window: PGLFWwindow; callback: GLFWwindowsizefun): GLFWwindowsizefun; cdecl;
  glfwSetWindowCloseCallback: function(window: PGLFWwindow; callback: GLFWwindowclosefun): GLFWwindowclosefun; cdecl;
  glfwSetWindowRefreshCallback: function(window: PGLFWwindow; callback: GLFWwindowrefreshfun): GLFWwindowrefreshfun; cdecl;
  glfwSetWindowFocusCallback: function(window: PGLFWwindow; callback: GLFWwindowfocusfun): GLFWwindowfocusfun; cdecl;
  glfwSetWindowIconifyCallback: function(window: PGLFWwindow; callback: GLFWwindowiconifyfun): GLFWwindowiconifyfun; cdecl;
  glfwSetWindowMaximizeCallback: function(window: PGLFWwindow; callback: GLFWwindowmaximizefun): GLFWwindowmaximizefun; cdecl;
  glfwSetFramebufferSizeCallback: function(window: PGLFWwindow; callback: GLFWframebuffersizefun): GLFWframebuffersizefun; cdecl;
  glfwSetWindowContentScaleCallback: function(window: PGLFWwindow; callback: GLFWwindowcontentscalefun): GLFWwindowcontentscalefun; cdecl;
  glfwPollEvents: procedure(); cdecl;
  glfwWaitEvents: procedure(); cdecl;
  glfwWaitEventsTimeout: procedure(timeout: Double); cdecl;
  glfwPostEmptyEvent: procedure(); cdecl;
  glfwGetInputMode: function(window: PGLFWwindow; mode: Integer): Integer; cdecl;
  glfwSetInputMode: procedure(window: PGLFWwindow; mode: Integer; value: Integer); cdecl;
  glfwRawMouseMotionSupported: function(): Integer; cdecl;
  glfwGetKeyName: function(key: Integer; scancode: Integer): PUTF8Char; cdecl;
  glfwGetKeyScancode: function(key: Integer): Integer; cdecl;
  glfwGetKey: function(window: PGLFWwindow; key: Integer): Integer; cdecl;
  glfwGetMouseButton: function(window: PGLFWwindow; button: Integer): Integer; cdecl;
  glfwGetCursorPos: procedure(window: PGLFWwindow; xpos: PDouble; ypos: PDouble); cdecl;
  glfwSetCursorPos: procedure(window: PGLFWwindow; xpos: Double; ypos: Double); cdecl;
  glfwCreateCursor: function(const image: PGLFWimage; xhot: Integer; yhot: Integer): PGLFWcursor; cdecl;
  glfwCreateStandardCursor: function(shape: Integer): PGLFWcursor; cdecl;
  glfwDestroyCursor: procedure(cursor: PGLFWcursor); cdecl;
  glfwSetCursor: procedure(window: PGLFWwindow; cursor: PGLFWcursor); cdecl;
  glfwSetKeyCallback: function(window: PGLFWwindow; callback: GLFWkeyfun): GLFWkeyfun; cdecl;
  glfwSetCharCallback: function(window: PGLFWwindow; callback: GLFWcharfun): GLFWcharfun; cdecl;
  glfwSetCharModsCallback: function(window: PGLFWwindow; callback: GLFWcharmodsfun): GLFWcharmodsfun; cdecl;
  glfwSetMouseButtonCallback: function(window: PGLFWwindow; callback: GLFWmousebuttonfun): GLFWmousebuttonfun; cdecl;
  glfwSetCursorPosCallback: function(window: PGLFWwindow; callback: GLFWcursorposfun): GLFWcursorposfun; cdecl;
  glfwSetCursorEnterCallback: function(window: PGLFWwindow; callback: GLFWcursorenterfun): GLFWcursorenterfun; cdecl;
  glfwSetScrollCallback: function(window: PGLFWwindow; callback: GLFWscrollfun): GLFWscrollfun; cdecl;
  glfwSetDropCallback: function(window: PGLFWwindow; callback: GLFWdropfun): GLFWdropfun; cdecl;
  glfwJoystickPresent: function(jid: Integer): Integer; cdecl;
  glfwGetJoystickAxes: function(jid: Integer; count: PInteger): PSingle; cdecl;
  glfwGetJoystickButtons: function(jid: Integer; count: PInteger): PByte; cdecl;
  glfwGetJoystickHats: function(jid: Integer; count: PInteger): PByte; cdecl;
  glfwGetJoystickName: function(jid: Integer): PUTF8Char; cdecl;
  glfwGetJoystickGUID: function(jid: Integer): PUTF8Char; cdecl;
  glfwSetJoystickUserPointer: procedure(jid: Integer; pointer: Pointer); cdecl;
  glfwGetJoystickUserPointer: function(jid: Integer): Pointer; cdecl;
  glfwJoystickIsGamepad: function(jid: Integer): Integer; cdecl;
  glfwSetJoystickCallback: function(callback: GLFWjoystickfun): GLFWjoystickfun; cdecl;
  glfwUpdateGamepadMappings: function(const &string: PUTF8Char): Integer; cdecl;
  glfwGetGamepadName: function(jid: Integer): PUTF8Char; cdecl;
  glfwGetGamepadState: function(jid: Integer; state: PGLFWgamepadstate): Integer; cdecl;
  glfwSetClipboardString: procedure(window: PGLFWwindow; const &string: PUTF8Char); cdecl;
  glfwGetClipboardString: function(window: PGLFWwindow): PUTF8Char; cdecl;
  glfwGetTime: function(): Double; cdecl;
  glfwSetTime: procedure(time: Double); cdecl;
  glfwGetTimerValue: function(): UInt64; cdecl;
  glfwGetTimerFrequency: function(): UInt64; cdecl;
  glfwMakeContextCurrent: procedure(window: PGLFWwindow); cdecl;
  glfwGetCurrentContext: function(): PGLFWwindow; cdecl;
  glfwSwapBuffers: procedure(window: PGLFWwindow); cdecl;
  glfwSwapInterval: procedure(interval: Integer); cdecl;
  glfwExtensionSupported: function(const extension: PUTF8Char): Integer; cdecl;
  glfwGetProcAddress: function(const procname: PUTF8Char): GLFWglproc; cdecl;
  glfwVulkanSupported: function(): Integer; cdecl;
  glfwGetRequiredInstanceExtensions: function(count: PUInt32): PPUTF8Char; cdecl;
  glfwGetWin32Adapter: function(monitor: PGLFWmonitor): PUTF8Char; cdecl;
  glfwGetWin32Monitor: function(monitor: PGLFWmonitor): PUTF8Char; cdecl;
  glfwGetWin32Window: function(window: PGLFWwindow): HWND; cdecl;
  crc32: function(crc: uLong; const buf: PBytef; len: uInt): uLong; cdecl;
  unzOpen64: function(const path: Pointer): unzFile; cdecl;
  unzLocateFile: function(&file: unzFile; const szFileName: PUTF8Char; iCaseSensitivity: Integer): Integer; cdecl;
  unzClose: function(&file: unzFile): Integer; cdecl;
  unzOpenCurrentFilePassword: function(&file: unzFile; const password: PUTF8Char): Integer; cdecl;
  unzGetCurrentFileInfo64: function(&file: unzFile; pfile_info: Punz_file_info64; szFileName: PUTF8Char; fileNameBufferSize: uLong; extraField: Pointer; extraFieldBufferSize: uLong; szComment: PUTF8Char; commentBufferSize: uLong): Integer; cdecl;
  unzReadCurrentFile: function(&file: unzFile; buf: voidp; len: Cardinal): Integer; cdecl;
  unzCloseCurrentFile: function(&file: unzFile): Integer; cdecl;
  unztell64: function(&file: unzFile): UInt64; cdecl;
  zipOpen64: function(const pathname: Pointer; append: Integer): zipFile; cdecl;
  zipOpenNewFileInZip3_64: function(&file: zipFile; const filename: PUTF8Char; const zipfi: Pzip_fileinfo; const extrafield_local: Pointer; size_extrafield_local: uInt; const extrafield_global: Pointer; size_extrafield_global: uInt; const comment: PUTF8Char; method: Integer; level: Integer; raw: Integer; windowBits: Integer; memLevel: Integer; strategy: Integer; const password: PUTF8Char; crcForCrypting: uLong; zip64: Integer): Integer; cdecl;
  zipWriteInFileInZip: function(&file: zipFile; const buf: Pointer; len: Cardinal): Integer; cdecl;
  zipCloseFileInZip: function(&file: zipFile): Integer; cdecl;
  zipClose: function(&file: zipFile; const global_comment: PUTF8Char): Integer; cdecl;
  initGL: function(): Integer; cdecl;
  c2CircletoCircle: function(A: c2Circle; B: c2Circle): Integer; cdecl;
  c2CircletoAABB: function(A: c2Circle; B: c2AABB): Integer; cdecl;
  c2CircletoCapsule: function(A: c2Circle; B: c2Capsule): Integer; cdecl;
  c2AABBtoAABB: function(A: c2AABB; B: c2AABB): Integer; cdecl;
  c2AABBtoCapsule: function(A: c2AABB; B: c2Capsule): Integer; cdecl;
  c2CapsuletoCapsule: function(A: c2Capsule; B: c2Capsule): Integer; cdecl;
  c2CircletoPoly: function(A: c2Circle; const B: Pc2Poly; const bx: Pc2x): Integer; cdecl;
  c2AABBtoPoly: function(A: c2AABB; const B: Pc2Poly; const bx: Pc2x): Integer; cdecl;
  c2CapsuletoPoly: function(A: c2Capsule; const B: Pc2Poly; const bx: Pc2x): Integer; cdecl;
  c2PolytoPoly: function(const A: Pc2Poly; const ax: Pc2x; const B: Pc2Poly; const bx: Pc2x): Integer; cdecl;
  c2RaytoCircle: function(A: c2Ray; B: c2Circle; &out: Pc2Raycast): Integer; cdecl;
  c2RaytoAABB: function(A: c2Ray; B: c2AABB; &out: Pc2Raycast): Integer; cdecl;
  c2RaytoCapsule: function(A: c2Ray; B: c2Capsule; &out: Pc2Raycast): Integer; cdecl;
  c2RaytoPoly: function(A: c2Ray; const B: Pc2Poly; const bx_ptr: Pc2x; &out: Pc2Raycast): Integer; cdecl;
  c2CircletoCircleManifold: procedure(A: c2Circle; B: c2Circle; m: Pc2Manifold); cdecl;
  c2CircletoAABBManifold: procedure(A: c2Circle; B: c2AABB; m: Pc2Manifold); cdecl;
  c2CircletoCapsuleManifold: procedure(A: c2Circle; B: c2Capsule; m: Pc2Manifold); cdecl;
  c2AABBtoAABBManifold: procedure(A: c2AABB; B: c2AABB; m: Pc2Manifold); cdecl;
  c2AABBtoCapsuleManifold: procedure(A: c2AABB; B: c2Capsule; m: Pc2Manifold); cdecl;
  c2CapsuletoCapsuleManifold: procedure(A: c2Capsule; B: c2Capsule; m: Pc2Manifold); cdecl;
  c2CircletoPolyManifold: procedure(A: c2Circle; const B: Pc2Poly; const bx: Pc2x; m: Pc2Manifold); cdecl;
  c2AABBtoPolyManifold: procedure(A: c2AABB; const B: Pc2Poly; const bx: Pc2x; m: Pc2Manifold); cdecl;
  c2CapsuletoPolyManifold: procedure(A: c2Capsule; const B: Pc2Poly; const bx: Pc2x; m: Pc2Manifold); cdecl;
  c2PolytoPolyManifold: procedure(const A: Pc2Poly; const ax: Pc2x; const B: Pc2Poly; const bx: Pc2x; m: Pc2Manifold); cdecl;
  c2GJK: function(const A: Pointer; typeA: C2_TYPE; const ax_ptr: Pc2x; const B: Pointer; typeB: C2_TYPE; const bx_ptr: Pc2x; outA: Pc2v; outB: Pc2v; use_radius: Integer; iterations: PInteger; cache: Pc2GJKCache): Single; cdecl;
  c2TOI: function(const A: Pointer; typeA: C2_TYPE; const ax_ptr: Pc2x; vA: c2v; const B: Pointer; typeB: C2_TYPE; const bx_ptr: Pc2x; vB: c2v; use_radius: Integer): c2TOIResult; cdecl;
  c2Inflate: procedure(shape: Pointer; &type: C2_TYPE; skin_factor: Single); cdecl;
  c2Hull: function(verts: Pc2v; count: Integer): Integer; cdecl;
  c2Norms: procedure(verts: Pc2v; norms: Pc2v; count: Integer); cdecl;
  c2MakePoly: procedure(p: Pc2Poly); cdecl;
  c2Collided: function(const A: Pointer; const ax: Pc2x; typeA: C2_TYPE; const B: Pointer; const bx: Pc2x; typeB: C2_TYPE): Integer; cdecl;
  c2Collide: procedure(const A: Pointer; const ax: Pc2x; typeA: C2_TYPE; const B: Pointer; const bx: Pc2x; typeB: C2_TYPE; m: Pc2Manifold); cdecl;
  c2CastRay: function(A: c2Ray; const B: Pointer; const bx: Pc2x; typeB: C2_TYPE; &out: Pc2Raycast): Integer; cdecl;
  ma_version: procedure(pMajor: Pma_uint32; pMinor: Pma_uint32; pRevision: Pma_uint32); cdecl;
  ma_version_string: function(): PUTF8Char; cdecl;
  ma_log_callback_init: function(onLog: ma_log_callback_proc; pUserData: Pointer): ma_log_callback; cdecl;
  ma_log_init: function(const pAllocationCallbacks: Pma_allocation_callbacks; pLog: Pma_log): ma_result; cdecl;
  ma_log_uninit: procedure(pLog: Pma_log); cdecl;
  ma_log_register_callback: function(pLog: Pma_log; callback: ma_log_callback): ma_result; cdecl;
  ma_log_unregister_callback: function(pLog: Pma_log; callback: ma_log_callback): ma_result; cdecl;
  ma_log_post: function(pLog: Pma_log; level: ma_uint32; const pMessage: PUTF8Char): ma_result; cdecl;
  ma_log_postv: function(pLog: Pma_log; level: ma_uint32; const pFormat: PUTF8Char; args: Pointer): ma_result; cdecl;
  ma_log_postf: function(pLog: Pma_log; level: ma_uint32; const pFormat: PUTF8Char): ma_result varargs; cdecl;
  ma_biquad_config_init: function(format: ma_format; channels: ma_uint32; b0: Double; b1: Double; b2: Double; a0: Double; a1: Double; a2: Double): ma_biquad_config; cdecl;
  ma_biquad_get_heap_size: function(const pConfig: Pma_biquad_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_biquad_init_preallocated: function(const pConfig: Pma_biquad_config; pHeap: Pointer; pBQ: Pma_biquad): ma_result; cdecl;
  ma_biquad_init: function(const pConfig: Pma_biquad_config; const pAllocationCallbacks: Pma_allocation_callbacks; pBQ: Pma_biquad): ma_result; cdecl;
  ma_biquad_uninit: procedure(pBQ: Pma_biquad; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_biquad_reinit: function(const pConfig: Pma_biquad_config; pBQ: Pma_biquad): ma_result; cdecl;
  ma_biquad_clear_cache: function(pBQ: Pma_biquad): ma_result; cdecl;
  ma_biquad_process_pcm_frames: function(pBQ: Pma_biquad; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_biquad_get_latency: function(const pBQ: Pma_biquad): ma_uint32; cdecl;
  ma_lpf1_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double): ma_lpf1_config; cdecl;
  ma_lpf2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; q: Double): ma_lpf2_config; cdecl;
  ma_lpf1_get_heap_size: function(const pConfig: Pma_lpf1_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_lpf1_init_preallocated: function(const pConfig: Pma_lpf1_config; pHeap: Pointer; pLPF: Pma_lpf1): ma_result; cdecl;
  ma_lpf1_init: function(const pConfig: Pma_lpf1_config; const pAllocationCallbacks: Pma_allocation_callbacks; pLPF: Pma_lpf1): ma_result; cdecl;
  ma_lpf1_uninit: procedure(pLPF: Pma_lpf1; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_lpf1_reinit: function(const pConfig: Pma_lpf1_config; pLPF: Pma_lpf1): ma_result; cdecl;
  ma_lpf1_clear_cache: function(pLPF: Pma_lpf1): ma_result; cdecl;
  ma_lpf1_process_pcm_frames: function(pLPF: Pma_lpf1; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_lpf1_get_latency: function(const pLPF: Pma_lpf1): ma_uint32; cdecl;
  ma_lpf2_get_heap_size: function(const pConfig: Pma_lpf2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_lpf2_init_preallocated: function(const pConfig: Pma_lpf2_config; pHeap: Pointer; pHPF: Pma_lpf2): ma_result; cdecl;
  ma_lpf2_init: function(const pConfig: Pma_lpf2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pLPF: Pma_lpf2): ma_result; cdecl;
  ma_lpf2_uninit: procedure(pLPF: Pma_lpf2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_lpf2_reinit: function(const pConfig: Pma_lpf2_config; pLPF: Pma_lpf2): ma_result; cdecl;
  ma_lpf2_clear_cache: function(pLPF: Pma_lpf2): ma_result; cdecl;
  ma_lpf2_process_pcm_frames: function(pLPF: Pma_lpf2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_lpf2_get_latency: function(const pLPF: Pma_lpf2): ma_uint32; cdecl;
  ma_lpf_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_lpf_config; cdecl;
  ma_lpf_get_heap_size: function(const pConfig: Pma_lpf_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_lpf_init_preallocated: function(const pConfig: Pma_lpf_config; pHeap: Pointer; pLPF: Pma_lpf): ma_result; cdecl;
  ma_lpf_init: function(const pConfig: Pma_lpf_config; const pAllocationCallbacks: Pma_allocation_callbacks; pLPF: Pma_lpf): ma_result; cdecl;
  ma_lpf_uninit: procedure(pLPF: Pma_lpf; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_lpf_reinit: function(const pConfig: Pma_lpf_config; pLPF: Pma_lpf): ma_result; cdecl;
  ma_lpf_clear_cache: function(pLPF: Pma_lpf): ma_result; cdecl;
  ma_lpf_process_pcm_frames: function(pLPF: Pma_lpf; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_lpf_get_latency: function(const pLPF: Pma_lpf): ma_uint32; cdecl;
  ma_hpf1_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double): ma_hpf1_config; cdecl;
  ma_hpf2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; q: Double): ma_hpf2_config; cdecl;
  ma_hpf1_get_heap_size: function(const pConfig: Pma_hpf1_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_hpf1_init_preallocated: function(const pConfig: Pma_hpf1_config; pHeap: Pointer; pLPF: Pma_hpf1): ma_result; cdecl;
  ma_hpf1_init: function(const pConfig: Pma_hpf1_config; const pAllocationCallbacks: Pma_allocation_callbacks; pHPF: Pma_hpf1): ma_result; cdecl;
  ma_hpf1_uninit: procedure(pHPF: Pma_hpf1; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hpf1_reinit: function(const pConfig: Pma_hpf1_config; pHPF: Pma_hpf1): ma_result; cdecl;
  ma_hpf1_process_pcm_frames: function(pHPF: Pma_hpf1; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_hpf1_get_latency: function(const pHPF: Pma_hpf1): ma_uint32; cdecl;
  ma_hpf2_get_heap_size: function(const pConfig: Pma_hpf2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_hpf2_init_preallocated: function(const pConfig: Pma_hpf2_config; pHeap: Pointer; pHPF: Pma_hpf2): ma_result; cdecl;
  ma_hpf2_init: function(const pConfig: Pma_hpf2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pHPF: Pma_hpf2): ma_result; cdecl;
  ma_hpf2_uninit: procedure(pHPF: Pma_hpf2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hpf2_reinit: function(const pConfig: Pma_hpf2_config; pHPF: Pma_hpf2): ma_result; cdecl;
  ma_hpf2_process_pcm_frames: function(pHPF: Pma_hpf2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_hpf2_get_latency: function(const pHPF: Pma_hpf2): ma_uint32; cdecl;
  ma_hpf_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_hpf_config; cdecl;
  ma_hpf_get_heap_size: function(const pConfig: Pma_hpf_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_hpf_init_preallocated: function(const pConfig: Pma_hpf_config; pHeap: Pointer; pLPF: Pma_hpf): ma_result; cdecl;
  ma_hpf_init: function(const pConfig: Pma_hpf_config; const pAllocationCallbacks: Pma_allocation_callbacks; pHPF: Pma_hpf): ma_result; cdecl;
  ma_hpf_uninit: procedure(pHPF: Pma_hpf; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hpf_reinit: function(const pConfig: Pma_hpf_config; pHPF: Pma_hpf): ma_result; cdecl;
  ma_hpf_process_pcm_frames: function(pHPF: Pma_hpf; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_hpf_get_latency: function(const pHPF: Pma_hpf): ma_uint32; cdecl;
  ma_bpf2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; q: Double): ma_bpf2_config; cdecl;
  ma_bpf2_get_heap_size: function(const pConfig: Pma_bpf2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_bpf2_init_preallocated: function(const pConfig: Pma_bpf2_config; pHeap: Pointer; pBPF: Pma_bpf2): ma_result; cdecl;
  ma_bpf2_init: function(const pConfig: Pma_bpf2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pBPF: Pma_bpf2): ma_result; cdecl;
  ma_bpf2_uninit: procedure(pBPF: Pma_bpf2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_bpf2_reinit: function(const pConfig: Pma_bpf2_config; pBPF: Pma_bpf2): ma_result; cdecl;
  ma_bpf2_process_pcm_frames: function(pBPF: Pma_bpf2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_bpf2_get_latency: function(const pBPF: Pma_bpf2): ma_uint32; cdecl;
  ma_bpf_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_bpf_config; cdecl;
  ma_bpf_get_heap_size: function(const pConfig: Pma_bpf_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_bpf_init_preallocated: function(const pConfig: Pma_bpf_config; pHeap: Pointer; pBPF: Pma_bpf): ma_result; cdecl;
  ma_bpf_init: function(const pConfig: Pma_bpf_config; const pAllocationCallbacks: Pma_allocation_callbacks; pBPF: Pma_bpf): ma_result; cdecl;
  ma_bpf_uninit: procedure(pBPF: Pma_bpf; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_bpf_reinit: function(const pConfig: Pma_bpf_config; pBPF: Pma_bpf): ma_result; cdecl;
  ma_bpf_process_pcm_frames: function(pBPF: Pma_bpf; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_bpf_get_latency: function(const pBPF: Pma_bpf): ma_uint32; cdecl;
  ma_notch2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; q: Double; frequency: Double): ma_notch2_config; cdecl;
  ma_notch2_get_heap_size: function(const pConfig: Pma_notch2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_notch2_init_preallocated: function(const pConfig: Pma_notch2_config; pHeap: Pointer; pFilter: Pma_notch2): ma_result; cdecl;
  ma_notch2_init: function(const pConfig: Pma_notch2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pFilter: Pma_notch2): ma_result; cdecl;
  ma_notch2_uninit: procedure(pFilter: Pma_notch2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_notch2_reinit: function(const pConfig: Pma_notch2_config; pFilter: Pma_notch2): ma_result; cdecl;
  ma_notch2_process_pcm_frames: function(pFilter: Pma_notch2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_notch2_get_latency: function(const pFilter: Pma_notch2): ma_uint32; cdecl;
  ma_peak2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; q: Double; frequency: Double): ma_peak2_config; cdecl;
  ma_peak2_get_heap_size: function(const pConfig: Pma_peak2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_peak2_init_preallocated: function(const pConfig: Pma_peak2_config; pHeap: Pointer; pFilter: Pma_peak2): ma_result; cdecl;
  ma_peak2_init: function(const pConfig: Pma_peak2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pFilter: Pma_peak2): ma_result; cdecl;
  ma_peak2_uninit: procedure(pFilter: Pma_peak2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_peak2_reinit: function(const pConfig: Pma_peak2_config; pFilter: Pma_peak2): ma_result; cdecl;
  ma_peak2_process_pcm_frames: function(pFilter: Pma_peak2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_peak2_get_latency: function(const pFilter: Pma_peak2): ma_uint32; cdecl;
  ma_loshelf2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; shelfSlope: Double; frequency: Double): ma_loshelf2_config; cdecl;
  ma_loshelf2_get_heap_size: function(const pConfig: Pma_loshelf2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_loshelf2_init_preallocated: function(const pConfig: Pma_loshelf2_config; pHeap: Pointer; pFilter: Pma_loshelf2): ma_result; cdecl;
  ma_loshelf2_init: function(const pConfig: Pma_loshelf2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pFilter: Pma_loshelf2): ma_result; cdecl;
  ma_loshelf2_uninit: procedure(pFilter: Pma_loshelf2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_loshelf2_reinit: function(const pConfig: Pma_loshelf2_config; pFilter: Pma_loshelf2): ma_result; cdecl;
  ma_loshelf2_process_pcm_frames: function(pFilter: Pma_loshelf2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_loshelf2_get_latency: function(const pFilter: Pma_loshelf2): ma_uint32; cdecl;
  ma_hishelf2_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; shelfSlope: Double; frequency: Double): ma_hishelf2_config; cdecl;
  ma_hishelf2_get_heap_size: function(const pConfig: Pma_hishelf2_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_hishelf2_init_preallocated: function(const pConfig: Pma_hishelf2_config; pHeap: Pointer; pFilter: Pma_hishelf2): ma_result; cdecl;
  ma_hishelf2_init: function(const pConfig: Pma_hishelf2_config; const pAllocationCallbacks: Pma_allocation_callbacks; pFilter: Pma_hishelf2): ma_result; cdecl;
  ma_hishelf2_uninit: procedure(pFilter: Pma_hishelf2; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hishelf2_reinit: function(const pConfig: Pma_hishelf2_config; pFilter: Pma_hishelf2): ma_result; cdecl;
  ma_hishelf2_process_pcm_frames: function(pFilter: Pma_hishelf2; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_hishelf2_get_latency: function(const pFilter: Pma_hishelf2): ma_uint32; cdecl;
  ma_delay_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; delayInFrames: ma_uint32; decay: Single): ma_delay_config; cdecl;
  ma_delay_init: function(const pConfig: Pma_delay_config; const pAllocationCallbacks: Pma_allocation_callbacks; pDelay: Pma_delay): ma_result; cdecl;
  ma_delay_uninit: procedure(pDelay: Pma_delay; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_delay_process_pcm_frames: function(pDelay: Pma_delay; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint32): ma_result; cdecl;
  ma_delay_set_wet: procedure(pDelay: Pma_delay; value: Single); cdecl;
  ma_delay_get_wet: function(const pDelay: Pma_delay): Single; cdecl;
  ma_delay_set_dry: procedure(pDelay: Pma_delay; value: Single); cdecl;
  ma_delay_get_dry: function(const pDelay: Pma_delay): Single; cdecl;
  ma_delay_set_decay: procedure(pDelay: Pma_delay; value: Single); cdecl;
  ma_delay_get_decay: function(const pDelay: Pma_delay): Single; cdecl;
  ma_gainer_config_init: function(channels: ma_uint32; smoothTimeInFrames: ma_uint32): ma_gainer_config; cdecl;
  ma_gainer_get_heap_size: function(const pConfig: Pma_gainer_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_gainer_init_preallocated: function(const pConfig: Pma_gainer_config; pHeap: Pointer; pGainer: Pma_gainer): ma_result; cdecl;
  ma_gainer_init: function(const pConfig: Pma_gainer_config; const pAllocationCallbacks: Pma_allocation_callbacks; pGainer: Pma_gainer): ma_result; cdecl;
  ma_gainer_uninit: procedure(pGainer: Pma_gainer; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_gainer_process_pcm_frames: function(pGainer: Pma_gainer; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_gainer_set_gain: function(pGainer: Pma_gainer; newGain: Single): ma_result; cdecl;
  ma_gainer_set_gains: function(pGainer: Pma_gainer; pNewGains: PSingle): ma_result; cdecl;
  ma_gainer_set_master_volume: function(pGainer: Pma_gainer; volume: Single): ma_result; cdecl;
  ma_gainer_get_master_volume: function(const pGainer: Pma_gainer; pVolume: PSingle): ma_result; cdecl;
  ma_panner_config_init: function(format: ma_format; channels: ma_uint32): ma_panner_config; cdecl;
  ma_panner_init: function(const pConfig: Pma_panner_config; pPanner: Pma_panner): ma_result; cdecl;
  ma_panner_process_pcm_frames: function(pPanner: Pma_panner; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_panner_set_mode: procedure(pPanner: Pma_panner; mode: ma_pan_mode); cdecl;
  ma_panner_get_mode: function(const pPanner: Pma_panner): ma_pan_mode; cdecl;
  ma_panner_set_pan: procedure(pPanner: Pma_panner; pan: Single); cdecl;
  ma_panner_get_pan: function(const pPanner: Pma_panner): Single; cdecl;
  ma_fader_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32): ma_fader_config; cdecl;
  ma_fader_init: function(const pConfig: Pma_fader_config; pFader: Pma_fader): ma_result; cdecl;
  ma_fader_process_pcm_frames: function(pFader: Pma_fader; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_fader_get_data_format: procedure(const pFader: Pma_fader; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32); cdecl;
  ma_fader_set_fade: procedure(pFader: Pma_fader; volumeBeg: Single; volumeEnd: Single; lengthInFrames: ma_uint64); cdecl;
  ma_fader_set_fade_ex: procedure(pFader: Pma_fader; volumeBeg: Single; volumeEnd: Single; lengthInFrames: ma_uint64; startOffsetInFrames: ma_int64); cdecl;
  ma_fader_get_current_volume: function(const pFader: Pma_fader): Single; cdecl;
  ma_spatializer_listener_config_init: function(channelsOut: ma_uint32): ma_spatializer_listener_config; cdecl;
  ma_spatializer_listener_get_heap_size: function(const pConfig: Pma_spatializer_listener_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_spatializer_listener_init_preallocated: function(const pConfig: Pma_spatializer_listener_config; pHeap: Pointer; pListener: Pma_spatializer_listener): ma_result; cdecl;
  ma_spatializer_listener_init: function(const pConfig: Pma_spatializer_listener_config; const pAllocationCallbacks: Pma_allocation_callbacks; pListener: Pma_spatializer_listener): ma_result; cdecl;
  ma_spatializer_listener_uninit: procedure(pListener: Pma_spatializer_listener; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_spatializer_listener_get_channel_map: function(pListener: Pma_spatializer_listener): Pma_channel; cdecl;
  ma_spatializer_listener_set_cone: procedure(pListener: Pma_spatializer_listener; innerAngleInRadians: Single; outerAngleInRadians: Single; outerGain: Single); cdecl;
  ma_spatializer_listener_get_cone: procedure(const pListener: Pma_spatializer_listener; pInnerAngleInRadians: PSingle; pOuterAngleInRadians: PSingle; pOuterGain: PSingle); cdecl;
  ma_spatializer_listener_set_position: procedure(pListener: Pma_spatializer_listener; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_listener_get_position: function(const pListener: Pma_spatializer_listener): ma_vec3f; cdecl;
  ma_spatializer_listener_set_direction: procedure(pListener: Pma_spatializer_listener; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_listener_get_direction: function(const pListener: Pma_spatializer_listener): ma_vec3f; cdecl;
  ma_spatializer_listener_set_velocity: procedure(pListener: Pma_spatializer_listener; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_listener_get_velocity: function(const pListener: Pma_spatializer_listener): ma_vec3f; cdecl;
  ma_spatializer_listener_set_speed_of_sound: procedure(pListener: Pma_spatializer_listener; speedOfSound: Single); cdecl;
  ma_spatializer_listener_get_speed_of_sound: function(const pListener: Pma_spatializer_listener): Single; cdecl;
  ma_spatializer_listener_set_world_up: procedure(pListener: Pma_spatializer_listener; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_listener_get_world_up: function(const pListener: Pma_spatializer_listener): ma_vec3f; cdecl;
  ma_spatializer_listener_set_enabled: procedure(pListener: Pma_spatializer_listener; isEnabled: ma_bool32); cdecl;
  ma_spatializer_listener_is_enabled: function(const pListener: Pma_spatializer_listener): ma_bool32; cdecl;
  ma_spatializer_config_init: function(channelsIn: ma_uint32; channelsOut: ma_uint32): ma_spatializer_config; cdecl;
  ma_spatializer_get_heap_size: function(const pConfig: Pma_spatializer_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_spatializer_init_preallocated: function(const pConfig: Pma_spatializer_config; pHeap: Pointer; pSpatializer: Pma_spatializer): ma_result; cdecl;
  ma_spatializer_init: function(const pConfig: Pma_spatializer_config; const pAllocationCallbacks: Pma_allocation_callbacks; pSpatializer: Pma_spatializer): ma_result; cdecl;
  ma_spatializer_uninit: procedure(pSpatializer: Pma_spatializer; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_spatializer_process_pcm_frames: function(pSpatializer: Pma_spatializer; pListener: Pma_spatializer_listener; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_spatializer_set_master_volume: function(pSpatializer: Pma_spatializer; volume: Single): ma_result; cdecl;
  ma_spatializer_get_master_volume: function(const pSpatializer: Pma_spatializer; pVolume: PSingle): ma_result; cdecl;
  ma_spatializer_get_input_channels: function(const pSpatializer: Pma_spatializer): ma_uint32; cdecl;
  ma_spatializer_get_output_channels: function(const pSpatializer: Pma_spatializer): ma_uint32; cdecl;
  ma_spatializer_set_attenuation_model: procedure(pSpatializer: Pma_spatializer; attenuationModel: ma_attenuation_model); cdecl;
  ma_spatializer_get_attenuation_model: function(const pSpatializer: Pma_spatializer): ma_attenuation_model; cdecl;
  ma_spatializer_set_positioning: procedure(pSpatializer: Pma_spatializer; positioning: ma_positioning); cdecl;
  ma_spatializer_get_positioning: function(const pSpatializer: Pma_spatializer): ma_positioning; cdecl;
  ma_spatializer_set_rolloff: procedure(pSpatializer: Pma_spatializer; rolloff: Single); cdecl;
  ma_spatializer_get_rolloff: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_min_gain: procedure(pSpatializer: Pma_spatializer; minGain: Single); cdecl;
  ma_spatializer_get_min_gain: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_max_gain: procedure(pSpatializer: Pma_spatializer; maxGain: Single); cdecl;
  ma_spatializer_get_max_gain: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_min_distance: procedure(pSpatializer: Pma_spatializer; minDistance: Single); cdecl;
  ma_spatializer_get_min_distance: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_max_distance: procedure(pSpatializer: Pma_spatializer; maxDistance: Single); cdecl;
  ma_spatializer_get_max_distance: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_cone: procedure(pSpatializer: Pma_spatializer; innerAngleInRadians: Single; outerAngleInRadians: Single; outerGain: Single); cdecl;
  ma_spatializer_get_cone: procedure(const pSpatializer: Pma_spatializer; pInnerAngleInRadians: PSingle; pOuterAngleInRadians: PSingle; pOuterGain: PSingle); cdecl;
  ma_spatializer_set_doppler_factor: procedure(pSpatializer: Pma_spatializer; dopplerFactor: Single); cdecl;
  ma_spatializer_get_doppler_factor: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_directional_attenuation_factor: procedure(pSpatializer: Pma_spatializer; directionalAttenuationFactor: Single); cdecl;
  ma_spatializer_get_directional_attenuation_factor: function(const pSpatializer: Pma_spatializer): Single; cdecl;
  ma_spatializer_set_position: procedure(pSpatializer: Pma_spatializer; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_get_position: function(const pSpatializer: Pma_spatializer): ma_vec3f; cdecl;
  ma_spatializer_set_direction: procedure(pSpatializer: Pma_spatializer; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_get_direction: function(const pSpatializer: Pma_spatializer): ma_vec3f; cdecl;
  ma_spatializer_set_velocity: procedure(pSpatializer: Pma_spatializer; x: Single; y: Single; z: Single); cdecl;
  ma_spatializer_get_velocity: function(const pSpatializer: Pma_spatializer): ma_vec3f; cdecl;
  ma_spatializer_get_relative_position_and_direction: procedure(const pSpatializer: Pma_spatializer; const pListener: Pma_spatializer_listener; pRelativePos: Pma_vec3f; pRelativeDir: Pma_vec3f); cdecl;
  ma_linear_resampler_config_init: function(format: ma_format; channels: ma_uint32; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_linear_resampler_config; cdecl;
  ma_linear_resampler_get_heap_size: function(const pConfig: Pma_linear_resampler_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_linear_resampler_init_preallocated: function(const pConfig: Pma_linear_resampler_config; pHeap: Pointer; pResampler: Pma_linear_resampler): ma_result; cdecl;
  ma_linear_resampler_init: function(const pConfig: Pma_linear_resampler_config; const pAllocationCallbacks: Pma_allocation_callbacks; pResampler: Pma_linear_resampler): ma_result; cdecl;
  ma_linear_resampler_uninit: procedure(pResampler: Pma_linear_resampler; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_linear_resampler_process_pcm_frames: function(pResampler: Pma_linear_resampler; const pFramesIn: Pointer; pFrameCountIn: Pma_uint64; pFramesOut: Pointer; pFrameCountOut: Pma_uint64): ma_result; cdecl;
  ma_linear_resampler_set_rate: function(pResampler: Pma_linear_resampler; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_result; cdecl;
  ma_linear_resampler_set_rate_ratio: function(pResampler: Pma_linear_resampler; ratioInOut: Single): ma_result; cdecl;
  ma_linear_resampler_get_input_latency: function(const pResampler: Pma_linear_resampler): ma_uint64; cdecl;
  ma_linear_resampler_get_output_latency: function(const pResampler: Pma_linear_resampler): ma_uint64; cdecl;
  ma_linear_resampler_get_required_input_frame_count: function(const pResampler: Pma_linear_resampler; outputFrameCount: ma_uint64; pInputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_linear_resampler_get_expected_output_frame_count: function(const pResampler: Pma_linear_resampler; inputFrameCount: ma_uint64; pOutputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_linear_resampler_reset: function(pResampler: Pma_linear_resampler): ma_result; cdecl;
  ma_resampler_config_init: function(format: ma_format; channels: ma_uint32; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32; algorithm: ma_resample_algorithm): ma_resampler_config; cdecl;
  ma_resampler_get_heap_size: function(const pConfig: Pma_resampler_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_resampler_init_preallocated: function(const pConfig: Pma_resampler_config; pHeap: Pointer; pResampler: Pma_resampler): ma_result; cdecl;
  ma_resampler_init: function(const pConfig: Pma_resampler_config; const pAllocationCallbacks: Pma_allocation_callbacks; pResampler: Pma_resampler): ma_result; cdecl;
  ma_resampler_uninit: procedure(pResampler: Pma_resampler; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_resampler_process_pcm_frames: function(pResampler: Pma_resampler; const pFramesIn: Pointer; pFrameCountIn: Pma_uint64; pFramesOut: Pointer; pFrameCountOut: Pma_uint64): ma_result; cdecl;
  ma_resampler_set_rate: function(pResampler: Pma_resampler; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_result; cdecl;
  ma_resampler_set_rate_ratio: function(pResampler: Pma_resampler; ratio: Single): ma_result; cdecl;
  ma_resampler_get_input_latency: function(const pResampler: Pma_resampler): ma_uint64; cdecl;
  ma_resampler_get_output_latency: function(const pResampler: Pma_resampler): ma_uint64; cdecl;
  ma_resampler_get_required_input_frame_count: function(const pResampler: Pma_resampler; outputFrameCount: ma_uint64; pInputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_resampler_get_expected_output_frame_count: function(const pResampler: Pma_resampler; inputFrameCount: ma_uint64; pOutputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_resampler_reset: function(pResampler: Pma_resampler): ma_result; cdecl;
  ma_channel_converter_config_init: function(format: ma_format; channelsIn: ma_uint32; const pChannelMapIn: Pma_channel; channelsOut: ma_uint32; const pChannelMapOut: Pma_channel; mixingMode: ma_channel_mix_mode): ma_channel_converter_config; cdecl;
  ma_channel_converter_get_heap_size: function(const pConfig: Pma_channel_converter_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_channel_converter_init_preallocated: function(const pConfig: Pma_channel_converter_config; pHeap: Pointer; pConverter: Pma_channel_converter): ma_result; cdecl;
  ma_channel_converter_init: function(const pConfig: Pma_channel_converter_config; const pAllocationCallbacks: Pma_allocation_callbacks; pConverter: Pma_channel_converter): ma_result; cdecl;
  ma_channel_converter_uninit: procedure(pConverter: Pma_channel_converter; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_channel_converter_process_pcm_frames: function(pConverter: Pma_channel_converter; pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64): ma_result; cdecl;
  ma_channel_converter_get_input_channel_map: function(const pConverter: Pma_channel_converter; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_channel_converter_get_output_channel_map: function(const pConverter: Pma_channel_converter; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_data_converter_config_init_default: function(): ma_data_converter_config; cdecl;
  ma_data_converter_config_init: function(formatIn: ma_format; formatOut: ma_format; channelsIn: ma_uint32; channelsOut: ma_uint32; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_data_converter_config; cdecl;
  ma_data_converter_get_heap_size: function(const pConfig: Pma_data_converter_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_data_converter_init_preallocated: function(const pConfig: Pma_data_converter_config; pHeap: Pointer; pConverter: Pma_data_converter): ma_result; cdecl;
  ma_data_converter_init: function(const pConfig: Pma_data_converter_config; const pAllocationCallbacks: Pma_allocation_callbacks; pConverter: Pma_data_converter): ma_result; cdecl;
  ma_data_converter_uninit: procedure(pConverter: Pma_data_converter; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_data_converter_process_pcm_frames: function(pConverter: Pma_data_converter; const pFramesIn: Pointer; pFrameCountIn: Pma_uint64; pFramesOut: Pointer; pFrameCountOut: Pma_uint64): ma_result; cdecl;
  ma_data_converter_set_rate: function(pConverter: Pma_data_converter; sampleRateIn: ma_uint32; sampleRateOut: ma_uint32): ma_result; cdecl;
  ma_data_converter_set_rate_ratio: function(pConverter: Pma_data_converter; ratioInOut: Single): ma_result; cdecl;
  ma_data_converter_get_input_latency: function(const pConverter: Pma_data_converter): ma_uint64; cdecl;
  ma_data_converter_get_output_latency: function(const pConverter: Pma_data_converter): ma_uint64; cdecl;
  ma_data_converter_get_required_input_frame_count: function(const pConverter: Pma_data_converter; outputFrameCount: ma_uint64; pInputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_data_converter_get_expected_output_frame_count: function(const pConverter: Pma_data_converter; inputFrameCount: ma_uint64; pOutputFrameCount: Pma_uint64): ma_result; cdecl;
  ma_data_converter_get_input_channel_map: function(const pConverter: Pma_data_converter; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_data_converter_get_output_channel_map: function(const pConverter: Pma_data_converter; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_data_converter_reset: function(pConverter: Pma_data_converter): ma_result; cdecl;
  ma_pcm_u8_to_s16: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_u8_to_s24: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_u8_to_s32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_u8_to_f32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s16_to_u8: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s16_to_s24: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s16_to_s32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s16_to_f32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s24_to_u8: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s24_to_s16: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s24_to_s32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s24_to_f32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s32_to_u8: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s32_to_s16: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s32_to_s24: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_s32_to_f32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_f32_to_u8: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_f32_to_s16: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_f32_to_s24: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_f32_to_s32: procedure(pOut: Pointer; const pIn: Pointer; count: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_pcm_convert: procedure(pOut: Pointer; formatOut: ma_format; const pIn: Pointer; formatIn: ma_format; sampleCount: ma_uint64; ditherMode: ma_dither_mode); cdecl;
  ma_convert_pcm_frames_format: procedure(pOut: Pointer; formatOut: ma_format; const pIn: Pointer; formatIn: ma_format; frameCount: ma_uint64; channels: ma_uint32; ditherMode: ma_dither_mode); cdecl;
  ma_deinterleave_pcm_frames: procedure(format: ma_format; channels: ma_uint32; frameCount: ma_uint64; const pInterleavedPCMFrames: Pointer; ppDeinterleavedPCMFrames: PPointer); cdecl;
  ma_interleave_pcm_frames: procedure(format: ma_format; channels: ma_uint32; frameCount: ma_uint64; ppDeinterleavedPCMFrames: PPointer; pInterleavedPCMFrames: Pointer); cdecl;
  ma_channel_map_get_channel: function(const pChannelMap: Pma_channel; channelCount: ma_uint32; channelIndex: ma_uint32): ma_channel; cdecl;
  ma_channel_map_init_blank: procedure(pChannelMap: Pma_channel; channels: ma_uint32); cdecl;
  ma_channel_map_init_standard: procedure(standardChannelMap: ma_standard_channel_map; pChannelMap: Pma_channel; channelMapCap: NativeUInt; channels: ma_uint32); cdecl;
  ma_channel_map_copy: procedure(pOut: Pma_channel; const pIn: Pma_channel; channels: ma_uint32); cdecl;
  ma_channel_map_copy_or_default: procedure(pOut: Pma_channel; channelMapCapOut: NativeUInt; const pIn: Pma_channel; channels: ma_uint32); cdecl;
  ma_channel_map_is_valid: function(const pChannelMap: Pma_channel; channels: ma_uint32): ma_bool32; cdecl;
  ma_channel_map_is_equal: function(const pChannelMapA: Pma_channel; const pChannelMapB: Pma_channel; channels: ma_uint32): ma_bool32; cdecl;
  ma_channel_map_is_blank: function(const pChannelMap: Pma_channel; channels: ma_uint32): ma_bool32; cdecl;
  ma_channel_map_contains_channel_position: function(channels: ma_uint32; const pChannelMap: Pma_channel; channelPosition: ma_channel): ma_bool32; cdecl;
  ma_channel_map_find_channel_position: function(channels: ma_uint32; const pChannelMap: Pma_channel; channelPosition: ma_channel; pChannelIndex: Pma_uint32): ma_bool32; cdecl;
  ma_channel_map_to_string: function(const pChannelMap: Pma_channel; channels: ma_uint32; pBufferOut: PUTF8Char; bufferCap: NativeUInt): NativeUInt; cdecl;
  ma_channel_position_to_string: function(channel: ma_channel): PUTF8Char; cdecl;
  ma_convert_frames: function(pOut: Pointer; frameCountOut: ma_uint64; formatOut: ma_format; channelsOut: ma_uint32; sampleRateOut: ma_uint32; const pIn: Pointer; frameCountIn: ma_uint64; formatIn: ma_format; channelsIn: ma_uint32; sampleRateIn: ma_uint32): ma_uint64; cdecl;
  ma_convert_frames_ex: function(pOut: Pointer; frameCountOut: ma_uint64; const pIn: Pointer; frameCountIn: ma_uint64; const pConfig: Pma_data_converter_config): ma_uint64; cdecl;
  ma_data_source_config_init: function(): ma_data_source_config; cdecl;
  ma_data_source_init: function(const pConfig: Pma_data_source_config; pDataSource: Pma_data_source): ma_result; cdecl;
  ma_data_source_uninit: procedure(pDataSource: Pma_data_source); cdecl;
  ma_data_source_read_pcm_frames: function(pDataSource: Pma_data_source; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_data_source_seek_pcm_frames: function(pDataSource: Pma_data_source; frameCount: ma_uint64; pFramesSeeked: Pma_uint64): ma_result; cdecl;
  ma_data_source_seek_to_pcm_frame: function(pDataSource: Pma_data_source; frameIndex: ma_uint64): ma_result; cdecl;
  ma_data_source_seek_seconds: function(pDataSource: Pma_data_source; secondCount: Single; pSecondsSeeked: PSingle): ma_result; cdecl;
  ma_data_source_seek_to_second: function(pDataSource: Pma_data_source; seekPointInSeconds: Single): ma_result; cdecl;
  ma_data_source_get_data_format: function(pDataSource: Pma_data_source; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_data_source_get_cursor_in_pcm_frames: function(pDataSource: Pma_data_source; pCursor: Pma_uint64): ma_result; cdecl;
  ma_data_source_get_length_in_pcm_frames: function(pDataSource: Pma_data_source; pLength: Pma_uint64): ma_result; cdecl;
  ma_data_source_get_cursor_in_seconds: function(pDataSource: Pma_data_source; pCursor: PSingle): ma_result; cdecl;
  ma_data_source_get_length_in_seconds: function(pDataSource: Pma_data_source; pLength: PSingle): ma_result; cdecl;
  ma_data_source_set_looping: function(pDataSource: Pma_data_source; isLooping: ma_bool32): ma_result; cdecl;
  ma_data_source_is_looping: function(const pDataSource: Pma_data_source): ma_bool32; cdecl;
  ma_data_source_set_range_in_pcm_frames: function(pDataSource: Pma_data_source; rangeBegInFrames: ma_uint64; rangeEndInFrames: ma_uint64): ma_result; cdecl;
  ma_data_source_get_range_in_pcm_frames: procedure(const pDataSource: Pma_data_source; pRangeBegInFrames: Pma_uint64; pRangeEndInFrames: Pma_uint64); cdecl;
  ma_data_source_set_loop_point_in_pcm_frames: function(pDataSource: Pma_data_source; loopBegInFrames: ma_uint64; loopEndInFrames: ma_uint64): ma_result; cdecl;
  ma_data_source_get_loop_point_in_pcm_frames: procedure(const pDataSource: Pma_data_source; pLoopBegInFrames: Pma_uint64; pLoopEndInFrames: Pma_uint64); cdecl;
  ma_data_source_set_current: function(pDataSource: Pma_data_source; pCurrentDataSource: Pma_data_source): ma_result; cdecl;
  ma_data_source_get_current: function(const pDataSource: Pma_data_source): Pma_data_source; cdecl;
  ma_data_source_set_next: function(pDataSource: Pma_data_source; pNextDataSource: Pma_data_source): ma_result; cdecl;
  ma_data_source_get_next: function(const pDataSource: Pma_data_source): Pma_data_source; cdecl;
  ma_data_source_set_next_callback: function(pDataSource: Pma_data_source; onGetNext: ma_data_source_get_next_proc): ma_result; cdecl;
  ma_data_source_get_next_callback: function(const pDataSource: Pma_data_source): ma_data_source_get_next_proc; cdecl;
  ma_audio_buffer_ref_init: function(format: ma_format; channels: ma_uint32; const pData: Pointer; sizeInFrames: ma_uint64; pAudioBufferRef: Pma_audio_buffer_ref): ma_result; cdecl;
  ma_audio_buffer_ref_uninit: procedure(pAudioBufferRef: Pma_audio_buffer_ref); cdecl;
  ma_audio_buffer_ref_set_data: function(pAudioBufferRef: Pma_audio_buffer_ref; const pData: Pointer; sizeInFrames: ma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_read_pcm_frames: function(pAudioBufferRef: Pma_audio_buffer_ref; pFramesOut: Pointer; frameCount: ma_uint64; loop: ma_bool32): ma_uint64; cdecl;
  ma_audio_buffer_ref_seek_to_pcm_frame: function(pAudioBufferRef: Pma_audio_buffer_ref; frameIndex: ma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_map: function(pAudioBufferRef: Pma_audio_buffer_ref; ppFramesOut: PPointer; pFrameCount: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_unmap: function(pAudioBufferRef: Pma_audio_buffer_ref; frameCount: ma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_at_end: function(const pAudioBufferRef: Pma_audio_buffer_ref): ma_bool32; cdecl;
  ma_audio_buffer_ref_get_cursor_in_pcm_frames: function(const pAudioBufferRef: Pma_audio_buffer_ref; pCursor: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_get_length_in_pcm_frames: function(const pAudioBufferRef: Pma_audio_buffer_ref; pLength: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_ref_get_available_frames: function(const pAudioBufferRef: Pma_audio_buffer_ref; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_config_init: function(format: ma_format; channels: ma_uint32; sizeInFrames: ma_uint64; const pData: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks): ma_audio_buffer_config; cdecl;
  ma_audio_buffer_init: function(const pConfig: Pma_audio_buffer_config; pAudioBuffer: Pma_audio_buffer): ma_result; cdecl;
  ma_audio_buffer_init_copy: function(const pConfig: Pma_audio_buffer_config; pAudioBuffer: Pma_audio_buffer): ma_result; cdecl;
  ma_audio_buffer_alloc_and_init: function(const pConfig: Pma_audio_buffer_config; ppAudioBuffer: PPma_audio_buffer): ma_result; cdecl;
  ma_audio_buffer_uninit: procedure(pAudioBuffer: Pma_audio_buffer); cdecl;
  ma_audio_buffer_uninit_and_free: procedure(pAudioBuffer: Pma_audio_buffer); cdecl;
  ma_audio_buffer_read_pcm_frames: function(pAudioBuffer: Pma_audio_buffer; pFramesOut: Pointer; frameCount: ma_uint64; loop: ma_bool32): ma_uint64; cdecl;
  ma_audio_buffer_seek_to_pcm_frame: function(pAudioBuffer: Pma_audio_buffer; frameIndex: ma_uint64): ma_result; cdecl;
  ma_audio_buffer_map: function(pAudioBuffer: Pma_audio_buffer; ppFramesOut: PPointer; pFrameCount: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_unmap: function(pAudioBuffer: Pma_audio_buffer; frameCount: ma_uint64): ma_result; cdecl;
  ma_audio_buffer_at_end: function(const pAudioBuffer: Pma_audio_buffer): ma_bool32; cdecl;
  ma_audio_buffer_get_cursor_in_pcm_frames: function(const pAudioBuffer: Pma_audio_buffer; pCursor: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_get_length_in_pcm_frames: function(const pAudioBuffer: Pma_audio_buffer; pLength: Pma_uint64): ma_result; cdecl;
  ma_audio_buffer_get_available_frames: function(const pAudioBuffer: Pma_audio_buffer; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_paged_audio_buffer_data_init: function(format: ma_format; channels: ma_uint32; pData: Pma_paged_audio_buffer_data): ma_result; cdecl;
  ma_paged_audio_buffer_data_uninit: procedure(pData: Pma_paged_audio_buffer_data; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_paged_audio_buffer_data_get_head: function(pData: Pma_paged_audio_buffer_data): Pma_paged_audio_buffer_page; cdecl;
  ma_paged_audio_buffer_data_get_tail: function(pData: Pma_paged_audio_buffer_data): Pma_paged_audio_buffer_page; cdecl;
  ma_paged_audio_buffer_data_get_length_in_pcm_frames: function(pData: Pma_paged_audio_buffer_data; pLength: Pma_uint64): ma_result; cdecl;
  ma_paged_audio_buffer_data_allocate_page: function(pData: Pma_paged_audio_buffer_data; pageSizeInFrames: ma_uint64; const pInitialData: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks; ppPage: PPma_paged_audio_buffer_page): ma_result; cdecl;
  ma_paged_audio_buffer_data_free_page: function(pData: Pma_paged_audio_buffer_data; pPage: Pma_paged_audio_buffer_page; const pAllocationCallbacks: Pma_allocation_callbacks): ma_result; cdecl;
  ma_paged_audio_buffer_data_append_page: function(pData: Pma_paged_audio_buffer_data; pPage: Pma_paged_audio_buffer_page): ma_result; cdecl;
  ma_paged_audio_buffer_data_allocate_and_append_page: function(pData: Pma_paged_audio_buffer_data; pageSizeInFrames: ma_uint32; const pInitialData: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks): ma_result; cdecl;
  ma_paged_audio_buffer_config_init: function(pData: Pma_paged_audio_buffer_data): ma_paged_audio_buffer_config; cdecl;
  ma_paged_audio_buffer_init: function(const pConfig: Pma_paged_audio_buffer_config; pPagedAudioBuffer: Pma_paged_audio_buffer): ma_result; cdecl;
  ma_paged_audio_buffer_uninit: procedure(pPagedAudioBuffer: Pma_paged_audio_buffer); cdecl;
  ma_paged_audio_buffer_read_pcm_frames: function(pPagedAudioBuffer: Pma_paged_audio_buffer; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_paged_audio_buffer_seek_to_pcm_frame: function(pPagedAudioBuffer: Pma_paged_audio_buffer; frameIndex: ma_uint64): ma_result; cdecl;
  ma_paged_audio_buffer_get_cursor_in_pcm_frames: function(pPagedAudioBuffer: Pma_paged_audio_buffer; pCursor: Pma_uint64): ma_result; cdecl;
  ma_paged_audio_buffer_get_length_in_pcm_frames: function(pPagedAudioBuffer: Pma_paged_audio_buffer; pLength: Pma_uint64): ma_result; cdecl;
  ma_rb_init_ex: function(subbufferSizeInBytes: NativeUInt; subbufferCount: NativeUInt; subbufferStrideInBytes: NativeUInt; pOptionalPreallocatedBuffer: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks; pRB: Pma_rb): ma_result; cdecl;
  ma_rb_init: function(bufferSizeInBytes: NativeUInt; pOptionalPreallocatedBuffer: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks; pRB: Pma_rb): ma_result; cdecl;
  ma_rb_uninit: procedure(pRB: Pma_rb); cdecl;
  ma_rb_reset: procedure(pRB: Pma_rb); cdecl;
  ma_rb_acquire_read: function(pRB: Pma_rb; pSizeInBytes: PNativeUInt; ppBufferOut: PPointer): ma_result; cdecl;
  ma_rb_commit_read: function(pRB: Pma_rb; sizeInBytes: NativeUInt): ma_result; cdecl;
  ma_rb_acquire_write: function(pRB: Pma_rb; pSizeInBytes: PNativeUInt; ppBufferOut: PPointer): ma_result; cdecl;
  ma_rb_commit_write: function(pRB: Pma_rb; sizeInBytes: NativeUInt): ma_result; cdecl;
  ma_rb_seek_read: function(pRB: Pma_rb; offsetInBytes: NativeUInt): ma_result; cdecl;
  ma_rb_seek_write: function(pRB: Pma_rb; offsetInBytes: NativeUInt): ma_result; cdecl;
  ma_rb_pointer_distance: function(pRB: Pma_rb): ma_int32; cdecl;
  ma_rb_available_read: function(pRB: Pma_rb): ma_uint32; cdecl;
  ma_rb_available_write: function(pRB: Pma_rb): ma_uint32; cdecl;
  ma_rb_get_subbuffer_size: function(pRB: Pma_rb): NativeUInt; cdecl;
  ma_rb_get_subbuffer_stride: function(pRB: Pma_rb): NativeUInt; cdecl;
  ma_rb_get_subbuffer_offset: function(pRB: Pma_rb; subbufferIndex: NativeUInt): NativeUInt; cdecl;
  ma_rb_get_subbuffer_ptr: function(pRB: Pma_rb; subbufferIndex: NativeUInt; pBuffer: Pointer): Pointer; cdecl;
  ma_pcm_rb_init_ex: function(format: ma_format; channels: ma_uint32; subbufferSizeInFrames: ma_uint32; subbufferCount: ma_uint32; subbufferStrideInFrames: ma_uint32; pOptionalPreallocatedBuffer: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks; pRB: Pma_pcm_rb): ma_result; cdecl;
  ma_pcm_rb_init: function(format: ma_format; channels: ma_uint32; bufferSizeInFrames: ma_uint32; pOptionalPreallocatedBuffer: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks; pRB: Pma_pcm_rb): ma_result; cdecl;
  ma_pcm_rb_uninit: procedure(pRB: Pma_pcm_rb); cdecl;
  ma_pcm_rb_reset: procedure(pRB: Pma_pcm_rb); cdecl;
  ma_pcm_rb_acquire_read: function(pRB: Pma_pcm_rb; pSizeInFrames: Pma_uint32; ppBufferOut: PPointer): ma_result; cdecl;
  ma_pcm_rb_commit_read: function(pRB: Pma_pcm_rb; sizeInFrames: ma_uint32): ma_result; cdecl;
  ma_pcm_rb_acquire_write: function(pRB: Pma_pcm_rb; pSizeInFrames: Pma_uint32; ppBufferOut: PPointer): ma_result; cdecl;
  ma_pcm_rb_commit_write: function(pRB: Pma_pcm_rb; sizeInFrames: ma_uint32): ma_result; cdecl;
  ma_pcm_rb_seek_read: function(pRB: Pma_pcm_rb; offsetInFrames: ma_uint32): ma_result; cdecl;
  ma_pcm_rb_seek_write: function(pRB: Pma_pcm_rb; offsetInFrames: ma_uint32): ma_result; cdecl;
  ma_pcm_rb_pointer_distance: function(pRB: Pma_pcm_rb): ma_int32; cdecl;
  ma_pcm_rb_available_read: function(pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_available_write: function(pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_get_subbuffer_size: function(pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_get_subbuffer_stride: function(pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_get_subbuffer_offset: function(pRB: Pma_pcm_rb; subbufferIndex: ma_uint32): ma_uint32; cdecl;
  ma_pcm_rb_get_subbuffer_ptr: function(pRB: Pma_pcm_rb; subbufferIndex: ma_uint32; pBuffer: Pointer): Pointer; cdecl;
  ma_pcm_rb_get_format: function(const pRB: Pma_pcm_rb): ma_format; cdecl;
  ma_pcm_rb_get_channels: function(const pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_get_sample_rate: function(const pRB: Pma_pcm_rb): ma_uint32; cdecl;
  ma_pcm_rb_set_sample_rate: procedure(pRB: Pma_pcm_rb; sampleRate: ma_uint32); cdecl;
  ma_duplex_rb_init: function(captureFormat: ma_format; captureChannels: ma_uint32; sampleRate: ma_uint32; captureInternalSampleRate: ma_uint32; captureInternalPeriodSizeInFrames: ma_uint32; const pAllocationCallbacks: Pma_allocation_callbacks; pRB: Pma_duplex_rb): ma_result; cdecl;
  ma_duplex_rb_uninit: function(pRB: Pma_duplex_rb): ma_result; cdecl;
  ma_result_description: function(result: ma_result): PUTF8Char; cdecl;
  ma_malloc: function(sz: NativeUInt; const pAllocationCallbacks: Pma_allocation_callbacks): Pointer; cdecl;
  ma_calloc: function(sz: NativeUInt; const pAllocationCallbacks: Pma_allocation_callbacks): Pointer; cdecl;
  ma_realloc: function(p: Pointer; sz: NativeUInt; const pAllocationCallbacks: Pma_allocation_callbacks): Pointer; cdecl;
  ma_free: procedure(p: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_aligned_malloc: function(sz: NativeUInt; alignment: NativeUInt; const pAllocationCallbacks: Pma_allocation_callbacks): Pointer; cdecl;
  ma_aligned_free: procedure(p: Pointer; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_get_format_name: function(format: ma_format): PUTF8Char; cdecl;
  ma_blend_f32: procedure(pOut: PSingle; pInA: PSingle; pInB: PSingle; factor: Single; channels: ma_uint32); cdecl;
  ma_get_bytes_per_sample: function(format: ma_format): ma_uint32; cdecl;
  ma_log_level_to_string: function(logLevel: ma_uint32): PUTF8Char; cdecl;
  ma_spinlock_lock: function(pSpinlock: Pma_spinlock): ma_result; cdecl;
  ma_spinlock_lock_noyield: function(pSpinlock: Pma_spinlock): ma_result; cdecl;
  ma_spinlock_unlock: function(pSpinlock: Pma_spinlock): ma_result; cdecl;
  ma_mutex_init: function(pMutex: Pma_mutex): ma_result; cdecl;
  ma_mutex_uninit: procedure(pMutex: Pma_mutex); cdecl;
  ma_mutex_lock: procedure(pMutex: Pma_mutex); cdecl;
  ma_mutex_unlock: procedure(pMutex: Pma_mutex); cdecl;
  ma_event_init: function(pEvent: Pma_event): ma_result; cdecl;
  ma_event_uninit: procedure(pEvent: Pma_event); cdecl;
  ma_event_wait: function(pEvent: Pma_event): ma_result; cdecl;
  ma_event_signal: function(pEvent: Pma_event): ma_result; cdecl;
  ma_semaphore_init: function(initialValue: Integer; pSemaphore: Pma_semaphore): ma_result; cdecl;
  ma_semaphore_uninit: procedure(pSemaphore: Pma_semaphore); cdecl;
  ma_semaphore_wait: function(pSemaphore: Pma_semaphore): ma_result; cdecl;
  ma_semaphore_release: function(pSemaphore: Pma_semaphore): ma_result; cdecl;
  ma_fence_init: function(pFence: Pma_fence): ma_result; cdecl;
  ma_fence_uninit: procedure(pFence: Pma_fence); cdecl;
  ma_fence_acquire: function(pFence: Pma_fence): ma_result; cdecl;
  ma_fence_release: function(pFence: Pma_fence): ma_result; cdecl;
  ma_fence_wait: function(pFence: Pma_fence): ma_result; cdecl;
  ma_async_notification_signal: function(pNotification: Pma_async_notification): ma_result; cdecl;
  ma_async_notification_poll_init: function(pNotificationPoll: Pma_async_notification_poll): ma_result; cdecl;
  ma_async_notification_poll_is_signalled: function(const pNotificationPoll: Pma_async_notification_poll): ma_bool32; cdecl;
  ma_async_notification_event_init: function(pNotificationEvent: Pma_async_notification_event): ma_result; cdecl;
  ma_async_notification_event_uninit: function(pNotificationEvent: Pma_async_notification_event): ma_result; cdecl;
  ma_async_notification_event_wait: function(pNotificationEvent: Pma_async_notification_event): ma_result; cdecl;
  ma_async_notification_event_signal: function(pNotificationEvent: Pma_async_notification_event): ma_result; cdecl;
  ma_slot_allocator_config_init: function(capacity: ma_uint32): ma_slot_allocator_config; cdecl;
  ma_slot_allocator_get_heap_size: function(const pConfig: Pma_slot_allocator_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_slot_allocator_init_preallocated: function(const pConfig: Pma_slot_allocator_config; pHeap: Pointer; pAllocator: Pma_slot_allocator): ma_result; cdecl;
  ma_slot_allocator_init: function(const pConfig: Pma_slot_allocator_config; const pAllocationCallbacks: Pma_allocation_callbacks; pAllocator: Pma_slot_allocator): ma_result; cdecl;
  ma_slot_allocator_uninit: procedure(pAllocator: Pma_slot_allocator; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_slot_allocator_alloc: function(pAllocator: Pma_slot_allocator; pSlot: Pma_uint64): ma_result; cdecl;
  ma_slot_allocator_free: function(pAllocator: Pma_slot_allocator; slot: ma_uint64): ma_result; cdecl;
  ma_job_init: function(code: ma_uint16): ma_job; cdecl;
  ma_job_process: function(pJob: Pma_job): ma_result; cdecl;
  ma_job_queue_config_init: function(flags: ma_uint32; capacity: ma_uint32): ma_job_queue_config; cdecl;
  ma_job_queue_get_heap_size: function(const pConfig: Pma_job_queue_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_job_queue_init_preallocated: function(const pConfig: Pma_job_queue_config; pHeap: Pointer; pQueue: Pma_job_queue): ma_result; cdecl;
  ma_job_queue_init: function(const pConfig: Pma_job_queue_config; const pAllocationCallbacks: Pma_allocation_callbacks; pQueue: Pma_job_queue): ma_result; cdecl;
  ma_job_queue_uninit: procedure(pQueue: Pma_job_queue; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_job_queue_post: function(pQueue: Pma_job_queue; const pJob: Pma_job): ma_result; cdecl;
  ma_job_queue_next: function(pQueue: Pma_job_queue; pJob: Pma_job): ma_result; cdecl;
  ma_device_job_thread_config_init: function(): ma_device_job_thread_config; cdecl;
  ma_device_job_thread_init: function(const pConfig: Pma_device_job_thread_config; const pAllocationCallbacks: Pma_allocation_callbacks; pJobThread: Pma_device_job_thread): ma_result; cdecl;
  ma_device_job_thread_uninit: procedure(pJobThread: Pma_device_job_thread; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_device_job_thread_post: function(pJobThread: Pma_device_job_thread; const pJob: Pma_job): ma_result; cdecl;
  ma_device_job_thread_next: function(pJobThread: Pma_device_job_thread; pJob: Pma_job): ma_result; cdecl;
  ma_device_id_equal: function(const pA: Pma_device_id; const pB: Pma_device_id): ma_bool32; cdecl;
  ma_context_config_init: function(): ma_context_config; cdecl;
  ma_context_init: function(backends: Pma_backend; backendCount: ma_uint32; const pConfig: Pma_context_config; pContext: Pma_context): ma_result; cdecl;
  ma_context_uninit: function(pContext: Pma_context): ma_result; cdecl;
  ma_context_sizeof: function(): NativeUInt; cdecl;
  ma_context_get_log: function(pContext: Pma_context): Pma_log; cdecl;
  ma_context_enumerate_devices: function(pContext: Pma_context; callback: ma_enum_devices_callback_proc; pUserData: Pointer): ma_result; cdecl;
  ma_context_get_devices: function(pContext: Pma_context; ppPlaybackDeviceInfos: PPma_device_info; pPlaybackDeviceCount: Pma_uint32; ppCaptureDeviceInfos: PPma_device_info; pCaptureDeviceCount: Pma_uint32): ma_result; cdecl;
  ma_context_get_device_info: function(pContext: Pma_context; deviceType: ma_device_type; const pDeviceID: Pma_device_id; pDeviceInfo: Pma_device_info): ma_result; cdecl;
  ma_context_is_loopback_supported: function(pContext: Pma_context): ma_bool32; cdecl;
  ma_device_config_init: function(deviceType: ma_device_type): ma_device_config; cdecl;
  ma_device_init: function(pContext: Pma_context; const pConfig: Pma_device_config; pDevice: Pma_device): ma_result; cdecl;
  ma_device_init_ex: function(backends: Pma_backend; backendCount: ma_uint32; const pContextConfig: Pma_context_config; const pConfig: Pma_device_config; pDevice: Pma_device): ma_result; cdecl;
  ma_device_uninit: procedure(pDevice: Pma_device); cdecl;
  ma_device_get_context: function(pDevice: Pma_device): Pma_context; cdecl;
  ma_device_get_log: function(pDevice: Pma_device): Pma_log; cdecl;
  ma_device_get_info: function(pDevice: Pma_device; &type: ma_device_type; pDeviceInfo: Pma_device_info): ma_result; cdecl;
  ma_device_get_name: function(pDevice: Pma_device; &type: ma_device_type; pName: PUTF8Char; nameCap: NativeUInt; pLengthNotIncludingNullTerminator: PNativeUInt): ma_result; cdecl;
  ma_device_start: function(pDevice: Pma_device): ma_result; cdecl;
  ma_device_stop: function(pDevice: Pma_device): ma_result; cdecl;
  ma_device_is_started: function(const pDevice: Pma_device): ma_bool32; cdecl;
  ma_device_get_state: function(const pDevice: Pma_device): ma_device_state; cdecl;
  ma_device_post_init: function(pDevice: Pma_device; deviceType: ma_device_type; const pPlaybackDescriptor: Pma_device_descriptor; const pCaptureDescriptor: Pma_device_descriptor): ma_result; cdecl;
  ma_device_set_master_volume: function(pDevice: Pma_device; volume: Single): ma_result; cdecl;
  ma_device_get_master_volume: function(pDevice: Pma_device; pVolume: PSingle): ma_result; cdecl;
  ma_device_set_master_volume_db: function(pDevice: Pma_device; gainDB: Single): ma_result; cdecl;
  ma_device_get_master_volume_db: function(pDevice: Pma_device; pGainDB: PSingle): ma_result; cdecl;
  ma_device_handle_backend_data_callback: function(pDevice: Pma_device; pOutput: Pointer; const pInput: Pointer; frameCount: ma_uint32): ma_result; cdecl;
  ma_calculate_buffer_size_in_frames_from_descriptor: function(const pDescriptor: Pma_device_descriptor; nativeSampleRate: ma_uint32; performanceProfile: ma_performance_profile): ma_uint32; cdecl;
  ma_get_backend_name: function(backend: ma_backend): PUTF8Char; cdecl;
  ma_get_backend_from_name: function(const pBackendName: PUTF8Char; pBackend: Pma_backend): ma_result; cdecl;
  ma_is_backend_enabled: function(backend: ma_backend): ma_bool32; cdecl;
  ma_get_enabled_backends: function(pBackends: Pma_backend; backendCap: NativeUInt; pBackendCount: PNativeUInt): ma_result; cdecl;
  ma_is_loopback_supported: function(backend: ma_backend): ma_bool32; cdecl;
  ma_calculate_buffer_size_in_milliseconds_from_frames: function(bufferSizeInFrames: ma_uint32; sampleRate: ma_uint32): ma_uint32; cdecl;
  ma_calculate_buffer_size_in_frames_from_milliseconds: function(bufferSizeInMilliseconds: ma_uint32; sampleRate: ma_uint32): ma_uint32; cdecl;
  ma_copy_pcm_frames: procedure(dst: Pointer; const src: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32); cdecl;
  ma_silence_pcm_frames: procedure(p: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32); cdecl;
  ma_offset_pcm_frames_ptr: function(p: Pointer; offsetInFrames: ma_uint64; format: ma_format; channels: ma_uint32): Pointer; cdecl;
  ma_offset_pcm_frames_const_ptr: function(const p: Pointer; offsetInFrames: ma_uint64; format: ma_format; channels: ma_uint32): Pointer; cdecl;
  ma_clip_samples_u8: procedure(pDst: Pma_uint8; const pSrc: Pma_int16; count: ma_uint64); cdecl;
  ma_clip_samples_s16: procedure(pDst: Pma_int16; const pSrc: Pma_int32; count: ma_uint64); cdecl;
  ma_clip_samples_s24: procedure(pDst: Pma_uint8; const pSrc: Pma_int64; count: ma_uint64); cdecl;
  ma_clip_samples_s32: procedure(pDst: Pma_int32; const pSrc: Pma_int64; count: ma_uint64); cdecl;
  ma_clip_samples_f32: procedure(pDst: PSingle; const pSrc: PSingle; count: ma_uint64); cdecl;
  ma_clip_pcm_frames: procedure(pDst: Pointer; const pSrc: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32); cdecl;
  ma_copy_and_apply_volume_factor_u8: procedure(pSamplesOut: Pma_uint8; const pSamplesIn: Pma_uint8; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_s16: procedure(pSamplesOut: Pma_int16; const pSamplesIn: Pma_int16; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_s24: procedure(pSamplesOut: Pointer; const pSamplesIn: Pointer; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_s32: procedure(pSamplesOut: Pma_int32; const pSamplesIn: Pma_int32; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_f32: procedure(pSamplesOut: PSingle; const pSamplesIn: PSingle; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_apply_volume_factor_u8: procedure(pSamples: Pma_uint8; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_apply_volume_factor_s16: procedure(pSamples: Pma_int16; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_apply_volume_factor_s24: procedure(pSamples: Pointer; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_apply_volume_factor_s32: procedure(pSamples: Pma_int32; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_apply_volume_factor_f32: procedure(pSamples: PSingle; sampleCount: ma_uint64; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames_u8: procedure(pFramesOut: Pma_uint8; const pFramesIn: Pma_uint8; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames_s16: procedure(pFramesOut: Pma_int16; const pFramesIn: Pma_int16; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames_s24: procedure(pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames_s32: procedure(pFramesOut: Pma_int32; const pFramesIn: Pma_int32; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames_f32: procedure(pFramesOut: PSingle; const pFramesIn: PSingle; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_pcm_frames: procedure(pFramesOut: Pointer; const pFramesIn: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames_u8: procedure(pFrames: Pma_uint8; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames_s16: procedure(pFrames: Pma_int16; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames_s24: procedure(pFrames: Pointer; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames_s32: procedure(pFrames: Pma_int32; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames_f32: procedure(pFrames: PSingle; frameCount: ma_uint64; channels: ma_uint32; factor: Single); cdecl;
  ma_apply_volume_factor_pcm_frames: procedure(pFrames: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32; factor: Single); cdecl;
  ma_copy_and_apply_volume_factor_per_channel_f32: procedure(pFramesOut: PSingle; const pFramesIn: PSingle; frameCount: ma_uint64; channels: ma_uint32; pChannelGains: PSingle); cdecl;
  ma_copy_and_apply_volume_and_clip_samples_u8: procedure(pDst: Pma_uint8; const pSrc: Pma_int16; count: ma_uint64; volume: Single); cdecl;
  ma_copy_and_apply_volume_and_clip_samples_s16: procedure(pDst: Pma_int16; const pSrc: Pma_int32; count: ma_uint64; volume: Single); cdecl;
  ma_copy_and_apply_volume_and_clip_samples_s24: procedure(pDst: Pma_uint8; const pSrc: Pma_int64; count: ma_uint64; volume: Single); cdecl;
  ma_copy_and_apply_volume_and_clip_samples_s32: procedure(pDst: Pma_int32; const pSrc: Pma_int64; count: ma_uint64; volume: Single); cdecl;
  ma_copy_and_apply_volume_and_clip_samples_f32: procedure(pDst: PSingle; const pSrc: PSingle; count: ma_uint64; volume: Single); cdecl;
  ma_copy_and_apply_volume_and_clip_pcm_frames: procedure(pDst: Pointer; const pSrc: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32; volume: Single); cdecl;
  ma_volume_linear_to_db: function(factor: Single): Single; cdecl;
  ma_volume_db_to_linear: function(gain: Single): Single; cdecl;
  ma_mix_pcm_frames_f32: function(pDst: PSingle; const pSrc: PSingle; frameCount: ma_uint64; channels: ma_uint32; volume: Single): ma_result; cdecl;
  ma_vfs_open: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; openMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
  ma_vfs_open_w: function(pVFS: Pma_vfs; const pFilePath: PWideChar; openMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
  ma_vfs_close: function(pVFS: Pma_vfs; &file: ma_vfs_file): ma_result; cdecl;
  ma_vfs_read: function(pVFS: Pma_vfs; &file: ma_vfs_file; pDst: Pointer; sizeInBytes: NativeUInt; pBytesRead: PNativeUInt): ma_result; cdecl;
  ma_vfs_write: function(pVFS: Pma_vfs; &file: ma_vfs_file; const pSrc: Pointer; sizeInBytes: NativeUInt; pBytesWritten: PNativeUInt): ma_result; cdecl;
  ma_vfs_seek: function(pVFS: Pma_vfs; &file: ma_vfs_file; offset: ma_int64; origin: ma_seek_origin): ma_result; cdecl;
  ma_vfs_tell: function(pVFS: Pma_vfs; &file: ma_vfs_file; pCursor: Pma_int64): ma_result; cdecl;
  ma_vfs_info: function(pVFS: Pma_vfs; &file: ma_vfs_file; pInfo: Pma_file_info): ma_result; cdecl;
  ma_vfs_open_and_read_file: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; ppData: PPointer; pSize: PNativeUInt; const pAllocationCallbacks: Pma_allocation_callbacks): ma_result; cdecl;
  ma_default_vfs_init: function(pVFS: Pma_default_vfs; const pAllocationCallbacks: Pma_allocation_callbacks): ma_result; cdecl;
  ma_decoding_backend_config_init: function(preferredFormat: ma_format; seekPointCount: ma_uint32): ma_decoding_backend_config; cdecl;
  ma_decoder_config_init: function(outputFormat: ma_format; outputChannels: ma_uint32; outputSampleRate: ma_uint32): ma_decoder_config; cdecl;
  ma_decoder_config_init_default: function(): ma_decoder_config; cdecl;
  ma_decoder_init: function(onRead: ma_decoder_read_proc; onSeek: ma_decoder_seek_proc; pUserData: Pointer; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_init_memory: function(const pData: Pointer; dataSize: NativeUInt; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_init_vfs: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_init_vfs_w: function(pVFS: Pma_vfs; const pFilePath: PWideChar; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_init_file: function(const pFilePath: PUTF8Char; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_init_file_w: function(const pFilePath: PWideChar; const pConfig: Pma_decoder_config; pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_uninit: function(pDecoder: Pma_decoder): ma_result; cdecl;
  ma_decoder_read_pcm_frames: function(pDecoder: Pma_decoder; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_decoder_seek_to_pcm_frame: function(pDecoder: Pma_decoder; frameIndex: ma_uint64): ma_result; cdecl;
  ma_decoder_get_data_format: function(pDecoder: Pma_decoder; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_decoder_get_cursor_in_pcm_frames: function(pDecoder: Pma_decoder; pCursor: Pma_uint64): ma_result; cdecl;
  ma_decoder_get_length_in_pcm_frames: function(pDecoder: Pma_decoder; pLength: Pma_uint64): ma_result; cdecl;
  ma_decoder_get_available_frames: function(pDecoder: Pma_decoder; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_decode_from_vfs: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; pConfig: Pma_decoder_config; pFrameCountOut: Pma_uint64; ppPCMFramesOut: PPointer): ma_result; cdecl;
  ma_decode_file: function(const pFilePath: PUTF8Char; pConfig: Pma_decoder_config; pFrameCountOut: Pma_uint64; ppPCMFramesOut: PPointer): ma_result; cdecl;
  ma_decode_memory: function(const pData: Pointer; dataSize: NativeUInt; pConfig: Pma_decoder_config; pFrameCountOut: Pma_uint64; ppPCMFramesOut: PPointer): ma_result; cdecl;
  ma_encoder_config_init: function(encodingFormat: ma_encoding_format; format: ma_format; channels: ma_uint32; sampleRate: ma_uint32): ma_encoder_config; cdecl;
  ma_encoder_init: function(onWrite: ma_encoder_write_proc; onSeek: ma_encoder_seek_proc; pUserData: Pointer; const pConfig: Pma_encoder_config; pEncoder: Pma_encoder): ma_result; cdecl;
  ma_encoder_init_vfs: function(pVFS: Pma_vfs; const pFilePath: PUTF8Char; const pConfig: Pma_encoder_config; pEncoder: Pma_encoder): ma_result; cdecl;
  ma_encoder_init_vfs_w: function(pVFS: Pma_vfs; const pFilePath: PWideChar; const pConfig: Pma_encoder_config; pEncoder: Pma_encoder): ma_result; cdecl;
  ma_encoder_init_file: function(const pFilePath: PUTF8Char; const pConfig: Pma_encoder_config; pEncoder: Pma_encoder): ma_result; cdecl;
  ma_encoder_init_file_w: function(const pFilePath: PWideChar; const pConfig: Pma_encoder_config; pEncoder: Pma_encoder): ma_result; cdecl;
  ma_encoder_uninit: procedure(pEncoder: Pma_encoder); cdecl;
  ma_encoder_write_pcm_frames: function(pEncoder: Pma_encoder; const pFramesIn: Pointer; frameCount: ma_uint64; pFramesWritten: Pma_uint64): ma_result; cdecl;
  ma_waveform_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; &type: ma_waveform_type; amplitude: Double; frequency: Double): ma_waveform_config; cdecl;
  ma_waveform_init: function(const pConfig: Pma_waveform_config; pWaveform: Pma_waveform): ma_result; cdecl;
  ma_waveform_uninit: procedure(pWaveform: Pma_waveform); cdecl;
  ma_waveform_read_pcm_frames: function(pWaveform: Pma_waveform; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_waveform_seek_to_pcm_frame: function(pWaveform: Pma_waveform; frameIndex: ma_uint64): ma_result; cdecl;
  ma_waveform_set_amplitude: function(pWaveform: Pma_waveform; amplitude: Double): ma_result; cdecl;
  ma_waveform_set_frequency: function(pWaveform: Pma_waveform; frequency: Double): ma_result; cdecl;
  ma_waveform_set_type: function(pWaveform: Pma_waveform; &type: ma_waveform_type): ma_result; cdecl;
  ma_waveform_set_sample_rate: function(pWaveform: Pma_waveform; sampleRate: ma_uint32): ma_result; cdecl;
  ma_pulsewave_config_init: function(format: ma_format; channels: ma_uint32; sampleRate: ma_uint32; dutyCycle: Double; amplitude: Double; frequency: Double): ma_pulsewave_config; cdecl;
  ma_pulsewave_init: function(const pConfig: Pma_pulsewave_config; pWaveform: Pma_pulsewave): ma_result; cdecl;
  ma_pulsewave_uninit: procedure(pWaveform: Pma_pulsewave); cdecl;
  ma_pulsewave_read_pcm_frames: function(pWaveform: Pma_pulsewave; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_pulsewave_seek_to_pcm_frame: function(pWaveform: Pma_pulsewave; frameIndex: ma_uint64): ma_result; cdecl;
  ma_pulsewave_set_amplitude: function(pWaveform: Pma_pulsewave; amplitude: Double): ma_result; cdecl;
  ma_pulsewave_set_frequency: function(pWaveform: Pma_pulsewave; frequency: Double): ma_result; cdecl;
  ma_pulsewave_set_sample_rate: function(pWaveform: Pma_pulsewave; sampleRate: ma_uint32): ma_result; cdecl;
  ma_pulsewave_set_duty_cycle: function(pWaveform: Pma_pulsewave; dutyCycle: Double): ma_result; cdecl;
  ma_noise_config_init: function(format: ma_format; channels: ma_uint32; &type: ma_noise_type; seed: ma_int32; amplitude: Double): ma_noise_config; cdecl;
  ma_noise_get_heap_size: function(const pConfig: Pma_noise_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_noise_init_preallocated: function(const pConfig: Pma_noise_config; pHeap: Pointer; pNoise: Pma_noise): ma_result; cdecl;
  ma_noise_init: function(const pConfig: Pma_noise_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNoise: Pma_noise): ma_result; cdecl;
  ma_noise_uninit: procedure(pNoise: Pma_noise; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_noise_read_pcm_frames: function(pNoise: Pma_noise; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_noise_set_amplitude: function(pNoise: Pma_noise; amplitude: Double): ma_result; cdecl;
  ma_noise_set_seed: function(pNoise: Pma_noise; seed: ma_int32): ma_result; cdecl;
  ma_noise_set_type: function(pNoise: Pma_noise; &type: ma_noise_type): ma_result; cdecl;
  ma_resource_manager_pipeline_notifications_init: function(): ma_resource_manager_pipeline_notifications; cdecl;
  ma_resource_manager_data_source_config_init: function(): ma_resource_manager_data_source_config; cdecl;
  ma_resource_manager_config_init: function(): ma_resource_manager_config; cdecl;
  ma_resource_manager_init: function(const pConfig: Pma_resource_manager_config; pResourceManager: Pma_resource_manager): ma_result; cdecl;
  ma_resource_manager_uninit: procedure(pResourceManager: Pma_resource_manager); cdecl;
  ma_resource_manager_get_log: function(pResourceManager: Pma_resource_manager): Pma_log; cdecl;
  ma_resource_manager_register_file: function(pResourceManager: Pma_resource_manager; const pFilePath: PUTF8Char; flags: ma_uint32): ma_result; cdecl;
  ma_resource_manager_register_file_w: function(pResourceManager: Pma_resource_manager; const pFilePath: PWideChar; flags: ma_uint32): ma_result; cdecl;
  ma_resource_manager_register_decoded_data: function(pResourceManager: Pma_resource_manager; const pName: PUTF8Char; const pData: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32; sampleRate: ma_uint32): ma_result; cdecl;
  ma_resource_manager_register_decoded_data_w: function(pResourceManager: Pma_resource_manager; const pName: PWideChar; const pData: Pointer; frameCount: ma_uint64; format: ma_format; channels: ma_uint32; sampleRate: ma_uint32): ma_result; cdecl;
  ma_resource_manager_register_encoded_data: function(pResourceManager: Pma_resource_manager; const pName: PUTF8Char; const pData: Pointer; sizeInBytes: NativeUInt): ma_result; cdecl;
  ma_resource_manager_register_encoded_data_w: function(pResourceManager: Pma_resource_manager; const pName: PWideChar; const pData: Pointer; sizeInBytes: NativeUInt): ma_result; cdecl;
  ma_resource_manager_unregister_file: function(pResourceManager: Pma_resource_manager; const pFilePath: PUTF8Char): ma_result; cdecl;
  ma_resource_manager_unregister_file_w: function(pResourceManager: Pma_resource_manager; const pFilePath: PWideChar): ma_result; cdecl;
  ma_resource_manager_unregister_data: function(pResourceManager: Pma_resource_manager; const pName: PUTF8Char): ma_result; cdecl;
  ma_resource_manager_unregister_data_w: function(pResourceManager: Pma_resource_manager; const pName: PWideChar): ma_result; cdecl;
  ma_resource_manager_data_buffer_init_ex: function(pResourceManager: Pma_resource_manager; const pConfig: Pma_resource_manager_data_source_config; pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_init: function(pResourceManager: Pma_resource_manager; const pFilePath: PUTF8Char; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_init_w: function(pResourceManager: Pma_resource_manager; const pFilePath: PWideChar; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_init_copy: function(pResourceManager: Pma_resource_manager; const pExistingDataBuffer: Pma_resource_manager_data_buffer; pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_uninit: function(pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_read_pcm_frames: function(pDataBuffer: Pma_resource_manager_data_buffer; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_buffer_seek_to_pcm_frame: function(pDataBuffer: Pma_resource_manager_data_buffer; frameIndex: ma_uint64): ma_result; cdecl;
  ma_resource_manager_data_buffer_get_data_format: function(pDataBuffer: Pma_resource_manager_data_buffer; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_resource_manager_data_buffer_get_cursor_in_pcm_frames: function(pDataBuffer: Pma_resource_manager_data_buffer; pCursor: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_buffer_get_length_in_pcm_frames: function(pDataBuffer: Pma_resource_manager_data_buffer; pLength: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_buffer_result: function(const pDataBuffer: Pma_resource_manager_data_buffer): ma_result; cdecl;
  ma_resource_manager_data_buffer_set_looping: function(pDataBuffer: Pma_resource_manager_data_buffer; isLooping: ma_bool32): ma_result; cdecl;
  ma_resource_manager_data_buffer_is_looping: function(const pDataBuffer: Pma_resource_manager_data_buffer): ma_bool32; cdecl;
  ma_resource_manager_data_buffer_get_available_frames: function(pDataBuffer: Pma_resource_manager_data_buffer; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_stream_init_ex: function(pResourceManager: Pma_resource_manager; const pConfig: Pma_resource_manager_data_source_config; pDataStream: Pma_resource_manager_data_stream): ma_result; cdecl;
  ma_resource_manager_data_stream_init: function(pResourceManager: Pma_resource_manager; const pFilePath: PUTF8Char; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataStream: Pma_resource_manager_data_stream): ma_result; cdecl;
  ma_resource_manager_data_stream_init_w: function(pResourceManager: Pma_resource_manager; const pFilePath: PWideChar; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataStream: Pma_resource_manager_data_stream): ma_result; cdecl;
  ma_resource_manager_data_stream_uninit: function(pDataStream: Pma_resource_manager_data_stream): ma_result; cdecl;
  ma_resource_manager_data_stream_read_pcm_frames: function(pDataStream: Pma_resource_manager_data_stream; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_stream_seek_to_pcm_frame: function(pDataStream: Pma_resource_manager_data_stream; frameIndex: ma_uint64): ma_result; cdecl;
  ma_resource_manager_data_stream_get_data_format: function(pDataStream: Pma_resource_manager_data_stream; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_resource_manager_data_stream_get_cursor_in_pcm_frames: function(pDataStream: Pma_resource_manager_data_stream; pCursor: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_stream_get_length_in_pcm_frames: function(pDataStream: Pma_resource_manager_data_stream; pLength: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_stream_result: function(const pDataStream: Pma_resource_manager_data_stream): ma_result; cdecl;
  ma_resource_manager_data_stream_set_looping: function(pDataStream: Pma_resource_manager_data_stream; isLooping: ma_bool32): ma_result; cdecl;
  ma_resource_manager_data_stream_is_looping: function(const pDataStream: Pma_resource_manager_data_stream): ma_bool32; cdecl;
  ma_resource_manager_data_stream_get_available_frames: function(pDataStream: Pma_resource_manager_data_stream; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_source_init_ex: function(pResourceManager: Pma_resource_manager; const pConfig: Pma_resource_manager_data_source_config; pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_init: function(pResourceManager: Pma_resource_manager; const pName: PUTF8Char; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_init_w: function(pResourceManager: Pma_resource_manager; const pName: PWideChar; flags: ma_uint32; const pNotifications: Pma_resource_manager_pipeline_notifications; pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_init_copy: function(pResourceManager: Pma_resource_manager; const pExistingDataSource: Pma_resource_manager_data_source; pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_uninit: function(pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_read_pcm_frames: function(pDataSource: Pma_resource_manager_data_source; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_source_seek_to_pcm_frame: function(pDataSource: Pma_resource_manager_data_source; frameIndex: ma_uint64): ma_result; cdecl;
  ma_resource_manager_data_source_get_data_format: function(pDataSource: Pma_resource_manager_data_source; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_resource_manager_data_source_get_cursor_in_pcm_frames: function(pDataSource: Pma_resource_manager_data_source; pCursor: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_source_get_length_in_pcm_frames: function(pDataSource: Pma_resource_manager_data_source; pLength: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_data_source_result: function(const pDataSource: Pma_resource_manager_data_source): ma_result; cdecl;
  ma_resource_manager_data_source_set_looping: function(pDataSource: Pma_resource_manager_data_source; isLooping: ma_bool32): ma_result; cdecl;
  ma_resource_manager_data_source_is_looping: function(const pDataSource: Pma_resource_manager_data_source): ma_bool32; cdecl;
  ma_resource_manager_data_source_get_available_frames: function(pDataSource: Pma_resource_manager_data_source; pAvailableFrames: Pma_uint64): ma_result; cdecl;
  ma_resource_manager_post_job: function(pResourceManager: Pma_resource_manager; const pJob: Pma_job): ma_result; cdecl;
  ma_resource_manager_post_job_quit: function(pResourceManager: Pma_resource_manager): ma_result; cdecl;
  ma_resource_manager_next_job: function(pResourceManager: Pma_resource_manager; pJob: Pma_job): ma_result; cdecl;
  ma_resource_manager_process_job: function(pResourceManager: Pma_resource_manager; pJob: Pma_job): ma_result; cdecl;
  ma_resource_manager_process_next_job: function(pResourceManager: Pma_resource_manager): ma_result; cdecl;
  ma_node_config_init: function(): ma_node_config; cdecl;
  ma_node_get_heap_size: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_node_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_node_init_preallocated: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_node_config; pHeap: Pointer; pNode: Pma_node): ma_result; cdecl;
  ma_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_node): ma_result; cdecl;
  ma_node_uninit: procedure(pNode: Pma_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_node_get_node_graph: function(const pNode: Pma_node): Pma_node_graph; cdecl;
  ma_node_get_input_bus_count: function(const pNode: Pma_node): ma_uint32; cdecl;
  ma_node_get_output_bus_count: function(const pNode: Pma_node): ma_uint32; cdecl;
  ma_node_get_input_channels: function(const pNode: Pma_node; inputBusIndex: ma_uint32): ma_uint32; cdecl;
  ma_node_get_output_channels: function(const pNode: Pma_node; outputBusIndex: ma_uint32): ma_uint32; cdecl;
  ma_node_attach_output_bus: function(pNode: Pma_node; outputBusIndex: ma_uint32; pOtherNode: Pma_node; otherNodeInputBusIndex: ma_uint32): ma_result; cdecl;
  ma_node_detach_output_bus: function(pNode: Pma_node; outputBusIndex: ma_uint32): ma_result; cdecl;
  ma_node_detach_all_output_buses: function(pNode: Pma_node): ma_result; cdecl;
  ma_node_set_output_bus_volume: function(pNode: Pma_node; outputBusIndex: ma_uint32; volume: Single): ma_result; cdecl;
  ma_node_get_output_bus_volume: function(const pNode: Pma_node; outputBusIndex: ma_uint32): Single; cdecl;
  ma_node_set_state: function(pNode: Pma_node; state: ma_node_state): ma_result; cdecl;
  ma_node_get_state: function(const pNode: Pma_node): ma_node_state; cdecl;
  ma_node_set_state_time: function(pNode: Pma_node; state: ma_node_state; globalTime: ma_uint64): ma_result; cdecl;
  ma_node_get_state_time: function(const pNode: Pma_node; state: ma_node_state): ma_uint64; cdecl;
  ma_node_get_state_by_time: function(const pNode: Pma_node; globalTime: ma_uint64): ma_node_state; cdecl;
  ma_node_get_state_by_time_range: function(const pNode: Pma_node; globalTimeBeg: ma_uint64; globalTimeEnd: ma_uint64): ma_node_state; cdecl;
  ma_node_get_time: function(const pNode: Pma_node): ma_uint64; cdecl;
  ma_node_set_time: function(pNode: Pma_node; localTime: ma_uint64): ma_result; cdecl;
  ma_node_graph_config_init: function(channels: ma_uint32): ma_node_graph_config; cdecl;
  ma_node_graph_init: function(const pConfig: Pma_node_graph_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNodeGraph: Pma_node_graph): ma_result; cdecl;
  ma_node_graph_uninit: procedure(pNodeGraph: Pma_node_graph; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_node_graph_get_endpoint: function(pNodeGraph: Pma_node_graph): Pma_node; cdecl;
  ma_node_graph_read_pcm_frames: function(pNodeGraph: Pma_node_graph; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_node_graph_get_channels: function(const pNodeGraph: Pma_node_graph): ma_uint32; cdecl;
  ma_node_graph_get_time: function(const pNodeGraph: Pma_node_graph): ma_uint64; cdecl;
  ma_node_graph_set_time: function(pNodeGraph: Pma_node_graph; globalTime: ma_uint64): ma_result; cdecl;
  ma_data_source_node_config_init: function(pDataSource: Pma_data_source): ma_data_source_node_config; cdecl;
  ma_data_source_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_data_source_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pDataSourceNode: Pma_data_source_node): ma_result; cdecl;
  ma_data_source_node_uninit: procedure(pDataSourceNode: Pma_data_source_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_data_source_node_set_looping: function(pDataSourceNode: Pma_data_source_node; isLooping: ma_bool32): ma_result; cdecl;
  ma_data_source_node_is_looping: function(pDataSourceNode: Pma_data_source_node): ma_bool32; cdecl;
  ma_splitter_node_config_init: function(channels: ma_uint32): ma_splitter_node_config; cdecl;
  ma_splitter_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_splitter_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pSplitterNode: Pma_splitter_node): ma_result; cdecl;
  ma_splitter_node_uninit: procedure(pSplitterNode: Pma_splitter_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_biquad_node_config_init: function(channels: ma_uint32; b0: Single; b1: Single; b2: Single; a0: Single; a1: Single; a2: Single): ma_biquad_node_config; cdecl;
  ma_biquad_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_biquad_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_biquad_node): ma_result; cdecl;
  ma_biquad_node_reinit: function(const pConfig: Pma_biquad_config; pNode: Pma_biquad_node): ma_result; cdecl;
  ma_biquad_node_uninit: procedure(pNode: Pma_biquad_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_lpf_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_lpf_node_config; cdecl;
  ma_lpf_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_lpf_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_lpf_node): ma_result; cdecl;
  ma_lpf_node_reinit: function(const pConfig: Pma_lpf_config; pNode: Pma_lpf_node): ma_result; cdecl;
  ma_lpf_node_uninit: procedure(pNode: Pma_lpf_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hpf_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_hpf_node_config; cdecl;
  ma_hpf_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_hpf_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_hpf_node): ma_result; cdecl;
  ma_hpf_node_reinit: function(const pConfig: Pma_hpf_config; pNode: Pma_hpf_node): ma_result; cdecl;
  ma_hpf_node_uninit: procedure(pNode: Pma_hpf_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_bpf_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; cutoffFrequency: Double; order: ma_uint32): ma_bpf_node_config; cdecl;
  ma_bpf_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_bpf_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_bpf_node): ma_result; cdecl;
  ma_bpf_node_reinit: function(const pConfig: Pma_bpf_config; pNode: Pma_bpf_node): ma_result; cdecl;
  ma_bpf_node_uninit: procedure(pNode: Pma_bpf_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_notch_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; q: Double; frequency: Double): ma_notch_node_config; cdecl;
  ma_notch_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_notch_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_notch_node): ma_result; cdecl;
  ma_notch_node_reinit: function(const pConfig: Pma_notch_config; pNode: Pma_notch_node): ma_result; cdecl;
  ma_notch_node_uninit: procedure(pNode: Pma_notch_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_peak_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; q: Double; frequency: Double): ma_peak_node_config; cdecl;
  ma_peak_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_peak_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_peak_node): ma_result; cdecl;
  ma_peak_node_reinit: function(const pConfig: Pma_peak_config; pNode: Pma_peak_node): ma_result; cdecl;
  ma_peak_node_uninit: procedure(pNode: Pma_peak_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_loshelf_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; q: Double; frequency: Double): ma_loshelf_node_config; cdecl;
  ma_loshelf_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_loshelf_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_loshelf_node): ma_result; cdecl;
  ma_loshelf_node_reinit: function(const pConfig: Pma_loshelf_config; pNode: Pma_loshelf_node): ma_result; cdecl;
  ma_loshelf_node_uninit: procedure(pNode: Pma_loshelf_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_hishelf_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; gainDB: Double; q: Double; frequency: Double): ma_hishelf_node_config; cdecl;
  ma_hishelf_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_hishelf_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pNode: Pma_hishelf_node): ma_result; cdecl;
  ma_hishelf_node_reinit: function(const pConfig: Pma_hishelf_config; pNode: Pma_hishelf_node): ma_result; cdecl;
  ma_hishelf_node_uninit: procedure(pNode: Pma_hishelf_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_delay_node_config_init: function(channels: ma_uint32; sampleRate: ma_uint32; delayInFrames: ma_uint32; decay: Single): ma_delay_node_config; cdecl;
  ma_delay_node_init: function(pNodeGraph: Pma_node_graph; const pConfig: Pma_delay_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pDelayNode: Pma_delay_node): ma_result; cdecl;
  ma_delay_node_uninit: procedure(pDelayNode: Pma_delay_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_delay_node_set_wet: procedure(pDelayNode: Pma_delay_node; value: Single); cdecl;
  ma_delay_node_get_wet: function(const pDelayNode: Pma_delay_node): Single; cdecl;
  ma_delay_node_set_dry: procedure(pDelayNode: Pma_delay_node; value: Single); cdecl;
  ma_delay_node_get_dry: function(const pDelayNode: Pma_delay_node): Single; cdecl;
  ma_delay_node_set_decay: procedure(pDelayNode: Pma_delay_node; value: Single); cdecl;
  ma_delay_node_get_decay: function(const pDelayNode: Pma_delay_node): Single; cdecl;
  ma_engine_node_config_init: function(pEngine: Pma_engine; &type: ma_engine_node_type; flags: ma_uint32): ma_engine_node_config; cdecl;
  ma_engine_node_get_heap_size: function(const pConfig: Pma_engine_node_config; pHeapSizeInBytes: PNativeUInt): ma_result; cdecl;
  ma_engine_node_init_preallocated: function(const pConfig: Pma_engine_node_config; pHeap: Pointer; pEngineNode: Pma_engine_node): ma_result; cdecl;
  ma_engine_node_init: function(const pConfig: Pma_engine_node_config; const pAllocationCallbacks: Pma_allocation_callbacks; pEngineNode: Pma_engine_node): ma_result; cdecl;
  ma_engine_node_uninit: procedure(pEngineNode: Pma_engine_node; const pAllocationCallbacks: Pma_allocation_callbacks); cdecl;
  ma_sound_config_init: function(): ma_sound_config; cdecl;
  ma_sound_config_init_2: function(pEngine: Pma_engine): ma_sound_config; cdecl;
  ma_sound_group_config_init: function(): ma_sound_group_config; cdecl;
  ma_sound_group_config_init_2: function(pEngine: Pma_engine): ma_sound_group_config; cdecl;
  ma_engine_config_init: function(): ma_engine_config; cdecl;
  ma_engine_init: function(const pConfig: Pma_engine_config; pEngine: Pma_engine): ma_result; cdecl;
  ma_engine_uninit: procedure(pEngine: Pma_engine); cdecl;
  ma_engine_read_pcm_frames: function(pEngine: Pma_engine; pFramesOut: Pointer; frameCount: ma_uint64; pFramesRead: Pma_uint64): ma_result; cdecl;
  ma_engine_get_node_graph: function(pEngine: Pma_engine): Pma_node_graph; cdecl;
  ma_engine_get_resource_manager: function(pEngine: Pma_engine): Pma_resource_manager; cdecl;
  ma_engine_get_device: function(pEngine: Pma_engine): Pma_device; cdecl;
  ma_engine_get_log: function(pEngine: Pma_engine): Pma_log; cdecl;
  ma_engine_get_endpoint: function(pEngine: Pma_engine): Pma_node; cdecl;
  ma_engine_get_time_in_pcm_frames: function(const pEngine: Pma_engine): ma_uint64; cdecl;
  ma_engine_get_time_in_milliseconds: function(const pEngine: Pma_engine): ma_uint64; cdecl;
  ma_engine_set_time_in_pcm_frames: function(pEngine: Pma_engine; globalTime: ma_uint64): ma_result; cdecl;
  ma_engine_set_time_in_milliseconds: function(pEngine: Pma_engine; globalTime: ma_uint64): ma_result; cdecl;
  ma_engine_get_time: function(const pEngine: Pma_engine): ma_uint64; cdecl;
  ma_engine_set_time: function(pEngine: Pma_engine; globalTime: ma_uint64): ma_result; cdecl;
  ma_engine_get_channels: function(const pEngine: Pma_engine): ma_uint32; cdecl;
  ma_engine_get_sample_rate: function(const pEngine: Pma_engine): ma_uint32; cdecl;
  ma_engine_start: function(pEngine: Pma_engine): ma_result; cdecl;
  ma_engine_stop: function(pEngine: Pma_engine): ma_result; cdecl;
  ma_engine_set_volume: function(pEngine: Pma_engine; volume: Single): ma_result; cdecl;
  ma_engine_get_volume: function(pEngine: Pma_engine): Single; cdecl;
  ma_engine_set_gain_db: function(pEngine: Pma_engine; gainDB: Single): ma_result; cdecl;
  ma_engine_get_gain_db: function(pEngine: Pma_engine): Single; cdecl;
  ma_engine_get_listener_count: function(const pEngine: Pma_engine): ma_uint32; cdecl;
  ma_engine_find_closest_listener: function(const pEngine: Pma_engine; absolutePosX: Single; absolutePosY: Single; absolutePosZ: Single): ma_uint32; cdecl;
  ma_engine_listener_set_position: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; x: Single; y: Single; z: Single); cdecl;
  ma_engine_listener_get_position: function(const pEngine: Pma_engine; listenerIndex: ma_uint32): ma_vec3f; cdecl;
  ma_engine_listener_set_direction: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; x: Single; y: Single; z: Single); cdecl;
  ma_engine_listener_get_direction: function(const pEngine: Pma_engine; listenerIndex: ma_uint32): ma_vec3f; cdecl;
  ma_engine_listener_set_velocity: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; x: Single; y: Single; z: Single); cdecl;
  ma_engine_listener_get_velocity: function(const pEngine: Pma_engine; listenerIndex: ma_uint32): ma_vec3f; cdecl;
  ma_engine_listener_set_cone: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; innerAngleInRadians: Single; outerAngleInRadians: Single; outerGain: Single); cdecl;
  ma_engine_listener_get_cone: procedure(const pEngine: Pma_engine; listenerIndex: ma_uint32; pInnerAngleInRadians: PSingle; pOuterAngleInRadians: PSingle; pOuterGain: PSingle); cdecl;
  ma_engine_listener_set_world_up: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; x: Single; y: Single; z: Single); cdecl;
  ma_engine_listener_get_world_up: function(const pEngine: Pma_engine; listenerIndex: ma_uint32): ma_vec3f; cdecl;
  ma_engine_listener_set_enabled: procedure(pEngine: Pma_engine; listenerIndex: ma_uint32; isEnabled: ma_bool32); cdecl;
  ma_engine_listener_is_enabled: function(const pEngine: Pma_engine; listenerIndex: ma_uint32): ma_bool32; cdecl;
  ma_engine_play_sound_ex: function(pEngine: Pma_engine; const pFilePath: PUTF8Char; pNode: Pma_node; nodeInputBusIndex: ma_uint32): ma_result; cdecl;
  ma_engine_play_sound: function(pEngine: Pma_engine; const pFilePath: PUTF8Char; pGroup: Pma_sound_group): ma_result; cdecl;
  ma_sound_init_from_file: function(pEngine: Pma_engine; const pFilePath: PUTF8Char; flags: ma_uint32; pGroup: Pma_sound_group; pDoneFence: Pma_fence; pSound: Pma_sound): ma_result; cdecl;
  ma_sound_init_from_file_w: function(pEngine: Pma_engine; const pFilePath: PWideChar; flags: ma_uint32; pGroup: Pma_sound_group; pDoneFence: Pma_fence; pSound: Pma_sound): ma_result; cdecl;
  ma_sound_init_copy: function(pEngine: Pma_engine; const pExistingSound: Pma_sound; flags: ma_uint32; pGroup: Pma_sound_group; pSound: Pma_sound): ma_result; cdecl;
  ma_sound_init_from_data_source: function(pEngine: Pma_engine; pDataSource: Pma_data_source; flags: ma_uint32; pGroup: Pma_sound_group; pSound: Pma_sound): ma_result; cdecl;
  ma_sound_init_ex: function(pEngine: Pma_engine; const pConfig: Pma_sound_config; pSound: Pma_sound): ma_result; cdecl;
  ma_sound_uninit: procedure(pSound: Pma_sound); cdecl;
  ma_sound_get_engine: function(const pSound: Pma_sound): Pma_engine; cdecl;
  ma_sound_get_data_source: function(const pSound: Pma_sound): Pma_data_source; cdecl;
  ma_sound_start: function(pSound: Pma_sound): ma_result; cdecl;
  ma_sound_stop: function(pSound: Pma_sound): ma_result; cdecl;
  ma_sound_stop_with_fade_in_pcm_frames: function(pSound: Pma_sound; fadeLengthInFrames: ma_uint64): ma_result; cdecl;
  ma_sound_stop_with_fade_in_milliseconds: function(pSound: Pma_sound; fadeLengthInFrames: ma_uint64): ma_result; cdecl;
  ma_sound_set_volume: procedure(pSound: Pma_sound; volume: Single); cdecl;
  ma_sound_get_volume: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_pan: procedure(pSound: Pma_sound; pan: Single); cdecl;
  ma_sound_get_pan: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_pan_mode: procedure(pSound: Pma_sound; panMode: ma_pan_mode); cdecl;
  ma_sound_get_pan_mode: function(const pSound: Pma_sound): ma_pan_mode; cdecl;
  ma_sound_set_pitch: procedure(pSound: Pma_sound; pitch: Single); cdecl;
  ma_sound_get_pitch: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_spatialization_enabled: procedure(pSound: Pma_sound; enabled: ma_bool32); cdecl;
  ma_sound_is_spatialization_enabled: function(const pSound: Pma_sound): ma_bool32; cdecl;
  ma_sound_set_pinned_listener_index: procedure(pSound: Pma_sound; listenerIndex: ma_uint32); cdecl;
  ma_sound_get_pinned_listener_index: function(const pSound: Pma_sound): ma_uint32; cdecl;
  ma_sound_get_listener_index: function(const pSound: Pma_sound): ma_uint32; cdecl;
  ma_sound_get_direction_to_listener: function(const pSound: Pma_sound): ma_vec3f; cdecl;
  ma_sound_set_position: procedure(pSound: Pma_sound; x: Single; y: Single; z: Single); cdecl;
  ma_sound_get_position: function(const pSound: Pma_sound): ma_vec3f; cdecl;
  ma_sound_set_direction: procedure(pSound: Pma_sound; x: Single; y: Single; z: Single); cdecl;
  ma_sound_get_direction: function(const pSound: Pma_sound): ma_vec3f; cdecl;
  ma_sound_set_velocity: procedure(pSound: Pma_sound; x: Single; y: Single; z: Single); cdecl;
  ma_sound_get_velocity: function(const pSound: Pma_sound): ma_vec3f; cdecl;
  ma_sound_set_attenuation_model: procedure(pSound: Pma_sound; attenuationModel: ma_attenuation_model); cdecl;
  ma_sound_get_attenuation_model: function(const pSound: Pma_sound): ma_attenuation_model; cdecl;
  ma_sound_set_positioning: procedure(pSound: Pma_sound; positioning: ma_positioning); cdecl;
  ma_sound_get_positioning: function(const pSound: Pma_sound): ma_positioning; cdecl;
  ma_sound_set_rolloff: procedure(pSound: Pma_sound; rolloff: Single); cdecl;
  ma_sound_get_rolloff: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_min_gain: procedure(pSound: Pma_sound; minGain: Single); cdecl;
  ma_sound_get_min_gain: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_max_gain: procedure(pSound: Pma_sound; maxGain: Single); cdecl;
  ma_sound_get_max_gain: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_min_distance: procedure(pSound: Pma_sound; minDistance: Single); cdecl;
  ma_sound_get_min_distance: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_max_distance: procedure(pSound: Pma_sound; maxDistance: Single); cdecl;
  ma_sound_get_max_distance: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_cone: procedure(pSound: Pma_sound; innerAngleInRadians: Single; outerAngleInRadians: Single; outerGain: Single); cdecl;
  ma_sound_get_cone: procedure(const pSound: Pma_sound; pInnerAngleInRadians: PSingle; pOuterAngleInRadians: PSingle; pOuterGain: PSingle); cdecl;
  ma_sound_set_doppler_factor: procedure(pSound: Pma_sound; dopplerFactor: Single); cdecl;
  ma_sound_get_doppler_factor: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_directional_attenuation_factor: procedure(pSound: Pma_sound; directionalAttenuationFactor: Single); cdecl;
  ma_sound_get_directional_attenuation_factor: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_fade_in_pcm_frames: procedure(pSound: Pma_sound; volumeBeg: Single; volumeEnd: Single; fadeLengthInFrames: ma_uint64); cdecl;
  ma_sound_set_fade_in_milliseconds: procedure(pSound: Pma_sound; volumeBeg: Single; volumeEnd: Single; fadeLengthInMilliseconds: ma_uint64); cdecl;
  ma_sound_set_fade_start_in_pcm_frames: procedure(pSound: Pma_sound; volumeBeg: Single; volumeEnd: Single; fadeLengthInFrames: ma_uint64; absoluteGlobalTimeInFrames: ma_uint64); cdecl;
  ma_sound_set_fade_start_in_milliseconds: procedure(pSound: Pma_sound; volumeBeg: Single; volumeEnd: Single; fadeLengthInMilliseconds: ma_uint64; absoluteGlobalTimeInMilliseconds: ma_uint64); cdecl;
  ma_sound_get_current_fade_volume: function(const pSound: Pma_sound): Single; cdecl;
  ma_sound_set_start_time_in_pcm_frames: procedure(pSound: Pma_sound; absoluteGlobalTimeInFrames: ma_uint64); cdecl;
  ma_sound_set_start_time_in_milliseconds: procedure(pSound: Pma_sound; absoluteGlobalTimeInMilliseconds: ma_uint64); cdecl;
  ma_sound_set_stop_time_in_pcm_frames: procedure(pSound: Pma_sound; absoluteGlobalTimeInFrames: ma_uint64); cdecl;
  ma_sound_set_stop_time_in_milliseconds: procedure(pSound: Pma_sound; absoluteGlobalTimeInMilliseconds: ma_uint64); cdecl;
  ma_sound_set_stop_time_with_fade_in_pcm_frames: procedure(pSound: Pma_sound; stopAbsoluteGlobalTimeInFrames: ma_uint64; fadeLengthInFrames: ma_uint64); cdecl;
  ma_sound_set_stop_time_with_fade_in_milliseconds: procedure(pSound: Pma_sound; stopAbsoluteGlobalTimeInMilliseconds: ma_uint64; fadeLengthInMilliseconds: ma_uint64); cdecl;
  ma_sound_is_playing: function(const pSound: Pma_sound): ma_bool32; cdecl;
  ma_sound_get_time_in_pcm_frames: function(const pSound: Pma_sound): ma_uint64; cdecl;
  ma_sound_get_time_in_milliseconds: function(const pSound: Pma_sound): ma_uint64; cdecl;
  ma_sound_set_looping: procedure(pSound: Pma_sound; isLooping: ma_bool32); cdecl;
  ma_sound_is_looping: function(const pSound: Pma_sound): ma_bool32; cdecl;
  ma_sound_at_end: function(const pSound: Pma_sound): ma_bool32; cdecl;
  ma_sound_seek_to_pcm_frame: function(pSound: Pma_sound; frameIndex: ma_uint64): ma_result; cdecl;
  ma_sound_seek_to_second: function(pSound: Pma_sound; seekPointInSeconds: Single): ma_result; cdecl;
  ma_sound_get_data_format: function(pSound: Pma_sound; pFormat: Pma_format; pChannels: Pma_uint32; pSampleRate: Pma_uint32; pChannelMap: Pma_channel; channelMapCap: NativeUInt): ma_result; cdecl;
  ma_sound_get_cursor_in_pcm_frames: function(pSound: Pma_sound; pCursor: Pma_uint64): ma_result; cdecl;
  ma_sound_get_length_in_pcm_frames: function(pSound: Pma_sound; pLength: Pma_uint64): ma_result; cdecl;
  ma_sound_get_cursor_in_seconds: function(pSound: Pma_sound; pCursor: PSingle): ma_result; cdecl;
  ma_sound_get_length_in_seconds: function(pSound: Pma_sound; pLength: PSingle): ma_result; cdecl;
  ma_sound_set_end_callback: function(pSound: Pma_sound; callback: ma_sound_end_proc; pUserData: Pointer): ma_result; cdecl;
  ma_sound_group_init: function(pEngine: Pma_engine; flags: ma_uint32; pParentGroup: Pma_sound_group; pGroup: Pma_sound_group): ma_result; cdecl;
  ma_sound_group_init_ex: function(pEngine: Pma_engine; const pConfig: Pma_sound_group_config; pGroup: Pma_sound_group): ma_result; cdecl;
  ma_sound_group_uninit: procedure(pGroup: Pma_sound_group); cdecl;
  ma_sound_group_get_engine: function(const pGroup: Pma_sound_group): Pma_engine; cdecl;
  ma_sound_group_start: function(pGroup: Pma_sound_group): ma_result; cdecl;
  ma_sound_group_stop: function(pGroup: Pma_sound_group): ma_result; cdecl;
  ma_sound_group_set_volume: procedure(pGroup: Pma_sound_group; volume: Single); cdecl;
  ma_sound_group_get_volume: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_pan: procedure(pGroup: Pma_sound_group; pan: Single); cdecl;
  ma_sound_group_get_pan: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_pan_mode: procedure(pGroup: Pma_sound_group; panMode: ma_pan_mode); cdecl;
  ma_sound_group_get_pan_mode: function(const pGroup: Pma_sound_group): ma_pan_mode; cdecl;
  ma_sound_group_set_pitch: procedure(pGroup: Pma_sound_group; pitch: Single); cdecl;
  ma_sound_group_get_pitch: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_spatialization_enabled: procedure(pGroup: Pma_sound_group; enabled: ma_bool32); cdecl;
  ma_sound_group_is_spatialization_enabled: function(const pGroup: Pma_sound_group): ma_bool32; cdecl;
  ma_sound_group_set_pinned_listener_index: procedure(pGroup: Pma_sound_group; listenerIndex: ma_uint32); cdecl;
  ma_sound_group_get_pinned_listener_index: function(const pGroup: Pma_sound_group): ma_uint32; cdecl;
  ma_sound_group_get_listener_index: function(const pGroup: Pma_sound_group): ma_uint32; cdecl;
  ma_sound_group_get_direction_to_listener: function(const pGroup: Pma_sound_group): ma_vec3f; cdecl;
  ma_sound_group_set_position: procedure(pGroup: Pma_sound_group; x: Single; y: Single; z: Single); cdecl;
  ma_sound_group_get_position: function(const pGroup: Pma_sound_group): ma_vec3f; cdecl;
  ma_sound_group_set_direction: procedure(pGroup: Pma_sound_group; x: Single; y: Single; z: Single); cdecl;
  ma_sound_group_get_direction: function(const pGroup: Pma_sound_group): ma_vec3f; cdecl;
  ma_sound_group_set_velocity: procedure(pGroup: Pma_sound_group; x: Single; y: Single; z: Single); cdecl;
  ma_sound_group_get_velocity: function(const pGroup: Pma_sound_group): ma_vec3f; cdecl;
  ma_sound_group_set_attenuation_model: procedure(pGroup: Pma_sound_group; attenuationModel: ma_attenuation_model); cdecl;
  ma_sound_group_get_attenuation_model: function(const pGroup: Pma_sound_group): ma_attenuation_model; cdecl;
  ma_sound_group_set_positioning: procedure(pGroup: Pma_sound_group; positioning: ma_positioning); cdecl;
  ma_sound_group_get_positioning: function(const pGroup: Pma_sound_group): ma_positioning; cdecl;
  ma_sound_group_set_rolloff: procedure(pGroup: Pma_sound_group; rolloff: Single); cdecl;
  ma_sound_group_get_rolloff: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_min_gain: procedure(pGroup: Pma_sound_group; minGain: Single); cdecl;
  ma_sound_group_get_min_gain: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_max_gain: procedure(pGroup: Pma_sound_group; maxGain: Single); cdecl;
  ma_sound_group_get_max_gain: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_min_distance: procedure(pGroup: Pma_sound_group; minDistance: Single); cdecl;
  ma_sound_group_get_min_distance: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_max_distance: procedure(pGroup: Pma_sound_group; maxDistance: Single); cdecl;
  ma_sound_group_get_max_distance: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_cone: procedure(pGroup: Pma_sound_group; innerAngleInRadians: Single; outerAngleInRadians: Single; outerGain: Single); cdecl;
  ma_sound_group_get_cone: procedure(const pGroup: Pma_sound_group; pInnerAngleInRadians: PSingle; pOuterAngleInRadians: PSingle; pOuterGain: PSingle); cdecl;
  ma_sound_group_set_doppler_factor: procedure(pGroup: Pma_sound_group; dopplerFactor: Single); cdecl;
  ma_sound_group_get_doppler_factor: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_directional_attenuation_factor: procedure(pGroup: Pma_sound_group; directionalAttenuationFactor: Single); cdecl;
  ma_sound_group_get_directional_attenuation_factor: function(const pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_fade_in_pcm_frames: procedure(pGroup: Pma_sound_group; volumeBeg: Single; volumeEnd: Single; fadeLengthInFrames: ma_uint64); cdecl;
  ma_sound_group_set_fade_in_milliseconds: procedure(pGroup: Pma_sound_group; volumeBeg: Single; volumeEnd: Single; fadeLengthInMilliseconds: ma_uint64); cdecl;
  ma_sound_group_get_current_fade_volume: function(pGroup: Pma_sound_group): Single; cdecl;
  ma_sound_group_set_start_time_in_pcm_frames: procedure(pGroup: Pma_sound_group; absoluteGlobalTimeInFrames: ma_uint64); cdecl;
  ma_sound_group_set_start_time_in_milliseconds: procedure(pGroup: Pma_sound_group; absoluteGlobalTimeInMilliseconds: ma_uint64); cdecl;
  ma_sound_group_set_stop_time_in_pcm_frames: procedure(pGroup: Pma_sound_group; absoluteGlobalTimeInFrames: ma_uint64); cdecl;
  ma_sound_group_set_stop_time_in_milliseconds: procedure(pGroup: Pma_sound_group; absoluteGlobalTimeInMilliseconds: ma_uint64); cdecl;
  ma_sound_group_is_playing: function(const pGroup: Pma_sound_group): ma_bool32; cdecl;
  ma_sound_group_get_time_in_pcm_frames: function(const pGroup: Pma_sound_group): ma_uint64; cdecl;
  plm_create_with_memory: function(bytes: PUInt8; length: NativeUInt; free_when_done: Integer): Pplm_t; cdecl;
  plm_create_with_buffer: function(buffer: Pplm_buffer_t; destroy_when_done: Integer): Pplm_t; cdecl;
  plm_destroy: procedure(self: Pplm_t); cdecl;
  plm_has_headers: function(self: Pplm_t): Integer; cdecl;
  plm_probe: function(self: Pplm_t; probesize: NativeUInt): Integer; cdecl;
  plm_get_video_enabled: function(self: Pplm_t): Integer; cdecl;
  plm_set_video_enabled: procedure(self: Pplm_t; enabled: Integer); cdecl;
  plm_get_num_video_streams: function(self: Pplm_t): Integer; cdecl;
  plm_get_width: function(self: Pplm_t): Integer; cdecl;
  plm_get_height: function(self: Pplm_t): Integer; cdecl;
  plm_get_pixel_aspect_ratio: function(self: Pplm_t): Double; cdecl;
  plm_get_framerate: function(self: Pplm_t): Double; cdecl;
  plm_get_audio_enabled: function(self: Pplm_t): Integer; cdecl;
  plm_set_audio_enabled: procedure(self: Pplm_t; enabled: Integer); cdecl;
  plm_get_num_audio_streams: function(self: Pplm_t): Integer; cdecl;
  plm_set_audio_stream: procedure(self: Pplm_t; stream_index: Integer); cdecl;
  plm_get_samplerate: function(self: Pplm_t): Integer; cdecl;
  plm_get_audio_lead_time: function(self: Pplm_t): Double; cdecl;
  plm_set_audio_lead_time: procedure(self: Pplm_t; lead_time: Double); cdecl;
  plm_get_time: function(self: Pplm_t): Double; cdecl;
  plm_get_duration: function(self: Pplm_t): Double; cdecl;
  plm_rewind: procedure(self: Pplm_t); cdecl;
  plm_get_loop: function(self: Pplm_t): Integer; cdecl;
  plm_set_loop: procedure(self: Pplm_t; loop: Integer); cdecl;
  plm_has_ended: function(self: Pplm_t): Integer; cdecl;
  plm_set_video_decode_callback: procedure(self: Pplm_t; fp: plm_video_decode_callback; user: Pointer); cdecl;
  plm_set_audio_decode_callback: procedure(self: Pplm_t; fp: plm_audio_decode_callback; user: Pointer); cdecl;
  plm_decode: procedure(self: Pplm_t; seconds: Double); cdecl;
  plm_decode_video: function(self: Pplm_t): Pplm_frame_t; cdecl;
  plm_decode_audio: function(self: Pplm_t): Pplm_samples_t; cdecl;
  plm_seek: function(self: Pplm_t; time: Double; seek_exact: Integer): Integer; cdecl;
  plm_seek_frame: function(self: Pplm_t; time: Double; seek_exact: Integer): Pplm_frame_t; cdecl;
  plm_buffer_create_with_callbacks: function(load_callback: plm_buffer_load_callback; seek_callback: plm_buffer_seek_callback; tell_callback: plm_buffer_tell_callback; length: NativeUInt; user: Pointer): Pplm_buffer_t; cdecl;
  plm_buffer_create_with_memory: function(bytes: PUInt8; length: NativeUInt; free_when_done: Integer): Pplm_buffer_t; cdecl;
  plm_buffer_create_with_capacity: function(capacity: NativeUInt): Pplm_buffer_t; cdecl;
  plm_buffer_create_for_appending: function(initial_capacity: NativeUInt): Pplm_buffer_t; cdecl;
  plm_buffer_destroy: procedure(self: Pplm_buffer_t); cdecl;
  plm_buffer_write: function(self: Pplm_buffer_t; bytes: PUInt8; length: NativeUInt): NativeUInt; cdecl;
  plm_buffer_signal_end: procedure(self: Pplm_buffer_t); cdecl;
  plm_buffer_set_load_callback: procedure(self: Pplm_buffer_t; fp: plm_buffer_load_callback; user: Pointer); cdecl;
  plm_buffer_rewind: procedure(self: Pplm_buffer_t); cdecl;
  plm_buffer_get_size: function(self: Pplm_buffer_t): NativeUInt; cdecl;
  plm_buffer_get_remaining: function(self: Pplm_buffer_t): NativeUInt; cdecl;
  plm_buffer_has_ended: function(self: Pplm_buffer_t): Integer; cdecl;
  plm_demux_create: function(buffer: Pplm_buffer_t; destroy_when_done: Integer): Pplm_demux_t; cdecl;
  plm_demux_destroy: procedure(self: Pplm_demux_t); cdecl;
  plm_demux_has_headers: function(self: Pplm_demux_t): Integer; cdecl;
  plm_demux_probe: function(self: Pplm_demux_t; probesize: NativeUInt): Integer; cdecl;
  plm_demux_get_num_video_streams: function(self: Pplm_demux_t): Integer; cdecl;
  plm_demux_get_num_audio_streams: function(self: Pplm_demux_t): Integer; cdecl;
  plm_demux_rewind: procedure(self: Pplm_demux_t); cdecl;
  plm_demux_has_ended: function(self: Pplm_demux_t): Integer; cdecl;
  plm_demux_seek: function(self: Pplm_demux_t; time: Double; &type: Integer; force_intra: Integer): Pplm_packet_t; cdecl;
  plm_demux_get_start_time: function(self: Pplm_demux_t; &type: Integer): Double; cdecl;
  plm_demux_get_duration: function(self: Pplm_demux_t; &type: Integer): Double; cdecl;
  plm_demux_decode: function(self: Pplm_demux_t): Pplm_packet_t; cdecl;
  plm_video_create_with_buffer: function(buffer: Pplm_buffer_t; destroy_when_done: Integer): Pplm_video_t; cdecl;
  plm_video_destroy: procedure(self: Pplm_video_t); cdecl;
  plm_video_has_header: function(self: Pplm_video_t): Integer; cdecl;
  plm_video_get_framerate: function(self: Pplm_video_t): Double; cdecl;
  plm_video_get_pixel_aspect_ratio: function(self: Pplm_video_t): Double; cdecl;
  plm_video_get_width: function(self: Pplm_video_t): Integer; cdecl;
  plm_video_get_height: function(self: Pplm_video_t): Integer; cdecl;
  plm_video_set_no_delay: procedure(self: Pplm_video_t; no_delay: Integer); cdecl;
  plm_video_get_time: function(self: Pplm_video_t): Double; cdecl;
  plm_video_set_time: procedure(self: Pplm_video_t; time: Double); cdecl;
  plm_video_rewind: procedure(self: Pplm_video_t); cdecl;
  plm_video_has_ended: function(self: Pplm_video_t): Integer; cdecl;
  plm_video_decode: function(self: Pplm_video_t): Pplm_frame_t; cdecl;
  plm_frame_to_rgb: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_frame_to_bgr: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_frame_to_rgba: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_frame_to_bgra: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_frame_to_argb: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_frame_to_abgr: procedure(frame: Pplm_frame_t; dest: PUInt8; stride: Integer); cdecl;
  plm_audio_create_with_buffer: function(buffer: Pplm_buffer_t; destroy_when_done: Integer): Pplm_audio_t; cdecl;
  plm_audio_destroy: procedure(self: Pplm_audio_t); cdecl;
  plm_audio_has_header: function(self: Pplm_audio_t): Integer; cdecl;
  plm_audio_get_samplerate: function(self: Pplm_audio_t): Integer; cdecl;
  plm_audio_get_time: function(self: Pplm_audio_t): Double; cdecl;
  plm_audio_set_time: procedure(self: Pplm_audio_t; time: Double); cdecl;
  plm_audio_rewind: procedure(self: Pplm_audio_t); cdecl;
  plm_audio_has_ended: function(self: Pplm_audio_t): Integer; cdecl;
  plm_audio_decode: function(self: Pplm_audio_t): Pplm_samples_t; cdecl;
  sqlite3_libversion: function(): PUTF8Char; cdecl;
  sqlite3_sourceid: function(): PUTF8Char; cdecl;
  sqlite3_libversion_number: function(): Integer; cdecl;
  sqlite3_compileoption_used: function(const zOptName: PUTF8Char): Integer; cdecl;
  sqlite3_compileoption_get: function(N: Integer): PUTF8Char; cdecl;
  sqlite3_threadsafe: function(): Integer; cdecl;
  sqlite3_close: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_close_v2: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_exec: function(p1: Psqlite3; const sql: PUTF8Char; callback: sqlite3_exec_callback; p4: Pointer; errmsg: PPUTF8Char): Integer; cdecl;
  sqlite3_initialize: function(): Integer; cdecl;
  sqlite3_shutdown: function(): Integer; cdecl;
  sqlite3_os_init: function(): Integer; cdecl;
  sqlite3_os_end: function(): Integer; cdecl;
  sqlite3_config: function(p1: Integer): Integer varargs; cdecl;
  sqlite3_db_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
  sqlite3_extended_result_codes: function(p1: Psqlite3; onoff: Integer): Integer; cdecl;
  sqlite3_last_insert_rowid: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_set_last_insert_rowid: procedure(p1: Psqlite3; p2: sqlite3_int64); cdecl;
  sqlite3_changes: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_total_changes: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_total_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_interrupt: procedure(p1: Psqlite3); cdecl;
  sqlite3_is_interrupted: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_complete: function(const sql: PUTF8Char): Integer; cdecl;
  sqlite3_complete16: function(const sql: Pointer): Integer; cdecl;
  sqlite3_busy_handler: function(p1: Psqlite3; p2: sqlite3_busy_handler_; p3: Pointer): Integer; cdecl;
  sqlite3_busy_timeout: function(p1: Psqlite3; ms: Integer): Integer; cdecl;
  sqlite3_setlk_timeout: function(p1: Psqlite3; ms: Integer; flags: Integer): Integer; cdecl;
  sqlite3_get_table: function(db: Psqlite3; const zSql: PUTF8Char; pazResult: PPPUTF8Char; pnRow: PInteger; pnColumn: PInteger; pzErrmsg: PPUTF8Char): Integer; cdecl;
  sqlite3_free_table: procedure(result: PPUTF8Char); cdecl;
  sqlite3_mprintf: function(const p1: PUTF8Char): PUTF8Char varargs; cdecl;
  sqlite3_vmprintf: function(const p1: PUTF8Char; p2: Pointer): PUTF8Char; cdecl;
  sqlite3_snprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char): PUTF8Char varargs; cdecl;
  sqlite3_vsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char; p4: Pointer): PUTF8Char; cdecl;
  sqlite3_malloc: function(p1: Integer): Pointer; cdecl;
  sqlite3_malloc64: function(p1: sqlite3_uint64): Pointer; cdecl;
  sqlite3_realloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
  sqlite3_realloc64: function(p1: Pointer; p2: sqlite3_uint64): Pointer; cdecl;
  sqlite3_free: procedure(p1: Pointer); cdecl;
  sqlite3_msize: function(p1: Pointer): sqlite3_uint64; cdecl;
  sqlite3_memory_used: function(): sqlite3_int64; cdecl;
  sqlite3_memory_highwater: function(resetFlag: Integer): sqlite3_int64; cdecl;
  sqlite3_randomness: procedure(N: Integer; P: Pointer); cdecl;
  sqlite3_set_authorizer: function(p1: Psqlite3; xAuth: sqlite3_set_authorizer_xAuth; pUserData: Pointer): Integer; cdecl;
  sqlite3_trace: function(p1: Psqlite3; xTrace: sqlite3_trace_xTrace; p3: Pointer): Pointer; cdecl;
  sqlite3_profile: function(p1: Psqlite3; xProfile: sqlite3_profile_xProfile; p3: Pointer): Pointer; cdecl;
  sqlite3_trace_v2: function(p1: Psqlite3; uMask: Cardinal; xCallback: sqlite3_trace_v2_xCallback; pCtx: Pointer): Integer; cdecl;
  sqlite3_progress_handler: procedure(p1: Psqlite3; p2: Integer; p3: sqlite3_progress_handler_; p4: Pointer); cdecl;
  sqlite3_open: function(const filename: PUTF8Char; ppDb: PPsqlite3): Integer; cdecl;
  sqlite3_open16: function(const filename: Pointer; ppDb: PPsqlite3): Integer; cdecl;
  sqlite3_open_v2: function(const filename: PUTF8Char; ppDb: PPsqlite3; flags: Integer; const zVfs: PUTF8Char): Integer; cdecl;
  sqlite3_uri_parameter: function(z: sqlite3_filename; const zParam: PUTF8Char): PUTF8Char; cdecl;
  sqlite3_uri_boolean: function(z: sqlite3_filename; const zParam: PUTF8Char; bDefault: Integer): Integer; cdecl;
  sqlite3_uri_int64: function(p1: sqlite3_filename; const p2: PUTF8Char; p3: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_uri_key: function(z: sqlite3_filename; N: Integer): PUTF8Char; cdecl;
  sqlite3_filename_database: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_filename_journal: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_filename_wal: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_database_file_object: function(const p1: PUTF8Char): Psqlite3_file; cdecl;
  sqlite3_create_filename: function(const zDatabase: PUTF8Char; const zJournal: PUTF8Char; const zWal: PUTF8Char; nParam: Integer; azParam: PPUTF8Char): sqlite3_filename; cdecl;
  sqlite3_free_filename: procedure(p1: sqlite3_filename); cdecl;
  sqlite3_errcode: function(db: Psqlite3): Integer; cdecl;
  sqlite3_extended_errcode: function(db: Psqlite3): Integer; cdecl;
  sqlite3_errmsg: function(p1: Psqlite3): PUTF8Char; cdecl;
  sqlite3_errmsg16: function(p1: Psqlite3): Pointer; cdecl;
  sqlite3_errstr: function(p1: Integer): PUTF8Char; cdecl;
  sqlite3_error_offset: function(db: Psqlite3): Integer; cdecl;
  sqlite3_limit: function(p1: Psqlite3; id: Integer; newVal: Integer): Integer; cdecl;
  sqlite3_prepare: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare_v2: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare_v3: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; prepFlags: Cardinal; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare16: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_prepare16_v2: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_prepare16_v3: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; prepFlags: Cardinal; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_sql: function(pStmt: Psqlite3_stmt): PUTF8Char; cdecl;
  sqlite3_expanded_sql: function(pStmt: Psqlite3_stmt): PUTF8Char; cdecl;
  sqlite3_stmt_readonly: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_stmt_isexplain: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_stmt_explain: function(pStmt: Psqlite3_stmt; eMode: Integer): Integer; cdecl;
  sqlite3_stmt_busy: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_bind_blob: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; n: Integer; p5: sqlite3_bind_blob_): Integer; cdecl;
  sqlite3_bind_blob64: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: sqlite3_uint64; p5: sqlite3_bind_blob64_): Integer; cdecl;
  sqlite3_bind_double: function(p1: Psqlite3_stmt; p2: Integer; p3: Double): Integer; cdecl;
  sqlite3_bind_int: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
  sqlite3_bind_int64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_int64): Integer; cdecl;
  sqlite3_bind_null: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
  sqlite3_bind_text: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: Integer; p5: sqlite3_bind_text_): Integer; cdecl;
  sqlite3_bind_text16: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: Integer; p5: sqlite3_bind_text16_): Integer; cdecl;
  sqlite3_bind_text64: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: sqlite3_uint64; p5: sqlite3_bind_text64_; encoding: Byte): Integer; cdecl;
  sqlite3_bind_value: function(p1: Psqlite3_stmt; p2: Integer; const p3: Psqlite3_value): Integer; cdecl;
  sqlite3_bind_pointer: function(p1: Psqlite3_stmt; p2: Integer; p3: Pointer; const p4: PUTF8Char; p5: sqlite3_bind_pointer_): Integer; cdecl;
  sqlite3_bind_zeroblob: function(p1: Psqlite3_stmt; p2: Integer; n: Integer): Integer; cdecl;
  sqlite3_bind_zeroblob64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_uint64): Integer; cdecl;
  sqlite3_bind_parameter_count: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_bind_parameter_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_bind_parameter_index: function(p1: Psqlite3_stmt; const zName: PUTF8Char): Integer; cdecl;
  sqlite3_clear_bindings: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_name: function(p1: Psqlite3_stmt; N: Integer): PUTF8Char; cdecl;
  sqlite3_column_name16: function(p1: Psqlite3_stmt; N: Integer): Pointer; cdecl;
  sqlite3_column_database_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_database_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_table_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_table_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_origin_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_origin_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_decltype: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_decltype16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_step: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_data_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_blob: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
  sqlite3_column_double: function(p1: Psqlite3_stmt; iCol: Integer): Double; cdecl;
  sqlite3_column_int: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_int64: function(p1: Psqlite3_stmt; iCol: Integer): sqlite3_int64; cdecl;
  sqlite3_column_text: function(p1: Psqlite3_stmt; iCol: Integer): PByte; cdecl;
  sqlite3_column_text16: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
  sqlite3_column_value: function(p1: Psqlite3_stmt; iCol: Integer): Psqlite3_value; cdecl;
  sqlite3_column_bytes: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_bytes16: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_type: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_finalize: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_reset: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_create_function: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function_xFunc; xStep: sqlite3_create_function_xStep; xFinal: sqlite3_create_function_xFinal): Integer; cdecl;
  sqlite3_create_function16: function(db: Psqlite3; const zFunctionName: Pointer; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function16_xFunc; xStep: sqlite3_create_function16_xStep; xFinal: sqlite3_create_function16_xFinal): Integer; cdecl;
  sqlite3_create_function_v2: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function_v2_xFunc; xStep: sqlite3_create_function_v2_xStep; xFinal: sqlite3_create_function_v2_xFinal; xDestroy: sqlite3_create_function_v2_xDestroy): Integer; cdecl;
  sqlite3_create_window_function: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xStep: sqlite3_create_window_function_xStep; xFinal: sqlite3_create_window_function_xFinal; xValue: sqlite3_create_window_function_xValue; xInverse: sqlite3_create_window_function_xInverse; xDestroy: sqlite3_create_window_function_xDestroy): Integer; cdecl;
  sqlite3_aggregate_count: function(p1: Psqlite3_context): Integer; cdecl;
  sqlite3_expired: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_transfer_bindings: function(p1: Psqlite3_stmt; p2: Psqlite3_stmt): Integer; cdecl;
  sqlite3_global_recover: function(): Integer; cdecl;
  sqlite3_thread_cleanup: procedure(); cdecl;
  sqlite3_memory_alarm: function(p1: sqlite3_memory_alarm_; p2: Pointer; p3: sqlite3_int64): Integer; cdecl;
  sqlite3_value_blob: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_double: function(p1: Psqlite3_value): Double; cdecl;
  sqlite3_value_int: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_int64: function(p1: Psqlite3_value): sqlite3_int64; cdecl;
  sqlite3_value_pointer: function(p1: Psqlite3_value; const p2: PUTF8Char): Pointer; cdecl;
  sqlite3_value_text: function(p1: Psqlite3_value): PByte; cdecl;
  sqlite3_value_text16: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_text16le: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_text16be: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_bytes: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_bytes16: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_type: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_numeric_type: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_nochange: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_frombind: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_encoding: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_subtype: function(p1: Psqlite3_value): Cardinal; cdecl;
  sqlite3_value_dup: function(const p1: Psqlite3_value): Psqlite3_value; cdecl;
  sqlite3_value_free: procedure(p1: Psqlite3_value); cdecl;
  sqlite3_aggregate_context: function(p1: Psqlite3_context; nBytes: Integer): Pointer; cdecl;
  sqlite3_user_data: function(p1: Psqlite3_context): Pointer; cdecl;
  sqlite3_context_db_handle: function(p1: Psqlite3_context): Psqlite3; cdecl;
  sqlite3_get_auxdata: function(p1: Psqlite3_context; N: Integer): Pointer; cdecl;
  sqlite3_set_auxdata: procedure(p1: Psqlite3_context; N: Integer; p3: Pointer; p4: sqlite3_set_auxdata_); cdecl;
  sqlite3_get_clientdata: function(p1: Psqlite3; const p2: PUTF8Char): Pointer; cdecl;
  sqlite3_set_clientdata: function(p1: Psqlite3; const p2: PUTF8Char; p3: Pointer; p4: sqlite3_set_clientdata_): Integer; cdecl;
  sqlite3_result_blob: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_blob_); cdecl;
  sqlite3_result_blob64: procedure(p1: Psqlite3_context; const p2: Pointer; p3: sqlite3_uint64; p4: sqlite3_result_blob64_); cdecl;
  sqlite3_result_double: procedure(p1: Psqlite3_context; p2: Double); cdecl;
  sqlite3_result_error: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer); cdecl;
  sqlite3_result_error16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer); cdecl;
  sqlite3_result_error_toobig: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_error_nomem: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_error_code: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
  sqlite3_result_int: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
  sqlite3_result_int64: procedure(p1: Psqlite3_context; p2: sqlite3_int64); cdecl;
  sqlite3_result_null: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_text: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer; p4: sqlite3_result_text_); cdecl;
  sqlite3_result_text64: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: sqlite3_uint64; p4: sqlite3_result_text64_; encoding: Byte); cdecl;
  sqlite3_result_text16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16_); cdecl;
  sqlite3_result_text16le: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16le_); cdecl;
  sqlite3_result_text16be: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16be_); cdecl;
  sqlite3_result_value: procedure(p1: Psqlite3_context; p2: Psqlite3_value); cdecl;
  sqlite3_result_pointer: procedure(p1: Psqlite3_context; p2: Pointer; const p3: PUTF8Char; p4: sqlite3_result_pointer_); cdecl;
  sqlite3_result_zeroblob: procedure(p1: Psqlite3_context; n: Integer); cdecl;
  sqlite3_result_zeroblob64: function(p1: Psqlite3_context; n: sqlite3_uint64): Integer; cdecl;
  sqlite3_result_subtype: procedure(p1: Psqlite3_context; p2: Cardinal); cdecl;
  sqlite3_create_collation: function(p1: Psqlite3; const zName: PUTF8Char; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation_xCompare): Integer; cdecl;
  sqlite3_create_collation_v2: function(p1: Psqlite3; const zName: PUTF8Char; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation_v2_xCompare; xDestroy: sqlite3_create_collation_v2_xDestroy): Integer; cdecl;
  sqlite3_create_collation16: function(p1: Psqlite3; const zName: Pointer; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation16_xCompare): Integer; cdecl;
  sqlite3_collation_needed: function(p1: Psqlite3; p2: Pointer; p3: sqlite3_collation_needed_): Integer; cdecl;
  sqlite3_collation_needed16: function(p1: Psqlite3; p2: Pointer; p3: sqlite3_collation_needed16_): Integer; cdecl;
  sqlite3_sleep: function(p1: Integer): Integer; cdecl;
  sqlite3_win32_set_directory: function(&type: Longword; zValue: Pointer): Integer; cdecl;
  sqlite3_win32_set_directory8: function(&type: Longword; const zValue: PUTF8Char): Integer; cdecl;
  sqlite3_win32_set_directory16: function(&type: Longword; const zValue: Pointer): Integer; cdecl;
  sqlite3_get_autocommit: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_db_handle: function(p1: Psqlite3_stmt): Psqlite3; cdecl;
  sqlite3_db_name: function(db: Psqlite3; N: Integer): PUTF8Char; cdecl;
  sqlite3_db_filename: function(db: Psqlite3; const zDbName: PUTF8Char): sqlite3_filename; cdecl;
  sqlite3_db_readonly: function(db: Psqlite3; const zDbName: PUTF8Char): Integer; cdecl;
  sqlite3_txn_state: function(p1: Psqlite3; const zSchema: PUTF8Char): Integer; cdecl;
  sqlite3_next_stmt: function(pDb: Psqlite3; pStmt: Psqlite3_stmt): Psqlite3_stmt; cdecl;
  sqlite3_commit_hook: function(p1: Psqlite3; p2: sqlite3_commit_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_rollback_hook: function(p1: Psqlite3; p2: sqlite3_rollback_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_autovacuum_pages: function(db: Psqlite3; p2: sqlite3_autovacuum_pages_1; p3: Pointer; p4: sqlite3_autovacuum_pages_2): Integer; cdecl;
  sqlite3_update_hook: function(p1: Psqlite3; p2: sqlite3_update_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_enable_shared_cache: function(p1: Integer): Integer; cdecl;
  sqlite3_release_memory: function(p1: Integer): Integer; cdecl;
  sqlite3_db_release_memory: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_soft_heap_limit64: function(N: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_hard_heap_limit64: function(N: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_soft_heap_limit: procedure(N: Integer); cdecl;
  sqlite3_table_column_metadata: function(db: Psqlite3; const zDbName: PUTF8Char; const zTableName: PUTF8Char; const zColumnName: PUTF8Char; pzDataType: PPUTF8Char; pzCollSeq: PPUTF8Char; pNotNull: PInteger; pPrimaryKey: PInteger; pAutoinc: PInteger): Integer; cdecl;
  sqlite3_auto_extension: function(xEntryPoint: sqlite3_auto_extension_xEntryPoint): Integer; cdecl;
  sqlite3_cancel_auto_extension: function(xEntryPoint: sqlite3_cancel_auto_extension_xEntryPoint): Integer; cdecl;
  sqlite3_reset_auto_extension: procedure(); cdecl;
  sqlite3_create_module: function(db: Psqlite3; const zName: PUTF8Char; const p: Psqlite3_module; pClientData: Pointer): Integer; cdecl;
  sqlite3_create_module_v2: function(db: Psqlite3; const zName: PUTF8Char; const p: Psqlite3_module; pClientData: Pointer; xDestroy: sqlite3_create_module_v2_xDestroy): Integer; cdecl;
  sqlite3_drop_modules: function(db: Psqlite3; azKeep: PPUTF8Char): Integer; cdecl;
  sqlite3_declare_vtab: function(p1: Psqlite3; const zSQL: PUTF8Char): Integer; cdecl;
  sqlite3_overload_function: function(p1: Psqlite3; const zFuncName: PUTF8Char; nArg: Integer): Integer; cdecl;
  sqlite3_blob_open: function(p1: Psqlite3; const zDb: PUTF8Char; const zTable: PUTF8Char; const zColumn: PUTF8Char; iRow: sqlite3_int64; flags: Integer; ppBlob: PPsqlite3_blob): Integer; cdecl;
  sqlite3_blob_reopen: function(p1: Psqlite3_blob; p2: sqlite3_int64): Integer; cdecl;
  sqlite3_blob_close: function(p1: Psqlite3_blob): Integer; cdecl;
  sqlite3_blob_bytes: function(p1: Psqlite3_blob): Integer; cdecl;
  sqlite3_blob_read: function(p1: Psqlite3_blob; Z: Pointer; N: Integer; iOffset: Integer): Integer; cdecl;
  sqlite3_blob_write: function(p1: Psqlite3_blob; const z: Pointer; n: Integer; iOffset: Integer): Integer; cdecl;
  sqlite3_vfs_find: function(const zVfsName: PUTF8Char): Psqlite3_vfs; cdecl;
  sqlite3_vfs_register: function(p1: Psqlite3_vfs; makeDflt: Integer): Integer; cdecl;
  sqlite3_vfs_unregister: function(p1: Psqlite3_vfs): Integer; cdecl;
  sqlite3_mutex_alloc: function(p1: Integer): Psqlite3_mutex; cdecl;
  sqlite3_mutex_free: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_mutex_enter: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_mutex_try: function(p1: Psqlite3_mutex): Integer; cdecl;
  sqlite3_mutex_leave: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_db_mutex: function(p1: Psqlite3): Psqlite3_mutex; cdecl;
  sqlite3_file_control: function(p1: Psqlite3; const zDbName: PUTF8Char; op: Integer; p4: Pointer): Integer; cdecl;
  sqlite3_test_control: function(op: Integer): Integer varargs; cdecl;
  sqlite3_keyword_count: function(): Integer; cdecl;
  sqlite3_keyword_name: function(p1: Integer; p2: PPUTF8Char; p3: PInteger): Integer; cdecl;
  sqlite3_keyword_check: function(const p1: PUTF8Char; p2: Integer): Integer; cdecl;
  sqlite3_str_new: function(p1: Psqlite3): Psqlite3_str; cdecl;
  sqlite3_str_finish: function(p1: Psqlite3_str): PUTF8Char; cdecl;
  sqlite3_str_appendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char) varargs; cdecl;
  sqlite3_str_vappendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char; p3: Pointer); cdecl;
  sqlite3_str_append: procedure(p1: Psqlite3_str; const zIn: PUTF8Char; N: Integer); cdecl;
  sqlite3_str_appendall: procedure(p1: Psqlite3_str; const zIn: PUTF8Char); cdecl;
  sqlite3_str_appendchar: procedure(p1: Psqlite3_str; N: Integer; C: UTF8Char); cdecl;
  sqlite3_str_reset: procedure(p1: Psqlite3_str); cdecl;
  sqlite3_str_errcode: function(p1: Psqlite3_str): Integer; cdecl;
  sqlite3_str_length: function(p1: Psqlite3_str): Integer; cdecl;
  sqlite3_str_value: function(p1: Psqlite3_str): PUTF8Char; cdecl;
  sqlite3_status: function(op: Integer; pCurrent: PInteger; pHighwater: PInteger; resetFlag: Integer): Integer; cdecl;
  sqlite3_status64: function(op: Integer; pCurrent: Psqlite3_int64; pHighwater: Psqlite3_int64; resetFlag: Integer): Integer; cdecl;
  sqlite3_db_status: function(p1: Psqlite3; op: Integer; pCur: PInteger; pHiwtr: PInteger; resetFlg: Integer): Integer; cdecl;
  sqlite3_stmt_status: function(p1: Psqlite3_stmt; op: Integer; resetFlg: Integer): Integer; cdecl;
  sqlite3_backup_init: function(pDest: Psqlite3; const zDestName: PUTF8Char; pSource: Psqlite3; const zSourceName: PUTF8Char): Psqlite3_backup; cdecl;
  sqlite3_backup_step: function(p: Psqlite3_backup; nPage: Integer): Integer; cdecl;
  sqlite3_backup_finish: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_backup_remaining: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_backup_pagecount: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_stricmp: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
  sqlite3_strnicmp: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  sqlite3_strglob: function(const zGlob: PUTF8Char; const zStr: PUTF8Char): Integer; cdecl;
  sqlite3_strlike: function(const zGlob: PUTF8Char; const zStr: PUTF8Char; cEsc: Cardinal): Integer; cdecl;
  sqlite3_log: procedure(iErrCode: Integer; const zFormat: PUTF8Char) varargs; cdecl;
  sqlite3_wal_hook: function(p1: Psqlite3; p2: sqlite3_wal_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_wal_autocheckpoint: function(db: Psqlite3; N: Integer): Integer; cdecl;
  sqlite3_wal_checkpoint: function(db: Psqlite3; const zDb: PUTF8Char): Integer; cdecl;
  sqlite3_wal_checkpoint_v2: function(db: Psqlite3; const zDb: PUTF8Char; eMode: Integer; pnLog: PInteger; pnCkpt: PInteger): Integer; cdecl;
  sqlite3_vtab_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
  sqlite3_vtab_on_conflict: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_vtab_nochange: function(p1: Psqlite3_context): Integer; cdecl;
  sqlite3_vtab_collation: function(p1: Psqlite3_index_info; p2: Integer): PUTF8Char; cdecl;
  sqlite3_vtab_distinct: function(p1: Psqlite3_index_info): Integer; cdecl;
  sqlite3_vtab_in: function(p1: Psqlite3_index_info; iCons: Integer; bHandle: Integer): Integer; cdecl;
  sqlite3_vtab_in_first: function(pVal: Psqlite3_value; ppOut: PPsqlite3_value): Integer; cdecl;
  sqlite3_vtab_in_next: function(pVal: Psqlite3_value; ppOut: PPsqlite3_value): Integer; cdecl;
  sqlite3_vtab_rhs_value: function(p1: Psqlite3_index_info; p2: Integer; ppVal: PPsqlite3_value): Integer; cdecl;
  sqlite3_db_cacheflush: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_system_errno: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_serialize: function(db: Psqlite3; const zSchema: PUTF8Char; piSize: Psqlite3_int64; mFlags: Cardinal): PByte; cdecl;
  sqlite3_deserialize: function(db: Psqlite3; const zSchema: PUTF8Char; pData: PByte; szDb: sqlite3_int64; szBuf: sqlite3_int64; mFlags: Cardinal): Integer; cdecl;
  stbi_load_from_memory: function(const buffer: Pstbi_uc; len: Integer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_uc; cdecl;
  stbi_load_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_uc; cdecl;
  stbi_load: function(const filename: PUTF8Char; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_uc; cdecl;
  stbi_load_from_file: function(f: PPointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_uc; cdecl;
  stbi_load_gif_from_memory: function(const buffer: Pstbi_uc; len: Integer; delays: PPInteger; x: PInteger; y: PInteger; z: PInteger; comp: PInteger; req_comp: Integer): Pstbi_uc; cdecl;
  stbi_load_16_from_memory: function(const buffer: Pstbi_uc; len: Integer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_us; cdecl;
  stbi_load_16_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_us; cdecl;
  stbi_load_16: function(const filename: PUTF8Char; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_us; cdecl;
  stbi_load_from_file_16: function(f: PPointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): Pstbi_us; cdecl;
  stbi_loadf_from_memory: function(const buffer: Pstbi_uc; len: Integer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): PSingle; cdecl;
  stbi_loadf_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): PSingle; cdecl;
  stbi_loadf: function(const filename: PUTF8Char; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): PSingle; cdecl;
  stbi_loadf_from_file: function(f: PPointer; x: PInteger; y: PInteger; channels_in_file: PInteger; desired_channels: Integer): PSingle; cdecl;
  stbi_hdr_to_ldr_gamma: procedure(gamma: Single); cdecl;
  stbi_hdr_to_ldr_scale: procedure(scale: Single); cdecl;
  stbi_ldr_to_hdr_gamma: procedure(gamma: Single); cdecl;
  stbi_ldr_to_hdr_scale: procedure(scale: Single); cdecl;
  stbi_is_hdr_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer): Integer; cdecl;
  stbi_is_hdr_from_memory: function(const buffer: Pstbi_uc; len: Integer): Integer; cdecl;
  stbi_is_hdr: function(const filename: PUTF8Char): Integer; cdecl;
  stbi_is_hdr_from_file: function(f: PPointer): Integer; cdecl;
  stbi_failure_reason: function(): PUTF8Char; cdecl;
  stbi_image_free: procedure(retval_from_stbi_load: Pointer); cdecl;
  stbi_info_from_memory: function(const buffer: Pstbi_uc; len: Integer; x: PInteger; y: PInteger; comp: PInteger): Integer; cdecl;
  stbi_info_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer; x: PInteger; y: PInteger; comp: PInteger): Integer; cdecl;
  stbi_is_16_bit_from_memory: function(const buffer: Pstbi_uc; len: Integer): Integer; cdecl;
  stbi_is_16_bit_from_callbacks: function(const clbk: Pstbi_io_callbacks; user: Pointer): Integer; cdecl;
  stbi_info: function(const filename: PUTF8Char; x: PInteger; y: PInteger; comp: PInteger): Integer; cdecl;
  stbi_info_from_file: function(f: PPointer; x: PInteger; y: PInteger; comp: PInteger): Integer; cdecl;
  stbi_is_16_bit: function(const filename: PUTF8Char): Integer; cdecl;
  stbi_is_16_bit_from_file: function(f: PPointer): Integer; cdecl;
  stbi_set_unpremultiply_on_load: procedure(flag_true_if_should_unpremultiply: Integer); cdecl;
  stbi_convert_iphone_png_to_rgb: procedure(flag_true_if_should_convert: Integer); cdecl;
  stbi_set_flip_vertically_on_load: procedure(flag_true_if_should_flip: Integer); cdecl;
  stbi_set_unpremultiply_on_load_thread: procedure(flag_true_if_should_unpremultiply: Integer); cdecl;
  stbi_convert_iphone_png_to_rgb_thread: procedure(flag_true_if_should_convert: Integer); cdecl;
  stbi_set_flip_vertically_on_load_thread: procedure(flag_true_if_should_flip: Integer); cdecl;
  stbi_zlib_decode_malloc_guesssize: function(const buffer: PUTF8Char; len: Integer; initial_size: Integer; outlen: PInteger): PUTF8Char; cdecl;
  stbi_zlib_decode_malloc_guesssize_headerflag: function(const buffer: PUTF8Char; len: Integer; initial_size: Integer; outlen: PInteger; parse_header: Integer): PUTF8Char; cdecl;
  stbi_zlib_decode_malloc: function(const buffer: PUTF8Char; len: Integer; outlen: PInteger): PUTF8Char; cdecl;
  stbi_zlib_decode_buffer: function(obuffer: PUTF8Char; olen: Integer; const ibuffer: PUTF8Char; ilen: Integer): Integer; cdecl;
  stbi_zlib_decode_noheader_malloc: function(const buffer: PUTF8Char; len: Integer; outlen: PInteger): PUTF8Char; cdecl;
  stbi_zlib_decode_noheader_buffer: function(obuffer: PUTF8Char; olen: Integer; const ibuffer: PUTF8Char; ilen: Integer): Integer; cdecl;
  stbi_write_png: function(const filename: PUTF8Char; w: Integer; h: Integer; comp: Integer; const data: Pointer; stride_in_bytes: Integer): Integer; cdecl;
  stbi_write_bmp: function(const filename: PUTF8Char; w: Integer; h: Integer; comp: Integer; const data: Pointer): Integer; cdecl;
  stbi_write_tga: function(const filename: PUTF8Char; w: Integer; h: Integer; comp: Integer; const data: Pointer): Integer; cdecl;
  stbi_write_hdr: function(const filename: PUTF8Char; w: Integer; h: Integer; comp: Integer; const data: PSingle): Integer; cdecl;
  stbi_write_jpg: function(const filename: PUTF8Char; x: Integer; y: Integer; comp: Integer; const data: Pointer; quality: Integer): Integer; cdecl;
  stbi_write_png_to_func: function(func: Pstbi_write_func; context: Pointer; w: Integer; h: Integer; comp: Integer; const data: Pointer; stride_in_bytes: Integer): Integer; cdecl;
  stbi_write_bmp_to_func: function(func: Pstbi_write_func; context: Pointer; w: Integer; h: Integer; comp: Integer; const data: Pointer): Integer; cdecl;
  stbi_write_tga_to_func: function(func: Pstbi_write_func; context: Pointer; w: Integer; h: Integer; comp: Integer; const data: Pointer): Integer; cdecl;
  stbi_write_hdr_to_func: function(func: Pstbi_write_func; context: Pointer; w: Integer; h: Integer; comp: Integer; const data: PSingle): Integer; cdecl;
  stbi_write_jpg_to_func: function(func: Pstbi_write_func; context: Pointer; x: Integer; y: Integer; comp: Integer; const data: Pointer; quality: Integer): Integer; cdecl;
  stbi_flip_vertically_on_write: procedure(flip_boolean: Integer); cdecl;
  stbrp_pack_rects: function(context: Pstbrp_context; rects: Pstbrp_rect; num_rects: Integer): Integer; cdecl;
  stbrp_init_target: procedure(context: Pstbrp_context; width: Integer; height: Integer; nodes: Pstbrp_node; num_nodes: Integer); cdecl;
  stbrp_setup_allow_out_of_mem: procedure(context: Pstbrp_context; allow_out_of_mem: Integer); cdecl;
  stbrp_setup_heuristic: procedure(context: Pstbrp_context; heuristic: Integer); cdecl;
  stbtt_BakeFontBitmap: function(const data: PByte; offset: Integer; pixel_height: Single; pixels: PByte; pw: Integer; ph: Integer; first_char: Integer; num_chars: Integer; chardata: Pstbtt_bakedchar): Integer; cdecl;
  stbtt_GetBakedQuad: procedure(const chardata: Pstbtt_bakedchar; pw: Integer; ph: Integer; char_index: Integer; xpos: PSingle; ypos: PSingle; q: Pstbtt_aligned_quad; opengl_fillrule: Integer); cdecl;
  stbtt_GetScaledFontVMetrics: procedure(const fontdata: PByte; index: Integer; size: Single; ascent: PSingle; descent: PSingle; lineGap: PSingle); cdecl;
  stbtt_PackBegin: function(spc: Pstbtt_pack_context; pixels: PByte; width: Integer; height: Integer; stride_in_bytes: Integer; padding: Integer; alloc_context: Pointer): Integer; cdecl;
  stbtt_PackEnd: procedure(spc: Pstbtt_pack_context); cdecl;
  stbtt_PackFontRange: function(spc: Pstbtt_pack_context; const fontdata: PByte; font_index: Integer; font_size: Single; first_unicode_char_in_range: Integer; num_chars_in_range: Integer; chardata_for_range: Pstbtt_packedchar): Integer; cdecl;
  stbtt_PackFontRanges: function(spc: Pstbtt_pack_context; const fontdata: PByte; font_index: Integer; ranges: Pstbtt_pack_range; num_ranges: Integer): Integer; cdecl;
  stbtt_PackSetOversampling: procedure(spc: Pstbtt_pack_context; h_oversample: Cardinal; v_oversample: Cardinal); cdecl;
  stbtt_PackSetSkipMissingCodepoints: procedure(spc: Pstbtt_pack_context; skip: Integer); cdecl;
  stbtt_GetPackedQuad: procedure(const chardata: Pstbtt_packedchar; pw: Integer; ph: Integer; char_index: Integer; xpos: PSingle; ypos: PSingle; q: Pstbtt_aligned_quad; align_to_integer: Integer); cdecl;
  stbtt_PackFontRangesGatherRects: function(spc: Pstbtt_pack_context; const info: Pstbtt_fontinfo; ranges: Pstbtt_pack_range; num_ranges: Integer; rects: Pstbrp_rect): Integer; cdecl;
  stbtt_PackFontRangesPackRects: procedure(spc: Pstbtt_pack_context; rects: Pstbrp_rect; num_rects: Integer); cdecl;
  stbtt_PackFontRangesRenderIntoRects: function(spc: Pstbtt_pack_context; const info: Pstbtt_fontinfo; ranges: Pstbtt_pack_range; num_ranges: Integer; rects: Pstbrp_rect): Integer; cdecl;
  stbtt_GetNumberOfFonts: function(const data: PByte): Integer; cdecl;
  stbtt_GetFontOffsetForIndex: function(const data: PByte; index: Integer): Integer; cdecl;
  stbtt_InitFont: function(info: Pstbtt_fontinfo; const data: PByte; offset: Integer): Integer; cdecl;
  stbtt_FindGlyphIndex: function(const info: Pstbtt_fontinfo; unicode_codepoint: Integer): Integer; cdecl;
  stbtt_ScaleForPixelHeight: function(const info: Pstbtt_fontinfo; pixels: Single): Single; cdecl;
  stbtt_ScaleForMappingEmToPixels: function(const info: Pstbtt_fontinfo; pixels: Single): Single; cdecl;
  stbtt_GetFontVMetrics: procedure(const info: Pstbtt_fontinfo; ascent: PInteger; descent: PInteger; lineGap: PInteger); cdecl;
  stbtt_GetFontVMetricsOS2: function(const info: Pstbtt_fontinfo; typoAscent: PInteger; typoDescent: PInteger; typoLineGap: PInteger): Integer; cdecl;
  stbtt_GetFontBoundingBox: procedure(const info: Pstbtt_fontinfo; x0: PInteger; y0: PInteger; x1: PInteger; y1: PInteger); cdecl;
  stbtt_GetCodepointHMetrics: procedure(const info: Pstbtt_fontinfo; codepoint: Integer; advanceWidth: PInteger; leftSideBearing: PInteger); cdecl;
  stbtt_GetCodepointKernAdvance: function(const info: Pstbtt_fontinfo; ch1: Integer; ch2: Integer): Integer; cdecl;
  stbtt_GetCodepointBox: function(const info: Pstbtt_fontinfo; codepoint: Integer; x0: PInteger; y0: PInteger; x1: PInteger; y1: PInteger): Integer; cdecl;
  stbtt_GetGlyphHMetrics: procedure(const info: Pstbtt_fontinfo; glyph_index: Integer; advanceWidth: PInteger; leftSideBearing: PInteger); cdecl;
  stbtt_GetGlyphKernAdvance: function(const info: Pstbtt_fontinfo; glyph1: Integer; glyph2: Integer): Integer; cdecl;
  stbtt_GetGlyphBox: function(const info: Pstbtt_fontinfo; glyph_index: Integer; x0: PInteger; y0: PInteger; x1: PInteger; y1: PInteger): Integer; cdecl;
  stbtt_GetKerningTableLength: function(const info: Pstbtt_fontinfo): Integer; cdecl;
  stbtt_GetKerningTable: function(const info: Pstbtt_fontinfo; table: Pstbtt_kerningentry; table_length: Integer): Integer; cdecl;
  stbtt_IsGlyphEmpty: function(const info: Pstbtt_fontinfo; glyph_index: Integer): Integer; cdecl;
  stbtt_GetCodepointShape: function(const info: Pstbtt_fontinfo; unicode_codepoint: Integer; vertices: PPstbtt_vertex): Integer; cdecl;
  stbtt_GetGlyphShape: function(const info: Pstbtt_fontinfo; glyph_index: Integer; vertices: PPstbtt_vertex): Integer; cdecl;
  stbtt_FreeShape: procedure(const info: Pstbtt_fontinfo; vertices: Pstbtt_vertex); cdecl;
  stbtt_FindSVGDoc: function(const info: Pstbtt_fontinfo; gl: Integer): PByte; cdecl;
  stbtt_GetCodepointSVG: function(const info: Pstbtt_fontinfo; unicode_codepoint: Integer; svg: PPUTF8Char): Integer; cdecl;
  stbtt_GetGlyphSVG: function(const info: Pstbtt_fontinfo; gl: Integer; svg: PPUTF8Char): Integer; cdecl;
  stbtt_FreeBitmap: procedure(bitmap: PByte; userdata: Pointer); cdecl;
  stbtt_GetCodepointBitmap: function(const info: Pstbtt_fontinfo; scale_x: Single; scale_y: Single; codepoint: Integer; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_GetCodepointBitmapSubpixel: function(const info: Pstbtt_fontinfo; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; codepoint: Integer; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_MakeCodepointBitmap: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; codepoint: Integer); cdecl;
  stbtt_MakeCodepointBitmapSubpixel: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; codepoint: Integer); cdecl;
  stbtt_MakeCodepointBitmapSubpixelPrefilter: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; oversample_x: Integer; oversample_y: Integer; sub_x: PSingle; sub_y: PSingle; codepoint: Integer); cdecl;
  stbtt_GetCodepointBitmapBox: procedure(const font: Pstbtt_fontinfo; codepoint: Integer; scale_x: Single; scale_y: Single; ix0: PInteger; iy0: PInteger; ix1: PInteger; iy1: PInteger); cdecl;
  stbtt_GetCodepointBitmapBoxSubpixel: procedure(const font: Pstbtt_fontinfo; codepoint: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; ix0: PInteger; iy0: PInteger; ix1: PInteger; iy1: PInteger); cdecl;
  stbtt_GetGlyphBitmap: function(const info: Pstbtt_fontinfo; scale_x: Single; scale_y: Single; glyph: Integer; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_GetGlyphBitmapSubpixel: function(const info: Pstbtt_fontinfo; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; glyph: Integer; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_MakeGlyphBitmap: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; glyph: Integer); cdecl;
  stbtt_MakeGlyphBitmapSubpixel: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; glyph: Integer); cdecl;
  stbtt_MakeGlyphBitmapSubpixelPrefilter: procedure(const info: Pstbtt_fontinfo; output: PByte; out_w: Integer; out_h: Integer; out_stride: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; oversample_x: Integer; oversample_y: Integer; sub_x: PSingle; sub_y: PSingle; glyph: Integer); cdecl;
  stbtt_GetGlyphBitmapBox: procedure(const font: Pstbtt_fontinfo; glyph: Integer; scale_x: Single; scale_y: Single; ix0: PInteger; iy0: PInteger; ix1: PInteger; iy1: PInteger); cdecl;
  stbtt_GetGlyphBitmapBoxSubpixel: procedure(const font: Pstbtt_fontinfo; glyph: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; ix0: PInteger; iy0: PInteger; ix1: PInteger; iy1: PInteger); cdecl;
  stbtt_Rasterize: procedure(result: Pstbtt__bitmap; flatness_in_pixels: Single; vertices: Pstbtt_vertex; num_verts: Integer; scale_x: Single; scale_y: Single; shift_x: Single; shift_y: Single; x_off: Integer; y_off: Integer; invert: Integer; userdata: Pointer); cdecl;
  stbtt_FreeSDF: procedure(bitmap: PByte; userdata: Pointer); cdecl;
  stbtt_GetGlyphSDF: function(const info: Pstbtt_fontinfo; scale: Single; glyph: Integer; padding: Integer; onedge_value: Byte; pixel_dist_scale: Single; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_GetCodepointSDF: function(const info: Pstbtt_fontinfo; scale: Single; codepoint: Integer; padding: Integer; onedge_value: Byte; pixel_dist_scale: Single; width: PInteger; height: PInteger; xoff: PInteger; yoff: PInteger): PByte; cdecl;
  stbtt_FindMatchingFont: function(const fontdata: PByte; const name: PUTF8Char; flags: Integer): Integer; cdecl;
  stbtt_CompareUTF8toUTF16_bigendian: function(const s1: PUTF8Char; len1: Integer; const s2: PUTF8Char; len2: Integer): Integer; cdecl;
  stbtt_GetFontNameString: function(const font: Pstbtt_fontinfo; length: PInteger; platformID: Integer; encodingID: Integer; languageID: Integer; nameID: Integer): PUTF8Char; cdecl;
  ImVec2_ImVec2_Nil: function(): PImVec2; cdecl;
  ImVec2_destroy: procedure(self: PImVec2); cdecl;
  ImVec2_ImVec2_Float: function(_x: Single; _y: Single): PImVec2; cdecl;
  ImVec4_ImVec4_Nil: function(): PImVec4; cdecl;
  ImVec4_destroy: procedure(self: PImVec4); cdecl;
  ImVec4_ImVec4_Float: function(_x: Single; _y: Single; _z: Single; _w: Single): PImVec4; cdecl;
  igCreateContext: function(shared_font_atlas: PImFontAtlas): PImGuiContext; cdecl;
  igDestroyContext: procedure(ctx: PImGuiContext); cdecl;
  igGetCurrentContext: function(): PImGuiContext; cdecl;
  igSetCurrentContext: procedure(ctx: PImGuiContext); cdecl;
  igGetIO_Nil: function(): PImGuiIO; cdecl;
  igGetPlatformIO_Nil: function(): PImGuiPlatformIO; cdecl;
  igGetStyle: function(): PImGuiStyle; cdecl;
  igNewFrame: procedure(); cdecl;
  igEndFrame: procedure(); cdecl;
  igRender: procedure(); cdecl;
  igGetDrawData: function(): PImDrawData; cdecl;
  igShowDemoWindow: procedure(p_open: PBoolean); cdecl;
  igShowMetricsWindow: procedure(p_open: PBoolean); cdecl;
  igShowDebugLogWindow: procedure(p_open: PBoolean); cdecl;
  igShowIDStackToolWindow: procedure(p_open: PBoolean); cdecl;
  igShowAboutWindow: procedure(p_open: PBoolean); cdecl;
  igShowStyleEditor: procedure(ref: PImGuiStyle); cdecl;
  igShowStyleSelector: function(const &label: PUTF8Char): Boolean; cdecl;
  igShowFontSelector: procedure(const &label: PUTF8Char); cdecl;
  igShowUserGuide: procedure(); cdecl;
  igGetVersion: function(): PUTF8Char; cdecl;
  igStyleColorsDark: procedure(dst: PImGuiStyle); cdecl;
  igStyleColorsLight: procedure(dst: PImGuiStyle); cdecl;
  igStyleColorsClassic: procedure(dst: PImGuiStyle); cdecl;
  igBegin: function(const name: PUTF8Char; p_open: PBoolean; flags: ImGuiWindowFlags): Boolean; cdecl;
  igEnd: procedure(); cdecl;
  igBeginChild_Str: function(const str_id: PUTF8Char; size: ImVec2; child_flags: ImGuiChildFlags; window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginChild_ID: function(id: ImGuiID; size: ImVec2; child_flags: ImGuiChildFlags; window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igEndChild: procedure(); cdecl;
  igIsWindowAppearing: function(): Boolean; cdecl;
  igIsWindowCollapsed: function(): Boolean; cdecl;
  igIsWindowFocused: function(flags: ImGuiFocusedFlags): Boolean; cdecl;
  igIsWindowHovered: function(flags: ImGuiHoveredFlags): Boolean; cdecl;
  igGetWindowDrawList: function(): PImDrawList; cdecl;
  igGetWindowDpiScale: function(): Single; cdecl;
  igGetWindowPos: procedure(pOut: PImVec2); cdecl;
  igGetWindowSize: procedure(pOut: PImVec2); cdecl;
  igGetWindowWidth: function(): Single; cdecl;
  igGetWindowHeight: function(): Single; cdecl;
  igGetWindowViewport: function(): PImGuiViewport; cdecl;
  igSetNextWindowPos: procedure(pos: ImVec2; cond: ImGuiCond; pivot: ImVec2); cdecl;
  igSetNextWindowSize: procedure(size: ImVec2; cond: ImGuiCond); cdecl;
  igSetNextWindowSizeConstraints: procedure(size_min: ImVec2; size_max: ImVec2; custom_callback: ImGuiSizeCallback; custom_callback_data: Pointer); cdecl;
  igSetNextWindowContentSize: procedure(size: ImVec2); cdecl;
  igSetNextWindowCollapsed: procedure(collapsed: Boolean; cond: ImGuiCond); cdecl;
  igSetNextWindowFocus: procedure(); cdecl;
  igSetNextWindowScroll: procedure(scroll: ImVec2); cdecl;
  igSetNextWindowBgAlpha: procedure(alpha: Single); cdecl;
  igSetNextWindowViewport: procedure(viewport_id: ImGuiID); cdecl;
  igSetWindowPos_Vec2: procedure(pos: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowSize_Vec2: procedure(size: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowCollapsed_Bool: procedure(collapsed: Boolean; cond: ImGuiCond); cdecl;
  igSetWindowFocus_Nil: procedure(); cdecl;
  igSetWindowFontScale: procedure(scale: Single); cdecl;
  igSetWindowPos_Str: procedure(const name: PUTF8Char; pos: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowSize_Str: procedure(const name: PUTF8Char; size: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowCollapsed_Str: procedure(const name: PUTF8Char; collapsed: Boolean; cond: ImGuiCond); cdecl;
  igSetWindowFocus_Str: procedure(const name: PUTF8Char); cdecl;
  igGetScrollX: function(): Single; cdecl;
  igGetScrollY: function(): Single; cdecl;
  igSetScrollX_Float: procedure(scroll_x: Single); cdecl;
  igSetScrollY_Float: procedure(scroll_y: Single); cdecl;
  igGetScrollMaxX: function(): Single; cdecl;
  igGetScrollMaxY: function(): Single; cdecl;
  igSetScrollHereX: procedure(center_x_ratio: Single); cdecl;
  igSetScrollHereY: procedure(center_y_ratio: Single); cdecl;
  igSetScrollFromPosX_Float: procedure(local_x: Single; center_x_ratio: Single); cdecl;
  igSetScrollFromPosY_Float: procedure(local_y: Single; center_y_ratio: Single); cdecl;
  igPushFont: procedure(font: PImFont); cdecl;
  igPopFont: procedure(); cdecl;
  igPushStyleColor_U32: procedure(idx: ImGuiCol; col: ImU32); cdecl;
  igPushStyleColor_Vec4: procedure(idx: ImGuiCol; col: ImVec4); cdecl;
  igPopStyleColor: procedure(count: Integer); cdecl;
  igPushStyleVar_Float: procedure(idx: ImGuiStyleVar; val: Single); cdecl;
  igPushStyleVar_Vec2: procedure(idx: ImGuiStyleVar; val: ImVec2); cdecl;
  igPushStyleVarX: procedure(idx: ImGuiStyleVar; val_x: Single); cdecl;
  igPushStyleVarY: procedure(idx: ImGuiStyleVar; val_y: Single); cdecl;
  igPopStyleVar: procedure(count: Integer); cdecl;
  igPushItemFlag: procedure(option: ImGuiItemFlags; enabled: Boolean); cdecl;
  igPopItemFlag: procedure(); cdecl;
  igPushItemWidth: procedure(item_width: Single); cdecl;
  igPopItemWidth: procedure(); cdecl;
  igSetNextItemWidth: procedure(item_width: Single); cdecl;
  igCalcItemWidth: function(): Single; cdecl;
  igPushTextWrapPos: procedure(wrap_local_pos_x: Single); cdecl;
  igPopTextWrapPos: procedure(); cdecl;
  igGetFont: function(): PImFont; cdecl;
  igGetFontSize: function(): Single; cdecl;
  igGetFontTexUvWhitePixel: procedure(pOut: PImVec2); cdecl;
  igGetColorU32_Col: function(idx: ImGuiCol; alpha_mul: Single): ImU32; cdecl;
  igGetColorU32_Vec4: function(col: ImVec4): ImU32; cdecl;
  igGetColorU32_U32: function(col: ImU32; alpha_mul: Single): ImU32; cdecl;
  igGetStyleColorVec4: function(idx: ImGuiCol): PImVec4; cdecl;
  igGetCursorScreenPos: procedure(pOut: PImVec2); cdecl;
  igSetCursorScreenPos: procedure(pos: ImVec2); cdecl;
  igGetContentRegionAvail: procedure(pOut: PImVec2); cdecl;
  igGetCursorPos: procedure(pOut: PImVec2); cdecl;
  igGetCursorPosX: function(): Single; cdecl;
  igGetCursorPosY: function(): Single; cdecl;
  igSetCursorPos: procedure(local_pos: ImVec2); cdecl;
  igSetCursorPosX: procedure(local_x: Single); cdecl;
  igSetCursorPosY: procedure(local_y: Single); cdecl;
  igGetCursorStartPos: procedure(pOut: PImVec2); cdecl;
  igSeparator: procedure(); cdecl;
  igSameLine: procedure(offset_from_start_x: Single; spacing: Single); cdecl;
  igNewLine: procedure(); cdecl;
  igSpacing: procedure(); cdecl;
  igDummy: procedure(size: ImVec2); cdecl;
  igIndent: procedure(indent_w: Single); cdecl;
  igUnindent: procedure(indent_w: Single); cdecl;
  igBeginGroup: procedure(); cdecl;
  igEndGroup: procedure(); cdecl;
  igAlignTextToFramePadding: procedure(); cdecl;
  igGetTextLineHeight: function(): Single; cdecl;
  igGetTextLineHeightWithSpacing: function(): Single; cdecl;
  igGetFrameHeight: function(): Single; cdecl;
  igGetFrameHeightWithSpacing: function(): Single; cdecl;
  igPushID_Str: procedure(const str_id: PUTF8Char); cdecl;
  igPushID_StrStr: procedure(const str_id_begin: PUTF8Char; const str_id_end: PUTF8Char); cdecl;
  igPushID_Ptr: procedure(const ptr_id: Pointer); cdecl;
  igPushID_Int: procedure(int_id: Integer); cdecl;
  igPopID: procedure(); cdecl;
  igGetID_Str: function(const str_id: PUTF8Char): ImGuiID; cdecl;
  igGetID_StrStr: function(const str_id_begin: PUTF8Char; const str_id_end: PUTF8Char): ImGuiID; cdecl;
  igGetID_Ptr: function(const ptr_id: Pointer): ImGuiID; cdecl;
  igGetID_Int: function(int_id: Integer): ImGuiID; cdecl;
  igTextUnformatted: procedure(const text: PUTF8Char; const text_end: PUTF8Char); cdecl;
  igText: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igTextV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igTextColored: procedure(col: ImVec4; const fmt: PUTF8Char) varargs; cdecl;
  igTextColoredV: procedure(col: ImVec4; const fmt: PUTF8Char; args: Pointer); cdecl;
  igTextDisabled: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igTextDisabledV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igTextWrapped: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igTextWrappedV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igLabelText: procedure(const &label: PUTF8Char; const fmt: PUTF8Char) varargs; cdecl;
  igLabelTextV: procedure(const &label: PUTF8Char; const fmt: PUTF8Char; args: Pointer); cdecl;
  igBulletText: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igBulletTextV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igSeparatorText: procedure(const &label: PUTF8Char); cdecl;
  igButton: function(const &label: PUTF8Char; size: ImVec2): Boolean; cdecl;
  igSmallButton: function(const &label: PUTF8Char): Boolean; cdecl;
  igInvisibleButton: function(const str_id: PUTF8Char; size: ImVec2; flags: ImGuiButtonFlags): Boolean; cdecl;
  igArrowButton: function(const str_id: PUTF8Char; dir: ImGuiDir): Boolean; cdecl;
  igCheckbox: function(const &label: PUTF8Char; v: PBoolean): Boolean; cdecl;
  igCheckboxFlags_IntPtr: function(const &label: PUTF8Char; flags: PInteger; flags_value: Integer): Boolean; cdecl;
  igCheckboxFlags_UintPtr: function(const &label: PUTF8Char; flags: PCardinal; flags_value: Cardinal): Boolean; cdecl;
  igRadioButton_Bool: function(const &label: PUTF8Char; active: Boolean): Boolean; cdecl;
  igRadioButton_IntPtr: function(const &label: PUTF8Char; v: PInteger; v_button: Integer): Boolean; cdecl;
  igProgressBar: procedure(fraction: Single; size_arg: ImVec2; const overlay: PUTF8Char); cdecl;
  igBullet: procedure(); cdecl;
  igTextLink: function(const &label: PUTF8Char): Boolean; cdecl;
  igTextLinkOpenURL: procedure(const &label: PUTF8Char; const url: PUTF8Char); cdecl;
  igImage: procedure(user_texture_id: ImTextureID; image_size: ImVec2; uv0: ImVec2; uv1: ImVec2); cdecl;
  igImageWithBg: procedure(user_texture_id: ImTextureID; image_size: ImVec2; uv0: ImVec2; uv1: ImVec2; bg_col: ImVec4; tint_col: ImVec4); cdecl;
  igImageButton: function(const str_id: PUTF8Char; user_texture_id: ImTextureID; image_size: ImVec2; uv0: ImVec2; uv1: ImVec2; bg_col: ImVec4; tint_col: ImVec4): Boolean; cdecl;
  igBeginCombo: function(const &label: PUTF8Char; const preview_value: PUTF8Char; flags: ImGuiComboFlags): Boolean; cdecl;
  igEndCombo: procedure(); cdecl;
  igCombo_Str_arr: function(const &label: PUTF8Char; current_item: PInteger; items: PPUTF8Char; items_count: Integer; popup_max_height_in_items: Integer): Boolean; cdecl;
  igCombo_Str: function(const &label: PUTF8Char; current_item: PInteger; const items_separated_by_zeros: PUTF8Char; popup_max_height_in_items: Integer): Boolean; cdecl;
  igCombo_FnStrPtr: function(const &label: PUTF8Char; current_item: PInteger; getter: igCombo_FnStrPtr_getter; user_data: Pointer; items_count: Integer; popup_max_height_in_items: Integer): Boolean; cdecl;
  igDragFloat: function(const &label: PUTF8Char; v: PSingle; v_speed: Single; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragFloat2: function(const &label: PUTF8Char; v: PSingle; v_speed: Single; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragFloat3: function(const &label: PUTF8Char; v: PSingle; v_speed: Single; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragFloat4: function(const &label: PUTF8Char; v: PSingle; v_speed: Single; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragFloatRange2: function(const &label: PUTF8Char; v_current_min: PSingle; v_current_max: PSingle; v_speed: Single; v_min: Single; v_max: Single; const format: PUTF8Char; const format_max: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragInt: function(const &label: PUTF8Char; v: PInteger; v_speed: Single; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragInt2: function(const &label: PUTF8Char; v: PInteger; v_speed: Single; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragInt3: function(const &label: PUTF8Char; v: PInteger; v_speed: Single; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragInt4: function(const &label: PUTF8Char; v: PInteger; v_speed: Single; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragIntRange2: function(const &label: PUTF8Char; v_current_min: PInteger; v_current_max: PInteger; v_speed: Single; v_min: Integer; v_max: Integer; const format: PUTF8Char; const format_max: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragScalar: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; v_speed: Single; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igDragScalarN: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; components: Integer; v_speed: Single; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderFloat: function(const &label: PUTF8Char; v: PSingle; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderFloat2: function(const &label: PUTF8Char; v: PSingle; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderFloat3: function(const &label: PUTF8Char; v: PSingle; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderFloat4: function(const &label: PUTF8Char; v: PSingle; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderAngle: function(const &label: PUTF8Char; v_rad: PSingle; v_degrees_min: Single; v_degrees_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderInt: function(const &label: PUTF8Char; v: PInteger; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderInt2: function(const &label: PUTF8Char; v: PInteger; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderInt3: function(const &label: PUTF8Char; v: PInteger; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderInt4: function(const &label: PUTF8Char; v: PInteger; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderScalar: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderScalarN: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; components: Integer; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igVSliderFloat: function(const &label: PUTF8Char; size: ImVec2; v: PSingle; v_min: Single; v_max: Single; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igVSliderInt: function(const &label: PUTF8Char; size: ImVec2; v: PInteger; v_min: Integer; v_max: Integer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igVSliderScalar: function(const &label: PUTF8Char; size: ImVec2; data_type: ImGuiDataType; p_data: Pointer; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igInputText: function(const &label: PUTF8Char; buf: PUTF8Char; buf_size: NativeUInt; flags: ImGuiInputTextFlags; callback: ImGuiInputTextCallback; user_data: Pointer): Boolean; cdecl;
  igInputTextMultiline: function(const &label: PUTF8Char; buf: PUTF8Char; buf_size: NativeUInt; size: ImVec2; flags: ImGuiInputTextFlags; callback: ImGuiInputTextCallback; user_data: Pointer): Boolean; cdecl;
  igInputTextWithHint: function(const &label: PUTF8Char; const hint: PUTF8Char; buf: PUTF8Char; buf_size: NativeUInt; flags: ImGuiInputTextFlags; callback: ImGuiInputTextCallback; user_data: Pointer): Boolean; cdecl;
  igInputFloat: function(const &label: PUTF8Char; v: PSingle; step: Single; step_fast: Single; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputFloat2: function(const &label: PUTF8Char; v: PSingle; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputFloat3: function(const &label: PUTF8Char; v: PSingle; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputFloat4: function(const &label: PUTF8Char; v: PSingle; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputInt: function(const &label: PUTF8Char; v: PInteger; step: Integer; step_fast: Integer; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputInt2: function(const &label: PUTF8Char; v: PInteger; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputInt3: function(const &label: PUTF8Char; v: PInteger; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputInt4: function(const &label: PUTF8Char; v: PInteger; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputDouble: function(const &label: PUTF8Char; v: PDouble; step: Double; step_fast: Double; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputScalar: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; const p_step: Pointer; const p_step_fast: Pointer; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igInputScalarN: function(const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; components: Integer; const p_step: Pointer; const p_step_fast: Pointer; const format: PUTF8Char; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igColorEdit3: function(const &label: PUTF8Char; col: PSingle; flags: ImGuiColorEditFlags): Boolean; cdecl;
  igColorEdit4: function(const &label: PUTF8Char; col: PSingle; flags: ImGuiColorEditFlags): Boolean; cdecl;
  igColorPicker3: function(const &label: PUTF8Char; col: PSingle; flags: ImGuiColorEditFlags): Boolean; cdecl;
  igColorPicker4: function(const &label: PUTF8Char; col: PSingle; flags: ImGuiColorEditFlags; const ref_col: PSingle): Boolean; cdecl;
  igColorButton: function(const desc_id: PUTF8Char; col: ImVec4; flags: ImGuiColorEditFlags; size: ImVec2): Boolean; cdecl;
  igSetColorEditOptions: procedure(flags: ImGuiColorEditFlags); cdecl;
  igTreeNode_Str: function(const &label: PUTF8Char): Boolean; cdecl;
  igTreeNode_StrStr: function(const str_id: PUTF8Char; const fmt: PUTF8Char): Boolean varargs; cdecl;
  igTreeNode_Ptr: function(const ptr_id: Pointer; const fmt: PUTF8Char): Boolean varargs; cdecl;
  igTreeNodeV_Str: function(const str_id: PUTF8Char; const fmt: PUTF8Char; args: Pointer): Boolean; cdecl;
  igTreeNodeV_Ptr: function(const ptr_id: Pointer; const fmt: PUTF8Char; args: Pointer): Boolean; cdecl;
  igTreeNodeEx_Str: function(const &label: PUTF8Char; flags: ImGuiTreeNodeFlags): Boolean; cdecl;
  igTreeNodeEx_StrStr: function(const str_id: PUTF8Char; flags: ImGuiTreeNodeFlags; const fmt: PUTF8Char): Boolean varargs; cdecl;
  igTreeNodeEx_Ptr: function(const ptr_id: Pointer; flags: ImGuiTreeNodeFlags; const fmt: PUTF8Char): Boolean varargs; cdecl;
  igTreeNodeExV_Str: function(const str_id: PUTF8Char; flags: ImGuiTreeNodeFlags; const fmt: PUTF8Char; args: Pointer): Boolean; cdecl;
  igTreeNodeExV_Ptr: function(const ptr_id: Pointer; flags: ImGuiTreeNodeFlags; const fmt: PUTF8Char; args: Pointer): Boolean; cdecl;
  igTreePush_Str: procedure(const str_id: PUTF8Char); cdecl;
  igTreePush_Ptr: procedure(const ptr_id: Pointer); cdecl;
  igTreePop: procedure(); cdecl;
  igGetTreeNodeToLabelSpacing: function(): Single; cdecl;
  igCollapsingHeader_TreeNodeFlags: function(const &label: PUTF8Char; flags: ImGuiTreeNodeFlags): Boolean; cdecl;
  igCollapsingHeader_BoolPtr: function(const &label: PUTF8Char; p_visible: PBoolean; flags: ImGuiTreeNodeFlags): Boolean; cdecl;
  igSetNextItemOpen: procedure(is_open: Boolean; cond: ImGuiCond); cdecl;
  igSetNextItemStorageID: procedure(storage_id: ImGuiID); cdecl;
  igSelectable_Bool: function(const &label: PUTF8Char; selected: Boolean; flags: ImGuiSelectableFlags; size: ImVec2): Boolean; cdecl;
  igSelectable_BoolPtr: function(const &label: PUTF8Char; p_selected: PBoolean; flags: ImGuiSelectableFlags; size: ImVec2): Boolean; cdecl;
  igBeginMultiSelect: function(flags: ImGuiMultiSelectFlags; selection_size: Integer; items_count: Integer): PImGuiMultiSelectIO; cdecl;
  igEndMultiSelect: function(): PImGuiMultiSelectIO; cdecl;
  igSetNextItemSelectionUserData: procedure(selection_user_data: ImGuiSelectionUserData); cdecl;
  igIsItemToggledSelection: function(): Boolean; cdecl;
  igBeginListBox: function(const &label: PUTF8Char; size: ImVec2): Boolean; cdecl;
  igEndListBox: procedure(); cdecl;
  igListBox_Str_arr: function(const &label: PUTF8Char; current_item: PInteger; items: PPUTF8Char; items_count: Integer; height_in_items: Integer): Boolean; cdecl;
  igListBox_FnStrPtr: function(const &label: PUTF8Char; current_item: PInteger; getter: igListBox_FnStrPtr_getter; user_data: Pointer; items_count: Integer; height_in_items: Integer): Boolean; cdecl;
  igPlotLines_FloatPtr: procedure(const &label: PUTF8Char; const values: PSingle; values_count: Integer; values_offset: Integer; const overlay_text: PUTF8Char; scale_min: Single; scale_max: Single; graph_size: ImVec2; stride: Integer); cdecl;
  igPlotLines_FnFloatPtr: procedure(const &label: PUTF8Char; values_getter: igPlotLines_FnFloatPtr_values_getter; data: Pointer; values_count: Integer; values_offset: Integer; const overlay_text: PUTF8Char; scale_min: Single; scale_max: Single; graph_size: ImVec2); cdecl;
  igPlotHistogram_FloatPtr: procedure(const &label: PUTF8Char; const values: PSingle; values_count: Integer; values_offset: Integer; const overlay_text: PUTF8Char; scale_min: Single; scale_max: Single; graph_size: ImVec2; stride: Integer); cdecl;
  igPlotHistogram_FnFloatPtr: procedure(const &label: PUTF8Char; values_getter: igPlotHistogram_FnFloatPtr_values_getter; data: Pointer; values_count: Integer; values_offset: Integer; const overlay_text: PUTF8Char; scale_min: Single; scale_max: Single; graph_size: ImVec2); cdecl;
  igValue_Bool: procedure(const prefix: PUTF8Char; b: Boolean); cdecl;
  igValue_Int: procedure(const prefix: PUTF8Char; v: Integer); cdecl;
  igValue_Uint: procedure(const prefix: PUTF8Char; v: Cardinal); cdecl;
  igValue_Float: procedure(const prefix: PUTF8Char; v: Single; const float_format: PUTF8Char); cdecl;
  igBeginMenuBar: function(): Boolean; cdecl;
  igEndMenuBar: procedure(); cdecl;
  igBeginMainMenuBar: function(): Boolean; cdecl;
  igEndMainMenuBar: procedure(); cdecl;
  igBeginMenu: function(const &label: PUTF8Char; enabled: Boolean): Boolean; cdecl;
  igEndMenu: procedure(); cdecl;
  igMenuItem_Bool: function(const &label: PUTF8Char; const shortcut: PUTF8Char; selected: Boolean; enabled: Boolean): Boolean; cdecl;
  igMenuItem_BoolPtr: function(const &label: PUTF8Char; const shortcut: PUTF8Char; p_selected: PBoolean; enabled: Boolean): Boolean; cdecl;
  igBeginTooltip: function(): Boolean; cdecl;
  igEndTooltip: procedure(); cdecl;
  igSetTooltip: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igSetTooltipV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igBeginItemTooltip: function(): Boolean; cdecl;
  igSetItemTooltip: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igSetItemTooltipV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igBeginPopup: function(const str_id: PUTF8Char; flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginPopupModal: function(const name: PUTF8Char; p_open: PBoolean; flags: ImGuiWindowFlags): Boolean; cdecl;
  igEndPopup: procedure(); cdecl;
  igOpenPopup_Str: procedure(const str_id: PUTF8Char; popup_flags: ImGuiPopupFlags); cdecl;
  igOpenPopup_ID: procedure(id: ImGuiID; popup_flags: ImGuiPopupFlags); cdecl;
  igOpenPopupOnItemClick: procedure(const str_id: PUTF8Char; popup_flags: ImGuiPopupFlags); cdecl;
  igCloseCurrentPopup: procedure(); cdecl;
  igBeginPopupContextItem: function(const str_id: PUTF8Char; popup_flags: ImGuiPopupFlags): Boolean; cdecl;
  igBeginPopupContextWindow: function(const str_id: PUTF8Char; popup_flags: ImGuiPopupFlags): Boolean; cdecl;
  igBeginPopupContextVoid: function(const str_id: PUTF8Char; popup_flags: ImGuiPopupFlags): Boolean; cdecl;
  igIsPopupOpen_Str: function(const str_id: PUTF8Char; flags: ImGuiPopupFlags): Boolean; cdecl;
  igBeginTable: function(const str_id: PUTF8Char; columns: Integer; flags: ImGuiTableFlags; outer_size: ImVec2; inner_width: Single): Boolean; cdecl;
  igEndTable: procedure(); cdecl;
  igTableNextRow: procedure(row_flags: ImGuiTableRowFlags; min_row_height: Single); cdecl;
  igTableNextColumn: function(): Boolean; cdecl;
  igTableSetColumnIndex: function(column_n: Integer): Boolean; cdecl;
  igTableSetupColumn: procedure(const &label: PUTF8Char; flags: ImGuiTableColumnFlags; init_width_or_weight: Single; user_id: ImGuiID); cdecl;
  igTableSetupScrollFreeze: procedure(cols: Integer; rows: Integer); cdecl;
  igTableHeader: procedure(const &label: PUTF8Char); cdecl;
  igTableHeadersRow: procedure(); cdecl;
  igTableAngledHeadersRow: procedure(); cdecl;
  igTableGetSortSpecs: function(): PImGuiTableSortSpecs; cdecl;
  igTableGetColumnCount: function(): Integer; cdecl;
  igTableGetColumnIndex: function(): Integer; cdecl;
  igTableGetRowIndex: function(): Integer; cdecl;
  igTableGetColumnName_Int: function(column_n: Integer): PUTF8Char; cdecl;
  igTableGetColumnFlags: function(column_n: Integer): ImGuiTableColumnFlags; cdecl;
  igTableSetColumnEnabled: procedure(column_n: Integer; v: Boolean); cdecl;
  igTableGetHoveredColumn: function(): Integer; cdecl;
  igTableSetBgColor: procedure(target: ImGuiTableBgTarget; color: ImU32; column_n: Integer); cdecl;
  igColumns: procedure(count: Integer; const id: PUTF8Char; borders: Boolean); cdecl;
  igNextColumn: procedure(); cdecl;
  igGetColumnIndex: function(): Integer; cdecl;
  igGetColumnWidth: function(column_index: Integer): Single; cdecl;
  igSetColumnWidth: procedure(column_index: Integer; width: Single); cdecl;
  igGetColumnOffset: function(column_index: Integer): Single; cdecl;
  igSetColumnOffset: procedure(column_index: Integer; offset_x: Single); cdecl;
  igGetColumnsCount: function(): Integer; cdecl;
  igBeginTabBar: function(const str_id: PUTF8Char; flags: ImGuiTabBarFlags): Boolean; cdecl;
  igEndTabBar: procedure(); cdecl;
  igBeginTabItem: function(const &label: PUTF8Char; p_open: PBoolean; flags: ImGuiTabItemFlags): Boolean; cdecl;
  igEndTabItem: procedure(); cdecl;
  igTabItemButton: function(const &label: PUTF8Char; flags: ImGuiTabItemFlags): Boolean; cdecl;
  igSetTabItemClosed: procedure(const tab_or_docked_window_label: PUTF8Char); cdecl;
  igDockSpace: function(dockspace_id: ImGuiID; size: ImVec2; flags: ImGuiDockNodeFlags; const window_class: PImGuiWindowClass): ImGuiID; cdecl;
  igDockSpaceOverViewport: function(dockspace_id: ImGuiID; const viewport: PImGuiViewport; flags: ImGuiDockNodeFlags; const window_class: PImGuiWindowClass): ImGuiID; cdecl;
  igSetNextWindowDockID: procedure(dock_id: ImGuiID; cond: ImGuiCond); cdecl;
  igSetNextWindowClass: procedure(const window_class: PImGuiWindowClass); cdecl;
  igGetWindowDockID: function(): ImGuiID; cdecl;
  igIsWindowDocked: function(): Boolean; cdecl;
  igLogToTTY: procedure(auto_open_depth: Integer); cdecl;
  igLogToFile: procedure(auto_open_depth: Integer; const filename: PUTF8Char); cdecl;
  igLogToClipboard: procedure(auto_open_depth: Integer); cdecl;
  igLogFinish: procedure(); cdecl;
  igLogButtons: procedure(); cdecl;
  igLogText: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igLogTextV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igBeginDragDropSource: function(flags: ImGuiDragDropFlags): Boolean; cdecl;
  igSetDragDropPayload: function(const &type: PUTF8Char; const data: Pointer; sz: NativeUInt; cond: ImGuiCond): Boolean; cdecl;
  igEndDragDropSource: procedure(); cdecl;
  igBeginDragDropTarget: function(): Boolean; cdecl;
  igAcceptDragDropPayload: function(const &type: PUTF8Char; flags: ImGuiDragDropFlags): PImGuiPayload; cdecl;
  igEndDragDropTarget: procedure(); cdecl;
  igGetDragDropPayload: function(): PImGuiPayload; cdecl;
  igBeginDisabled: procedure(disabled: Boolean); cdecl;
  igEndDisabled: procedure(); cdecl;
  igPushClipRect: procedure(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: Boolean); cdecl;
  igPopClipRect: procedure(); cdecl;
  igSetItemDefaultFocus: procedure(); cdecl;
  igSetKeyboardFocusHere: procedure(offset: Integer); cdecl;
  igSetNavCursorVisible: procedure(visible: Boolean); cdecl;
  igSetNextItemAllowOverlap: procedure(); cdecl;
  igIsItemHovered: function(flags: ImGuiHoveredFlags): Boolean; cdecl;
  igIsItemActive: function(): Boolean; cdecl;
  igIsItemFocused: function(): Boolean; cdecl;
  igIsItemClicked: function(mouse_button: ImGuiMouseButton): Boolean; cdecl;
  igIsItemVisible: function(): Boolean; cdecl;
  igIsItemEdited: function(): Boolean; cdecl;
  igIsItemActivated: function(): Boolean; cdecl;
  igIsItemDeactivated: function(): Boolean; cdecl;
  igIsItemDeactivatedAfterEdit: function(): Boolean; cdecl;
  igIsItemToggledOpen: function(): Boolean; cdecl;
  igIsAnyItemHovered: function(): Boolean; cdecl;
  igIsAnyItemActive: function(): Boolean; cdecl;
  igIsAnyItemFocused: function(): Boolean; cdecl;
  igGetItemID: function(): ImGuiID; cdecl;
  igGetItemRectMin: procedure(pOut: PImVec2); cdecl;
  igGetItemRectMax: procedure(pOut: PImVec2); cdecl;
  igGetItemRectSize: procedure(pOut: PImVec2); cdecl;
  igGetMainViewport: function(): PImGuiViewport; cdecl;
  igGetBackgroundDrawList: function(viewport: PImGuiViewport): PImDrawList; cdecl;
  igGetForegroundDrawList_ViewportPtr: function(viewport: PImGuiViewport): PImDrawList; cdecl;
  igIsRectVisible_Nil: function(size: ImVec2): Boolean; cdecl;
  igIsRectVisible_Vec2: function(rect_min: ImVec2; rect_max: ImVec2): Boolean; cdecl;
  igGetTime: function(): Double; cdecl;
  igGetFrameCount: function(): Integer; cdecl;
  igGetDrawListSharedData: function(): PImDrawListSharedData; cdecl;
  igGetStyleColorName: function(idx: ImGuiCol): PUTF8Char; cdecl;
  igSetStateStorage: procedure(storage: PImGuiStorage); cdecl;
  igGetStateStorage: function(): PImGuiStorage; cdecl;
  igCalcTextSize: procedure(pOut: PImVec2; const text: PUTF8Char; const text_end: PUTF8Char; hide_text_after_double_hash: Boolean; wrap_width: Single); cdecl;
  igColorConvertU32ToFloat4: procedure(pOut: PImVec4; &in: ImU32); cdecl;
  igColorConvertFloat4ToU32: function(&in: ImVec4): ImU32; cdecl;
  igColorConvertRGBtoHSV: procedure(r: Single; g: Single; b: Single; out_h: PSingle; out_s: PSingle; out_v: PSingle); cdecl;
  igColorConvertHSVtoRGB: procedure(h: Single; s: Single; v: Single; out_r: PSingle; out_g: PSingle; out_b: PSingle); cdecl;
  igIsKeyDown_Nil: function(key: ImGuiKey): Boolean; cdecl;
  igIsKeyPressed_Bool: function(key: ImGuiKey; &repeat: Boolean): Boolean; cdecl;
  igIsKeyReleased_Nil: function(key: ImGuiKey): Boolean; cdecl;
  igIsKeyChordPressed_Nil: function(key_chord: ImGuiKeyChord): Boolean; cdecl;
  igGetKeyPressedAmount: function(key: ImGuiKey; repeat_delay: Single; rate: Single): Integer; cdecl;
  igGetKeyName: function(key: ImGuiKey): PUTF8Char; cdecl;
  igSetNextFrameWantCaptureKeyboard: procedure(want_capture_keyboard: Boolean); cdecl;
  igShortcut_Nil: function(key_chord: ImGuiKeyChord; flags: ImGuiInputFlags): Boolean; cdecl;
  igSetNextItemShortcut: procedure(key_chord: ImGuiKeyChord; flags: ImGuiInputFlags); cdecl;
  igSetItemKeyOwner_Nil: procedure(key: ImGuiKey); cdecl;
  igIsMouseDown_Nil: function(button: ImGuiMouseButton): Boolean; cdecl;
  igIsMouseClicked_Bool: function(button: ImGuiMouseButton; &repeat: Boolean): Boolean; cdecl;
  igIsMouseReleased_Nil: function(button: ImGuiMouseButton): Boolean; cdecl;
  igIsMouseDoubleClicked_Nil: function(button: ImGuiMouseButton): Boolean; cdecl;
  igIsMouseReleasedWithDelay: function(button: ImGuiMouseButton; delay: Single): Boolean; cdecl;
  igGetMouseClickedCount: function(button: ImGuiMouseButton): Integer; cdecl;
  igIsMouseHoveringRect: function(r_min: ImVec2; r_max: ImVec2; clip: Boolean): Boolean; cdecl;
  igIsMousePosValid: function(const mouse_pos: PImVec2): Boolean; cdecl;
  igIsAnyMouseDown: function(): Boolean; cdecl;
  igGetMousePos: procedure(pOut: PImVec2); cdecl;
  igGetMousePosOnOpeningCurrentPopup: procedure(pOut: PImVec2); cdecl;
  igIsMouseDragging: function(button: ImGuiMouseButton; lock_threshold: Single): Boolean; cdecl;
  igGetMouseDragDelta: procedure(pOut: PImVec2; button: ImGuiMouseButton; lock_threshold: Single); cdecl;
  igResetMouseDragDelta: procedure(button: ImGuiMouseButton); cdecl;
  igGetMouseCursor: function(): ImGuiMouseCursor; cdecl;
  igSetMouseCursor: procedure(cursor_type: ImGuiMouseCursor); cdecl;
  igSetNextFrameWantCaptureMouse: procedure(want_capture_mouse: Boolean); cdecl;
  igGetClipboardText: function(): PUTF8Char; cdecl;
  igSetClipboardText: procedure(const text: PUTF8Char); cdecl;
  igLoadIniSettingsFromDisk: procedure(const ini_filename: PUTF8Char); cdecl;
  igLoadIniSettingsFromMemory: procedure(const ini_data: PUTF8Char; ini_size: NativeUInt); cdecl;
  igSaveIniSettingsToDisk: procedure(const ini_filename: PUTF8Char); cdecl;
  igSaveIniSettingsToMemory: function(out_ini_size: PNativeUInt): PUTF8Char; cdecl;
  igDebugTextEncoding: procedure(const text: PUTF8Char); cdecl;
  igDebugFlashStyleColor: procedure(idx: ImGuiCol); cdecl;
  igDebugStartItemPicker: procedure(); cdecl;
  igDebugCheckVersionAndDataLayout: function(const version_str: PUTF8Char; sz_io: NativeUInt; sz_style: NativeUInt; sz_vec2: NativeUInt; sz_vec4: NativeUInt; sz_drawvert: NativeUInt; sz_drawidx: NativeUInt): Boolean; cdecl;
  igDebugLog: procedure(const fmt: PUTF8Char) varargs; cdecl;
  igDebugLogV: procedure(const fmt: PUTF8Char; args: Pointer); cdecl;
  igSetAllocatorFunctions: procedure(alloc_func: ImGuiMemAllocFunc; free_func: ImGuiMemFreeFunc; user_data: Pointer); cdecl;
  igGetAllocatorFunctions: procedure(p_alloc_func: PImGuiMemAllocFunc; p_free_func: PImGuiMemFreeFunc; p_user_data: PPointer); cdecl;
  igMemAlloc: function(size: NativeUInt): Pointer; cdecl;
  igMemFree: procedure(ptr: Pointer); cdecl;
  igUpdatePlatformWindows: procedure(); cdecl;
  igRenderPlatformWindowsDefault: procedure(platform_render_arg: Pointer; renderer_render_arg: Pointer); cdecl;
  igDestroyPlatformWindows: procedure(); cdecl;
  igFindViewportByID: function(id: ImGuiID): PImGuiViewport; cdecl;
  igFindViewportByPlatformHandle: function(platform_handle: Pointer): PImGuiViewport; cdecl;
  ImGuiTableSortSpecs_ImGuiTableSortSpecs: function(): PImGuiTableSortSpecs; cdecl;
  ImGuiTableSortSpecs_destroy: procedure(self: PImGuiTableSortSpecs); cdecl;
  ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs: function(): PImGuiTableColumnSortSpecs; cdecl;
  ImGuiTableColumnSortSpecs_destroy: procedure(self: PImGuiTableColumnSortSpecs); cdecl;
  ImGuiStyle_ImGuiStyle: function(): PImGuiStyle; cdecl;
  ImGuiStyle_destroy: procedure(self: PImGuiStyle); cdecl;
  ImGuiStyle_ScaleAllSizes: procedure(self: PImGuiStyle; scale_factor: Single); cdecl;
  ImGuiIO_AddKeyEvent: procedure(self: PImGuiIO; key: ImGuiKey; down: Boolean); cdecl;
  ImGuiIO_AddKeyAnalogEvent: procedure(self: PImGuiIO; key: ImGuiKey; down: Boolean; v: Single); cdecl;
  ImGuiIO_AddMousePosEvent: procedure(self: PImGuiIO; x: Single; y: Single); cdecl;
  ImGuiIO_AddMouseButtonEvent: procedure(self: PImGuiIO; button: Integer; down: Boolean); cdecl;
  ImGuiIO_AddMouseWheelEvent: procedure(self: PImGuiIO; wheel_x: Single; wheel_y: Single); cdecl;
  ImGuiIO_AddMouseSourceEvent: procedure(self: PImGuiIO; source: ImGuiMouseSource); cdecl;
  ImGuiIO_AddMouseViewportEvent: procedure(self: PImGuiIO; id: ImGuiID); cdecl;
  ImGuiIO_AddFocusEvent: procedure(self: PImGuiIO; focused: Boolean); cdecl;
  ImGuiIO_AddInputCharacter: procedure(self: PImGuiIO; c: Cardinal); cdecl;
  ImGuiIO_AddInputCharacterUTF16: procedure(self: PImGuiIO; c: ImWchar16); cdecl;
  ImGuiIO_AddInputCharactersUTF8: procedure(self: PImGuiIO; const str: PUTF8Char); cdecl;
  ImGuiIO_SetKeyEventNativeData: procedure(self: PImGuiIO; key: ImGuiKey; native_keycode: Integer; native_scancode: Integer; native_legacy_index: Integer); cdecl;
  ImGuiIO_SetAppAcceptingEvents: procedure(self: PImGuiIO; accepting_events: Boolean); cdecl;
  ImGuiIO_ClearEventsQueue: procedure(self: PImGuiIO); cdecl;
  ImGuiIO_ClearInputKeys: procedure(self: PImGuiIO); cdecl;
  ImGuiIO_ClearInputMouse: procedure(self: PImGuiIO); cdecl;
  ImGuiIO_ImGuiIO: function(): PImGuiIO; cdecl;
  ImGuiIO_destroy: procedure(self: PImGuiIO); cdecl;
  ImGuiInputTextCallbackData_ImGuiInputTextCallbackData: function(): PImGuiInputTextCallbackData; cdecl;
  ImGuiInputTextCallbackData_destroy: procedure(self: PImGuiInputTextCallbackData); cdecl;
  ImGuiInputTextCallbackData_DeleteChars: procedure(self: PImGuiInputTextCallbackData; pos: Integer; bytes_count: Integer); cdecl;
  ImGuiInputTextCallbackData_InsertChars: procedure(self: PImGuiInputTextCallbackData; pos: Integer; const text: PUTF8Char; const text_end: PUTF8Char); cdecl;
  ImGuiInputTextCallbackData_SelectAll: procedure(self: PImGuiInputTextCallbackData); cdecl;
  ImGuiInputTextCallbackData_ClearSelection: procedure(self: PImGuiInputTextCallbackData); cdecl;
  ImGuiInputTextCallbackData_HasSelection: function(self: PImGuiInputTextCallbackData): Boolean; cdecl;
  ImGuiWindowClass_ImGuiWindowClass: function(): PImGuiWindowClass; cdecl;
  ImGuiWindowClass_destroy: procedure(self: PImGuiWindowClass); cdecl;
  ImGuiPayload_ImGuiPayload: function(): PImGuiPayload; cdecl;
  ImGuiPayload_destroy: procedure(self: PImGuiPayload); cdecl;
  ImGuiPayload_Clear: procedure(self: PImGuiPayload); cdecl;
  ImGuiPayload_IsDataType: function(self: PImGuiPayload; const &type: PUTF8Char): Boolean; cdecl;
  ImGuiPayload_IsPreview: function(self: PImGuiPayload): Boolean; cdecl;
  ImGuiPayload_IsDelivery: function(self: PImGuiPayload): Boolean; cdecl;
  ImGuiOnceUponAFrame_ImGuiOnceUponAFrame: function(): PImGuiOnceUponAFrame; cdecl;
  ImGuiOnceUponAFrame_destroy: procedure(self: PImGuiOnceUponAFrame); cdecl;
  ImGuiTextFilter_ImGuiTextFilter: function(const default_filter: PUTF8Char): PImGuiTextFilter; cdecl;
  ImGuiTextFilter_destroy: procedure(self: PImGuiTextFilter); cdecl;
  ImGuiTextFilter_Draw: function(self: PImGuiTextFilter; const &label: PUTF8Char; width: Single): Boolean; cdecl;
  ImGuiTextFilter_PassFilter: function(self: PImGuiTextFilter; const text: PUTF8Char; const text_end: PUTF8Char): Boolean; cdecl;
  ImGuiTextFilter_Build: procedure(self: PImGuiTextFilter); cdecl;
  ImGuiTextFilter_Clear: procedure(self: PImGuiTextFilter); cdecl;
  ImGuiTextFilter_IsActive: function(self: PImGuiTextFilter): Boolean; cdecl;
  ImGuiTextRange_ImGuiTextRange_Nil: function(): PImGuiTextRange; cdecl;
  ImGuiTextRange_destroy: procedure(self: PImGuiTextRange); cdecl;
  ImGuiTextRange_ImGuiTextRange_Str: function(const _b: PUTF8Char; const _e: PUTF8Char): PImGuiTextRange; cdecl;
  ImGuiTextRange_empty: function(self: PImGuiTextRange): Boolean; cdecl;
  ImGuiTextRange_split: procedure(self: PImGuiTextRange; separator: UTF8Char; &out: PImVector_ImGuiTextRange); cdecl;
  ImGuiTextBuffer_ImGuiTextBuffer: function(): PImGuiTextBuffer; cdecl;
  ImGuiTextBuffer_destroy: procedure(self: PImGuiTextBuffer); cdecl;
  ImGuiTextBuffer_begin: function(self: PImGuiTextBuffer): PUTF8Char; cdecl;
  ImGuiTextBuffer_end: function(self: PImGuiTextBuffer): PUTF8Char; cdecl;
  ImGuiTextBuffer_size: function(self: PImGuiTextBuffer): Integer; cdecl;
  ImGuiTextBuffer_empty: function(self: PImGuiTextBuffer): Boolean; cdecl;
  ImGuiTextBuffer_clear: procedure(self: PImGuiTextBuffer); cdecl;
  ImGuiTextBuffer_resize: procedure(self: PImGuiTextBuffer; size: Integer); cdecl;
  ImGuiTextBuffer_reserve: procedure(self: PImGuiTextBuffer; capacity: Integer); cdecl;
  ImGuiTextBuffer_c_str: function(self: PImGuiTextBuffer): PUTF8Char; cdecl;
  ImGuiTextBuffer_append: procedure(self: PImGuiTextBuffer; const str: PUTF8Char; const str_end: PUTF8Char); cdecl;
  ImGuiTextBuffer_appendfv: procedure(self: PImGuiTextBuffer; const fmt: PUTF8Char; args: Pointer); cdecl;
  ImGuiStoragePair_ImGuiStoragePair_Int: function(_key: ImGuiID; _val: Integer): PImGuiStoragePair; cdecl;
  ImGuiStoragePair_destroy: procedure(self: PImGuiStoragePair); cdecl;
  ImGuiStoragePair_ImGuiStoragePair_Float: function(_key: ImGuiID; _val: Single): PImGuiStoragePair; cdecl;
  ImGuiStoragePair_ImGuiStoragePair_Ptr: function(_key: ImGuiID; _val: Pointer): PImGuiStoragePair; cdecl;
  ImGuiStorage_Clear: procedure(self: PImGuiStorage); cdecl;
  ImGuiStorage_GetInt: function(self: PImGuiStorage; key: ImGuiID; default_val: Integer): Integer; cdecl;
  ImGuiStorage_SetInt: procedure(self: PImGuiStorage; key: ImGuiID; val: Integer); cdecl;
  ImGuiStorage_GetBool: function(self: PImGuiStorage; key: ImGuiID; default_val: Boolean): Boolean; cdecl;
  ImGuiStorage_SetBool: procedure(self: PImGuiStorage; key: ImGuiID; val: Boolean); cdecl;
  ImGuiStorage_GetFloat: function(self: PImGuiStorage; key: ImGuiID; default_val: Single): Single; cdecl;
  ImGuiStorage_SetFloat: procedure(self: PImGuiStorage; key: ImGuiID; val: Single); cdecl;
  ImGuiStorage_GetVoidPtr: function(self: PImGuiStorage; key: ImGuiID): Pointer; cdecl;
  ImGuiStorage_SetVoidPtr: procedure(self: PImGuiStorage; key: ImGuiID; val: Pointer); cdecl;
  ImGuiStorage_GetIntRef: function(self: PImGuiStorage; key: ImGuiID; default_val: Integer): PInteger; cdecl;
  ImGuiStorage_GetBoolRef: function(self: PImGuiStorage; key: ImGuiID; default_val: Boolean): PBoolean; cdecl;
  ImGuiStorage_GetFloatRef: function(self: PImGuiStorage; key: ImGuiID; default_val: Single): PSingle; cdecl;
  ImGuiStorage_GetVoidPtrRef: function(self: PImGuiStorage; key: ImGuiID; default_val: Pointer): PPointer; cdecl;
  ImGuiStorage_BuildSortByKey: procedure(self: PImGuiStorage); cdecl;
  ImGuiStorage_SetAllInt: procedure(self: PImGuiStorage; val: Integer); cdecl;
  ImGuiListClipper_ImGuiListClipper: function(): PImGuiListClipper; cdecl;
  ImGuiListClipper_destroy: procedure(self: PImGuiListClipper); cdecl;
  ImGuiListClipper_Begin: procedure(self: PImGuiListClipper; items_count: Integer; items_height: Single); cdecl;
  ImGuiListClipper_End: procedure(self: PImGuiListClipper); cdecl;
  ImGuiListClipper_Step: function(self: PImGuiListClipper): Boolean; cdecl;
  ImGuiListClipper_IncludeItemByIndex: procedure(self: PImGuiListClipper; item_index: Integer); cdecl;
  ImGuiListClipper_IncludeItemsByIndex: procedure(self: PImGuiListClipper; item_begin: Integer; item_end: Integer); cdecl;
  ImGuiListClipper_SeekCursorForItem: procedure(self: PImGuiListClipper; item_index: Integer); cdecl;
  ImColor_ImColor_Nil: function(): PImColor; cdecl;
  ImColor_destroy: procedure(self: PImColor); cdecl;
  ImColor_ImColor_Float: function(r: Single; g: Single; b: Single; a: Single): PImColor; cdecl;
  ImColor_ImColor_Vec4: function(col: ImVec4): PImColor; cdecl;
  ImColor_ImColor_Int: function(r: Integer; g: Integer; b: Integer; a: Integer): PImColor; cdecl;
  ImColor_ImColor_U32: function(rgba: ImU32): PImColor; cdecl;
  ImColor_SetHSV: procedure(self: PImColor; h: Single; s: Single; v: Single; a: Single); cdecl;
  ImColor_HSV: procedure(pOut: PImColor; h: Single; s: Single; v: Single; a: Single); cdecl;
  ImGuiSelectionBasicStorage_ImGuiSelectionBasicStorage: function(): PImGuiSelectionBasicStorage; cdecl;
  ImGuiSelectionBasicStorage_destroy: procedure(self: PImGuiSelectionBasicStorage); cdecl;
  ImGuiSelectionBasicStorage_ApplyRequests: procedure(self: PImGuiSelectionBasicStorage; ms_io: PImGuiMultiSelectIO); cdecl;
  ImGuiSelectionBasicStorage_Contains: function(self: PImGuiSelectionBasicStorage; id: ImGuiID): Boolean; cdecl;
  ImGuiSelectionBasicStorage_Clear: procedure(self: PImGuiSelectionBasicStorage); cdecl;
  ImGuiSelectionBasicStorage_Swap: procedure(self: PImGuiSelectionBasicStorage; r: PImGuiSelectionBasicStorage); cdecl;
  ImGuiSelectionBasicStorage_SetItemSelected: procedure(self: PImGuiSelectionBasicStorage; id: ImGuiID; selected: Boolean); cdecl;
  ImGuiSelectionBasicStorage_GetNextSelectedItem: function(self: PImGuiSelectionBasicStorage; opaque_it: PPointer; out_id: PImGuiID): Boolean; cdecl;
  ImGuiSelectionBasicStorage_GetStorageIdFromIndex: function(self: PImGuiSelectionBasicStorage; idx: Integer): ImGuiID; cdecl;
  ImGuiSelectionExternalStorage_ImGuiSelectionExternalStorage: function(): PImGuiSelectionExternalStorage; cdecl;
  ImGuiSelectionExternalStorage_destroy: procedure(self: PImGuiSelectionExternalStorage); cdecl;
  ImGuiSelectionExternalStorage_ApplyRequests: procedure(self: PImGuiSelectionExternalStorage; ms_io: PImGuiMultiSelectIO); cdecl;
  ImDrawCmd_ImDrawCmd: function(): PImDrawCmd; cdecl;
  ImDrawCmd_destroy: procedure(self: PImDrawCmd); cdecl;
  ImDrawCmd_GetTexID: function(self: PImDrawCmd): ImTextureID; cdecl;
  ImDrawListSplitter_ImDrawListSplitter: function(): PImDrawListSplitter; cdecl;
  ImDrawListSplitter_destroy: procedure(self: PImDrawListSplitter); cdecl;
  ImDrawListSplitter_Clear: procedure(self: PImDrawListSplitter); cdecl;
  ImDrawListSplitter_ClearFreeMemory: procedure(self: PImDrawListSplitter); cdecl;
  ImDrawListSplitter_Split: procedure(self: PImDrawListSplitter; draw_list: PImDrawList; count: Integer); cdecl;
  ImDrawListSplitter_Merge: procedure(self: PImDrawListSplitter; draw_list: PImDrawList); cdecl;
  ImDrawListSplitter_SetCurrentChannel: procedure(self: PImDrawListSplitter; draw_list: PImDrawList; channel_idx: Integer); cdecl;
  ImDrawList_ImDrawList: function(shared_data: PImDrawListSharedData): PImDrawList; cdecl;
  ImDrawList_destroy: procedure(self: PImDrawList); cdecl;
  ImDrawList_PushClipRect: procedure(self: PImDrawList; clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: Boolean); cdecl;
  ImDrawList_PushClipRectFullScreen: procedure(self: PImDrawList); cdecl;
  ImDrawList_PopClipRect: procedure(self: PImDrawList); cdecl;
  ImDrawList_PushTextureID: procedure(self: PImDrawList; texture_id: ImTextureID); cdecl;
  ImDrawList_PopTextureID: procedure(self: PImDrawList); cdecl;
  ImDrawList_GetClipRectMin: procedure(pOut: PImVec2; self: PImDrawList); cdecl;
  ImDrawList_GetClipRectMax: procedure(pOut: PImVec2; self: PImDrawList); cdecl;
  ImDrawList_AddLine: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; col: ImU32; thickness: Single); cdecl;
  ImDrawList_AddRect: procedure(self: PImDrawList; p_min: ImVec2; p_max: ImVec2; col: ImU32; rounding: Single; flags: ImDrawFlags; thickness: Single); cdecl;
  ImDrawList_AddRectFilled: procedure(self: PImDrawList; p_min: ImVec2; p_max: ImVec2; col: ImU32; rounding: Single; flags: ImDrawFlags); cdecl;
  ImDrawList_AddRectFilledMultiColor: procedure(self: PImDrawList; p_min: ImVec2; p_max: ImVec2; col_upr_left: ImU32; col_upr_right: ImU32; col_bot_right: ImU32; col_bot_left: ImU32); cdecl;
  ImDrawList_AddQuad: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; col: ImU32; thickness: Single); cdecl;
  ImDrawList_AddQuadFilled: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; col: ImU32); cdecl;
  ImDrawList_AddTriangle: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; col: ImU32; thickness: Single); cdecl;
  ImDrawList_AddTriangleFilled: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; col: ImU32); cdecl;
  ImDrawList_AddCircle: procedure(self: PImDrawList; center: ImVec2; radius: Single; col: ImU32; num_segments: Integer; thickness: Single); cdecl;
  ImDrawList_AddCircleFilled: procedure(self: PImDrawList; center: ImVec2; radius: Single; col: ImU32; num_segments: Integer); cdecl;
  ImDrawList_AddNgon: procedure(self: PImDrawList; center: ImVec2; radius: Single; col: ImU32; num_segments: Integer; thickness: Single); cdecl;
  ImDrawList_AddNgonFilled: procedure(self: PImDrawList; center: ImVec2; radius: Single; col: ImU32; num_segments: Integer); cdecl;
  ImDrawList_AddEllipse: procedure(self: PImDrawList; center: ImVec2; radius: ImVec2; col: ImU32; rot: Single; num_segments: Integer; thickness: Single); cdecl;
  ImDrawList_AddEllipseFilled: procedure(self: PImDrawList; center: ImVec2; radius: ImVec2; col: ImU32; rot: Single; num_segments: Integer); cdecl;
  ImDrawList_AddText_Vec2: procedure(self: PImDrawList; pos: ImVec2; col: ImU32; const text_begin: PUTF8Char; const text_end: PUTF8Char); cdecl;
  ImDrawList_AddText_FontPtr: procedure(self: PImDrawList; font: PImFont; font_size: Single; pos: ImVec2; col: ImU32; const text_begin: PUTF8Char; const text_end: PUTF8Char; wrap_width: Single; const cpu_fine_clip_rect: PImVec4); cdecl;
  ImDrawList_AddBezierCubic: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; col: ImU32; thickness: Single; num_segments: Integer); cdecl;
  ImDrawList_AddBezierQuadratic: procedure(self: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; col: ImU32; thickness: Single; num_segments: Integer); cdecl;
  ImDrawList_AddPolyline: procedure(self: PImDrawList; const points: PImVec2; num_points: Integer; col: ImU32; flags: ImDrawFlags; thickness: Single); cdecl;
  ImDrawList_AddConvexPolyFilled: procedure(self: PImDrawList; const points: PImVec2; num_points: Integer; col: ImU32); cdecl;
  ImDrawList_AddConcavePolyFilled: procedure(self: PImDrawList; const points: PImVec2; num_points: Integer; col: ImU32); cdecl;
  ImDrawList_AddImage: procedure(self: PImDrawList; user_texture_id: ImTextureID; p_min: ImVec2; p_max: ImVec2; uv_min: ImVec2; uv_max: ImVec2; col: ImU32); cdecl;
  ImDrawList_AddImageQuad: procedure(self: PImDrawList; user_texture_id: ImTextureID; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; uv1: ImVec2; uv2: ImVec2; uv3: ImVec2; uv4: ImVec2; col: ImU32); cdecl;
  ImDrawList_AddImageRounded: procedure(self: PImDrawList; user_texture_id: ImTextureID; p_min: ImVec2; p_max: ImVec2; uv_min: ImVec2; uv_max: ImVec2; col: ImU32; rounding: Single; flags: ImDrawFlags); cdecl;
  ImDrawList_PathClear: procedure(self: PImDrawList); cdecl;
  ImDrawList_PathLineTo: procedure(self: PImDrawList; pos: ImVec2); cdecl;
  ImDrawList_PathLineToMergeDuplicate: procedure(self: PImDrawList; pos: ImVec2); cdecl;
  ImDrawList_PathFillConvex: procedure(self: PImDrawList; col: ImU32); cdecl;
  ImDrawList_PathFillConcave: procedure(self: PImDrawList; col: ImU32); cdecl;
  ImDrawList_PathStroke: procedure(self: PImDrawList; col: ImU32; flags: ImDrawFlags; thickness: Single); cdecl;
  ImDrawList_PathArcTo: procedure(self: PImDrawList; center: ImVec2; radius: Single; a_min: Single; a_max: Single; num_segments: Integer); cdecl;
  ImDrawList_PathArcToFast: procedure(self: PImDrawList; center: ImVec2; radius: Single; a_min_of_12: Integer; a_max_of_12: Integer); cdecl;
  ImDrawList_PathEllipticalArcTo: procedure(self: PImDrawList; center: ImVec2; radius: ImVec2; rot: Single; a_min: Single; a_max: Single; num_segments: Integer); cdecl;
  ImDrawList_PathBezierCubicCurveTo: procedure(self: PImDrawList; p2: ImVec2; p3: ImVec2; p4: ImVec2; num_segments: Integer); cdecl;
  ImDrawList_PathBezierQuadraticCurveTo: procedure(self: PImDrawList; p2: ImVec2; p3: ImVec2; num_segments: Integer); cdecl;
  ImDrawList_PathRect: procedure(self: PImDrawList; rect_min: ImVec2; rect_max: ImVec2; rounding: Single; flags: ImDrawFlags); cdecl;
  ImDrawList_AddCallback: procedure(self: PImDrawList; callback: ImDrawCallback; userdata: Pointer; userdata_size: NativeUInt); cdecl;
  ImDrawList_AddDrawCmd: procedure(self: PImDrawList); cdecl;
  ImDrawList_CloneOutput: function(self: PImDrawList): PImDrawList; cdecl;
  ImDrawList_ChannelsSplit: procedure(self: PImDrawList; count: Integer); cdecl;
  ImDrawList_ChannelsMerge: procedure(self: PImDrawList); cdecl;
  ImDrawList_ChannelsSetCurrent: procedure(self: PImDrawList; n: Integer); cdecl;
  ImDrawList_PrimReserve: procedure(self: PImDrawList; idx_count: Integer; vtx_count: Integer); cdecl;
  ImDrawList_PrimUnreserve: procedure(self: PImDrawList; idx_count: Integer; vtx_count: Integer); cdecl;
  ImDrawList_PrimRect: procedure(self: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32); cdecl;
  ImDrawList_PrimRectUV: procedure(self: PImDrawList; a: ImVec2; b: ImVec2; uv_a: ImVec2; uv_b: ImVec2; col: ImU32); cdecl;
  ImDrawList_PrimQuadUV: procedure(self: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; uv_a: ImVec2; uv_b: ImVec2; uv_c: ImVec2; uv_d: ImVec2; col: ImU32); cdecl;
  ImDrawList_PrimWriteVtx: procedure(self: PImDrawList; pos: ImVec2; uv: ImVec2; col: ImU32); cdecl;
  ImDrawList_PrimWriteIdx: procedure(self: PImDrawList; idx: ImDrawIdx); cdecl;
  ImDrawList_PrimVtx: procedure(self: PImDrawList; pos: ImVec2; uv: ImVec2; col: ImU32); cdecl;
  ImDrawList__ResetForNewFrame: procedure(self: PImDrawList); cdecl;
  ImDrawList__ClearFreeMemory: procedure(self: PImDrawList); cdecl;
  ImDrawList__PopUnusedDrawCmd: procedure(self: PImDrawList); cdecl;
  ImDrawList__TryMergeDrawCmds: procedure(self: PImDrawList); cdecl;
  ImDrawList__OnChangedClipRect: procedure(self: PImDrawList); cdecl;
  ImDrawList__OnChangedTextureID: procedure(self: PImDrawList); cdecl;
  ImDrawList__OnChangedVtxOffset: procedure(self: PImDrawList); cdecl;
  ImDrawList__SetTextureID: procedure(self: PImDrawList; texture_id: ImTextureID); cdecl;
  ImDrawList__CalcCircleAutoSegmentCount: function(self: PImDrawList; radius: Single): Integer; cdecl;
  ImDrawList__PathArcToFastEx: procedure(self: PImDrawList; center: ImVec2; radius: Single; a_min_sample: Integer; a_max_sample: Integer; a_step: Integer); cdecl;
  ImDrawList__PathArcToN: procedure(self: PImDrawList; center: ImVec2; radius: Single; a_min: Single; a_max: Single; num_segments: Integer); cdecl;
  ImDrawData_ImDrawData: function(): PImDrawData; cdecl;
  ImDrawData_destroy: procedure(self: PImDrawData); cdecl;
  ImDrawData_Clear: procedure(self: PImDrawData); cdecl;
  ImDrawData_AddDrawList: procedure(self: PImDrawData; draw_list: PImDrawList); cdecl;
  ImDrawData_DeIndexAllBuffers: procedure(self: PImDrawData); cdecl;
  ImDrawData_ScaleClipRects: procedure(self: PImDrawData; fb_scale: ImVec2); cdecl;
  ImFontConfig_ImFontConfig: function(): PImFontConfig; cdecl;
  ImFontConfig_destroy: procedure(self: PImFontConfig); cdecl;
  ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder: function(): PImFontGlyphRangesBuilder; cdecl;
  ImFontGlyphRangesBuilder_destroy: procedure(self: PImFontGlyphRangesBuilder); cdecl;
  ImFontGlyphRangesBuilder_Clear: procedure(self: PImFontGlyphRangesBuilder); cdecl;
  ImFontGlyphRangesBuilder_GetBit: function(self: PImFontGlyphRangesBuilder; n: NativeUInt): Boolean; cdecl;
  ImFontGlyphRangesBuilder_SetBit: procedure(self: PImFontGlyphRangesBuilder; n: NativeUInt); cdecl;
  ImFontGlyphRangesBuilder_AddChar: procedure(self: PImFontGlyphRangesBuilder; c: ImWchar); cdecl;
  ImFontGlyphRangesBuilder_AddText: procedure(self: PImFontGlyphRangesBuilder; const text: PUTF8Char; const text_end: PUTF8Char); cdecl;
  ImFontGlyphRangesBuilder_AddRanges: procedure(self: PImFontGlyphRangesBuilder; const ranges: PImWchar); cdecl;
  ImFontGlyphRangesBuilder_BuildRanges: procedure(self: PImFontGlyphRangesBuilder; out_ranges: PImVector_ImWchar); cdecl;
  ImFontAtlasCustomRect_ImFontAtlasCustomRect: function(): PImFontAtlasCustomRect; cdecl;
  ImFontAtlasCustomRect_destroy: procedure(self: PImFontAtlasCustomRect); cdecl;
  ImFontAtlasCustomRect_IsPacked: function(self: PImFontAtlasCustomRect): Boolean; cdecl;
  ImFontAtlas_ImFontAtlas: function(): PImFontAtlas; cdecl;
  ImFontAtlas_destroy: procedure(self: PImFontAtlas); cdecl;
  ImFontAtlas_AddFont: function(self: PImFontAtlas; const font_cfg: PImFontConfig): PImFont; cdecl;
  ImFontAtlas_AddFontDefault: function(self: PImFontAtlas; const font_cfg: PImFontConfig): PImFont; cdecl;
  ImFontAtlas_AddFontFromFileTTF: function(self: PImFontAtlas; const filename: PUTF8Char; size_pixels: Single; const font_cfg: PImFontConfig; const glyph_ranges: PImWchar): PImFont; cdecl;
  ImFontAtlas_AddFontFromMemoryTTF: function(self: PImFontAtlas; font_data: Pointer; font_data_size: Integer; size_pixels: Single; const font_cfg: PImFontConfig; const glyph_ranges: PImWchar): PImFont; cdecl;
  ImFontAtlas_AddFontFromMemoryCompressedTTF: function(self: PImFontAtlas; const compressed_font_data: Pointer; compressed_font_data_size: Integer; size_pixels: Single; const font_cfg: PImFontConfig; const glyph_ranges: PImWchar): PImFont; cdecl;
  ImFontAtlas_AddFontFromMemoryCompressedBase85TTF: function(self: PImFontAtlas; const compressed_font_data_base85: PUTF8Char; size_pixels: Single; const font_cfg: PImFontConfig; const glyph_ranges: PImWchar): PImFont; cdecl;
  ImFontAtlas_ClearInputData: procedure(self: PImFontAtlas); cdecl;
  ImFontAtlas_ClearFonts: procedure(self: PImFontAtlas); cdecl;
  ImFontAtlas_ClearTexData: procedure(self: PImFontAtlas); cdecl;
  ImFontAtlas_Clear: procedure(self: PImFontAtlas); cdecl;
  ImFontAtlas_Build: function(self: PImFontAtlas): Boolean; cdecl;
  ImFontAtlas_GetTexDataAsAlpha8: procedure(self: PImFontAtlas; out_pixels: PPByte; out_width: PInteger; out_height: PInteger; out_bytes_per_pixel: PInteger); cdecl;
  ImFontAtlas_GetTexDataAsRGBA32: procedure(self: PImFontAtlas; out_pixels: PPByte; out_width: PInteger; out_height: PInteger; out_bytes_per_pixel: PInteger); cdecl;
  ImFontAtlas_IsBuilt: function(self: PImFontAtlas): Boolean; cdecl;
  ImFontAtlas_SetTexID: procedure(self: PImFontAtlas; id: ImTextureID); cdecl;
  ImFontAtlas_GetGlyphRangesDefault: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesGreek: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesKorean: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesJapanese: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesChineseFull: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesCyrillic: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesThai: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_GetGlyphRangesVietnamese: function(self: PImFontAtlas): PImWchar; cdecl;
  ImFontAtlas_AddCustomRectRegular: function(self: PImFontAtlas; width: Integer; height: Integer): Integer; cdecl;
  ImFontAtlas_AddCustomRectFontGlyph: function(self: PImFontAtlas; font: PImFont; id: ImWchar; width: Integer; height: Integer; advance_x: Single; offset: ImVec2): Integer; cdecl;
  ImFontAtlas_GetCustomRectByIndex: function(self: PImFontAtlas; index: Integer): PImFontAtlasCustomRect; cdecl;
  ImFontAtlas_CalcCustomRectUV: procedure(self: PImFontAtlas; const rect: PImFontAtlasCustomRect; out_uv_min: PImVec2; out_uv_max: PImVec2); cdecl;
  ImFont_ImFont: function(): PImFont; cdecl;
  ImFont_destroy: procedure(self: PImFont); cdecl;
  ImFont_FindGlyph: function(self: PImFont; c: ImWchar): PImFontGlyph; cdecl;
  ImFont_FindGlyphNoFallback: function(self: PImFont; c: ImWchar): PImFontGlyph; cdecl;
  ImFont_GetCharAdvance: function(self: PImFont; c: ImWchar): Single; cdecl;
  ImFont_IsLoaded: function(self: PImFont): Boolean; cdecl;
  ImFont_GetDebugName: function(self: PImFont): PUTF8Char; cdecl;
  ImFont_CalcTextSizeA: procedure(pOut: PImVec2; self: PImFont; size: Single; max_width: Single; wrap_width: Single; const text_begin: PUTF8Char; const text_end: PUTF8Char; remaining: PPUTF8Char); cdecl;
  ImFont_CalcWordWrapPositionA: function(self: PImFont; scale: Single; const text: PUTF8Char; const text_end: PUTF8Char; wrap_width: Single): PUTF8Char; cdecl;
  ImFont_RenderChar: procedure(self: PImFont; draw_list: PImDrawList; size: Single; pos: ImVec2; col: ImU32; c: ImWchar); cdecl;
  ImFont_RenderText: procedure(self: PImFont; draw_list: PImDrawList; size: Single; pos: ImVec2; col: ImU32; clip_rect: ImVec4; const text_begin: PUTF8Char; const text_end: PUTF8Char; wrap_width: Single; cpu_fine_clip: Boolean); cdecl;
  ImFont_BuildLookupTable: procedure(self: PImFont); cdecl;
  ImFont_ClearOutputData: procedure(self: PImFont); cdecl;
  ImFont_GrowIndex: procedure(self: PImFont; new_size: Integer); cdecl;
  ImFont_AddGlyph: procedure(self: PImFont; const src_cfg: PImFontConfig; c: ImWchar; x0: Single; y0: Single; x1: Single; y1: Single; u0: Single; v0: Single; u1: Single; v1: Single; advance_x: Single); cdecl;
  ImFont_AddRemapChar: procedure(self: PImFont; dst: ImWchar; src: ImWchar; overwrite_dst: Boolean); cdecl;
  ImFont_IsGlyphRangeUnused: function(self: PImFont; c_begin: Cardinal; c_last: Cardinal): Boolean; cdecl;
  ImGuiViewport_ImGuiViewport: function(): PImGuiViewport; cdecl;
  ImGuiViewport_destroy: procedure(self: PImGuiViewport); cdecl;
  ImGuiViewport_GetCenter: procedure(pOut: PImVec2; self: PImGuiViewport); cdecl;
  ImGuiViewport_GetWorkCenter: procedure(pOut: PImVec2; self: PImGuiViewport); cdecl;
  ImGuiPlatformIO_ImGuiPlatformIO: function(): PImGuiPlatformIO; cdecl;
  ImGuiPlatformIO_destroy: procedure(self: PImGuiPlatformIO); cdecl;
  ImGuiPlatformMonitor_ImGuiPlatformMonitor: function(): PImGuiPlatformMonitor; cdecl;
  ImGuiPlatformMonitor_destroy: procedure(self: PImGuiPlatformMonitor); cdecl;
  ImGuiPlatformImeData_ImGuiPlatformImeData: function(): PImGuiPlatformImeData; cdecl;
  ImGuiPlatformImeData_destroy: procedure(self: PImGuiPlatformImeData); cdecl;
  igImHashData: function(const data: Pointer; data_size: NativeUInt; seed: ImGuiID): ImGuiID; cdecl;
  igImHashStr: function(const data: PUTF8Char; data_size: NativeUInt; seed: ImGuiID): ImGuiID; cdecl;
  igImQsort: procedure(base: Pointer; count: NativeUInt; size_of_element: NativeUInt; compare_func: igImQsort_compare_func); cdecl;
  igImAlphaBlendColors: function(col_a: ImU32; col_b: ImU32): ImU32; cdecl;
  igImIsPowerOfTwo_Int: function(v: Integer): Boolean; cdecl;
  igImIsPowerOfTwo_U64: function(v: ImU64): Boolean; cdecl;
  igImUpperPowerOfTwo: function(v: Integer): Integer; cdecl;
  igImCountSetBits: function(v: Cardinal): Cardinal; cdecl;
  igImStricmp: function(const str1: PUTF8Char; const str2: PUTF8Char): Integer; cdecl;
  igImStrnicmp: function(const str1: PUTF8Char; const str2: PUTF8Char; count: NativeUInt): Integer; cdecl;
  igImStrncpy: procedure(dst: PUTF8Char; const src: PUTF8Char; count: NativeUInt); cdecl;
  igImStrdup: function(const str: PUTF8Char): PUTF8Char; cdecl;
  igImStrdupcpy: function(dst: PUTF8Char; p_dst_size: PNativeUInt; const str: PUTF8Char): PUTF8Char; cdecl;
  igImStrchrRange: function(const str_begin: PUTF8Char; const str_end: PUTF8Char; c: UTF8Char): PUTF8Char; cdecl;
  igImStreolRange: function(const str: PUTF8Char; const str_end: PUTF8Char): PUTF8Char; cdecl;
  igImStristr: function(const haystack: PUTF8Char; const haystack_end: PUTF8Char; const needle: PUTF8Char; const needle_end: PUTF8Char): PUTF8Char; cdecl;
  igImStrTrimBlanks: procedure(str: PUTF8Char); cdecl;
  igImStrSkipBlank: function(const str: PUTF8Char): PUTF8Char; cdecl;
  igImStrlenW: function(const str: PImWchar): Integer; cdecl;
  igImStrbol: function(const buf_mid_line: PUTF8Char; const buf_begin: PUTF8Char): PUTF8Char; cdecl;
  igImToUpper: function(c: UTF8Char): UTF8Char; cdecl;
  igImCharIsBlankA: function(c: UTF8Char): Boolean; cdecl;
  igImCharIsBlankW: function(c: Cardinal): Boolean; cdecl;
  igImCharIsXdigitA: function(c: UTF8Char): Boolean; cdecl;
  igImFormatString: function(buf: PUTF8Char; buf_size: NativeUInt; const fmt: PUTF8Char): Integer varargs; cdecl;
  igImFormatStringV: function(buf: PUTF8Char; buf_size: NativeUInt; const fmt: PUTF8Char; args: Pointer): Integer; cdecl;
  igImFormatStringToTempBuffer: procedure(out_buf: PPUTF8Char; out_buf_end: PPUTF8Char; const fmt: PUTF8Char) varargs; cdecl;
  igImFormatStringToTempBufferV: procedure(out_buf: PPUTF8Char; out_buf_end: PPUTF8Char; const fmt: PUTF8Char; args: Pointer); cdecl;
  igImParseFormatFindStart: function(const format: PUTF8Char): PUTF8Char; cdecl;
  igImParseFormatFindEnd: function(const format: PUTF8Char): PUTF8Char; cdecl;
  igImParseFormatTrimDecorations: function(const format: PUTF8Char; buf: PUTF8Char; buf_size: NativeUInt): PUTF8Char; cdecl;
  igImParseFormatSanitizeForPrinting: procedure(const fmt_in: PUTF8Char; fmt_out: PUTF8Char; fmt_out_size: NativeUInt); cdecl;
  igImParseFormatSanitizeForScanning: function(const fmt_in: PUTF8Char; fmt_out: PUTF8Char; fmt_out_size: NativeUInt): PUTF8Char; cdecl;
  igImParseFormatPrecision: function(const format: PUTF8Char; default_value: Integer): Integer; cdecl;
  igImTextCharToUtf8: function(out_buf: PUTF8Char; c: Cardinal): PUTF8Char; cdecl;
  igImTextStrToUtf8: function(out_buf: PUTF8Char; out_buf_size: Integer; const in_text: PImWchar; const in_text_end: PImWchar): Integer; cdecl;
  igImTextCharFromUtf8: function(out_char: PCardinal; const in_text: PUTF8Char; const in_text_end: PUTF8Char): Integer; cdecl;
  igImTextStrFromUtf8: function(out_buf: PImWchar; out_buf_size: Integer; const in_text: PUTF8Char; const in_text_end: PUTF8Char; in_remaining: PPUTF8Char): Integer; cdecl;
  igImTextCountCharsFromUtf8: function(const in_text: PUTF8Char; const in_text_end: PUTF8Char): Integer; cdecl;
  igImTextCountUtf8BytesFromChar: function(const in_text: PUTF8Char; const in_text_end: PUTF8Char): Integer; cdecl;
  igImTextCountUtf8BytesFromStr: function(const in_text: PImWchar; const in_text_end: PImWchar): Integer; cdecl;
  igImTextFindPreviousUtf8Codepoint: function(const in_text_start: PUTF8Char; const in_text_curr: PUTF8Char): PUTF8Char; cdecl;
  igImTextCountLines: function(const in_text: PUTF8Char; const in_text_end: PUTF8Char): Integer; cdecl;
  igImFileOpen: function(const filename: PUTF8Char; const mode: PUTF8Char): ImFileHandle; cdecl;
  igImFileClose: function(&file: ImFileHandle): Boolean; cdecl;
  igImFileGetSize: function(&file: ImFileHandle): ImU64; cdecl;
  igImFileRead: function(data: Pointer; size: ImU64; count: ImU64; &file: ImFileHandle): ImU64; cdecl;
  igImFileWrite: function(const data: Pointer; size: ImU64; count: ImU64; &file: ImFileHandle): ImU64; cdecl;
  igImFileLoadToMemory: function(const filename: PUTF8Char; const mode: PUTF8Char; out_file_size: PNativeUInt; padding_bytes: Integer): Pointer; cdecl;
  igImPow_Float: function(x: Single; y: Single): Single; cdecl;
  igImPow_double: function(x: Double; y: Double): Double; cdecl;
  igImLog_Float: function(x: Single): Single; cdecl;
  igImLog_double: function(x: Double): Double; cdecl;
  igImAbs_Int: function(x: Integer): Integer; cdecl;
  igImAbs_Float: function(x: Single): Single; cdecl;
  igImAbs_double: function(x: Double): Double; cdecl;
  igImSign_Float: function(x: Single): Single; cdecl;
  igImSign_double: function(x: Double): Double; cdecl;
  igImRsqrt_Float: function(x: Single): Single; cdecl;
  igImRsqrt_double: function(x: Double): Double; cdecl;
  igImMin: procedure(pOut: PImVec2; lhs: ImVec2; rhs: ImVec2); cdecl;
  igImMax: procedure(pOut: PImVec2; lhs: ImVec2; rhs: ImVec2); cdecl;
  igImClamp: procedure(pOut: PImVec2; v: ImVec2; mn: ImVec2; mx: ImVec2); cdecl;
  igImLerp_Vec2Float: procedure(pOut: PImVec2; a: ImVec2; b: ImVec2; t: Single); cdecl;
  igImLerp_Vec2Vec2: procedure(pOut: PImVec2; a: ImVec2; b: ImVec2; t: ImVec2); cdecl;
  igImLerp_Vec4: procedure(pOut: PImVec4; a: ImVec4; b: ImVec4; t: Single); cdecl;
  igImSaturate: function(f: Single): Single; cdecl;
  igImLengthSqr_Vec2: function(lhs: ImVec2): Single; cdecl;
  igImLengthSqr_Vec4: function(lhs: ImVec4): Single; cdecl;
  igImInvLength: function(lhs: ImVec2; fail_value: Single): Single; cdecl;
  igImTrunc_Float: function(f: Single): Single; cdecl;
  igImTrunc_Vec2: procedure(pOut: PImVec2; v: ImVec2); cdecl;
  igImFloor_Float: function(f: Single): Single; cdecl;
  igImFloor_Vec2: procedure(pOut: PImVec2; v: ImVec2); cdecl;
  igImModPositive: function(a: Integer; b: Integer): Integer; cdecl;
  igImDot: function(a: ImVec2; b: ImVec2): Single; cdecl;
  igImRotate: procedure(pOut: PImVec2; v: ImVec2; cos_a: Single; sin_a: Single); cdecl;
  igImLinearSweep: function(current: Single; target: Single; speed: Single): Single; cdecl;
  igImLinearRemapClamp: function(s0: Single; s1: Single; d0: Single; d1: Single; x: Single): Single; cdecl;
  igImMul: procedure(pOut: PImVec2; lhs: ImVec2; rhs: ImVec2); cdecl;
  igImIsFloatAboveGuaranteedIntegerPrecision: function(f: Single): Boolean; cdecl;
  igImExponentialMovingAverage: function(avg: Single; sample: Single; n: Integer): Single; cdecl;
  igImBezierCubicCalc: procedure(pOut: PImVec2; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; t: Single); cdecl;
  igImBezierCubicClosestPoint: procedure(pOut: PImVec2; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; p: ImVec2; num_segments: Integer); cdecl;
  igImBezierCubicClosestPointCasteljau: procedure(pOut: PImVec2; p1: ImVec2; p2: ImVec2; p3: ImVec2; p4: ImVec2; p: ImVec2; tess_tol: Single); cdecl;
  igImBezierQuadraticCalc: procedure(pOut: PImVec2; p1: ImVec2; p2: ImVec2; p3: ImVec2; t: Single); cdecl;
  igImLineClosestPoint: procedure(pOut: PImVec2; a: ImVec2; b: ImVec2; p: ImVec2); cdecl;
  igImTriangleContainsPoint: function(a: ImVec2; b: ImVec2; c: ImVec2; p: ImVec2): Boolean; cdecl;
  igImTriangleClosestPoint: procedure(pOut: PImVec2; a: ImVec2; b: ImVec2; c: ImVec2; p: ImVec2); cdecl;
  igImTriangleBarycentricCoords: procedure(a: ImVec2; b: ImVec2; c: ImVec2; p: ImVec2; out_u: PSingle; out_v: PSingle; out_w: PSingle); cdecl;
  igImTriangleArea: function(a: ImVec2; b: ImVec2; c: ImVec2): Single; cdecl;
  igImTriangleIsClockwise: function(a: ImVec2; b: ImVec2; c: ImVec2): Boolean; cdecl;
  ImVec1_ImVec1_Nil: function(): PImVec1; cdecl;
  ImVec1_destroy: procedure(self: PImVec1); cdecl;
  ImVec1_ImVec1_Float: function(_x: Single): PImVec1; cdecl;
  ImVec2ih_ImVec2ih_Nil: function(): PImVec2ih; cdecl;
  ImVec2ih_destroy: procedure(self: PImVec2ih); cdecl;
  ImVec2ih_ImVec2ih_short: function(_x: Smallint; _y: Smallint): PImVec2ih; cdecl;
  ImVec2ih_ImVec2ih_Vec2: function(rhs: ImVec2): PImVec2ih; cdecl;
  ImRect_ImRect_Nil: function(): PImRect; cdecl;
  ImRect_destroy: procedure(self: PImRect); cdecl;
  ImRect_ImRect_Vec2: function(min: ImVec2; max: ImVec2): PImRect; cdecl;
  ImRect_ImRect_Vec4: function(v: ImVec4): PImRect; cdecl;
  ImRect_ImRect_Float: function(x1: Single; y1: Single; x2: Single; y2: Single): PImRect; cdecl;
  ImRect_GetCenter: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_GetSize: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_GetWidth: function(self: PImRect): Single; cdecl;
  ImRect_GetHeight: function(self: PImRect): Single; cdecl;
  ImRect_GetArea: function(self: PImRect): Single; cdecl;
  ImRect_GetTL: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_GetTR: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_GetBL: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_GetBR: procedure(pOut: PImVec2; self: PImRect); cdecl;
  ImRect_Contains_Vec2: function(self: PImRect; p: ImVec2): Boolean; cdecl;
  ImRect_Contains_Rect: function(self: PImRect; r: ImRect): Boolean; cdecl;
  ImRect_ContainsWithPad: function(self: PImRect; p: ImVec2; pad: ImVec2): Boolean; cdecl;
  ImRect_Overlaps: function(self: PImRect; r: ImRect): Boolean; cdecl;
  ImRect_Add_Vec2: procedure(self: PImRect; p: ImVec2); cdecl;
  ImRect_Add_Rect: procedure(self: PImRect; r: ImRect); cdecl;
  ImRect_Expand_Float: procedure(self: PImRect; const amount: Single); cdecl;
  ImRect_Expand_Vec2: procedure(self: PImRect; amount: ImVec2); cdecl;
  ImRect_Translate: procedure(self: PImRect; d: ImVec2); cdecl;
  ImRect_TranslateX: procedure(self: PImRect; dx: Single); cdecl;
  ImRect_TranslateY: procedure(self: PImRect; dy: Single); cdecl;
  ImRect_ClipWith: procedure(self: PImRect; r: ImRect); cdecl;
  ImRect_ClipWithFull: procedure(self: PImRect; r: ImRect); cdecl;
  ImRect_Floor: procedure(self: PImRect); cdecl;
  ImRect_IsInverted: function(self: PImRect): Boolean; cdecl;
  ImRect_ToVec4: procedure(pOut: PImVec4; self: PImRect); cdecl;
  igImBitArrayGetStorageSizeInBytes: function(bitcount: Integer): NativeUInt; cdecl;
  igImBitArrayClearAllBits: procedure(arr: PImU32; bitcount: Integer); cdecl;
  igImBitArrayTestBit: function(const arr: PImU32; n: Integer): Boolean; cdecl;
  igImBitArrayClearBit: procedure(arr: PImU32; n: Integer); cdecl;
  igImBitArraySetBit: procedure(arr: PImU32; n: Integer); cdecl;
  igImBitArraySetBitRange: procedure(arr: PImU32; n: Integer; n2: Integer); cdecl;
  ImBitVector_Create: procedure(self: PImBitVector; sz: Integer); cdecl;
  ImBitVector_Clear: procedure(self: PImBitVector); cdecl;
  ImBitVector_TestBit: function(self: PImBitVector; n: Integer): Boolean; cdecl;
  ImBitVector_SetBit: procedure(self: PImBitVector; n: Integer); cdecl;
  ImBitVector_ClearBit: procedure(self: PImBitVector; n: Integer); cdecl;
  ImGuiTextIndex_clear: procedure(self: PImGuiTextIndex); cdecl;
  ImGuiTextIndex_size: function(self: PImGuiTextIndex): Integer; cdecl;
  ImGuiTextIndex_get_line_begin: function(self: PImGuiTextIndex; const base: PUTF8Char; n: Integer): PUTF8Char; cdecl;
  ImGuiTextIndex_get_line_end: function(self: PImGuiTextIndex; const base: PUTF8Char; n: Integer): PUTF8Char; cdecl;
  ImGuiTextIndex_append: procedure(self: PImGuiTextIndex; const base: PUTF8Char; old_size: Integer; new_size: Integer); cdecl;
  igImLowerBound: function(in_begin: PImGuiStoragePair; in_end: PImGuiStoragePair; key: ImGuiID): PImGuiStoragePair; cdecl;
  ImDrawListSharedData_ImDrawListSharedData: function(): PImDrawListSharedData; cdecl;
  ImDrawListSharedData_destroy: procedure(self: PImDrawListSharedData); cdecl;
  ImDrawListSharedData_SetCircleTessellationMaxError: procedure(self: PImDrawListSharedData; max_error: Single); cdecl;
  ImDrawDataBuilder_ImDrawDataBuilder: function(): PImDrawDataBuilder; cdecl;
  ImDrawDataBuilder_destroy: procedure(self: PImDrawDataBuilder); cdecl;
  ImGuiStyleVarInfo_GetVarPtr: function(self: PImGuiStyleVarInfo; parent: Pointer): Pointer; cdecl;
  ImGuiStyleMod_ImGuiStyleMod_Int: function(idx: ImGuiStyleVar; v: Integer): PImGuiStyleMod; cdecl;
  ImGuiStyleMod_destroy: procedure(self: PImGuiStyleMod); cdecl;
  ImGuiStyleMod_ImGuiStyleMod_Float: function(idx: ImGuiStyleVar; v: Single): PImGuiStyleMod; cdecl;
  ImGuiStyleMod_ImGuiStyleMod_Vec2: function(idx: ImGuiStyleVar; v: ImVec2): PImGuiStyleMod; cdecl;
  ImGuiComboPreviewData_ImGuiComboPreviewData: function(): PImGuiComboPreviewData; cdecl;
  ImGuiComboPreviewData_destroy: procedure(self: PImGuiComboPreviewData); cdecl;
  ImGuiMenuColumns_ImGuiMenuColumns: function(): PImGuiMenuColumns; cdecl;
  ImGuiMenuColumns_destroy: procedure(self: PImGuiMenuColumns); cdecl;
  ImGuiMenuColumns_Update: procedure(self: PImGuiMenuColumns; spacing: Single; window_reappearing: Boolean); cdecl;
  ImGuiMenuColumns_DeclColumns: function(self: PImGuiMenuColumns; w_icon: Single; w_label: Single; w_shortcut: Single; w_mark: Single): Single; cdecl;
  ImGuiMenuColumns_CalcNextTotalWidth: procedure(self: PImGuiMenuColumns; update_offsets: Boolean); cdecl;
  ImGuiInputTextDeactivatedState_ImGuiInputTextDeactivatedState: function(): PImGuiInputTextDeactivatedState; cdecl;
  ImGuiInputTextDeactivatedState_destroy: procedure(self: PImGuiInputTextDeactivatedState); cdecl;
  ImGuiInputTextDeactivatedState_ClearFreeMemory: procedure(self: PImGuiInputTextDeactivatedState); cdecl;
  ImGuiInputTextState_ImGuiInputTextState: function(): PImGuiInputTextState; cdecl;
  ImGuiInputTextState_destroy: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_ClearText: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_ClearFreeMemory: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_OnKeyPressed: procedure(self: PImGuiInputTextState; key: Integer); cdecl;
  ImGuiInputTextState_OnCharPressed: procedure(self: PImGuiInputTextState; c: Cardinal); cdecl;
  ImGuiInputTextState_CursorAnimReset: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_CursorClamp: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_HasSelection: function(self: PImGuiInputTextState): Boolean; cdecl;
  ImGuiInputTextState_ClearSelection: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_GetCursorPos: function(self: PImGuiInputTextState): Integer; cdecl;
  ImGuiInputTextState_GetSelectionStart: function(self: PImGuiInputTextState): Integer; cdecl;
  ImGuiInputTextState_GetSelectionEnd: function(self: PImGuiInputTextState): Integer; cdecl;
  ImGuiInputTextState_SelectAll: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_ReloadUserBufAndSelectAll: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_ReloadUserBufAndKeepSelection: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiInputTextState_ReloadUserBufAndMoveToEnd: procedure(self: PImGuiInputTextState); cdecl;
  ImGuiNextWindowData_ImGuiNextWindowData: function(): PImGuiNextWindowData; cdecl;
  ImGuiNextWindowData_destroy: procedure(self: PImGuiNextWindowData); cdecl;
  ImGuiNextWindowData_ClearFlags: procedure(self: PImGuiNextWindowData); cdecl;
  ImGuiNextItemData_ImGuiNextItemData: function(): PImGuiNextItemData; cdecl;
  ImGuiNextItemData_destroy: procedure(self: PImGuiNextItemData); cdecl;
  ImGuiNextItemData_ClearFlags: procedure(self: PImGuiNextItemData); cdecl;
  ImGuiLastItemData_ImGuiLastItemData: function(): PImGuiLastItemData; cdecl;
  ImGuiLastItemData_destroy: procedure(self: PImGuiLastItemData); cdecl;
  ImGuiErrorRecoveryState_ImGuiErrorRecoveryState: function(): PImGuiErrorRecoveryState; cdecl;
  ImGuiErrorRecoveryState_destroy: procedure(self: PImGuiErrorRecoveryState); cdecl;
  ImGuiPtrOrIndex_ImGuiPtrOrIndex_Ptr: function(ptr: Pointer): PImGuiPtrOrIndex; cdecl;
  ImGuiPtrOrIndex_destroy: procedure(self: PImGuiPtrOrIndex); cdecl;
  ImGuiPtrOrIndex_ImGuiPtrOrIndex_Int: function(index: Integer): PImGuiPtrOrIndex; cdecl;
  ImGuiPopupData_ImGuiPopupData: function(): PImGuiPopupData; cdecl;
  ImGuiPopupData_destroy: procedure(self: PImGuiPopupData); cdecl;
  ImGuiInputEvent_ImGuiInputEvent: function(): PImGuiInputEvent; cdecl;
  ImGuiInputEvent_destroy: procedure(self: PImGuiInputEvent); cdecl;
  ImGuiKeyRoutingData_ImGuiKeyRoutingData: function(): PImGuiKeyRoutingData; cdecl;
  ImGuiKeyRoutingData_destroy: procedure(self: PImGuiKeyRoutingData); cdecl;
  ImGuiKeyRoutingTable_ImGuiKeyRoutingTable: function(): PImGuiKeyRoutingTable; cdecl;
  ImGuiKeyRoutingTable_destroy: procedure(self: PImGuiKeyRoutingTable); cdecl;
  ImGuiKeyRoutingTable_Clear: procedure(self: PImGuiKeyRoutingTable); cdecl;
  ImGuiKeyOwnerData_ImGuiKeyOwnerData: function(): PImGuiKeyOwnerData; cdecl;
  ImGuiKeyOwnerData_destroy: procedure(self: PImGuiKeyOwnerData); cdecl;
  ImGuiListClipperRange_FromIndices: function(min: Integer; max: Integer): ImGuiListClipperRange; cdecl;
  ImGuiListClipperRange_FromPositions: function(y1: Single; y2: Single; off_min: Integer; off_max: Integer): ImGuiListClipperRange; cdecl;
  ImGuiListClipperData_ImGuiListClipperData: function(): PImGuiListClipperData; cdecl;
  ImGuiListClipperData_destroy: procedure(self: PImGuiListClipperData); cdecl;
  ImGuiListClipperData_Reset: procedure(self: PImGuiListClipperData; clipper: PImGuiListClipper); cdecl;
  ImGuiNavItemData_ImGuiNavItemData: function(): PImGuiNavItemData; cdecl;
  ImGuiNavItemData_destroy: procedure(self: PImGuiNavItemData); cdecl;
  ImGuiNavItemData_Clear: procedure(self: PImGuiNavItemData); cdecl;
  ImGuiTypingSelectState_ImGuiTypingSelectState: function(): PImGuiTypingSelectState; cdecl;
  ImGuiTypingSelectState_destroy: procedure(self: PImGuiTypingSelectState); cdecl;
  ImGuiTypingSelectState_Clear: procedure(self: PImGuiTypingSelectState); cdecl;
  ImGuiOldColumnData_ImGuiOldColumnData: function(): PImGuiOldColumnData; cdecl;
  ImGuiOldColumnData_destroy: procedure(self: PImGuiOldColumnData); cdecl;
  ImGuiOldColumns_ImGuiOldColumns: function(): PImGuiOldColumns; cdecl;
  ImGuiOldColumns_destroy: procedure(self: PImGuiOldColumns); cdecl;
  ImGuiBoxSelectState_ImGuiBoxSelectState: function(): PImGuiBoxSelectState; cdecl;
  ImGuiBoxSelectState_destroy: procedure(self: PImGuiBoxSelectState); cdecl;
  ImGuiMultiSelectTempData_ImGuiMultiSelectTempData: function(): PImGuiMultiSelectTempData; cdecl;
  ImGuiMultiSelectTempData_destroy: procedure(self: PImGuiMultiSelectTempData); cdecl;
  ImGuiMultiSelectTempData_Clear: procedure(self: PImGuiMultiSelectTempData); cdecl;
  ImGuiMultiSelectTempData_ClearIO: procedure(self: PImGuiMultiSelectTempData); cdecl;
  ImGuiMultiSelectState_ImGuiMultiSelectState: function(): PImGuiMultiSelectState; cdecl;
  ImGuiMultiSelectState_destroy: procedure(self: PImGuiMultiSelectState); cdecl;
  ImGuiDockNode_ImGuiDockNode: function(id: ImGuiID): PImGuiDockNode; cdecl;
  ImGuiDockNode_destroy: procedure(self: PImGuiDockNode); cdecl;
  ImGuiDockNode_IsRootNode: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsDockSpace: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsFloatingNode: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsCentralNode: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsHiddenTabBar: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsNoTabBar: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsSplitNode: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsLeafNode: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_IsEmpty: function(self: PImGuiDockNode): Boolean; cdecl;
  ImGuiDockNode_Rect: procedure(pOut: PImRect; self: PImGuiDockNode); cdecl;
  ImGuiDockNode_SetLocalFlags: procedure(self: PImGuiDockNode; flags: ImGuiDockNodeFlags); cdecl;
  ImGuiDockNode_UpdateMergedFlags: procedure(self: PImGuiDockNode); cdecl;
  ImGuiDockContext_ImGuiDockContext: function(): PImGuiDockContext; cdecl;
  ImGuiDockContext_destroy: procedure(self: PImGuiDockContext); cdecl;
  ImGuiViewportP_ImGuiViewportP: function(): PImGuiViewportP; cdecl;
  ImGuiViewportP_destroy: procedure(self: PImGuiViewportP); cdecl;
  ImGuiViewportP_ClearRequestFlags: procedure(self: PImGuiViewportP); cdecl;
  ImGuiViewportP_CalcWorkRectPos: procedure(pOut: PImVec2; self: PImGuiViewportP; inset_min: ImVec2); cdecl;
  ImGuiViewportP_CalcWorkRectSize: procedure(pOut: PImVec2; self: PImGuiViewportP; inset_min: ImVec2; inset_max: ImVec2); cdecl;
  ImGuiViewportP_UpdateWorkRect: procedure(self: PImGuiViewportP); cdecl;
  ImGuiViewportP_GetMainRect: procedure(pOut: PImRect; self: PImGuiViewportP); cdecl;
  ImGuiViewportP_GetWorkRect: procedure(pOut: PImRect; self: PImGuiViewportP); cdecl;
  ImGuiViewportP_GetBuildWorkRect: procedure(pOut: PImRect; self: PImGuiViewportP); cdecl;
  ImGuiWindowSettings_ImGuiWindowSettings: function(): PImGuiWindowSettings; cdecl;
  ImGuiWindowSettings_destroy: procedure(self: PImGuiWindowSettings); cdecl;
  ImGuiWindowSettings_GetName: function(self: PImGuiWindowSettings): PUTF8Char; cdecl;
  ImGuiSettingsHandler_ImGuiSettingsHandler: function(): PImGuiSettingsHandler; cdecl;
  ImGuiSettingsHandler_destroy: procedure(self: PImGuiSettingsHandler); cdecl;
  ImGuiDebugAllocInfo_ImGuiDebugAllocInfo: function(): PImGuiDebugAllocInfo; cdecl;
  ImGuiDebugAllocInfo_destroy: procedure(self: PImGuiDebugAllocInfo); cdecl;
  ImGuiStackLevelInfo_ImGuiStackLevelInfo: function(): PImGuiStackLevelInfo; cdecl;
  ImGuiStackLevelInfo_destroy: procedure(self: PImGuiStackLevelInfo); cdecl;
  ImGuiIDStackTool_ImGuiIDStackTool: function(): PImGuiIDStackTool; cdecl;
  ImGuiIDStackTool_destroy: procedure(self: PImGuiIDStackTool); cdecl;
  ImGuiContextHook_ImGuiContextHook: function(): PImGuiContextHook; cdecl;
  ImGuiContextHook_destroy: procedure(self: PImGuiContextHook); cdecl;
  ImGuiContext_ImGuiContext: function(shared_font_atlas: PImFontAtlas): PImGuiContext; cdecl;
  ImGuiContext_destroy: procedure(self: PImGuiContext); cdecl;
  ImGuiWindow_ImGuiWindow: function(context: PImGuiContext; const name: PUTF8Char): PImGuiWindow; cdecl;
  ImGuiWindow_destroy: procedure(self: PImGuiWindow); cdecl;
  ImGuiWindow_GetID_Str: function(self: PImGuiWindow; const str: PUTF8Char; const str_end: PUTF8Char): ImGuiID; cdecl;
  ImGuiWindow_GetID_Ptr: function(self: PImGuiWindow; const ptr: Pointer): ImGuiID; cdecl;
  ImGuiWindow_GetID_Int: function(self: PImGuiWindow; n: Integer): ImGuiID; cdecl;
  ImGuiWindow_GetIDFromPos: function(self: PImGuiWindow; p_abs: ImVec2): ImGuiID; cdecl;
  ImGuiWindow_GetIDFromRectangle: function(self: PImGuiWindow; r_abs: ImRect): ImGuiID; cdecl;
  ImGuiWindow_Rect: procedure(pOut: PImRect; self: PImGuiWindow); cdecl;
  ImGuiWindow_CalcFontSize: function(self: PImGuiWindow): Single; cdecl;
  ImGuiWindow_TitleBarRect: procedure(pOut: PImRect; self: PImGuiWindow); cdecl;
  ImGuiWindow_MenuBarRect: procedure(pOut: PImRect; self: PImGuiWindow); cdecl;
  ImGuiTabItem_ImGuiTabItem: function(): PImGuiTabItem; cdecl;
  ImGuiTabItem_destroy: procedure(self: PImGuiTabItem); cdecl;
  ImGuiTabBar_ImGuiTabBar: function(): PImGuiTabBar; cdecl;
  ImGuiTabBar_destroy: procedure(self: PImGuiTabBar); cdecl;
  ImGuiTableColumn_ImGuiTableColumn: function(): PImGuiTableColumn; cdecl;
  ImGuiTableColumn_destroy: procedure(self: PImGuiTableColumn); cdecl;
  ImGuiTableInstanceData_ImGuiTableInstanceData: function(): PImGuiTableInstanceData; cdecl;
  ImGuiTableInstanceData_destroy: procedure(self: PImGuiTableInstanceData); cdecl;
  ImGuiTable_ImGuiTable: function(): PImGuiTable; cdecl;
  ImGuiTable_destroy: procedure(self: PImGuiTable); cdecl;
  ImGuiTableTempData_ImGuiTableTempData: function(): PImGuiTableTempData; cdecl;
  ImGuiTableTempData_destroy: procedure(self: PImGuiTableTempData); cdecl;
  ImGuiTableColumnSettings_ImGuiTableColumnSettings: function(): PImGuiTableColumnSettings; cdecl;
  ImGuiTableColumnSettings_destroy: procedure(self: PImGuiTableColumnSettings); cdecl;
  ImGuiTableSettings_ImGuiTableSettings: function(): PImGuiTableSettings; cdecl;
  ImGuiTableSettings_destroy: procedure(self: PImGuiTableSettings); cdecl;
  ImGuiTableSettings_GetColumnSettings: function(self: PImGuiTableSettings): PImGuiTableColumnSettings; cdecl;
  igGetIO_ContextPtr: function(ctx: PImGuiContext): PImGuiIO; cdecl;
  igGetPlatformIO_ContextPtr: function(ctx: PImGuiContext): PImGuiPlatformIO; cdecl;
  igGetCurrentWindowRead: function(): PImGuiWindow; cdecl;
  igGetCurrentWindow: function(): PImGuiWindow; cdecl;
  igFindWindowByID: function(id: ImGuiID): PImGuiWindow; cdecl;
  igFindWindowByName: function(const name: PUTF8Char): PImGuiWindow; cdecl;
  igUpdateWindowParentAndRootLinks: procedure(window: PImGuiWindow; flags: ImGuiWindowFlags; parent_window: PImGuiWindow); cdecl;
  igUpdateWindowSkipRefresh: procedure(window: PImGuiWindow); cdecl;
  igCalcWindowNextAutoFitSize: procedure(pOut: PImVec2; window: PImGuiWindow); cdecl;
  igIsWindowChildOf: function(window: PImGuiWindow; potential_parent: PImGuiWindow; popup_hierarchy: Boolean; dock_hierarchy: Boolean): Boolean; cdecl;
  igIsWindowWithinBeginStackOf: function(window: PImGuiWindow; potential_parent: PImGuiWindow): Boolean; cdecl;
  igIsWindowAbove: function(potential_above: PImGuiWindow; potential_below: PImGuiWindow): Boolean; cdecl;
  igIsWindowNavFocusable: function(window: PImGuiWindow): Boolean; cdecl;
  igSetWindowPos_WindowPtr: procedure(window: PImGuiWindow; pos: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowSize_WindowPtr: procedure(window: PImGuiWindow; size: ImVec2; cond: ImGuiCond); cdecl;
  igSetWindowCollapsed_WindowPtr: procedure(window: PImGuiWindow; collapsed: Boolean; cond: ImGuiCond); cdecl;
  igSetWindowHitTestHole: procedure(window: PImGuiWindow; pos: ImVec2; size: ImVec2); cdecl;
  igSetWindowHiddenAndSkipItemsForCurrentFrame: procedure(window: PImGuiWindow); cdecl;
  igSetWindowParentWindowForFocusRoute: procedure(window: PImGuiWindow; parent_window: PImGuiWindow); cdecl;
  igWindowRectAbsToRel: procedure(pOut: PImRect; window: PImGuiWindow; r: ImRect); cdecl;
  igWindowRectRelToAbs: procedure(pOut: PImRect; window: PImGuiWindow; r: ImRect); cdecl;
  igWindowPosAbsToRel: procedure(pOut: PImVec2; window: PImGuiWindow; p: ImVec2); cdecl;
  igWindowPosRelToAbs: procedure(pOut: PImVec2; window: PImGuiWindow; p: ImVec2); cdecl;
  igFocusWindow: procedure(window: PImGuiWindow; flags: ImGuiFocusRequestFlags); cdecl;
  igFocusTopMostWindowUnderOne: procedure(under_this_window: PImGuiWindow; ignore_window: PImGuiWindow; filter_viewport: PImGuiViewport; flags: ImGuiFocusRequestFlags); cdecl;
  igBringWindowToFocusFront: procedure(window: PImGuiWindow); cdecl;
  igBringWindowToDisplayFront: procedure(window: PImGuiWindow); cdecl;
  igBringWindowToDisplayBack: procedure(window: PImGuiWindow); cdecl;
  igBringWindowToDisplayBehind: procedure(window: PImGuiWindow; above_window: PImGuiWindow); cdecl;
  igFindWindowDisplayIndex: function(window: PImGuiWindow): Integer; cdecl;
  igFindBottomMostVisibleWindowWithinBeginStack: function(window: PImGuiWindow): PImGuiWindow; cdecl;
  igSetNextWindowRefreshPolicy: procedure(flags: ImGuiWindowRefreshFlags); cdecl;
  igSetCurrentFont: procedure(font: PImFont); cdecl;
  igGetDefaultFont: function(): PImFont; cdecl;
  igPushPasswordFont: procedure(); cdecl;
  igGetForegroundDrawList_WindowPtr: function(window: PImGuiWindow): PImDrawList; cdecl;
  igAddDrawListToDrawDataEx: procedure(draw_data: PImDrawData; out_list: PImVector_ImDrawListPtr; draw_list: PImDrawList); cdecl;
  igInitialize: procedure(); cdecl;
  igShutdown: procedure(); cdecl;
  igUpdateInputEvents: procedure(trickle_fast_inputs: Boolean); cdecl;
  igUpdateHoveredWindowAndCaptureFlags: procedure(); cdecl;
  igFindHoveredWindowEx: procedure(pos: ImVec2; find_first_and_in_any_viewport: Boolean; out_hovered_window: PPImGuiWindow; out_hovered_window_under_moving_window: PPImGuiWindow); cdecl;
  igStartMouseMovingWindow: procedure(window: PImGuiWindow); cdecl;
  igStartMouseMovingWindowOrNode: procedure(window: PImGuiWindow; node: PImGuiDockNode; undock: Boolean); cdecl;
  igUpdateMouseMovingWindowNewFrame: procedure(); cdecl;
  igUpdateMouseMovingWindowEndFrame: procedure(); cdecl;
  igAddContextHook: function(context: PImGuiContext; const hook: PImGuiContextHook): ImGuiID; cdecl;
  igRemoveContextHook: procedure(context: PImGuiContext; hook_to_remove: ImGuiID); cdecl;
  igCallContextHooks: procedure(context: PImGuiContext; &type: ImGuiContextHookType); cdecl;
  igTranslateWindowsInViewport: procedure(viewport: PImGuiViewportP; old_pos: ImVec2; new_pos: ImVec2; old_size: ImVec2; new_size: ImVec2); cdecl;
  igScaleWindowsInViewport: procedure(viewport: PImGuiViewportP; scale: Single); cdecl;
  igDestroyPlatformWindow: procedure(viewport: PImGuiViewportP); cdecl;
  igSetWindowViewport: procedure(window: PImGuiWindow; viewport: PImGuiViewportP); cdecl;
  igSetCurrentViewport: procedure(window: PImGuiWindow; viewport: PImGuiViewportP); cdecl;
  igGetViewportPlatformMonitor: function(viewport: PImGuiViewport): PImGuiPlatformMonitor; cdecl;
  igFindHoveredViewportFromPlatformWindowStack: function(mouse_platform_pos: ImVec2): PImGuiViewportP; cdecl;
  igMarkIniSettingsDirty_Nil: procedure(); cdecl;
  igMarkIniSettingsDirty_WindowPtr: procedure(window: PImGuiWindow); cdecl;
  igClearIniSettings: procedure(); cdecl;
  igAddSettingsHandler: procedure(const handler: PImGuiSettingsHandler); cdecl;
  igRemoveSettingsHandler: procedure(const type_name: PUTF8Char); cdecl;
  igFindSettingsHandler: function(const type_name: PUTF8Char): PImGuiSettingsHandler; cdecl;
  igCreateNewWindowSettings: function(const name: PUTF8Char): PImGuiWindowSettings; cdecl;
  igFindWindowSettingsByID: function(id: ImGuiID): PImGuiWindowSettings; cdecl;
  igFindWindowSettingsByWindow: function(window: PImGuiWindow): PImGuiWindowSettings; cdecl;
  igClearWindowSettings: procedure(const name: PUTF8Char); cdecl;
  igLocalizeRegisterEntries: procedure(const entries: PImGuiLocEntry; count: Integer); cdecl;
  igLocalizeGetMsg: function(key: ImGuiLocKey): PUTF8Char; cdecl;
  igSetScrollX_WindowPtr: procedure(window: PImGuiWindow; scroll_x: Single); cdecl;
  igSetScrollY_WindowPtr: procedure(window: PImGuiWindow; scroll_y: Single); cdecl;
  igSetScrollFromPosX_WindowPtr: procedure(window: PImGuiWindow; local_x: Single; center_x_ratio: Single); cdecl;
  igSetScrollFromPosY_WindowPtr: procedure(window: PImGuiWindow; local_y: Single; center_y_ratio: Single); cdecl;
  igScrollToItem: procedure(flags: ImGuiScrollFlags); cdecl;
  igScrollToRect: procedure(window: PImGuiWindow; rect: ImRect; flags: ImGuiScrollFlags); cdecl;
  igScrollToRectEx: procedure(pOut: PImVec2; window: PImGuiWindow; rect: ImRect; flags: ImGuiScrollFlags); cdecl;
  igScrollToBringRectIntoView: procedure(window: PImGuiWindow; rect: ImRect); cdecl;
  igGetItemStatusFlags: function(): ImGuiItemStatusFlags; cdecl;
  igGetItemFlags: function(): ImGuiItemFlags; cdecl;
  igGetActiveID: function(): ImGuiID; cdecl;
  igGetFocusID: function(): ImGuiID; cdecl;
  igSetActiveID: procedure(id: ImGuiID; window: PImGuiWindow); cdecl;
  igSetFocusID: procedure(id: ImGuiID; window: PImGuiWindow); cdecl;
  igClearActiveID: procedure(); cdecl;
  igGetHoveredID: function(): ImGuiID; cdecl;
  igSetHoveredID: procedure(id: ImGuiID); cdecl;
  igKeepAliveID: procedure(id: ImGuiID); cdecl;
  igMarkItemEdited: procedure(id: ImGuiID); cdecl;
  igPushOverrideID: procedure(id: ImGuiID); cdecl;
  igGetIDWithSeed_Str: function(const str_id_begin: PUTF8Char; const str_id_end: PUTF8Char; seed: ImGuiID): ImGuiID; cdecl;
  igGetIDWithSeed_Int: function(n: Integer; seed: ImGuiID): ImGuiID; cdecl;
  igItemSize_Vec2: procedure(size: ImVec2; text_baseline_y: Single); cdecl;
  igItemSize_Rect: procedure(bb: ImRect; text_baseline_y: Single); cdecl;
  igItemAdd: function(bb: ImRect; id: ImGuiID; const nav_bb: PImRect; extra_flags: ImGuiItemFlags): Boolean; cdecl;
  igItemHoverable: function(bb: ImRect; id: ImGuiID; item_flags: ImGuiItemFlags): Boolean; cdecl;
  igIsWindowContentHoverable: function(window: PImGuiWindow; flags: ImGuiHoveredFlags): Boolean; cdecl;
  igIsClippedEx: function(bb: ImRect; id: ImGuiID): Boolean; cdecl;
  igSetLastItemData: procedure(item_id: ImGuiID; item_flags: ImGuiItemFlags; status_flags: ImGuiItemStatusFlags; item_rect: ImRect); cdecl;
  igCalcItemSize: procedure(pOut: PImVec2; size: ImVec2; default_w: Single; default_h: Single); cdecl;
  igCalcWrapWidthForPos: function(pos: ImVec2; wrap_pos_x: Single): Single; cdecl;
  igPushMultiItemsWidths: procedure(components: Integer; width_full: Single); cdecl;
  igShrinkWidths: procedure(items: PImGuiShrinkWidthItem; count: Integer; width_excess: Single); cdecl;
  igGetStyleVarInfo: function(idx: ImGuiStyleVar): PImGuiStyleVarInfo; cdecl;
  igBeginDisabledOverrideReenable: procedure(); cdecl;
  igEndDisabledOverrideReenable: procedure(); cdecl;
  igLogBegin: procedure(flags: ImGuiLogFlags; auto_open_depth: Integer); cdecl;
  igLogToBuffer: procedure(auto_open_depth: Integer); cdecl;
  igLogRenderedText: procedure(const ref_pos: PImVec2; const text: PUTF8Char; const text_end: PUTF8Char); cdecl;
  igLogSetNextTextDecoration: procedure(const prefix: PUTF8Char; const suffix: PUTF8Char); cdecl;
  igBeginChildEx: function(const name: PUTF8Char; id: ImGuiID; size_arg: ImVec2; child_flags: ImGuiChildFlags; window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginPopupEx: function(id: ImGuiID; extra_window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginPopupMenuEx: function(id: ImGuiID; const &label: PUTF8Char; extra_window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igOpenPopupEx: procedure(id: ImGuiID; popup_flags: ImGuiPopupFlags); cdecl;
  igClosePopupToLevel: procedure(remaining: Integer; restore_focus_to_window_under_popup: Boolean); cdecl;
  igClosePopupsOverWindow: procedure(ref_window: PImGuiWindow; restore_focus_to_window_under_popup: Boolean); cdecl;
  igClosePopupsExceptModals: procedure(); cdecl;
  igIsPopupOpen_ID: function(id: ImGuiID; popup_flags: ImGuiPopupFlags): Boolean; cdecl;
  igGetPopupAllowedExtentRect: procedure(pOut: PImRect; window: PImGuiWindow); cdecl;
  igGetTopMostPopupModal: function(): PImGuiWindow; cdecl;
  igGetTopMostAndVisiblePopupModal: function(): PImGuiWindow; cdecl;
  igFindBlockingModal: function(window: PImGuiWindow): PImGuiWindow; cdecl;
  igFindBestWindowPosForPopup: procedure(pOut: PImVec2; window: PImGuiWindow); cdecl;
  igFindBestWindowPosForPopupEx: procedure(pOut: PImVec2; ref_pos: ImVec2; size: ImVec2; last_dir: PImGuiDir; r_outer: ImRect; r_avoid: ImRect; policy: ImGuiPopupPositionPolicy); cdecl;
  igBeginTooltipEx: function(tooltip_flags: ImGuiTooltipFlags; extra_window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginTooltipHidden: function(): Boolean; cdecl;
  igBeginViewportSideBar: function(const name: PUTF8Char; viewport: PImGuiViewport; dir: ImGuiDir; size: Single; window_flags: ImGuiWindowFlags): Boolean; cdecl;
  igBeginMenuEx: function(const &label: PUTF8Char; const icon: PUTF8Char; enabled: Boolean): Boolean; cdecl;
  igMenuItemEx: function(const &label: PUTF8Char; const icon: PUTF8Char; const shortcut: PUTF8Char; selected: Boolean; enabled: Boolean): Boolean; cdecl;
  igBeginComboPopup: function(popup_id: ImGuiID; bb: ImRect; flags: ImGuiComboFlags): Boolean; cdecl;
  igBeginComboPreview: function(): Boolean; cdecl;
  igEndComboPreview: procedure(); cdecl;
  igNavInitWindow: procedure(window: PImGuiWindow; force_reinit: Boolean); cdecl;
  igNavInitRequestApplyResult: procedure(); cdecl;
  igNavMoveRequestButNoResultYet: function(): Boolean; cdecl;
  igNavMoveRequestSubmit: procedure(move_dir: ImGuiDir; clip_dir: ImGuiDir; move_flags: ImGuiNavMoveFlags; scroll_flags: ImGuiScrollFlags); cdecl;
  igNavMoveRequestForward: procedure(move_dir: ImGuiDir; clip_dir: ImGuiDir; move_flags: ImGuiNavMoveFlags; scroll_flags: ImGuiScrollFlags); cdecl;
  igNavMoveRequestResolveWithLastItem: procedure(result: PImGuiNavItemData); cdecl;
  igNavMoveRequestResolveWithPastTreeNode: procedure(result: PImGuiNavItemData; tree_node_data: PImGuiTreeNodeStackData); cdecl;
  igNavMoveRequestCancel: procedure(); cdecl;
  igNavMoveRequestApplyResult: procedure(); cdecl;
  igNavMoveRequestTryWrapping: procedure(window: PImGuiWindow; move_flags: ImGuiNavMoveFlags); cdecl;
  igNavHighlightActivated: procedure(id: ImGuiID); cdecl;
  igNavClearPreferredPosForAxis: procedure(axis: ImGuiAxis); cdecl;
  igSetNavCursorVisibleAfterMove: procedure(); cdecl;
  igNavUpdateCurrentWindowIsScrollPushableX: procedure(); cdecl;
  igSetNavWindow: procedure(window: PImGuiWindow); cdecl;
  igSetNavID: procedure(id: ImGuiID; nav_layer: ImGuiNavLayer; focus_scope_id: ImGuiID; rect_rel: ImRect); cdecl;
  igSetNavFocusScope: procedure(focus_scope_id: ImGuiID); cdecl;
  igFocusItem: procedure(); cdecl;
  igActivateItemByID: procedure(id: ImGuiID); cdecl;
  igIsNamedKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsNamedKeyOrMod: function(key: ImGuiKey): Boolean; cdecl;
  igIsLegacyKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsKeyboardKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsGamepadKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsMouseKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsAliasKey: function(key: ImGuiKey): Boolean; cdecl;
  igIsLRModKey: function(key: ImGuiKey): Boolean; cdecl;
  igFixupKeyChord: function(key_chord: ImGuiKeyChord): ImGuiKeyChord; cdecl;
  igConvertSingleModFlagToKey: function(key: ImGuiKey): ImGuiKey; cdecl;
  igGetKeyData_ContextPtr: function(ctx: PImGuiContext; key: ImGuiKey): PImGuiKeyData; cdecl;
  igGetKeyData_Key: function(key: ImGuiKey): PImGuiKeyData; cdecl;
  igGetKeyChordName: function(key_chord: ImGuiKeyChord): PUTF8Char; cdecl;
  igMouseButtonToKey: function(button: ImGuiMouseButton): ImGuiKey; cdecl;
  igIsMouseDragPastThreshold: function(button: ImGuiMouseButton; lock_threshold: Single): Boolean; cdecl;
  igGetKeyMagnitude2d: procedure(pOut: PImVec2; key_left: ImGuiKey; key_right: ImGuiKey; key_up: ImGuiKey; key_down: ImGuiKey); cdecl;
  igGetNavTweakPressedAmount: function(axis: ImGuiAxis): Single; cdecl;
  igCalcTypematicRepeatAmount: function(t0: Single; t1: Single; repeat_delay: Single; repeat_rate: Single): Integer; cdecl;
  igGetTypematicRepeatRate: procedure(flags: ImGuiInputFlags; repeat_delay: PSingle; repeat_rate: PSingle); cdecl;
  igTeleportMousePos: procedure(pos: ImVec2); cdecl;
  igSetActiveIdUsingAllKeyboardKeys: procedure(); cdecl;
  igIsActiveIdUsingNavDir: function(dir: ImGuiDir): Boolean; cdecl;
  igGetKeyOwner: function(key: ImGuiKey): ImGuiID; cdecl;
  igSetKeyOwner: procedure(key: ImGuiKey; owner_id: ImGuiID; flags: ImGuiInputFlags); cdecl;
  igSetKeyOwnersForKeyChord: procedure(key: ImGuiKeyChord; owner_id: ImGuiID; flags: ImGuiInputFlags); cdecl;
  igSetItemKeyOwner_InputFlags: procedure(key: ImGuiKey; flags: ImGuiInputFlags); cdecl;
  igTestKeyOwner: function(key: ImGuiKey; owner_id: ImGuiID): Boolean; cdecl;
  igGetKeyOwnerData: function(ctx: PImGuiContext; key: ImGuiKey): PImGuiKeyOwnerData; cdecl;
  igIsKeyDown_ID: function(key: ImGuiKey; owner_id: ImGuiID): Boolean; cdecl;
  igIsKeyPressed_InputFlags: function(key: ImGuiKey; flags: ImGuiInputFlags; owner_id: ImGuiID): Boolean; cdecl;
  igIsKeyReleased_ID: function(key: ImGuiKey; owner_id: ImGuiID): Boolean; cdecl;
  igIsKeyChordPressed_InputFlags: function(key_chord: ImGuiKeyChord; flags: ImGuiInputFlags; owner_id: ImGuiID): Boolean; cdecl;
  igIsMouseDown_ID: function(button: ImGuiMouseButton; owner_id: ImGuiID): Boolean; cdecl;
  igIsMouseClicked_InputFlags: function(button: ImGuiMouseButton; flags: ImGuiInputFlags; owner_id: ImGuiID): Boolean; cdecl;
  igIsMouseReleased_ID: function(button: ImGuiMouseButton; owner_id: ImGuiID): Boolean; cdecl;
  igIsMouseDoubleClicked_ID: function(button: ImGuiMouseButton; owner_id: ImGuiID): Boolean; cdecl;
  igShortcut_ID: function(key_chord: ImGuiKeyChord; flags: ImGuiInputFlags; owner_id: ImGuiID): Boolean; cdecl;
  igSetShortcutRouting: function(key_chord: ImGuiKeyChord; flags: ImGuiInputFlags; owner_id: ImGuiID): Boolean; cdecl;
  igTestShortcutRouting: function(key_chord: ImGuiKeyChord; owner_id: ImGuiID): Boolean; cdecl;
  igGetShortcutRoutingData: function(key_chord: ImGuiKeyChord): PImGuiKeyRoutingData; cdecl;
  igDockContextInitialize: procedure(ctx: PImGuiContext); cdecl;
  igDockContextShutdown: procedure(ctx: PImGuiContext); cdecl;
  igDockContextClearNodes: procedure(ctx: PImGuiContext; root_id: ImGuiID; clear_settings_refs: Boolean); cdecl;
  igDockContextRebuildNodes: procedure(ctx: PImGuiContext); cdecl;
  igDockContextNewFrameUpdateUndocking: procedure(ctx: PImGuiContext); cdecl;
  igDockContextNewFrameUpdateDocking: procedure(ctx: PImGuiContext); cdecl;
  igDockContextEndFrame: procedure(ctx: PImGuiContext); cdecl;
  igDockContextGenNodeID: function(ctx: PImGuiContext): ImGuiID; cdecl;
  igDockContextQueueDock: procedure(ctx: PImGuiContext; target: PImGuiWindow; target_node: PImGuiDockNode; payload: PImGuiWindow; split_dir: ImGuiDir; split_ratio: Single; split_outer: Boolean); cdecl;
  igDockContextQueueUndockWindow: procedure(ctx: PImGuiContext; window: PImGuiWindow); cdecl;
  igDockContextQueueUndockNode: procedure(ctx: PImGuiContext; node: PImGuiDockNode); cdecl;
  igDockContextProcessUndockWindow: procedure(ctx: PImGuiContext; window: PImGuiWindow; clear_persistent_docking_ref: Boolean); cdecl;
  igDockContextProcessUndockNode: procedure(ctx: PImGuiContext; node: PImGuiDockNode); cdecl;
  igDockContextCalcDropPosForDocking: function(target: PImGuiWindow; target_node: PImGuiDockNode; payload_window: PImGuiWindow; payload_node: PImGuiDockNode; split_dir: ImGuiDir; split_outer: Boolean; out_pos: PImVec2): Boolean; cdecl;
  igDockContextFindNodeByID: function(ctx: PImGuiContext; id: ImGuiID): PImGuiDockNode; cdecl;
  igDockNodeWindowMenuHandler_Default: procedure(ctx: PImGuiContext; node: PImGuiDockNode; tab_bar: PImGuiTabBar); cdecl;
  igDockNodeBeginAmendTabBar: function(node: PImGuiDockNode): Boolean; cdecl;
  igDockNodeEndAmendTabBar: procedure(); cdecl;
  igDockNodeGetRootNode: function(node: PImGuiDockNode): PImGuiDockNode; cdecl;
  igDockNodeIsInHierarchyOf: function(node: PImGuiDockNode; parent: PImGuiDockNode): Boolean; cdecl;
  igDockNodeGetDepth: function(const node: PImGuiDockNode): Integer; cdecl;
  igDockNodeGetWindowMenuButtonId: function(const node: PImGuiDockNode): ImGuiID; cdecl;
  igGetWindowDockNode: function(): PImGuiDockNode; cdecl;
  igGetWindowAlwaysWantOwnTabBar: function(window: PImGuiWindow): Boolean; cdecl;
  igBeginDocked: procedure(window: PImGuiWindow; p_open: PBoolean); cdecl;
  igBeginDockableDragDropSource: procedure(window: PImGuiWindow); cdecl;
  igBeginDockableDragDropTarget: procedure(window: PImGuiWindow); cdecl;
  igSetWindowDock: procedure(window: PImGuiWindow; dock_id: ImGuiID; cond: ImGuiCond); cdecl;
  igDockBuilderDockWindow: procedure(const window_name: PUTF8Char; node_id: ImGuiID); cdecl;
  igDockBuilderGetNode: function(node_id: ImGuiID): PImGuiDockNode; cdecl;
  igDockBuilderGetCentralNode: function(node_id: ImGuiID): PImGuiDockNode; cdecl;
  igDockBuilderAddNode: function(node_id: ImGuiID; flags: ImGuiDockNodeFlags): ImGuiID; cdecl;
  igDockBuilderRemoveNode: procedure(node_id: ImGuiID); cdecl;
  igDockBuilderRemoveNodeDockedWindows: procedure(node_id: ImGuiID; clear_settings_refs: Boolean); cdecl;
  igDockBuilderRemoveNodeChildNodes: procedure(node_id: ImGuiID); cdecl;
  igDockBuilderSetNodePos: procedure(node_id: ImGuiID; pos: ImVec2); cdecl;
  igDockBuilderSetNodeSize: procedure(node_id: ImGuiID; size: ImVec2); cdecl;
  igDockBuilderSplitNode: function(node_id: ImGuiID; split_dir: ImGuiDir; size_ratio_for_node_at_dir: Single; out_id_at_dir: PImGuiID; out_id_at_opposite_dir: PImGuiID): ImGuiID; cdecl;
  igDockBuilderCopyDockSpace: procedure(src_dockspace_id: ImGuiID; dst_dockspace_id: ImGuiID; in_window_remap_pairs: PImVector_const_charPtr); cdecl;
  igDockBuilderCopyNode: procedure(src_node_id: ImGuiID; dst_node_id: ImGuiID; out_node_remap_pairs: PImVector_ImGuiID); cdecl;
  igDockBuilderCopyWindowSettings: procedure(const src_name: PUTF8Char; const dst_name: PUTF8Char); cdecl;
  igDockBuilderFinish: procedure(node_id: ImGuiID); cdecl;
  igPushFocusScope: procedure(id: ImGuiID); cdecl;
  igPopFocusScope: procedure(); cdecl;
  igGetCurrentFocusScope: function(): ImGuiID; cdecl;
  igIsDragDropActive: function(): Boolean; cdecl;
  igBeginDragDropTargetCustom: function(bb: ImRect; id: ImGuiID): Boolean; cdecl;
  igClearDragDrop: procedure(); cdecl;
  igIsDragDropPayloadBeingAccepted: function(): Boolean; cdecl;
  igRenderDragDropTargetRect: procedure(bb: ImRect; item_clip_rect: ImRect); cdecl;
  igGetTypingSelectRequest: function(flags: ImGuiTypingSelectFlags): PImGuiTypingSelectRequest; cdecl;
  igTypingSelectFindMatch: function(req: PImGuiTypingSelectRequest; items_count: Integer; get_item_name_func: igTypingSelectFindMatch_get_item_name_func; user_data: Pointer; nav_item_idx: Integer): Integer; cdecl;
  igTypingSelectFindNextSingleCharMatch: function(req: PImGuiTypingSelectRequest; items_count: Integer; get_item_name_func: igTypingSelectFindNextSingleCharMatch_get_item_name_func; user_data: Pointer; nav_item_idx: Integer): Integer; cdecl;
  igTypingSelectFindBestLeadingMatch: function(req: PImGuiTypingSelectRequest; items_count: Integer; get_item_name_func: igTypingSelectFindBestLeadingMatch_get_item_name_func; user_data: Pointer): Integer; cdecl;
  igBeginBoxSelect: function(scope_rect: ImRect; window: PImGuiWindow; box_select_id: ImGuiID; ms_flags: ImGuiMultiSelectFlags): Boolean; cdecl;
  igEndBoxSelect: procedure(scope_rect: ImRect; ms_flags: ImGuiMultiSelectFlags); cdecl;
  igMultiSelectItemHeader: procedure(id: ImGuiID; p_selected: PBoolean; p_button_flags: PImGuiButtonFlags); cdecl;
  igMultiSelectItemFooter: procedure(id: ImGuiID; p_selected: PBoolean; p_pressed: PBoolean); cdecl;
  igMultiSelectAddSetAll: procedure(ms: PImGuiMultiSelectTempData; selected: Boolean); cdecl;
  igMultiSelectAddSetRange: procedure(ms: PImGuiMultiSelectTempData; selected: Boolean; range_dir: Integer; first_item: ImGuiSelectionUserData; last_item: ImGuiSelectionUserData); cdecl;
  igGetBoxSelectState: function(id: ImGuiID): PImGuiBoxSelectState; cdecl;
  igGetMultiSelectState: function(id: ImGuiID): PImGuiMultiSelectState; cdecl;
  igSetWindowClipRectBeforeSetChannel: procedure(window: PImGuiWindow; clip_rect: ImRect); cdecl;
  igBeginColumns: procedure(const str_id: PUTF8Char; count: Integer; flags: ImGuiOldColumnFlags); cdecl;
  igEndColumns: procedure(); cdecl;
  igPushColumnClipRect: procedure(column_index: Integer); cdecl;
  igPushColumnsBackground: procedure(); cdecl;
  igPopColumnsBackground: procedure(); cdecl;
  igGetColumnsID: function(const str_id: PUTF8Char; count: Integer): ImGuiID; cdecl;
  igFindOrCreateColumns: function(window: PImGuiWindow; id: ImGuiID): PImGuiOldColumns; cdecl;
  igGetColumnOffsetFromNorm: function(const columns: PImGuiOldColumns; offset_norm: Single): Single; cdecl;
  igGetColumnNormFromOffset: function(const columns: PImGuiOldColumns; offset: Single): Single; cdecl;
  igTableOpenContextMenu: procedure(column_n: Integer); cdecl;
  igTableSetColumnWidth: procedure(column_n: Integer; width: Single); cdecl;
  igTableSetColumnSortDirection: procedure(column_n: Integer; sort_direction: ImGuiSortDirection; append_to_sort_specs: Boolean); cdecl;
  igTableGetHoveredRow: function(): Integer; cdecl;
  igTableGetHeaderRowHeight: function(): Single; cdecl;
  igTableGetHeaderAngledMaxLabelWidth: function(): Single; cdecl;
  igTablePushBackgroundChannel: procedure(); cdecl;
  igTablePopBackgroundChannel: procedure(); cdecl;
  igTableAngledHeadersRowEx: procedure(row_id: ImGuiID; angle: Single; max_label_width: Single; const data: PImGuiTableHeaderData; data_count: Integer); cdecl;
  igGetCurrentTable: function(): PImGuiTable; cdecl;
  igTableFindByID: function(id: ImGuiID): PImGuiTable; cdecl;
  igBeginTableEx: function(const name: PUTF8Char; id: ImGuiID; columns_count: Integer; flags: ImGuiTableFlags; outer_size: ImVec2; inner_width: Single): Boolean; cdecl;
  igTableBeginInitMemory: procedure(table: PImGuiTable; columns_count: Integer); cdecl;
  igTableBeginApplyRequests: procedure(table: PImGuiTable); cdecl;
  igTableSetupDrawChannels: procedure(table: PImGuiTable); cdecl;
  igTableUpdateLayout: procedure(table: PImGuiTable); cdecl;
  igTableUpdateBorders: procedure(table: PImGuiTable); cdecl;
  igTableUpdateColumnsWeightFromWidth: procedure(table: PImGuiTable); cdecl;
  igTableDrawBorders: procedure(table: PImGuiTable); cdecl;
  igTableDrawDefaultContextMenu: procedure(table: PImGuiTable; flags_for_section_to_display: ImGuiTableFlags); cdecl;
  igTableBeginContextMenuPopup: function(table: PImGuiTable): Boolean; cdecl;
  igTableMergeDrawChannels: procedure(table: PImGuiTable); cdecl;
  igTableGetInstanceData: function(table: PImGuiTable; instance_no: Integer): PImGuiTableInstanceData; cdecl;
  igTableGetInstanceID: function(table: PImGuiTable; instance_no: Integer): ImGuiID; cdecl;
  igTableSortSpecsSanitize: procedure(table: PImGuiTable); cdecl;
  igTableSortSpecsBuild: procedure(table: PImGuiTable); cdecl;
  igTableGetColumnNextSortDirection: function(column: PImGuiTableColumn): ImGuiSortDirection; cdecl;
  igTableFixColumnSortDirection: procedure(table: PImGuiTable; column: PImGuiTableColumn); cdecl;
  igTableGetColumnWidthAuto: function(table: PImGuiTable; column: PImGuiTableColumn): Single; cdecl;
  igTableBeginRow: procedure(table: PImGuiTable); cdecl;
  igTableEndRow: procedure(table: PImGuiTable); cdecl;
  igTableBeginCell: procedure(table: PImGuiTable; column_n: Integer); cdecl;
  igTableEndCell: procedure(table: PImGuiTable); cdecl;
  igTableGetCellBgRect: procedure(pOut: PImRect; const table: PImGuiTable; column_n: Integer); cdecl;
  igTableGetColumnName_TablePtr: function(const table: PImGuiTable; column_n: Integer): PUTF8Char; cdecl;
  igTableGetColumnResizeID: function(table: PImGuiTable; column_n: Integer; instance_no: Integer): ImGuiID; cdecl;
  igTableCalcMaxColumnWidth: function(const table: PImGuiTable; column_n: Integer): Single; cdecl;
  igTableSetColumnWidthAutoSingle: procedure(table: PImGuiTable; column_n: Integer); cdecl;
  igTableSetColumnWidthAutoAll: procedure(table: PImGuiTable); cdecl;
  igTableRemove: procedure(table: PImGuiTable); cdecl;
  igTableGcCompactTransientBuffers_TablePtr: procedure(table: PImGuiTable); cdecl;
  igTableGcCompactTransientBuffers_TableTempDataPtr: procedure(table: PImGuiTableTempData); cdecl;
  igTableGcCompactSettings: procedure(); cdecl;
  igTableLoadSettings: procedure(table: PImGuiTable); cdecl;
  igTableSaveSettings: procedure(table: PImGuiTable); cdecl;
  igTableResetSettings: procedure(table: PImGuiTable); cdecl;
  igTableGetBoundSettings: function(table: PImGuiTable): PImGuiTableSettings; cdecl;
  igTableSettingsAddSettingsHandler: procedure(); cdecl;
  igTableSettingsCreate: function(id: ImGuiID; columns_count: Integer): PImGuiTableSettings; cdecl;
  igTableSettingsFindByID: function(id: ImGuiID): PImGuiTableSettings; cdecl;
  igGetCurrentTabBar: function(): PImGuiTabBar; cdecl;
  igBeginTabBarEx: function(tab_bar: PImGuiTabBar; bb: ImRect; flags: ImGuiTabBarFlags): Boolean; cdecl;
  igTabBarFindTabByID: function(tab_bar: PImGuiTabBar; tab_id: ImGuiID): PImGuiTabItem; cdecl;
  igTabBarFindTabByOrder: function(tab_bar: PImGuiTabBar; order: Integer): PImGuiTabItem; cdecl;
  igTabBarFindMostRecentlySelectedTabForActiveWindow: function(tab_bar: PImGuiTabBar): PImGuiTabItem; cdecl;
  igTabBarGetCurrentTab: function(tab_bar: PImGuiTabBar): PImGuiTabItem; cdecl;
  igTabBarGetTabOrder: function(tab_bar: PImGuiTabBar; tab: PImGuiTabItem): Integer; cdecl;
  igTabBarGetTabName: function(tab_bar: PImGuiTabBar; tab: PImGuiTabItem): PUTF8Char; cdecl;
  igTabBarAddTab: procedure(tab_bar: PImGuiTabBar; tab_flags: ImGuiTabItemFlags; window: PImGuiWindow); cdecl;
  igTabBarRemoveTab: procedure(tab_bar: PImGuiTabBar; tab_id: ImGuiID); cdecl;
  igTabBarCloseTab: procedure(tab_bar: PImGuiTabBar; tab: PImGuiTabItem); cdecl;
  igTabBarQueueFocus_TabItemPtr: procedure(tab_bar: PImGuiTabBar; tab: PImGuiTabItem); cdecl;
  igTabBarQueueFocus_Str: procedure(tab_bar: PImGuiTabBar; const tab_name: PUTF8Char); cdecl;
  igTabBarQueueReorder: procedure(tab_bar: PImGuiTabBar; tab: PImGuiTabItem; offset: Integer); cdecl;
  igTabBarQueueReorderFromMousePos: procedure(tab_bar: PImGuiTabBar; tab: PImGuiTabItem; mouse_pos: ImVec2); cdecl;
  igTabBarProcessReorder: function(tab_bar: PImGuiTabBar): Boolean; cdecl;
  igTabItemEx: function(tab_bar: PImGuiTabBar; const &label: PUTF8Char; p_open: PBoolean; flags: ImGuiTabItemFlags; docked_window: PImGuiWindow): Boolean; cdecl;
  igTabItemSpacing: procedure(const str_id: PUTF8Char; flags: ImGuiTabItemFlags; width: Single); cdecl;
  igTabItemCalcSize_Str: procedure(pOut: PImVec2; const &label: PUTF8Char; has_close_button_or_unsaved_marker: Boolean); cdecl;
  igTabItemCalcSize_WindowPtr: procedure(pOut: PImVec2; window: PImGuiWindow); cdecl;
  igTabItemBackground: procedure(draw_list: PImDrawList; bb: ImRect; flags: ImGuiTabItemFlags; col: ImU32); cdecl;
  igTabItemLabelAndCloseButton: procedure(draw_list: PImDrawList; bb: ImRect; flags: ImGuiTabItemFlags; frame_padding: ImVec2; const &label: PUTF8Char; tab_id: ImGuiID; close_button_id: ImGuiID; is_contents_visible: Boolean; out_just_closed: PBoolean; out_text_clipped: PBoolean); cdecl;
  igRenderText: procedure(pos: ImVec2; const text: PUTF8Char; const text_end: PUTF8Char; hide_text_after_hash: Boolean); cdecl;
  igRenderTextWrapped: procedure(pos: ImVec2; const text: PUTF8Char; const text_end: PUTF8Char; wrap_width: Single); cdecl;
  igRenderTextClipped: procedure(pos_min: ImVec2; pos_max: ImVec2; const text: PUTF8Char; const text_end: PUTF8Char; const text_size_if_known: PImVec2; align: ImVec2; const clip_rect: PImRect); cdecl;
  igRenderTextClippedEx: procedure(draw_list: PImDrawList; pos_min: ImVec2; pos_max: ImVec2; const text: PUTF8Char; const text_end: PUTF8Char; const text_size_if_known: PImVec2; align: ImVec2; const clip_rect: PImRect); cdecl;
  igRenderTextEllipsis: procedure(draw_list: PImDrawList; pos_min: ImVec2; pos_max: ImVec2; clip_max_x: Single; ellipsis_max_x: Single; const text: PUTF8Char; const text_end: PUTF8Char; const text_size_if_known: PImVec2); cdecl;
  igRenderFrame: procedure(p_min: ImVec2; p_max: ImVec2; fill_col: ImU32; borders: Boolean; rounding: Single); cdecl;
  igRenderFrameBorder: procedure(p_min: ImVec2; p_max: ImVec2; rounding: Single); cdecl;
  igRenderColorRectWithAlphaCheckerboard: procedure(draw_list: PImDrawList; p_min: ImVec2; p_max: ImVec2; fill_col: ImU32; grid_step: Single; grid_off: ImVec2; rounding: Single; flags: ImDrawFlags); cdecl;
  igRenderNavCursor: procedure(bb: ImRect; id: ImGuiID; flags: ImGuiNavRenderCursorFlags); cdecl;
  igFindRenderedTextEnd: function(const text: PUTF8Char; const text_end: PUTF8Char): PUTF8Char; cdecl;
  igRenderMouseCursor: procedure(pos: ImVec2; scale: Single; mouse_cursor: ImGuiMouseCursor; col_fill: ImU32; col_border: ImU32; col_shadow: ImU32); cdecl;
  igRenderArrow: procedure(draw_list: PImDrawList; pos: ImVec2; col: ImU32; dir: ImGuiDir; scale: Single); cdecl;
  igRenderBullet: procedure(draw_list: PImDrawList; pos: ImVec2; col: ImU32); cdecl;
  igRenderCheckMark: procedure(draw_list: PImDrawList; pos: ImVec2; col: ImU32; sz: Single); cdecl;
  igRenderArrowPointingAt: procedure(draw_list: PImDrawList; pos: ImVec2; half_sz: ImVec2; direction: ImGuiDir; col: ImU32); cdecl;
  igRenderArrowDockMenu: procedure(draw_list: PImDrawList; p_min: ImVec2; sz: Single; col: ImU32); cdecl;
  igRenderRectFilledRangeH: procedure(draw_list: PImDrawList; rect: ImRect; col: ImU32; x_start_norm: Single; x_end_norm: Single; rounding: Single); cdecl;
  igRenderRectFilledWithHole: procedure(draw_list: PImDrawList; outer: ImRect; inner: ImRect; col: ImU32; rounding: Single); cdecl;
  igCalcRoundingFlagsForRectInRect: function(r_in: ImRect; r_outer: ImRect; threshold: Single): ImDrawFlags; cdecl;
  igTextEx: procedure(const text: PUTF8Char; const text_end: PUTF8Char; flags: ImGuiTextFlags); cdecl;
  igButtonEx: function(const &label: PUTF8Char; size_arg: ImVec2; flags: ImGuiButtonFlags): Boolean; cdecl;
  igArrowButtonEx: function(const str_id: PUTF8Char; dir: ImGuiDir; size_arg: ImVec2; flags: ImGuiButtonFlags): Boolean; cdecl;
  igImageButtonEx: function(id: ImGuiID; user_texture_id: ImTextureID; image_size: ImVec2; uv0: ImVec2; uv1: ImVec2; bg_col: ImVec4; tint_col: ImVec4; flags: ImGuiButtonFlags): Boolean; cdecl;
  igSeparatorEx: procedure(flags: ImGuiSeparatorFlags; thickness: Single); cdecl;
  igSeparatorTextEx: procedure(id: ImGuiID; const &label: PUTF8Char; const label_end: PUTF8Char; extra_width: Single); cdecl;
  igCheckboxFlags_S64Ptr: function(const &label: PUTF8Char; flags: PImS64; flags_value: ImS64): Boolean; cdecl;
  igCheckboxFlags_U64Ptr: function(const &label: PUTF8Char; flags: PImU64; flags_value: ImU64): Boolean; cdecl;
  igCloseButton: function(id: ImGuiID; pos: ImVec2): Boolean; cdecl;
  igCollapseButton: function(id: ImGuiID; pos: ImVec2; dock_node: PImGuiDockNode): Boolean; cdecl;
  igScrollbar: procedure(axis: ImGuiAxis); cdecl;
  igScrollbarEx: function(bb: ImRect; id: ImGuiID; axis: ImGuiAxis; p_scroll_v: PImS64; avail_v: ImS64; contents_v: ImS64; draw_rounding_flags: ImDrawFlags): Boolean; cdecl;
  igGetWindowScrollbarRect: procedure(pOut: PImRect; window: PImGuiWindow; axis: ImGuiAxis); cdecl;
  igGetWindowScrollbarID: function(window: PImGuiWindow; axis: ImGuiAxis): ImGuiID; cdecl;
  igGetWindowResizeCornerID: function(window: PImGuiWindow; n: Integer): ImGuiID; cdecl;
  igGetWindowResizeBorderID: function(window: PImGuiWindow; dir: ImGuiDir): ImGuiID; cdecl;
  igButtonBehavior: function(bb: ImRect; id: ImGuiID; out_hovered: PBoolean; out_held: PBoolean; flags: ImGuiButtonFlags): Boolean; cdecl;
  igDragBehavior: function(id: ImGuiID; data_type: ImGuiDataType; p_v: Pointer; v_speed: Single; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags): Boolean; cdecl;
  igSliderBehavior: function(bb: ImRect; id: ImGuiID; data_type: ImGuiDataType; p_v: Pointer; const p_min: Pointer; const p_max: Pointer; const format: PUTF8Char; flags: ImGuiSliderFlags; out_grab_bb: PImRect): Boolean; cdecl;
  igSplitterBehavior: function(bb: ImRect; id: ImGuiID; axis: ImGuiAxis; size1: PSingle; size2: PSingle; min_size1: Single; min_size2: Single; hover_extend: Single; hover_visibility_delay: Single; bg_col: ImU32): Boolean; cdecl;
  igTreeNodeBehavior: function(id: ImGuiID; flags: ImGuiTreeNodeFlags; const &label: PUTF8Char; const label_end: PUTF8Char): Boolean; cdecl;
  igTreePushOverrideID: procedure(id: ImGuiID); cdecl;
  igTreeNodeGetOpen: function(storage_id: ImGuiID): Boolean; cdecl;
  igTreeNodeSetOpen: procedure(storage_id: ImGuiID; open: Boolean); cdecl;
  igTreeNodeUpdateNextOpen: function(storage_id: ImGuiID; flags: ImGuiTreeNodeFlags): Boolean; cdecl;
  igDataTypeGetInfo: function(data_type: ImGuiDataType): PImGuiDataTypeInfo; cdecl;
  igDataTypeFormatString: function(buf: PUTF8Char; buf_size: Integer; data_type: ImGuiDataType; const p_data: Pointer; const format: PUTF8Char): Integer; cdecl;
  igDataTypeApplyOp: procedure(data_type: ImGuiDataType; op: Integer; output: Pointer; const arg_1: Pointer; const arg_2: Pointer); cdecl;
  igDataTypeApplyFromText: function(const buf: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; const format: PUTF8Char; p_data_when_empty: Pointer): Boolean; cdecl;
  igDataTypeCompare: function(data_type: ImGuiDataType; const arg_1: Pointer; const arg_2: Pointer): Integer; cdecl;
  igDataTypeClamp: function(data_type: ImGuiDataType; p_data: Pointer; const p_min: Pointer; const p_max: Pointer): Boolean; cdecl;
  igDataTypeIsZero: function(data_type: ImGuiDataType; const p_data: Pointer): Boolean; cdecl;
  igInputTextEx: function(const &label: PUTF8Char; const hint: PUTF8Char; buf: PUTF8Char; buf_size: Integer; size_arg: ImVec2; flags: ImGuiInputTextFlags; callback: ImGuiInputTextCallback; user_data: Pointer): Boolean; cdecl;
  igInputTextDeactivateHook: procedure(id: ImGuiID); cdecl;
  igTempInputText: function(bb: ImRect; id: ImGuiID; const &label: PUTF8Char; buf: PUTF8Char; buf_size: Integer; flags: ImGuiInputTextFlags): Boolean; cdecl;
  igTempInputScalar: function(bb: ImRect; id: ImGuiID; const &label: PUTF8Char; data_type: ImGuiDataType; p_data: Pointer; const format: PUTF8Char; const p_clamp_min: Pointer; const p_clamp_max: Pointer): Boolean; cdecl;
  igTempInputIsActive: function(id: ImGuiID): Boolean; cdecl;
  igGetInputTextState: function(id: ImGuiID): PImGuiInputTextState; cdecl;
  igSetNextItemRefVal: procedure(data_type: ImGuiDataType; p_data: Pointer); cdecl;
  igIsItemActiveAsInputText: function(): Boolean; cdecl;
  igColorTooltip: procedure(const text: PUTF8Char; const col: PSingle; flags: ImGuiColorEditFlags); cdecl;
  igColorEditOptionsPopup: procedure(const col: PSingle; flags: ImGuiColorEditFlags); cdecl;
  igColorPickerOptionsPopup: procedure(const ref_col: PSingle; flags: ImGuiColorEditFlags); cdecl;
  igPlotEx: function(plot_type: ImGuiPlotType; const &label: PUTF8Char; values_getter: igPlotEx_values_getter; data: Pointer; values_count: Integer; values_offset: Integer; const overlay_text: PUTF8Char; scale_min: Single; scale_max: Single; size_arg: ImVec2): Integer; cdecl;
  igShadeVertsLinearColorGradientKeepAlpha: procedure(draw_list: PImDrawList; vert_start_idx: Integer; vert_end_idx: Integer; gradient_p0: ImVec2; gradient_p1: ImVec2; col0: ImU32; col1: ImU32); cdecl;
  igShadeVertsLinearUV: procedure(draw_list: PImDrawList; vert_start_idx: Integer; vert_end_idx: Integer; a: ImVec2; b: ImVec2; uv_a: ImVec2; uv_b: ImVec2; clamp: Boolean); cdecl;
  igShadeVertsTransformPos: procedure(draw_list: PImDrawList; vert_start_idx: Integer; vert_end_idx: Integer; pivot_in: ImVec2; cos_a: Single; sin_a: Single; pivot_out: ImVec2); cdecl;
  igGcCompactTransientMiscBuffers: procedure(); cdecl;
  igGcCompactTransientWindowBuffers: procedure(window: PImGuiWindow); cdecl;
  igGcAwakeTransientWindowBuffers: procedure(window: PImGuiWindow); cdecl;
  igErrorLog: function(const msg: PUTF8Char): Boolean; cdecl;
  igErrorRecoveryStoreState: procedure(state_out: PImGuiErrorRecoveryState); cdecl;
  igErrorRecoveryTryToRecoverState: procedure(const state_in: PImGuiErrorRecoveryState); cdecl;
  igErrorRecoveryTryToRecoverWindowState: procedure(const state_in: PImGuiErrorRecoveryState); cdecl;
  igErrorCheckUsingSetCursorPosToExtendParentBoundaries: procedure(); cdecl;
  igErrorCheckEndFrameFinalizeErrorTooltip: procedure(); cdecl;
  igBeginErrorTooltip: function(): Boolean; cdecl;
  igEndErrorTooltip: procedure(); cdecl;
  igDebugAllocHook: procedure(info: PImGuiDebugAllocInfo; frame_count: Integer; ptr: Pointer; size: NativeUInt); cdecl;
  igDebugDrawCursorPos: procedure(col: ImU32); cdecl;
  igDebugDrawLineExtents: procedure(col: ImU32); cdecl;
  igDebugDrawItemRect: procedure(col: ImU32); cdecl;
  igDebugTextUnformattedWithLocateItem: procedure(const line_begin: PUTF8Char; const line_end: PUTF8Char); cdecl;
  igDebugLocateItem: procedure(target_id: ImGuiID); cdecl;
  igDebugLocateItemOnHover: procedure(target_id: ImGuiID); cdecl;
  igDebugLocateItemResolveWithLastItem: procedure(); cdecl;
  igDebugBreakClearData: procedure(); cdecl;
  igDebugBreakButton: function(const &label: PUTF8Char; const description_of_location: PUTF8Char): Boolean; cdecl;
  igDebugBreakButtonTooltip: procedure(keyboard_only: Boolean; const description_of_location: PUTF8Char); cdecl;
  igShowFontAtlas: procedure(atlas: PImFontAtlas); cdecl;
  igDebugHookIdInfo: procedure(id: ImGuiID; data_type: ImGuiDataType; const data_id: Pointer; const data_id_end: Pointer); cdecl;
  igDebugNodeColumns: procedure(columns: PImGuiOldColumns); cdecl;
  igDebugNodeDockNode: procedure(node: PImGuiDockNode; const &label: PUTF8Char); cdecl;
  igDebugNodeDrawList: procedure(window: PImGuiWindow; viewport: PImGuiViewportP; const draw_list: PImDrawList; const &label: PUTF8Char); cdecl;
  igDebugNodeDrawCmdShowMeshAndBoundingBox: procedure(out_draw_list: PImDrawList; const draw_list: PImDrawList; const draw_cmd: PImDrawCmd; show_mesh: Boolean; show_aabb: Boolean); cdecl;
  igDebugNodeFont: procedure(font: PImFont); cdecl;
  igDebugNodeFontGlyph: procedure(font: PImFont; const glyph: PImFontGlyph); cdecl;
  igDebugNodeStorage: procedure(storage: PImGuiStorage; const &label: PUTF8Char); cdecl;
  igDebugNodeTabBar: procedure(tab_bar: PImGuiTabBar; const &label: PUTF8Char); cdecl;
  igDebugNodeTable: procedure(table: PImGuiTable); cdecl;
  igDebugNodeTableSettings: procedure(settings: PImGuiTableSettings); cdecl;
  igDebugNodeInputTextState: procedure(state: PImGuiInputTextState); cdecl;
  igDebugNodeTypingSelectState: procedure(state: PImGuiTypingSelectState); cdecl;
  igDebugNodeMultiSelectState: procedure(state: PImGuiMultiSelectState); cdecl;
  igDebugNodeWindow: procedure(window: PImGuiWindow; const &label: PUTF8Char); cdecl;
  igDebugNodeWindowSettings: procedure(settings: PImGuiWindowSettings); cdecl;
  igDebugNodeWindowsList: procedure(windows: PImVector_ImGuiWindowPtr; const &label: PUTF8Char); cdecl;
  igDebugNodeWindowsListByBeginStackParent: procedure(windows: PPImGuiWindow; windows_size: Integer; parent_in_begin_stack: PImGuiWindow); cdecl;
  igDebugNodeViewport: procedure(viewport: PImGuiViewportP); cdecl;
  igDebugNodePlatformMonitor: procedure(monitor: PImGuiPlatformMonitor; const &label: PUTF8Char; idx: Integer); cdecl;
  igDebugRenderKeyboardPreview: procedure(draw_list: PImDrawList); cdecl;
  igDebugRenderViewportThumbnail: procedure(draw_list: PImDrawList; viewport: PImGuiViewportP; bb: ImRect); cdecl;
  igImFontAtlasGetBuilderForStbTruetype: function(): PImFontBuilderIO; cdecl;
  igImFontAtlasUpdateSourcesPointers: procedure(atlas: PImFontAtlas); cdecl;
  igImFontAtlasBuildInit: procedure(atlas: PImFontAtlas); cdecl;
  igImFontAtlasBuildSetupFont: procedure(atlas: PImFontAtlas; font: PImFont; src: PImFontConfig; ascent: Single; descent: Single); cdecl;
  igImFontAtlasBuildPackCustomRects: procedure(atlas: PImFontAtlas; stbrp_context_opaque: Pointer); cdecl;
  igImFontAtlasBuildFinish: procedure(atlas: PImFontAtlas); cdecl;
  igImFontAtlasBuildRender8bppRectFromString: procedure(atlas: PImFontAtlas; x: Integer; y: Integer; w: Integer; h: Integer; const in_str: PUTF8Char; in_marker_char: UTF8Char; in_marker_pixel_value: Byte); cdecl;
  igImFontAtlasBuildRender32bppRectFromString: procedure(atlas: PImFontAtlas; x: Integer; y: Integer; w: Integer; h: Integer; const in_str: PUTF8Char; in_marker_char: UTF8Char; in_marker_pixel_value: Cardinal); cdecl;
  igImFontAtlasBuildMultiplyCalcLookupTable: procedure(out_table: PByte; in_multiply_factor: Single); cdecl;
  igImFontAtlasBuildMultiplyRectAlpha8: procedure(table: PByte; pixels: PByte; x: Integer; y: Integer; w: Integer; h: Integer; stride: Integer); cdecl;
  igImFontAtlasBuildGetOversampleFactors: procedure(const src: PImFontConfig; out_oversample_h: PInteger; out_oversample_v: PInteger); cdecl;
  igImFontAtlasGetMouseCursorTexData: function(atlas: PImFontAtlas; cursor_type: ImGuiMouseCursor; out_offset: PImVec2; out_size: PImVec2; out_uv_border: PImVec2; out_uv_fill: PImVec2): Boolean; cdecl;
  ImGuiTextBuffer_appendf: procedure(self: PImGuiTextBuffer; const fmt: PUTF8Char) varargs; cdecl;
  igGET_FLT_MAX: function(): Single; cdecl;
  igGET_FLT_MIN: function(): Single; cdecl;
  ImVector_ImWchar_create: function(): PImVector_ImWchar; cdecl;
  ImVector_ImWchar_destroy: procedure(self: PImVector_ImWchar); cdecl;
  ImVector_ImWchar_Init: procedure(p: PImVector_ImWchar); cdecl;
  ImVector_ImWchar_UnInit: procedure(p: PImVector_ImWchar); cdecl;
  ImGuiPlatformIO_Set_Platform_GetWindowPos: procedure(platform_io: PImGuiPlatformIO; user_callback: ImGuiPlatformIO_Set_Platform_GetWindowPos_user_callback); cdecl;
  ImGuiPlatformIO_Set_Platform_GetWindowSize: procedure(platform_io: PImGuiPlatformIO; user_callback: ImGuiPlatformIO_Set_Platform_GetWindowSize_user_callback); cdecl;
  ImGui_ImplGlfw_InitForOpenGL: function(window: PGLFWwindow; install_callbacks: Boolean): Boolean; cdecl;
  ImGui_ImplGlfw_InitForVulkan: function(window: PGLFWwindow; install_callbacks: Boolean): Boolean; cdecl;
  ImGui_ImplGlfw_InitForOther: function(window: PGLFWwindow; install_callbacks: Boolean): Boolean; cdecl;
  ImGui_ImplGlfw_Shutdown: procedure(); cdecl;
  ImGui_ImplGlfw_NewFrame: procedure(); cdecl;
  ImGui_ImplGlfw_InstallCallbacks: procedure(window: PGLFWwindow); cdecl;
  ImGui_ImplGlfw_RestoreCallbacks: procedure(window: PGLFWwindow); cdecl;
  ImGui_ImplGlfw_SetCallbacksChainForAllWindows: procedure(chain_for_all_windows: Boolean); cdecl;
  ImGui_ImplGlfw_WindowFocusCallback: procedure(window: PGLFWwindow; focused: Integer); cdecl;
  ImGui_ImplGlfw_CursorEnterCallback: procedure(window: PGLFWwindow; entered: Integer); cdecl;
  ImGui_ImplGlfw_CursorPosCallback: procedure(window: PGLFWwindow; x: Double; y: Double); cdecl;
  ImGui_ImplGlfw_MouseButtonCallback: procedure(window: PGLFWwindow; button: Integer; action: Integer; mods: Integer); cdecl;
  ImGui_ImplGlfw_ScrollCallback: procedure(window: PGLFWwindow; xoffset: Double; yoffset: Double); cdecl;
  ImGui_ImplGlfw_KeyCallback: procedure(window: PGLFWwindow; key: Integer; scancode: Integer; action: Integer; mods: Integer); cdecl;
  ImGui_ImplGlfw_CharCallback: procedure(window: PGLFWwindow; c: Cardinal); cdecl;
  ImGui_ImplGlfw_MonitorCallback: procedure(monitor: PGLFWmonitor; event: Integer); cdecl;
  ImGui_ImplGlfw_Sleep: procedure(milliseconds: Integer); cdecl;
  ImGui_ImplOpenGL2_Init: function(): Boolean; cdecl;
  ImGui_ImplOpenGL2_Shutdown: procedure(); cdecl;
  ImGui_ImplOpenGL2_NewFrame: procedure(); cdecl;
  ImGui_ImplOpenGL2_RenderDrawData: procedure(draw_data: PImDrawData; virtual_width: Single; virtual_height: Single); cdecl;
  ImGui_ImplOpenGL2_CreateFontsTexture: function(): Boolean; cdecl;
  ImGui_ImplOpenGL2_DestroyFontsTexture: procedure(); cdecl;
  ImGui_ImplOpenGL2_CreateDeviceObjects: function(): Boolean; cdecl;
  ImGui_ImplOpenGL2_DestroyDeviceObjects: procedure(); cdecl;

procedure GetExports(const aDLLHandle: THandle);

implementation

uses
  System.IOUtils,
  Dlluminator;

procedure GetExports(const aDLLHandle: THandle);
begin
  if aDllHandle = 0 then Exit;
  c2AABBtoAABB := GetProcAddress(aDLLHandle, 'c2AABBtoAABB');
  c2AABBtoAABBManifold := GetProcAddress(aDLLHandle, 'c2AABBtoAABBManifold');
  c2AABBtoCapsule := GetProcAddress(aDLLHandle, 'c2AABBtoCapsule');
  c2AABBtoCapsuleManifold := GetProcAddress(aDLLHandle, 'c2AABBtoCapsuleManifold');
  c2AABBtoPoly := GetProcAddress(aDLLHandle, 'c2AABBtoPoly');
  c2AABBtoPolyManifold := GetProcAddress(aDLLHandle, 'c2AABBtoPolyManifold');
  c2CapsuletoCapsule := GetProcAddress(aDLLHandle, 'c2CapsuletoCapsule');
  c2CapsuletoCapsuleManifold := GetProcAddress(aDLLHandle, 'c2CapsuletoCapsuleManifold');
  c2CapsuletoPoly := GetProcAddress(aDLLHandle, 'c2CapsuletoPoly');
  c2CapsuletoPolyManifold := GetProcAddress(aDLLHandle, 'c2CapsuletoPolyManifold');
  c2CastRay := GetProcAddress(aDLLHandle, 'c2CastRay');
  c2CircletoAABB := GetProcAddress(aDLLHandle, 'c2CircletoAABB');
  c2CircletoAABBManifold := GetProcAddress(aDLLHandle, 'c2CircletoAABBManifold');
  c2CircletoCapsule := GetProcAddress(aDLLHandle, 'c2CircletoCapsule');
  c2CircletoCapsuleManifold := GetProcAddress(aDLLHandle, 'c2CircletoCapsuleManifold');
  c2CircletoCircle := GetProcAddress(aDLLHandle, 'c2CircletoCircle');
  c2CircletoCircleManifold := GetProcAddress(aDLLHandle, 'c2CircletoCircleManifold');
  c2CircletoPoly := GetProcAddress(aDLLHandle, 'c2CircletoPoly');
  c2CircletoPolyManifold := GetProcAddress(aDLLHandle, 'c2CircletoPolyManifold');
  c2Collide := GetProcAddress(aDLLHandle, 'c2Collide');
  c2Collided := GetProcAddress(aDLLHandle, 'c2Collided');
  c2GJK := GetProcAddress(aDLLHandle, 'c2GJK');
  c2Hull := GetProcAddress(aDLLHandle, 'c2Hull');
  c2Inflate := GetProcAddress(aDLLHandle, 'c2Inflate');
  c2MakePoly := GetProcAddress(aDLLHandle, 'c2MakePoly');
  c2Norms := GetProcAddress(aDLLHandle, 'c2Norms');
  c2PolytoPoly := GetProcAddress(aDLLHandle, 'c2PolytoPoly');
  c2PolytoPolyManifold := GetProcAddress(aDLLHandle, 'c2PolytoPolyManifold');
  c2RaytoAABB := GetProcAddress(aDLLHandle, 'c2RaytoAABB');
  c2RaytoCapsule := GetProcAddress(aDLLHandle, 'c2RaytoCapsule');
  c2RaytoCircle := GetProcAddress(aDLLHandle, 'c2RaytoCircle');
  c2RaytoPoly := GetProcAddress(aDLLHandle, 'c2RaytoPoly');
  c2TOI := GetProcAddress(aDLLHandle, 'c2TOI');
  crc32 := GetProcAddress(aDLLHandle, 'crc32');
  glfwCreateCursor := GetProcAddress(aDLLHandle, 'glfwCreateCursor');
  glfwCreateStandardCursor := GetProcAddress(aDLLHandle, 'glfwCreateStandardCursor');
  glfwCreateWindow := GetProcAddress(aDLLHandle, 'glfwCreateWindow');
  glfwDefaultWindowHints := GetProcAddress(aDLLHandle, 'glfwDefaultWindowHints');
  glfwDestroyCursor := GetProcAddress(aDLLHandle, 'glfwDestroyCursor');
  glfwDestroyWindow := GetProcAddress(aDLLHandle, 'glfwDestroyWindow');
  glfwExtensionSupported := GetProcAddress(aDLLHandle, 'glfwExtensionSupported');
  glfwFocusWindow := GetProcAddress(aDLLHandle, 'glfwFocusWindow');
  glfwGetClipboardString := GetProcAddress(aDLLHandle, 'glfwGetClipboardString');
  glfwGetCurrentContext := GetProcAddress(aDLLHandle, 'glfwGetCurrentContext');
  glfwGetCursorPos := GetProcAddress(aDLLHandle, 'glfwGetCursorPos');
  glfwGetError := GetProcAddress(aDLLHandle, 'glfwGetError');
  glfwGetFramebufferSize := GetProcAddress(aDLLHandle, 'glfwGetFramebufferSize');
  glfwGetGamepadName := GetProcAddress(aDLLHandle, 'glfwGetGamepadName');
  glfwGetGamepadState := GetProcAddress(aDLLHandle, 'glfwGetGamepadState');
  glfwGetGammaRamp := GetProcAddress(aDLLHandle, 'glfwGetGammaRamp');
  glfwGetInputMode := GetProcAddress(aDLLHandle, 'glfwGetInputMode');
  glfwGetJoystickAxes := GetProcAddress(aDLLHandle, 'glfwGetJoystickAxes');
  glfwGetJoystickButtons := GetProcAddress(aDLLHandle, 'glfwGetJoystickButtons');
  glfwGetJoystickGUID := GetProcAddress(aDLLHandle, 'glfwGetJoystickGUID');
  glfwGetJoystickHats := GetProcAddress(aDLLHandle, 'glfwGetJoystickHats');
  glfwGetJoystickName := GetProcAddress(aDLLHandle, 'glfwGetJoystickName');
  glfwGetJoystickUserPointer := GetProcAddress(aDLLHandle, 'glfwGetJoystickUserPointer');
  glfwGetKey := GetProcAddress(aDLLHandle, 'glfwGetKey');
  glfwGetKeyName := GetProcAddress(aDLLHandle, 'glfwGetKeyName');
  glfwGetKeyScancode := GetProcAddress(aDLLHandle, 'glfwGetKeyScancode');
  glfwGetMonitorContentScale := GetProcAddress(aDLLHandle, 'glfwGetMonitorContentScale');
  glfwGetMonitorName := GetProcAddress(aDLLHandle, 'glfwGetMonitorName');
  glfwGetMonitorPhysicalSize := GetProcAddress(aDLLHandle, 'glfwGetMonitorPhysicalSize');
  glfwGetMonitorPos := GetProcAddress(aDLLHandle, 'glfwGetMonitorPos');
  glfwGetMonitors := GetProcAddress(aDLLHandle, 'glfwGetMonitors');
  glfwGetMonitorUserPointer := GetProcAddress(aDLLHandle, 'glfwGetMonitorUserPointer');
  glfwGetMonitorWorkarea := GetProcAddress(aDLLHandle, 'glfwGetMonitorWorkarea');
  glfwGetMouseButton := GetProcAddress(aDLLHandle, 'glfwGetMouseButton');
  glfwGetPlatform := GetProcAddress(aDLLHandle, 'glfwGetPlatform');
  glfwGetPrimaryMonitor := GetProcAddress(aDLLHandle, 'glfwGetPrimaryMonitor');
  glfwGetProcAddress := GetProcAddress(aDLLHandle, 'glfwGetProcAddress');
  glfwGetRequiredInstanceExtensions := GetProcAddress(aDLLHandle, 'glfwGetRequiredInstanceExtensions');
  glfwGetTime := GetProcAddress(aDLLHandle, 'glfwGetTime');
  glfwGetTimerFrequency := GetProcAddress(aDLLHandle, 'glfwGetTimerFrequency');
  glfwGetTimerValue := GetProcAddress(aDLLHandle, 'glfwGetTimerValue');
  glfwGetVersion := GetProcAddress(aDLLHandle, 'glfwGetVersion');
  glfwGetVersionString := GetProcAddress(aDLLHandle, 'glfwGetVersionString');
  glfwGetVideoMode := GetProcAddress(aDLLHandle, 'glfwGetVideoMode');
  glfwGetVideoModes := GetProcAddress(aDLLHandle, 'glfwGetVideoModes');
  glfwGetWin32Adapter := GetProcAddress(aDLLHandle, 'glfwGetWin32Adapter');
  glfwGetWin32Monitor := GetProcAddress(aDLLHandle, 'glfwGetWin32Monitor');
  glfwGetWin32Window := GetProcAddress(aDLLHandle, 'glfwGetWin32Window');
  glfwGetWindowAttrib := GetProcAddress(aDLLHandle, 'glfwGetWindowAttrib');
  glfwGetWindowContentScale := GetProcAddress(aDLLHandle, 'glfwGetWindowContentScale');
  glfwGetWindowFrameSize := GetProcAddress(aDLLHandle, 'glfwGetWindowFrameSize');
  glfwGetWindowMonitor := GetProcAddress(aDLLHandle, 'glfwGetWindowMonitor');
  glfwGetWindowOpacity := GetProcAddress(aDLLHandle, 'glfwGetWindowOpacity');
  glfwGetWindowPos := GetProcAddress(aDLLHandle, 'glfwGetWindowPos');
  glfwGetWindowSize := GetProcAddress(aDLLHandle, 'glfwGetWindowSize');
  glfwGetWindowTitle := GetProcAddress(aDLLHandle, 'glfwGetWindowTitle');
  glfwGetWindowUserPointer := GetProcAddress(aDLLHandle, 'glfwGetWindowUserPointer');
  glfwHideWindow := GetProcAddress(aDLLHandle, 'glfwHideWindow');
  glfwIconifyWindow := GetProcAddress(aDLLHandle, 'glfwIconifyWindow');
  glfwInit := GetProcAddress(aDLLHandle, 'glfwInit');
  glfwInitAllocator := GetProcAddress(aDLLHandle, 'glfwInitAllocator');
  glfwInitHint := GetProcAddress(aDLLHandle, 'glfwInitHint');
  glfwJoystickIsGamepad := GetProcAddress(aDLLHandle, 'glfwJoystickIsGamepad');
  glfwJoystickPresent := GetProcAddress(aDLLHandle, 'glfwJoystickPresent');
  glfwMakeContextCurrent := GetProcAddress(aDLLHandle, 'glfwMakeContextCurrent');
  glfwMaximizeWindow := GetProcAddress(aDLLHandle, 'glfwMaximizeWindow');
  glfwPlatformSupported := GetProcAddress(aDLLHandle, 'glfwPlatformSupported');
  glfwPollEvents := GetProcAddress(aDLLHandle, 'glfwPollEvents');
  glfwPostEmptyEvent := GetProcAddress(aDLLHandle, 'glfwPostEmptyEvent');
  glfwRawMouseMotionSupported := GetProcAddress(aDLLHandle, 'glfwRawMouseMotionSupported');
  glfwRequestWindowAttention := GetProcAddress(aDLLHandle, 'glfwRequestWindowAttention');
  glfwRestoreWindow := GetProcAddress(aDLLHandle, 'glfwRestoreWindow');
  glfwSetCharCallback := GetProcAddress(aDLLHandle, 'glfwSetCharCallback');
  glfwSetCharModsCallback := GetProcAddress(aDLLHandle, 'glfwSetCharModsCallback');
  glfwSetClipboardString := GetProcAddress(aDLLHandle, 'glfwSetClipboardString');
  glfwSetCursor := GetProcAddress(aDLLHandle, 'glfwSetCursor');
  glfwSetCursorEnterCallback := GetProcAddress(aDLLHandle, 'glfwSetCursorEnterCallback');
  glfwSetCursorPos := GetProcAddress(aDLLHandle, 'glfwSetCursorPos');
  glfwSetCursorPosCallback := GetProcAddress(aDLLHandle, 'glfwSetCursorPosCallback');
  glfwSetDropCallback := GetProcAddress(aDLLHandle, 'glfwSetDropCallback');
  glfwSetErrorCallback := GetProcAddress(aDLLHandle, 'glfwSetErrorCallback');
  glfwSetFramebufferSizeCallback := GetProcAddress(aDLLHandle, 'glfwSetFramebufferSizeCallback');
  glfwSetGamma := GetProcAddress(aDLLHandle, 'glfwSetGamma');
  glfwSetGammaRamp := GetProcAddress(aDLLHandle, 'glfwSetGammaRamp');
  glfwSetInputMode := GetProcAddress(aDLLHandle, 'glfwSetInputMode');
  glfwSetJoystickCallback := GetProcAddress(aDLLHandle, 'glfwSetJoystickCallback');
  glfwSetJoystickUserPointer := GetProcAddress(aDLLHandle, 'glfwSetJoystickUserPointer');
  glfwSetKeyCallback := GetProcAddress(aDLLHandle, 'glfwSetKeyCallback');
  glfwSetMonitorCallback := GetProcAddress(aDLLHandle, 'glfwSetMonitorCallback');
  glfwSetMonitorUserPointer := GetProcAddress(aDLLHandle, 'glfwSetMonitorUserPointer');
  glfwSetMouseButtonCallback := GetProcAddress(aDLLHandle, 'glfwSetMouseButtonCallback');
  glfwSetScrollCallback := GetProcAddress(aDLLHandle, 'glfwSetScrollCallback');
  glfwSetTime := GetProcAddress(aDLLHandle, 'glfwSetTime');
  glfwSetWindowAspectRatio := GetProcAddress(aDLLHandle, 'glfwSetWindowAspectRatio');
  glfwSetWindowAttrib := GetProcAddress(aDLLHandle, 'glfwSetWindowAttrib');
  glfwSetWindowCloseCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowCloseCallback');
  glfwSetWindowContentScaleCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowContentScaleCallback');
  glfwSetWindowFocusCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowFocusCallback');
  glfwSetWindowIcon := GetProcAddress(aDLLHandle, 'glfwSetWindowIcon');
  glfwSetWindowIconifyCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowIconifyCallback');
  glfwSetWindowMaximizeCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowMaximizeCallback');
  glfwSetWindowMonitor := GetProcAddress(aDLLHandle, 'glfwSetWindowMonitor');
  glfwSetWindowOpacity := GetProcAddress(aDLLHandle, 'glfwSetWindowOpacity');
  glfwSetWindowPos := GetProcAddress(aDLLHandle, 'glfwSetWindowPos');
  glfwSetWindowPosCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowPosCallback');
  glfwSetWindowRefreshCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowRefreshCallback');
  glfwSetWindowShouldClose := GetProcAddress(aDLLHandle, 'glfwSetWindowShouldClose');
  glfwSetWindowSize := GetProcAddress(aDLLHandle, 'glfwSetWindowSize');
  glfwSetWindowSizeCallback := GetProcAddress(aDLLHandle, 'glfwSetWindowSizeCallback');
  glfwSetWindowSizeLimits := GetProcAddress(aDLLHandle, 'glfwSetWindowSizeLimits');
  glfwSetWindowTitle := GetProcAddress(aDLLHandle, 'glfwSetWindowTitle');
  glfwSetWindowUserPointer := GetProcAddress(aDLLHandle, 'glfwSetWindowUserPointer');
  glfwShowWindow := GetProcAddress(aDLLHandle, 'glfwShowWindow');
  glfwSwapBuffers := GetProcAddress(aDLLHandle, 'glfwSwapBuffers');
  glfwSwapInterval := GetProcAddress(aDLLHandle, 'glfwSwapInterval');
  glfwTerminate := GetProcAddress(aDLLHandle, 'glfwTerminate');
  glfwUpdateGamepadMappings := GetProcAddress(aDLLHandle, 'glfwUpdateGamepadMappings');
  glfwVulkanSupported := GetProcAddress(aDLLHandle, 'glfwVulkanSupported');
  glfwWaitEvents := GetProcAddress(aDLLHandle, 'glfwWaitEvents');
  glfwWaitEventsTimeout := GetProcAddress(aDLLHandle, 'glfwWaitEventsTimeout');
  glfwWindowHint := GetProcAddress(aDLLHandle, 'glfwWindowHint');
  glfwWindowHintString := GetProcAddress(aDLLHandle, 'glfwWindowHintString');
  glfwWindowShouldClose := GetProcAddress(aDLLHandle, 'glfwWindowShouldClose');
  igAcceptDragDropPayload := GetProcAddress(aDLLHandle, 'igAcceptDragDropPayload');
  igActivateItemByID := GetProcAddress(aDLLHandle, 'igActivateItemByID');
  igAddContextHook := GetProcAddress(aDLLHandle, 'igAddContextHook');
  igAddDrawListToDrawDataEx := GetProcAddress(aDLLHandle, 'igAddDrawListToDrawDataEx');
  igAddSettingsHandler := GetProcAddress(aDLLHandle, 'igAddSettingsHandler');
  igAlignTextToFramePadding := GetProcAddress(aDLLHandle, 'igAlignTextToFramePadding');
  igArrowButton := GetProcAddress(aDLLHandle, 'igArrowButton');
  igArrowButtonEx := GetProcAddress(aDLLHandle, 'igArrowButtonEx');
  igBegin := GetProcAddress(aDLLHandle, 'igBegin');
  igBeginBoxSelect := GetProcAddress(aDLLHandle, 'igBeginBoxSelect');
  igBeginChild_ID := GetProcAddress(aDLLHandle, 'igBeginChild_ID');
  igBeginChild_Str := GetProcAddress(aDLLHandle, 'igBeginChild_Str');
  igBeginChildEx := GetProcAddress(aDLLHandle, 'igBeginChildEx');
  igBeginColumns := GetProcAddress(aDLLHandle, 'igBeginColumns');
  igBeginCombo := GetProcAddress(aDLLHandle, 'igBeginCombo');
  igBeginComboPopup := GetProcAddress(aDLLHandle, 'igBeginComboPopup');
  igBeginComboPreview := GetProcAddress(aDLLHandle, 'igBeginComboPreview');
  igBeginDisabled := GetProcAddress(aDLLHandle, 'igBeginDisabled');
  igBeginDisabledOverrideReenable := GetProcAddress(aDLLHandle, 'igBeginDisabledOverrideReenable');
  igBeginDockableDragDropSource := GetProcAddress(aDLLHandle, 'igBeginDockableDragDropSource');
  igBeginDockableDragDropTarget := GetProcAddress(aDLLHandle, 'igBeginDockableDragDropTarget');
  igBeginDocked := GetProcAddress(aDLLHandle, 'igBeginDocked');
  igBeginDragDropSource := GetProcAddress(aDLLHandle, 'igBeginDragDropSource');
  igBeginDragDropTarget := GetProcAddress(aDLLHandle, 'igBeginDragDropTarget');
  igBeginDragDropTargetCustom := GetProcAddress(aDLLHandle, 'igBeginDragDropTargetCustom');
  igBeginErrorTooltip := GetProcAddress(aDLLHandle, 'igBeginErrorTooltip');
  igBeginGroup := GetProcAddress(aDLLHandle, 'igBeginGroup');
  igBeginItemTooltip := GetProcAddress(aDLLHandle, 'igBeginItemTooltip');
  igBeginListBox := GetProcAddress(aDLLHandle, 'igBeginListBox');
  igBeginMainMenuBar := GetProcAddress(aDLLHandle, 'igBeginMainMenuBar');
  igBeginMenu := GetProcAddress(aDLLHandle, 'igBeginMenu');
  igBeginMenuBar := GetProcAddress(aDLLHandle, 'igBeginMenuBar');
  igBeginMenuEx := GetProcAddress(aDLLHandle, 'igBeginMenuEx');
  igBeginMultiSelect := GetProcAddress(aDLLHandle, 'igBeginMultiSelect');
  igBeginPopup := GetProcAddress(aDLLHandle, 'igBeginPopup');
  igBeginPopupContextItem := GetProcAddress(aDLLHandle, 'igBeginPopupContextItem');
  igBeginPopupContextVoid := GetProcAddress(aDLLHandle, 'igBeginPopupContextVoid');
  igBeginPopupContextWindow := GetProcAddress(aDLLHandle, 'igBeginPopupContextWindow');
  igBeginPopupEx := GetProcAddress(aDLLHandle, 'igBeginPopupEx');
  igBeginPopupMenuEx := GetProcAddress(aDLLHandle, 'igBeginPopupMenuEx');
  igBeginPopupModal := GetProcAddress(aDLLHandle, 'igBeginPopupModal');
  igBeginTabBar := GetProcAddress(aDLLHandle, 'igBeginTabBar');
  igBeginTabBarEx := GetProcAddress(aDLLHandle, 'igBeginTabBarEx');
  igBeginTabItem := GetProcAddress(aDLLHandle, 'igBeginTabItem');
  igBeginTable := GetProcAddress(aDLLHandle, 'igBeginTable');
  igBeginTableEx := GetProcAddress(aDLLHandle, 'igBeginTableEx');
  igBeginTooltip := GetProcAddress(aDLLHandle, 'igBeginTooltip');
  igBeginTooltipEx := GetProcAddress(aDLLHandle, 'igBeginTooltipEx');
  igBeginTooltipHidden := GetProcAddress(aDLLHandle, 'igBeginTooltipHidden');
  igBeginViewportSideBar := GetProcAddress(aDLLHandle, 'igBeginViewportSideBar');
  igBringWindowToDisplayBack := GetProcAddress(aDLLHandle, 'igBringWindowToDisplayBack');
  igBringWindowToDisplayBehind := GetProcAddress(aDLLHandle, 'igBringWindowToDisplayBehind');
  igBringWindowToDisplayFront := GetProcAddress(aDLLHandle, 'igBringWindowToDisplayFront');
  igBringWindowToFocusFront := GetProcAddress(aDLLHandle, 'igBringWindowToFocusFront');
  igBullet := GetProcAddress(aDLLHandle, 'igBullet');
  igBulletText := GetProcAddress(aDLLHandle, 'igBulletText');
  igBulletTextV := GetProcAddress(aDLLHandle, 'igBulletTextV');
  igButton := GetProcAddress(aDLLHandle, 'igButton');
  igButtonBehavior := GetProcAddress(aDLLHandle, 'igButtonBehavior');
  igButtonEx := GetProcAddress(aDLLHandle, 'igButtonEx');
  igCalcItemSize := GetProcAddress(aDLLHandle, 'igCalcItemSize');
  igCalcItemWidth := GetProcAddress(aDLLHandle, 'igCalcItemWidth');
  igCalcRoundingFlagsForRectInRect := GetProcAddress(aDLLHandle, 'igCalcRoundingFlagsForRectInRect');
  igCalcTextSize := GetProcAddress(aDLLHandle, 'igCalcTextSize');
  igCalcTypematicRepeatAmount := GetProcAddress(aDLLHandle, 'igCalcTypematicRepeatAmount');
  igCalcWindowNextAutoFitSize := GetProcAddress(aDLLHandle, 'igCalcWindowNextAutoFitSize');
  igCalcWrapWidthForPos := GetProcAddress(aDLLHandle, 'igCalcWrapWidthForPos');
  igCallContextHooks := GetProcAddress(aDLLHandle, 'igCallContextHooks');
  igCheckbox := GetProcAddress(aDLLHandle, 'igCheckbox');
  igCheckboxFlags_IntPtr := GetProcAddress(aDLLHandle, 'igCheckboxFlags_IntPtr');
  igCheckboxFlags_S64Ptr := GetProcAddress(aDLLHandle, 'igCheckboxFlags_S64Ptr');
  igCheckboxFlags_U64Ptr := GetProcAddress(aDLLHandle, 'igCheckboxFlags_U64Ptr');
  igCheckboxFlags_UintPtr := GetProcAddress(aDLLHandle, 'igCheckboxFlags_UintPtr');
  igClearActiveID := GetProcAddress(aDLLHandle, 'igClearActiveID');
  igClearDragDrop := GetProcAddress(aDLLHandle, 'igClearDragDrop');
  igClearIniSettings := GetProcAddress(aDLLHandle, 'igClearIniSettings');
  igClearWindowSettings := GetProcAddress(aDLLHandle, 'igClearWindowSettings');
  igCloseButton := GetProcAddress(aDLLHandle, 'igCloseButton');
  igCloseCurrentPopup := GetProcAddress(aDLLHandle, 'igCloseCurrentPopup');
  igClosePopupsExceptModals := GetProcAddress(aDLLHandle, 'igClosePopupsExceptModals');
  igClosePopupsOverWindow := GetProcAddress(aDLLHandle, 'igClosePopupsOverWindow');
  igClosePopupToLevel := GetProcAddress(aDLLHandle, 'igClosePopupToLevel');
  igCollapseButton := GetProcAddress(aDLLHandle, 'igCollapseButton');
  igCollapsingHeader_BoolPtr := GetProcAddress(aDLLHandle, 'igCollapsingHeader_BoolPtr');
  igCollapsingHeader_TreeNodeFlags := GetProcAddress(aDLLHandle, 'igCollapsingHeader_TreeNodeFlags');
  igColorButton := GetProcAddress(aDLLHandle, 'igColorButton');
  igColorConvertFloat4ToU32 := GetProcAddress(aDLLHandle, 'igColorConvertFloat4ToU32');
  igColorConvertHSVtoRGB := GetProcAddress(aDLLHandle, 'igColorConvertHSVtoRGB');
  igColorConvertRGBtoHSV := GetProcAddress(aDLLHandle, 'igColorConvertRGBtoHSV');
  igColorConvertU32ToFloat4 := GetProcAddress(aDLLHandle, 'igColorConvertU32ToFloat4');
  igColorEdit3 := GetProcAddress(aDLLHandle, 'igColorEdit3');
  igColorEdit4 := GetProcAddress(aDLLHandle, 'igColorEdit4');
  igColorEditOptionsPopup := GetProcAddress(aDLLHandle, 'igColorEditOptionsPopup');
  igColorPicker3 := GetProcAddress(aDLLHandle, 'igColorPicker3');
  igColorPicker4 := GetProcAddress(aDLLHandle, 'igColorPicker4');
  igColorPickerOptionsPopup := GetProcAddress(aDLLHandle, 'igColorPickerOptionsPopup');
  igColorTooltip := GetProcAddress(aDLLHandle, 'igColorTooltip');
  igColumns := GetProcAddress(aDLLHandle, 'igColumns');
  igCombo_FnStrPtr := GetProcAddress(aDLLHandle, 'igCombo_FnStrPtr');
  igCombo_Str := GetProcAddress(aDLLHandle, 'igCombo_Str');
  igCombo_Str_arr := GetProcAddress(aDLLHandle, 'igCombo_Str_arr');
  igConvertSingleModFlagToKey := GetProcAddress(aDLLHandle, 'igConvertSingleModFlagToKey');
  igCreateContext := GetProcAddress(aDLLHandle, 'igCreateContext');
  igCreateNewWindowSettings := GetProcAddress(aDLLHandle, 'igCreateNewWindowSettings');
  igDataTypeApplyFromText := GetProcAddress(aDLLHandle, 'igDataTypeApplyFromText');
  igDataTypeApplyOp := GetProcAddress(aDLLHandle, 'igDataTypeApplyOp');
  igDataTypeClamp := GetProcAddress(aDLLHandle, 'igDataTypeClamp');
  igDataTypeCompare := GetProcAddress(aDLLHandle, 'igDataTypeCompare');
  igDataTypeFormatString := GetProcAddress(aDLLHandle, 'igDataTypeFormatString');
  igDataTypeGetInfo := GetProcAddress(aDLLHandle, 'igDataTypeGetInfo');
  igDataTypeIsZero := GetProcAddress(aDLLHandle, 'igDataTypeIsZero');
  igDebugAllocHook := GetProcAddress(aDLLHandle, 'igDebugAllocHook');
  igDebugBreakButton := GetProcAddress(aDLLHandle, 'igDebugBreakButton');
  igDebugBreakButtonTooltip := GetProcAddress(aDLLHandle, 'igDebugBreakButtonTooltip');
  igDebugBreakClearData := GetProcAddress(aDLLHandle, 'igDebugBreakClearData');
  igDebugCheckVersionAndDataLayout := GetProcAddress(aDLLHandle, 'igDebugCheckVersionAndDataLayout');
  igDebugDrawCursorPos := GetProcAddress(aDLLHandle, 'igDebugDrawCursorPos');
  igDebugDrawItemRect := GetProcAddress(aDLLHandle, 'igDebugDrawItemRect');
  igDebugDrawLineExtents := GetProcAddress(aDLLHandle, 'igDebugDrawLineExtents');
  igDebugFlashStyleColor := GetProcAddress(aDLLHandle, 'igDebugFlashStyleColor');
  igDebugHookIdInfo := GetProcAddress(aDLLHandle, 'igDebugHookIdInfo');
  igDebugLocateItem := GetProcAddress(aDLLHandle, 'igDebugLocateItem');
  igDebugLocateItemOnHover := GetProcAddress(aDLLHandle, 'igDebugLocateItemOnHover');
  igDebugLocateItemResolveWithLastItem := GetProcAddress(aDLLHandle, 'igDebugLocateItemResolveWithLastItem');
  igDebugLog := GetProcAddress(aDLLHandle, 'igDebugLog');
  igDebugLogV := GetProcAddress(aDLLHandle, 'igDebugLogV');
  igDebugNodeColumns := GetProcAddress(aDLLHandle, 'igDebugNodeColumns');
  igDebugNodeDockNode := GetProcAddress(aDLLHandle, 'igDebugNodeDockNode');
  igDebugNodeDrawCmdShowMeshAndBoundingBox := GetProcAddress(aDLLHandle, 'igDebugNodeDrawCmdShowMeshAndBoundingBox');
  igDebugNodeDrawList := GetProcAddress(aDLLHandle, 'igDebugNodeDrawList');
  igDebugNodeFont := GetProcAddress(aDLLHandle, 'igDebugNodeFont');
  igDebugNodeFontGlyph := GetProcAddress(aDLLHandle, 'igDebugNodeFontGlyph');
  igDebugNodeInputTextState := GetProcAddress(aDLLHandle, 'igDebugNodeInputTextState');
  igDebugNodeMultiSelectState := GetProcAddress(aDLLHandle, 'igDebugNodeMultiSelectState');
  igDebugNodePlatformMonitor := GetProcAddress(aDLLHandle, 'igDebugNodePlatformMonitor');
  igDebugNodeStorage := GetProcAddress(aDLLHandle, 'igDebugNodeStorage');
  igDebugNodeTabBar := GetProcAddress(aDLLHandle, 'igDebugNodeTabBar');
  igDebugNodeTable := GetProcAddress(aDLLHandle, 'igDebugNodeTable');
  igDebugNodeTableSettings := GetProcAddress(aDLLHandle, 'igDebugNodeTableSettings');
  igDebugNodeTypingSelectState := GetProcAddress(aDLLHandle, 'igDebugNodeTypingSelectState');
  igDebugNodeViewport := GetProcAddress(aDLLHandle, 'igDebugNodeViewport');
  igDebugNodeWindow := GetProcAddress(aDLLHandle, 'igDebugNodeWindow');
  igDebugNodeWindowSettings := GetProcAddress(aDLLHandle, 'igDebugNodeWindowSettings');
  igDebugNodeWindowsList := GetProcAddress(aDLLHandle, 'igDebugNodeWindowsList');
  igDebugNodeWindowsListByBeginStackParent := GetProcAddress(aDLLHandle, 'igDebugNodeWindowsListByBeginStackParent');
  igDebugRenderKeyboardPreview := GetProcAddress(aDLLHandle, 'igDebugRenderKeyboardPreview');
  igDebugRenderViewportThumbnail := GetProcAddress(aDLLHandle, 'igDebugRenderViewportThumbnail');
  igDebugStartItemPicker := GetProcAddress(aDLLHandle, 'igDebugStartItemPicker');
  igDebugTextEncoding := GetProcAddress(aDLLHandle, 'igDebugTextEncoding');
  igDebugTextUnformattedWithLocateItem := GetProcAddress(aDLLHandle, 'igDebugTextUnformattedWithLocateItem');
  igDestroyContext := GetProcAddress(aDLLHandle, 'igDestroyContext');
  igDestroyPlatformWindow := GetProcAddress(aDLLHandle, 'igDestroyPlatformWindow');
  igDestroyPlatformWindows := GetProcAddress(aDLLHandle, 'igDestroyPlatformWindows');
  igDockBuilderAddNode := GetProcAddress(aDLLHandle, 'igDockBuilderAddNode');
  igDockBuilderCopyDockSpace := GetProcAddress(aDLLHandle, 'igDockBuilderCopyDockSpace');
  igDockBuilderCopyNode := GetProcAddress(aDLLHandle, 'igDockBuilderCopyNode');
  igDockBuilderCopyWindowSettings := GetProcAddress(aDLLHandle, 'igDockBuilderCopyWindowSettings');
  igDockBuilderDockWindow := GetProcAddress(aDLLHandle, 'igDockBuilderDockWindow');
  igDockBuilderFinish := GetProcAddress(aDLLHandle, 'igDockBuilderFinish');
  igDockBuilderGetCentralNode := GetProcAddress(aDLLHandle, 'igDockBuilderGetCentralNode');
  igDockBuilderGetNode := GetProcAddress(aDLLHandle, 'igDockBuilderGetNode');
  igDockBuilderRemoveNode := GetProcAddress(aDLLHandle, 'igDockBuilderRemoveNode');
  igDockBuilderRemoveNodeChildNodes := GetProcAddress(aDLLHandle, 'igDockBuilderRemoveNodeChildNodes');
  igDockBuilderRemoveNodeDockedWindows := GetProcAddress(aDLLHandle, 'igDockBuilderRemoveNodeDockedWindows');
  igDockBuilderSetNodePos := GetProcAddress(aDLLHandle, 'igDockBuilderSetNodePos');
  igDockBuilderSetNodeSize := GetProcAddress(aDLLHandle, 'igDockBuilderSetNodeSize');
  igDockBuilderSplitNode := GetProcAddress(aDLLHandle, 'igDockBuilderSplitNode');
  igDockContextCalcDropPosForDocking := GetProcAddress(aDLLHandle, 'igDockContextCalcDropPosForDocking');
  igDockContextClearNodes := GetProcAddress(aDLLHandle, 'igDockContextClearNodes');
  igDockContextEndFrame := GetProcAddress(aDLLHandle, 'igDockContextEndFrame');
  igDockContextFindNodeByID := GetProcAddress(aDLLHandle, 'igDockContextFindNodeByID');
  igDockContextGenNodeID := GetProcAddress(aDLLHandle, 'igDockContextGenNodeID');
  igDockContextInitialize := GetProcAddress(aDLLHandle, 'igDockContextInitialize');
  igDockContextNewFrameUpdateDocking := GetProcAddress(aDLLHandle, 'igDockContextNewFrameUpdateDocking');
  igDockContextNewFrameUpdateUndocking := GetProcAddress(aDLLHandle, 'igDockContextNewFrameUpdateUndocking');
  igDockContextProcessUndockNode := GetProcAddress(aDLLHandle, 'igDockContextProcessUndockNode');
  igDockContextProcessUndockWindow := GetProcAddress(aDLLHandle, 'igDockContextProcessUndockWindow');
  igDockContextQueueDock := GetProcAddress(aDLLHandle, 'igDockContextQueueDock');
  igDockContextQueueUndockNode := GetProcAddress(aDLLHandle, 'igDockContextQueueUndockNode');
  igDockContextQueueUndockWindow := GetProcAddress(aDLLHandle, 'igDockContextQueueUndockWindow');
  igDockContextRebuildNodes := GetProcAddress(aDLLHandle, 'igDockContextRebuildNodes');
  igDockContextShutdown := GetProcAddress(aDLLHandle, 'igDockContextShutdown');
  igDockNodeBeginAmendTabBar := GetProcAddress(aDLLHandle, 'igDockNodeBeginAmendTabBar');
  igDockNodeEndAmendTabBar := GetProcAddress(aDLLHandle, 'igDockNodeEndAmendTabBar');
  igDockNodeGetDepth := GetProcAddress(aDLLHandle, 'igDockNodeGetDepth');
  igDockNodeGetRootNode := GetProcAddress(aDLLHandle, 'igDockNodeGetRootNode');
  igDockNodeGetWindowMenuButtonId := GetProcAddress(aDLLHandle, 'igDockNodeGetWindowMenuButtonId');
  igDockNodeIsInHierarchyOf := GetProcAddress(aDLLHandle, 'igDockNodeIsInHierarchyOf');
  igDockNodeWindowMenuHandler_Default := GetProcAddress(aDLLHandle, 'igDockNodeWindowMenuHandler_Default');
  igDockSpace := GetProcAddress(aDLLHandle, 'igDockSpace');
  igDockSpaceOverViewport := GetProcAddress(aDLLHandle, 'igDockSpaceOverViewport');
  igDragBehavior := GetProcAddress(aDLLHandle, 'igDragBehavior');
  igDragFloat := GetProcAddress(aDLLHandle, 'igDragFloat');
  igDragFloat2 := GetProcAddress(aDLLHandle, 'igDragFloat2');
  igDragFloat3 := GetProcAddress(aDLLHandle, 'igDragFloat3');
  igDragFloat4 := GetProcAddress(aDLLHandle, 'igDragFloat4');
  igDragFloatRange2 := GetProcAddress(aDLLHandle, 'igDragFloatRange2');
  igDragInt := GetProcAddress(aDLLHandle, 'igDragInt');
  igDragInt2 := GetProcAddress(aDLLHandle, 'igDragInt2');
  igDragInt3 := GetProcAddress(aDLLHandle, 'igDragInt3');
  igDragInt4 := GetProcAddress(aDLLHandle, 'igDragInt4');
  igDragIntRange2 := GetProcAddress(aDLLHandle, 'igDragIntRange2');
  igDragScalar := GetProcAddress(aDLLHandle, 'igDragScalar');
  igDragScalarN := GetProcAddress(aDLLHandle, 'igDragScalarN');
  igDummy := GetProcAddress(aDLLHandle, 'igDummy');
  igEnd := GetProcAddress(aDLLHandle, 'igEnd');
  igEndBoxSelect := GetProcAddress(aDLLHandle, 'igEndBoxSelect');
  igEndChild := GetProcAddress(aDLLHandle, 'igEndChild');
  igEndColumns := GetProcAddress(aDLLHandle, 'igEndColumns');
  igEndCombo := GetProcAddress(aDLLHandle, 'igEndCombo');
  igEndComboPreview := GetProcAddress(aDLLHandle, 'igEndComboPreview');
  igEndDisabled := GetProcAddress(aDLLHandle, 'igEndDisabled');
  igEndDisabledOverrideReenable := GetProcAddress(aDLLHandle, 'igEndDisabledOverrideReenable');
  igEndDragDropSource := GetProcAddress(aDLLHandle, 'igEndDragDropSource');
  igEndDragDropTarget := GetProcAddress(aDLLHandle, 'igEndDragDropTarget');
  igEndErrorTooltip := GetProcAddress(aDLLHandle, 'igEndErrorTooltip');
  igEndFrame := GetProcAddress(aDLLHandle, 'igEndFrame');
  igEndGroup := GetProcAddress(aDLLHandle, 'igEndGroup');
  igEndListBox := GetProcAddress(aDLLHandle, 'igEndListBox');
  igEndMainMenuBar := GetProcAddress(aDLLHandle, 'igEndMainMenuBar');
  igEndMenu := GetProcAddress(aDLLHandle, 'igEndMenu');
  igEndMenuBar := GetProcAddress(aDLLHandle, 'igEndMenuBar');
  igEndMultiSelect := GetProcAddress(aDLLHandle, 'igEndMultiSelect');
  igEndPopup := GetProcAddress(aDLLHandle, 'igEndPopup');
  igEndTabBar := GetProcAddress(aDLLHandle, 'igEndTabBar');
  igEndTabItem := GetProcAddress(aDLLHandle, 'igEndTabItem');
  igEndTable := GetProcAddress(aDLLHandle, 'igEndTable');
  igEndTooltip := GetProcAddress(aDLLHandle, 'igEndTooltip');
  igErrorCheckEndFrameFinalizeErrorTooltip := GetProcAddress(aDLLHandle, 'igErrorCheckEndFrameFinalizeErrorTooltip');
  igErrorCheckUsingSetCursorPosToExtendParentBoundaries := GetProcAddress(aDLLHandle, 'igErrorCheckUsingSetCursorPosToExtendParentBoundaries');
  igErrorLog := GetProcAddress(aDLLHandle, 'igErrorLog');
  igErrorRecoveryStoreState := GetProcAddress(aDLLHandle, 'igErrorRecoveryStoreState');
  igErrorRecoveryTryToRecoverState := GetProcAddress(aDLLHandle, 'igErrorRecoveryTryToRecoverState');
  igErrorRecoveryTryToRecoverWindowState := GetProcAddress(aDLLHandle, 'igErrorRecoveryTryToRecoverWindowState');
  igFindBestWindowPosForPopup := GetProcAddress(aDLLHandle, 'igFindBestWindowPosForPopup');
  igFindBestWindowPosForPopupEx := GetProcAddress(aDLLHandle, 'igFindBestWindowPosForPopupEx');
  igFindBlockingModal := GetProcAddress(aDLLHandle, 'igFindBlockingModal');
  igFindBottomMostVisibleWindowWithinBeginStack := GetProcAddress(aDLLHandle, 'igFindBottomMostVisibleWindowWithinBeginStack');
  igFindHoveredViewportFromPlatformWindowStack := GetProcAddress(aDLLHandle, 'igFindHoveredViewportFromPlatformWindowStack');
  igFindHoveredWindowEx := GetProcAddress(aDLLHandle, 'igFindHoveredWindowEx');
  igFindOrCreateColumns := GetProcAddress(aDLLHandle, 'igFindOrCreateColumns');
  igFindRenderedTextEnd := GetProcAddress(aDLLHandle, 'igFindRenderedTextEnd');
  igFindSettingsHandler := GetProcAddress(aDLLHandle, 'igFindSettingsHandler');
  igFindViewportByID := GetProcAddress(aDLLHandle, 'igFindViewportByID');
  igFindViewportByPlatformHandle := GetProcAddress(aDLLHandle, 'igFindViewportByPlatformHandle');
  igFindWindowByID := GetProcAddress(aDLLHandle, 'igFindWindowByID');
  igFindWindowByName := GetProcAddress(aDLLHandle, 'igFindWindowByName');
  igFindWindowDisplayIndex := GetProcAddress(aDLLHandle, 'igFindWindowDisplayIndex');
  igFindWindowSettingsByID := GetProcAddress(aDLLHandle, 'igFindWindowSettingsByID');
  igFindWindowSettingsByWindow := GetProcAddress(aDLLHandle, 'igFindWindowSettingsByWindow');
  igFixupKeyChord := GetProcAddress(aDLLHandle, 'igFixupKeyChord');
  igFocusItem := GetProcAddress(aDLLHandle, 'igFocusItem');
  igFocusTopMostWindowUnderOne := GetProcAddress(aDLLHandle, 'igFocusTopMostWindowUnderOne');
  igFocusWindow := GetProcAddress(aDLLHandle, 'igFocusWindow');
  igGcAwakeTransientWindowBuffers := GetProcAddress(aDLLHandle, 'igGcAwakeTransientWindowBuffers');
  igGcCompactTransientMiscBuffers := GetProcAddress(aDLLHandle, 'igGcCompactTransientMiscBuffers');
  igGcCompactTransientWindowBuffers := GetProcAddress(aDLLHandle, 'igGcCompactTransientWindowBuffers');
  igGET_FLT_MAX := GetProcAddress(aDLLHandle, 'igGET_FLT_MAX');
  igGET_FLT_MIN := GetProcAddress(aDLLHandle, 'igGET_FLT_MIN');
  igGetActiveID := GetProcAddress(aDLLHandle, 'igGetActiveID');
  igGetAllocatorFunctions := GetProcAddress(aDLLHandle, 'igGetAllocatorFunctions');
  igGetBackgroundDrawList := GetProcAddress(aDLLHandle, 'igGetBackgroundDrawList');
  igGetBoxSelectState := GetProcAddress(aDLLHandle, 'igGetBoxSelectState');
  igGetClipboardText := GetProcAddress(aDLLHandle, 'igGetClipboardText');
  igGetColorU32_Col := GetProcAddress(aDLLHandle, 'igGetColorU32_Col');
  igGetColorU32_U32 := GetProcAddress(aDLLHandle, 'igGetColorU32_U32');
  igGetColorU32_Vec4 := GetProcAddress(aDLLHandle, 'igGetColorU32_Vec4');
  igGetColumnIndex := GetProcAddress(aDLLHandle, 'igGetColumnIndex');
  igGetColumnNormFromOffset := GetProcAddress(aDLLHandle, 'igGetColumnNormFromOffset');
  igGetColumnOffset := GetProcAddress(aDLLHandle, 'igGetColumnOffset');
  igGetColumnOffsetFromNorm := GetProcAddress(aDLLHandle, 'igGetColumnOffsetFromNorm');
  igGetColumnsCount := GetProcAddress(aDLLHandle, 'igGetColumnsCount');
  igGetColumnsID := GetProcAddress(aDLLHandle, 'igGetColumnsID');
  igGetColumnWidth := GetProcAddress(aDLLHandle, 'igGetColumnWidth');
  igGetContentRegionAvail := GetProcAddress(aDLLHandle, 'igGetContentRegionAvail');
  igGetCurrentContext := GetProcAddress(aDLLHandle, 'igGetCurrentContext');
  igGetCurrentFocusScope := GetProcAddress(aDLLHandle, 'igGetCurrentFocusScope');
  igGetCurrentTabBar := GetProcAddress(aDLLHandle, 'igGetCurrentTabBar');
  igGetCurrentTable := GetProcAddress(aDLLHandle, 'igGetCurrentTable');
  igGetCurrentWindow := GetProcAddress(aDLLHandle, 'igGetCurrentWindow');
  igGetCurrentWindowRead := GetProcAddress(aDLLHandle, 'igGetCurrentWindowRead');
  igGetCursorPos := GetProcAddress(aDLLHandle, 'igGetCursorPos');
  igGetCursorPosX := GetProcAddress(aDLLHandle, 'igGetCursorPosX');
  igGetCursorPosY := GetProcAddress(aDLLHandle, 'igGetCursorPosY');
  igGetCursorScreenPos := GetProcAddress(aDLLHandle, 'igGetCursorScreenPos');
  igGetCursorStartPos := GetProcAddress(aDLLHandle, 'igGetCursorStartPos');
  igGetDefaultFont := GetProcAddress(aDLLHandle, 'igGetDefaultFont');
  igGetDragDropPayload := GetProcAddress(aDLLHandle, 'igGetDragDropPayload');
  igGetDrawData := GetProcAddress(aDLLHandle, 'igGetDrawData');
  igGetDrawListSharedData := GetProcAddress(aDLLHandle, 'igGetDrawListSharedData');
  igGetFocusID := GetProcAddress(aDLLHandle, 'igGetFocusID');
  igGetFont := GetProcAddress(aDLLHandle, 'igGetFont');
  igGetFontSize := GetProcAddress(aDLLHandle, 'igGetFontSize');
  igGetFontTexUvWhitePixel := GetProcAddress(aDLLHandle, 'igGetFontTexUvWhitePixel');
  igGetForegroundDrawList_ViewportPtr := GetProcAddress(aDLLHandle, 'igGetForegroundDrawList_ViewportPtr');
  igGetForegroundDrawList_WindowPtr := GetProcAddress(aDLLHandle, 'igGetForegroundDrawList_WindowPtr');
  igGetFrameCount := GetProcAddress(aDLLHandle, 'igGetFrameCount');
  igGetFrameHeight := GetProcAddress(aDLLHandle, 'igGetFrameHeight');
  igGetFrameHeightWithSpacing := GetProcAddress(aDLLHandle, 'igGetFrameHeightWithSpacing');
  igGetHoveredID := GetProcAddress(aDLLHandle, 'igGetHoveredID');
  igGetID_Int := GetProcAddress(aDLLHandle, 'igGetID_Int');
  igGetID_Ptr := GetProcAddress(aDLLHandle, 'igGetID_Ptr');
  igGetID_Str := GetProcAddress(aDLLHandle, 'igGetID_Str');
  igGetID_StrStr := GetProcAddress(aDLLHandle, 'igGetID_StrStr');
  igGetIDWithSeed_Int := GetProcAddress(aDLLHandle, 'igGetIDWithSeed_Int');
  igGetIDWithSeed_Str := GetProcAddress(aDLLHandle, 'igGetIDWithSeed_Str');
  igGetInputTextState := GetProcAddress(aDLLHandle, 'igGetInputTextState');
  igGetIO_ContextPtr := GetProcAddress(aDLLHandle, 'igGetIO_ContextPtr');
  igGetIO_Nil := GetProcAddress(aDLLHandle, 'igGetIO_Nil');
  igGetItemFlags := GetProcAddress(aDLLHandle, 'igGetItemFlags');
  igGetItemID := GetProcAddress(aDLLHandle, 'igGetItemID');
  igGetItemRectMax := GetProcAddress(aDLLHandle, 'igGetItemRectMax');
  igGetItemRectMin := GetProcAddress(aDLLHandle, 'igGetItemRectMin');
  igGetItemRectSize := GetProcAddress(aDLLHandle, 'igGetItemRectSize');
  igGetItemStatusFlags := GetProcAddress(aDLLHandle, 'igGetItemStatusFlags');
  igGetKeyChordName := GetProcAddress(aDLLHandle, 'igGetKeyChordName');
  igGetKeyData_ContextPtr := GetProcAddress(aDLLHandle, 'igGetKeyData_ContextPtr');
  igGetKeyData_Key := GetProcAddress(aDLLHandle, 'igGetKeyData_Key');
  igGetKeyMagnitude2d := GetProcAddress(aDLLHandle, 'igGetKeyMagnitude2d');
  igGetKeyName := GetProcAddress(aDLLHandle, 'igGetKeyName');
  igGetKeyOwner := GetProcAddress(aDLLHandle, 'igGetKeyOwner');
  igGetKeyOwnerData := GetProcAddress(aDLLHandle, 'igGetKeyOwnerData');
  igGetKeyPressedAmount := GetProcAddress(aDLLHandle, 'igGetKeyPressedAmount');
  igGetMainViewport := GetProcAddress(aDLLHandle, 'igGetMainViewport');
  igGetMouseClickedCount := GetProcAddress(aDLLHandle, 'igGetMouseClickedCount');
  igGetMouseCursor := GetProcAddress(aDLLHandle, 'igGetMouseCursor');
  igGetMouseDragDelta := GetProcAddress(aDLLHandle, 'igGetMouseDragDelta');
  igGetMousePos := GetProcAddress(aDLLHandle, 'igGetMousePos');
  igGetMousePosOnOpeningCurrentPopup := GetProcAddress(aDLLHandle, 'igGetMousePosOnOpeningCurrentPopup');
  igGetMultiSelectState := GetProcAddress(aDLLHandle, 'igGetMultiSelectState');
  igGetNavTweakPressedAmount := GetProcAddress(aDLLHandle, 'igGetNavTweakPressedAmount');
  igGetPlatformIO_ContextPtr := GetProcAddress(aDLLHandle, 'igGetPlatformIO_ContextPtr');
  igGetPlatformIO_Nil := GetProcAddress(aDLLHandle, 'igGetPlatformIO_Nil');
  igGetPopupAllowedExtentRect := GetProcAddress(aDLLHandle, 'igGetPopupAllowedExtentRect');
  igGetScrollMaxX := GetProcAddress(aDLLHandle, 'igGetScrollMaxX');
  igGetScrollMaxY := GetProcAddress(aDLLHandle, 'igGetScrollMaxY');
  igGetScrollX := GetProcAddress(aDLLHandle, 'igGetScrollX');
  igGetScrollY := GetProcAddress(aDLLHandle, 'igGetScrollY');
  igGetShortcutRoutingData := GetProcAddress(aDLLHandle, 'igGetShortcutRoutingData');
  igGetStateStorage := GetProcAddress(aDLLHandle, 'igGetStateStorage');
  igGetStyle := GetProcAddress(aDLLHandle, 'igGetStyle');
  igGetStyleColorName := GetProcAddress(aDLLHandle, 'igGetStyleColorName');
  igGetStyleColorVec4 := GetProcAddress(aDLLHandle, 'igGetStyleColorVec4');
  igGetStyleVarInfo := GetProcAddress(aDLLHandle, 'igGetStyleVarInfo');
  igGetTextLineHeight := GetProcAddress(aDLLHandle, 'igGetTextLineHeight');
  igGetTextLineHeightWithSpacing := GetProcAddress(aDLLHandle, 'igGetTextLineHeightWithSpacing');
  igGetTime := GetProcAddress(aDLLHandle, 'igGetTime');
  igGetTopMostAndVisiblePopupModal := GetProcAddress(aDLLHandle, 'igGetTopMostAndVisiblePopupModal');
  igGetTopMostPopupModal := GetProcAddress(aDLLHandle, 'igGetTopMostPopupModal');
  igGetTreeNodeToLabelSpacing := GetProcAddress(aDLLHandle, 'igGetTreeNodeToLabelSpacing');
  igGetTypematicRepeatRate := GetProcAddress(aDLLHandle, 'igGetTypematicRepeatRate');
  igGetTypingSelectRequest := GetProcAddress(aDLLHandle, 'igGetTypingSelectRequest');
  igGetVersion := GetProcAddress(aDLLHandle, 'igGetVersion');
  igGetViewportPlatformMonitor := GetProcAddress(aDLLHandle, 'igGetViewportPlatformMonitor');
  igGetWindowAlwaysWantOwnTabBar := GetProcAddress(aDLLHandle, 'igGetWindowAlwaysWantOwnTabBar');
  igGetWindowDockID := GetProcAddress(aDLLHandle, 'igGetWindowDockID');
  igGetWindowDockNode := GetProcAddress(aDLLHandle, 'igGetWindowDockNode');
  igGetWindowDpiScale := GetProcAddress(aDLLHandle, 'igGetWindowDpiScale');
  igGetWindowDrawList := GetProcAddress(aDLLHandle, 'igGetWindowDrawList');
  igGetWindowHeight := GetProcAddress(aDLLHandle, 'igGetWindowHeight');
  igGetWindowPos := GetProcAddress(aDLLHandle, 'igGetWindowPos');
  igGetWindowResizeBorderID := GetProcAddress(aDLLHandle, 'igGetWindowResizeBorderID');
  igGetWindowResizeCornerID := GetProcAddress(aDLLHandle, 'igGetWindowResizeCornerID');
  igGetWindowScrollbarID := GetProcAddress(aDLLHandle, 'igGetWindowScrollbarID');
  igGetWindowScrollbarRect := GetProcAddress(aDLLHandle, 'igGetWindowScrollbarRect');
  igGetWindowSize := GetProcAddress(aDLLHandle, 'igGetWindowSize');
  igGetWindowViewport := GetProcAddress(aDLLHandle, 'igGetWindowViewport');
  igGetWindowWidth := GetProcAddress(aDLLHandle, 'igGetWindowWidth');
  igImAbs_double := GetProcAddress(aDLLHandle, 'igImAbs_double');
  igImAbs_Float := GetProcAddress(aDLLHandle, 'igImAbs_Float');
  igImAbs_Int := GetProcAddress(aDLLHandle, 'igImAbs_Int');
  igImage := GetProcAddress(aDLLHandle, 'igImage');
  igImageButton := GetProcAddress(aDLLHandle, 'igImageButton');
  igImageButtonEx := GetProcAddress(aDLLHandle, 'igImageButtonEx');
  igImageWithBg := GetProcAddress(aDLLHandle, 'igImageWithBg');
  igImAlphaBlendColors := GetProcAddress(aDLLHandle, 'igImAlphaBlendColors');
  igImBezierCubicCalc := GetProcAddress(aDLLHandle, 'igImBezierCubicCalc');
  igImBezierCubicClosestPoint := GetProcAddress(aDLLHandle, 'igImBezierCubicClosestPoint');
  igImBezierCubicClosestPointCasteljau := GetProcAddress(aDLLHandle, 'igImBezierCubicClosestPointCasteljau');
  igImBezierQuadraticCalc := GetProcAddress(aDLLHandle, 'igImBezierQuadraticCalc');
  igImBitArrayClearAllBits := GetProcAddress(aDLLHandle, 'igImBitArrayClearAllBits');
  igImBitArrayClearBit := GetProcAddress(aDLLHandle, 'igImBitArrayClearBit');
  igImBitArrayGetStorageSizeInBytes := GetProcAddress(aDLLHandle, 'igImBitArrayGetStorageSizeInBytes');
  igImBitArraySetBit := GetProcAddress(aDLLHandle, 'igImBitArraySetBit');
  igImBitArraySetBitRange := GetProcAddress(aDLLHandle, 'igImBitArraySetBitRange');
  igImBitArrayTestBit := GetProcAddress(aDLLHandle, 'igImBitArrayTestBit');
  igImCharIsBlankA := GetProcAddress(aDLLHandle, 'igImCharIsBlankA');
  igImCharIsBlankW := GetProcAddress(aDLLHandle, 'igImCharIsBlankW');
  igImCharIsXdigitA := GetProcAddress(aDLLHandle, 'igImCharIsXdigitA');
  igImClamp := GetProcAddress(aDLLHandle, 'igImClamp');
  igImCountSetBits := GetProcAddress(aDLLHandle, 'igImCountSetBits');
  igImDot := GetProcAddress(aDLLHandle, 'igImDot');
  igImExponentialMovingAverage := GetProcAddress(aDLLHandle, 'igImExponentialMovingAverage');
  igImFileClose := GetProcAddress(aDLLHandle, 'igImFileClose');
  igImFileGetSize := GetProcAddress(aDLLHandle, 'igImFileGetSize');
  igImFileLoadToMemory := GetProcAddress(aDLLHandle, 'igImFileLoadToMemory');
  igImFileOpen := GetProcAddress(aDLLHandle, 'igImFileOpen');
  igImFileRead := GetProcAddress(aDLLHandle, 'igImFileRead');
  igImFileWrite := GetProcAddress(aDLLHandle, 'igImFileWrite');
  igImFloor_Float := GetProcAddress(aDLLHandle, 'igImFloor_Float');
  igImFloor_Vec2 := GetProcAddress(aDLLHandle, 'igImFloor_Vec2');
  igImFontAtlasBuildFinish := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildFinish');
  igImFontAtlasBuildGetOversampleFactors := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildGetOversampleFactors');
  igImFontAtlasBuildInit := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildInit');
  igImFontAtlasBuildMultiplyCalcLookupTable := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildMultiplyCalcLookupTable');
  igImFontAtlasBuildMultiplyRectAlpha8 := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildMultiplyRectAlpha8');
  igImFontAtlasBuildPackCustomRects := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildPackCustomRects');
  igImFontAtlasBuildRender32bppRectFromString := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildRender32bppRectFromString');
  igImFontAtlasBuildRender8bppRectFromString := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildRender8bppRectFromString');
  igImFontAtlasBuildSetupFont := GetProcAddress(aDLLHandle, 'igImFontAtlasBuildSetupFont');
  igImFontAtlasGetBuilderForStbTruetype := GetProcAddress(aDLLHandle, 'igImFontAtlasGetBuilderForStbTruetype');
  igImFontAtlasGetMouseCursorTexData := GetProcAddress(aDLLHandle, 'igImFontAtlasGetMouseCursorTexData');
  igImFontAtlasUpdateSourcesPointers := GetProcAddress(aDLLHandle, 'igImFontAtlasUpdateSourcesPointers');
  igImFormatString := GetProcAddress(aDLLHandle, 'igImFormatString');
  igImFormatStringToTempBuffer := GetProcAddress(aDLLHandle, 'igImFormatStringToTempBuffer');
  igImFormatStringToTempBufferV := GetProcAddress(aDLLHandle, 'igImFormatStringToTempBufferV');
  igImFormatStringV := GetProcAddress(aDLLHandle, 'igImFormatStringV');
  igImHashData := GetProcAddress(aDLLHandle, 'igImHashData');
  igImHashStr := GetProcAddress(aDLLHandle, 'igImHashStr');
  igImInvLength := GetProcAddress(aDLLHandle, 'igImInvLength');
  igImIsFloatAboveGuaranteedIntegerPrecision := GetProcAddress(aDLLHandle, 'igImIsFloatAboveGuaranteedIntegerPrecision');
  igImIsPowerOfTwo_Int := GetProcAddress(aDLLHandle, 'igImIsPowerOfTwo_Int');
  igImIsPowerOfTwo_U64 := GetProcAddress(aDLLHandle, 'igImIsPowerOfTwo_U64');
  igImLengthSqr_Vec2 := GetProcAddress(aDLLHandle, 'igImLengthSqr_Vec2');
  igImLengthSqr_Vec4 := GetProcAddress(aDLLHandle, 'igImLengthSqr_Vec4');
  igImLerp_Vec2Float := GetProcAddress(aDLLHandle, 'igImLerp_Vec2Float');
  igImLerp_Vec2Vec2 := GetProcAddress(aDLLHandle, 'igImLerp_Vec2Vec2');
  igImLerp_Vec4 := GetProcAddress(aDLLHandle, 'igImLerp_Vec4');
  igImLinearRemapClamp := GetProcAddress(aDLLHandle, 'igImLinearRemapClamp');
  igImLinearSweep := GetProcAddress(aDLLHandle, 'igImLinearSweep');
  igImLineClosestPoint := GetProcAddress(aDLLHandle, 'igImLineClosestPoint');
  igImLog_double := GetProcAddress(aDLLHandle, 'igImLog_double');
  igImLog_Float := GetProcAddress(aDLLHandle, 'igImLog_Float');
  igImLowerBound := GetProcAddress(aDLLHandle, 'igImLowerBound');
  igImMax := GetProcAddress(aDLLHandle, 'igImMax');
  igImMin := GetProcAddress(aDLLHandle, 'igImMin');
  igImModPositive := GetProcAddress(aDLLHandle, 'igImModPositive');
  igImMul := GetProcAddress(aDLLHandle, 'igImMul');
  igImParseFormatFindEnd := GetProcAddress(aDLLHandle, 'igImParseFormatFindEnd');
  igImParseFormatFindStart := GetProcAddress(aDLLHandle, 'igImParseFormatFindStart');
  igImParseFormatPrecision := GetProcAddress(aDLLHandle, 'igImParseFormatPrecision');
  igImParseFormatSanitizeForPrinting := GetProcAddress(aDLLHandle, 'igImParseFormatSanitizeForPrinting');
  igImParseFormatSanitizeForScanning := GetProcAddress(aDLLHandle, 'igImParseFormatSanitizeForScanning');
  igImParseFormatTrimDecorations := GetProcAddress(aDLLHandle, 'igImParseFormatTrimDecorations');
  igImPow_double := GetProcAddress(aDLLHandle, 'igImPow_double');
  igImPow_Float := GetProcAddress(aDLLHandle, 'igImPow_Float');
  igImQsort := GetProcAddress(aDLLHandle, 'igImQsort');
  igImRotate := GetProcAddress(aDLLHandle, 'igImRotate');
  igImRsqrt_double := GetProcAddress(aDLLHandle, 'igImRsqrt_double');
  igImRsqrt_Float := GetProcAddress(aDLLHandle, 'igImRsqrt_Float');
  igImSaturate := GetProcAddress(aDLLHandle, 'igImSaturate');
  igImSign_double := GetProcAddress(aDLLHandle, 'igImSign_double');
  igImSign_Float := GetProcAddress(aDLLHandle, 'igImSign_Float');
  igImStrbol := GetProcAddress(aDLLHandle, 'igImStrbol');
  igImStrchrRange := GetProcAddress(aDLLHandle, 'igImStrchrRange');
  igImStrdup := GetProcAddress(aDLLHandle, 'igImStrdup');
  igImStrdupcpy := GetProcAddress(aDLLHandle, 'igImStrdupcpy');
  igImStreolRange := GetProcAddress(aDLLHandle, 'igImStreolRange');
  igImStricmp := GetProcAddress(aDLLHandle, 'igImStricmp');
  igImStristr := GetProcAddress(aDLLHandle, 'igImStristr');
  igImStrlenW := GetProcAddress(aDLLHandle, 'igImStrlenW');
  igImStrncpy := GetProcAddress(aDLLHandle, 'igImStrncpy');
  igImStrnicmp := GetProcAddress(aDLLHandle, 'igImStrnicmp');
  igImStrSkipBlank := GetProcAddress(aDLLHandle, 'igImStrSkipBlank');
  igImStrTrimBlanks := GetProcAddress(aDLLHandle, 'igImStrTrimBlanks');
  igImTextCharFromUtf8 := GetProcAddress(aDLLHandle, 'igImTextCharFromUtf8');
  igImTextCharToUtf8 := GetProcAddress(aDLLHandle, 'igImTextCharToUtf8');
  igImTextCountCharsFromUtf8 := GetProcAddress(aDLLHandle, 'igImTextCountCharsFromUtf8');
  igImTextCountLines := GetProcAddress(aDLLHandle, 'igImTextCountLines');
  igImTextCountUtf8BytesFromChar := GetProcAddress(aDLLHandle, 'igImTextCountUtf8BytesFromChar');
  igImTextCountUtf8BytesFromStr := GetProcAddress(aDLLHandle, 'igImTextCountUtf8BytesFromStr');
  igImTextFindPreviousUtf8Codepoint := GetProcAddress(aDLLHandle, 'igImTextFindPreviousUtf8Codepoint');
  igImTextStrFromUtf8 := GetProcAddress(aDLLHandle, 'igImTextStrFromUtf8');
  igImTextStrToUtf8 := GetProcAddress(aDLLHandle, 'igImTextStrToUtf8');
  igImToUpper := GetProcAddress(aDLLHandle, 'igImToUpper');
  igImTriangleArea := GetProcAddress(aDLLHandle, 'igImTriangleArea');
  igImTriangleBarycentricCoords := GetProcAddress(aDLLHandle, 'igImTriangleBarycentricCoords');
  igImTriangleClosestPoint := GetProcAddress(aDLLHandle, 'igImTriangleClosestPoint');
  igImTriangleContainsPoint := GetProcAddress(aDLLHandle, 'igImTriangleContainsPoint');
  igImTriangleIsClockwise := GetProcAddress(aDLLHandle, 'igImTriangleIsClockwise');
  igImTrunc_Float := GetProcAddress(aDLLHandle, 'igImTrunc_Float');
  igImTrunc_Vec2 := GetProcAddress(aDLLHandle, 'igImTrunc_Vec2');
  igImUpperPowerOfTwo := GetProcAddress(aDLLHandle, 'igImUpperPowerOfTwo');
  igIndent := GetProcAddress(aDLLHandle, 'igIndent');
  igInitialize := GetProcAddress(aDLLHandle, 'igInitialize');
  igInputDouble := GetProcAddress(aDLLHandle, 'igInputDouble');
  igInputFloat := GetProcAddress(aDLLHandle, 'igInputFloat');
  igInputFloat2 := GetProcAddress(aDLLHandle, 'igInputFloat2');
  igInputFloat3 := GetProcAddress(aDLLHandle, 'igInputFloat3');
  igInputFloat4 := GetProcAddress(aDLLHandle, 'igInputFloat4');
  igInputInt := GetProcAddress(aDLLHandle, 'igInputInt');
  igInputInt2 := GetProcAddress(aDLLHandle, 'igInputInt2');
  igInputInt3 := GetProcAddress(aDLLHandle, 'igInputInt3');
  igInputInt4 := GetProcAddress(aDLLHandle, 'igInputInt4');
  igInputScalar := GetProcAddress(aDLLHandle, 'igInputScalar');
  igInputScalarN := GetProcAddress(aDLLHandle, 'igInputScalarN');
  igInputText := GetProcAddress(aDLLHandle, 'igInputText');
  igInputTextDeactivateHook := GetProcAddress(aDLLHandle, 'igInputTextDeactivateHook');
  igInputTextEx := GetProcAddress(aDLLHandle, 'igInputTextEx');
  igInputTextMultiline := GetProcAddress(aDLLHandle, 'igInputTextMultiline');
  igInputTextWithHint := GetProcAddress(aDLLHandle, 'igInputTextWithHint');
  igInvisibleButton := GetProcAddress(aDLLHandle, 'igInvisibleButton');
  igIsActiveIdUsingNavDir := GetProcAddress(aDLLHandle, 'igIsActiveIdUsingNavDir');
  igIsAliasKey := GetProcAddress(aDLLHandle, 'igIsAliasKey');
  igIsAnyItemActive := GetProcAddress(aDLLHandle, 'igIsAnyItemActive');
  igIsAnyItemFocused := GetProcAddress(aDLLHandle, 'igIsAnyItemFocused');
  igIsAnyItemHovered := GetProcAddress(aDLLHandle, 'igIsAnyItemHovered');
  igIsAnyMouseDown := GetProcAddress(aDLLHandle, 'igIsAnyMouseDown');
  igIsClippedEx := GetProcAddress(aDLLHandle, 'igIsClippedEx');
  igIsDragDropActive := GetProcAddress(aDLLHandle, 'igIsDragDropActive');
  igIsDragDropPayloadBeingAccepted := GetProcAddress(aDLLHandle, 'igIsDragDropPayloadBeingAccepted');
  igIsGamepadKey := GetProcAddress(aDLLHandle, 'igIsGamepadKey');
  igIsItemActivated := GetProcAddress(aDLLHandle, 'igIsItemActivated');
  igIsItemActive := GetProcAddress(aDLLHandle, 'igIsItemActive');
  igIsItemActiveAsInputText := GetProcAddress(aDLLHandle, 'igIsItemActiveAsInputText');
  igIsItemClicked := GetProcAddress(aDLLHandle, 'igIsItemClicked');
  igIsItemDeactivated := GetProcAddress(aDLLHandle, 'igIsItemDeactivated');
  igIsItemDeactivatedAfterEdit := GetProcAddress(aDLLHandle, 'igIsItemDeactivatedAfterEdit');
  igIsItemEdited := GetProcAddress(aDLLHandle, 'igIsItemEdited');
  igIsItemFocused := GetProcAddress(aDLLHandle, 'igIsItemFocused');
  igIsItemHovered := GetProcAddress(aDLLHandle, 'igIsItemHovered');
  igIsItemToggledOpen := GetProcAddress(aDLLHandle, 'igIsItemToggledOpen');
  igIsItemToggledSelection := GetProcAddress(aDLLHandle, 'igIsItemToggledSelection');
  igIsItemVisible := GetProcAddress(aDLLHandle, 'igIsItemVisible');
  igIsKeyboardKey := GetProcAddress(aDLLHandle, 'igIsKeyboardKey');
  igIsKeyChordPressed_InputFlags := GetProcAddress(aDLLHandle, 'igIsKeyChordPressed_InputFlags');
  igIsKeyChordPressed_Nil := GetProcAddress(aDLLHandle, 'igIsKeyChordPressed_Nil');
  igIsKeyDown_ID := GetProcAddress(aDLLHandle, 'igIsKeyDown_ID');
  igIsKeyDown_Nil := GetProcAddress(aDLLHandle, 'igIsKeyDown_Nil');
  igIsKeyPressed_Bool := GetProcAddress(aDLLHandle, 'igIsKeyPressed_Bool');
  igIsKeyPressed_InputFlags := GetProcAddress(aDLLHandle, 'igIsKeyPressed_InputFlags');
  igIsKeyReleased_ID := GetProcAddress(aDLLHandle, 'igIsKeyReleased_ID');
  igIsKeyReleased_Nil := GetProcAddress(aDLLHandle, 'igIsKeyReleased_Nil');
  igIsLegacyKey := GetProcAddress(aDLLHandle, 'igIsLegacyKey');
  igIsLRModKey := GetProcAddress(aDLLHandle, 'igIsLRModKey');
  igIsMouseClicked_Bool := GetProcAddress(aDLLHandle, 'igIsMouseClicked_Bool');
  igIsMouseClicked_InputFlags := GetProcAddress(aDLLHandle, 'igIsMouseClicked_InputFlags');
  igIsMouseDoubleClicked_ID := GetProcAddress(aDLLHandle, 'igIsMouseDoubleClicked_ID');
  igIsMouseDoubleClicked_Nil := GetProcAddress(aDLLHandle, 'igIsMouseDoubleClicked_Nil');
  igIsMouseDown_ID := GetProcAddress(aDLLHandle, 'igIsMouseDown_ID');
  igIsMouseDown_Nil := GetProcAddress(aDLLHandle, 'igIsMouseDown_Nil');
  igIsMouseDragging := GetProcAddress(aDLLHandle, 'igIsMouseDragging');
  igIsMouseDragPastThreshold := GetProcAddress(aDLLHandle, 'igIsMouseDragPastThreshold');
  igIsMouseHoveringRect := GetProcAddress(aDLLHandle, 'igIsMouseHoveringRect');
  igIsMouseKey := GetProcAddress(aDLLHandle, 'igIsMouseKey');
  igIsMousePosValid := GetProcAddress(aDLLHandle, 'igIsMousePosValid');
  igIsMouseReleased_ID := GetProcAddress(aDLLHandle, 'igIsMouseReleased_ID');
  igIsMouseReleased_Nil := GetProcAddress(aDLLHandle, 'igIsMouseReleased_Nil');
  igIsMouseReleasedWithDelay := GetProcAddress(aDLLHandle, 'igIsMouseReleasedWithDelay');
  igIsNamedKey := GetProcAddress(aDLLHandle, 'igIsNamedKey');
  igIsNamedKeyOrMod := GetProcAddress(aDLLHandle, 'igIsNamedKeyOrMod');
  igIsPopupOpen_ID := GetProcAddress(aDLLHandle, 'igIsPopupOpen_ID');
  igIsPopupOpen_Str := GetProcAddress(aDLLHandle, 'igIsPopupOpen_Str');
  igIsRectVisible_Nil := GetProcAddress(aDLLHandle, 'igIsRectVisible_Nil');
  igIsRectVisible_Vec2 := GetProcAddress(aDLLHandle, 'igIsRectVisible_Vec2');
  igIsWindowAbove := GetProcAddress(aDLLHandle, 'igIsWindowAbove');
  igIsWindowAppearing := GetProcAddress(aDLLHandle, 'igIsWindowAppearing');
  igIsWindowChildOf := GetProcAddress(aDLLHandle, 'igIsWindowChildOf');
  igIsWindowCollapsed := GetProcAddress(aDLLHandle, 'igIsWindowCollapsed');
  igIsWindowContentHoverable := GetProcAddress(aDLLHandle, 'igIsWindowContentHoverable');
  igIsWindowDocked := GetProcAddress(aDLLHandle, 'igIsWindowDocked');
  igIsWindowFocused := GetProcAddress(aDLLHandle, 'igIsWindowFocused');
  igIsWindowHovered := GetProcAddress(aDLLHandle, 'igIsWindowHovered');
  igIsWindowNavFocusable := GetProcAddress(aDLLHandle, 'igIsWindowNavFocusable');
  igIsWindowWithinBeginStackOf := GetProcAddress(aDLLHandle, 'igIsWindowWithinBeginStackOf');
  igItemAdd := GetProcAddress(aDLLHandle, 'igItemAdd');
  igItemHoverable := GetProcAddress(aDLLHandle, 'igItemHoverable');
  igItemSize_Rect := GetProcAddress(aDLLHandle, 'igItemSize_Rect');
  igItemSize_Vec2 := GetProcAddress(aDLLHandle, 'igItemSize_Vec2');
  igKeepAliveID := GetProcAddress(aDLLHandle, 'igKeepAliveID');
  igLabelText := GetProcAddress(aDLLHandle, 'igLabelText');
  igLabelTextV := GetProcAddress(aDLLHandle, 'igLabelTextV');
  igListBox_FnStrPtr := GetProcAddress(aDLLHandle, 'igListBox_FnStrPtr');
  igListBox_Str_arr := GetProcAddress(aDLLHandle, 'igListBox_Str_arr');
  igLoadIniSettingsFromDisk := GetProcAddress(aDLLHandle, 'igLoadIniSettingsFromDisk');
  igLoadIniSettingsFromMemory := GetProcAddress(aDLLHandle, 'igLoadIniSettingsFromMemory');
  igLocalizeGetMsg := GetProcAddress(aDLLHandle, 'igLocalizeGetMsg');
  igLocalizeRegisterEntries := GetProcAddress(aDLLHandle, 'igLocalizeRegisterEntries');
  igLogBegin := GetProcAddress(aDLLHandle, 'igLogBegin');
  igLogButtons := GetProcAddress(aDLLHandle, 'igLogButtons');
  igLogFinish := GetProcAddress(aDLLHandle, 'igLogFinish');
  igLogRenderedText := GetProcAddress(aDLLHandle, 'igLogRenderedText');
  igLogSetNextTextDecoration := GetProcAddress(aDLLHandle, 'igLogSetNextTextDecoration');
  igLogText := GetProcAddress(aDLLHandle, 'igLogText');
  igLogTextV := GetProcAddress(aDLLHandle, 'igLogTextV');
  igLogToBuffer := GetProcAddress(aDLLHandle, 'igLogToBuffer');
  igLogToClipboard := GetProcAddress(aDLLHandle, 'igLogToClipboard');
  igLogToFile := GetProcAddress(aDLLHandle, 'igLogToFile');
  igLogToTTY := GetProcAddress(aDLLHandle, 'igLogToTTY');
  igMarkIniSettingsDirty_Nil := GetProcAddress(aDLLHandle, 'igMarkIniSettingsDirty_Nil');
  igMarkIniSettingsDirty_WindowPtr := GetProcAddress(aDLLHandle, 'igMarkIniSettingsDirty_WindowPtr');
  igMarkItemEdited := GetProcAddress(aDLLHandle, 'igMarkItemEdited');
  igMemAlloc := GetProcAddress(aDLLHandle, 'igMemAlloc');
  igMemFree := GetProcAddress(aDLLHandle, 'igMemFree');
  igMenuItem_Bool := GetProcAddress(aDLLHandle, 'igMenuItem_Bool');
  igMenuItem_BoolPtr := GetProcAddress(aDLLHandle, 'igMenuItem_BoolPtr');
  igMenuItemEx := GetProcAddress(aDLLHandle, 'igMenuItemEx');
  igMouseButtonToKey := GetProcAddress(aDLLHandle, 'igMouseButtonToKey');
  igMultiSelectAddSetAll := GetProcAddress(aDLLHandle, 'igMultiSelectAddSetAll');
  igMultiSelectAddSetRange := GetProcAddress(aDLLHandle, 'igMultiSelectAddSetRange');
  igMultiSelectItemFooter := GetProcAddress(aDLLHandle, 'igMultiSelectItemFooter');
  igMultiSelectItemHeader := GetProcAddress(aDLLHandle, 'igMultiSelectItemHeader');
  igNavClearPreferredPosForAxis := GetProcAddress(aDLLHandle, 'igNavClearPreferredPosForAxis');
  igNavHighlightActivated := GetProcAddress(aDLLHandle, 'igNavHighlightActivated');
  igNavInitRequestApplyResult := GetProcAddress(aDLLHandle, 'igNavInitRequestApplyResult');
  igNavInitWindow := GetProcAddress(aDLLHandle, 'igNavInitWindow');
  igNavMoveRequestApplyResult := GetProcAddress(aDLLHandle, 'igNavMoveRequestApplyResult');
  igNavMoveRequestButNoResultYet := GetProcAddress(aDLLHandle, 'igNavMoveRequestButNoResultYet');
  igNavMoveRequestCancel := GetProcAddress(aDLLHandle, 'igNavMoveRequestCancel');
  igNavMoveRequestForward := GetProcAddress(aDLLHandle, 'igNavMoveRequestForward');
  igNavMoveRequestResolveWithLastItem := GetProcAddress(aDLLHandle, 'igNavMoveRequestResolveWithLastItem');
  igNavMoveRequestResolveWithPastTreeNode := GetProcAddress(aDLLHandle, 'igNavMoveRequestResolveWithPastTreeNode');
  igNavMoveRequestSubmit := GetProcAddress(aDLLHandle, 'igNavMoveRequestSubmit');
  igNavMoveRequestTryWrapping := GetProcAddress(aDLLHandle, 'igNavMoveRequestTryWrapping');
  igNavUpdateCurrentWindowIsScrollPushableX := GetProcAddress(aDLLHandle, 'igNavUpdateCurrentWindowIsScrollPushableX');
  igNewFrame := GetProcAddress(aDLLHandle, 'igNewFrame');
  igNewLine := GetProcAddress(aDLLHandle, 'igNewLine');
  igNextColumn := GetProcAddress(aDLLHandle, 'igNextColumn');
  igOpenPopup_ID := GetProcAddress(aDLLHandle, 'igOpenPopup_ID');
  igOpenPopup_Str := GetProcAddress(aDLLHandle, 'igOpenPopup_Str');
  igOpenPopupEx := GetProcAddress(aDLLHandle, 'igOpenPopupEx');
  igOpenPopupOnItemClick := GetProcAddress(aDLLHandle, 'igOpenPopupOnItemClick');
  igPlotEx := GetProcAddress(aDLLHandle, 'igPlotEx');
  igPlotHistogram_FloatPtr := GetProcAddress(aDLLHandle, 'igPlotHistogram_FloatPtr');
  igPlotHistogram_FnFloatPtr := GetProcAddress(aDLLHandle, 'igPlotHistogram_FnFloatPtr');
  igPlotLines_FloatPtr := GetProcAddress(aDLLHandle, 'igPlotLines_FloatPtr');
  igPlotLines_FnFloatPtr := GetProcAddress(aDLLHandle, 'igPlotLines_FnFloatPtr');
  igPopClipRect := GetProcAddress(aDLLHandle, 'igPopClipRect');
  igPopColumnsBackground := GetProcAddress(aDLLHandle, 'igPopColumnsBackground');
  igPopFocusScope := GetProcAddress(aDLLHandle, 'igPopFocusScope');
  igPopFont := GetProcAddress(aDLLHandle, 'igPopFont');
  igPopID := GetProcAddress(aDLLHandle, 'igPopID');
  igPopItemFlag := GetProcAddress(aDLLHandle, 'igPopItemFlag');
  igPopItemWidth := GetProcAddress(aDLLHandle, 'igPopItemWidth');
  igPopStyleColor := GetProcAddress(aDLLHandle, 'igPopStyleColor');
  igPopStyleVar := GetProcAddress(aDLLHandle, 'igPopStyleVar');
  igPopTextWrapPos := GetProcAddress(aDLLHandle, 'igPopTextWrapPos');
  igProgressBar := GetProcAddress(aDLLHandle, 'igProgressBar');
  igPushClipRect := GetProcAddress(aDLLHandle, 'igPushClipRect');
  igPushColumnClipRect := GetProcAddress(aDLLHandle, 'igPushColumnClipRect');
  igPushColumnsBackground := GetProcAddress(aDLLHandle, 'igPushColumnsBackground');
  igPushFocusScope := GetProcAddress(aDLLHandle, 'igPushFocusScope');
  igPushFont := GetProcAddress(aDLLHandle, 'igPushFont');
  igPushID_Int := GetProcAddress(aDLLHandle, 'igPushID_Int');
  igPushID_Ptr := GetProcAddress(aDLLHandle, 'igPushID_Ptr');
  igPushID_Str := GetProcAddress(aDLLHandle, 'igPushID_Str');
  igPushID_StrStr := GetProcAddress(aDLLHandle, 'igPushID_StrStr');
  igPushItemFlag := GetProcAddress(aDLLHandle, 'igPushItemFlag');
  igPushItemWidth := GetProcAddress(aDLLHandle, 'igPushItemWidth');
  igPushMultiItemsWidths := GetProcAddress(aDLLHandle, 'igPushMultiItemsWidths');
  igPushOverrideID := GetProcAddress(aDLLHandle, 'igPushOverrideID');
  igPushPasswordFont := GetProcAddress(aDLLHandle, 'igPushPasswordFont');
  igPushStyleColor_U32 := GetProcAddress(aDLLHandle, 'igPushStyleColor_U32');
  igPushStyleColor_Vec4 := GetProcAddress(aDLLHandle, 'igPushStyleColor_Vec4');
  igPushStyleVar_Float := GetProcAddress(aDLLHandle, 'igPushStyleVar_Float');
  igPushStyleVar_Vec2 := GetProcAddress(aDLLHandle, 'igPushStyleVar_Vec2');
  igPushStyleVarX := GetProcAddress(aDLLHandle, 'igPushStyleVarX');
  igPushStyleVarY := GetProcAddress(aDLLHandle, 'igPushStyleVarY');
  igPushTextWrapPos := GetProcAddress(aDLLHandle, 'igPushTextWrapPos');
  igRadioButton_Bool := GetProcAddress(aDLLHandle, 'igRadioButton_Bool');
  igRadioButton_IntPtr := GetProcAddress(aDLLHandle, 'igRadioButton_IntPtr');
  igRemoveContextHook := GetProcAddress(aDLLHandle, 'igRemoveContextHook');
  igRemoveSettingsHandler := GetProcAddress(aDLLHandle, 'igRemoveSettingsHandler');
  igRender := GetProcAddress(aDLLHandle, 'igRender');
  igRenderArrow := GetProcAddress(aDLLHandle, 'igRenderArrow');
  igRenderArrowDockMenu := GetProcAddress(aDLLHandle, 'igRenderArrowDockMenu');
  igRenderArrowPointingAt := GetProcAddress(aDLLHandle, 'igRenderArrowPointingAt');
  igRenderBullet := GetProcAddress(aDLLHandle, 'igRenderBullet');
  igRenderCheckMark := GetProcAddress(aDLLHandle, 'igRenderCheckMark');
  igRenderColorRectWithAlphaCheckerboard := GetProcAddress(aDLLHandle, 'igRenderColorRectWithAlphaCheckerboard');
  igRenderDragDropTargetRect := GetProcAddress(aDLLHandle, 'igRenderDragDropTargetRect');
  igRenderFrame := GetProcAddress(aDLLHandle, 'igRenderFrame');
  igRenderFrameBorder := GetProcAddress(aDLLHandle, 'igRenderFrameBorder');
  igRenderMouseCursor := GetProcAddress(aDLLHandle, 'igRenderMouseCursor');
  igRenderNavCursor := GetProcAddress(aDLLHandle, 'igRenderNavCursor');
  igRenderPlatformWindowsDefault := GetProcAddress(aDLLHandle, 'igRenderPlatformWindowsDefault');
  igRenderRectFilledRangeH := GetProcAddress(aDLLHandle, 'igRenderRectFilledRangeH');
  igRenderRectFilledWithHole := GetProcAddress(aDLLHandle, 'igRenderRectFilledWithHole');
  igRenderText := GetProcAddress(aDLLHandle, 'igRenderText');
  igRenderTextClipped := GetProcAddress(aDLLHandle, 'igRenderTextClipped');
  igRenderTextClippedEx := GetProcAddress(aDLLHandle, 'igRenderTextClippedEx');
  igRenderTextEllipsis := GetProcAddress(aDLLHandle, 'igRenderTextEllipsis');
  igRenderTextWrapped := GetProcAddress(aDLLHandle, 'igRenderTextWrapped');
  igResetMouseDragDelta := GetProcAddress(aDLLHandle, 'igResetMouseDragDelta');
  igSameLine := GetProcAddress(aDLLHandle, 'igSameLine');
  igSaveIniSettingsToDisk := GetProcAddress(aDLLHandle, 'igSaveIniSettingsToDisk');
  igSaveIniSettingsToMemory := GetProcAddress(aDLLHandle, 'igSaveIniSettingsToMemory');
  igScaleWindowsInViewport := GetProcAddress(aDLLHandle, 'igScaleWindowsInViewport');
  igScrollbar := GetProcAddress(aDLLHandle, 'igScrollbar');
  igScrollbarEx := GetProcAddress(aDLLHandle, 'igScrollbarEx');
  igScrollToBringRectIntoView := GetProcAddress(aDLLHandle, 'igScrollToBringRectIntoView');
  igScrollToItem := GetProcAddress(aDLLHandle, 'igScrollToItem');
  igScrollToRect := GetProcAddress(aDLLHandle, 'igScrollToRect');
  igScrollToRectEx := GetProcAddress(aDLLHandle, 'igScrollToRectEx');
  igSelectable_Bool := GetProcAddress(aDLLHandle, 'igSelectable_Bool');
  igSelectable_BoolPtr := GetProcAddress(aDLLHandle, 'igSelectable_BoolPtr');
  igSeparator := GetProcAddress(aDLLHandle, 'igSeparator');
  igSeparatorEx := GetProcAddress(aDLLHandle, 'igSeparatorEx');
  igSeparatorText := GetProcAddress(aDLLHandle, 'igSeparatorText');
  igSeparatorTextEx := GetProcAddress(aDLLHandle, 'igSeparatorTextEx');
  igSetActiveID := GetProcAddress(aDLLHandle, 'igSetActiveID');
  igSetActiveIdUsingAllKeyboardKeys := GetProcAddress(aDLLHandle, 'igSetActiveIdUsingAllKeyboardKeys');
  igSetAllocatorFunctions := GetProcAddress(aDLLHandle, 'igSetAllocatorFunctions');
  igSetClipboardText := GetProcAddress(aDLLHandle, 'igSetClipboardText');
  igSetColorEditOptions := GetProcAddress(aDLLHandle, 'igSetColorEditOptions');
  igSetColumnOffset := GetProcAddress(aDLLHandle, 'igSetColumnOffset');
  igSetColumnWidth := GetProcAddress(aDLLHandle, 'igSetColumnWidth');
  igSetCurrentContext := GetProcAddress(aDLLHandle, 'igSetCurrentContext');
  igSetCurrentFont := GetProcAddress(aDLLHandle, 'igSetCurrentFont');
  igSetCurrentViewport := GetProcAddress(aDLLHandle, 'igSetCurrentViewport');
  igSetCursorPos := GetProcAddress(aDLLHandle, 'igSetCursorPos');
  igSetCursorPosX := GetProcAddress(aDLLHandle, 'igSetCursorPosX');
  igSetCursorPosY := GetProcAddress(aDLLHandle, 'igSetCursorPosY');
  igSetCursorScreenPos := GetProcAddress(aDLLHandle, 'igSetCursorScreenPos');
  igSetDragDropPayload := GetProcAddress(aDLLHandle, 'igSetDragDropPayload');
  igSetFocusID := GetProcAddress(aDLLHandle, 'igSetFocusID');
  igSetHoveredID := GetProcAddress(aDLLHandle, 'igSetHoveredID');
  igSetItemDefaultFocus := GetProcAddress(aDLLHandle, 'igSetItemDefaultFocus');
  igSetItemKeyOwner_InputFlags := GetProcAddress(aDLLHandle, 'igSetItemKeyOwner_InputFlags');
  igSetItemKeyOwner_Nil := GetProcAddress(aDLLHandle, 'igSetItemKeyOwner_Nil');
  igSetItemTooltip := GetProcAddress(aDLLHandle, 'igSetItemTooltip');
  igSetItemTooltipV := GetProcAddress(aDLLHandle, 'igSetItemTooltipV');
  igSetKeyboardFocusHere := GetProcAddress(aDLLHandle, 'igSetKeyboardFocusHere');
  igSetKeyOwner := GetProcAddress(aDLLHandle, 'igSetKeyOwner');
  igSetKeyOwnersForKeyChord := GetProcAddress(aDLLHandle, 'igSetKeyOwnersForKeyChord');
  igSetLastItemData := GetProcAddress(aDLLHandle, 'igSetLastItemData');
  igSetMouseCursor := GetProcAddress(aDLLHandle, 'igSetMouseCursor');
  igSetNavCursorVisible := GetProcAddress(aDLLHandle, 'igSetNavCursorVisible');
  igSetNavCursorVisibleAfterMove := GetProcAddress(aDLLHandle, 'igSetNavCursorVisibleAfterMove');
  igSetNavFocusScope := GetProcAddress(aDLLHandle, 'igSetNavFocusScope');
  igSetNavID := GetProcAddress(aDLLHandle, 'igSetNavID');
  igSetNavWindow := GetProcAddress(aDLLHandle, 'igSetNavWindow');
  igSetNextFrameWantCaptureKeyboard := GetProcAddress(aDLLHandle, 'igSetNextFrameWantCaptureKeyboard');
  igSetNextFrameWantCaptureMouse := GetProcAddress(aDLLHandle, 'igSetNextFrameWantCaptureMouse');
  igSetNextItemAllowOverlap := GetProcAddress(aDLLHandle, 'igSetNextItemAllowOverlap');
  igSetNextItemOpen := GetProcAddress(aDLLHandle, 'igSetNextItemOpen');
  igSetNextItemRefVal := GetProcAddress(aDLLHandle, 'igSetNextItemRefVal');
  igSetNextItemSelectionUserData := GetProcAddress(aDLLHandle, 'igSetNextItemSelectionUserData');
  igSetNextItemShortcut := GetProcAddress(aDLLHandle, 'igSetNextItemShortcut');
  igSetNextItemStorageID := GetProcAddress(aDLLHandle, 'igSetNextItemStorageID');
  igSetNextItemWidth := GetProcAddress(aDLLHandle, 'igSetNextItemWidth');
  igSetNextWindowBgAlpha := GetProcAddress(aDLLHandle, 'igSetNextWindowBgAlpha');
  igSetNextWindowClass := GetProcAddress(aDLLHandle, 'igSetNextWindowClass');
  igSetNextWindowCollapsed := GetProcAddress(aDLLHandle, 'igSetNextWindowCollapsed');
  igSetNextWindowContentSize := GetProcAddress(aDLLHandle, 'igSetNextWindowContentSize');
  igSetNextWindowDockID := GetProcAddress(aDLLHandle, 'igSetNextWindowDockID');
  igSetNextWindowFocus := GetProcAddress(aDLLHandle, 'igSetNextWindowFocus');
  igSetNextWindowPos := GetProcAddress(aDLLHandle, 'igSetNextWindowPos');
  igSetNextWindowRefreshPolicy := GetProcAddress(aDLLHandle, 'igSetNextWindowRefreshPolicy');
  igSetNextWindowScroll := GetProcAddress(aDLLHandle, 'igSetNextWindowScroll');
  igSetNextWindowSize := GetProcAddress(aDLLHandle, 'igSetNextWindowSize');
  igSetNextWindowSizeConstraints := GetProcAddress(aDLLHandle, 'igSetNextWindowSizeConstraints');
  igSetNextWindowViewport := GetProcAddress(aDLLHandle, 'igSetNextWindowViewport');
  igSetScrollFromPosX_Float := GetProcAddress(aDLLHandle, 'igSetScrollFromPosX_Float');
  igSetScrollFromPosX_WindowPtr := GetProcAddress(aDLLHandle, 'igSetScrollFromPosX_WindowPtr');
  igSetScrollFromPosY_Float := GetProcAddress(aDLLHandle, 'igSetScrollFromPosY_Float');
  igSetScrollFromPosY_WindowPtr := GetProcAddress(aDLLHandle, 'igSetScrollFromPosY_WindowPtr');
  igSetScrollHereX := GetProcAddress(aDLLHandle, 'igSetScrollHereX');
  igSetScrollHereY := GetProcAddress(aDLLHandle, 'igSetScrollHereY');
  igSetScrollX_Float := GetProcAddress(aDLLHandle, 'igSetScrollX_Float');
  igSetScrollX_WindowPtr := GetProcAddress(aDLLHandle, 'igSetScrollX_WindowPtr');
  igSetScrollY_Float := GetProcAddress(aDLLHandle, 'igSetScrollY_Float');
  igSetScrollY_WindowPtr := GetProcAddress(aDLLHandle, 'igSetScrollY_WindowPtr');
  igSetShortcutRouting := GetProcAddress(aDLLHandle, 'igSetShortcutRouting');
  igSetStateStorage := GetProcAddress(aDLLHandle, 'igSetStateStorage');
  igSetTabItemClosed := GetProcAddress(aDLLHandle, 'igSetTabItemClosed');
  igSetTooltip := GetProcAddress(aDLLHandle, 'igSetTooltip');
  igSetTooltipV := GetProcAddress(aDLLHandle, 'igSetTooltipV');
  igSetWindowClipRectBeforeSetChannel := GetProcAddress(aDLLHandle, 'igSetWindowClipRectBeforeSetChannel');
  igSetWindowCollapsed_Bool := GetProcAddress(aDLLHandle, 'igSetWindowCollapsed_Bool');
  igSetWindowCollapsed_Str := GetProcAddress(aDLLHandle, 'igSetWindowCollapsed_Str');
  igSetWindowCollapsed_WindowPtr := GetProcAddress(aDLLHandle, 'igSetWindowCollapsed_WindowPtr');
  igSetWindowDock := GetProcAddress(aDLLHandle, 'igSetWindowDock');
  igSetWindowFocus_Nil := GetProcAddress(aDLLHandle, 'igSetWindowFocus_Nil');
  igSetWindowFocus_Str := GetProcAddress(aDLLHandle, 'igSetWindowFocus_Str');
  igSetWindowFontScale := GetProcAddress(aDLLHandle, 'igSetWindowFontScale');
  igSetWindowHiddenAndSkipItemsForCurrentFrame := GetProcAddress(aDLLHandle, 'igSetWindowHiddenAndSkipItemsForCurrentFrame');
  igSetWindowHitTestHole := GetProcAddress(aDLLHandle, 'igSetWindowHitTestHole');
  igSetWindowParentWindowForFocusRoute := GetProcAddress(aDLLHandle, 'igSetWindowParentWindowForFocusRoute');
  igSetWindowPos_Str := GetProcAddress(aDLLHandle, 'igSetWindowPos_Str');
  igSetWindowPos_Vec2 := GetProcAddress(aDLLHandle, 'igSetWindowPos_Vec2');
  igSetWindowPos_WindowPtr := GetProcAddress(aDLLHandle, 'igSetWindowPos_WindowPtr');
  igSetWindowSize_Str := GetProcAddress(aDLLHandle, 'igSetWindowSize_Str');
  igSetWindowSize_Vec2 := GetProcAddress(aDLLHandle, 'igSetWindowSize_Vec2');
  igSetWindowSize_WindowPtr := GetProcAddress(aDLLHandle, 'igSetWindowSize_WindowPtr');
  igSetWindowViewport := GetProcAddress(aDLLHandle, 'igSetWindowViewport');
  igShadeVertsLinearColorGradientKeepAlpha := GetProcAddress(aDLLHandle, 'igShadeVertsLinearColorGradientKeepAlpha');
  igShadeVertsLinearUV := GetProcAddress(aDLLHandle, 'igShadeVertsLinearUV');
  igShadeVertsTransformPos := GetProcAddress(aDLLHandle, 'igShadeVertsTransformPos');
  igShortcut_ID := GetProcAddress(aDLLHandle, 'igShortcut_ID');
  igShortcut_Nil := GetProcAddress(aDLLHandle, 'igShortcut_Nil');
  igShowAboutWindow := GetProcAddress(aDLLHandle, 'igShowAboutWindow');
  igShowDebugLogWindow := GetProcAddress(aDLLHandle, 'igShowDebugLogWindow');
  igShowDemoWindow := GetProcAddress(aDLLHandle, 'igShowDemoWindow');
  igShowFontAtlas := GetProcAddress(aDLLHandle, 'igShowFontAtlas');
  igShowFontSelector := GetProcAddress(aDLLHandle, 'igShowFontSelector');
  igShowIDStackToolWindow := GetProcAddress(aDLLHandle, 'igShowIDStackToolWindow');
  igShowMetricsWindow := GetProcAddress(aDLLHandle, 'igShowMetricsWindow');
  igShowStyleEditor := GetProcAddress(aDLLHandle, 'igShowStyleEditor');
  igShowStyleSelector := GetProcAddress(aDLLHandle, 'igShowStyleSelector');
  igShowUserGuide := GetProcAddress(aDLLHandle, 'igShowUserGuide');
  igShrinkWidths := GetProcAddress(aDLLHandle, 'igShrinkWidths');
  igShutdown := GetProcAddress(aDLLHandle, 'igShutdown');
  igSliderAngle := GetProcAddress(aDLLHandle, 'igSliderAngle');
  igSliderBehavior := GetProcAddress(aDLLHandle, 'igSliderBehavior');
  igSliderFloat := GetProcAddress(aDLLHandle, 'igSliderFloat');
  igSliderFloat2 := GetProcAddress(aDLLHandle, 'igSliderFloat2');
  igSliderFloat3 := GetProcAddress(aDLLHandle, 'igSliderFloat3');
  igSliderFloat4 := GetProcAddress(aDLLHandle, 'igSliderFloat4');
  igSliderInt := GetProcAddress(aDLLHandle, 'igSliderInt');
  igSliderInt2 := GetProcAddress(aDLLHandle, 'igSliderInt2');
  igSliderInt3 := GetProcAddress(aDLLHandle, 'igSliderInt3');
  igSliderInt4 := GetProcAddress(aDLLHandle, 'igSliderInt4');
  igSliderScalar := GetProcAddress(aDLLHandle, 'igSliderScalar');
  igSliderScalarN := GetProcAddress(aDLLHandle, 'igSliderScalarN');
  igSmallButton := GetProcAddress(aDLLHandle, 'igSmallButton');
  igSpacing := GetProcAddress(aDLLHandle, 'igSpacing');
  igSplitterBehavior := GetProcAddress(aDLLHandle, 'igSplitterBehavior');
  igStartMouseMovingWindow := GetProcAddress(aDLLHandle, 'igStartMouseMovingWindow');
  igStartMouseMovingWindowOrNode := GetProcAddress(aDLLHandle, 'igStartMouseMovingWindowOrNode');
  igStyleColorsClassic := GetProcAddress(aDLLHandle, 'igStyleColorsClassic');
  igStyleColorsDark := GetProcAddress(aDLLHandle, 'igStyleColorsDark');
  igStyleColorsLight := GetProcAddress(aDLLHandle, 'igStyleColorsLight');
  igTabBarAddTab := GetProcAddress(aDLLHandle, 'igTabBarAddTab');
  igTabBarCloseTab := GetProcAddress(aDLLHandle, 'igTabBarCloseTab');
  igTabBarFindMostRecentlySelectedTabForActiveWindow := GetProcAddress(aDLLHandle, 'igTabBarFindMostRecentlySelectedTabForActiveWindow');
  igTabBarFindTabByID := GetProcAddress(aDLLHandle, 'igTabBarFindTabByID');
  igTabBarFindTabByOrder := GetProcAddress(aDLLHandle, 'igTabBarFindTabByOrder');
  igTabBarGetCurrentTab := GetProcAddress(aDLLHandle, 'igTabBarGetCurrentTab');
  igTabBarGetTabName := GetProcAddress(aDLLHandle, 'igTabBarGetTabName');
  igTabBarGetTabOrder := GetProcAddress(aDLLHandle, 'igTabBarGetTabOrder');
  igTabBarProcessReorder := GetProcAddress(aDLLHandle, 'igTabBarProcessReorder');
  igTabBarQueueFocus_Str := GetProcAddress(aDLLHandle, 'igTabBarQueueFocus_Str');
  igTabBarQueueFocus_TabItemPtr := GetProcAddress(aDLLHandle, 'igTabBarQueueFocus_TabItemPtr');
  igTabBarQueueReorder := GetProcAddress(aDLLHandle, 'igTabBarQueueReorder');
  igTabBarQueueReorderFromMousePos := GetProcAddress(aDLLHandle, 'igTabBarQueueReorderFromMousePos');
  igTabBarRemoveTab := GetProcAddress(aDLLHandle, 'igTabBarRemoveTab');
  igTabItemBackground := GetProcAddress(aDLLHandle, 'igTabItemBackground');
  igTabItemButton := GetProcAddress(aDLLHandle, 'igTabItemButton');
  igTabItemCalcSize_Str := GetProcAddress(aDLLHandle, 'igTabItemCalcSize_Str');
  igTabItemCalcSize_WindowPtr := GetProcAddress(aDLLHandle, 'igTabItemCalcSize_WindowPtr');
  igTabItemEx := GetProcAddress(aDLLHandle, 'igTabItemEx');
  igTabItemLabelAndCloseButton := GetProcAddress(aDLLHandle, 'igTabItemLabelAndCloseButton');
  igTabItemSpacing := GetProcAddress(aDLLHandle, 'igTabItemSpacing');
  igTableAngledHeadersRow := GetProcAddress(aDLLHandle, 'igTableAngledHeadersRow');
  igTableAngledHeadersRowEx := GetProcAddress(aDLLHandle, 'igTableAngledHeadersRowEx');
  igTableBeginApplyRequests := GetProcAddress(aDLLHandle, 'igTableBeginApplyRequests');
  igTableBeginCell := GetProcAddress(aDLLHandle, 'igTableBeginCell');
  igTableBeginContextMenuPopup := GetProcAddress(aDLLHandle, 'igTableBeginContextMenuPopup');
  igTableBeginInitMemory := GetProcAddress(aDLLHandle, 'igTableBeginInitMemory');
  igTableBeginRow := GetProcAddress(aDLLHandle, 'igTableBeginRow');
  igTableCalcMaxColumnWidth := GetProcAddress(aDLLHandle, 'igTableCalcMaxColumnWidth');
  igTableDrawBorders := GetProcAddress(aDLLHandle, 'igTableDrawBorders');
  igTableDrawDefaultContextMenu := GetProcAddress(aDLLHandle, 'igTableDrawDefaultContextMenu');
  igTableEndCell := GetProcAddress(aDLLHandle, 'igTableEndCell');
  igTableEndRow := GetProcAddress(aDLLHandle, 'igTableEndRow');
  igTableFindByID := GetProcAddress(aDLLHandle, 'igTableFindByID');
  igTableFixColumnSortDirection := GetProcAddress(aDLLHandle, 'igTableFixColumnSortDirection');
  igTableGcCompactSettings := GetProcAddress(aDLLHandle, 'igTableGcCompactSettings');
  igTableGcCompactTransientBuffers_TablePtr := GetProcAddress(aDLLHandle, 'igTableGcCompactTransientBuffers_TablePtr');
  igTableGcCompactTransientBuffers_TableTempDataPtr := GetProcAddress(aDLLHandle, 'igTableGcCompactTransientBuffers_TableTempDataPtr');
  igTableGetBoundSettings := GetProcAddress(aDLLHandle, 'igTableGetBoundSettings');
  igTableGetCellBgRect := GetProcAddress(aDLLHandle, 'igTableGetCellBgRect');
  igTableGetColumnCount := GetProcAddress(aDLLHandle, 'igTableGetColumnCount');
  igTableGetColumnFlags := GetProcAddress(aDLLHandle, 'igTableGetColumnFlags');
  igTableGetColumnIndex := GetProcAddress(aDLLHandle, 'igTableGetColumnIndex');
  igTableGetColumnName_Int := GetProcAddress(aDLLHandle, 'igTableGetColumnName_Int');
  igTableGetColumnName_TablePtr := GetProcAddress(aDLLHandle, 'igTableGetColumnName_TablePtr');
  igTableGetColumnNextSortDirection := GetProcAddress(aDLLHandle, 'igTableGetColumnNextSortDirection');
  igTableGetColumnResizeID := GetProcAddress(aDLLHandle, 'igTableGetColumnResizeID');
  igTableGetColumnWidthAuto := GetProcAddress(aDLLHandle, 'igTableGetColumnWidthAuto');
  igTableGetHeaderAngledMaxLabelWidth := GetProcAddress(aDLLHandle, 'igTableGetHeaderAngledMaxLabelWidth');
  igTableGetHeaderRowHeight := GetProcAddress(aDLLHandle, 'igTableGetHeaderRowHeight');
  igTableGetHoveredColumn := GetProcAddress(aDLLHandle, 'igTableGetHoveredColumn');
  igTableGetHoveredRow := GetProcAddress(aDLLHandle, 'igTableGetHoveredRow');
  igTableGetInstanceData := GetProcAddress(aDLLHandle, 'igTableGetInstanceData');
  igTableGetInstanceID := GetProcAddress(aDLLHandle, 'igTableGetInstanceID');
  igTableGetRowIndex := GetProcAddress(aDLLHandle, 'igTableGetRowIndex');
  igTableGetSortSpecs := GetProcAddress(aDLLHandle, 'igTableGetSortSpecs');
  igTableHeader := GetProcAddress(aDLLHandle, 'igTableHeader');
  igTableHeadersRow := GetProcAddress(aDLLHandle, 'igTableHeadersRow');
  igTableLoadSettings := GetProcAddress(aDLLHandle, 'igTableLoadSettings');
  igTableMergeDrawChannels := GetProcAddress(aDLLHandle, 'igTableMergeDrawChannels');
  igTableNextColumn := GetProcAddress(aDLLHandle, 'igTableNextColumn');
  igTableNextRow := GetProcAddress(aDLLHandle, 'igTableNextRow');
  igTableOpenContextMenu := GetProcAddress(aDLLHandle, 'igTableOpenContextMenu');
  igTablePopBackgroundChannel := GetProcAddress(aDLLHandle, 'igTablePopBackgroundChannel');
  igTablePushBackgroundChannel := GetProcAddress(aDLLHandle, 'igTablePushBackgroundChannel');
  igTableRemove := GetProcAddress(aDLLHandle, 'igTableRemove');
  igTableResetSettings := GetProcAddress(aDLLHandle, 'igTableResetSettings');
  igTableSaveSettings := GetProcAddress(aDLLHandle, 'igTableSaveSettings');
  igTableSetBgColor := GetProcAddress(aDLLHandle, 'igTableSetBgColor');
  igTableSetColumnEnabled := GetProcAddress(aDLLHandle, 'igTableSetColumnEnabled');
  igTableSetColumnIndex := GetProcAddress(aDLLHandle, 'igTableSetColumnIndex');
  igTableSetColumnSortDirection := GetProcAddress(aDLLHandle, 'igTableSetColumnSortDirection');
  igTableSetColumnWidth := GetProcAddress(aDLLHandle, 'igTableSetColumnWidth');
  igTableSetColumnWidthAutoAll := GetProcAddress(aDLLHandle, 'igTableSetColumnWidthAutoAll');
  igTableSetColumnWidthAutoSingle := GetProcAddress(aDLLHandle, 'igTableSetColumnWidthAutoSingle');
  igTableSettingsAddSettingsHandler := GetProcAddress(aDLLHandle, 'igTableSettingsAddSettingsHandler');
  igTableSettingsCreate := GetProcAddress(aDLLHandle, 'igTableSettingsCreate');
  igTableSettingsFindByID := GetProcAddress(aDLLHandle, 'igTableSettingsFindByID');
  igTableSetupColumn := GetProcAddress(aDLLHandle, 'igTableSetupColumn');
  igTableSetupDrawChannels := GetProcAddress(aDLLHandle, 'igTableSetupDrawChannels');
  igTableSetupScrollFreeze := GetProcAddress(aDLLHandle, 'igTableSetupScrollFreeze');
  igTableSortSpecsBuild := GetProcAddress(aDLLHandle, 'igTableSortSpecsBuild');
  igTableSortSpecsSanitize := GetProcAddress(aDLLHandle, 'igTableSortSpecsSanitize');
  igTableUpdateBorders := GetProcAddress(aDLLHandle, 'igTableUpdateBorders');
  igTableUpdateColumnsWeightFromWidth := GetProcAddress(aDLLHandle, 'igTableUpdateColumnsWeightFromWidth');
  igTableUpdateLayout := GetProcAddress(aDLLHandle, 'igTableUpdateLayout');
  igTeleportMousePos := GetProcAddress(aDLLHandle, 'igTeleportMousePos');
  igTempInputIsActive := GetProcAddress(aDLLHandle, 'igTempInputIsActive');
  igTempInputScalar := GetProcAddress(aDLLHandle, 'igTempInputScalar');
  igTempInputText := GetProcAddress(aDLLHandle, 'igTempInputText');
  igTestKeyOwner := GetProcAddress(aDLLHandle, 'igTestKeyOwner');
  igTestShortcutRouting := GetProcAddress(aDLLHandle, 'igTestShortcutRouting');
  igText := GetProcAddress(aDLLHandle, 'igText');
  igTextColored := GetProcAddress(aDLLHandle, 'igTextColored');
  igTextColoredV := GetProcAddress(aDLLHandle, 'igTextColoredV');
  igTextDisabled := GetProcAddress(aDLLHandle, 'igTextDisabled');
  igTextDisabledV := GetProcAddress(aDLLHandle, 'igTextDisabledV');
  igTextEx := GetProcAddress(aDLLHandle, 'igTextEx');
  igTextLink := GetProcAddress(aDLLHandle, 'igTextLink');
  igTextLinkOpenURL := GetProcAddress(aDLLHandle, 'igTextLinkOpenURL');
  igTextUnformatted := GetProcAddress(aDLLHandle, 'igTextUnformatted');
  igTextV := GetProcAddress(aDLLHandle, 'igTextV');
  igTextWrapped := GetProcAddress(aDLLHandle, 'igTextWrapped');
  igTextWrappedV := GetProcAddress(aDLLHandle, 'igTextWrappedV');
  igTranslateWindowsInViewport := GetProcAddress(aDLLHandle, 'igTranslateWindowsInViewport');
  igTreeNode_Ptr := GetProcAddress(aDLLHandle, 'igTreeNode_Ptr');
  igTreeNode_Str := GetProcAddress(aDLLHandle, 'igTreeNode_Str');
  igTreeNode_StrStr := GetProcAddress(aDLLHandle, 'igTreeNode_StrStr');
  igTreeNodeBehavior := GetProcAddress(aDLLHandle, 'igTreeNodeBehavior');
  igTreeNodeEx_Ptr := GetProcAddress(aDLLHandle, 'igTreeNodeEx_Ptr');
  igTreeNodeEx_Str := GetProcAddress(aDLLHandle, 'igTreeNodeEx_Str');
  igTreeNodeEx_StrStr := GetProcAddress(aDLLHandle, 'igTreeNodeEx_StrStr');
  igTreeNodeExV_Ptr := GetProcAddress(aDLLHandle, 'igTreeNodeExV_Ptr');
  igTreeNodeExV_Str := GetProcAddress(aDLLHandle, 'igTreeNodeExV_Str');
  igTreeNodeGetOpen := GetProcAddress(aDLLHandle, 'igTreeNodeGetOpen');
  igTreeNodeSetOpen := GetProcAddress(aDLLHandle, 'igTreeNodeSetOpen');
  igTreeNodeUpdateNextOpen := GetProcAddress(aDLLHandle, 'igTreeNodeUpdateNextOpen');
  igTreeNodeV_Ptr := GetProcAddress(aDLLHandle, 'igTreeNodeV_Ptr');
  igTreeNodeV_Str := GetProcAddress(aDLLHandle, 'igTreeNodeV_Str');
  igTreePop := GetProcAddress(aDLLHandle, 'igTreePop');
  igTreePush_Ptr := GetProcAddress(aDLLHandle, 'igTreePush_Ptr');
  igTreePush_Str := GetProcAddress(aDLLHandle, 'igTreePush_Str');
  igTreePushOverrideID := GetProcAddress(aDLLHandle, 'igTreePushOverrideID');
  igTypingSelectFindBestLeadingMatch := GetProcAddress(aDLLHandle, 'igTypingSelectFindBestLeadingMatch');
  igTypingSelectFindMatch := GetProcAddress(aDLLHandle, 'igTypingSelectFindMatch');
  igTypingSelectFindNextSingleCharMatch := GetProcAddress(aDLLHandle, 'igTypingSelectFindNextSingleCharMatch');
  igUnindent := GetProcAddress(aDLLHandle, 'igUnindent');
  igUpdateHoveredWindowAndCaptureFlags := GetProcAddress(aDLLHandle, 'igUpdateHoveredWindowAndCaptureFlags');
  igUpdateInputEvents := GetProcAddress(aDLLHandle, 'igUpdateInputEvents');
  igUpdateMouseMovingWindowEndFrame := GetProcAddress(aDLLHandle, 'igUpdateMouseMovingWindowEndFrame');
  igUpdateMouseMovingWindowNewFrame := GetProcAddress(aDLLHandle, 'igUpdateMouseMovingWindowNewFrame');
  igUpdatePlatformWindows := GetProcAddress(aDLLHandle, 'igUpdatePlatformWindows');
  igUpdateWindowParentAndRootLinks := GetProcAddress(aDLLHandle, 'igUpdateWindowParentAndRootLinks');
  igUpdateWindowSkipRefresh := GetProcAddress(aDLLHandle, 'igUpdateWindowSkipRefresh');
  igValue_Bool := GetProcAddress(aDLLHandle, 'igValue_Bool');
  igValue_Float := GetProcAddress(aDLLHandle, 'igValue_Float');
  igValue_Int := GetProcAddress(aDLLHandle, 'igValue_Int');
  igValue_Uint := GetProcAddress(aDLLHandle, 'igValue_Uint');
  igVSliderFloat := GetProcAddress(aDLLHandle, 'igVSliderFloat');
  igVSliderInt := GetProcAddress(aDLLHandle, 'igVSliderInt');
  igVSliderScalar := GetProcAddress(aDLLHandle, 'igVSliderScalar');
  igWindowPosAbsToRel := GetProcAddress(aDLLHandle, 'igWindowPosAbsToRel');
  igWindowPosRelToAbs := GetProcAddress(aDLLHandle, 'igWindowPosRelToAbs');
  igWindowRectAbsToRel := GetProcAddress(aDLLHandle, 'igWindowRectAbsToRel');
  igWindowRectRelToAbs := GetProcAddress(aDLLHandle, 'igWindowRectRelToAbs');
  ImBitVector_Clear := GetProcAddress(aDLLHandle, 'ImBitVector_Clear');
  ImBitVector_ClearBit := GetProcAddress(aDLLHandle, 'ImBitVector_ClearBit');
  ImBitVector_Create := GetProcAddress(aDLLHandle, 'ImBitVector_Create');
  ImBitVector_SetBit := GetProcAddress(aDLLHandle, 'ImBitVector_SetBit');
  ImBitVector_TestBit := GetProcAddress(aDLLHandle, 'ImBitVector_TestBit');
  ImColor_destroy := GetProcAddress(aDLLHandle, 'ImColor_destroy');
  ImColor_HSV := GetProcAddress(aDLLHandle, 'ImColor_HSV');
  ImColor_ImColor_Float := GetProcAddress(aDLLHandle, 'ImColor_ImColor_Float');
  ImColor_ImColor_Int := GetProcAddress(aDLLHandle, 'ImColor_ImColor_Int');
  ImColor_ImColor_Nil := GetProcAddress(aDLLHandle, 'ImColor_ImColor_Nil');
  ImColor_ImColor_U32 := GetProcAddress(aDLLHandle, 'ImColor_ImColor_U32');
  ImColor_ImColor_Vec4 := GetProcAddress(aDLLHandle, 'ImColor_ImColor_Vec4');
  ImColor_SetHSV := GetProcAddress(aDLLHandle, 'ImColor_SetHSV');
  ImDrawCmd_destroy := GetProcAddress(aDLLHandle, 'ImDrawCmd_destroy');
  ImDrawCmd_GetTexID := GetProcAddress(aDLLHandle, 'ImDrawCmd_GetTexID');
  ImDrawCmd_ImDrawCmd := GetProcAddress(aDLLHandle, 'ImDrawCmd_ImDrawCmd');
  ImDrawData_AddDrawList := GetProcAddress(aDLLHandle, 'ImDrawData_AddDrawList');
  ImDrawData_Clear := GetProcAddress(aDLLHandle, 'ImDrawData_Clear');
  ImDrawData_DeIndexAllBuffers := GetProcAddress(aDLLHandle, 'ImDrawData_DeIndexAllBuffers');
  ImDrawData_destroy := GetProcAddress(aDLLHandle, 'ImDrawData_destroy');
  ImDrawData_ImDrawData := GetProcAddress(aDLLHandle, 'ImDrawData_ImDrawData');
  ImDrawData_ScaleClipRects := GetProcAddress(aDLLHandle, 'ImDrawData_ScaleClipRects');
  ImDrawDataBuilder_destroy := GetProcAddress(aDLLHandle, 'ImDrawDataBuilder_destroy');
  ImDrawDataBuilder_ImDrawDataBuilder := GetProcAddress(aDLLHandle, 'ImDrawDataBuilder_ImDrawDataBuilder');
  ImDrawList__CalcCircleAutoSegmentCount := GetProcAddress(aDLLHandle, 'ImDrawList__CalcCircleAutoSegmentCount');
  ImDrawList__ClearFreeMemory := GetProcAddress(aDLLHandle, 'ImDrawList__ClearFreeMemory');
  ImDrawList__OnChangedClipRect := GetProcAddress(aDLLHandle, 'ImDrawList__OnChangedClipRect');
  ImDrawList__OnChangedTextureID := GetProcAddress(aDLLHandle, 'ImDrawList__OnChangedTextureID');
  ImDrawList__OnChangedVtxOffset := GetProcAddress(aDLLHandle, 'ImDrawList__OnChangedVtxOffset');
  ImDrawList__PathArcToFastEx := GetProcAddress(aDLLHandle, 'ImDrawList__PathArcToFastEx');
  ImDrawList__PathArcToN := GetProcAddress(aDLLHandle, 'ImDrawList__PathArcToN');
  ImDrawList__PopUnusedDrawCmd := GetProcAddress(aDLLHandle, 'ImDrawList__PopUnusedDrawCmd');
  ImDrawList__ResetForNewFrame := GetProcAddress(aDLLHandle, 'ImDrawList__ResetForNewFrame');
  ImDrawList__SetTextureID := GetProcAddress(aDLLHandle, 'ImDrawList__SetTextureID');
  ImDrawList__TryMergeDrawCmds := GetProcAddress(aDLLHandle, 'ImDrawList__TryMergeDrawCmds');
  ImDrawList_AddBezierCubic := GetProcAddress(aDLLHandle, 'ImDrawList_AddBezierCubic');
  ImDrawList_AddBezierQuadratic := GetProcAddress(aDLLHandle, 'ImDrawList_AddBezierQuadratic');
  ImDrawList_AddCallback := GetProcAddress(aDLLHandle, 'ImDrawList_AddCallback');
  ImDrawList_AddCircle := GetProcAddress(aDLLHandle, 'ImDrawList_AddCircle');
  ImDrawList_AddCircleFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddCircleFilled');
  ImDrawList_AddConcavePolyFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddConcavePolyFilled');
  ImDrawList_AddConvexPolyFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddConvexPolyFilled');
  ImDrawList_AddDrawCmd := GetProcAddress(aDLLHandle, 'ImDrawList_AddDrawCmd');
  ImDrawList_AddEllipse := GetProcAddress(aDLLHandle, 'ImDrawList_AddEllipse');
  ImDrawList_AddEllipseFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddEllipseFilled');
  ImDrawList_AddImage := GetProcAddress(aDLLHandle, 'ImDrawList_AddImage');
  ImDrawList_AddImageQuad := GetProcAddress(aDLLHandle, 'ImDrawList_AddImageQuad');
  ImDrawList_AddImageRounded := GetProcAddress(aDLLHandle, 'ImDrawList_AddImageRounded');
  ImDrawList_AddLine := GetProcAddress(aDLLHandle, 'ImDrawList_AddLine');
  ImDrawList_AddNgon := GetProcAddress(aDLLHandle, 'ImDrawList_AddNgon');
  ImDrawList_AddNgonFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddNgonFilled');
  ImDrawList_AddPolyline := GetProcAddress(aDLLHandle, 'ImDrawList_AddPolyline');
  ImDrawList_AddQuad := GetProcAddress(aDLLHandle, 'ImDrawList_AddQuad');
  ImDrawList_AddQuadFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddQuadFilled');
  ImDrawList_AddRect := GetProcAddress(aDLLHandle, 'ImDrawList_AddRect');
  ImDrawList_AddRectFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddRectFilled');
  ImDrawList_AddRectFilledMultiColor := GetProcAddress(aDLLHandle, 'ImDrawList_AddRectFilledMultiColor');
  ImDrawList_AddText_FontPtr := GetProcAddress(aDLLHandle, 'ImDrawList_AddText_FontPtr');
  ImDrawList_AddText_Vec2 := GetProcAddress(aDLLHandle, 'ImDrawList_AddText_Vec2');
  ImDrawList_AddTriangle := GetProcAddress(aDLLHandle, 'ImDrawList_AddTriangle');
  ImDrawList_AddTriangleFilled := GetProcAddress(aDLLHandle, 'ImDrawList_AddTriangleFilled');
  ImDrawList_ChannelsMerge := GetProcAddress(aDLLHandle, 'ImDrawList_ChannelsMerge');
  ImDrawList_ChannelsSetCurrent := GetProcAddress(aDLLHandle, 'ImDrawList_ChannelsSetCurrent');
  ImDrawList_ChannelsSplit := GetProcAddress(aDLLHandle, 'ImDrawList_ChannelsSplit');
  ImDrawList_CloneOutput := GetProcAddress(aDLLHandle, 'ImDrawList_CloneOutput');
  ImDrawList_destroy := GetProcAddress(aDLLHandle, 'ImDrawList_destroy');
  ImDrawList_GetClipRectMax := GetProcAddress(aDLLHandle, 'ImDrawList_GetClipRectMax');
  ImDrawList_GetClipRectMin := GetProcAddress(aDLLHandle, 'ImDrawList_GetClipRectMin');
  ImDrawList_ImDrawList := GetProcAddress(aDLLHandle, 'ImDrawList_ImDrawList');
  ImDrawList_PathArcTo := GetProcAddress(aDLLHandle, 'ImDrawList_PathArcTo');
  ImDrawList_PathArcToFast := GetProcAddress(aDLLHandle, 'ImDrawList_PathArcToFast');
  ImDrawList_PathBezierCubicCurveTo := GetProcAddress(aDLLHandle, 'ImDrawList_PathBezierCubicCurveTo');
  ImDrawList_PathBezierQuadraticCurveTo := GetProcAddress(aDLLHandle, 'ImDrawList_PathBezierQuadraticCurveTo');
  ImDrawList_PathClear := GetProcAddress(aDLLHandle, 'ImDrawList_PathClear');
  ImDrawList_PathEllipticalArcTo := GetProcAddress(aDLLHandle, 'ImDrawList_PathEllipticalArcTo');
  ImDrawList_PathFillConcave := GetProcAddress(aDLLHandle, 'ImDrawList_PathFillConcave');
  ImDrawList_PathFillConvex := GetProcAddress(aDLLHandle, 'ImDrawList_PathFillConvex');
  ImDrawList_PathLineTo := GetProcAddress(aDLLHandle, 'ImDrawList_PathLineTo');
  ImDrawList_PathLineToMergeDuplicate := GetProcAddress(aDLLHandle, 'ImDrawList_PathLineToMergeDuplicate');
  ImDrawList_PathRect := GetProcAddress(aDLLHandle, 'ImDrawList_PathRect');
  ImDrawList_PathStroke := GetProcAddress(aDLLHandle, 'ImDrawList_PathStroke');
  ImDrawList_PopClipRect := GetProcAddress(aDLLHandle, 'ImDrawList_PopClipRect');
  ImDrawList_PopTextureID := GetProcAddress(aDLLHandle, 'ImDrawList_PopTextureID');
  ImDrawList_PrimQuadUV := GetProcAddress(aDLLHandle, 'ImDrawList_PrimQuadUV');
  ImDrawList_PrimRect := GetProcAddress(aDLLHandle, 'ImDrawList_PrimRect');
  ImDrawList_PrimRectUV := GetProcAddress(aDLLHandle, 'ImDrawList_PrimRectUV');
  ImDrawList_PrimReserve := GetProcAddress(aDLLHandle, 'ImDrawList_PrimReserve');
  ImDrawList_PrimUnreserve := GetProcAddress(aDLLHandle, 'ImDrawList_PrimUnreserve');
  ImDrawList_PrimVtx := GetProcAddress(aDLLHandle, 'ImDrawList_PrimVtx');
  ImDrawList_PrimWriteIdx := GetProcAddress(aDLLHandle, 'ImDrawList_PrimWriteIdx');
  ImDrawList_PrimWriteVtx := GetProcAddress(aDLLHandle, 'ImDrawList_PrimWriteVtx');
  ImDrawList_PushClipRect := GetProcAddress(aDLLHandle, 'ImDrawList_PushClipRect');
  ImDrawList_PushClipRectFullScreen := GetProcAddress(aDLLHandle, 'ImDrawList_PushClipRectFullScreen');
  ImDrawList_PushTextureID := GetProcAddress(aDLLHandle, 'ImDrawList_PushTextureID');
  ImDrawListSharedData_destroy := GetProcAddress(aDLLHandle, 'ImDrawListSharedData_destroy');
  ImDrawListSharedData_ImDrawListSharedData := GetProcAddress(aDLLHandle, 'ImDrawListSharedData_ImDrawListSharedData');
  ImDrawListSharedData_SetCircleTessellationMaxError := GetProcAddress(aDLLHandle, 'ImDrawListSharedData_SetCircleTessellationMaxError');
  ImDrawListSplitter_Clear := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_Clear');
  ImDrawListSplitter_ClearFreeMemory := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_ClearFreeMemory');
  ImDrawListSplitter_destroy := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_destroy');
  ImDrawListSplitter_ImDrawListSplitter := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_ImDrawListSplitter');
  ImDrawListSplitter_Merge := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_Merge');
  ImDrawListSplitter_SetCurrentChannel := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_SetCurrentChannel');
  ImDrawListSplitter_Split := GetProcAddress(aDLLHandle, 'ImDrawListSplitter_Split');
  ImFont_AddGlyph := GetProcAddress(aDLLHandle, 'ImFont_AddGlyph');
  ImFont_AddRemapChar := GetProcAddress(aDLLHandle, 'ImFont_AddRemapChar');
  ImFont_BuildLookupTable := GetProcAddress(aDLLHandle, 'ImFont_BuildLookupTable');
  ImFont_CalcTextSizeA := GetProcAddress(aDLLHandle, 'ImFont_CalcTextSizeA');
  ImFont_CalcWordWrapPositionA := GetProcAddress(aDLLHandle, 'ImFont_CalcWordWrapPositionA');
  ImFont_ClearOutputData := GetProcAddress(aDLLHandle, 'ImFont_ClearOutputData');
  ImFont_destroy := GetProcAddress(aDLLHandle, 'ImFont_destroy');
  ImFont_FindGlyph := GetProcAddress(aDLLHandle, 'ImFont_FindGlyph');
  ImFont_FindGlyphNoFallback := GetProcAddress(aDLLHandle, 'ImFont_FindGlyphNoFallback');
  ImFont_GetCharAdvance := GetProcAddress(aDLLHandle, 'ImFont_GetCharAdvance');
  ImFont_GetDebugName := GetProcAddress(aDLLHandle, 'ImFont_GetDebugName');
  ImFont_GrowIndex := GetProcAddress(aDLLHandle, 'ImFont_GrowIndex');
  ImFont_ImFont := GetProcAddress(aDLLHandle, 'ImFont_ImFont');
  ImFont_IsGlyphRangeUnused := GetProcAddress(aDLLHandle, 'ImFont_IsGlyphRangeUnused');
  ImFont_IsLoaded := GetProcAddress(aDLLHandle, 'ImFont_IsLoaded');
  ImFont_RenderChar := GetProcAddress(aDLLHandle, 'ImFont_RenderChar');
  ImFont_RenderText := GetProcAddress(aDLLHandle, 'ImFont_RenderText');
  ImFontAtlas_AddCustomRectFontGlyph := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddCustomRectFontGlyph');
  ImFontAtlas_AddCustomRectRegular := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddCustomRectRegular');
  ImFontAtlas_AddFont := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFont');
  ImFontAtlas_AddFontDefault := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFontDefault');
  ImFontAtlas_AddFontFromFileTTF := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFontFromFileTTF');
  ImFontAtlas_AddFontFromMemoryCompressedBase85TTF := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFontFromMemoryCompressedBase85TTF');
  ImFontAtlas_AddFontFromMemoryCompressedTTF := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFontFromMemoryCompressedTTF');
  ImFontAtlas_AddFontFromMemoryTTF := GetProcAddress(aDLLHandle, 'ImFontAtlas_AddFontFromMemoryTTF');
  ImFontAtlas_Build := GetProcAddress(aDLLHandle, 'ImFontAtlas_Build');
  ImFontAtlas_CalcCustomRectUV := GetProcAddress(aDLLHandle, 'ImFontAtlas_CalcCustomRectUV');
  ImFontAtlas_Clear := GetProcAddress(aDLLHandle, 'ImFontAtlas_Clear');
  ImFontAtlas_ClearFonts := GetProcAddress(aDLLHandle, 'ImFontAtlas_ClearFonts');
  ImFontAtlas_ClearInputData := GetProcAddress(aDLLHandle, 'ImFontAtlas_ClearInputData');
  ImFontAtlas_ClearTexData := GetProcAddress(aDLLHandle, 'ImFontAtlas_ClearTexData');
  ImFontAtlas_destroy := GetProcAddress(aDLLHandle, 'ImFontAtlas_destroy');
  ImFontAtlas_GetCustomRectByIndex := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetCustomRectByIndex');
  ImFontAtlas_GetGlyphRangesChineseFull := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesChineseFull');
  ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon');
  ImFontAtlas_GetGlyphRangesCyrillic := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesCyrillic');
  ImFontAtlas_GetGlyphRangesDefault := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesDefault');
  ImFontAtlas_GetGlyphRangesGreek := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesGreek');
  ImFontAtlas_GetGlyphRangesJapanese := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesJapanese');
  ImFontAtlas_GetGlyphRangesKorean := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesKorean');
  ImFontAtlas_GetGlyphRangesThai := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesThai');
  ImFontAtlas_GetGlyphRangesVietnamese := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetGlyphRangesVietnamese');
  ImFontAtlas_GetTexDataAsAlpha8 := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetTexDataAsAlpha8');
  ImFontAtlas_GetTexDataAsRGBA32 := GetProcAddress(aDLLHandle, 'ImFontAtlas_GetTexDataAsRGBA32');
  ImFontAtlas_ImFontAtlas := GetProcAddress(aDLLHandle, 'ImFontAtlas_ImFontAtlas');
  ImFontAtlas_IsBuilt := GetProcAddress(aDLLHandle, 'ImFontAtlas_IsBuilt');
  ImFontAtlas_SetTexID := GetProcAddress(aDLLHandle, 'ImFontAtlas_SetTexID');
  ImFontAtlasCustomRect_destroy := GetProcAddress(aDLLHandle, 'ImFontAtlasCustomRect_destroy');
  ImFontAtlasCustomRect_ImFontAtlasCustomRect := GetProcAddress(aDLLHandle, 'ImFontAtlasCustomRect_ImFontAtlasCustomRect');
  ImFontAtlasCustomRect_IsPacked := GetProcAddress(aDLLHandle, 'ImFontAtlasCustomRect_IsPacked');
  ImFontConfig_destroy := GetProcAddress(aDLLHandle, 'ImFontConfig_destroy');
  ImFontConfig_ImFontConfig := GetProcAddress(aDLLHandle, 'ImFontConfig_ImFontConfig');
  ImFontGlyphRangesBuilder_AddChar := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_AddChar');
  ImFontGlyphRangesBuilder_AddRanges := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_AddRanges');
  ImFontGlyphRangesBuilder_AddText := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_AddText');
  ImFontGlyphRangesBuilder_BuildRanges := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_BuildRanges');
  ImFontGlyphRangesBuilder_Clear := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_Clear');
  ImFontGlyphRangesBuilder_destroy := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_destroy');
  ImFontGlyphRangesBuilder_GetBit := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_GetBit');
  ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder');
  ImFontGlyphRangesBuilder_SetBit := GetProcAddress(aDLLHandle, 'ImFontGlyphRangesBuilder_SetBit');
  ImGui_ImplGlfw_CharCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_CharCallback');
  ImGui_ImplGlfw_CursorEnterCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_CursorEnterCallback');
  ImGui_ImplGlfw_CursorPosCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_CursorPosCallback');
  ImGui_ImplGlfw_InitForOpenGL := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_InitForOpenGL');
  ImGui_ImplGlfw_InitForOther := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_InitForOther');
  ImGui_ImplGlfw_InitForVulkan := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_InitForVulkan');
  ImGui_ImplGlfw_InstallCallbacks := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_InstallCallbacks');
  ImGui_ImplGlfw_KeyCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_KeyCallback');
  ImGui_ImplGlfw_MonitorCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_MonitorCallback');
  ImGui_ImplGlfw_MouseButtonCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_MouseButtonCallback');
  ImGui_ImplGlfw_NewFrame := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_NewFrame');
  ImGui_ImplGlfw_RestoreCallbacks := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_RestoreCallbacks');
  ImGui_ImplGlfw_ScrollCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_ScrollCallback');
  ImGui_ImplGlfw_SetCallbacksChainForAllWindows := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_SetCallbacksChainForAllWindows');
  ImGui_ImplGlfw_Shutdown := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_Shutdown');
  ImGui_ImplGlfw_Sleep := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_Sleep');
  ImGui_ImplGlfw_WindowFocusCallback := GetProcAddress(aDLLHandle, 'ImGui_ImplGlfw_WindowFocusCallback');
  ImGui_ImplOpenGL2_CreateDeviceObjects := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_CreateDeviceObjects');
  ImGui_ImplOpenGL2_CreateFontsTexture := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_CreateFontsTexture');
  ImGui_ImplOpenGL2_DestroyDeviceObjects := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_DestroyDeviceObjects');
  ImGui_ImplOpenGL2_DestroyFontsTexture := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_DestroyFontsTexture');
  ImGui_ImplOpenGL2_Init := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_Init');
  ImGui_ImplOpenGL2_NewFrame := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_NewFrame');
  ImGui_ImplOpenGL2_RenderDrawData := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_RenderDrawData');
  ImGui_ImplOpenGL2_Shutdown := GetProcAddress(aDLLHandle, 'ImGui_ImplOpenGL2_Shutdown');
  ImGuiBoxSelectState_destroy := GetProcAddress(aDLLHandle, 'ImGuiBoxSelectState_destroy');
  ImGuiBoxSelectState_ImGuiBoxSelectState := GetProcAddress(aDLLHandle, 'ImGuiBoxSelectState_ImGuiBoxSelectState');
  ImGuiComboPreviewData_destroy := GetProcAddress(aDLLHandle, 'ImGuiComboPreviewData_destroy');
  ImGuiComboPreviewData_ImGuiComboPreviewData := GetProcAddress(aDLLHandle, 'ImGuiComboPreviewData_ImGuiComboPreviewData');
  ImGuiContext_destroy := GetProcAddress(aDLLHandle, 'ImGuiContext_destroy');
  ImGuiContext_ImGuiContext := GetProcAddress(aDLLHandle, 'ImGuiContext_ImGuiContext');
  ImGuiContextHook_destroy := GetProcAddress(aDLLHandle, 'ImGuiContextHook_destroy');
  ImGuiContextHook_ImGuiContextHook := GetProcAddress(aDLLHandle, 'ImGuiContextHook_ImGuiContextHook');
  ImGuiDebugAllocInfo_destroy := GetProcAddress(aDLLHandle, 'ImGuiDebugAllocInfo_destroy');
  ImGuiDebugAllocInfo_ImGuiDebugAllocInfo := GetProcAddress(aDLLHandle, 'ImGuiDebugAllocInfo_ImGuiDebugAllocInfo');
  ImGuiDockContext_destroy := GetProcAddress(aDLLHandle, 'ImGuiDockContext_destroy');
  ImGuiDockContext_ImGuiDockContext := GetProcAddress(aDLLHandle, 'ImGuiDockContext_ImGuiDockContext');
  ImGuiDockNode_destroy := GetProcAddress(aDLLHandle, 'ImGuiDockNode_destroy');
  ImGuiDockNode_ImGuiDockNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_ImGuiDockNode');
  ImGuiDockNode_IsCentralNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsCentralNode');
  ImGuiDockNode_IsDockSpace := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsDockSpace');
  ImGuiDockNode_IsEmpty := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsEmpty');
  ImGuiDockNode_IsFloatingNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsFloatingNode');
  ImGuiDockNode_IsHiddenTabBar := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsHiddenTabBar');
  ImGuiDockNode_IsLeafNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsLeafNode');
  ImGuiDockNode_IsNoTabBar := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsNoTabBar');
  ImGuiDockNode_IsRootNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsRootNode');
  ImGuiDockNode_IsSplitNode := GetProcAddress(aDLLHandle, 'ImGuiDockNode_IsSplitNode');
  ImGuiDockNode_Rect := GetProcAddress(aDLLHandle, 'ImGuiDockNode_Rect');
  ImGuiDockNode_SetLocalFlags := GetProcAddress(aDLLHandle, 'ImGuiDockNode_SetLocalFlags');
  ImGuiDockNode_UpdateMergedFlags := GetProcAddress(aDLLHandle, 'ImGuiDockNode_UpdateMergedFlags');
  ImGuiErrorRecoveryState_destroy := GetProcAddress(aDLLHandle, 'ImGuiErrorRecoveryState_destroy');
  ImGuiErrorRecoveryState_ImGuiErrorRecoveryState := GetProcAddress(aDLLHandle, 'ImGuiErrorRecoveryState_ImGuiErrorRecoveryState');
  ImGuiIDStackTool_destroy := GetProcAddress(aDLLHandle, 'ImGuiIDStackTool_destroy');
  ImGuiIDStackTool_ImGuiIDStackTool := GetProcAddress(aDLLHandle, 'ImGuiIDStackTool_ImGuiIDStackTool');
  ImGuiInputEvent_destroy := GetProcAddress(aDLLHandle, 'ImGuiInputEvent_destroy');
  ImGuiInputEvent_ImGuiInputEvent := GetProcAddress(aDLLHandle, 'ImGuiInputEvent_ImGuiInputEvent');
  ImGuiInputTextCallbackData_ClearSelection := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_ClearSelection');
  ImGuiInputTextCallbackData_DeleteChars := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_DeleteChars');
  ImGuiInputTextCallbackData_destroy := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_destroy');
  ImGuiInputTextCallbackData_HasSelection := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_HasSelection');
  ImGuiInputTextCallbackData_ImGuiInputTextCallbackData := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_ImGuiInputTextCallbackData');
  ImGuiInputTextCallbackData_InsertChars := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_InsertChars');
  ImGuiInputTextCallbackData_SelectAll := GetProcAddress(aDLLHandle, 'ImGuiInputTextCallbackData_SelectAll');
  ImGuiInputTextDeactivatedState_ClearFreeMemory := GetProcAddress(aDLLHandle, 'ImGuiInputTextDeactivatedState_ClearFreeMemory');
  ImGuiInputTextDeactivatedState_destroy := GetProcAddress(aDLLHandle, 'ImGuiInputTextDeactivatedState_destroy');
  ImGuiInputTextDeactivatedState_ImGuiInputTextDeactivatedState := GetProcAddress(aDLLHandle, 'ImGuiInputTextDeactivatedState_ImGuiInputTextDeactivatedState');
  ImGuiInputTextState_ClearFreeMemory := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ClearFreeMemory');
  ImGuiInputTextState_ClearSelection := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ClearSelection');
  ImGuiInputTextState_ClearText := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ClearText');
  ImGuiInputTextState_CursorAnimReset := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_CursorAnimReset');
  ImGuiInputTextState_CursorClamp := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_CursorClamp');
  ImGuiInputTextState_destroy := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_destroy');
  ImGuiInputTextState_GetCursorPos := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_GetCursorPos');
  ImGuiInputTextState_GetSelectionEnd := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_GetSelectionEnd');
  ImGuiInputTextState_GetSelectionStart := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_GetSelectionStart');
  ImGuiInputTextState_HasSelection := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_HasSelection');
  ImGuiInputTextState_ImGuiInputTextState := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ImGuiInputTextState');
  ImGuiInputTextState_OnCharPressed := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_OnCharPressed');
  ImGuiInputTextState_OnKeyPressed := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_OnKeyPressed');
  ImGuiInputTextState_ReloadUserBufAndKeepSelection := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ReloadUserBufAndKeepSelection');
  ImGuiInputTextState_ReloadUserBufAndMoveToEnd := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ReloadUserBufAndMoveToEnd');
  ImGuiInputTextState_ReloadUserBufAndSelectAll := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_ReloadUserBufAndSelectAll');
  ImGuiInputTextState_SelectAll := GetProcAddress(aDLLHandle, 'ImGuiInputTextState_SelectAll');
  ImGuiIO_AddFocusEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddFocusEvent');
  ImGuiIO_AddInputCharacter := GetProcAddress(aDLLHandle, 'ImGuiIO_AddInputCharacter');
  ImGuiIO_AddInputCharactersUTF8 := GetProcAddress(aDLLHandle, 'ImGuiIO_AddInputCharactersUTF8');
  ImGuiIO_AddInputCharacterUTF16 := GetProcAddress(aDLLHandle, 'ImGuiIO_AddInputCharacterUTF16');
  ImGuiIO_AddKeyAnalogEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddKeyAnalogEvent');
  ImGuiIO_AddKeyEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddKeyEvent');
  ImGuiIO_AddMouseButtonEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddMouseButtonEvent');
  ImGuiIO_AddMousePosEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddMousePosEvent');
  ImGuiIO_AddMouseSourceEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddMouseSourceEvent');
  ImGuiIO_AddMouseViewportEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddMouseViewportEvent');
  ImGuiIO_AddMouseWheelEvent := GetProcAddress(aDLLHandle, 'ImGuiIO_AddMouseWheelEvent');
  ImGuiIO_ClearEventsQueue := GetProcAddress(aDLLHandle, 'ImGuiIO_ClearEventsQueue');
  ImGuiIO_ClearInputKeys := GetProcAddress(aDLLHandle, 'ImGuiIO_ClearInputKeys');
  ImGuiIO_ClearInputMouse := GetProcAddress(aDLLHandle, 'ImGuiIO_ClearInputMouse');
  ImGuiIO_destroy := GetProcAddress(aDLLHandle, 'ImGuiIO_destroy');
  ImGuiIO_ImGuiIO := GetProcAddress(aDLLHandle, 'ImGuiIO_ImGuiIO');
  ImGuiIO_SetAppAcceptingEvents := GetProcAddress(aDLLHandle, 'ImGuiIO_SetAppAcceptingEvents');
  ImGuiIO_SetKeyEventNativeData := GetProcAddress(aDLLHandle, 'ImGuiIO_SetKeyEventNativeData');
  ImGuiKeyOwnerData_destroy := GetProcAddress(aDLLHandle, 'ImGuiKeyOwnerData_destroy');
  ImGuiKeyOwnerData_ImGuiKeyOwnerData := GetProcAddress(aDLLHandle, 'ImGuiKeyOwnerData_ImGuiKeyOwnerData');
  ImGuiKeyRoutingData_destroy := GetProcAddress(aDLLHandle, 'ImGuiKeyRoutingData_destroy');
  ImGuiKeyRoutingData_ImGuiKeyRoutingData := GetProcAddress(aDLLHandle, 'ImGuiKeyRoutingData_ImGuiKeyRoutingData');
  ImGuiKeyRoutingTable_Clear := GetProcAddress(aDLLHandle, 'ImGuiKeyRoutingTable_Clear');
  ImGuiKeyRoutingTable_destroy := GetProcAddress(aDLLHandle, 'ImGuiKeyRoutingTable_destroy');
  ImGuiKeyRoutingTable_ImGuiKeyRoutingTable := GetProcAddress(aDLLHandle, 'ImGuiKeyRoutingTable_ImGuiKeyRoutingTable');
  ImGuiLastItemData_destroy := GetProcAddress(aDLLHandle, 'ImGuiLastItemData_destroy');
  ImGuiLastItemData_ImGuiLastItemData := GetProcAddress(aDLLHandle, 'ImGuiLastItemData_ImGuiLastItemData');
  ImGuiListClipper_Begin := GetProcAddress(aDLLHandle, 'ImGuiListClipper_Begin');
  ImGuiListClipper_destroy := GetProcAddress(aDLLHandle, 'ImGuiListClipper_destroy');
  ImGuiListClipper_End := GetProcAddress(aDLLHandle, 'ImGuiListClipper_End');
  ImGuiListClipper_ImGuiListClipper := GetProcAddress(aDLLHandle, 'ImGuiListClipper_ImGuiListClipper');
  ImGuiListClipper_IncludeItemByIndex := GetProcAddress(aDLLHandle, 'ImGuiListClipper_IncludeItemByIndex');
  ImGuiListClipper_IncludeItemsByIndex := GetProcAddress(aDLLHandle, 'ImGuiListClipper_IncludeItemsByIndex');
  ImGuiListClipper_SeekCursorForItem := GetProcAddress(aDLLHandle, 'ImGuiListClipper_SeekCursorForItem');
  ImGuiListClipper_Step := GetProcAddress(aDLLHandle, 'ImGuiListClipper_Step');
  ImGuiListClipperData_destroy := GetProcAddress(aDLLHandle, 'ImGuiListClipperData_destroy');
  ImGuiListClipperData_ImGuiListClipperData := GetProcAddress(aDLLHandle, 'ImGuiListClipperData_ImGuiListClipperData');
  ImGuiListClipperData_Reset := GetProcAddress(aDLLHandle, 'ImGuiListClipperData_Reset');
  ImGuiListClipperRange_FromIndices := GetProcAddress(aDLLHandle, 'ImGuiListClipperRange_FromIndices');
  ImGuiListClipperRange_FromPositions := GetProcAddress(aDLLHandle, 'ImGuiListClipperRange_FromPositions');
  ImGuiMenuColumns_CalcNextTotalWidth := GetProcAddress(aDLLHandle, 'ImGuiMenuColumns_CalcNextTotalWidth');
  ImGuiMenuColumns_DeclColumns := GetProcAddress(aDLLHandle, 'ImGuiMenuColumns_DeclColumns');
  ImGuiMenuColumns_destroy := GetProcAddress(aDLLHandle, 'ImGuiMenuColumns_destroy');
  ImGuiMenuColumns_ImGuiMenuColumns := GetProcAddress(aDLLHandle, 'ImGuiMenuColumns_ImGuiMenuColumns');
  ImGuiMenuColumns_Update := GetProcAddress(aDLLHandle, 'ImGuiMenuColumns_Update');
  ImGuiMultiSelectState_destroy := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectState_destroy');
  ImGuiMultiSelectState_ImGuiMultiSelectState := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectState_ImGuiMultiSelectState');
  ImGuiMultiSelectTempData_Clear := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectTempData_Clear');
  ImGuiMultiSelectTempData_ClearIO := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectTempData_ClearIO');
  ImGuiMultiSelectTempData_destroy := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectTempData_destroy');
  ImGuiMultiSelectTempData_ImGuiMultiSelectTempData := GetProcAddress(aDLLHandle, 'ImGuiMultiSelectTempData_ImGuiMultiSelectTempData');
  ImGuiNavItemData_Clear := GetProcAddress(aDLLHandle, 'ImGuiNavItemData_Clear');
  ImGuiNavItemData_destroy := GetProcAddress(aDLLHandle, 'ImGuiNavItemData_destroy');
  ImGuiNavItemData_ImGuiNavItemData := GetProcAddress(aDLLHandle, 'ImGuiNavItemData_ImGuiNavItemData');
  ImGuiNextItemData_ClearFlags := GetProcAddress(aDLLHandle, 'ImGuiNextItemData_ClearFlags');
  ImGuiNextItemData_destroy := GetProcAddress(aDLLHandle, 'ImGuiNextItemData_destroy');
  ImGuiNextItemData_ImGuiNextItemData := GetProcAddress(aDLLHandle, 'ImGuiNextItemData_ImGuiNextItemData');
  ImGuiNextWindowData_ClearFlags := GetProcAddress(aDLLHandle, 'ImGuiNextWindowData_ClearFlags');
  ImGuiNextWindowData_destroy := GetProcAddress(aDLLHandle, 'ImGuiNextWindowData_destroy');
  ImGuiNextWindowData_ImGuiNextWindowData := GetProcAddress(aDLLHandle, 'ImGuiNextWindowData_ImGuiNextWindowData');
  ImGuiOldColumnData_destroy := GetProcAddress(aDLLHandle, 'ImGuiOldColumnData_destroy');
  ImGuiOldColumnData_ImGuiOldColumnData := GetProcAddress(aDLLHandle, 'ImGuiOldColumnData_ImGuiOldColumnData');
  ImGuiOldColumns_destroy := GetProcAddress(aDLLHandle, 'ImGuiOldColumns_destroy');
  ImGuiOldColumns_ImGuiOldColumns := GetProcAddress(aDLLHandle, 'ImGuiOldColumns_ImGuiOldColumns');
  ImGuiOnceUponAFrame_destroy := GetProcAddress(aDLLHandle, 'ImGuiOnceUponAFrame_destroy');
  ImGuiOnceUponAFrame_ImGuiOnceUponAFrame := GetProcAddress(aDLLHandle, 'ImGuiOnceUponAFrame_ImGuiOnceUponAFrame');
  ImGuiPayload_Clear := GetProcAddress(aDLLHandle, 'ImGuiPayload_Clear');
  ImGuiPayload_destroy := GetProcAddress(aDLLHandle, 'ImGuiPayload_destroy');
  ImGuiPayload_ImGuiPayload := GetProcAddress(aDLLHandle, 'ImGuiPayload_ImGuiPayload');
  ImGuiPayload_IsDataType := GetProcAddress(aDLLHandle, 'ImGuiPayload_IsDataType');
  ImGuiPayload_IsDelivery := GetProcAddress(aDLLHandle, 'ImGuiPayload_IsDelivery');
  ImGuiPayload_IsPreview := GetProcAddress(aDLLHandle, 'ImGuiPayload_IsPreview');
  ImGuiPlatformImeData_destroy := GetProcAddress(aDLLHandle, 'ImGuiPlatformImeData_destroy');
  ImGuiPlatformImeData_ImGuiPlatformImeData := GetProcAddress(aDLLHandle, 'ImGuiPlatformImeData_ImGuiPlatformImeData');
  ImGuiPlatformIO_destroy := GetProcAddress(aDLLHandle, 'ImGuiPlatformIO_destroy');
  ImGuiPlatformIO_ImGuiPlatformIO := GetProcAddress(aDLLHandle, 'ImGuiPlatformIO_ImGuiPlatformIO');
  ImGuiPlatformIO_Set_Platform_GetWindowPos := GetProcAddress(aDLLHandle, 'ImGuiPlatformIO_Set_Platform_GetWindowPos');
  ImGuiPlatformIO_Set_Platform_GetWindowSize := GetProcAddress(aDLLHandle, 'ImGuiPlatformIO_Set_Platform_GetWindowSize');
  ImGuiPlatformMonitor_destroy := GetProcAddress(aDLLHandle, 'ImGuiPlatformMonitor_destroy');
  ImGuiPlatformMonitor_ImGuiPlatformMonitor := GetProcAddress(aDLLHandle, 'ImGuiPlatformMonitor_ImGuiPlatformMonitor');
  ImGuiPopupData_destroy := GetProcAddress(aDLLHandle, 'ImGuiPopupData_destroy');
  ImGuiPopupData_ImGuiPopupData := GetProcAddress(aDLLHandle, 'ImGuiPopupData_ImGuiPopupData');
  ImGuiPtrOrIndex_destroy := GetProcAddress(aDLLHandle, 'ImGuiPtrOrIndex_destroy');
  ImGuiPtrOrIndex_ImGuiPtrOrIndex_Int := GetProcAddress(aDLLHandle, 'ImGuiPtrOrIndex_ImGuiPtrOrIndex_Int');
  ImGuiPtrOrIndex_ImGuiPtrOrIndex_Ptr := GetProcAddress(aDLLHandle, 'ImGuiPtrOrIndex_ImGuiPtrOrIndex_Ptr');
  ImGuiSelectionBasicStorage_ApplyRequests := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_ApplyRequests');
  ImGuiSelectionBasicStorage_Clear := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_Clear');
  ImGuiSelectionBasicStorage_Contains := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_Contains');
  ImGuiSelectionBasicStorage_destroy := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_destroy');
  ImGuiSelectionBasicStorage_GetNextSelectedItem := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_GetNextSelectedItem');
  ImGuiSelectionBasicStorage_GetStorageIdFromIndex := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_GetStorageIdFromIndex');
  ImGuiSelectionBasicStorage_ImGuiSelectionBasicStorage := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_ImGuiSelectionBasicStorage');
  ImGuiSelectionBasicStorage_SetItemSelected := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_SetItemSelected');
  ImGuiSelectionBasicStorage_Swap := GetProcAddress(aDLLHandle, 'ImGuiSelectionBasicStorage_Swap');
  ImGuiSelectionExternalStorage_ApplyRequests := GetProcAddress(aDLLHandle, 'ImGuiSelectionExternalStorage_ApplyRequests');
  ImGuiSelectionExternalStorage_destroy := GetProcAddress(aDLLHandle, 'ImGuiSelectionExternalStorage_destroy');
  ImGuiSelectionExternalStorage_ImGuiSelectionExternalStorage := GetProcAddress(aDLLHandle, 'ImGuiSelectionExternalStorage_ImGuiSelectionExternalStorage');
  ImGuiSettingsHandler_destroy := GetProcAddress(aDLLHandle, 'ImGuiSettingsHandler_destroy');
  ImGuiSettingsHandler_ImGuiSettingsHandler := GetProcAddress(aDLLHandle, 'ImGuiSettingsHandler_ImGuiSettingsHandler');
  ImGuiStackLevelInfo_destroy := GetProcAddress(aDLLHandle, 'ImGuiStackLevelInfo_destroy');
  ImGuiStackLevelInfo_ImGuiStackLevelInfo := GetProcAddress(aDLLHandle, 'ImGuiStackLevelInfo_ImGuiStackLevelInfo');
  ImGuiStorage_BuildSortByKey := GetProcAddress(aDLLHandle, 'ImGuiStorage_BuildSortByKey');
  ImGuiStorage_Clear := GetProcAddress(aDLLHandle, 'ImGuiStorage_Clear');
  ImGuiStorage_GetBool := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetBool');
  ImGuiStorage_GetBoolRef := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetBoolRef');
  ImGuiStorage_GetFloat := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetFloat');
  ImGuiStorage_GetFloatRef := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetFloatRef');
  ImGuiStorage_GetInt := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetInt');
  ImGuiStorage_GetIntRef := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetIntRef');
  ImGuiStorage_GetVoidPtr := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetVoidPtr');
  ImGuiStorage_GetVoidPtrRef := GetProcAddress(aDLLHandle, 'ImGuiStorage_GetVoidPtrRef');
  ImGuiStorage_SetAllInt := GetProcAddress(aDLLHandle, 'ImGuiStorage_SetAllInt');
  ImGuiStorage_SetBool := GetProcAddress(aDLLHandle, 'ImGuiStorage_SetBool');
  ImGuiStorage_SetFloat := GetProcAddress(aDLLHandle, 'ImGuiStorage_SetFloat');
  ImGuiStorage_SetInt := GetProcAddress(aDLLHandle, 'ImGuiStorage_SetInt');
  ImGuiStorage_SetVoidPtr := GetProcAddress(aDLLHandle, 'ImGuiStorage_SetVoidPtr');
  ImGuiStoragePair_destroy := GetProcAddress(aDLLHandle, 'ImGuiStoragePair_destroy');
  ImGuiStoragePair_ImGuiStoragePair_Float := GetProcAddress(aDLLHandle, 'ImGuiStoragePair_ImGuiStoragePair_Float');
  ImGuiStoragePair_ImGuiStoragePair_Int := GetProcAddress(aDLLHandle, 'ImGuiStoragePair_ImGuiStoragePair_Int');
  ImGuiStoragePair_ImGuiStoragePair_Ptr := GetProcAddress(aDLLHandle, 'ImGuiStoragePair_ImGuiStoragePair_Ptr');
  ImGuiStyle_destroy := GetProcAddress(aDLLHandle, 'ImGuiStyle_destroy');
  ImGuiStyle_ImGuiStyle := GetProcAddress(aDLLHandle, 'ImGuiStyle_ImGuiStyle');
  ImGuiStyle_ScaleAllSizes := GetProcAddress(aDLLHandle, 'ImGuiStyle_ScaleAllSizes');
  ImGuiStyleMod_destroy := GetProcAddress(aDLLHandle, 'ImGuiStyleMod_destroy');
  ImGuiStyleMod_ImGuiStyleMod_Float := GetProcAddress(aDLLHandle, 'ImGuiStyleMod_ImGuiStyleMod_Float');
  ImGuiStyleMod_ImGuiStyleMod_Int := GetProcAddress(aDLLHandle, 'ImGuiStyleMod_ImGuiStyleMod_Int');
  ImGuiStyleMod_ImGuiStyleMod_Vec2 := GetProcAddress(aDLLHandle, 'ImGuiStyleMod_ImGuiStyleMod_Vec2');
  ImGuiStyleVarInfo_GetVarPtr := GetProcAddress(aDLLHandle, 'ImGuiStyleVarInfo_GetVarPtr');
  ImGuiTabBar_destroy := GetProcAddress(aDLLHandle, 'ImGuiTabBar_destroy');
  ImGuiTabBar_ImGuiTabBar := GetProcAddress(aDLLHandle, 'ImGuiTabBar_ImGuiTabBar');
  ImGuiTabItem_destroy := GetProcAddress(aDLLHandle, 'ImGuiTabItem_destroy');
  ImGuiTabItem_ImGuiTabItem := GetProcAddress(aDLLHandle, 'ImGuiTabItem_ImGuiTabItem');
  ImGuiTable_destroy := GetProcAddress(aDLLHandle, 'ImGuiTable_destroy');
  ImGuiTable_ImGuiTable := GetProcAddress(aDLLHandle, 'ImGuiTable_ImGuiTable');
  ImGuiTableColumn_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableColumn_destroy');
  ImGuiTableColumn_ImGuiTableColumn := GetProcAddress(aDLLHandle, 'ImGuiTableColumn_ImGuiTableColumn');
  ImGuiTableColumnSettings_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableColumnSettings_destroy');
  ImGuiTableColumnSettings_ImGuiTableColumnSettings := GetProcAddress(aDLLHandle, 'ImGuiTableColumnSettings_ImGuiTableColumnSettings');
  ImGuiTableColumnSortSpecs_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableColumnSortSpecs_destroy');
  ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs := GetProcAddress(aDLLHandle, 'ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs');
  ImGuiTableInstanceData_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableInstanceData_destroy');
  ImGuiTableInstanceData_ImGuiTableInstanceData := GetProcAddress(aDLLHandle, 'ImGuiTableInstanceData_ImGuiTableInstanceData');
  ImGuiTableSettings_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableSettings_destroy');
  ImGuiTableSettings_GetColumnSettings := GetProcAddress(aDLLHandle, 'ImGuiTableSettings_GetColumnSettings');
  ImGuiTableSettings_ImGuiTableSettings := GetProcAddress(aDLLHandle, 'ImGuiTableSettings_ImGuiTableSettings');
  ImGuiTableSortSpecs_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableSortSpecs_destroy');
  ImGuiTableSortSpecs_ImGuiTableSortSpecs := GetProcAddress(aDLLHandle, 'ImGuiTableSortSpecs_ImGuiTableSortSpecs');
  ImGuiTableTempData_destroy := GetProcAddress(aDLLHandle, 'ImGuiTableTempData_destroy');
  ImGuiTableTempData_ImGuiTableTempData := GetProcAddress(aDLLHandle, 'ImGuiTableTempData_ImGuiTableTempData');
  ImGuiTextBuffer_append := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_append');
  ImGuiTextBuffer_appendf := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_appendf');
  ImGuiTextBuffer_appendfv := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_appendfv');
  ImGuiTextBuffer_begin := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_begin');
  ImGuiTextBuffer_c_str := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_c_str');
  ImGuiTextBuffer_clear := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_clear');
  ImGuiTextBuffer_destroy := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_destroy');
  ImGuiTextBuffer_empty := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_empty');
  ImGuiTextBuffer_end := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_end');
  ImGuiTextBuffer_ImGuiTextBuffer := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_ImGuiTextBuffer');
  ImGuiTextBuffer_reserve := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_reserve');
  ImGuiTextBuffer_resize := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_resize');
  ImGuiTextBuffer_size := GetProcAddress(aDLLHandle, 'ImGuiTextBuffer_size');
  ImGuiTextFilter_Build := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_Build');
  ImGuiTextFilter_Clear := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_Clear');
  ImGuiTextFilter_destroy := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_destroy');
  ImGuiTextFilter_Draw := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_Draw');
  ImGuiTextFilter_ImGuiTextFilter := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_ImGuiTextFilter');
  ImGuiTextFilter_IsActive := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_IsActive');
  ImGuiTextFilter_PassFilter := GetProcAddress(aDLLHandle, 'ImGuiTextFilter_PassFilter');
  ImGuiTextIndex_append := GetProcAddress(aDLLHandle, 'ImGuiTextIndex_append');
  ImGuiTextIndex_clear := GetProcAddress(aDLLHandle, 'ImGuiTextIndex_clear');
  ImGuiTextIndex_get_line_begin := GetProcAddress(aDLLHandle, 'ImGuiTextIndex_get_line_begin');
  ImGuiTextIndex_get_line_end := GetProcAddress(aDLLHandle, 'ImGuiTextIndex_get_line_end');
  ImGuiTextIndex_size := GetProcAddress(aDLLHandle, 'ImGuiTextIndex_size');
  ImGuiTextRange_destroy := GetProcAddress(aDLLHandle, 'ImGuiTextRange_destroy');
  ImGuiTextRange_empty := GetProcAddress(aDLLHandle, 'ImGuiTextRange_empty');
  ImGuiTextRange_ImGuiTextRange_Nil := GetProcAddress(aDLLHandle, 'ImGuiTextRange_ImGuiTextRange_Nil');
  ImGuiTextRange_ImGuiTextRange_Str := GetProcAddress(aDLLHandle, 'ImGuiTextRange_ImGuiTextRange_Str');
  ImGuiTextRange_split := GetProcAddress(aDLLHandle, 'ImGuiTextRange_split');
  ImGuiTypingSelectState_Clear := GetProcAddress(aDLLHandle, 'ImGuiTypingSelectState_Clear');
  ImGuiTypingSelectState_destroy := GetProcAddress(aDLLHandle, 'ImGuiTypingSelectState_destroy');
  ImGuiTypingSelectState_ImGuiTypingSelectState := GetProcAddress(aDLLHandle, 'ImGuiTypingSelectState_ImGuiTypingSelectState');
  ImGuiViewport_destroy := GetProcAddress(aDLLHandle, 'ImGuiViewport_destroy');
  ImGuiViewport_GetCenter := GetProcAddress(aDLLHandle, 'ImGuiViewport_GetCenter');
  ImGuiViewport_GetWorkCenter := GetProcAddress(aDLLHandle, 'ImGuiViewport_GetWorkCenter');
  ImGuiViewport_ImGuiViewport := GetProcAddress(aDLLHandle, 'ImGuiViewport_ImGuiViewport');
  ImGuiViewportP_CalcWorkRectPos := GetProcAddress(aDLLHandle, 'ImGuiViewportP_CalcWorkRectPos');
  ImGuiViewportP_CalcWorkRectSize := GetProcAddress(aDLLHandle, 'ImGuiViewportP_CalcWorkRectSize');
  ImGuiViewportP_ClearRequestFlags := GetProcAddress(aDLLHandle, 'ImGuiViewportP_ClearRequestFlags');
  ImGuiViewportP_destroy := GetProcAddress(aDLLHandle, 'ImGuiViewportP_destroy');
  ImGuiViewportP_GetBuildWorkRect := GetProcAddress(aDLLHandle, 'ImGuiViewportP_GetBuildWorkRect');
  ImGuiViewportP_GetMainRect := GetProcAddress(aDLLHandle, 'ImGuiViewportP_GetMainRect');
  ImGuiViewportP_GetWorkRect := GetProcAddress(aDLLHandle, 'ImGuiViewportP_GetWorkRect');
  ImGuiViewportP_ImGuiViewportP := GetProcAddress(aDLLHandle, 'ImGuiViewportP_ImGuiViewportP');
  ImGuiViewportP_UpdateWorkRect := GetProcAddress(aDLLHandle, 'ImGuiViewportP_UpdateWorkRect');
  ImGuiWindow_CalcFontSize := GetProcAddress(aDLLHandle, 'ImGuiWindow_CalcFontSize');
  ImGuiWindow_destroy := GetProcAddress(aDLLHandle, 'ImGuiWindow_destroy');
  ImGuiWindow_GetID_Int := GetProcAddress(aDLLHandle, 'ImGuiWindow_GetID_Int');
  ImGuiWindow_GetID_Ptr := GetProcAddress(aDLLHandle, 'ImGuiWindow_GetID_Ptr');
  ImGuiWindow_GetID_Str := GetProcAddress(aDLLHandle, 'ImGuiWindow_GetID_Str');
  ImGuiWindow_GetIDFromPos := GetProcAddress(aDLLHandle, 'ImGuiWindow_GetIDFromPos');
  ImGuiWindow_GetIDFromRectangle := GetProcAddress(aDLLHandle, 'ImGuiWindow_GetIDFromRectangle');
  ImGuiWindow_ImGuiWindow := GetProcAddress(aDLLHandle, 'ImGuiWindow_ImGuiWindow');
  ImGuiWindow_MenuBarRect := GetProcAddress(aDLLHandle, 'ImGuiWindow_MenuBarRect');
  ImGuiWindow_Rect := GetProcAddress(aDLLHandle, 'ImGuiWindow_Rect');
  ImGuiWindow_TitleBarRect := GetProcAddress(aDLLHandle, 'ImGuiWindow_TitleBarRect');
  ImGuiWindowClass_destroy := GetProcAddress(aDLLHandle, 'ImGuiWindowClass_destroy');
  ImGuiWindowClass_ImGuiWindowClass := GetProcAddress(aDLLHandle, 'ImGuiWindowClass_ImGuiWindowClass');
  ImGuiWindowSettings_destroy := GetProcAddress(aDLLHandle, 'ImGuiWindowSettings_destroy');
  ImGuiWindowSettings_GetName := GetProcAddress(aDLLHandle, 'ImGuiWindowSettings_GetName');
  ImGuiWindowSettings_ImGuiWindowSettings := GetProcAddress(aDLLHandle, 'ImGuiWindowSettings_ImGuiWindowSettings');
  ImRect_Add_Rect := GetProcAddress(aDLLHandle, 'ImRect_Add_Rect');
  ImRect_Add_Vec2 := GetProcAddress(aDLLHandle, 'ImRect_Add_Vec2');
  ImRect_ClipWith := GetProcAddress(aDLLHandle, 'ImRect_ClipWith');
  ImRect_ClipWithFull := GetProcAddress(aDLLHandle, 'ImRect_ClipWithFull');
  ImRect_Contains_Rect := GetProcAddress(aDLLHandle, 'ImRect_Contains_Rect');
  ImRect_Contains_Vec2 := GetProcAddress(aDLLHandle, 'ImRect_Contains_Vec2');
  ImRect_ContainsWithPad := GetProcAddress(aDLLHandle, 'ImRect_ContainsWithPad');
  ImRect_destroy := GetProcAddress(aDLLHandle, 'ImRect_destroy');
  ImRect_Expand_Float := GetProcAddress(aDLLHandle, 'ImRect_Expand_Float');
  ImRect_Expand_Vec2 := GetProcAddress(aDLLHandle, 'ImRect_Expand_Vec2');
  ImRect_Floor := GetProcAddress(aDLLHandle, 'ImRect_Floor');
  ImRect_GetArea := GetProcAddress(aDLLHandle, 'ImRect_GetArea');
  ImRect_GetBL := GetProcAddress(aDLLHandle, 'ImRect_GetBL');
  ImRect_GetBR := GetProcAddress(aDLLHandle, 'ImRect_GetBR');
  ImRect_GetCenter := GetProcAddress(aDLLHandle, 'ImRect_GetCenter');
  ImRect_GetHeight := GetProcAddress(aDLLHandle, 'ImRect_GetHeight');
  ImRect_GetSize := GetProcAddress(aDLLHandle, 'ImRect_GetSize');
  ImRect_GetTL := GetProcAddress(aDLLHandle, 'ImRect_GetTL');
  ImRect_GetTR := GetProcAddress(aDLLHandle, 'ImRect_GetTR');
  ImRect_GetWidth := GetProcAddress(aDLLHandle, 'ImRect_GetWidth');
  ImRect_ImRect_Float := GetProcAddress(aDLLHandle, 'ImRect_ImRect_Float');
  ImRect_ImRect_Nil := GetProcAddress(aDLLHandle, 'ImRect_ImRect_Nil');
  ImRect_ImRect_Vec2 := GetProcAddress(aDLLHandle, 'ImRect_ImRect_Vec2');
  ImRect_ImRect_Vec4 := GetProcAddress(aDLLHandle, 'ImRect_ImRect_Vec4');
  ImRect_IsInverted := GetProcAddress(aDLLHandle, 'ImRect_IsInverted');
  ImRect_Overlaps := GetProcAddress(aDLLHandle, 'ImRect_Overlaps');
  ImRect_ToVec4 := GetProcAddress(aDLLHandle, 'ImRect_ToVec4');
  ImRect_Translate := GetProcAddress(aDLLHandle, 'ImRect_Translate');
  ImRect_TranslateX := GetProcAddress(aDLLHandle, 'ImRect_TranslateX');
  ImRect_TranslateY := GetProcAddress(aDLLHandle, 'ImRect_TranslateY');
  ImVec1_destroy := GetProcAddress(aDLLHandle, 'ImVec1_destroy');
  ImVec1_ImVec1_Float := GetProcAddress(aDLLHandle, 'ImVec1_ImVec1_Float');
  ImVec1_ImVec1_Nil := GetProcAddress(aDLLHandle, 'ImVec1_ImVec1_Nil');
  ImVec2_destroy := GetProcAddress(aDLLHandle, 'ImVec2_destroy');
  ImVec2_ImVec2_Float := GetProcAddress(aDLLHandle, 'ImVec2_ImVec2_Float');
  ImVec2_ImVec2_Nil := GetProcAddress(aDLLHandle, 'ImVec2_ImVec2_Nil');
  ImVec2ih_destroy := GetProcAddress(aDLLHandle, 'ImVec2ih_destroy');
  ImVec2ih_ImVec2ih_Nil := GetProcAddress(aDLLHandle, 'ImVec2ih_ImVec2ih_Nil');
  ImVec2ih_ImVec2ih_short := GetProcAddress(aDLLHandle, 'ImVec2ih_ImVec2ih_short');
  ImVec2ih_ImVec2ih_Vec2 := GetProcAddress(aDLLHandle, 'ImVec2ih_ImVec2ih_Vec2');
  ImVec4_destroy := GetProcAddress(aDLLHandle, 'ImVec4_destroy');
  ImVec4_ImVec4_Float := GetProcAddress(aDLLHandle, 'ImVec4_ImVec4_Float');
  ImVec4_ImVec4_Nil := GetProcAddress(aDLLHandle, 'ImVec4_ImVec4_Nil');
  ImVector_ImWchar_create := GetProcAddress(aDLLHandle, 'ImVector_ImWchar_create');
  ImVector_ImWchar_destroy := GetProcAddress(aDLLHandle, 'ImVector_ImWchar_destroy');
  ImVector_ImWchar_Init := GetProcAddress(aDLLHandle, 'ImVector_ImWchar_Init');
  ImVector_ImWchar_UnInit := GetProcAddress(aDLLHandle, 'ImVector_ImWchar_UnInit');
  initGL := GetProcAddress(aDLLHandle, 'initGL');
  ma_aligned_free := GetProcAddress(aDLLHandle, 'ma_aligned_free');
  ma_aligned_malloc := GetProcAddress(aDLLHandle, 'ma_aligned_malloc');
  ma_apply_volume_factor_f32 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_f32');
  ma_apply_volume_factor_pcm_frames := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames');
  ma_apply_volume_factor_pcm_frames_f32 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames_f32');
  ma_apply_volume_factor_pcm_frames_s16 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames_s16');
  ma_apply_volume_factor_pcm_frames_s24 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames_s24');
  ma_apply_volume_factor_pcm_frames_s32 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames_s32');
  ma_apply_volume_factor_pcm_frames_u8 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_pcm_frames_u8');
  ma_apply_volume_factor_s16 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_s16');
  ma_apply_volume_factor_s24 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_s24');
  ma_apply_volume_factor_s32 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_s32');
  ma_apply_volume_factor_u8 := GetProcAddress(aDLLHandle, 'ma_apply_volume_factor_u8');
  ma_async_notification_event_init := GetProcAddress(aDLLHandle, 'ma_async_notification_event_init');
  ma_async_notification_event_signal := GetProcAddress(aDLLHandle, 'ma_async_notification_event_signal');
  ma_async_notification_event_uninit := GetProcAddress(aDLLHandle, 'ma_async_notification_event_uninit');
  ma_async_notification_event_wait := GetProcAddress(aDLLHandle, 'ma_async_notification_event_wait');
  ma_async_notification_poll_init := GetProcAddress(aDLLHandle, 'ma_async_notification_poll_init');
  ma_async_notification_poll_is_signalled := GetProcAddress(aDLLHandle, 'ma_async_notification_poll_is_signalled');
  ma_async_notification_signal := GetProcAddress(aDLLHandle, 'ma_async_notification_signal');
  ma_audio_buffer_alloc_and_init := GetProcAddress(aDLLHandle, 'ma_audio_buffer_alloc_and_init');
  ma_audio_buffer_at_end := GetProcAddress(aDLLHandle, 'ma_audio_buffer_at_end');
  ma_audio_buffer_config_init := GetProcAddress(aDLLHandle, 'ma_audio_buffer_config_init');
  ma_audio_buffer_get_available_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_get_available_frames');
  ma_audio_buffer_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_get_cursor_in_pcm_frames');
  ma_audio_buffer_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_get_length_in_pcm_frames');
  ma_audio_buffer_init := GetProcAddress(aDLLHandle, 'ma_audio_buffer_init');
  ma_audio_buffer_init_copy := GetProcAddress(aDLLHandle, 'ma_audio_buffer_init_copy');
  ma_audio_buffer_map := GetProcAddress(aDLLHandle, 'ma_audio_buffer_map');
  ma_audio_buffer_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_read_pcm_frames');
  ma_audio_buffer_ref_at_end := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_at_end');
  ma_audio_buffer_ref_get_available_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_get_available_frames');
  ma_audio_buffer_ref_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_get_cursor_in_pcm_frames');
  ma_audio_buffer_ref_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_get_length_in_pcm_frames');
  ma_audio_buffer_ref_init := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_init');
  ma_audio_buffer_ref_map := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_map');
  ma_audio_buffer_ref_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_read_pcm_frames');
  ma_audio_buffer_ref_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_seek_to_pcm_frame');
  ma_audio_buffer_ref_set_data := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_set_data');
  ma_audio_buffer_ref_uninit := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_uninit');
  ma_audio_buffer_ref_unmap := GetProcAddress(aDLLHandle, 'ma_audio_buffer_ref_unmap');
  ma_audio_buffer_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_audio_buffer_seek_to_pcm_frame');
  ma_audio_buffer_uninit := GetProcAddress(aDLLHandle, 'ma_audio_buffer_uninit');
  ma_audio_buffer_uninit_and_free := GetProcAddress(aDLLHandle, 'ma_audio_buffer_uninit_and_free');
  ma_audio_buffer_unmap := GetProcAddress(aDLLHandle, 'ma_audio_buffer_unmap');
  ma_biquad_clear_cache := GetProcAddress(aDLLHandle, 'ma_biquad_clear_cache');
  ma_biquad_config_init := GetProcAddress(aDLLHandle, 'ma_biquad_config_init');
  ma_biquad_get_heap_size := GetProcAddress(aDLLHandle, 'ma_biquad_get_heap_size');
  ma_biquad_get_latency := GetProcAddress(aDLLHandle, 'ma_biquad_get_latency');
  ma_biquad_init := GetProcAddress(aDLLHandle, 'ma_biquad_init');
  ma_biquad_init_preallocated := GetProcAddress(aDLLHandle, 'ma_biquad_init_preallocated');
  ma_biquad_node_config_init := GetProcAddress(aDLLHandle, 'ma_biquad_node_config_init');
  ma_biquad_node_init := GetProcAddress(aDLLHandle, 'ma_biquad_node_init');
  ma_biquad_node_reinit := GetProcAddress(aDLLHandle, 'ma_biquad_node_reinit');
  ma_biquad_node_uninit := GetProcAddress(aDLLHandle, 'ma_biquad_node_uninit');
  ma_biquad_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_biquad_process_pcm_frames');
  ma_biquad_reinit := GetProcAddress(aDLLHandle, 'ma_biquad_reinit');
  ma_biquad_uninit := GetProcAddress(aDLLHandle, 'ma_biquad_uninit');
  ma_blend_f32 := GetProcAddress(aDLLHandle, 'ma_blend_f32');
  ma_bpf_config_init := GetProcAddress(aDLLHandle, 'ma_bpf_config_init');
  ma_bpf_get_heap_size := GetProcAddress(aDLLHandle, 'ma_bpf_get_heap_size');
  ma_bpf_get_latency := GetProcAddress(aDLLHandle, 'ma_bpf_get_latency');
  ma_bpf_init := GetProcAddress(aDLLHandle, 'ma_bpf_init');
  ma_bpf_init_preallocated := GetProcAddress(aDLLHandle, 'ma_bpf_init_preallocated');
  ma_bpf_node_config_init := GetProcAddress(aDLLHandle, 'ma_bpf_node_config_init');
  ma_bpf_node_init := GetProcAddress(aDLLHandle, 'ma_bpf_node_init');
  ma_bpf_node_reinit := GetProcAddress(aDLLHandle, 'ma_bpf_node_reinit');
  ma_bpf_node_uninit := GetProcAddress(aDLLHandle, 'ma_bpf_node_uninit');
  ma_bpf_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_bpf_process_pcm_frames');
  ma_bpf_reinit := GetProcAddress(aDLLHandle, 'ma_bpf_reinit');
  ma_bpf_uninit := GetProcAddress(aDLLHandle, 'ma_bpf_uninit');
  ma_bpf2_config_init := GetProcAddress(aDLLHandle, 'ma_bpf2_config_init');
  ma_bpf2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_bpf2_get_heap_size');
  ma_bpf2_get_latency := GetProcAddress(aDLLHandle, 'ma_bpf2_get_latency');
  ma_bpf2_init := GetProcAddress(aDLLHandle, 'ma_bpf2_init');
  ma_bpf2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_bpf2_init_preallocated');
  ma_bpf2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_bpf2_process_pcm_frames');
  ma_bpf2_reinit := GetProcAddress(aDLLHandle, 'ma_bpf2_reinit');
  ma_bpf2_uninit := GetProcAddress(aDLLHandle, 'ma_bpf2_uninit');
  ma_calculate_buffer_size_in_frames_from_descriptor := GetProcAddress(aDLLHandle, 'ma_calculate_buffer_size_in_frames_from_descriptor');
  ma_calculate_buffer_size_in_frames_from_milliseconds := GetProcAddress(aDLLHandle, 'ma_calculate_buffer_size_in_frames_from_milliseconds');
  ma_calculate_buffer_size_in_milliseconds_from_frames := GetProcAddress(aDLLHandle, 'ma_calculate_buffer_size_in_milliseconds_from_frames');
  ma_calloc := GetProcAddress(aDLLHandle, 'ma_calloc');
  ma_channel_converter_config_init := GetProcAddress(aDLLHandle, 'ma_channel_converter_config_init');
  ma_channel_converter_get_heap_size := GetProcAddress(aDLLHandle, 'ma_channel_converter_get_heap_size');
  ma_channel_converter_get_input_channel_map := GetProcAddress(aDLLHandle, 'ma_channel_converter_get_input_channel_map');
  ma_channel_converter_get_output_channel_map := GetProcAddress(aDLLHandle, 'ma_channel_converter_get_output_channel_map');
  ma_channel_converter_init := GetProcAddress(aDLLHandle, 'ma_channel_converter_init');
  ma_channel_converter_init_preallocated := GetProcAddress(aDLLHandle, 'ma_channel_converter_init_preallocated');
  ma_channel_converter_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_channel_converter_process_pcm_frames');
  ma_channel_converter_uninit := GetProcAddress(aDLLHandle, 'ma_channel_converter_uninit');
  ma_channel_map_contains_channel_position := GetProcAddress(aDLLHandle, 'ma_channel_map_contains_channel_position');
  ma_channel_map_copy := GetProcAddress(aDLLHandle, 'ma_channel_map_copy');
  ma_channel_map_copy_or_default := GetProcAddress(aDLLHandle, 'ma_channel_map_copy_or_default');
  ma_channel_map_find_channel_position := GetProcAddress(aDLLHandle, 'ma_channel_map_find_channel_position');
  ma_channel_map_get_channel := GetProcAddress(aDLLHandle, 'ma_channel_map_get_channel');
  ma_channel_map_init_blank := GetProcAddress(aDLLHandle, 'ma_channel_map_init_blank');
  ma_channel_map_init_standard := GetProcAddress(aDLLHandle, 'ma_channel_map_init_standard');
  ma_channel_map_is_blank := GetProcAddress(aDLLHandle, 'ma_channel_map_is_blank');
  ma_channel_map_is_equal := GetProcAddress(aDLLHandle, 'ma_channel_map_is_equal');
  ma_channel_map_is_valid := GetProcAddress(aDLLHandle, 'ma_channel_map_is_valid');
  ma_channel_map_to_string := GetProcAddress(aDLLHandle, 'ma_channel_map_to_string');
  ma_channel_position_to_string := GetProcAddress(aDLLHandle, 'ma_channel_position_to_string');
  ma_clip_pcm_frames := GetProcAddress(aDLLHandle, 'ma_clip_pcm_frames');
  ma_clip_samples_f32 := GetProcAddress(aDLLHandle, 'ma_clip_samples_f32');
  ma_clip_samples_s16 := GetProcAddress(aDLLHandle, 'ma_clip_samples_s16');
  ma_clip_samples_s24 := GetProcAddress(aDLLHandle, 'ma_clip_samples_s24');
  ma_clip_samples_s32 := GetProcAddress(aDLLHandle, 'ma_clip_samples_s32');
  ma_clip_samples_u8 := GetProcAddress(aDLLHandle, 'ma_clip_samples_u8');
  ma_context_config_init := GetProcAddress(aDLLHandle, 'ma_context_config_init');
  ma_context_enumerate_devices := GetProcAddress(aDLLHandle, 'ma_context_enumerate_devices');
  ma_context_get_device_info := GetProcAddress(aDLLHandle, 'ma_context_get_device_info');
  ma_context_get_devices := GetProcAddress(aDLLHandle, 'ma_context_get_devices');
  ma_context_get_log := GetProcAddress(aDLLHandle, 'ma_context_get_log');
  ma_context_init := GetProcAddress(aDLLHandle, 'ma_context_init');
  ma_context_is_loopback_supported := GetProcAddress(aDLLHandle, 'ma_context_is_loopback_supported');
  ma_context_sizeof := GetProcAddress(aDLLHandle, 'ma_context_sizeof');
  ma_context_uninit := GetProcAddress(aDLLHandle, 'ma_context_uninit');
  ma_convert_frames := GetProcAddress(aDLLHandle, 'ma_convert_frames');
  ma_convert_frames_ex := GetProcAddress(aDLLHandle, 'ma_convert_frames_ex');
  ma_convert_pcm_frames_format := GetProcAddress(aDLLHandle, 'ma_convert_pcm_frames_format');
  ma_copy_and_apply_volume_and_clip_pcm_frames := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_pcm_frames');
  ma_copy_and_apply_volume_and_clip_samples_f32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_samples_f32');
  ma_copy_and_apply_volume_and_clip_samples_s16 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_samples_s16');
  ma_copy_and_apply_volume_and_clip_samples_s24 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_samples_s24');
  ma_copy_and_apply_volume_and_clip_samples_s32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_samples_s32');
  ma_copy_and_apply_volume_and_clip_samples_u8 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_and_clip_samples_u8');
  ma_copy_and_apply_volume_factor_f32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_f32');
  ma_copy_and_apply_volume_factor_pcm_frames := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames');
  ma_copy_and_apply_volume_factor_pcm_frames_f32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames_f32');
  ma_copy_and_apply_volume_factor_pcm_frames_s16 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames_s16');
  ma_copy_and_apply_volume_factor_pcm_frames_s24 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames_s24');
  ma_copy_and_apply_volume_factor_pcm_frames_s32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames_s32');
  ma_copy_and_apply_volume_factor_pcm_frames_u8 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_pcm_frames_u8');
  ma_copy_and_apply_volume_factor_per_channel_f32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_per_channel_f32');
  ma_copy_and_apply_volume_factor_s16 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_s16');
  ma_copy_and_apply_volume_factor_s24 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_s24');
  ma_copy_and_apply_volume_factor_s32 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_s32');
  ma_copy_and_apply_volume_factor_u8 := GetProcAddress(aDLLHandle, 'ma_copy_and_apply_volume_factor_u8');
  ma_copy_pcm_frames := GetProcAddress(aDLLHandle, 'ma_copy_pcm_frames');
  ma_data_converter_config_init := GetProcAddress(aDLLHandle, 'ma_data_converter_config_init');
  ma_data_converter_config_init_default := GetProcAddress(aDLLHandle, 'ma_data_converter_config_init_default');
  ma_data_converter_get_expected_output_frame_count := GetProcAddress(aDLLHandle, 'ma_data_converter_get_expected_output_frame_count');
  ma_data_converter_get_heap_size := GetProcAddress(aDLLHandle, 'ma_data_converter_get_heap_size');
  ma_data_converter_get_input_channel_map := GetProcAddress(aDLLHandle, 'ma_data_converter_get_input_channel_map');
  ma_data_converter_get_input_latency := GetProcAddress(aDLLHandle, 'ma_data_converter_get_input_latency');
  ma_data_converter_get_output_channel_map := GetProcAddress(aDLLHandle, 'ma_data_converter_get_output_channel_map');
  ma_data_converter_get_output_latency := GetProcAddress(aDLLHandle, 'ma_data_converter_get_output_latency');
  ma_data_converter_get_required_input_frame_count := GetProcAddress(aDLLHandle, 'ma_data_converter_get_required_input_frame_count');
  ma_data_converter_init := GetProcAddress(aDLLHandle, 'ma_data_converter_init');
  ma_data_converter_init_preallocated := GetProcAddress(aDLLHandle, 'ma_data_converter_init_preallocated');
  ma_data_converter_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_converter_process_pcm_frames');
  ma_data_converter_reset := GetProcAddress(aDLLHandle, 'ma_data_converter_reset');
  ma_data_converter_set_rate := GetProcAddress(aDLLHandle, 'ma_data_converter_set_rate');
  ma_data_converter_set_rate_ratio := GetProcAddress(aDLLHandle, 'ma_data_converter_set_rate_ratio');
  ma_data_converter_uninit := GetProcAddress(aDLLHandle, 'ma_data_converter_uninit');
  ma_data_source_config_init := GetProcAddress(aDLLHandle, 'ma_data_source_config_init');
  ma_data_source_get_current := GetProcAddress(aDLLHandle, 'ma_data_source_get_current');
  ma_data_source_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_get_cursor_in_pcm_frames');
  ma_data_source_get_cursor_in_seconds := GetProcAddress(aDLLHandle, 'ma_data_source_get_cursor_in_seconds');
  ma_data_source_get_data_format := GetProcAddress(aDLLHandle, 'ma_data_source_get_data_format');
  ma_data_source_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_get_length_in_pcm_frames');
  ma_data_source_get_length_in_seconds := GetProcAddress(aDLLHandle, 'ma_data_source_get_length_in_seconds');
  ma_data_source_get_loop_point_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_get_loop_point_in_pcm_frames');
  ma_data_source_get_next := GetProcAddress(aDLLHandle, 'ma_data_source_get_next');
  ma_data_source_get_next_callback := GetProcAddress(aDLLHandle, 'ma_data_source_get_next_callback');
  ma_data_source_get_range_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_get_range_in_pcm_frames');
  ma_data_source_init := GetProcAddress(aDLLHandle, 'ma_data_source_init');
  ma_data_source_is_looping := GetProcAddress(aDLLHandle, 'ma_data_source_is_looping');
  ma_data_source_node_config_init := GetProcAddress(aDLLHandle, 'ma_data_source_node_config_init');
  ma_data_source_node_init := GetProcAddress(aDLLHandle, 'ma_data_source_node_init');
  ma_data_source_node_is_looping := GetProcAddress(aDLLHandle, 'ma_data_source_node_is_looping');
  ma_data_source_node_set_looping := GetProcAddress(aDLLHandle, 'ma_data_source_node_set_looping');
  ma_data_source_node_uninit := GetProcAddress(aDLLHandle, 'ma_data_source_node_uninit');
  ma_data_source_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_read_pcm_frames');
  ma_data_source_seek_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_seek_pcm_frames');
  ma_data_source_seek_seconds := GetProcAddress(aDLLHandle, 'ma_data_source_seek_seconds');
  ma_data_source_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_data_source_seek_to_pcm_frame');
  ma_data_source_seek_to_second := GetProcAddress(aDLLHandle, 'ma_data_source_seek_to_second');
  ma_data_source_set_current := GetProcAddress(aDLLHandle, 'ma_data_source_set_current');
  ma_data_source_set_loop_point_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_set_loop_point_in_pcm_frames');
  ma_data_source_set_looping := GetProcAddress(aDLLHandle, 'ma_data_source_set_looping');
  ma_data_source_set_next := GetProcAddress(aDLLHandle, 'ma_data_source_set_next');
  ma_data_source_set_next_callback := GetProcAddress(aDLLHandle, 'ma_data_source_set_next_callback');
  ma_data_source_set_range_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_data_source_set_range_in_pcm_frames');
  ma_data_source_uninit := GetProcAddress(aDLLHandle, 'ma_data_source_uninit');
  ma_decode_file := GetProcAddress(aDLLHandle, 'ma_decode_file');
  ma_decode_from_vfs := GetProcAddress(aDLLHandle, 'ma_decode_from_vfs');
  ma_decode_memory := GetProcAddress(aDLLHandle, 'ma_decode_memory');
  ma_decoder_config_init := GetProcAddress(aDLLHandle, 'ma_decoder_config_init');
  ma_decoder_config_init_default := GetProcAddress(aDLLHandle, 'ma_decoder_config_init_default');
  ma_decoder_get_available_frames := GetProcAddress(aDLLHandle, 'ma_decoder_get_available_frames');
  ma_decoder_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_decoder_get_cursor_in_pcm_frames');
  ma_decoder_get_data_format := GetProcAddress(aDLLHandle, 'ma_decoder_get_data_format');
  ma_decoder_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_decoder_get_length_in_pcm_frames');
  ma_decoder_init := GetProcAddress(aDLLHandle, 'ma_decoder_init');
  ma_decoder_init_file := GetProcAddress(aDLLHandle, 'ma_decoder_init_file');
  ma_decoder_init_file_w := GetProcAddress(aDLLHandle, 'ma_decoder_init_file_w');
  ma_decoder_init_memory := GetProcAddress(aDLLHandle, 'ma_decoder_init_memory');
  ma_decoder_init_vfs := GetProcAddress(aDLLHandle, 'ma_decoder_init_vfs');
  ma_decoder_init_vfs_w := GetProcAddress(aDLLHandle, 'ma_decoder_init_vfs_w');
  ma_decoder_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_decoder_read_pcm_frames');
  ma_decoder_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_decoder_seek_to_pcm_frame');
  ma_decoder_uninit := GetProcAddress(aDLLHandle, 'ma_decoder_uninit');
  ma_decoding_backend_config_init := GetProcAddress(aDLLHandle, 'ma_decoding_backend_config_init');
  ma_default_vfs_init := GetProcAddress(aDLLHandle, 'ma_default_vfs_init');
  ma_deinterleave_pcm_frames := GetProcAddress(aDLLHandle, 'ma_deinterleave_pcm_frames');
  ma_delay_config_init := GetProcAddress(aDLLHandle, 'ma_delay_config_init');
  ma_delay_get_decay := GetProcAddress(aDLLHandle, 'ma_delay_get_decay');
  ma_delay_get_dry := GetProcAddress(aDLLHandle, 'ma_delay_get_dry');
  ma_delay_get_wet := GetProcAddress(aDLLHandle, 'ma_delay_get_wet');
  ma_delay_init := GetProcAddress(aDLLHandle, 'ma_delay_init');
  ma_delay_node_config_init := GetProcAddress(aDLLHandle, 'ma_delay_node_config_init');
  ma_delay_node_get_decay := GetProcAddress(aDLLHandle, 'ma_delay_node_get_decay');
  ma_delay_node_get_dry := GetProcAddress(aDLLHandle, 'ma_delay_node_get_dry');
  ma_delay_node_get_wet := GetProcAddress(aDLLHandle, 'ma_delay_node_get_wet');
  ma_delay_node_init := GetProcAddress(aDLLHandle, 'ma_delay_node_init');
  ma_delay_node_set_decay := GetProcAddress(aDLLHandle, 'ma_delay_node_set_decay');
  ma_delay_node_set_dry := GetProcAddress(aDLLHandle, 'ma_delay_node_set_dry');
  ma_delay_node_set_wet := GetProcAddress(aDLLHandle, 'ma_delay_node_set_wet');
  ma_delay_node_uninit := GetProcAddress(aDLLHandle, 'ma_delay_node_uninit');
  ma_delay_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_delay_process_pcm_frames');
  ma_delay_set_decay := GetProcAddress(aDLLHandle, 'ma_delay_set_decay');
  ma_delay_set_dry := GetProcAddress(aDLLHandle, 'ma_delay_set_dry');
  ma_delay_set_wet := GetProcAddress(aDLLHandle, 'ma_delay_set_wet');
  ma_delay_uninit := GetProcAddress(aDLLHandle, 'ma_delay_uninit');
  ma_device_config_init := GetProcAddress(aDLLHandle, 'ma_device_config_init');
  ma_device_get_context := GetProcAddress(aDLLHandle, 'ma_device_get_context');
  ma_device_get_info := GetProcAddress(aDLLHandle, 'ma_device_get_info');
  ma_device_get_log := GetProcAddress(aDLLHandle, 'ma_device_get_log');
  ma_device_get_master_volume := GetProcAddress(aDLLHandle, 'ma_device_get_master_volume');
  ma_device_get_master_volume_db := GetProcAddress(aDLLHandle, 'ma_device_get_master_volume_db');
  ma_device_get_name := GetProcAddress(aDLLHandle, 'ma_device_get_name');
  ma_device_get_state := GetProcAddress(aDLLHandle, 'ma_device_get_state');
  ma_device_handle_backend_data_callback := GetProcAddress(aDLLHandle, 'ma_device_handle_backend_data_callback');
  ma_device_id_equal := GetProcAddress(aDLLHandle, 'ma_device_id_equal');
  ma_device_init := GetProcAddress(aDLLHandle, 'ma_device_init');
  ma_device_init_ex := GetProcAddress(aDLLHandle, 'ma_device_init_ex');
  ma_device_is_started := GetProcAddress(aDLLHandle, 'ma_device_is_started');
  ma_device_job_thread_config_init := GetProcAddress(aDLLHandle, 'ma_device_job_thread_config_init');
  ma_device_job_thread_init := GetProcAddress(aDLLHandle, 'ma_device_job_thread_init');
  ma_device_job_thread_next := GetProcAddress(aDLLHandle, 'ma_device_job_thread_next');
  ma_device_job_thread_post := GetProcAddress(aDLLHandle, 'ma_device_job_thread_post');
  ma_device_job_thread_uninit := GetProcAddress(aDLLHandle, 'ma_device_job_thread_uninit');
  ma_device_post_init := GetProcAddress(aDLLHandle, 'ma_device_post_init');
  ma_device_set_master_volume := GetProcAddress(aDLLHandle, 'ma_device_set_master_volume');
  ma_device_set_master_volume_db := GetProcAddress(aDLLHandle, 'ma_device_set_master_volume_db');
  ma_device_start := GetProcAddress(aDLLHandle, 'ma_device_start');
  ma_device_stop := GetProcAddress(aDLLHandle, 'ma_device_stop');
  ma_device_uninit := GetProcAddress(aDLLHandle, 'ma_device_uninit');
  ma_duplex_rb_init := GetProcAddress(aDLLHandle, 'ma_duplex_rb_init');
  ma_duplex_rb_uninit := GetProcAddress(aDLLHandle, 'ma_duplex_rb_uninit');
  ma_encoder_config_init := GetProcAddress(aDLLHandle, 'ma_encoder_config_init');
  ma_encoder_init := GetProcAddress(aDLLHandle, 'ma_encoder_init');
  ma_encoder_init_file := GetProcAddress(aDLLHandle, 'ma_encoder_init_file');
  ma_encoder_init_file_w := GetProcAddress(aDLLHandle, 'ma_encoder_init_file_w');
  ma_encoder_init_vfs := GetProcAddress(aDLLHandle, 'ma_encoder_init_vfs');
  ma_encoder_init_vfs_w := GetProcAddress(aDLLHandle, 'ma_encoder_init_vfs_w');
  ma_encoder_uninit := GetProcAddress(aDLLHandle, 'ma_encoder_uninit');
  ma_encoder_write_pcm_frames := GetProcAddress(aDLLHandle, 'ma_encoder_write_pcm_frames');
  ma_engine_config_init := GetProcAddress(aDLLHandle, 'ma_engine_config_init');
  ma_engine_find_closest_listener := GetProcAddress(aDLLHandle, 'ma_engine_find_closest_listener');
  ma_engine_get_channels := GetProcAddress(aDLLHandle, 'ma_engine_get_channels');
  ma_engine_get_device := GetProcAddress(aDLLHandle, 'ma_engine_get_device');
  ma_engine_get_endpoint := GetProcAddress(aDLLHandle, 'ma_engine_get_endpoint');
  ma_engine_get_gain_db := GetProcAddress(aDLLHandle, 'ma_engine_get_gain_db');
  ma_engine_get_listener_count := GetProcAddress(aDLLHandle, 'ma_engine_get_listener_count');
  ma_engine_get_log := GetProcAddress(aDLLHandle, 'ma_engine_get_log');
  ma_engine_get_node_graph := GetProcAddress(aDLLHandle, 'ma_engine_get_node_graph');
  ma_engine_get_resource_manager := GetProcAddress(aDLLHandle, 'ma_engine_get_resource_manager');
  ma_engine_get_sample_rate := GetProcAddress(aDLLHandle, 'ma_engine_get_sample_rate');
  ma_engine_get_time := GetProcAddress(aDLLHandle, 'ma_engine_get_time');
  ma_engine_get_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_engine_get_time_in_milliseconds');
  ma_engine_get_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_engine_get_time_in_pcm_frames');
  ma_engine_get_volume := GetProcAddress(aDLLHandle, 'ma_engine_get_volume');
  ma_engine_init := GetProcAddress(aDLLHandle, 'ma_engine_init');
  ma_engine_listener_get_cone := GetProcAddress(aDLLHandle, 'ma_engine_listener_get_cone');
  ma_engine_listener_get_direction := GetProcAddress(aDLLHandle, 'ma_engine_listener_get_direction');
  ma_engine_listener_get_position := GetProcAddress(aDLLHandle, 'ma_engine_listener_get_position');
  ma_engine_listener_get_velocity := GetProcAddress(aDLLHandle, 'ma_engine_listener_get_velocity');
  ma_engine_listener_get_world_up := GetProcAddress(aDLLHandle, 'ma_engine_listener_get_world_up');
  ma_engine_listener_is_enabled := GetProcAddress(aDLLHandle, 'ma_engine_listener_is_enabled');
  ma_engine_listener_set_cone := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_cone');
  ma_engine_listener_set_direction := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_direction');
  ma_engine_listener_set_enabled := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_enabled');
  ma_engine_listener_set_position := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_position');
  ma_engine_listener_set_velocity := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_velocity');
  ma_engine_listener_set_world_up := GetProcAddress(aDLLHandle, 'ma_engine_listener_set_world_up');
  ma_engine_node_config_init := GetProcAddress(aDLLHandle, 'ma_engine_node_config_init');
  ma_engine_node_get_heap_size := GetProcAddress(aDLLHandle, 'ma_engine_node_get_heap_size');
  ma_engine_node_init := GetProcAddress(aDLLHandle, 'ma_engine_node_init');
  ma_engine_node_init_preallocated := GetProcAddress(aDLLHandle, 'ma_engine_node_init_preallocated');
  ma_engine_node_uninit := GetProcAddress(aDLLHandle, 'ma_engine_node_uninit');
  ma_engine_play_sound := GetProcAddress(aDLLHandle, 'ma_engine_play_sound');
  ma_engine_play_sound_ex := GetProcAddress(aDLLHandle, 'ma_engine_play_sound_ex');
  ma_engine_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_engine_read_pcm_frames');
  ma_engine_set_gain_db := GetProcAddress(aDLLHandle, 'ma_engine_set_gain_db');
  ma_engine_set_time := GetProcAddress(aDLLHandle, 'ma_engine_set_time');
  ma_engine_set_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_engine_set_time_in_milliseconds');
  ma_engine_set_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_engine_set_time_in_pcm_frames');
  ma_engine_set_volume := GetProcAddress(aDLLHandle, 'ma_engine_set_volume');
  ma_engine_start := GetProcAddress(aDLLHandle, 'ma_engine_start');
  ma_engine_stop := GetProcAddress(aDLLHandle, 'ma_engine_stop');
  ma_engine_uninit := GetProcAddress(aDLLHandle, 'ma_engine_uninit');
  ma_event_init := GetProcAddress(aDLLHandle, 'ma_event_init');
  ma_event_signal := GetProcAddress(aDLLHandle, 'ma_event_signal');
  ma_event_uninit := GetProcAddress(aDLLHandle, 'ma_event_uninit');
  ma_event_wait := GetProcAddress(aDLLHandle, 'ma_event_wait');
  ma_fader_config_init := GetProcAddress(aDLLHandle, 'ma_fader_config_init');
  ma_fader_get_current_volume := GetProcAddress(aDLLHandle, 'ma_fader_get_current_volume');
  ma_fader_get_data_format := GetProcAddress(aDLLHandle, 'ma_fader_get_data_format');
  ma_fader_init := GetProcAddress(aDLLHandle, 'ma_fader_init');
  ma_fader_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_fader_process_pcm_frames');
  ma_fader_set_fade := GetProcAddress(aDLLHandle, 'ma_fader_set_fade');
  ma_fader_set_fade_ex := GetProcAddress(aDLLHandle, 'ma_fader_set_fade_ex');
  ma_fence_acquire := GetProcAddress(aDLLHandle, 'ma_fence_acquire');
  ma_fence_init := GetProcAddress(aDLLHandle, 'ma_fence_init');
  ma_fence_release := GetProcAddress(aDLLHandle, 'ma_fence_release');
  ma_fence_uninit := GetProcAddress(aDLLHandle, 'ma_fence_uninit');
  ma_fence_wait := GetProcAddress(aDLLHandle, 'ma_fence_wait');
  ma_free := GetProcAddress(aDLLHandle, 'ma_free');
  ma_gainer_config_init := GetProcAddress(aDLLHandle, 'ma_gainer_config_init');
  ma_gainer_get_heap_size := GetProcAddress(aDLLHandle, 'ma_gainer_get_heap_size');
  ma_gainer_get_master_volume := GetProcAddress(aDLLHandle, 'ma_gainer_get_master_volume');
  ma_gainer_init := GetProcAddress(aDLLHandle, 'ma_gainer_init');
  ma_gainer_init_preallocated := GetProcAddress(aDLLHandle, 'ma_gainer_init_preallocated');
  ma_gainer_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_gainer_process_pcm_frames');
  ma_gainer_set_gain := GetProcAddress(aDLLHandle, 'ma_gainer_set_gain');
  ma_gainer_set_gains := GetProcAddress(aDLLHandle, 'ma_gainer_set_gains');
  ma_gainer_set_master_volume := GetProcAddress(aDLLHandle, 'ma_gainer_set_master_volume');
  ma_gainer_uninit := GetProcAddress(aDLLHandle, 'ma_gainer_uninit');
  ma_get_backend_from_name := GetProcAddress(aDLLHandle, 'ma_get_backend_from_name');
  ma_get_backend_name := GetProcAddress(aDLLHandle, 'ma_get_backend_name');
  ma_get_bytes_per_sample := GetProcAddress(aDLLHandle, 'ma_get_bytes_per_sample');
  ma_get_enabled_backends := GetProcAddress(aDLLHandle, 'ma_get_enabled_backends');
  ma_get_format_name := GetProcAddress(aDLLHandle, 'ma_get_format_name');
  ma_hishelf_node_config_init := GetProcAddress(aDLLHandle, 'ma_hishelf_node_config_init');
  ma_hishelf_node_init := GetProcAddress(aDLLHandle, 'ma_hishelf_node_init');
  ma_hishelf_node_reinit := GetProcAddress(aDLLHandle, 'ma_hishelf_node_reinit');
  ma_hishelf_node_uninit := GetProcAddress(aDLLHandle, 'ma_hishelf_node_uninit');
  ma_hishelf2_config_init := GetProcAddress(aDLLHandle, 'ma_hishelf2_config_init');
  ma_hishelf2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_hishelf2_get_heap_size');
  ma_hishelf2_get_latency := GetProcAddress(aDLLHandle, 'ma_hishelf2_get_latency');
  ma_hishelf2_init := GetProcAddress(aDLLHandle, 'ma_hishelf2_init');
  ma_hishelf2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_hishelf2_init_preallocated');
  ma_hishelf2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_hishelf2_process_pcm_frames');
  ma_hishelf2_reinit := GetProcAddress(aDLLHandle, 'ma_hishelf2_reinit');
  ma_hishelf2_uninit := GetProcAddress(aDLLHandle, 'ma_hishelf2_uninit');
  ma_hpf_config_init := GetProcAddress(aDLLHandle, 'ma_hpf_config_init');
  ma_hpf_get_heap_size := GetProcAddress(aDLLHandle, 'ma_hpf_get_heap_size');
  ma_hpf_get_latency := GetProcAddress(aDLLHandle, 'ma_hpf_get_latency');
  ma_hpf_init := GetProcAddress(aDLLHandle, 'ma_hpf_init');
  ma_hpf_init_preallocated := GetProcAddress(aDLLHandle, 'ma_hpf_init_preallocated');
  ma_hpf_node_config_init := GetProcAddress(aDLLHandle, 'ma_hpf_node_config_init');
  ma_hpf_node_init := GetProcAddress(aDLLHandle, 'ma_hpf_node_init');
  ma_hpf_node_reinit := GetProcAddress(aDLLHandle, 'ma_hpf_node_reinit');
  ma_hpf_node_uninit := GetProcAddress(aDLLHandle, 'ma_hpf_node_uninit');
  ma_hpf_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_hpf_process_pcm_frames');
  ma_hpf_reinit := GetProcAddress(aDLLHandle, 'ma_hpf_reinit');
  ma_hpf_uninit := GetProcAddress(aDLLHandle, 'ma_hpf_uninit');
  ma_hpf1_config_init := GetProcAddress(aDLLHandle, 'ma_hpf1_config_init');
  ma_hpf1_get_heap_size := GetProcAddress(aDLLHandle, 'ma_hpf1_get_heap_size');
  ma_hpf1_get_latency := GetProcAddress(aDLLHandle, 'ma_hpf1_get_latency');
  ma_hpf1_init := GetProcAddress(aDLLHandle, 'ma_hpf1_init');
  ma_hpf1_init_preallocated := GetProcAddress(aDLLHandle, 'ma_hpf1_init_preallocated');
  ma_hpf1_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_hpf1_process_pcm_frames');
  ma_hpf1_reinit := GetProcAddress(aDLLHandle, 'ma_hpf1_reinit');
  ma_hpf1_uninit := GetProcAddress(aDLLHandle, 'ma_hpf1_uninit');
  ma_hpf2_config_init := GetProcAddress(aDLLHandle, 'ma_hpf2_config_init');
  ma_hpf2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_hpf2_get_heap_size');
  ma_hpf2_get_latency := GetProcAddress(aDLLHandle, 'ma_hpf2_get_latency');
  ma_hpf2_init := GetProcAddress(aDLLHandle, 'ma_hpf2_init');
  ma_hpf2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_hpf2_init_preallocated');
  ma_hpf2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_hpf2_process_pcm_frames');
  ma_hpf2_reinit := GetProcAddress(aDLLHandle, 'ma_hpf2_reinit');
  ma_hpf2_uninit := GetProcAddress(aDLLHandle, 'ma_hpf2_uninit');
  ma_interleave_pcm_frames := GetProcAddress(aDLLHandle, 'ma_interleave_pcm_frames');
  ma_is_backend_enabled := GetProcAddress(aDLLHandle, 'ma_is_backend_enabled');
  ma_is_loopback_supported := GetProcAddress(aDLLHandle, 'ma_is_loopback_supported');
  ma_job_init := GetProcAddress(aDLLHandle, 'ma_job_init');
  ma_job_process := GetProcAddress(aDLLHandle, 'ma_job_process');
  ma_job_queue_config_init := GetProcAddress(aDLLHandle, 'ma_job_queue_config_init');
  ma_job_queue_get_heap_size := GetProcAddress(aDLLHandle, 'ma_job_queue_get_heap_size');
  ma_job_queue_init := GetProcAddress(aDLLHandle, 'ma_job_queue_init');
  ma_job_queue_init_preallocated := GetProcAddress(aDLLHandle, 'ma_job_queue_init_preallocated');
  ma_job_queue_next := GetProcAddress(aDLLHandle, 'ma_job_queue_next');
  ma_job_queue_post := GetProcAddress(aDLLHandle, 'ma_job_queue_post');
  ma_job_queue_uninit := GetProcAddress(aDLLHandle, 'ma_job_queue_uninit');
  ma_linear_resampler_config_init := GetProcAddress(aDLLHandle, 'ma_linear_resampler_config_init');
  ma_linear_resampler_get_expected_output_frame_count := GetProcAddress(aDLLHandle, 'ma_linear_resampler_get_expected_output_frame_count');
  ma_linear_resampler_get_heap_size := GetProcAddress(aDLLHandle, 'ma_linear_resampler_get_heap_size');
  ma_linear_resampler_get_input_latency := GetProcAddress(aDLLHandle, 'ma_linear_resampler_get_input_latency');
  ma_linear_resampler_get_output_latency := GetProcAddress(aDLLHandle, 'ma_linear_resampler_get_output_latency');
  ma_linear_resampler_get_required_input_frame_count := GetProcAddress(aDLLHandle, 'ma_linear_resampler_get_required_input_frame_count');
  ma_linear_resampler_init := GetProcAddress(aDLLHandle, 'ma_linear_resampler_init');
  ma_linear_resampler_init_preallocated := GetProcAddress(aDLLHandle, 'ma_linear_resampler_init_preallocated');
  ma_linear_resampler_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_linear_resampler_process_pcm_frames');
  ma_linear_resampler_reset := GetProcAddress(aDLLHandle, 'ma_linear_resampler_reset');
  ma_linear_resampler_set_rate := GetProcAddress(aDLLHandle, 'ma_linear_resampler_set_rate');
  ma_linear_resampler_set_rate_ratio := GetProcAddress(aDLLHandle, 'ma_linear_resampler_set_rate_ratio');
  ma_linear_resampler_uninit := GetProcAddress(aDLLHandle, 'ma_linear_resampler_uninit');
  ma_log_callback_init := GetProcAddress(aDLLHandle, 'ma_log_callback_init');
  ma_log_init := GetProcAddress(aDLLHandle, 'ma_log_init');
  ma_log_level_to_string := GetProcAddress(aDLLHandle, 'ma_log_level_to_string');
  ma_log_post := GetProcAddress(aDLLHandle, 'ma_log_post');
  ma_log_postf := GetProcAddress(aDLLHandle, 'ma_log_postf');
  ma_log_postv := GetProcAddress(aDLLHandle, 'ma_log_postv');
  ma_log_register_callback := GetProcAddress(aDLLHandle, 'ma_log_register_callback');
  ma_log_uninit := GetProcAddress(aDLLHandle, 'ma_log_uninit');
  ma_log_unregister_callback := GetProcAddress(aDLLHandle, 'ma_log_unregister_callback');
  ma_loshelf_node_config_init := GetProcAddress(aDLLHandle, 'ma_loshelf_node_config_init');
  ma_loshelf_node_init := GetProcAddress(aDLLHandle, 'ma_loshelf_node_init');
  ma_loshelf_node_reinit := GetProcAddress(aDLLHandle, 'ma_loshelf_node_reinit');
  ma_loshelf_node_uninit := GetProcAddress(aDLLHandle, 'ma_loshelf_node_uninit');
  ma_loshelf2_config_init := GetProcAddress(aDLLHandle, 'ma_loshelf2_config_init');
  ma_loshelf2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_loshelf2_get_heap_size');
  ma_loshelf2_get_latency := GetProcAddress(aDLLHandle, 'ma_loshelf2_get_latency');
  ma_loshelf2_init := GetProcAddress(aDLLHandle, 'ma_loshelf2_init');
  ma_loshelf2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_loshelf2_init_preallocated');
  ma_loshelf2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_loshelf2_process_pcm_frames');
  ma_loshelf2_reinit := GetProcAddress(aDLLHandle, 'ma_loshelf2_reinit');
  ma_loshelf2_uninit := GetProcAddress(aDLLHandle, 'ma_loshelf2_uninit');
  ma_lpf_clear_cache := GetProcAddress(aDLLHandle, 'ma_lpf_clear_cache');
  ma_lpf_config_init := GetProcAddress(aDLLHandle, 'ma_lpf_config_init');
  ma_lpf_get_heap_size := GetProcAddress(aDLLHandle, 'ma_lpf_get_heap_size');
  ma_lpf_get_latency := GetProcAddress(aDLLHandle, 'ma_lpf_get_latency');
  ma_lpf_init := GetProcAddress(aDLLHandle, 'ma_lpf_init');
  ma_lpf_init_preallocated := GetProcAddress(aDLLHandle, 'ma_lpf_init_preallocated');
  ma_lpf_node_config_init := GetProcAddress(aDLLHandle, 'ma_lpf_node_config_init');
  ma_lpf_node_init := GetProcAddress(aDLLHandle, 'ma_lpf_node_init');
  ma_lpf_node_reinit := GetProcAddress(aDLLHandle, 'ma_lpf_node_reinit');
  ma_lpf_node_uninit := GetProcAddress(aDLLHandle, 'ma_lpf_node_uninit');
  ma_lpf_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_lpf_process_pcm_frames');
  ma_lpf_reinit := GetProcAddress(aDLLHandle, 'ma_lpf_reinit');
  ma_lpf_uninit := GetProcAddress(aDLLHandle, 'ma_lpf_uninit');
  ma_lpf1_clear_cache := GetProcAddress(aDLLHandle, 'ma_lpf1_clear_cache');
  ma_lpf1_config_init := GetProcAddress(aDLLHandle, 'ma_lpf1_config_init');
  ma_lpf1_get_heap_size := GetProcAddress(aDLLHandle, 'ma_lpf1_get_heap_size');
  ma_lpf1_get_latency := GetProcAddress(aDLLHandle, 'ma_lpf1_get_latency');
  ma_lpf1_init := GetProcAddress(aDLLHandle, 'ma_lpf1_init');
  ma_lpf1_init_preallocated := GetProcAddress(aDLLHandle, 'ma_lpf1_init_preallocated');
  ma_lpf1_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_lpf1_process_pcm_frames');
  ma_lpf1_reinit := GetProcAddress(aDLLHandle, 'ma_lpf1_reinit');
  ma_lpf1_uninit := GetProcAddress(aDLLHandle, 'ma_lpf1_uninit');
  ma_lpf2_clear_cache := GetProcAddress(aDLLHandle, 'ma_lpf2_clear_cache');
  ma_lpf2_config_init := GetProcAddress(aDLLHandle, 'ma_lpf2_config_init');
  ma_lpf2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_lpf2_get_heap_size');
  ma_lpf2_get_latency := GetProcAddress(aDLLHandle, 'ma_lpf2_get_latency');
  ma_lpf2_init := GetProcAddress(aDLLHandle, 'ma_lpf2_init');
  ma_lpf2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_lpf2_init_preallocated');
  ma_lpf2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_lpf2_process_pcm_frames');
  ma_lpf2_reinit := GetProcAddress(aDLLHandle, 'ma_lpf2_reinit');
  ma_lpf2_uninit := GetProcAddress(aDLLHandle, 'ma_lpf2_uninit');
  ma_malloc := GetProcAddress(aDLLHandle, 'ma_malloc');
  ma_mix_pcm_frames_f32 := GetProcAddress(aDLLHandle, 'ma_mix_pcm_frames_f32');
  ma_mutex_init := GetProcAddress(aDLLHandle, 'ma_mutex_init');
  ma_mutex_lock := GetProcAddress(aDLLHandle, 'ma_mutex_lock');
  ma_mutex_uninit := GetProcAddress(aDLLHandle, 'ma_mutex_uninit');
  ma_mutex_unlock := GetProcAddress(aDLLHandle, 'ma_mutex_unlock');
  ma_node_attach_output_bus := GetProcAddress(aDLLHandle, 'ma_node_attach_output_bus');
  ma_node_config_init := GetProcAddress(aDLLHandle, 'ma_node_config_init');
  ma_node_detach_all_output_buses := GetProcAddress(aDLLHandle, 'ma_node_detach_all_output_buses');
  ma_node_detach_output_bus := GetProcAddress(aDLLHandle, 'ma_node_detach_output_bus');
  ma_node_get_heap_size := GetProcAddress(aDLLHandle, 'ma_node_get_heap_size');
  ma_node_get_input_bus_count := GetProcAddress(aDLLHandle, 'ma_node_get_input_bus_count');
  ma_node_get_input_channels := GetProcAddress(aDLLHandle, 'ma_node_get_input_channels');
  ma_node_get_node_graph := GetProcAddress(aDLLHandle, 'ma_node_get_node_graph');
  ma_node_get_output_bus_count := GetProcAddress(aDLLHandle, 'ma_node_get_output_bus_count');
  ma_node_get_output_bus_volume := GetProcAddress(aDLLHandle, 'ma_node_get_output_bus_volume');
  ma_node_get_output_channels := GetProcAddress(aDLLHandle, 'ma_node_get_output_channels');
  ma_node_get_state := GetProcAddress(aDLLHandle, 'ma_node_get_state');
  ma_node_get_state_by_time := GetProcAddress(aDLLHandle, 'ma_node_get_state_by_time');
  ma_node_get_state_by_time_range := GetProcAddress(aDLLHandle, 'ma_node_get_state_by_time_range');
  ma_node_get_state_time := GetProcAddress(aDLLHandle, 'ma_node_get_state_time');
  ma_node_get_time := GetProcAddress(aDLLHandle, 'ma_node_get_time');
  ma_node_graph_config_init := GetProcAddress(aDLLHandle, 'ma_node_graph_config_init');
  ma_node_graph_get_channels := GetProcAddress(aDLLHandle, 'ma_node_graph_get_channels');
  ma_node_graph_get_endpoint := GetProcAddress(aDLLHandle, 'ma_node_graph_get_endpoint');
  ma_node_graph_get_time := GetProcAddress(aDLLHandle, 'ma_node_graph_get_time');
  ma_node_graph_init := GetProcAddress(aDLLHandle, 'ma_node_graph_init');
  ma_node_graph_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_node_graph_read_pcm_frames');
  ma_node_graph_set_time := GetProcAddress(aDLLHandle, 'ma_node_graph_set_time');
  ma_node_graph_uninit := GetProcAddress(aDLLHandle, 'ma_node_graph_uninit');
  ma_node_init := GetProcAddress(aDLLHandle, 'ma_node_init');
  ma_node_init_preallocated := GetProcAddress(aDLLHandle, 'ma_node_init_preallocated');
  ma_node_set_output_bus_volume := GetProcAddress(aDLLHandle, 'ma_node_set_output_bus_volume');
  ma_node_set_state := GetProcAddress(aDLLHandle, 'ma_node_set_state');
  ma_node_set_state_time := GetProcAddress(aDLLHandle, 'ma_node_set_state_time');
  ma_node_set_time := GetProcAddress(aDLLHandle, 'ma_node_set_time');
  ma_node_uninit := GetProcAddress(aDLLHandle, 'ma_node_uninit');
  ma_noise_config_init := GetProcAddress(aDLLHandle, 'ma_noise_config_init');
  ma_noise_get_heap_size := GetProcAddress(aDLLHandle, 'ma_noise_get_heap_size');
  ma_noise_init := GetProcAddress(aDLLHandle, 'ma_noise_init');
  ma_noise_init_preallocated := GetProcAddress(aDLLHandle, 'ma_noise_init_preallocated');
  ma_noise_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_noise_read_pcm_frames');
  ma_noise_set_amplitude := GetProcAddress(aDLLHandle, 'ma_noise_set_amplitude');
  ma_noise_set_seed := GetProcAddress(aDLLHandle, 'ma_noise_set_seed');
  ma_noise_set_type := GetProcAddress(aDLLHandle, 'ma_noise_set_type');
  ma_noise_uninit := GetProcAddress(aDLLHandle, 'ma_noise_uninit');
  ma_notch_node_config_init := GetProcAddress(aDLLHandle, 'ma_notch_node_config_init');
  ma_notch_node_init := GetProcAddress(aDLLHandle, 'ma_notch_node_init');
  ma_notch_node_reinit := GetProcAddress(aDLLHandle, 'ma_notch_node_reinit');
  ma_notch_node_uninit := GetProcAddress(aDLLHandle, 'ma_notch_node_uninit');
  ma_notch2_config_init := GetProcAddress(aDLLHandle, 'ma_notch2_config_init');
  ma_notch2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_notch2_get_heap_size');
  ma_notch2_get_latency := GetProcAddress(aDLLHandle, 'ma_notch2_get_latency');
  ma_notch2_init := GetProcAddress(aDLLHandle, 'ma_notch2_init');
  ma_notch2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_notch2_init_preallocated');
  ma_notch2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_notch2_process_pcm_frames');
  ma_notch2_reinit := GetProcAddress(aDLLHandle, 'ma_notch2_reinit');
  ma_notch2_uninit := GetProcAddress(aDLLHandle, 'ma_notch2_uninit');
  ma_offset_pcm_frames_const_ptr := GetProcAddress(aDLLHandle, 'ma_offset_pcm_frames_const_ptr');
  ma_offset_pcm_frames_ptr := GetProcAddress(aDLLHandle, 'ma_offset_pcm_frames_ptr');
  ma_paged_audio_buffer_config_init := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_config_init');
  ma_paged_audio_buffer_data_allocate_and_append_page := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_allocate_and_append_page');
  ma_paged_audio_buffer_data_allocate_page := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_allocate_page');
  ma_paged_audio_buffer_data_append_page := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_append_page');
  ma_paged_audio_buffer_data_free_page := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_free_page');
  ma_paged_audio_buffer_data_get_head := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_get_head');
  ma_paged_audio_buffer_data_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_get_length_in_pcm_frames');
  ma_paged_audio_buffer_data_get_tail := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_get_tail');
  ma_paged_audio_buffer_data_init := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_init');
  ma_paged_audio_buffer_data_uninit := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_data_uninit');
  ma_paged_audio_buffer_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_get_cursor_in_pcm_frames');
  ma_paged_audio_buffer_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_get_length_in_pcm_frames');
  ma_paged_audio_buffer_init := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_init');
  ma_paged_audio_buffer_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_read_pcm_frames');
  ma_paged_audio_buffer_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_seek_to_pcm_frame');
  ma_paged_audio_buffer_uninit := GetProcAddress(aDLLHandle, 'ma_paged_audio_buffer_uninit');
  ma_panner_config_init := GetProcAddress(aDLLHandle, 'ma_panner_config_init');
  ma_panner_get_mode := GetProcAddress(aDLLHandle, 'ma_panner_get_mode');
  ma_panner_get_pan := GetProcAddress(aDLLHandle, 'ma_panner_get_pan');
  ma_panner_init := GetProcAddress(aDLLHandle, 'ma_panner_init');
  ma_panner_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_panner_process_pcm_frames');
  ma_panner_set_mode := GetProcAddress(aDLLHandle, 'ma_panner_set_mode');
  ma_panner_set_pan := GetProcAddress(aDLLHandle, 'ma_panner_set_pan');
  ma_pcm_convert := GetProcAddress(aDLLHandle, 'ma_pcm_convert');
  ma_pcm_f32_to_s16 := GetProcAddress(aDLLHandle, 'ma_pcm_f32_to_s16');
  ma_pcm_f32_to_s24 := GetProcAddress(aDLLHandle, 'ma_pcm_f32_to_s24');
  ma_pcm_f32_to_s32 := GetProcAddress(aDLLHandle, 'ma_pcm_f32_to_s32');
  ma_pcm_f32_to_u8 := GetProcAddress(aDLLHandle, 'ma_pcm_f32_to_u8');
  ma_pcm_rb_acquire_read := GetProcAddress(aDLLHandle, 'ma_pcm_rb_acquire_read');
  ma_pcm_rb_acquire_write := GetProcAddress(aDLLHandle, 'ma_pcm_rb_acquire_write');
  ma_pcm_rb_available_read := GetProcAddress(aDLLHandle, 'ma_pcm_rb_available_read');
  ma_pcm_rb_available_write := GetProcAddress(aDLLHandle, 'ma_pcm_rb_available_write');
  ma_pcm_rb_commit_read := GetProcAddress(aDLLHandle, 'ma_pcm_rb_commit_read');
  ma_pcm_rb_commit_write := GetProcAddress(aDLLHandle, 'ma_pcm_rb_commit_write');
  ma_pcm_rb_get_channels := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_channels');
  ma_pcm_rb_get_format := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_format');
  ma_pcm_rb_get_sample_rate := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_sample_rate');
  ma_pcm_rb_get_subbuffer_offset := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_subbuffer_offset');
  ma_pcm_rb_get_subbuffer_ptr := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_subbuffer_ptr');
  ma_pcm_rb_get_subbuffer_size := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_subbuffer_size');
  ma_pcm_rb_get_subbuffer_stride := GetProcAddress(aDLLHandle, 'ma_pcm_rb_get_subbuffer_stride');
  ma_pcm_rb_init := GetProcAddress(aDLLHandle, 'ma_pcm_rb_init');
  ma_pcm_rb_init_ex := GetProcAddress(aDLLHandle, 'ma_pcm_rb_init_ex');
  ma_pcm_rb_pointer_distance := GetProcAddress(aDLLHandle, 'ma_pcm_rb_pointer_distance');
  ma_pcm_rb_reset := GetProcAddress(aDLLHandle, 'ma_pcm_rb_reset');
  ma_pcm_rb_seek_read := GetProcAddress(aDLLHandle, 'ma_pcm_rb_seek_read');
  ma_pcm_rb_seek_write := GetProcAddress(aDLLHandle, 'ma_pcm_rb_seek_write');
  ma_pcm_rb_set_sample_rate := GetProcAddress(aDLLHandle, 'ma_pcm_rb_set_sample_rate');
  ma_pcm_rb_uninit := GetProcAddress(aDLLHandle, 'ma_pcm_rb_uninit');
  ma_pcm_s16_to_f32 := GetProcAddress(aDLLHandle, 'ma_pcm_s16_to_f32');
  ma_pcm_s16_to_s24 := GetProcAddress(aDLLHandle, 'ma_pcm_s16_to_s24');
  ma_pcm_s16_to_s32 := GetProcAddress(aDLLHandle, 'ma_pcm_s16_to_s32');
  ma_pcm_s16_to_u8 := GetProcAddress(aDLLHandle, 'ma_pcm_s16_to_u8');
  ma_pcm_s24_to_f32 := GetProcAddress(aDLLHandle, 'ma_pcm_s24_to_f32');
  ma_pcm_s24_to_s16 := GetProcAddress(aDLLHandle, 'ma_pcm_s24_to_s16');
  ma_pcm_s24_to_s32 := GetProcAddress(aDLLHandle, 'ma_pcm_s24_to_s32');
  ma_pcm_s24_to_u8 := GetProcAddress(aDLLHandle, 'ma_pcm_s24_to_u8');
  ma_pcm_s32_to_f32 := GetProcAddress(aDLLHandle, 'ma_pcm_s32_to_f32');
  ma_pcm_s32_to_s16 := GetProcAddress(aDLLHandle, 'ma_pcm_s32_to_s16');
  ma_pcm_s32_to_s24 := GetProcAddress(aDLLHandle, 'ma_pcm_s32_to_s24');
  ma_pcm_s32_to_u8 := GetProcAddress(aDLLHandle, 'ma_pcm_s32_to_u8');
  ma_pcm_u8_to_f32 := GetProcAddress(aDLLHandle, 'ma_pcm_u8_to_f32');
  ma_pcm_u8_to_s16 := GetProcAddress(aDLLHandle, 'ma_pcm_u8_to_s16');
  ma_pcm_u8_to_s24 := GetProcAddress(aDLLHandle, 'ma_pcm_u8_to_s24');
  ma_pcm_u8_to_s32 := GetProcAddress(aDLLHandle, 'ma_pcm_u8_to_s32');
  ma_peak_node_config_init := GetProcAddress(aDLLHandle, 'ma_peak_node_config_init');
  ma_peak_node_init := GetProcAddress(aDLLHandle, 'ma_peak_node_init');
  ma_peak_node_reinit := GetProcAddress(aDLLHandle, 'ma_peak_node_reinit');
  ma_peak_node_uninit := GetProcAddress(aDLLHandle, 'ma_peak_node_uninit');
  ma_peak2_config_init := GetProcAddress(aDLLHandle, 'ma_peak2_config_init');
  ma_peak2_get_heap_size := GetProcAddress(aDLLHandle, 'ma_peak2_get_heap_size');
  ma_peak2_get_latency := GetProcAddress(aDLLHandle, 'ma_peak2_get_latency');
  ma_peak2_init := GetProcAddress(aDLLHandle, 'ma_peak2_init');
  ma_peak2_init_preallocated := GetProcAddress(aDLLHandle, 'ma_peak2_init_preallocated');
  ma_peak2_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_peak2_process_pcm_frames');
  ma_peak2_reinit := GetProcAddress(aDLLHandle, 'ma_peak2_reinit');
  ma_peak2_uninit := GetProcAddress(aDLLHandle, 'ma_peak2_uninit');
  ma_pulsewave_config_init := GetProcAddress(aDLLHandle, 'ma_pulsewave_config_init');
  ma_pulsewave_init := GetProcAddress(aDLLHandle, 'ma_pulsewave_init');
  ma_pulsewave_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_pulsewave_read_pcm_frames');
  ma_pulsewave_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_pulsewave_seek_to_pcm_frame');
  ma_pulsewave_set_amplitude := GetProcAddress(aDLLHandle, 'ma_pulsewave_set_amplitude');
  ma_pulsewave_set_duty_cycle := GetProcAddress(aDLLHandle, 'ma_pulsewave_set_duty_cycle');
  ma_pulsewave_set_frequency := GetProcAddress(aDLLHandle, 'ma_pulsewave_set_frequency');
  ma_pulsewave_set_sample_rate := GetProcAddress(aDLLHandle, 'ma_pulsewave_set_sample_rate');
  ma_pulsewave_uninit := GetProcAddress(aDLLHandle, 'ma_pulsewave_uninit');
  ma_rb_acquire_read := GetProcAddress(aDLLHandle, 'ma_rb_acquire_read');
  ma_rb_acquire_write := GetProcAddress(aDLLHandle, 'ma_rb_acquire_write');
  ma_rb_available_read := GetProcAddress(aDLLHandle, 'ma_rb_available_read');
  ma_rb_available_write := GetProcAddress(aDLLHandle, 'ma_rb_available_write');
  ma_rb_commit_read := GetProcAddress(aDLLHandle, 'ma_rb_commit_read');
  ma_rb_commit_write := GetProcAddress(aDLLHandle, 'ma_rb_commit_write');
  ma_rb_get_subbuffer_offset := GetProcAddress(aDLLHandle, 'ma_rb_get_subbuffer_offset');
  ma_rb_get_subbuffer_ptr := GetProcAddress(aDLLHandle, 'ma_rb_get_subbuffer_ptr');
  ma_rb_get_subbuffer_size := GetProcAddress(aDLLHandle, 'ma_rb_get_subbuffer_size');
  ma_rb_get_subbuffer_stride := GetProcAddress(aDLLHandle, 'ma_rb_get_subbuffer_stride');
  ma_rb_init := GetProcAddress(aDLLHandle, 'ma_rb_init');
  ma_rb_init_ex := GetProcAddress(aDLLHandle, 'ma_rb_init_ex');
  ma_rb_pointer_distance := GetProcAddress(aDLLHandle, 'ma_rb_pointer_distance');
  ma_rb_reset := GetProcAddress(aDLLHandle, 'ma_rb_reset');
  ma_rb_seek_read := GetProcAddress(aDLLHandle, 'ma_rb_seek_read');
  ma_rb_seek_write := GetProcAddress(aDLLHandle, 'ma_rb_seek_write');
  ma_rb_uninit := GetProcAddress(aDLLHandle, 'ma_rb_uninit');
  ma_realloc := GetProcAddress(aDLLHandle, 'ma_realloc');
  ma_resampler_config_init := GetProcAddress(aDLLHandle, 'ma_resampler_config_init');
  ma_resampler_get_expected_output_frame_count := GetProcAddress(aDLLHandle, 'ma_resampler_get_expected_output_frame_count');
  ma_resampler_get_heap_size := GetProcAddress(aDLLHandle, 'ma_resampler_get_heap_size');
  ma_resampler_get_input_latency := GetProcAddress(aDLLHandle, 'ma_resampler_get_input_latency');
  ma_resampler_get_output_latency := GetProcAddress(aDLLHandle, 'ma_resampler_get_output_latency');
  ma_resampler_get_required_input_frame_count := GetProcAddress(aDLLHandle, 'ma_resampler_get_required_input_frame_count');
  ma_resampler_init := GetProcAddress(aDLLHandle, 'ma_resampler_init');
  ma_resampler_init_preallocated := GetProcAddress(aDLLHandle, 'ma_resampler_init_preallocated');
  ma_resampler_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resampler_process_pcm_frames');
  ma_resampler_reset := GetProcAddress(aDLLHandle, 'ma_resampler_reset');
  ma_resampler_set_rate := GetProcAddress(aDLLHandle, 'ma_resampler_set_rate');
  ma_resampler_set_rate_ratio := GetProcAddress(aDLLHandle, 'ma_resampler_set_rate_ratio');
  ma_resampler_uninit := GetProcAddress(aDLLHandle, 'ma_resampler_uninit');
  ma_resource_manager_config_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_config_init');
  ma_resource_manager_data_buffer_get_available_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_get_available_frames');
  ma_resource_manager_data_buffer_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_get_cursor_in_pcm_frames');
  ma_resource_manager_data_buffer_get_data_format := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_get_data_format');
  ma_resource_manager_data_buffer_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_get_length_in_pcm_frames');
  ma_resource_manager_data_buffer_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_init');
  ma_resource_manager_data_buffer_init_copy := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_init_copy');
  ma_resource_manager_data_buffer_init_ex := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_init_ex');
  ma_resource_manager_data_buffer_init_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_init_w');
  ma_resource_manager_data_buffer_is_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_is_looping');
  ma_resource_manager_data_buffer_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_read_pcm_frames');
  ma_resource_manager_data_buffer_result := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_result');
  ma_resource_manager_data_buffer_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_seek_to_pcm_frame');
  ma_resource_manager_data_buffer_set_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_set_looping');
  ma_resource_manager_data_buffer_uninit := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_buffer_uninit');
  ma_resource_manager_data_source_config_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_config_init');
  ma_resource_manager_data_source_get_available_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_get_available_frames');
  ma_resource_manager_data_source_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_get_cursor_in_pcm_frames');
  ma_resource_manager_data_source_get_data_format := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_get_data_format');
  ma_resource_manager_data_source_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_get_length_in_pcm_frames');
  ma_resource_manager_data_source_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_init');
  ma_resource_manager_data_source_init_copy := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_init_copy');
  ma_resource_manager_data_source_init_ex := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_init_ex');
  ma_resource_manager_data_source_init_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_init_w');
  ma_resource_manager_data_source_is_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_is_looping');
  ma_resource_manager_data_source_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_read_pcm_frames');
  ma_resource_manager_data_source_result := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_result');
  ma_resource_manager_data_source_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_seek_to_pcm_frame');
  ma_resource_manager_data_source_set_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_set_looping');
  ma_resource_manager_data_source_uninit := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_source_uninit');
  ma_resource_manager_data_stream_get_available_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_get_available_frames');
  ma_resource_manager_data_stream_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_get_cursor_in_pcm_frames');
  ma_resource_manager_data_stream_get_data_format := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_get_data_format');
  ma_resource_manager_data_stream_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_get_length_in_pcm_frames');
  ma_resource_manager_data_stream_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_init');
  ma_resource_manager_data_stream_init_ex := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_init_ex');
  ma_resource_manager_data_stream_init_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_init_w');
  ma_resource_manager_data_stream_is_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_is_looping');
  ma_resource_manager_data_stream_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_read_pcm_frames');
  ma_resource_manager_data_stream_result := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_result');
  ma_resource_manager_data_stream_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_seek_to_pcm_frame');
  ma_resource_manager_data_stream_set_looping := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_set_looping');
  ma_resource_manager_data_stream_uninit := GetProcAddress(aDLLHandle, 'ma_resource_manager_data_stream_uninit');
  ma_resource_manager_get_log := GetProcAddress(aDLLHandle, 'ma_resource_manager_get_log');
  ma_resource_manager_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_init');
  ma_resource_manager_next_job := GetProcAddress(aDLLHandle, 'ma_resource_manager_next_job');
  ma_resource_manager_pipeline_notifications_init := GetProcAddress(aDLLHandle, 'ma_resource_manager_pipeline_notifications_init');
  ma_resource_manager_post_job := GetProcAddress(aDLLHandle, 'ma_resource_manager_post_job');
  ma_resource_manager_post_job_quit := GetProcAddress(aDLLHandle, 'ma_resource_manager_post_job_quit');
  ma_resource_manager_process_job := GetProcAddress(aDLLHandle, 'ma_resource_manager_process_job');
  ma_resource_manager_process_next_job := GetProcAddress(aDLLHandle, 'ma_resource_manager_process_next_job');
  ma_resource_manager_register_decoded_data := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_decoded_data');
  ma_resource_manager_register_decoded_data_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_decoded_data_w');
  ma_resource_manager_register_encoded_data := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_encoded_data');
  ma_resource_manager_register_encoded_data_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_encoded_data_w');
  ma_resource_manager_register_file := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_file');
  ma_resource_manager_register_file_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_register_file_w');
  ma_resource_manager_uninit := GetProcAddress(aDLLHandle, 'ma_resource_manager_uninit');
  ma_resource_manager_unregister_data := GetProcAddress(aDLLHandle, 'ma_resource_manager_unregister_data');
  ma_resource_manager_unregister_data_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_unregister_data_w');
  ma_resource_manager_unregister_file := GetProcAddress(aDLLHandle, 'ma_resource_manager_unregister_file');
  ma_resource_manager_unregister_file_w := GetProcAddress(aDLLHandle, 'ma_resource_manager_unregister_file_w');
  ma_result_description := GetProcAddress(aDLLHandle, 'ma_result_description');
  ma_semaphore_init := GetProcAddress(aDLLHandle, 'ma_semaphore_init');
  ma_semaphore_release := GetProcAddress(aDLLHandle, 'ma_semaphore_release');
  ma_semaphore_uninit := GetProcAddress(aDLLHandle, 'ma_semaphore_uninit');
  ma_semaphore_wait := GetProcAddress(aDLLHandle, 'ma_semaphore_wait');
  ma_silence_pcm_frames := GetProcAddress(aDLLHandle, 'ma_silence_pcm_frames');
  ma_slot_allocator_alloc := GetProcAddress(aDLLHandle, 'ma_slot_allocator_alloc');
  ma_slot_allocator_config_init := GetProcAddress(aDLLHandle, 'ma_slot_allocator_config_init');
  ma_slot_allocator_free := GetProcAddress(aDLLHandle, 'ma_slot_allocator_free');
  ma_slot_allocator_get_heap_size := GetProcAddress(aDLLHandle, 'ma_slot_allocator_get_heap_size');
  ma_slot_allocator_init := GetProcAddress(aDLLHandle, 'ma_slot_allocator_init');
  ma_slot_allocator_init_preallocated := GetProcAddress(aDLLHandle, 'ma_slot_allocator_init_preallocated');
  ma_slot_allocator_uninit := GetProcAddress(aDLLHandle, 'ma_slot_allocator_uninit');
  ma_sound_at_end := GetProcAddress(aDLLHandle, 'ma_sound_at_end');
  ma_sound_config_init := GetProcAddress(aDLLHandle, 'ma_sound_config_init');
  ma_sound_config_init_2 := GetProcAddress(aDLLHandle, 'ma_sound_config_init_2');
  ma_sound_get_attenuation_model := GetProcAddress(aDLLHandle, 'ma_sound_get_attenuation_model');
  ma_sound_get_cone := GetProcAddress(aDLLHandle, 'ma_sound_get_cone');
  ma_sound_get_current_fade_volume := GetProcAddress(aDLLHandle, 'ma_sound_get_current_fade_volume');
  ma_sound_get_cursor_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_get_cursor_in_pcm_frames');
  ma_sound_get_cursor_in_seconds := GetProcAddress(aDLLHandle, 'ma_sound_get_cursor_in_seconds');
  ma_sound_get_data_format := GetProcAddress(aDLLHandle, 'ma_sound_get_data_format');
  ma_sound_get_data_source := GetProcAddress(aDLLHandle, 'ma_sound_get_data_source');
  ma_sound_get_direction := GetProcAddress(aDLLHandle, 'ma_sound_get_direction');
  ma_sound_get_direction_to_listener := GetProcAddress(aDLLHandle, 'ma_sound_get_direction_to_listener');
  ma_sound_get_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_sound_get_directional_attenuation_factor');
  ma_sound_get_doppler_factor := GetProcAddress(aDLLHandle, 'ma_sound_get_doppler_factor');
  ma_sound_get_engine := GetProcAddress(aDLLHandle, 'ma_sound_get_engine');
  ma_sound_get_length_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_get_length_in_pcm_frames');
  ma_sound_get_length_in_seconds := GetProcAddress(aDLLHandle, 'ma_sound_get_length_in_seconds');
  ma_sound_get_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_get_listener_index');
  ma_sound_get_max_distance := GetProcAddress(aDLLHandle, 'ma_sound_get_max_distance');
  ma_sound_get_max_gain := GetProcAddress(aDLLHandle, 'ma_sound_get_max_gain');
  ma_sound_get_min_distance := GetProcAddress(aDLLHandle, 'ma_sound_get_min_distance');
  ma_sound_get_min_gain := GetProcAddress(aDLLHandle, 'ma_sound_get_min_gain');
  ma_sound_get_pan := GetProcAddress(aDLLHandle, 'ma_sound_get_pan');
  ma_sound_get_pan_mode := GetProcAddress(aDLLHandle, 'ma_sound_get_pan_mode');
  ma_sound_get_pinned_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_get_pinned_listener_index');
  ma_sound_get_pitch := GetProcAddress(aDLLHandle, 'ma_sound_get_pitch');
  ma_sound_get_position := GetProcAddress(aDLLHandle, 'ma_sound_get_position');
  ma_sound_get_positioning := GetProcAddress(aDLLHandle, 'ma_sound_get_positioning');
  ma_sound_get_rolloff := GetProcAddress(aDLLHandle, 'ma_sound_get_rolloff');
  ma_sound_get_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_get_time_in_milliseconds');
  ma_sound_get_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_get_time_in_pcm_frames');
  ma_sound_get_velocity := GetProcAddress(aDLLHandle, 'ma_sound_get_velocity');
  ma_sound_get_volume := GetProcAddress(aDLLHandle, 'ma_sound_get_volume');
  ma_sound_group_config_init := GetProcAddress(aDLLHandle, 'ma_sound_group_config_init');
  ma_sound_group_config_init_2 := GetProcAddress(aDLLHandle, 'ma_sound_group_config_init_2');
  ma_sound_group_get_attenuation_model := GetProcAddress(aDLLHandle, 'ma_sound_group_get_attenuation_model');
  ma_sound_group_get_cone := GetProcAddress(aDLLHandle, 'ma_sound_group_get_cone');
  ma_sound_group_get_current_fade_volume := GetProcAddress(aDLLHandle, 'ma_sound_group_get_current_fade_volume');
  ma_sound_group_get_direction := GetProcAddress(aDLLHandle, 'ma_sound_group_get_direction');
  ma_sound_group_get_direction_to_listener := GetProcAddress(aDLLHandle, 'ma_sound_group_get_direction_to_listener');
  ma_sound_group_get_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_sound_group_get_directional_attenuation_factor');
  ma_sound_group_get_doppler_factor := GetProcAddress(aDLLHandle, 'ma_sound_group_get_doppler_factor');
  ma_sound_group_get_engine := GetProcAddress(aDLLHandle, 'ma_sound_group_get_engine');
  ma_sound_group_get_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_group_get_listener_index');
  ma_sound_group_get_max_distance := GetProcAddress(aDLLHandle, 'ma_sound_group_get_max_distance');
  ma_sound_group_get_max_gain := GetProcAddress(aDLLHandle, 'ma_sound_group_get_max_gain');
  ma_sound_group_get_min_distance := GetProcAddress(aDLLHandle, 'ma_sound_group_get_min_distance');
  ma_sound_group_get_min_gain := GetProcAddress(aDLLHandle, 'ma_sound_group_get_min_gain');
  ma_sound_group_get_pan := GetProcAddress(aDLLHandle, 'ma_sound_group_get_pan');
  ma_sound_group_get_pan_mode := GetProcAddress(aDLLHandle, 'ma_sound_group_get_pan_mode');
  ma_sound_group_get_pinned_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_group_get_pinned_listener_index');
  ma_sound_group_get_pitch := GetProcAddress(aDLLHandle, 'ma_sound_group_get_pitch');
  ma_sound_group_get_position := GetProcAddress(aDLLHandle, 'ma_sound_group_get_position');
  ma_sound_group_get_positioning := GetProcAddress(aDLLHandle, 'ma_sound_group_get_positioning');
  ma_sound_group_get_rolloff := GetProcAddress(aDLLHandle, 'ma_sound_group_get_rolloff');
  ma_sound_group_get_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_group_get_time_in_pcm_frames');
  ma_sound_group_get_velocity := GetProcAddress(aDLLHandle, 'ma_sound_group_get_velocity');
  ma_sound_group_get_volume := GetProcAddress(aDLLHandle, 'ma_sound_group_get_volume');
  ma_sound_group_init := GetProcAddress(aDLLHandle, 'ma_sound_group_init');
  ma_sound_group_init_ex := GetProcAddress(aDLLHandle, 'ma_sound_group_init_ex');
  ma_sound_group_is_playing := GetProcAddress(aDLLHandle, 'ma_sound_group_is_playing');
  ma_sound_group_is_spatialization_enabled := GetProcAddress(aDLLHandle, 'ma_sound_group_is_spatialization_enabled');
  ma_sound_group_set_attenuation_model := GetProcAddress(aDLLHandle, 'ma_sound_group_set_attenuation_model');
  ma_sound_group_set_cone := GetProcAddress(aDLLHandle, 'ma_sound_group_set_cone');
  ma_sound_group_set_direction := GetProcAddress(aDLLHandle, 'ma_sound_group_set_direction');
  ma_sound_group_set_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_sound_group_set_directional_attenuation_factor');
  ma_sound_group_set_doppler_factor := GetProcAddress(aDLLHandle, 'ma_sound_group_set_doppler_factor');
  ma_sound_group_set_fade_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_group_set_fade_in_milliseconds');
  ma_sound_group_set_fade_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_group_set_fade_in_pcm_frames');
  ma_sound_group_set_max_distance := GetProcAddress(aDLLHandle, 'ma_sound_group_set_max_distance');
  ma_sound_group_set_max_gain := GetProcAddress(aDLLHandle, 'ma_sound_group_set_max_gain');
  ma_sound_group_set_min_distance := GetProcAddress(aDLLHandle, 'ma_sound_group_set_min_distance');
  ma_sound_group_set_min_gain := GetProcAddress(aDLLHandle, 'ma_sound_group_set_min_gain');
  ma_sound_group_set_pan := GetProcAddress(aDLLHandle, 'ma_sound_group_set_pan');
  ma_sound_group_set_pan_mode := GetProcAddress(aDLLHandle, 'ma_sound_group_set_pan_mode');
  ma_sound_group_set_pinned_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_group_set_pinned_listener_index');
  ma_sound_group_set_pitch := GetProcAddress(aDLLHandle, 'ma_sound_group_set_pitch');
  ma_sound_group_set_position := GetProcAddress(aDLLHandle, 'ma_sound_group_set_position');
  ma_sound_group_set_positioning := GetProcAddress(aDLLHandle, 'ma_sound_group_set_positioning');
  ma_sound_group_set_rolloff := GetProcAddress(aDLLHandle, 'ma_sound_group_set_rolloff');
  ma_sound_group_set_spatialization_enabled := GetProcAddress(aDLLHandle, 'ma_sound_group_set_spatialization_enabled');
  ma_sound_group_set_start_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_group_set_start_time_in_milliseconds');
  ma_sound_group_set_start_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_group_set_start_time_in_pcm_frames');
  ma_sound_group_set_stop_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_group_set_stop_time_in_milliseconds');
  ma_sound_group_set_stop_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_group_set_stop_time_in_pcm_frames');
  ma_sound_group_set_velocity := GetProcAddress(aDLLHandle, 'ma_sound_group_set_velocity');
  ma_sound_group_set_volume := GetProcAddress(aDLLHandle, 'ma_sound_group_set_volume');
  ma_sound_group_start := GetProcAddress(aDLLHandle, 'ma_sound_group_start');
  ma_sound_group_stop := GetProcAddress(aDLLHandle, 'ma_sound_group_stop');
  ma_sound_group_uninit := GetProcAddress(aDLLHandle, 'ma_sound_group_uninit');
  ma_sound_init_copy := GetProcAddress(aDLLHandle, 'ma_sound_init_copy');
  ma_sound_init_ex := GetProcAddress(aDLLHandle, 'ma_sound_init_ex');
  ma_sound_init_from_data_source := GetProcAddress(aDLLHandle, 'ma_sound_init_from_data_source');
  ma_sound_init_from_file := GetProcAddress(aDLLHandle, 'ma_sound_init_from_file');
  ma_sound_init_from_file_w := GetProcAddress(aDLLHandle, 'ma_sound_init_from_file_w');
  ma_sound_is_looping := GetProcAddress(aDLLHandle, 'ma_sound_is_looping');
  ma_sound_is_playing := GetProcAddress(aDLLHandle, 'ma_sound_is_playing');
  ma_sound_is_spatialization_enabled := GetProcAddress(aDLLHandle, 'ma_sound_is_spatialization_enabled');
  ma_sound_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_sound_seek_to_pcm_frame');
  ma_sound_seek_to_second := GetProcAddress(aDLLHandle, 'ma_sound_seek_to_second');
  ma_sound_set_attenuation_model := GetProcAddress(aDLLHandle, 'ma_sound_set_attenuation_model');
  ma_sound_set_cone := GetProcAddress(aDLLHandle, 'ma_sound_set_cone');
  ma_sound_set_direction := GetProcAddress(aDLLHandle, 'ma_sound_set_direction');
  ma_sound_set_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_sound_set_directional_attenuation_factor');
  ma_sound_set_doppler_factor := GetProcAddress(aDLLHandle, 'ma_sound_set_doppler_factor');
  ma_sound_set_end_callback := GetProcAddress(aDLLHandle, 'ma_sound_set_end_callback');
  ma_sound_set_fade_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_set_fade_in_milliseconds');
  ma_sound_set_fade_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_set_fade_in_pcm_frames');
  ma_sound_set_fade_start_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_set_fade_start_in_milliseconds');
  ma_sound_set_fade_start_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_set_fade_start_in_pcm_frames');
  ma_sound_set_looping := GetProcAddress(aDLLHandle, 'ma_sound_set_looping');
  ma_sound_set_max_distance := GetProcAddress(aDLLHandle, 'ma_sound_set_max_distance');
  ma_sound_set_max_gain := GetProcAddress(aDLLHandle, 'ma_sound_set_max_gain');
  ma_sound_set_min_distance := GetProcAddress(aDLLHandle, 'ma_sound_set_min_distance');
  ma_sound_set_min_gain := GetProcAddress(aDLLHandle, 'ma_sound_set_min_gain');
  ma_sound_set_pan := GetProcAddress(aDLLHandle, 'ma_sound_set_pan');
  ma_sound_set_pan_mode := GetProcAddress(aDLLHandle, 'ma_sound_set_pan_mode');
  ma_sound_set_pinned_listener_index := GetProcAddress(aDLLHandle, 'ma_sound_set_pinned_listener_index');
  ma_sound_set_pitch := GetProcAddress(aDLLHandle, 'ma_sound_set_pitch');
  ma_sound_set_position := GetProcAddress(aDLLHandle, 'ma_sound_set_position');
  ma_sound_set_positioning := GetProcAddress(aDLLHandle, 'ma_sound_set_positioning');
  ma_sound_set_rolloff := GetProcAddress(aDLLHandle, 'ma_sound_set_rolloff');
  ma_sound_set_spatialization_enabled := GetProcAddress(aDLLHandle, 'ma_sound_set_spatialization_enabled');
  ma_sound_set_start_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_set_start_time_in_milliseconds');
  ma_sound_set_start_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_set_start_time_in_pcm_frames');
  ma_sound_set_stop_time_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_set_stop_time_in_milliseconds');
  ma_sound_set_stop_time_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_set_stop_time_in_pcm_frames');
  ma_sound_set_stop_time_with_fade_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_set_stop_time_with_fade_in_milliseconds');
  ma_sound_set_stop_time_with_fade_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_set_stop_time_with_fade_in_pcm_frames');
  ma_sound_set_velocity := GetProcAddress(aDLLHandle, 'ma_sound_set_velocity');
  ma_sound_set_volume := GetProcAddress(aDLLHandle, 'ma_sound_set_volume');
  ma_sound_start := GetProcAddress(aDLLHandle, 'ma_sound_start');
  ma_sound_stop := GetProcAddress(aDLLHandle, 'ma_sound_stop');
  ma_sound_stop_with_fade_in_milliseconds := GetProcAddress(aDLLHandle, 'ma_sound_stop_with_fade_in_milliseconds');
  ma_sound_stop_with_fade_in_pcm_frames := GetProcAddress(aDLLHandle, 'ma_sound_stop_with_fade_in_pcm_frames');
  ma_sound_uninit := GetProcAddress(aDLLHandle, 'ma_sound_uninit');
  ma_spatializer_config_init := GetProcAddress(aDLLHandle, 'ma_spatializer_config_init');
  ma_spatializer_get_attenuation_model := GetProcAddress(aDLLHandle, 'ma_spatializer_get_attenuation_model');
  ma_spatializer_get_cone := GetProcAddress(aDLLHandle, 'ma_spatializer_get_cone');
  ma_spatializer_get_direction := GetProcAddress(aDLLHandle, 'ma_spatializer_get_direction');
  ma_spatializer_get_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_spatializer_get_directional_attenuation_factor');
  ma_spatializer_get_doppler_factor := GetProcAddress(aDLLHandle, 'ma_spatializer_get_doppler_factor');
  ma_spatializer_get_heap_size := GetProcAddress(aDLLHandle, 'ma_spatializer_get_heap_size');
  ma_spatializer_get_input_channels := GetProcAddress(aDLLHandle, 'ma_spatializer_get_input_channels');
  ma_spatializer_get_master_volume := GetProcAddress(aDLLHandle, 'ma_spatializer_get_master_volume');
  ma_spatializer_get_max_distance := GetProcAddress(aDLLHandle, 'ma_spatializer_get_max_distance');
  ma_spatializer_get_max_gain := GetProcAddress(aDLLHandle, 'ma_spatializer_get_max_gain');
  ma_spatializer_get_min_distance := GetProcAddress(aDLLHandle, 'ma_spatializer_get_min_distance');
  ma_spatializer_get_min_gain := GetProcAddress(aDLLHandle, 'ma_spatializer_get_min_gain');
  ma_spatializer_get_output_channels := GetProcAddress(aDLLHandle, 'ma_spatializer_get_output_channels');
  ma_spatializer_get_position := GetProcAddress(aDLLHandle, 'ma_spatializer_get_position');
  ma_spatializer_get_positioning := GetProcAddress(aDLLHandle, 'ma_spatializer_get_positioning');
  ma_spatializer_get_relative_position_and_direction := GetProcAddress(aDLLHandle, 'ma_spatializer_get_relative_position_and_direction');
  ma_spatializer_get_rolloff := GetProcAddress(aDLLHandle, 'ma_spatializer_get_rolloff');
  ma_spatializer_get_velocity := GetProcAddress(aDLLHandle, 'ma_spatializer_get_velocity');
  ma_spatializer_init := GetProcAddress(aDLLHandle, 'ma_spatializer_init');
  ma_spatializer_init_preallocated := GetProcAddress(aDLLHandle, 'ma_spatializer_init_preallocated');
  ma_spatializer_listener_config_init := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_config_init');
  ma_spatializer_listener_get_channel_map := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_channel_map');
  ma_spatializer_listener_get_cone := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_cone');
  ma_spatializer_listener_get_direction := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_direction');
  ma_spatializer_listener_get_heap_size := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_heap_size');
  ma_spatializer_listener_get_position := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_position');
  ma_spatializer_listener_get_speed_of_sound := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_speed_of_sound');
  ma_spatializer_listener_get_velocity := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_velocity');
  ma_spatializer_listener_get_world_up := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_get_world_up');
  ma_spatializer_listener_init := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_init');
  ma_spatializer_listener_init_preallocated := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_init_preallocated');
  ma_spatializer_listener_is_enabled := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_is_enabled');
  ma_spatializer_listener_set_cone := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_cone');
  ma_spatializer_listener_set_direction := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_direction');
  ma_spatializer_listener_set_enabled := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_enabled');
  ma_spatializer_listener_set_position := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_position');
  ma_spatializer_listener_set_speed_of_sound := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_speed_of_sound');
  ma_spatializer_listener_set_velocity := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_velocity');
  ma_spatializer_listener_set_world_up := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_set_world_up');
  ma_spatializer_listener_uninit := GetProcAddress(aDLLHandle, 'ma_spatializer_listener_uninit');
  ma_spatializer_process_pcm_frames := GetProcAddress(aDLLHandle, 'ma_spatializer_process_pcm_frames');
  ma_spatializer_set_attenuation_model := GetProcAddress(aDLLHandle, 'ma_spatializer_set_attenuation_model');
  ma_spatializer_set_cone := GetProcAddress(aDLLHandle, 'ma_spatializer_set_cone');
  ma_spatializer_set_direction := GetProcAddress(aDLLHandle, 'ma_spatializer_set_direction');
  ma_spatializer_set_directional_attenuation_factor := GetProcAddress(aDLLHandle, 'ma_spatializer_set_directional_attenuation_factor');
  ma_spatializer_set_doppler_factor := GetProcAddress(aDLLHandle, 'ma_spatializer_set_doppler_factor');
  ma_spatializer_set_master_volume := GetProcAddress(aDLLHandle, 'ma_spatializer_set_master_volume');
  ma_spatializer_set_max_distance := GetProcAddress(aDLLHandle, 'ma_spatializer_set_max_distance');
  ma_spatializer_set_max_gain := GetProcAddress(aDLLHandle, 'ma_spatializer_set_max_gain');
  ma_spatializer_set_min_distance := GetProcAddress(aDLLHandle, 'ma_spatializer_set_min_distance');
  ma_spatializer_set_min_gain := GetProcAddress(aDLLHandle, 'ma_spatializer_set_min_gain');
  ma_spatializer_set_position := GetProcAddress(aDLLHandle, 'ma_spatializer_set_position');
  ma_spatializer_set_positioning := GetProcAddress(aDLLHandle, 'ma_spatializer_set_positioning');
  ma_spatializer_set_rolloff := GetProcAddress(aDLLHandle, 'ma_spatializer_set_rolloff');
  ma_spatializer_set_velocity := GetProcAddress(aDLLHandle, 'ma_spatializer_set_velocity');
  ma_spatializer_uninit := GetProcAddress(aDLLHandle, 'ma_spatializer_uninit');
  ma_spinlock_lock := GetProcAddress(aDLLHandle, 'ma_spinlock_lock');
  ma_spinlock_lock_noyield := GetProcAddress(aDLLHandle, 'ma_spinlock_lock_noyield');
  ma_spinlock_unlock := GetProcAddress(aDLLHandle, 'ma_spinlock_unlock');
  ma_splitter_node_config_init := GetProcAddress(aDLLHandle, 'ma_splitter_node_config_init');
  ma_splitter_node_init := GetProcAddress(aDLLHandle, 'ma_splitter_node_init');
  ma_splitter_node_uninit := GetProcAddress(aDLLHandle, 'ma_splitter_node_uninit');
  ma_version := GetProcAddress(aDLLHandle, 'ma_version');
  ma_version_string := GetProcAddress(aDLLHandle, 'ma_version_string');
  ma_vfs_close := GetProcAddress(aDLLHandle, 'ma_vfs_close');
  ma_vfs_info := GetProcAddress(aDLLHandle, 'ma_vfs_info');
  ma_vfs_open := GetProcAddress(aDLLHandle, 'ma_vfs_open');
  ma_vfs_open_and_read_file := GetProcAddress(aDLLHandle, 'ma_vfs_open_and_read_file');
  ma_vfs_open_w := GetProcAddress(aDLLHandle, 'ma_vfs_open_w');
  ma_vfs_read := GetProcAddress(aDLLHandle, 'ma_vfs_read');
  ma_vfs_seek := GetProcAddress(aDLLHandle, 'ma_vfs_seek');
  ma_vfs_tell := GetProcAddress(aDLLHandle, 'ma_vfs_tell');
  ma_vfs_write := GetProcAddress(aDLLHandle, 'ma_vfs_write');
  ma_volume_db_to_linear := GetProcAddress(aDLLHandle, 'ma_volume_db_to_linear');
  ma_volume_linear_to_db := GetProcAddress(aDLLHandle, 'ma_volume_linear_to_db');
  ma_waveform_config_init := GetProcAddress(aDLLHandle, 'ma_waveform_config_init');
  ma_waveform_init := GetProcAddress(aDLLHandle, 'ma_waveform_init');
  ma_waveform_read_pcm_frames := GetProcAddress(aDLLHandle, 'ma_waveform_read_pcm_frames');
  ma_waveform_seek_to_pcm_frame := GetProcAddress(aDLLHandle, 'ma_waveform_seek_to_pcm_frame');
  ma_waveform_set_amplitude := GetProcAddress(aDLLHandle, 'ma_waveform_set_amplitude');
  ma_waveform_set_frequency := GetProcAddress(aDLLHandle, 'ma_waveform_set_frequency');
  ma_waveform_set_sample_rate := GetProcAddress(aDLLHandle, 'ma_waveform_set_sample_rate');
  ma_waveform_set_type := GetProcAddress(aDLLHandle, 'ma_waveform_set_type');
  ma_waveform_uninit := GetProcAddress(aDLLHandle, 'ma_waveform_uninit');
  plm_audio_create_with_buffer := GetProcAddress(aDLLHandle, 'plm_audio_create_with_buffer');
  plm_audio_decode := GetProcAddress(aDLLHandle, 'plm_audio_decode');
  plm_audio_destroy := GetProcAddress(aDLLHandle, 'plm_audio_destroy');
  plm_audio_get_samplerate := GetProcAddress(aDLLHandle, 'plm_audio_get_samplerate');
  plm_audio_get_time := GetProcAddress(aDLLHandle, 'plm_audio_get_time');
  plm_audio_has_ended := GetProcAddress(aDLLHandle, 'plm_audio_has_ended');
  plm_audio_has_header := GetProcAddress(aDLLHandle, 'plm_audio_has_header');
  plm_audio_rewind := GetProcAddress(aDLLHandle, 'plm_audio_rewind');
  plm_audio_set_time := GetProcAddress(aDLLHandle, 'plm_audio_set_time');
  plm_buffer_create_for_appending := GetProcAddress(aDLLHandle, 'plm_buffer_create_for_appending');
  plm_buffer_create_with_callbacks := GetProcAddress(aDLLHandle, 'plm_buffer_create_with_callbacks');
  plm_buffer_create_with_capacity := GetProcAddress(aDLLHandle, 'plm_buffer_create_with_capacity');
  plm_buffer_create_with_memory := GetProcAddress(aDLLHandle, 'plm_buffer_create_with_memory');
  plm_buffer_destroy := GetProcAddress(aDLLHandle, 'plm_buffer_destroy');
  plm_buffer_get_remaining := GetProcAddress(aDLLHandle, 'plm_buffer_get_remaining');
  plm_buffer_get_size := GetProcAddress(aDLLHandle, 'plm_buffer_get_size');
  plm_buffer_has_ended := GetProcAddress(aDLLHandle, 'plm_buffer_has_ended');
  plm_buffer_rewind := GetProcAddress(aDLLHandle, 'plm_buffer_rewind');
  plm_buffer_set_load_callback := GetProcAddress(aDLLHandle, 'plm_buffer_set_load_callback');
  plm_buffer_signal_end := GetProcAddress(aDLLHandle, 'plm_buffer_signal_end');
  plm_buffer_write := GetProcAddress(aDLLHandle, 'plm_buffer_write');
  plm_create_with_buffer := GetProcAddress(aDLLHandle, 'plm_create_with_buffer');
  plm_create_with_memory := GetProcAddress(aDLLHandle, 'plm_create_with_memory');
  plm_decode := GetProcAddress(aDLLHandle, 'plm_decode');
  plm_decode_audio := GetProcAddress(aDLLHandle, 'plm_decode_audio');
  plm_decode_video := GetProcAddress(aDLLHandle, 'plm_decode_video');
  plm_demux_create := GetProcAddress(aDLLHandle, 'plm_demux_create');
  plm_demux_decode := GetProcAddress(aDLLHandle, 'plm_demux_decode');
  plm_demux_destroy := GetProcAddress(aDLLHandle, 'plm_demux_destroy');
  plm_demux_get_duration := GetProcAddress(aDLLHandle, 'plm_demux_get_duration');
  plm_demux_get_num_audio_streams := GetProcAddress(aDLLHandle, 'plm_demux_get_num_audio_streams');
  plm_demux_get_num_video_streams := GetProcAddress(aDLLHandle, 'plm_demux_get_num_video_streams');
  plm_demux_get_start_time := GetProcAddress(aDLLHandle, 'plm_demux_get_start_time');
  plm_demux_has_ended := GetProcAddress(aDLLHandle, 'plm_demux_has_ended');
  plm_demux_has_headers := GetProcAddress(aDLLHandle, 'plm_demux_has_headers');
  plm_demux_probe := GetProcAddress(aDLLHandle, 'plm_demux_probe');
  plm_demux_rewind := GetProcAddress(aDLLHandle, 'plm_demux_rewind');
  plm_demux_seek := GetProcAddress(aDLLHandle, 'plm_demux_seek');
  plm_destroy := GetProcAddress(aDLLHandle, 'plm_destroy');
  plm_frame_to_abgr := GetProcAddress(aDLLHandle, 'plm_frame_to_abgr');
  plm_frame_to_argb := GetProcAddress(aDLLHandle, 'plm_frame_to_argb');
  plm_frame_to_bgr := GetProcAddress(aDLLHandle, 'plm_frame_to_bgr');
  plm_frame_to_bgra := GetProcAddress(aDLLHandle, 'plm_frame_to_bgra');
  plm_frame_to_rgb := GetProcAddress(aDLLHandle, 'plm_frame_to_rgb');
  plm_frame_to_rgba := GetProcAddress(aDLLHandle, 'plm_frame_to_rgba');
  plm_get_audio_enabled := GetProcAddress(aDLLHandle, 'plm_get_audio_enabled');
  plm_get_audio_lead_time := GetProcAddress(aDLLHandle, 'plm_get_audio_lead_time');
  plm_get_duration := GetProcAddress(aDLLHandle, 'plm_get_duration');
  plm_get_framerate := GetProcAddress(aDLLHandle, 'plm_get_framerate');
  plm_get_height := GetProcAddress(aDLLHandle, 'plm_get_height');
  plm_get_loop := GetProcAddress(aDLLHandle, 'plm_get_loop');
  plm_get_num_audio_streams := GetProcAddress(aDLLHandle, 'plm_get_num_audio_streams');
  plm_get_num_video_streams := GetProcAddress(aDLLHandle, 'plm_get_num_video_streams');
  plm_get_pixel_aspect_ratio := GetProcAddress(aDLLHandle, 'plm_get_pixel_aspect_ratio');
  plm_get_samplerate := GetProcAddress(aDLLHandle, 'plm_get_samplerate');
  plm_get_time := GetProcAddress(aDLLHandle, 'plm_get_time');
  plm_get_video_enabled := GetProcAddress(aDLLHandle, 'plm_get_video_enabled');
  plm_get_width := GetProcAddress(aDLLHandle, 'plm_get_width');
  plm_has_ended := GetProcAddress(aDLLHandle, 'plm_has_ended');
  plm_has_headers := GetProcAddress(aDLLHandle, 'plm_has_headers');
  plm_probe := GetProcAddress(aDLLHandle, 'plm_probe');
  plm_rewind := GetProcAddress(aDLLHandle, 'plm_rewind');
  plm_seek := GetProcAddress(aDLLHandle, 'plm_seek');
  plm_seek_frame := GetProcAddress(aDLLHandle, 'plm_seek_frame');
  plm_set_audio_decode_callback := GetProcAddress(aDLLHandle, 'plm_set_audio_decode_callback');
  plm_set_audio_enabled := GetProcAddress(aDLLHandle, 'plm_set_audio_enabled');
  plm_set_audio_lead_time := GetProcAddress(aDLLHandle, 'plm_set_audio_lead_time');
  plm_set_audio_stream := GetProcAddress(aDLLHandle, 'plm_set_audio_stream');
  plm_set_loop := GetProcAddress(aDLLHandle, 'plm_set_loop');
  plm_set_video_decode_callback := GetProcAddress(aDLLHandle, 'plm_set_video_decode_callback');
  plm_set_video_enabled := GetProcAddress(aDLLHandle, 'plm_set_video_enabled');
  plm_video_create_with_buffer := GetProcAddress(aDLLHandle, 'plm_video_create_with_buffer');
  plm_video_decode := GetProcAddress(aDLLHandle, 'plm_video_decode');
  plm_video_destroy := GetProcAddress(aDLLHandle, 'plm_video_destroy');
  plm_video_get_framerate := GetProcAddress(aDLLHandle, 'plm_video_get_framerate');
  plm_video_get_height := GetProcAddress(aDLLHandle, 'plm_video_get_height');
  plm_video_get_pixel_aspect_ratio := GetProcAddress(aDLLHandle, 'plm_video_get_pixel_aspect_ratio');
  plm_video_get_time := GetProcAddress(aDLLHandle, 'plm_video_get_time');
  plm_video_get_width := GetProcAddress(aDLLHandle, 'plm_video_get_width');
  plm_video_has_ended := GetProcAddress(aDLLHandle, 'plm_video_has_ended');
  plm_video_has_header := GetProcAddress(aDLLHandle, 'plm_video_has_header');
  plm_video_rewind := GetProcAddress(aDLLHandle, 'plm_video_rewind');
  plm_video_set_no_delay := GetProcAddress(aDLLHandle, 'plm_video_set_no_delay');
  plm_video_set_time := GetProcAddress(aDLLHandle, 'plm_video_set_time');
  sqlite3_aggregate_context := GetProcAddress(aDLLHandle, 'sqlite3_aggregate_context');
  sqlite3_aggregate_count := GetProcAddress(aDLLHandle, 'sqlite3_aggregate_count');
  sqlite3_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_auto_extension');
  sqlite3_autovacuum_pages := GetProcAddress(aDLLHandle, 'sqlite3_autovacuum_pages');
  sqlite3_backup_finish := GetProcAddress(aDLLHandle, 'sqlite3_backup_finish');
  sqlite3_backup_init := GetProcAddress(aDLLHandle, 'sqlite3_backup_init');
  sqlite3_backup_pagecount := GetProcAddress(aDLLHandle, 'sqlite3_backup_pagecount');
  sqlite3_backup_remaining := GetProcAddress(aDLLHandle, 'sqlite3_backup_remaining');
  sqlite3_backup_step := GetProcAddress(aDLLHandle, 'sqlite3_backup_step');
  sqlite3_bind_blob := GetProcAddress(aDLLHandle, 'sqlite3_bind_blob');
  sqlite3_bind_blob64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_blob64');
  sqlite3_bind_double := GetProcAddress(aDLLHandle, 'sqlite3_bind_double');
  sqlite3_bind_int := GetProcAddress(aDLLHandle, 'sqlite3_bind_int');
  sqlite3_bind_int64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_int64');
  sqlite3_bind_null := GetProcAddress(aDLLHandle, 'sqlite3_bind_null');
  sqlite3_bind_parameter_count := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_count');
  sqlite3_bind_parameter_index := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_index');
  sqlite3_bind_parameter_name := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_name');
  sqlite3_bind_pointer := GetProcAddress(aDLLHandle, 'sqlite3_bind_pointer');
  sqlite3_bind_text := GetProcAddress(aDLLHandle, 'sqlite3_bind_text');
  sqlite3_bind_text16 := GetProcAddress(aDLLHandle, 'sqlite3_bind_text16');
  sqlite3_bind_text64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_text64');
  sqlite3_bind_value := GetProcAddress(aDLLHandle, 'sqlite3_bind_value');
  sqlite3_bind_zeroblob := GetProcAddress(aDLLHandle, 'sqlite3_bind_zeroblob');
  sqlite3_bind_zeroblob64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_zeroblob64');
  sqlite3_blob_bytes := GetProcAddress(aDLLHandle, 'sqlite3_blob_bytes');
  sqlite3_blob_close := GetProcAddress(aDLLHandle, 'sqlite3_blob_close');
  sqlite3_blob_open := GetProcAddress(aDLLHandle, 'sqlite3_blob_open');
  sqlite3_blob_read := GetProcAddress(aDLLHandle, 'sqlite3_blob_read');
  sqlite3_blob_reopen := GetProcAddress(aDLLHandle, 'sqlite3_blob_reopen');
  sqlite3_blob_write := GetProcAddress(aDLLHandle, 'sqlite3_blob_write');
  sqlite3_busy_handler := GetProcAddress(aDLLHandle, 'sqlite3_busy_handler');
  sqlite3_busy_timeout := GetProcAddress(aDLLHandle, 'sqlite3_busy_timeout');
  sqlite3_cancel_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_cancel_auto_extension');
  sqlite3_changes := GetProcAddress(aDLLHandle, 'sqlite3_changes');
  sqlite3_changes64 := GetProcAddress(aDLLHandle, 'sqlite3_changes64');
  sqlite3_clear_bindings := GetProcAddress(aDLLHandle, 'sqlite3_clear_bindings');
  sqlite3_close := GetProcAddress(aDLLHandle, 'sqlite3_close');
  sqlite3_close_v2 := GetProcAddress(aDLLHandle, 'sqlite3_close_v2');
  sqlite3_collation_needed := GetProcAddress(aDLLHandle, 'sqlite3_collation_needed');
  sqlite3_collation_needed16 := GetProcAddress(aDLLHandle, 'sqlite3_collation_needed16');
  sqlite3_column_blob := GetProcAddress(aDLLHandle, 'sqlite3_column_blob');
  sqlite3_column_bytes := GetProcAddress(aDLLHandle, 'sqlite3_column_bytes');
  sqlite3_column_bytes16 := GetProcAddress(aDLLHandle, 'sqlite3_column_bytes16');
  sqlite3_column_count := GetProcAddress(aDLLHandle, 'sqlite3_column_count');
  sqlite3_column_database_name := GetProcAddress(aDLLHandle, 'sqlite3_column_database_name');
  sqlite3_column_database_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_database_name16');
  sqlite3_column_decltype := GetProcAddress(aDLLHandle, 'sqlite3_column_decltype');
  sqlite3_column_decltype16 := GetProcAddress(aDLLHandle, 'sqlite3_column_decltype16');
  sqlite3_column_double := GetProcAddress(aDLLHandle, 'sqlite3_column_double');
  sqlite3_column_int := GetProcAddress(aDLLHandle, 'sqlite3_column_int');
  sqlite3_column_int64 := GetProcAddress(aDLLHandle, 'sqlite3_column_int64');
  sqlite3_column_name := GetProcAddress(aDLLHandle, 'sqlite3_column_name');
  sqlite3_column_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_name16');
  sqlite3_column_origin_name := GetProcAddress(aDLLHandle, 'sqlite3_column_origin_name');
  sqlite3_column_origin_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_origin_name16');
  sqlite3_column_table_name := GetProcAddress(aDLLHandle, 'sqlite3_column_table_name');
  sqlite3_column_table_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_table_name16');
  sqlite3_column_text := GetProcAddress(aDLLHandle, 'sqlite3_column_text');
  sqlite3_column_text16 := GetProcAddress(aDLLHandle, 'sqlite3_column_text16');
  sqlite3_column_type := GetProcAddress(aDLLHandle, 'sqlite3_column_type');
  sqlite3_column_value := GetProcAddress(aDLLHandle, 'sqlite3_column_value');
  sqlite3_commit_hook := GetProcAddress(aDLLHandle, 'sqlite3_commit_hook');
  sqlite3_compileoption_get := GetProcAddress(aDLLHandle, 'sqlite3_compileoption_get');
  sqlite3_compileoption_used := GetProcAddress(aDLLHandle, 'sqlite3_compileoption_used');
  sqlite3_complete := GetProcAddress(aDLLHandle, 'sqlite3_complete');
  sqlite3_complete16 := GetProcAddress(aDLLHandle, 'sqlite3_complete16');
  sqlite3_config := GetProcAddress(aDLLHandle, 'sqlite3_config');
  sqlite3_context_db_handle := GetProcAddress(aDLLHandle, 'sqlite3_context_db_handle');
  sqlite3_create_collation := GetProcAddress(aDLLHandle, 'sqlite3_create_collation');
  sqlite3_create_collation_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_collation_v2');
  sqlite3_create_collation16 := GetProcAddress(aDLLHandle, 'sqlite3_create_collation16');
  sqlite3_create_filename := GetProcAddress(aDLLHandle, 'sqlite3_create_filename');
  sqlite3_create_function := GetProcAddress(aDLLHandle, 'sqlite3_create_function');
  sqlite3_create_function_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_function_v2');
  sqlite3_create_function16 := GetProcAddress(aDLLHandle, 'sqlite3_create_function16');
  sqlite3_create_module := GetProcAddress(aDLLHandle, 'sqlite3_create_module');
  sqlite3_create_module_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_module_v2');
  sqlite3_create_window_function := GetProcAddress(aDLLHandle, 'sqlite3_create_window_function');
  sqlite3_data_count := GetProcAddress(aDLLHandle, 'sqlite3_data_count');
  sqlite3_database_file_object := GetProcAddress(aDLLHandle, 'sqlite3_database_file_object');
  sqlite3_db_cacheflush := GetProcAddress(aDLLHandle, 'sqlite3_db_cacheflush');
  sqlite3_db_config := GetProcAddress(aDLLHandle, 'sqlite3_db_config');
  sqlite3_db_filename := GetProcAddress(aDLLHandle, 'sqlite3_db_filename');
  sqlite3_db_handle := GetProcAddress(aDLLHandle, 'sqlite3_db_handle');
  sqlite3_db_mutex := GetProcAddress(aDLLHandle, 'sqlite3_db_mutex');
  sqlite3_db_name := GetProcAddress(aDLLHandle, 'sqlite3_db_name');
  sqlite3_db_readonly := GetProcAddress(aDLLHandle, 'sqlite3_db_readonly');
  sqlite3_db_release_memory := GetProcAddress(aDLLHandle, 'sqlite3_db_release_memory');
  sqlite3_db_status := GetProcAddress(aDLLHandle, 'sqlite3_db_status');
  sqlite3_declare_vtab := GetProcAddress(aDLLHandle, 'sqlite3_declare_vtab');
  sqlite3_deserialize := GetProcAddress(aDLLHandle, 'sqlite3_deserialize');
  sqlite3_drop_modules := GetProcAddress(aDLLHandle, 'sqlite3_drop_modules');
  sqlite3_enable_shared_cache := GetProcAddress(aDLLHandle, 'sqlite3_enable_shared_cache');
  sqlite3_errcode := GetProcAddress(aDLLHandle, 'sqlite3_errcode');
  sqlite3_errmsg := GetProcAddress(aDLLHandle, 'sqlite3_errmsg');
  sqlite3_errmsg16 := GetProcAddress(aDLLHandle, 'sqlite3_errmsg16');
  sqlite3_error_offset := GetProcAddress(aDLLHandle, 'sqlite3_error_offset');
  sqlite3_errstr := GetProcAddress(aDLLHandle, 'sqlite3_errstr');
  sqlite3_exec := GetProcAddress(aDLLHandle, 'sqlite3_exec');
  sqlite3_expanded_sql := GetProcAddress(aDLLHandle, 'sqlite3_expanded_sql');
  sqlite3_expired := GetProcAddress(aDLLHandle, 'sqlite3_expired');
  sqlite3_extended_errcode := GetProcAddress(aDLLHandle, 'sqlite3_extended_errcode');
  sqlite3_extended_result_codes := GetProcAddress(aDLLHandle, 'sqlite3_extended_result_codes');
  sqlite3_file_control := GetProcAddress(aDLLHandle, 'sqlite3_file_control');
  sqlite3_filename_database := GetProcAddress(aDLLHandle, 'sqlite3_filename_database');
  sqlite3_filename_journal := GetProcAddress(aDLLHandle, 'sqlite3_filename_journal');
  sqlite3_filename_wal := GetProcAddress(aDLLHandle, 'sqlite3_filename_wal');
  sqlite3_finalize := GetProcAddress(aDLLHandle, 'sqlite3_finalize');
  sqlite3_free := GetProcAddress(aDLLHandle, 'sqlite3_free');
  sqlite3_free_filename := GetProcAddress(aDLLHandle, 'sqlite3_free_filename');
  sqlite3_free_table := GetProcAddress(aDLLHandle, 'sqlite3_free_table');
  sqlite3_get_autocommit := GetProcAddress(aDLLHandle, 'sqlite3_get_autocommit');
  sqlite3_get_auxdata := GetProcAddress(aDLLHandle, 'sqlite3_get_auxdata');
  sqlite3_get_clientdata := GetProcAddress(aDLLHandle, 'sqlite3_get_clientdata');
  sqlite3_get_table := GetProcAddress(aDLLHandle, 'sqlite3_get_table');
  sqlite3_global_recover := GetProcAddress(aDLLHandle, 'sqlite3_global_recover');
  sqlite3_hard_heap_limit64 := GetProcAddress(aDLLHandle, 'sqlite3_hard_heap_limit64');
  sqlite3_initialize := GetProcAddress(aDLLHandle, 'sqlite3_initialize');
  sqlite3_interrupt := GetProcAddress(aDLLHandle, 'sqlite3_interrupt');
  sqlite3_is_interrupted := GetProcAddress(aDLLHandle, 'sqlite3_is_interrupted');
  sqlite3_keyword_check := GetProcAddress(aDLLHandle, 'sqlite3_keyword_check');
  sqlite3_keyword_count := GetProcAddress(aDLLHandle, 'sqlite3_keyword_count');
  sqlite3_keyword_name := GetProcAddress(aDLLHandle, 'sqlite3_keyword_name');
  sqlite3_last_insert_rowid := GetProcAddress(aDLLHandle, 'sqlite3_last_insert_rowid');
  sqlite3_libversion := GetProcAddress(aDLLHandle, 'sqlite3_libversion');
  sqlite3_libversion_number := GetProcAddress(aDLLHandle, 'sqlite3_libversion_number');
  sqlite3_limit := GetProcAddress(aDLLHandle, 'sqlite3_limit');
  sqlite3_log := GetProcAddress(aDLLHandle, 'sqlite3_log');
  sqlite3_malloc := GetProcAddress(aDLLHandle, 'sqlite3_malloc');
  sqlite3_malloc64 := GetProcAddress(aDLLHandle, 'sqlite3_malloc64');
  sqlite3_memory_alarm := GetProcAddress(aDLLHandle, 'sqlite3_memory_alarm');
  sqlite3_memory_highwater := GetProcAddress(aDLLHandle, 'sqlite3_memory_highwater');
  sqlite3_memory_used := GetProcAddress(aDLLHandle, 'sqlite3_memory_used');
  sqlite3_mprintf := GetProcAddress(aDLLHandle, 'sqlite3_mprintf');
  sqlite3_msize := GetProcAddress(aDLLHandle, 'sqlite3_msize');
  sqlite3_mutex_alloc := GetProcAddress(aDLLHandle, 'sqlite3_mutex_alloc');
  sqlite3_mutex_enter := GetProcAddress(aDLLHandle, 'sqlite3_mutex_enter');
  sqlite3_mutex_free := GetProcAddress(aDLLHandle, 'sqlite3_mutex_free');
  sqlite3_mutex_leave := GetProcAddress(aDLLHandle, 'sqlite3_mutex_leave');
  sqlite3_mutex_try := GetProcAddress(aDLLHandle, 'sqlite3_mutex_try');
  sqlite3_next_stmt := GetProcAddress(aDLLHandle, 'sqlite3_next_stmt');
  sqlite3_open := GetProcAddress(aDLLHandle, 'sqlite3_open');
  sqlite3_open_v2 := GetProcAddress(aDLLHandle, 'sqlite3_open_v2');
  sqlite3_open16 := GetProcAddress(aDLLHandle, 'sqlite3_open16');
  sqlite3_os_end := GetProcAddress(aDLLHandle, 'sqlite3_os_end');
  sqlite3_os_init := GetProcAddress(aDLLHandle, 'sqlite3_os_init');
  sqlite3_overload_function := GetProcAddress(aDLLHandle, 'sqlite3_overload_function');
  sqlite3_prepare := GetProcAddress(aDLLHandle, 'sqlite3_prepare');
  sqlite3_prepare_v2 := GetProcAddress(aDLLHandle, 'sqlite3_prepare_v2');
  sqlite3_prepare_v3 := GetProcAddress(aDLLHandle, 'sqlite3_prepare_v3');
  sqlite3_prepare16 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16');
  sqlite3_prepare16_v2 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16_v2');
  sqlite3_prepare16_v3 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16_v3');
  sqlite3_profile := GetProcAddress(aDLLHandle, 'sqlite3_profile');
  sqlite3_progress_handler := GetProcAddress(aDLLHandle, 'sqlite3_progress_handler');
  sqlite3_randomness := GetProcAddress(aDLLHandle, 'sqlite3_randomness');
  sqlite3_realloc := GetProcAddress(aDLLHandle, 'sqlite3_realloc');
  sqlite3_realloc64 := GetProcAddress(aDLLHandle, 'sqlite3_realloc64');
  sqlite3_release_memory := GetProcAddress(aDLLHandle, 'sqlite3_release_memory');
  sqlite3_reset := GetProcAddress(aDLLHandle, 'sqlite3_reset');
  sqlite3_reset_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_reset_auto_extension');
  sqlite3_result_blob := GetProcAddress(aDLLHandle, 'sqlite3_result_blob');
  sqlite3_result_blob64 := GetProcAddress(aDLLHandle, 'sqlite3_result_blob64');
  sqlite3_result_double := GetProcAddress(aDLLHandle, 'sqlite3_result_double');
  sqlite3_result_error := GetProcAddress(aDLLHandle, 'sqlite3_result_error');
  sqlite3_result_error_code := GetProcAddress(aDLLHandle, 'sqlite3_result_error_code');
  sqlite3_result_error_nomem := GetProcAddress(aDLLHandle, 'sqlite3_result_error_nomem');
  sqlite3_result_error_toobig := GetProcAddress(aDLLHandle, 'sqlite3_result_error_toobig');
  sqlite3_result_error16 := GetProcAddress(aDLLHandle, 'sqlite3_result_error16');
  sqlite3_result_int := GetProcAddress(aDLLHandle, 'sqlite3_result_int');
  sqlite3_result_int64 := GetProcAddress(aDLLHandle, 'sqlite3_result_int64');
  sqlite3_result_null := GetProcAddress(aDLLHandle, 'sqlite3_result_null');
  sqlite3_result_pointer := GetProcAddress(aDLLHandle, 'sqlite3_result_pointer');
  sqlite3_result_subtype := GetProcAddress(aDLLHandle, 'sqlite3_result_subtype');
  sqlite3_result_text := GetProcAddress(aDLLHandle, 'sqlite3_result_text');
  sqlite3_result_text16 := GetProcAddress(aDLLHandle, 'sqlite3_result_text16');
  sqlite3_result_text16be := GetProcAddress(aDLLHandle, 'sqlite3_result_text16be');
  sqlite3_result_text16le := GetProcAddress(aDLLHandle, 'sqlite3_result_text16le');
  sqlite3_result_text64 := GetProcAddress(aDLLHandle, 'sqlite3_result_text64');
  sqlite3_result_value := GetProcAddress(aDLLHandle, 'sqlite3_result_value');
  sqlite3_result_zeroblob := GetProcAddress(aDLLHandle, 'sqlite3_result_zeroblob');
  sqlite3_result_zeroblob64 := GetProcAddress(aDLLHandle, 'sqlite3_result_zeroblob64');
  sqlite3_rollback_hook := GetProcAddress(aDLLHandle, 'sqlite3_rollback_hook');
  sqlite3_serialize := GetProcAddress(aDLLHandle, 'sqlite3_serialize');
  sqlite3_set_authorizer := GetProcAddress(aDLLHandle, 'sqlite3_set_authorizer');
  sqlite3_set_auxdata := GetProcAddress(aDLLHandle, 'sqlite3_set_auxdata');
  sqlite3_set_clientdata := GetProcAddress(aDLLHandle, 'sqlite3_set_clientdata');
  sqlite3_set_last_insert_rowid := GetProcAddress(aDLLHandle, 'sqlite3_set_last_insert_rowid');
  sqlite3_setlk_timeout := GetProcAddress(aDLLHandle, 'sqlite3_setlk_timeout');
  sqlite3_shutdown := GetProcAddress(aDLLHandle, 'sqlite3_shutdown');
  sqlite3_sleep := GetProcAddress(aDLLHandle, 'sqlite3_sleep');
  sqlite3_snprintf := GetProcAddress(aDLLHandle, 'sqlite3_snprintf');
  sqlite3_soft_heap_limit := GetProcAddress(aDLLHandle, 'sqlite3_soft_heap_limit');
  sqlite3_soft_heap_limit64 := GetProcAddress(aDLLHandle, 'sqlite3_soft_heap_limit64');
  sqlite3_sourceid := GetProcAddress(aDLLHandle, 'sqlite3_sourceid');
  sqlite3_sql := GetProcAddress(aDLLHandle, 'sqlite3_sql');
  sqlite3_status := GetProcAddress(aDLLHandle, 'sqlite3_status');
  sqlite3_status64 := GetProcAddress(aDLLHandle, 'sqlite3_status64');
  sqlite3_step := GetProcAddress(aDLLHandle, 'sqlite3_step');
  sqlite3_stmt_busy := GetProcAddress(aDLLHandle, 'sqlite3_stmt_busy');
  sqlite3_stmt_explain := GetProcAddress(aDLLHandle, 'sqlite3_stmt_explain');
  sqlite3_stmt_isexplain := GetProcAddress(aDLLHandle, 'sqlite3_stmt_isexplain');
  sqlite3_stmt_readonly := GetProcAddress(aDLLHandle, 'sqlite3_stmt_readonly');
  sqlite3_stmt_status := GetProcAddress(aDLLHandle, 'sqlite3_stmt_status');
  sqlite3_str_append := GetProcAddress(aDLLHandle, 'sqlite3_str_append');
  sqlite3_str_appendall := GetProcAddress(aDLLHandle, 'sqlite3_str_appendall');
  sqlite3_str_appendchar := GetProcAddress(aDLLHandle, 'sqlite3_str_appendchar');
  sqlite3_str_appendf := GetProcAddress(aDLLHandle, 'sqlite3_str_appendf');
  sqlite3_str_errcode := GetProcAddress(aDLLHandle, 'sqlite3_str_errcode');
  sqlite3_str_finish := GetProcAddress(aDLLHandle, 'sqlite3_str_finish');
  sqlite3_str_length := GetProcAddress(aDLLHandle, 'sqlite3_str_length');
  sqlite3_str_new := GetProcAddress(aDLLHandle, 'sqlite3_str_new');
  sqlite3_str_reset := GetProcAddress(aDLLHandle, 'sqlite3_str_reset');
  sqlite3_str_value := GetProcAddress(aDLLHandle, 'sqlite3_str_value');
  sqlite3_str_vappendf := GetProcAddress(aDLLHandle, 'sqlite3_str_vappendf');
  sqlite3_strglob := GetProcAddress(aDLLHandle, 'sqlite3_strglob');
  sqlite3_stricmp := GetProcAddress(aDLLHandle, 'sqlite3_stricmp');
  sqlite3_strlike := GetProcAddress(aDLLHandle, 'sqlite3_strlike');
  sqlite3_strnicmp := GetProcAddress(aDLLHandle, 'sqlite3_strnicmp');
  sqlite3_system_errno := GetProcAddress(aDLLHandle, 'sqlite3_system_errno');
  sqlite3_table_column_metadata := GetProcAddress(aDLLHandle, 'sqlite3_table_column_metadata');
  sqlite3_test_control := GetProcAddress(aDLLHandle, 'sqlite3_test_control');
  sqlite3_thread_cleanup := GetProcAddress(aDLLHandle, 'sqlite3_thread_cleanup');
  sqlite3_threadsafe := GetProcAddress(aDLLHandle, 'sqlite3_threadsafe');
  sqlite3_total_changes := GetProcAddress(aDLLHandle, 'sqlite3_total_changes');
  sqlite3_total_changes64 := GetProcAddress(aDLLHandle, 'sqlite3_total_changes64');
  sqlite3_trace := GetProcAddress(aDLLHandle, 'sqlite3_trace');
  sqlite3_trace_v2 := GetProcAddress(aDLLHandle, 'sqlite3_trace_v2');
  sqlite3_transfer_bindings := GetProcAddress(aDLLHandle, 'sqlite3_transfer_bindings');
  sqlite3_txn_state := GetProcAddress(aDLLHandle, 'sqlite3_txn_state');
  sqlite3_update_hook := GetProcAddress(aDLLHandle, 'sqlite3_update_hook');
  sqlite3_uri_boolean := GetProcAddress(aDLLHandle, 'sqlite3_uri_boolean');
  sqlite3_uri_int64 := GetProcAddress(aDLLHandle, 'sqlite3_uri_int64');
  sqlite3_uri_key := GetProcAddress(aDLLHandle, 'sqlite3_uri_key');
  sqlite3_uri_parameter := GetProcAddress(aDLLHandle, 'sqlite3_uri_parameter');
  sqlite3_user_data := GetProcAddress(aDLLHandle, 'sqlite3_user_data');
  sqlite3_value_blob := GetProcAddress(aDLLHandle, 'sqlite3_value_blob');
  sqlite3_value_bytes := GetProcAddress(aDLLHandle, 'sqlite3_value_bytes');
  sqlite3_value_bytes16 := GetProcAddress(aDLLHandle, 'sqlite3_value_bytes16');
  sqlite3_value_double := GetProcAddress(aDLLHandle, 'sqlite3_value_double');
  sqlite3_value_dup := GetProcAddress(aDLLHandle, 'sqlite3_value_dup');
  sqlite3_value_encoding := GetProcAddress(aDLLHandle, 'sqlite3_value_encoding');
  sqlite3_value_free := GetProcAddress(aDLLHandle, 'sqlite3_value_free');
  sqlite3_value_frombind := GetProcAddress(aDLLHandle, 'sqlite3_value_frombind');
  sqlite3_value_int := GetProcAddress(aDLLHandle, 'sqlite3_value_int');
  sqlite3_value_int64 := GetProcAddress(aDLLHandle, 'sqlite3_value_int64');
  sqlite3_value_nochange := GetProcAddress(aDLLHandle, 'sqlite3_value_nochange');
  sqlite3_value_numeric_type := GetProcAddress(aDLLHandle, 'sqlite3_value_numeric_type');
  sqlite3_value_pointer := GetProcAddress(aDLLHandle, 'sqlite3_value_pointer');
  sqlite3_value_subtype := GetProcAddress(aDLLHandle, 'sqlite3_value_subtype');
  sqlite3_value_text := GetProcAddress(aDLLHandle, 'sqlite3_value_text');
  sqlite3_value_text16 := GetProcAddress(aDLLHandle, 'sqlite3_value_text16');
  sqlite3_value_text16be := GetProcAddress(aDLLHandle, 'sqlite3_value_text16be');
  sqlite3_value_text16le := GetProcAddress(aDLLHandle, 'sqlite3_value_text16le');
  sqlite3_value_type := GetProcAddress(aDLLHandle, 'sqlite3_value_type');
  sqlite3_vfs_find := GetProcAddress(aDLLHandle, 'sqlite3_vfs_find');
  sqlite3_vfs_register := GetProcAddress(aDLLHandle, 'sqlite3_vfs_register');
  sqlite3_vfs_unregister := GetProcAddress(aDLLHandle, 'sqlite3_vfs_unregister');
  sqlite3_vmprintf := GetProcAddress(aDLLHandle, 'sqlite3_vmprintf');
  sqlite3_vsnprintf := GetProcAddress(aDLLHandle, 'sqlite3_vsnprintf');
  sqlite3_vtab_collation := GetProcAddress(aDLLHandle, 'sqlite3_vtab_collation');
  sqlite3_vtab_config := GetProcAddress(aDLLHandle, 'sqlite3_vtab_config');
  sqlite3_vtab_distinct := GetProcAddress(aDLLHandle, 'sqlite3_vtab_distinct');
  sqlite3_vtab_in := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in');
  sqlite3_vtab_in_first := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in_first');
  sqlite3_vtab_in_next := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in_next');
  sqlite3_vtab_nochange := GetProcAddress(aDLLHandle, 'sqlite3_vtab_nochange');
  sqlite3_vtab_on_conflict := GetProcAddress(aDLLHandle, 'sqlite3_vtab_on_conflict');
  sqlite3_vtab_rhs_value := GetProcAddress(aDLLHandle, 'sqlite3_vtab_rhs_value');
  sqlite3_wal_autocheckpoint := GetProcAddress(aDLLHandle, 'sqlite3_wal_autocheckpoint');
  sqlite3_wal_checkpoint := GetProcAddress(aDLLHandle, 'sqlite3_wal_checkpoint');
  sqlite3_wal_checkpoint_v2 := GetProcAddress(aDLLHandle, 'sqlite3_wal_checkpoint_v2');
  sqlite3_wal_hook := GetProcAddress(aDLLHandle, 'sqlite3_wal_hook');
  sqlite3_win32_set_directory := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory');
  sqlite3_win32_set_directory16 := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory16');
  sqlite3_win32_set_directory8 := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory8');
  stbi_convert_iphone_png_to_rgb := GetProcAddress(aDLLHandle, 'stbi_convert_iphone_png_to_rgb');
  stbi_convert_iphone_png_to_rgb_thread := GetProcAddress(aDLLHandle, 'stbi_convert_iphone_png_to_rgb_thread');
  stbi_failure_reason := GetProcAddress(aDLLHandle, 'stbi_failure_reason');
  stbi_flip_vertically_on_write := GetProcAddress(aDLLHandle, 'stbi_flip_vertically_on_write');
  stbi_hdr_to_ldr_gamma := GetProcAddress(aDLLHandle, 'stbi_hdr_to_ldr_gamma');
  stbi_hdr_to_ldr_scale := GetProcAddress(aDLLHandle, 'stbi_hdr_to_ldr_scale');
  stbi_image_free := GetProcAddress(aDLLHandle, 'stbi_image_free');
  stbi_info := GetProcAddress(aDLLHandle, 'stbi_info');
  stbi_info_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_info_from_callbacks');
  stbi_info_from_file := GetProcAddress(aDLLHandle, 'stbi_info_from_file');
  stbi_info_from_memory := GetProcAddress(aDLLHandle, 'stbi_info_from_memory');
  stbi_is_16_bit := GetProcAddress(aDLLHandle, 'stbi_is_16_bit');
  stbi_is_16_bit_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_is_16_bit_from_callbacks');
  stbi_is_16_bit_from_file := GetProcAddress(aDLLHandle, 'stbi_is_16_bit_from_file');
  stbi_is_16_bit_from_memory := GetProcAddress(aDLLHandle, 'stbi_is_16_bit_from_memory');
  stbi_is_hdr := GetProcAddress(aDLLHandle, 'stbi_is_hdr');
  stbi_is_hdr_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_is_hdr_from_callbacks');
  stbi_is_hdr_from_file := GetProcAddress(aDLLHandle, 'stbi_is_hdr_from_file');
  stbi_is_hdr_from_memory := GetProcAddress(aDLLHandle, 'stbi_is_hdr_from_memory');
  stbi_ldr_to_hdr_gamma := GetProcAddress(aDLLHandle, 'stbi_ldr_to_hdr_gamma');
  stbi_ldr_to_hdr_scale := GetProcAddress(aDLLHandle, 'stbi_ldr_to_hdr_scale');
  stbi_load := GetProcAddress(aDLLHandle, 'stbi_load');
  stbi_load_16 := GetProcAddress(aDLLHandle, 'stbi_load_16');
  stbi_load_16_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_load_16_from_callbacks');
  stbi_load_16_from_memory := GetProcAddress(aDLLHandle, 'stbi_load_16_from_memory');
  stbi_load_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_load_from_callbacks');
  stbi_load_from_file := GetProcAddress(aDLLHandle, 'stbi_load_from_file');
  stbi_load_from_file_16 := GetProcAddress(aDLLHandle, 'stbi_load_from_file_16');
  stbi_load_from_memory := GetProcAddress(aDLLHandle, 'stbi_load_from_memory');
  stbi_load_gif_from_memory := GetProcAddress(aDLLHandle, 'stbi_load_gif_from_memory');
  stbi_loadf := GetProcAddress(aDLLHandle, 'stbi_loadf');
  stbi_loadf_from_callbacks := GetProcAddress(aDLLHandle, 'stbi_loadf_from_callbacks');
  stbi_loadf_from_file := GetProcAddress(aDLLHandle, 'stbi_loadf_from_file');
  stbi_loadf_from_memory := GetProcAddress(aDLLHandle, 'stbi_loadf_from_memory');
  stbi_set_flip_vertically_on_load := GetProcAddress(aDLLHandle, 'stbi_set_flip_vertically_on_load');
  stbi_set_flip_vertically_on_load_thread := GetProcAddress(aDLLHandle, 'stbi_set_flip_vertically_on_load_thread');
  stbi_set_unpremultiply_on_load := GetProcAddress(aDLLHandle, 'stbi_set_unpremultiply_on_load');
  stbi_set_unpremultiply_on_load_thread := GetProcAddress(aDLLHandle, 'stbi_set_unpremultiply_on_load_thread');
  stbi_write_bmp := GetProcAddress(aDLLHandle, 'stbi_write_bmp');
  stbi_write_bmp_to_func := GetProcAddress(aDLLHandle, 'stbi_write_bmp_to_func');
  stbi_write_hdr := GetProcAddress(aDLLHandle, 'stbi_write_hdr');
  stbi_write_hdr_to_func := GetProcAddress(aDLLHandle, 'stbi_write_hdr_to_func');
  stbi_write_jpg := GetProcAddress(aDLLHandle, 'stbi_write_jpg');
  stbi_write_jpg_to_func := GetProcAddress(aDLLHandle, 'stbi_write_jpg_to_func');
  stbi_write_png := GetProcAddress(aDLLHandle, 'stbi_write_png');
  stbi_write_png_to_func := GetProcAddress(aDLLHandle, 'stbi_write_png_to_func');
  stbi_write_tga := GetProcAddress(aDLLHandle, 'stbi_write_tga');
  stbi_write_tga_to_func := GetProcAddress(aDLLHandle, 'stbi_write_tga_to_func');
  stbi_zlib_decode_buffer := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_buffer');
  stbi_zlib_decode_malloc := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_malloc');
  stbi_zlib_decode_malloc_guesssize := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_malloc_guesssize');
  stbi_zlib_decode_malloc_guesssize_headerflag := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_malloc_guesssize_headerflag');
  stbi_zlib_decode_noheader_buffer := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_noheader_buffer');
  stbi_zlib_decode_noheader_malloc := GetProcAddress(aDLLHandle, 'stbi_zlib_decode_noheader_malloc');
  stbrp_init_target := GetProcAddress(aDLLHandle, 'stbrp_init_target');
  stbrp_pack_rects := GetProcAddress(aDLLHandle, 'stbrp_pack_rects');
  stbrp_setup_allow_out_of_mem := GetProcAddress(aDLLHandle, 'stbrp_setup_allow_out_of_mem');
  stbrp_setup_heuristic := GetProcAddress(aDLLHandle, 'stbrp_setup_heuristic');
  stbtt_BakeFontBitmap := GetProcAddress(aDLLHandle, 'stbtt_BakeFontBitmap');
  stbtt_CompareUTF8toUTF16_bigendian := GetProcAddress(aDLLHandle, 'stbtt_CompareUTF8toUTF16_bigendian');
  stbtt_FindGlyphIndex := GetProcAddress(aDLLHandle, 'stbtt_FindGlyphIndex');
  stbtt_FindMatchingFont := GetProcAddress(aDLLHandle, 'stbtt_FindMatchingFont');
  stbtt_FindSVGDoc := GetProcAddress(aDLLHandle, 'stbtt_FindSVGDoc');
  stbtt_FreeBitmap := GetProcAddress(aDLLHandle, 'stbtt_FreeBitmap');
  stbtt_FreeSDF := GetProcAddress(aDLLHandle, 'stbtt_FreeSDF');
  stbtt_FreeShape := GetProcAddress(aDLLHandle, 'stbtt_FreeShape');
  stbtt_GetBakedQuad := GetProcAddress(aDLLHandle, 'stbtt_GetBakedQuad');
  stbtt_GetCodepointBitmap := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointBitmap');
  stbtt_GetCodepointBitmapBox := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointBitmapBox');
  stbtt_GetCodepointBitmapBoxSubpixel := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointBitmapBoxSubpixel');
  stbtt_GetCodepointBitmapSubpixel := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointBitmapSubpixel');
  stbtt_GetCodepointBox := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointBox');
  stbtt_GetCodepointHMetrics := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointHMetrics');
  stbtt_GetCodepointKernAdvance := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointKernAdvance');
  stbtt_GetCodepointSDF := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointSDF');
  stbtt_GetCodepointShape := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointShape');
  stbtt_GetCodepointSVG := GetProcAddress(aDLLHandle, 'stbtt_GetCodepointSVG');
  stbtt_GetFontBoundingBox := GetProcAddress(aDLLHandle, 'stbtt_GetFontBoundingBox');
  stbtt_GetFontNameString := GetProcAddress(aDLLHandle, 'stbtt_GetFontNameString');
  stbtt_GetFontOffsetForIndex := GetProcAddress(aDLLHandle, 'stbtt_GetFontOffsetForIndex');
  stbtt_GetFontVMetrics := GetProcAddress(aDLLHandle, 'stbtt_GetFontVMetrics');
  stbtt_GetFontVMetricsOS2 := GetProcAddress(aDLLHandle, 'stbtt_GetFontVMetricsOS2');
  stbtt_GetGlyphBitmap := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphBitmap');
  stbtt_GetGlyphBitmapBox := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphBitmapBox');
  stbtt_GetGlyphBitmapBoxSubpixel := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphBitmapBoxSubpixel');
  stbtt_GetGlyphBitmapSubpixel := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphBitmapSubpixel');
  stbtt_GetGlyphBox := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphBox');
  stbtt_GetGlyphHMetrics := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphHMetrics');
  stbtt_GetGlyphKernAdvance := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphKernAdvance');
  stbtt_GetGlyphSDF := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphSDF');
  stbtt_GetGlyphShape := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphShape');
  stbtt_GetGlyphSVG := GetProcAddress(aDLLHandle, 'stbtt_GetGlyphSVG');
  stbtt_GetKerningTable := GetProcAddress(aDLLHandle, 'stbtt_GetKerningTable');
  stbtt_GetKerningTableLength := GetProcAddress(aDLLHandle, 'stbtt_GetKerningTableLength');
  stbtt_GetNumberOfFonts := GetProcAddress(aDLLHandle, 'stbtt_GetNumberOfFonts');
  stbtt_GetPackedQuad := GetProcAddress(aDLLHandle, 'stbtt_GetPackedQuad');
  stbtt_GetScaledFontVMetrics := GetProcAddress(aDLLHandle, 'stbtt_GetScaledFontVMetrics');
  stbtt_InitFont := GetProcAddress(aDLLHandle, 'stbtt_InitFont');
  stbtt_IsGlyphEmpty := GetProcAddress(aDLLHandle, 'stbtt_IsGlyphEmpty');
  stbtt_MakeCodepointBitmap := GetProcAddress(aDLLHandle, 'stbtt_MakeCodepointBitmap');
  stbtt_MakeCodepointBitmapSubpixel := GetProcAddress(aDLLHandle, 'stbtt_MakeCodepointBitmapSubpixel');
  stbtt_MakeCodepointBitmapSubpixelPrefilter := GetProcAddress(aDLLHandle, 'stbtt_MakeCodepointBitmapSubpixelPrefilter');
  stbtt_MakeGlyphBitmap := GetProcAddress(aDLLHandle, 'stbtt_MakeGlyphBitmap');
  stbtt_MakeGlyphBitmapSubpixel := GetProcAddress(aDLLHandle, 'stbtt_MakeGlyphBitmapSubpixel');
  stbtt_MakeGlyphBitmapSubpixelPrefilter := GetProcAddress(aDLLHandle, 'stbtt_MakeGlyphBitmapSubpixelPrefilter');
  stbtt_PackBegin := GetProcAddress(aDLLHandle, 'stbtt_PackBegin');
  stbtt_PackEnd := GetProcAddress(aDLLHandle, 'stbtt_PackEnd');
  stbtt_PackFontRange := GetProcAddress(aDLLHandle, 'stbtt_PackFontRange');
  stbtt_PackFontRanges := GetProcAddress(aDLLHandle, 'stbtt_PackFontRanges');
  stbtt_PackFontRangesGatherRects := GetProcAddress(aDLLHandle, 'stbtt_PackFontRangesGatherRects');
  stbtt_PackFontRangesPackRects := GetProcAddress(aDLLHandle, 'stbtt_PackFontRangesPackRects');
  stbtt_PackFontRangesRenderIntoRects := GetProcAddress(aDLLHandle, 'stbtt_PackFontRangesRenderIntoRects');
  stbtt_PackSetOversampling := GetProcAddress(aDLLHandle, 'stbtt_PackSetOversampling');
  stbtt_PackSetSkipMissingCodepoints := GetProcAddress(aDLLHandle, 'stbtt_PackSetSkipMissingCodepoints');
  stbtt_Rasterize := GetProcAddress(aDLLHandle, 'stbtt_Rasterize');
  stbtt_ScaleForMappingEmToPixels := GetProcAddress(aDLLHandle, 'stbtt_ScaleForMappingEmToPixels');
  stbtt_ScaleForPixelHeight := GetProcAddress(aDLLHandle, 'stbtt_ScaleForPixelHeight');
  unzClose := GetProcAddress(aDLLHandle, 'unzClose');
  unzCloseCurrentFile := GetProcAddress(aDLLHandle, 'unzCloseCurrentFile');
  unzGetCurrentFileInfo64 := GetProcAddress(aDLLHandle, 'unzGetCurrentFileInfo64');
  unzLocateFile := GetProcAddress(aDLLHandle, 'unzLocateFile');
  unzOpen64 := GetProcAddress(aDLLHandle, 'unzOpen64');
  unzOpenCurrentFilePassword := GetProcAddress(aDLLHandle, 'unzOpenCurrentFilePassword');
  unzReadCurrentFile := GetProcAddress(aDLLHandle, 'unzReadCurrentFile');
  unztell64 := GetProcAddress(aDLLHandle, 'unztell64');
  x_net_accept := GetProcAddress(aDLLHandle, 'x_net_accept');
  x_net_address_any := GetProcAddress(aDLLHandle, 'x_net_address_any');
  x_net_address_clear := GetProcAddress(aDLLHandle, 'x_net_address_clear');
  x_net_address_equal := GetProcAddress(aDLLHandle, 'x_net_address_equal');
  x_net_address_from_ip_port := GetProcAddress(aDLLHandle, 'x_net_address_from_ip_port');
  x_net_address_to_string := GetProcAddress(aDLLHandle, 'x_net_address_to_string');
  x_net_bind := GetProcAddress(aDLLHandle, 'x_net_bind');
  x_net_bind_any := GetProcAddress(aDLLHandle, 'x_net_bind_any');
  x_net_bind_any_udp := GetProcAddress(aDLLHandle, 'x_net_bind_any_udp');
  x_net_bind_any_udp6 := GetProcAddress(aDLLHandle, 'x_net_bind_any_udp6');
  x_net_close := GetProcAddress(aDLLHandle, 'x_net_close');
  x_net_connect := GetProcAddress(aDLLHandle, 'x_net_connect');
  x_net_dns_resolve := GetProcAddress(aDLLHandle, 'x_net_dns_resolve');
  x_net_enable_broadcast := GetProcAddress(aDLLHandle, 'x_net_enable_broadcast');
  x_net_format_address := GetProcAddress(aDLLHandle, 'x_net_format_address');
  x_net_get_adapter_count := GetProcAddress(aDLLHandle, 'x_net_get_adapter_count');
  x_net_get_adapter_info := GetProcAddress(aDLLHandle, 'x_net_get_adapter_info');
  x_net_get_last_error := GetProcAddress(aDLLHandle, 'x_net_get_last_error');
  x_net_get_last_error_message := GetProcAddress(aDLLHandle, 'x_net_get_last_error_message');
  x_net_init := GetProcAddress(aDLLHandle, 'x_net_init');
  x_net_join_multicast_ipv4 := GetProcAddress(aDLLHandle, 'x_net_join_multicast_ipv4');
  x_net_join_multicast_ipv4_addr := GetProcAddress(aDLLHandle, 'x_net_join_multicast_ipv4_addr');
  x_net_join_multicast_ipv6 := GetProcAddress(aDLLHandle, 'x_net_join_multicast_ipv6');
  x_net_leave_multicast_ipv4 := GetProcAddress(aDLLHandle, 'x_net_leave_multicast_ipv4');
  x_net_leave_multicast_ipv4_addr := GetProcAddress(aDLLHandle, 'x_net_leave_multicast_ipv4_addr');
  x_net_leave_multicast_ipv6 := GetProcAddress(aDLLHandle, 'x_net_leave_multicast_ipv6');
  x_net_list_adapters := GetProcAddress(aDLLHandle, 'x_net_list_adapters');
  x_net_listen := GetProcAddress(aDLLHandle, 'x_net_listen');
  x_net_parse_ip := GetProcAddress(aDLLHandle, 'x_net_parse_ip');
  x_net_poll := GetProcAddress(aDLLHandle, 'x_net_poll');
  x_net_recv := GetProcAddress(aDLLHandle, 'x_net_recv');
  x_net_recvfrom := GetProcAddress(aDLLHandle, 'x_net_recvfrom');
  x_net_resolve := GetProcAddress(aDLLHandle, 'x_net_resolve');
  x_net_select := GetProcAddress(aDLLHandle, 'x_net_select');
  x_net_send := GetProcAddress(aDLLHandle, 'x_net_send');
  x_net_sendto := GetProcAddress(aDLLHandle, 'x_net_sendto');
  x_net_set_nonblocking := GetProcAddress(aDLLHandle, 'x_net_set_nonblocking');
  x_net_shutdown := GetProcAddress(aDLLHandle, 'x_net_shutdown');
  x_net_socket := GetProcAddress(aDLLHandle, 'x_net_socket');
  x_net_socket_is_valid := GetProcAddress(aDLLHandle, 'x_net_socket_is_valid');
  x_net_socket_tcp4 := GetProcAddress(aDLLHandle, 'x_net_socket_tcp4');
  x_net_socket_tcp6 := GetProcAddress(aDLLHandle, 'x_net_socket_tcp6');
  x_net_socket_udp4 := GetProcAddress(aDLLHandle, 'x_net_socket_udp4');
  x_net_socket_udp6 := GetProcAddress(aDLLHandle, 'x_net_socket_udp6');
  zipClose := GetProcAddress(aDLLHandle, 'zipClose');
  zipCloseFileInZip := GetProcAddress(aDLLHandle, 'zipCloseFileInZip');
  zipOpen64 := GetProcAddress(aDLLHandle, 'zipOpen64');
  zipOpenNewFileInZip3_64 := GetProcAddress(aDLLHandle, 'zipOpenNewFileInZip3_64');
  zipWriteInFileInZip := GetProcAddress(aDLLHandle, 'zipWriteInFileInZip');
end;

{ImFontGlyph}

function ImFontGlyph.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImFontGlyph.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImFontAtlasCustomRect}

function ImFontAtlasCustomRect.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImFontAtlasCustomRect.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiStyleVarInfo}

function ImGuiStyleVarInfo.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiStyleVarInfo.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiBoxSelectState}

function ImGuiBoxSelectState.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiBoxSelectState.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiDockNode}

function ImGuiDockNode.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiDockNode.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiStackLevelInfo}

function ImGuiStackLevelInfo.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiStackLevelInfo.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiContext}

function ImGuiContext.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiContext.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiWindow}

function ImGuiWindow.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiWindow.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiWindow}

function ImGuiWindow.GetData1Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data1 shr Offset) and Mask;
end;

procedure ImGuiWindow.SetData1Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data1 := (Data1 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiTableColumn}

function ImGuiTableColumn.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiTableColumn.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiTable}

function ImGuiTable.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiTable.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;

{ImGuiTableColumnSettings}

function ImGuiTableColumnSettings.GetData0Value(const AIndex: Integer): Cardinal;
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (Data0 shr Offset) and Mask;
end;

procedure ImGuiTableColumnSettings.SetData0Value(const AIndex: Integer; const AValue: Cardinal);
var
  BitCount, Offset, Mask: Cardinal;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Data0 := (Data0 and (not (Mask shl Offset))) or (AValue shl Offset);
end;


{ =========================================================================== }

{$R Game2D.Deps.res}

var
  DepsDLLHandle: THandle = 0;

procedure LoadDLL();
var
  LResStream: TResourceStream;

  function b2219e6774ab486da0ff9449db6f83dc(): string;
  const
    CValue = '47867e5e741948e9ade692ac2dd61124';
  begin
    Result := CValue;
  end;

  procedure AbortDLL(const AText: string; const AArgs: array of const);
  begin
    MessageBox(0, System.PWideChar(Format(AText, AArgs)), 'Critial Error', MB_ICONERROR);
    Halt(1);
  end;

begin
  // load deps DLL
  if DepsDLLHandle <> 0 then Exit;
  if not Boolean((FindResource(HInstance, PChar(b2219e6774ab486da0ff9449db6f83dc()), RT_RCDATA) <> 0)) then AbortDLL('Deps DLL was not found in resource', []);
  LResStream := TResourceStream.Create(HInstance, b2219e6774ab486da0ff9449db6f83dc(), RT_RCDATA);
  try
    LResStream.Position := 0;
    DepsDLLHandle := Dlluminator.LoadLibrary(LResStream.Memory, LResStream.Size);
    if DepsDLLHandle = 0 then AbortDLL('Was not able to load Deps DLL from memory', []);
  finally
    LResStream.Free();
  end;
  GetExports(DepsDLLHandle);
end;

procedure UnloadDLL();
begin
  // unload deps DLL
  if DepsDLLHandle <> 0 then
  begin
    FreeLibrary(DepsDLLHandle);
    DepsDLLHandle := 0;
  end;
end;

initialization
begin
  // turn on memory leak detection
  ReportMemoryLeaksOnShutdown := True;

  // load allegro DLL
  LoadDLL();
end;

finalization
begin
  // shutdown allegro DLL
  UnloadDLL();
end;

end.

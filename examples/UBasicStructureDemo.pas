{==============================================================================
  Game2D Basic Structure Demo - Entry Point for New Developers

  This unit demonstrates the fundamental architecture and lifecycle patterns
  required for any Game2D application. It serves as the canonical reference
  for setting up a complete game loop with proper resource management,
  audio/video handling, and window state management.

  Key Learning Points:
  • Proper initialization and cleanup sequences
  • Window ready state handling for pause/resume functionality
  • Main game loop structure with frame timing
  • Resource loading from encrypted ZIP archives
  • Basic input handling and HUD rendering
  • Error handling and graceful shutdown patterns

  This code follows Game2D best practices and coding conventions that should
  be used throughout your game development projects.

==============================================================================}
unit UBasicStructureDemo;

interface

{==============================================================================
  MAIN ENTRY POINT

  Call this procedure from your main program to run the demo. This represents
  the complete lifecycle of a Game2D application from startup to shutdown.
==============================================================================}
procedure BasicStructureDemo();

implementation

uses
  System.SysUtils,
  Game2D.Common,
  Game2D.Core,
  UCommon;  // Contains common constants like ZIP_FILENAME

{==============================================================================
  BASIC STRUCTURE DEMO IMPLEMENTATION

  This procedure demonstrates the complete structure of a Game2D application:
  1. Local variable declarations with proper naming conventions
  2. Nested helper functions for organization
  3. Main execution block with error handling
  4. Proper resource cleanup in finally block
==============================================================================}

procedure BasicStructureDemo();
var
  // Core Game2D objects - these are the minimum required for any application
  LWindow: Tg2dWindow;    // Main application window and OpenGL context
  LFont: Tg2dFont;        // Font rendering system for text display
  LHudPos: Tg2dVec;       // Position vector for HUD text placement

  {============================================================================
    STARTUP FUNCTION

    Initializes all Game2D systems in the correct order. This function
    demonstrates the proper initialization sequence that must be followed
    for any Game2D application.

    Returns: True if all systems initialized successfully, False otherwise

    CRITICAL: Always check return values from Game2D initialization functions.
    If any step fails, the application should terminate gracefully.
  ============================================================================}
  function Startup(): Boolean;
  begin
    Result := False;

    // Step 1: Initialize the main window
    // This creates the OpenGL context and sets up the rendering pipeline
    LWindow := Tg2dWindow.Init('Game2D: Basic Structure');
    if not Assigned(LWindow) then Exit;

    // Step 2: Set up window ready state callback
    // This callback handles when the window loses/gains focus or is minimized
    // It automatically pauses audio and video when the window is not ready
    LWindow.SetReadyCallback(
      procedure (const AReady: Boolean)
      begin
        case AReady of
          False:  // Window lost focus, minimized, or not visible
            begin
              // Pause all audio playback to avoid audio continuing in background
              Tg2dAudio.SetPause(True);
              // Pause video playback to save CPU/GPU resources
              Tg2dVideo.SetPause(True);
            end;
          True:   // Window regained focus and is ready for updates
            begin
              // Resume audio playback
              Tg2dAudio.SetPause(False);
              // Resume video playback
              Tg2dVideo.SetPause(False);
            end;
        end;
      end,
      nil  // No user data needed for this callback
    );


    // Step 3: Initialize font system
    // The font system requires a valid window context to function
    LFont := Tg2dFont.Init(LWindow);
    if not Assigned(LFont) then Exit;

    // Step 4: Initialize audio system
    // Must be called before any audio operations
    if not Tg2dAudio.Open() then Exit;

    // Step 5: Load and play background music from encrypted ZIP
    // Game2D supports loading assets from password-protected ZIP files
    // ZIP_FILENAME is defined in UCommon and contains the game's asset archive
    Tg2dAudio.PlayMusicFromZipFile(
      ZIP_FILENAME,           // ZIP file containing game assets
      'res/music/song01.ogg', // Path within the ZIP file
      1.0,                    // Volume (0.0 to 1.0)
      True                    // Loop the music
    );

    // Step 6: Load and play background video
    // Demonstrates video playback capabilities of Game2D
    Tg2dVideo.PlayFromZipFile(
      ZIP_FILENAME,           // Same ZIP file as music
      'res/videos/game2d.mpg', // Video file path within ZIP
      1.0,                    // Volume for video audio track
      True                    // Loop the video
    );

    // All systems initialized successfully
    Result := True;
  end;

  {============================================================================
    SHUTDOWN FUNCTION

    Properly releases all Game2D resources in reverse order of initialization.
    This function demonstrates the correct cleanup sequence that prevents
    memory leaks and ensures graceful application termination.

    CRITICAL: Always call cleanup functions in reverse order of initialization.
    Failing to do so can cause access violations or resource leaks.
  ============================================================================}
  procedure Shutdown();
  begin
    // Step 1: Stop video playback first (releases video resources)
    Tg2dVideo.Stop();

    // Step 2: Close audio system (stops all audio and releases audio resources)
    Tg2dAudio.Close();

    // Step 3: Release font system
    if Assigned(LFont) then
      LFont.Free();

    // Step 4: Release window last (destroys OpenGL context)
    if Assigned(LWindow) then
      LWindow.Free();
  end;

  {============================================================================
    UPDATE FUNCTION

    Handles game logic updates, input processing, and game state changes.
    This function is called once per frame when the window is ready.

    This example demonstrates:
    • Basic keyboard input handling
    • Application termination through ESC key
    • Fullscreen toggling with F11
    • Proper input state checking (isWasPressed vs isPressed)
  ============================================================================}
  procedure Update();
  begin
    // Check for ESC key press to quit application
    // isWasPressed ensures this triggers only once per key press
    if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
      LWindow.SetShouldClose(True);

    // Check for F11 key press to toggle fullscreen mode
    // This is a common game convention for fullscreen toggling
    if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
      LWindow.ToggleFullscreen();
  end;

  {============================================================================
    RENDER FUNCTION

    Handles all game world rendering. This function draws the main game content
    but does not include HUD elements (those are drawn separately).

    This example demonstrates:
    • Basic window clearing with a background color
    • Video rendering with scaling and positioning
    • Centering content on screen using window dimensions
  ============================================================================}
  procedure Render();
  var
    LPos: Tg2dVec;      // Position for video rendering
    LSize: Tg2dSize;    // Size of the video
  begin
    // Clear the screen with a dark background color
    // G2D_DARKSLATEBROWN is a predefined color constant
    LWindow.Clear(G2D_DARKSLATEBROWN);

    // Get the current video frame size
    LSize := Tg2dVideo.GetSize();

    // Calculate position to center the video on screen at 25% scale
    LPos.X := (LWindow.GetVirtualSize().Width - (LSize.Width * 0.25)) / 2;
    LPos.Y := (LWindow.GetVirtualSize().Height - (LSize.Height * 0.25)) / 2;

    // Draw the video frame at calculated position with 25% scaling
    Tg2dVideo.Draw(LPos.X, LPos.Y, 0.25);
  end;

  {============================================================================
    RENDER HUD FUNCTION

    Handles all HUD (Heads-Up Display) rendering. HUD elements are typically
    drawn last so they appear on top of all other game content.

    This example demonstrates:
    • FPS counter display
    • Control instruction display
    • Text positioning and formatting
    • Using predefined color constants
    • HUD text utility functions
  ============================================================================}
  procedure RenderHUD();
  begin
    // Set HUD text starting position (top-left corner with small margin)
    LHudPos.Assign(3, 3);

    // Display current frame rate in white
    // The Y position auto-advances after each text draw call
    LFont.DrawText(
      LWindow,                        // Window context for rendering
      LHudPos.X, LHudPos.Y,          // X, Y position
      0,                             // Z-order (0 = no depth)
      LFont.GetLogicalScale(12),     // Font size (scaled for window)
      G2D_WHITE,                     // Text color
      haLeft,                        // Horizontal alignment
      '%d fps',                      // Format string
      [LWindow.GetFrameRate()]       // Frame rate value
    );

    // Display ESC key instruction in green
    LFont.DrawText(
      LWindow, LHudPos.X, LHudPos.Y, 0,
      LFont.GetLogicalScale(12), G2D_GREEN, haLeft,
      Tg2dUtils.HudTextItem('ESC', 'Quit')  // Formats as "ESC: Quit"
    );

    // Display F11 key instruction in green
    LFont.DrawText(
      LWindow, LHudPos.X, LHudPos.Y, 0,
      LFont.GetLogicalScale(12), G2D_GREEN, haLeft,
      Tg2dUtils.HudTextItem('F11', 'Toggle fullscreen')
    );

    // Display technical info about window focus behavior in yellow
    LFont.DrawText(
      LWindow, LHudPos.X, LHudPos.Y, 0,
      LFont.GetLogicalScale(12), G2D_YELLOW, haLeft,
      'App pauses when window loses focus'
    );
  end;

{==============================================================================
  MAIN EXECUTION BLOCK

  This is the heart of any Game2D application. It demonstrates the standard
  game loop pattern used in virtually all real-time games and interactive
  applications.

  The structure follows this pattern:
  1. Initialize all systems
  2. Run the main loop until exit condition
  3. Clean up all resources (even if an exception occurs)
==============================================================================}
begin
  try
    // PHASE 1: INITIALIZATION
    // Attempt to start up all game systems
    if not Startup() then Exit;

    // PHASE 2: MAIN GAME LOOP
    // Continue running until the window should close
    while not LWindow.ShouldClose() do
    begin
      // Start frame timing and input polling
      // This must be called at the beginning of every frame
      LWindow.StartFrame();

      // Only update and render when window is ready (has focus, not minimized)
      if LWindow.IsReady() then
      begin
        // GAME LOGIC UPDATE
        // Process input, update game state, handle collisions, etc.
        Update();

        // RENDERING PHASE
        // Set up rendering context and clear buffers
        LWindow.StartDrawing();

        // Draw game world content
        Render();

        // Draw HUD elements on top of game world
        RenderHUD();

        // Present the completed frame to screen
        LWindow.EndDrawing();
      end;

      // Complete frame processing and maintain target frame rate
      // This handles VSync, frame rate limiting, and buffer swapping
      LWindow.EndFrame();
    end;

  finally
    // PHASE 3: CLEANUP
    // Always clean up resources, even if an exception occurred
    // The finally block ensures this runs regardless of how execution ends
    Shutdown();
  end;
end;

end.

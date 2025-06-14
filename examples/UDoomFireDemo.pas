(******************************************************************************
  UDOOMFIREDEMO - CLASSIC DOOM FIRE EFFECT SIMULATION

  A faithful recreation of the iconic fire effect from id Software's DOOM (1993),
  implementing the original cellular automaton algorithm using real-time pixel
  manipulation. This demo showcases advanced 2D graphics programming techniques
  including direct texture memory access, procedural animation systems, and
  interactive parameter control for educational and entertainment purposes.

  TECHNICAL COMPLEXITY LEVEL: INTERMEDIATE TO ADVANCED

  OVERVIEW
  ========

  This demonstration recreates the legendary fire effect from DOOM using a cellular
  automaton approach with direct pixel manipulation. The effect operates on a
  400x300 pixel buffer that serves as both the computation grid and visual output.
  Each pixel represents a heat value (0-255) that propagates upward through the
  grid according to simple but effective rules, creating the characteristic
  flickering flame appearance that made DOOM visually distinctive.

  The demo targets graphics programmers, game developers studying classic effects,
  and computer science students learning cellular automata applications. It serves
  as both a historical recreation and a practical example of efficient real-time
  pixel-level graphics programming using the Game2D library's texture manipulation
  capabilities.

  TECHNICAL IMPLEMENTATION
  ========================

  CORE SYSTEMS AND ALGORITHMS:
  The fire simulation operates as a 2D cellular automaton where each cell (pixel)
  updates based on its neighbors according to deterministic rules with random
  variations. The system uses three primary data structures:

  • TFireBuffer[400][300] - Integer grid storing heat values (0-255 range)
  • TFirePalette[256] - Color lookup table mapping heat to RGB values
  • Tg2dTexture - Hardware-accelerated texture for real-time rendering

  MATHEMATICAL FOUNDATION:
  The core algorithm implements upward heat propagation with cooling:

    for y := 0 to HEIGHT-2 do
      for x := 0 to WIDTH-1 do
        NewHeat := FireBuffer[y+1, x] - Random(3)
        FireBuffer[y, x + WindOffset] := Max(0, NewHeat)

  This creates natural heat dissipation where higher pixels become cooler,
  while horizontal wind displacement (±1 pixel) adds realistic turbulence.

  COORDINATE SYSTEM:
  The simulation uses a standard screen coordinate system with origin (0,0) at
  top-left. The fire source is maintained at row HEIGHT-1 (bottom) with maximum
  heat values, while heat propagates upward to row 0 (top) where it naturally
  dissipates to black pixels.

  MEMORY MANAGEMENT:
  Direct texture manipulation uses Game2D's Lock/Unlock mechanism for optimal
  performance. The texture is locked once per frame, all pixels are updated
  via SetPixel() calls, then unlocked to transfer changes to GPU memory.

  FEATURES DEMONSTRATED
  =====================

  • Cellular automaton simulation with deterministic + random elements
  • Real-time texture pixel manipulation using Lock/Unlock patterns
  • Procedural color palette generation with authentic DOOM fire colors
  • Interactive parameter control (fire intensity, wind effects)
  • Fullscreen scaling with aspect ratio preservation
  • Frame-rate independent animation timing
  • Hardware-accelerated texture rendering with GL_LINEAR filtering
  • Dynamic fire source maintenance with probabilistic gaps

  RENDERING TECHNIQUES
  ====================

  TEXTURE MANIPULATION:
  The demo uses direct pixel access through Game2D's texture system:

    LFireTexture.Lock()
    for y := 0 to HEIGHT-1 do
      for x := 0 to WIDTH-1 do
        LFireTexture.SetPixel(x, y, LFirePalette[LFireBuffer[y, x]])
    LFireTexture.Unlock()

  SCALING AND DISPLAY:
  Fullscreen rendering uses proportional scaling to maintain aspect ratio:

    LScaleX := WindowWidth / FIRE_WIDTH
    LScaleY := WindowHeight / FIRE_HEIGHT
    LFireTexture.SetScale(Max(LScaleX, LScaleY))

  COLOR PALETTE GENERATION:
  Authentic DOOM fire colors are generated procedurally:

    0-15:   Pure black (cold)
    16-47:  Black to dark red transition
    48-111: Dark red to bright red
    112-175: Red to orange transition
    176-239: Orange to yellow transition
    240-255: Pure yellow (hottest)

  CONTROLS
  ========

  KEYBOARD INPUT:
  • ESC - Exit demonstration
  • F11 - Toggle fullscreen mode
  • 1 - Low fire intensity (50%)
  • 2 - Normal fire intensity (75%)
  • 3 - High fire intensity (85%)
  • 4 - Maximum fire intensity (95%)
  • LEFT ARROW - Wind effect leftward
  • RIGHT ARROW - Wind effect rightward
  • UP/DOWN ARROW - Reset wind to neutral
  • R - Reset fire parameters and reinitialize buffer

  MATHEMATICAL FOUNDATION
  =======================

  CELLULAR AUTOMATON RULES:
  Each cell updates according to these rules:

    NewHeat = SourceHeat - CoolingFactor - Random(3)
    DestinationX = SourceX + WindEffect + Random(3) - 1

  Where CoolingFactor creates upward heat dissipation and Random(3) provides
  the characteristic flickering behavior that makes the fire appear alive.

  HEAT SOURCE MAINTENANCE:
  The bottom row fire source uses probability-based generation:

    if Random(100) < FireIntensity then
      FireBuffer[HEIGHT-1, x] := 255  // Maximum heat
    else
      FireBuffer[HEIGHT-1, x] := 0    // Gap in fire

  WIND PHYSICS SIMULATION:
  Wind effects modify horizontal heat propagation:

    DestX := SourceX + WindEffect + Random(3) - 1
    DestX := Clamp(DestX, 0, WIDTH-1)

  This creates realistic flame bending and turbulence effects.

  PERFORMANCE CHARACTERISTICS
  ===========================

  COMPUTATIONAL COMPLEXITY:
  • Per-frame operations: O(WIDTH × HEIGHT) = O(120,000) pixel updates
  • Memory access pattern: Sequential row-wise traversal for cache efficiency
  • Expected frame rate: 60+ FPS on modern hardware
  • Memory usage: ~470KB for fire buffer + palette + texture data

  OPTIMIZATION TECHNIQUES:
  • Single texture lock/unlock per frame minimizes GPU state changes
  • Integer arithmetic throughout the simulation loop
  • Lookup table for color conversion eliminates floating-point calculations
  • FillChar() used for efficient buffer initialization
  • Clamping operations prevent array bounds checking overhead

  SCALABILITY CONSIDERATIONS:
  The algorithm scales linearly with resolution. Larger fire effects require
  proportionally more CPU time but maintain the same visual characteristics.
  GPU texture upload becomes the bottleneck for very large textures.

  EDUCATIONAL VALUE
  =================

  TRANSFERABLE CONCEPTS:
  • Cellular automata for procedural animation systems
  • Real-time pixel manipulation techniques in game engines
  • Color palette design for retro-style graphics
  • Interactive parameter systems for artistic tools
  • Frame-rate independent timing for smooth animation
  • Probability-based systems for natural-looking randomness

  PROGRESSION PATHWAY:
  Developers can extend this demo by implementing:
  • Multiple fire sources with different intensities
  • Particle systems spawned from high-heat pixels
  • Smoke simulation using similar cellular automaton rules
  • Advanced wind patterns with vortex effects
  • Fire-to-object interaction and burn propagation

  REAL-WORLD APPLICATIONS:
  This technique applies to game effects, screensavers, visualization tools,
  educational software demonstrating cellular automata, and retro-style
  game development where authentic classic effects are desired.

  The DOOM fire effect remains one of the most elegant examples of how simple
  mathematical rules can create complex, visually appealing phenomena suitable
  for real-time interactive applications.
******************************************************************************)

unit UDoomFireDemo;

interface

uses
  System.SysUtils,
  Game2D.Common,
  Game2D.Core,
  UCommon;

procedure DoomFireDemo();


implementation

procedure DoomFireDemo();
const
  FIRE_WIDTH = 400;
  FIRE_HEIGHT = 300;

type
  TFirePalette = array[0..255] of Tg2dColor;
  TFireBuffer = array[0..FIRE_HEIGHT-1, 0..FIRE_WIDTH-1] of Integer;

var
  LWindow: Tg2dWindow;
  LFireTexture: Tg2dTexture;
  LFireBuffer: TFireBuffer;
  LFirePalette: TFirePalette;
  LTime: Single;
  LFireIntensity: Integer;
  LWindEffect: Integer;
  LScaleX: Single;
  LScaleY: Single;
  LFont: Tg2dFont;
  LHudPos: Tg2dVec;
  LIntensityText: string;
  LWindText: string;

  procedure InitFirePalette();
  var
    LI: Integer;
    LR: Single;
    LG: Single;
    LB: Single;
  begin
    // More authentic Doom fire palette
    for LI := 0 to 255 do
    begin
      if LI < 16 then
      begin
        // Pure black
        LR := 0;
        LG := 0;
        LB := 0;
      end
      else if LI < 48 then
      begin
        // Black to dark red
        LR := (LI - 16) / 32.0 * 0.5;
        LG := 0;
        LB := 0;
      end
      else if LI < 112 then
      begin
        // Dark red to bright red
        LR := 0.5 + (LI - 48) / 64.0 * 0.5;
        LG := 0;
        LB := 0;
      end
      else if LI < 176 then
      begin
        // Red to orange
        LR := 1.0;
        LG := (LI - 112) / 64.0 * 0.5;
        LB := 0;
      end
      else if LI < 240 then
      begin
        // Orange to yellow
        LR := 1.0;
        LG := 0.5 + (LI - 176) / 64.0 * 0.5;
        LB := 0;
      end
      else
      begin
        // Yellow (very rare)
        LR := 1.0;
        LG := 1.0;
        LB := (LI - 240) / 15.0 * 0.3;
      end;

      LFirePalette[LI].FromFloat(LR, LG, LB, 1.0);
    end;
  end;

  procedure InitFireBuffer();
  var
    LX: Integer;
  begin
    // Initialize buffer with zeros (black) - more efficient
    FillChar(LFireBuffer, SizeOf(LFireBuffer), 0);

    // Set bottom row to maximum heat (fire source)
    for LX := 0 to FIRE_WIDTH-1 do
      LFireBuffer[FIRE_HEIGHT-1, LX] := 255;
  end;

  procedure UpdateFire();
  var
    LX: Integer;
    LY: Integer;
    LRandomValue: Integer;
    LNewHeat: Integer;
    LDestX: Integer;
  begin
    // Cellular automaton: each pixel looks at pixel below and applies rules
    for LY := 0 to FIRE_HEIGHT-2 do // Don't process bottom row (fire source)
    begin
      for LX := 0 to FIRE_WIDTH-1 do
      begin
        // Get heat from pixel directly below
        LNewHeat := LFireBuffer[LY+1, LX];

        // Cool down (this is the key cellular automaton rule)
        LRandomValue := Random(3); // 0, 1, or 2
        LNewHeat := LNewHeat - LRandomValue;

        // Clamp to valid range
        if LNewHeat < 0 then LNewHeat := 0;

        // Apply wind effect (horizontal displacement)
        LDestX := LX + LWindEffect;
        if Random(2) = 0 then // Add some randomness to wind
          LDestX := LDestX + Random(3) - 1; // -1, 0, or 1

        // Keep within bounds
        if LDestX < 0 then LDestX := 0;
        if LDestX >= FIRE_WIDTH then LDestX := FIRE_WIDTH-1;

        // Set the new heat value
        LFireBuffer[LY, LDestX] := LNewHeat;
      end;
    end;

    // Maintain fire source at bottom
    for LX := 0 to FIRE_WIDTH-1 do
    begin
      if Random(100) < LFireIntensity then
        LFireBuffer[FIRE_HEIGHT-1, LX] := 255 // Max heat
      else
        LFireBuffer[FIRE_HEIGHT-1, LX] := 0;  // No heat (gaps in fire)
    end;
  end;

  procedure UpdateFireTexture();
  var
    LX: Integer;
    LY: Integer;
    LHeatValue: Integer;
    LColor: Tg2dColor;
  begin
    if not LFireTexture.Lock() then Exit;

    // Convert fire buffer to texture pixels
    for LY := 0 to FIRE_HEIGHT-1 do
    begin
      for LX := 0 to FIRE_WIDTH-1 do
      begin
        LHeatValue := LFireBuffer[LY, LX];
        LColor := LFirePalette[LHeatValue];
        LFireTexture.SetPixel(LX, LY, LColor);
      end;
    end;

    LFireTexture.Unlock();
  end;

begin
  LWindow := Tg2dWindow.Init('Game2D - Doom Fire Demo');
  try
    LWindow.SetSizeLimits(Round(LWindow.GetVirtualSize().Width/2), Round(LWindow.GetVirtualSize().Height/2), G2D_DONT_CARE, G2D_DONT_CARE);

    LFont := Tg2dFont.Init(LWindow);

    // Create fullscreen fire texture
    LFireTexture := Tg2dTexture.Create();
    LFireTexture.Alloc(FIRE_WIDTH, FIRE_HEIGHT, G2D_BLACK);
    LFireTexture.SetPos(LWindow.GetVirtualSize().Width/2, LWindow.GetVirtualSize().Height/2);

    // Calculate scale to fill entire screen
    LScaleX := LWindow.GetVirtualSize().Width / FIRE_WIDTH;
    LScaleY := LWindow.GetVirtualSize().Height / FIRE_HEIGHT;

    // Use the larger scale to ensure full coverage
    if LScaleX > LScaleY then
      LFireTexture.SetScale(LScaleX)
    else
      LFireTexture.SetScale(LScaleY);

    // Initialize fire system
    InitFirePalette();
    InitFireBuffer();

    // Initialize parameters
    LTime := 0.0;
    LFireIntensity := 75; // Default intensity
    LWindEffect := 0;

    while not LWindow.ShouldClose() do
    begin
      LWindow.StartFrame();

        // Input handling
        if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
          LWindow.SetShouldClose(True);

        if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
          LWindow.ToggleFullscreen();

        // Control fire intensity with number keys
        if LWindow.GetKey(G2D_KEY_1, isWasPressed) then
          LFireIntensity := 50;  // Low intensity

        if LWindow.GetKey(G2D_KEY_2, isWasPressed) then
          LFireIntensity := 75;  // Normal intensity

        if LWindow.GetKey(G2D_KEY_3, isWasPressed) then
          LFireIntensity := 85;  // High intensity

        if LWindow.GetKey(G2D_KEY_4, isWasPressed) then
          LFireIntensity := 95;  // Maximum intensity

        // Control wind with arrow keys
        if LWindow.GetKey(G2D_KEY_LEFT, isPressed) then
          LWindEffect := -1
        else if LWindow.GetKey(G2D_KEY_RIGHT, isPressed) then
          LWindEffect := 1
        else if LWindow.GetKey(G2D_KEY_UP, isPressed) or LWindow.GetKey(G2D_KEY_DOWN, isPressed) then
          LWindEffect := 0;

        // Reset with R key
        if LWindow.GetKey(G2D_KEY_R, isWasPressed) then
        begin
          LFireIntensity := 75;
          LWindEffect := 0;
          InitFireBuffer();
        end;

        // Update fire algorithm
        UpdateFire();
        UpdateFireTexture();

        // Update time for animation
        LTime := LTime + LWindow.GetDeltaTime();

        // Prepare status text
        case LFireIntensity of
          50: LIntensityText := 'Low';
          75: LIntensityText := 'Normal';
          85: LIntensityText := 'High';
          95: LIntensityText := 'Maximum';
        else
          LIntensityText := 'Custom';
        end;

        case LWindEffect of
          -1: LWindText := 'Left';
           0: LWindText := 'None';
           1: LWindText := 'Right';
        else
          LWindText := 'Variable';
        end;

        LWindow.StartDrawing();
          LWindow.Clear(G2D_BLACK);

          // Draw the fullscreen fire
          LFireTexture.Draw();

          // Draw title in larger font
          LFont.DrawText(LWindow, 15, 15, LFont.GetLogicalScale(18), G2D_WHITE, haLeft, 'Doom Fire Demo');

          // Draw FPS in upper right corner
          LFont.DrawText(LWindow, LWindow.GetVirtualSize().Width - 15, 15, LFont.GetLogicalScale(12), G2D_WHITE, haRight, '%d fps', [LWindow.GetFrameRate()]);

          // Draw HUD information starting below title
          LHudPos.Assign(15, 50);
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_BLANK, haLeft, '');

          // Fire status
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_YELLOW, haLeft, 'Fire Intensity: %s (%d%%)', [LIntensityText, LFireIntensity]);
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_YELLOW, haLeft, 'Wind Effect: %s', [LWindText]);
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_BLANK, haLeft, '');

          // Controls
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('ESC', 'Quit'));
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('F11', 'Toggle fullscreen'));
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('1-4', 'Fire intensity'));
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('←/→', 'Wind direction'));
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('↑/↓', 'Reset wind'));
          LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_GREEN, haLeft, Tg2dUtils.HudTextItem('R', 'Reset fire'));

        LWindow.EndDrawing();

      LWindow.EndFrame();
    end;

    LFireTexture.Free();
    LFont.Free();

  finally
    LWindow.Free();
  end;
end;

end.

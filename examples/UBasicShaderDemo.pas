(******************************************************************************
  Game2D Basic Shader Demo - Advanced Fragment Shader Programming Demonstration

  This demonstration showcases comprehensive custom fragment shader implementation
  within the Game2D graphics library, featuring real-time uniform parameter
  manipulation, texture distortion effects, and interactive color transformation.
  The demo serves as an educational platform for understanding OpenGL shader
  programming concepts, uniform variable binding, and real-time graphics pipeline
  control within a Delphi/Object Pascal environment.

  Technical Complexity Level: Advanced

  OVERVIEW:
  This advanced shader demonstration illustrates the fundamental concepts of
  programmable graphics pipeline control using OpenGL Shading Language (GLSL)
  version 1.20. The demo creates a custom fragment shader that applies real-time
  wave distortion effects and color tinting to a procedurally generated
  checkerboard texture. Users can interactively modify shader parameters through
  keyboard input, providing immediate visual feedback on how uniform variables
  affect the final rendered output.

  TECHNICAL IMPLEMENTATION:
  Core Systems: OpenGL fragment shader compilation and linking pipeline, real-time
  uniform variable transmission, sinusoidal wave distortion algorithm using
  sin(uv.y * 10.0 + time * 2.0), RGB color channel multiplication for tinting
  effects, and checkerboard pattern generation using modulo arithmetic.

  Data Structures: Tg2dShader for OpenGL shader program management, Tg2dTexture
  for 256x256 RGBA texture buffer with procedural pattern, Tg2dVec for three-
  component RGB color representation, and Tg2dWindow for graphics context.

  Mathematical Foundation: Wave distortion formula uv.x += sin(uv.y * 10.0 +
  time * 2.0) * waveStrength, color tinting operation texColor.rgb *= tintColor,
  texture coordinate space in normalized [0.0, 1.0] range.

  FEATURES DEMONSTRATED:
  • Custom GLSL fragment shader with wave distortion and color tinting
  • Real-time uniform parameter modification through keyboard input
  • Procedural texture generation with 32x32 pixel checkerboard pattern
  • Shader compilation, linking, and error handling systems
  • Interactive parameter control for educational purposes
  • Frame-rate independent animation using delta time accumulation

  RENDERING TECHNIQUES:
  Multi-pass rendering approach with conditional shader application, texture
  coordinate manipulation through sinusoidal functions, RGB color space tinting
  using component-wise multiplication, and real-time uniform buffer updates.
  Performance optimization through single texture unit binding and efficient
  shader state management.

  CONTROLS:
  SPACE - Toggle shader on/off for comparison viewing
  1,2,3 - Apply red, green, or blue color tints respectively
  R - Reset color tint to neutral white
  UP/DOWN - Increase/decrease wave distortion strength (0.0 to 0.1 range)
  F11 - Toggle fullscreen display mode
  ESC - Exit demonstration

  MATHEMATICAL FOUNDATION:
  Wave calculation: float wave = sin(uv.y * 10.0 + time * 2.0) * waveStrength;
  Coordinate transformation: uv.x += wave;
  Color tinting: texColor.rgb *= tintColor;
  Checkerboard generation: ((LX div 32) + (LY div 32)) mod 2

  PERFORMANCE CHARACTERISTICS:
  Expected 60+ FPS on modern hardware with single 256x256 texture, minimal GPU
  memory usage of approximately 256KB for texture data, optimized uniform
  updates per frame, and efficient shader state switching. Scalable to multiple
  texture units and complex shader combinations.

  EDUCATIONAL VALUE:
  Developers learn OpenGL shader programming fundamentals, uniform variable
  management, texture coordinate manipulation, real-time parameter control,
  shader compilation error handling, and interactive graphics programming
  patterns. Transferable concepts include GLSL syntax, graphics pipeline
  understanding, and performance optimization techniques for real-world
  shader development projects.
******************************************************************************)

unit UBasicShaderDemo;

interface

uses
  System.SysUtils,
  Game2D.Common,
  Game2D.Core,
  UCommon;

procedure BasicShaderDemo();

implementation

procedure BasicShaderDemo();
const
  // Custom fragment shader with color tinting and wave effect
  LCustomFragmentShader =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'uniform float time;' + #13#10 +
    'uniform vec3 tintColor;' + #13#10 +
    'uniform float waveStrength;' + #13#10 +
    'uniform vec2 resolution;' + #13#10 +
    'void main() {' + #13#10 +
    '  vec2 uv = vTexCoord;' + #13#10 +
    '  ' + #13#10 +
    '  // Add wave distortion' + #13#10 +
    '  float wave = sin(uv.y * 10.0 + time * 2.0) * waveStrength;' + #13#10 +
    '  uv.x += wave;' + #13#10 +
    '  ' + #13#10 +
    '  if (useTexture) {' + #13#10 +
    '    vec4 texColor = texture2D(mainTexture, uv);' + #13#10 +
    '    // Apply color tint' + #13#10 +
    '    texColor.rgb *= tintColor;' + #13#10 +
    '    gl_FragColor = texColor * vColor;' + #13#10 +
    '  } else {' + #13#10 +
    '    gl_FragColor = vColor;' + #13#10 +
    '  }' + #13#10 +
    '}';

var
  LWindow: Tg2dWindow;
  LTexture: Tg2dTexture;
  LShader: Tg2dShader;
  LFont: Tg2dFont;
  LTime: Single;
  LTintColor: Tg2dVec;
  LWaveStrength: Single;
  LUseShader: Boolean;
  LResolution: Tg2dSize;
  LX: Integer;
  LY: Integer;
  LColor: Tg2dColor;
  LTextY: Single;
  LScale: Single;
  LCurrentTintName: string;
begin
  LWindow := Tg2dWindow.Init('Game2D - Shader Demo', 800, 600);
  try
    LWindow.SetSizeLimits(400, 300, G2D_DONT_CARE, G2D_DONT_CARE);

    // Initialize font
    LFont := Tg2dFont.Init(LWindow, G2D_SDF_SIZE_BALANCED);
    if not Assigned(LFont) then
    begin
      Tg2dUtils.FatalError('Failed to initialize font', []);
      Exit;
    end;

    // Create a test texture
    LTexture := Tg2dTexture.Create();
    LTexture.Alloc(256, 256, G2D_WHITE);

    // Fill texture with a pattern for better shader visibility
    if LTexture.Lock() then
    begin
      for LY := 0 to 255 do
      begin
        for LX := 0 to 255 do
        begin
          // Create a checkerboard pattern with colors
          if ((LX div 32) + (LY div 32)) mod 2 = 0 then
            LColor := G2D_RED
          else
            LColor := G2D_BLUE;
          LTexture.SetPixel(LX, LY, LColor);
        end;
      end;
      LTexture.Unlock();
    end;

    LTexture.SetPos(LWindow.GetVirtualSize().Width/2, LWindow.GetVirtualSize().Height/2);
    LTexture.SetScale(2.0);

    // Create and setup shader
    LShader := Tg2dShader.Create();

    // Load default vertex shader and custom fragment shader
    if not LShader.Load(skVertex, G2D_DEFAULT_VERTEX_SHADER) then
    begin
      Tg2dUtils.FatalError('Failed to load vertex shader: %s', [LShader.GetLog()]);
      Exit;
    end;

    if not LShader.Load(skFragment, LCustomFragmentShader) then
    begin
      Tg2dUtils.FatalError('Failed to load fragment shader: %s', [LShader.GetLog()]);
      Exit;
    end;

    if not LShader.Build() then
    begin
      Tg2dUtils.FatalError('Failed to build shader: %s', [LShader.GetLog()]);
      Exit;
    end;

    // Initialize shader parameters
    LTime := 0.0;
    LTintColor := Tg2dVec.Create(1.0, 1.0, 1.0); // Start with white (no tint)
    LWaveStrength := 0.02;
    LUseShader := True;
    LResolution := LWindow.GetVirtualSize();
    LCurrentTintName := 'White';

    while not LWindow.ShouldClose() do
    begin
      LWindow.StartFrame();

        // Input handling
        if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
          LWindow.SetShouldClose(True);

        if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
          LWindow.ToggleFullscreen();

        // Toggle shader on/off with SPACE
        if LWindow.GetKey(G2D_KEY_SPACE, isWasPressed) then
          LUseShader := not LUseShader;

        // Control tint color with number keys
        if LWindow.GetKey(G2D_KEY_1, isWasPressed) then
        begin
          LTintColor := Tg2dVec.Create(1.0, 0.2, 0.2); // Strong red tint
          LCurrentTintName := 'Red';
        end;

        if LWindow.GetKey(G2D_KEY_2, isWasPressed) then
        begin
          LTintColor := Tg2dVec.Create(0.2, 1.0, 0.2); // Strong green tint
          LCurrentTintName := 'Green';
        end;

        if LWindow.GetKey(G2D_KEY_3, isWasPressed) then
        begin
          LTintColor := Tg2dVec.Create(0.2, 0.2, 1.0); // Strong blue tint
          LCurrentTintName := 'Blue';
        end;

        if LWindow.GetKey(G2D_KEY_R, isWasPressed) then
        begin
          LTintColor := Tg2dVec.Create(1.0, 1.0, 1.0); // Reset to white
          LCurrentTintName := 'White';
        end;

        // Control wave strength with arrow keys
        if LWindow.GetKey(G2D_KEY_UP, isPressed) then
          LWaveStrength := LWaveStrength + 0.001;

        if LWindow.GetKey(G2D_KEY_DOWN, isPressed) then
          LWaveStrength := LWaveStrength - 0.001;

        // Clamp wave strength
        if LWaveStrength < 0.0 then LWaveStrength := 0.0;
        if LWaveStrength > 0.1 then LWaveStrength := 0.1;

        // Update time for animation
        LTime := LTime + LWindow.GetDeltaTime();

        LWindow.StartDrawing();
          LWindow.Clear(G2D_DARKSLATEBROWN);

          if LUseShader then
          begin
            // Enable shader and set uniforms
            LShader.Enable(True);
            LShader.SetFloatUniform('time', LTime);
            LShader.SetVec3Uniform('tintColor', LTintColor);
            LShader.SetFloatUniform('waveStrength', LWaveStrength);
            LShader.SetVec2Uniform('resolution', LResolution);
            LShader.SetBoolUniform('useTexture', True);
            LShader.SetTextureUniform('mainTexture', LTexture, 0);

            // Draw texture with shader
            LTexture.Draw();

            // Disable shader
            LShader.Enable(False);
          end
          else
          begin
            // Draw texture without shader
            LTexture.Draw();
          end;

          // Draw UI text
          LScale := LFont.GetLogicalScale(12.0);
          LTextY := 10;

          // Title
          LFont.DrawText(LWindow, 10, LTextY, LFont.GetLogicalScale(16.0), G2D_WHITE, haLeft, 'Game2D Shader Demo');
          LTextY := LTextY + LFont.LineHeight(LFont.GetLogicalScale(16.0)) + 5;

          // Shader status
          if LUseShader then
            LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_GREEN, haLeft, 'Shader: ENABLED')
          else
            LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_RED, haLeft, 'Shader: DISABLED');
          LTextY := LTextY + LFont.LineHeight(LScale) + 3;

          // Current parameters (only show when shader is enabled)
          if LUseShader then
          begin
            LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_YELLOW, haLeft, 'Tint Color: %s', [LCurrentTintName]);
            LTextY := LTextY + LFont.LineHeight(LScale) + 3;

            LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_YELLOW, haLeft, 'Wave Strength: %.3f', [LWaveStrength]);
            LTextY := LTextY + LFont.LineHeight(LScale) + 10;
          end;

          // Controls
          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_LIGHTBLUE, haLeft, 'Controls:');
          LTextY := LTextY + LFont.LineHeight(LScale) + 3;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, 'SPACE    - Toggle shader on/off');
          LTextY := LTextY + LFont.LineHeight(LScale) + 2;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, '1,2,3    - Change tint color');
          LTextY := LTextY + LFont.LineHeight(LScale) + 2;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, 'R        - Reset tint to white');
          LTextY := LTextY + LFont.LineHeight(LScale) + 2;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, 'UP/DOWN  - Adjust wave strength');
          LTextY := LTextY + LFont.LineHeight(LScale) + 2;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, 'F11      - Toggle fullscreen');
          LTextY := LTextY + LFont.LineHeight(LScale) + 2;

          LFont.DrawText(LWindow, 10, LTextY, LScale, G2D_WHITE, haLeft, 'ESC      - Exit');

          // Frame rate display (top right)
          LFont.DrawText(LWindow, LWindow.GetVirtualSize().Width - 10, 10, LScale, G2D_YELLOW, haRight, '%d fps', [LWindow.GetFrameRate()]);

        LWindow.EndDrawing();

      LWindow.EndFrame();
    end;

    LFont.Free();
    LShader.Free();
    LTexture.Free();

  finally
    LWindow.Free();
  end;
end;

end.

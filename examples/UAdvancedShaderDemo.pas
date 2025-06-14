(******************************************************************************
  ADVANCED SHADER DEMO - Real-time Mathematical Visualization Engine

  A comprehensive demonstration of advanced fragment shader programming using the
  Game2D framework, showcasing four distinct procedural rendering techniques:
  infinite Mandelbrot fractal zoom, plasma energy simulation, 3D raymarching
  with distance fields, and realistic fire simulation. This demo illustrates
  GPU-accelerated mathematical computation, complex number arithmetic, noise
  generation algorithms, and real-time interactive visual effects suitable
  for advanced graphics programming education and technical showcasing.

  COMPLEXITY LEVEL: Advanced

  OVERVIEW:
  This demo demonstrates cutting-edge shader programming techniques by implementing
  four mathematically intensive visual effects entirely on the GPU. Each effect
  showcases different aspects of computational graphics: fractal mathematics,
  wave simulation, 3D rendering in 2D space, and procedural animation. The demo
  serves as both an educational tool for understanding advanced shader concepts
  and a technical showcase of the Game2D framework's shader capabilities.

  TECHNICAL IMPLEMENTATION:
  Core architecture utilizes the Tg2dShader class with custom GLSL fragment
  shaders processing fullscreen quads. Each effect operates on normalized
  texture coordinates (0.0-1.0) transformed to appropriate mathematical spaces.

  Key Systems:
  - Shader Management: Dynamic compilation and uniform parameter binding
  - Precision Handling: Double-precision coordinates for deep fractal zoom
  - Parametric Animation: Time-based uniform updates for continuous motion
  - Interactive Control: Mouse position mapping to shader parameters

  Mathematical Foundations:
  - Complex Number Iteration: z = z² + c for Mandelbrot computation
  - Trigonometric Synthesis: Multiple sine wave superposition for plasma
  - Distance Field Evaluation: Signed distance functions for 3D geometry
  - Fractal Brownian Motion: Multi-octave noise for fire simulation

  Memory Architecture:
  - Single base texture (1024x768) with gradient pattern
  - Shader uniform buffers for real-time parameter updates
  - No vertex buffer management - leverages built-in quad rendering

  FEATURES DEMONSTRATED:
  • GPU-accelerated complex number arithmetic
  • Infinite precision mathematical zoom with coordinate cycling
  • Multi-frequency wave interference patterns
  • Real-time 3D raymarching in fragment shaders
  • Procedural noise generation and animation
  • Dynamic iteration scaling based on zoom depth
  • HSV to RGB color space conversion
  • Interactive parameter manipulation via mouse input
  • Automatic effect transitions with timing control
  • Famous mathematical coordinate exploration

  RENDERING TECHNIQUES:
  Primary rendering operates through fragment shader processing of a fullscreen
  textured quad. Each pixel's screen coordinates are transformed to mathematical
  space where procedural algorithms generate color values.

  Mandelbrot Implementation:
  - Coordinate transformation: screen → complex plane
  - Iterative computation: z(n+1) = z(n)² + c
  - Smooth iteration counting with logarithmic interpolation
  - Dynamic iteration limits: 128 + (zoom_level / 100)
  - Color mapping via HSV space with temporal shifting

  Plasma Generation:
  - Five-wave superposition with varying frequencies
  - Time-based phase shifting for animation
  - Mouse-influenced disturbance patterns
  - HSV color cycling for smooth transitions

  Raymarching Process:
  - Camera ray generation from screen coordinates
  - Sphere tracing using signed distance fields
  - Surface normal computation via gradient estimation
  - Phong lighting model with directional illumination

  Fire Simulation:
  - Fractal Brownian Motion noise generation
  - Six-octave noise summation with amplitude decay
  - Vertical gradient masking for flame shape
  - Temperature-based color grading (black→red→orange→yellow)

  CONTROLS:
  1-4 Keys: Direct effect selection (Mandelbrot/Plasma/Raymarching/Fire)
  SPACE: Toggle automatic effect cycling (12-second intervals)
  R: Cycle to next Mandelbrot zoom target (7 famous coordinates)
  Mouse: Interactive parameter control for each effect
  F11: Fullscreen toggle
  ESC: Exit demo

  MATHEMATICAL FOUNDATION:

  Mandelbrot Iteration Core:
    for i in 0..max_iterations:
      if |z|² > 4.0: break
      z = z² + c

  Smooth Iteration Count:
    smooth_iter = iterations + 1 - log₂(log₂(|z|²))

  Plasma Wave Synthesis:
    plasma = (sin(x*2 + t) + sin(y*3 + t*1.5) + sin((x+y)*1.5 + t*0.8) +
              sin(√(x²+y²)*4 + t*2) + mouse_influence) / 5

  Distance Field Sphere:
    sdf_sphere(p, r) = length(p) - r

  Fractal Brownian Motion:
    fbm(p) = Σ(amplitude[i] * noise(p * frequency[i])) for i in 0..5

  Famous Mandelbrot Coordinates:
  - Spiral: (-0.7435669, 0.1314023)
  - Lightning: (-0.16, 1.0405)
  - Seahorse Valley: (-0.75, 0.1)
  - Elephant Valley: (-1.25066, 0.02012)
  - Mini Mandelbrot: (-0.74529, 0.11307)

  PERFORMANCE CHARACTERISTICS:
  Target Performance: 60 FPS at 1024x768 resolution
  GPU Utilization: Fragment shader intensive, minimal vertex processing
  Memory Footprint: ~3MB texture data, minimal CPU overhead
  Precision Limits: Mandelbrot zoom effective to ~10⁹ before cycling

  Optimization Strategies:
  - Iteration limit capping (1000 maximum) prevents GPU stalls
  - Early termination in fractal computation reduces unnecessary cycles
  - Efficient HSV→RGB conversion using vectorized operations
  - Single-pass rendering eliminates multi-target complexity

  EDUCATIONAL VALUE:
  This demo provides comprehensive coverage of advanced GPU programming concepts
  essential for modern graphics development:

  Transferable Concepts:
  - Fragment shader architecture and GLSL programming
  - Mathematical visualization and procedural generation
  - Real-time parameter animation and user interaction
  - Complex coordinate space transformations
  - GPU optimization techniques for compute-intensive algorithms

  Progression Path:
  Beginner: Understand basic shader structure and uniform binding
  Intermediate: Analyze mathematical algorithms and coordinate transformations
  Advanced: Optimize performance and implement custom mathematical functions

  Real-world Applications:
  - Scientific visualization and mathematical modeling
  - Procedural content generation for games
  - Real-time visual effects and post-processing
  - Educational software for mathematics and physics
  - Technical demonstrations and portfolio showcases
******************************************************************************)

unit UAdvancedShaderDemo;

interface

uses
  System.SysUtils,
  System.Math,
  Game2D.Deps,
  Game2D.Common,
  Game2D.Core;

procedure AdvancedShaderDemo();

implementation

procedure AdvancedShaderDemo();
const
  WINDOW_WIDTH = 1024;
  WINDOW_HEIGHT = 768;

  // Vertex shader for fullscreen rendering
  VERTEX_SHADER_SOURCE =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'void main() {' + #13#10 +
    '  gl_Position = ftransform();' + #13#10 +
    '  vTexCoord = gl_MultiTexCoord0.xy;' + #13#10 +
    '  vColor = gl_Color;' + #13#10 +
    '}';

  // Mandelbrot fractal shader
  MANDELBROT_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'uniform float uTime;' + #13#10 +
    'uniform vec2 uResolution;' + #13#10 +
    'uniform vec2 uMouse;' + #13#10 +
    'uniform float uZoom;' + #13#10 +
    'uniform vec2 uCenter;' + #13#10 +
    'uniform int uMaxIterations;' + #13#10 +
    'uniform float uColorShift;' + #13#10 +
    '' + #13#10 +
    'vec3 hsv2rgb(vec3 c) {' + #13#10 +
    '  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);' + #13#10 +
    '  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);' + #13#10 +
    '  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'void main() {' + #13#10 +
    '  vec2 uv = (vTexCoord - 0.5) * 2.0;' + #13#10 +
    '  uv.x *= uResolution.x / uResolution.y;' + #13#10 +
    '  ' + #13#10 +
    '  vec2 c = uCenter + uv / uZoom;' + #13#10 +
    '  vec2 z = vec2(0.0);' + #13#10 +
    '  int iterations = 0;' + #13#10 +
    '  ' + #13#10 +
    '  for (int i = 0; i < 256; i++) {' + #13#10 +
    '    if (i >= uMaxIterations) break;' + #13#10 +
    '    if (dot(z, z) > 4.0) break;' + #13#10 +
    '    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;' + #13#10 +
    '    iterations = i;' + #13#10 +
    '  }' + #13#10 +
    '  ' + #13#10 +
    '  if (iterations >= uMaxIterations - 1) {' + #13#10 +
    '    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);' + #13#10 +
    '  } else {' + #13#10 +
    '    float smoothIter = float(iterations) + 1.0 - log2(log2(dot(z, z)));' + #13#10 +
    '    float hue = fract(smoothIter / 32.0 + uColorShift);' + #13#10 +
    '    vec3 color = hsv2rgb(vec3(hue, 0.8, 1.0));' + #13#10 +
    '    gl_FragColor = vec4(color, 1.0);' + #13#10 +
    '  }' + #13#10 +
    '}';

  // Plasma effect shader
  PLASMA_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'uniform float uTime;' + #13#10 +
    'uniform vec2 uResolution;' + #13#10 +
    'uniform vec2 uMouse;' + #13#10 +
    'uniform float uSpeed;' + #13#10 +
    'uniform float uComplexity;' + #13#10 +
    '' + #13#10 +
    'vec3 hsv2rgb(vec3 c) {' + #13#10 +
    '  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);' + #13#10 +
    '  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);' + #13#10 +
    '  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'void main() {' + #13#10 +
    '  vec2 uv = vTexCoord * uComplexity;' + #13#10 +
    '  float time = uTime * uSpeed;' + #13#10 +
    '  ' + #13#10 +
    '  float plasma1 = sin(uv.x * 2.0 + time);' + #13#10 +
    '  float plasma2 = sin(uv.y * 3.0 + time * 1.5);' + #13#10 +
    '  float plasma3 = sin((uv.x + uv.y) * 1.5 + time * 0.8);' + #13#10 +
    '  float plasma4 = sin(sqrt(uv.x * uv.x + uv.y * uv.y) * 4.0 + time * 2.0);' + #13#10 +
    '  ' + #13#10 +
    '  vec2 mouseInfluence = (uMouse - 0.5) * 2.0;' + #13#10 +
    '  float mouseDist = length(uv - mouseInfluence * 5.0);' + #13#10 +
    '  float plasma5 = sin(mouseDist * 3.0 - time * 3.0);' + #13#10 +
    '  ' + #13#10 +
    '  float combined = (plasma1 + plasma2 + plasma3 + plasma4 + plasma5) / 5.0;' + #13#10 +
    '  float hue = fract(combined * 0.5 + time * 0.1);' + #13#10 +
    '  ' + #13#10 +
    '  vec3 color = hsv2rgb(vec3(hue, 0.8, 0.8 + 0.2 * sin(combined * 3.14159)));' + #13#10 +
    '  gl_FragColor = vec4(color, 1.0);' + #13#10 +
    '}';

  // Raymarching shader
  RAYMARCHING_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'uniform float uTime;' + #13#10 +
    'uniform vec2 uResolution;' + #13#10 +
    'uniform vec2 uMouse;' + #13#10 +
    'uniform float uCameraDistance;' + #13#10 +
    '' + #13#10 +
    'float sdSphere(vec3 p, float r) {' + #13#10 +
    '  return length(p) - r;' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'float sdBox(vec3 p, vec3 b) {' + #13#10 +
    '  vec3 d = abs(p) - b;' + #13#10 +
    '  return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'float sdTorus(vec3 p, vec2 t) {' + #13#10 +
    '  vec2 q = vec2(length(p.xz) - t.x, p.y);' + #13#10 +
    '  return length(q) - t.y;' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'mat3 rotateY(float angle) {' + #13#10 +
    '  float c = cos(angle);' + #13#10 +
    '  float s = sin(angle);' + #13#10 +
    '  return mat3(c, 0, s, 0, 1, 0, -s, 0, c);' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'float map(vec3 p) {' + #13#10 +
    '  p = rotateY(uTime * 0.5) * p;' + #13#10 +
    '  ' + #13#10 +
    '  float sphere = sdSphere(p + vec3(0, sin(uTime * 2.0) * 0.5, 0), 0.8);' + #13#10 +
    '  float box = sdBox(p + vec3(1.5, 0, 0), vec3(0.6));' + #13#10 +
    '  float torus = sdTorus(p + vec3(-1.5, 0, 0), vec2(0.8, 0.3));' + #13#10 +
    '  ' + #13#10 +
    '  return min(sphere, min(box, torus));' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'vec3 getNormal(vec3 p) {' + #13#10 +
    '  const float eps = 0.001;' + #13#10 +
    '  return normalize(vec3(' + #13#10 +
    '    map(p + vec3(eps, 0, 0)) - map(p - vec3(eps, 0, 0)),' + #13#10 +
    '    map(p + vec3(0, eps, 0)) - map(p - vec3(0, eps, 0)),' + #13#10 +
    '    map(p + vec3(0, 0, eps)) - map(p - vec3(0, 0, eps))' + #13#10 +
    '  ));' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'void main() {' + #13#10 +
    '  vec2 uv = (vTexCoord - 0.5) * 2.0;' + #13#10 +
    '  uv.x *= uResolution.x / uResolution.y;' + #13#10 +
    '  ' + #13#10 +
    '  vec2 mouse = (uMouse - 0.5) * 6.0;' + #13#10 +
    '  vec3 ro = vec3(sin(mouse.x) * uCameraDistance, mouse.y * 2.0, cos(mouse.x) * uCameraDistance);' + #13#10 +
    '  vec3 rd = normalize(vec3(uv, -1.0));' + #13#10 +
    '  ' + #13#10 +
    '  float t = 0.0;' + #13#10 +
    '  for (int i = 0; i < 64; i++) {' + #13#10 +
    '    vec3 p = ro + rd * t;' + #13#10 +
    '    float d = map(p);' + #13#10 +
    '    if (d < 0.001 || t > 10.0) break;' + #13#10 +
    '    t += d;' + #13#10 +
    '  }' + #13#10 +
    '  ' + #13#10 +
    '  if (t > 10.0) {' + #13#10 +
    '    gl_FragColor = vec4(0.1, 0.1, 0.2, 1.0);' + #13#10 +
    '  } else {' + #13#10 +
    '    vec3 p = ro + rd * t;' + #13#10 +
    '    vec3 normal = getNormal(p);' + #13#10 +
    '    vec3 light = normalize(vec3(1, 1, 1));' + #13#10 +
    '    float diff = max(dot(normal, light), 0.0);' + #13#10 +
    '    vec3 color = vec3(0.2, 0.4, 0.8) * (0.3 + 0.7 * diff);' + #13#10 +
    '    gl_FragColor = vec4(color, 1.0);' + #13#10 +
    '  }' + #13#10 +
    '}';

  // Fire effect shader
  FIRE_FRAGMENT_SHADER =
    '#version 120' + #13#10 +
    'varying vec2 vTexCoord;' + #13#10 +
    'varying vec4 vColor;' + #13#10 +
    'uniform sampler2D mainTexture;' + #13#10 +
    'uniform bool useTexture;' + #13#10 +
    'uniform float uTime;' + #13#10 +
    'uniform vec2 uResolution;' + #13#10 +
    'uniform vec2 uMouse;' + #13#10 +
    'uniform float uIntensity;' + #13#10 +
    '' + #13#10 +
    'float noise(vec2 p) {' + #13#10 +
    '  return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'float fbm(vec2 p) {' + #13#10 +
    '  float value = 0.0;' + #13#10 +
    '  float amplitude = 0.5;' + #13#10 +
    '  for (int i = 0; i < 6; i++) {' + #13#10 +
    '    value += amplitude * noise(p);' + #13#10 +
    '    p *= 2.0;' + #13#10 +
    '    amplitude *= 0.5;' + #13#10 +
    '  }' + #13#10 +
    '  return value;' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    'void main() {' + #13#10 +
    '  vec2 uv = vTexCoord;' + #13#10 +
    '  uv.y = 1.0 - uv.y;' + #13#10 +
    '  ' + #13#10 +
    '  vec2 mouseInfluence = uMouse * 2.0;' + #13#10 +
    '  float mouseDist = distance(uv, mouseInfluence);' + #13#10 +
    '  float mouseEffect = exp(-mouseDist * 3.0) * 0.5;' + #13#10 +
    '  ' + #13#10 +
    '  vec2 q = uv;' + #13#10 +
    '  q.x += sin(uTime * 2.0 + uv.y * 10.0) * 0.02;' + #13#10 +
    '  ' + #13#10 +
    '  float noise1 = fbm(q * 3.0 + vec2(0.0, uTime * 2.0));' + #13#10 +
    '  float noise2 = fbm(q * 6.0 + vec2(uTime * 1.5, 0.0));' + #13#10 +
    '  ' + #13#10 +
    '  float fire = noise1 * noise2;' + #13#10 +
    '  fire *= (1.0 - uv.y) * (1.0 - uv.y);' + #13#10 +
    '  fire += mouseEffect;' + #13#10 +
    '  fire *= uIntensity;' + #13#10 +
    '  ' + #13#10 +
    '  vec3 color = vec3(0.0);' + #13#10 +
    '  if (fire > 0.4) {' + #13#10 +
    '    color = mix(vec3(1.0, 0.3, 0.0), vec3(1.0, 1.0, 0.2), (fire - 0.4) * 2.0);' + #13#10 +
    '  } else if (fire > 0.2) {' + #13#10 +
    '    color = mix(vec3(0.8, 0.0, 0.0), vec3(1.0, 0.3, 0.0), (fire - 0.2) * 5.0);' + #13#10 +
    '  } else if (fire > 0.1) {' + #13#10 +
    '    color = mix(vec3(0.0), vec3(0.8, 0.0, 0.0), (fire - 0.1) * 10.0);' + #13#10 +
    '  }' + #13#10 +
    '  ' + #13#10 +
    '  gl_FragColor = vec4(color, 1.0);' + #13#10 +
    '}';

var
  LWindow: Tg2dWindow;
  LFont: Tg2dFont;
  LBaseTexture: Tg2dTexture;
  LShaderMandelbrot: Tg2dShader;
  LShaderPlasma: Tg2dShader;
  LShaderRaymarching: Tg2dShader;
  LShaderFire: Tg2dShader;
  LCurrentShader: Tg2dShader;
  LCurrentEffect: Integer;
  LTime: Single;
  LDeltaTime: Single;
  LMouseX: Single;
  LMouseY: Single;
  LEffectTimer: Single;
  LAutoSwitch: Boolean;
  LZoomLevel: Double; // Use Double for higher precision
  LCenterX: Double;   // Use Double for higher precision
  LCenterY: Double;   // Use Double for higher precision
  LMaxIterations: Integer;
  LColorShift: Single;
  LPlasmaSpeed: Single;
  LPlasmaComplexity: Single;
  LCameraDistance: Single;
  LFireIntensity: Single;
  LHudPos: Tg2dVec;
  LColor: Tg2dColor;
  LCurrentZoomPoint: Integer;

  function InitializeShaders(): Boolean;
  begin
    Result := False;

    // Initialize Mandelbrot shader
    LShaderMandelbrot := Tg2dShader.Create();
    if not LShaderMandelbrot.Load(skVertex, VERTEX_SHADER_SOURCE) then Exit;
    if not LShaderMandelbrot.Load(skFragment, MANDELBROT_FRAGMENT_SHADER) then Exit;
    if not LShaderMandelbrot.Build() then Exit;

    // Initialize Plasma shader
    LShaderPlasma := Tg2dShader.Create();
    if not LShaderPlasma.Load(skVertex, VERTEX_SHADER_SOURCE) then Exit;
    if not LShaderPlasma.Load(skFragment, PLASMA_FRAGMENT_SHADER) then Exit;
    if not LShaderPlasma.Build() then Exit;

    // Initialize Raymarching shader
    LShaderRaymarching := Tg2dShader.Create();
    if not LShaderRaymarching.Load(skVertex, VERTEX_SHADER_SOURCE) then Exit;
    if not LShaderRaymarching.Load(skFragment, RAYMARCHING_FRAGMENT_SHADER) then Exit;
    if not LShaderRaymarching.Build() then Exit;

    // Initialize Fire shader
    LShaderFire := Tg2dShader.Create();
    if not LShaderFire.Load(skVertex, VERTEX_SHADER_SOURCE) then Exit;
    if not LShaderFire.Load(skFragment, FIRE_FRAGMENT_SHADER) then Exit;
    if not LShaderFire.Build() then Exit;

    Result := True;
  end;

  procedure CleanupShaders();
  begin
    if Assigned(LShaderMandelbrot) then
      LShaderMandelbrot.Free();
    if Assigned(LShaderPlasma) then
      LShaderPlasma.Free();
    if Assigned(LShaderRaymarching) then
      LShaderRaymarching.Free();
    if Assigned(LShaderFire) then
      LShaderFire.Free();
  end;

  procedure CreateBaseTexture();
  var
    LX,LY: Integer;
  begin
    // Create a base texture with a pattern that works well with shaders
    LBaseTexture := Tg2dTexture.Create();
    LBaseTexture.Alloc(WINDOW_WIDTH, WINDOW_HEIGHT, G2D_WHITE);

    // Fill texture with a gradient pattern for better shader visibility
    if LBaseTexture.Lock() then
    begin
      for LY := 0 to WINDOW_HEIGHT - 1 do
      begin
        for LX := 0 to WINDOW_WIDTH - 1 do
        begin
          // Create a simple gradient
          LColor.Red := LX / WINDOW_WIDTH;
          LColor.Green := LY / WINDOW_HEIGHT;
          LColor.Blue := 0.5;
          LColor.Alpha := 1.0;
          LBaseTexture.SetPixel(LX, LY, LColor);
        end;
      end;
      LBaseTexture.Unlock();
    end;

    LBaseTexture.SetPos(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2);
    LBaseTexture.SetScale(1.0);
  end;

  procedure SetShaderUniforms();
  begin
    if not Assigned(LCurrentShader) then Exit;

    LCurrentShader.SetFloatUniform('uTime', LTime);
    LCurrentShader.SetVec2Uniform('uResolution', WINDOW_WIDTH, WINDOW_HEIGHT);
    LCurrentShader.SetVec2Uniform('uMouse', LMouseX, LMouseY);
    LCurrentShader.SetBoolUniform('useTexture', False); // We're generating procedural effects

    case LCurrentEffect of
      0: begin // Mandelbrot
        LCurrentShader.SetFloatUniform('uZoom', LZoomLevel);
        LCurrentShader.SetVec2Uniform('uCenter', LCenterX, LCenterY);
        LCurrentShader.SetIntUniform('uMaxIterations', LMaxIterations);
        LCurrentShader.SetFloatUniform('uColorShift', LColorShift);
      end;
      1: begin // Plasma
        LCurrentShader.SetFloatUniform('uSpeed', LPlasmaSpeed);
        LCurrentShader.SetFloatUniform('uComplexity', LPlasmaComplexity);
      end;
      2: begin // Raymarching
        LCurrentShader.SetFloatUniform('uCameraDistance', LCameraDistance);
      end;
      3: begin // Fire
        LCurrentShader.SetFloatUniform('uIntensity', LFireIntensity);
      end;
    end;
  end;

  procedure UpdateParameters();
  type
    TInterestingPoint = record
      X, Y: Double;
      Name: string;
    end;
  const
    // Famous Mandelbrot zoom coordinates with infinite detail
    INTERESTING_POINTS: array[0..6] of TInterestingPoint = (
      (X: -0.7435669; Y:  0.1314023; Name: 'Spiral'),
      (X: -0.16;      Y:  1.0405;    Name: 'Lightning'),
      (X: -0.7;       Y:  0.0;       Name: 'Tendril'),
      (X: -0.75;      Y:  0.1;       Name: 'Seahorse Valley'),
      (X: -1.25066;   Y:  0.02012;   Name: 'Elephant Valley'),
      (X: -0.8;       Y:  0.156;     Name: 'Twisted Branches'),
      (X: -0.74529;   Y:  0.11307;   Name: 'Mini Mandelbrot')
    );
  var
    LBaseIterations: Integer;
  begin
    LTime := LTime + LDeltaTime;
    LColorShift := LColorShift + LDeltaTime * 0.1;

    // Infinite zoom for Mandelbrot
    if LCurrentEffect = 0 then
    begin
      // Zoom IN continuously (multiply by > 1.0)
      LZoomLevel := LZoomLevel * (1.0 + LDeltaTime * 0.8);

      // Calculate dynamic iterations based on zoom level
      LBaseIterations := 128;
      LMaxIterations := Round(LBaseIterations + (LZoomLevel / 100.0));
      if LMaxIterations > 1000 then LMaxIterations := 1000; // Cap at reasonable limit

      // When zoom gets extreme (precision limits), cycle to next interesting point
      if LZoomLevel > 1000000000.0 then
      begin
        LCurrentZoomPoint := (LCurrentZoomPoint + 1) mod Length(INTERESTING_POINTS);
        LCenterX := INTERESTING_POINTS[LCurrentZoomPoint].X;
        LCenterY := INTERESTING_POINTS[LCurrentZoomPoint].Y;
        LZoomLevel := 0.5; // Reset zoom to start zooming into new point
        LMaxIterations := LBaseIterations;
      end;
    end;

    // Auto-switch effects
    if LAutoSwitch then
    begin
      LEffectTimer := LEffectTimer + LDeltaTime;
      if LEffectTimer > 12.0 then // Give more time for Mandelbrot zoom
      begin
        LEffectTimer := 0.0;
        LCurrentEffect := (LCurrentEffect + 1) mod 4;
        case LCurrentEffect of
          0: LCurrentShader := LShaderMandelbrot;
          1: LCurrentShader := LShaderPlasma;
          2: LCurrentShader := LShaderRaymarching;
          3: LCurrentShader := LShaderFire;
        end;
      end;
    end;
  end;

  procedure HandleInput();
  begin
    // Get normalized mouse position
    LMouseX := LWindow.GetMousePos().x / WINDOW_WIDTH;
    LMouseY := 1.0 - (LWindow.GetMousePos().y / WINDOW_HEIGHT);

    // Check for key presses (1-4 for effects)
    if LWindow.GetKey(GLFW_KEY_1, isWasPressed) then
    begin
      LCurrentEffect := 0;
      LCurrentShader := LShaderMandelbrot;
      LAutoSwitch := False;
    end;

    if LWindow.GetKey(GLFW_KEY_2, isWasPressed) then
    begin
      LCurrentEffect := 1;
      LCurrentShader := LShaderPlasma;
      LAutoSwitch := False;
    end;

    if LWindow.GetKey(GLFW_KEY_3, isWasPressed) then
    begin
      LCurrentEffect := 2;
      LCurrentShader := LShaderRaymarching;
      LAutoSwitch := False;
    end;

    if LWindow.GetKey(GLFW_KEY_4, isWasPressed) then
    begin
      LCurrentEffect := 3;
      LCurrentShader := LShaderFire;
      LAutoSwitch := False;
    end;

    if LWindow.GetKey(GLFW_KEY_SPACE, isWasPressed) then
    begin
      LAutoSwitch := not LAutoSwitch;
      LEffectTimer := 0.0;
    end;

    if LWindow.GetKey(GLFW_KEY_R, isWasPressed) then
    begin
      // Reset to next interesting point
      LCurrentZoomPoint := (LCurrentZoomPoint + 1) mod 7;
      case LCurrentZoomPoint of
        0: begin LCenterX := -0.7435669; LCenterY :=  0.1314023; end; // Spiral
        1: begin LCenterX := -0.16;      LCenterY :=  1.0405;    end; // Lightning
        2: begin LCenterX := -0.7;       LCenterY :=  0.0;       end; // Tendril
        3: begin LCenterX := -0.75;      LCenterY :=  0.1;       end; // Seahorse Valley
        4: begin LCenterX := -1.25066;   LCenterY :=  0.02012;   end; // Elephant Valley
        5: begin LCenterX := -0.8;       LCenterY :=  0.156;     end; // Twisted Branches
        6: begin LCenterX := -0.74529;   LCenterY :=  0.11307;   end; // Mini Mandelbrot
      end;
      LZoomLevel := 0.5;
    end;
  end;

  function GetEffectName(): string;
  begin
    case LCurrentEffect of
      0: Result := 'Mandelbrot Fractal';
      1: Result := 'Plasma Effect';
      2: Result := 'Raymarching 3D';
      3: Result := 'Fire Simulation';
    else
      Result := 'Unknown Effect';
    end;
  end;

  procedure RenderHUD();
  begin
    LHudPos.Assign(10, 10);

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(14),
                   G2D_YELLOW, haLeft, 'Advanced Shader Demo - %s', [GetEffectName()]);

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_WHITE, haLeft, '%d fps', [LWindow.GetFrameRate()]);

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_LIGHTGREEN, haLeft, '1-4: Select Effect');

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_LIGHTGREEN, haLeft, 'SPACE: Auto-switch (%s)',
                   [Tg2dMath.IfThen(LAutoSwitch, 'ON', 'OFF')]);

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_LIGHTGREEN, haLeft, 'R: Next zoom target');

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_LIGHTGREEN, haLeft, 'ESC: Exit');

    LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12),
                   G2D_CYAN, haLeft, 'Mouse: Interactive Control');

    // Effect-specific info
    case LCurrentEffect of
      0: begin
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(11),
                      G2D_ORANGE, haLeft, 'Zoom: %.0f  Iterations: %d',
                      [LZoomLevel, LMaxIterations]);

        // Show current zoom target
        case LCurrentZoomPoint of
          0: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Spiral (%.6f, %.6f)', [LCenterX, LCenterY]);
          1: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Lightning (%.6f, %.6f)', [LCenterX, LCenterY]);
          2: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Tendril (%.6f, %.6f)', [LCenterX, LCenterY]);
          3: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Seahorse Valley (%.6f, %.6f)', [LCenterX, LCenterY]);
          4: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Elephant Valley (%.6f, %.6f)', [LCenterX, LCenterY]);
          5: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Twisted Branches (%.6f, %.6f)', [LCenterX, LCenterY]);
          6: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(10),
                           G2D_CYAN, haLeft, 'Target: Mini Mandelbrot (%.6f, %.6f)', [LCenterX, LCenterY]);
        end;
      end;
      1: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(11),
                        G2D_ORANGE, haLeft, 'Speed: %.1f  Complexity: %.1f',
                        [LPlasmaSpeed, LPlasmaComplexity]);
      2: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(11),
                        G2D_ORANGE, haLeft, 'Camera Distance: %.1f',
                        [LCameraDistance]);
      3: LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(11),
                        G2D_ORANGE, haLeft, 'Intensity: %.1f',
                        [LFireIntensity]);
    end;
  end;

begin
  // Initialize window
  LWindow := Tg2dWindow.Init('Advanced Shader Demo', WINDOW_WIDTH, WINDOW_HEIGHT,
                             0, True, True);
  if not Assigned(LWindow) then
    Exit;

  // Initialize font
  LFont := Tg2dFont.Init(LWindow);
  if not Assigned(LFont) then
  begin
    LWindow.Free();
    Exit;
  end;

  // Create base texture
  CreateBaseTexture();

  // Initialize shaders
  if not InitializeShaders() then
  begin
    LBaseTexture.Free();
    LFont.Free();
    LWindow.Free();
    Exit;
  end;

  // Initialize parameters
  LCurrentEffect := 0;
  LCurrentShader := LShaderMandelbrot;
  LTime := 0.0;
  LEffectTimer := 0.0;
  LAutoSwitch := True;
  LZoomLevel := 0.5; // Start zoomed out
  LCurrentZoomPoint := 0;
  LCenterX := -0.7435669; // First interesting point
  LCenterY := 0.1314023;
  LMaxIterations := 128;
  LColorShift := 0.0;
  LPlasmaSpeed := 1.0;
  LPlasmaComplexity := 8.0;
  LCameraDistance := 4.0;
  LFireIntensity := 1.2;
  LHudPos := Tg2dVec.Create(0, 0);

  try
    // Main loop
    while not LWindow.ShouldClose() do
    begin
      LWindow.StartFrame();

      if LWindow.IsReady() then
      begin
        LDeltaTime := LWindow.GetDeltaTime();

        // Handle input
        if LWindow.GetKey(GLFW_KEY_ESCAPE, isWasPressed) then
          LWindow.SetShouldClose(True);

        if LWindow.GetKey(GLFW_KEY_F11, isWasPressed) then
          LWindow.ToggleFullscreen();

        HandleInput();
        UpdateParameters();

        // Render
        LWindow.StartDrawing();
          LWindow.Clear(G2D_BLACK);

          // Enable shader and draw texture with shader effect
          LCurrentShader.Enable(True);
          SetShaderUniforms();
          LBaseTexture.Draw();
          LCurrentShader.Enable(False);

          // Draw HUD on top
          RenderHUD();

        LWindow.EndDrawing();
      end;

      LWindow.EndFrame();
    end;

  finally
    CleanupShaders();
    LBaseTexture.Free();
    LFont.Free();
    LWindow.Free();
  end;
end;

end.

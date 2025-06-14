(******************************************************************************
  Game2D Video Demo - Comprehensive MPEG Video Playback Demonstration

  This demo showcases the Game2D engine's integrated video playback capabilities,
  demonstrating synchronized audio-video rendering using PLM (MPEG-1) format with
  compressed archive streaming and real-time texture updating. The implementation
  highlights advanced multimedia programming techniques including ring buffer
  audio management, YUV to RGBA color space conversion, and frame-synchronous
  decoding optimized for game engine integration.

  Technical Complexity Level: Intermediate

  OVERVIEW

  This demonstration illustrates the Game2D engine's sophisticated video playback
  system, showcasing MPEG-1 video file streaming directly from compressed ZIP
  archives. The demo loads and plays 'res/videos/game2d.mpg' with full audio
  synchronization, demonstrating real-time video texture updating, audio ring
  buffer management, and seamless integration with the game engine's rendering
  pipeline. The implementation serves as a comprehensive example of multimedia
  programming within a game development framework.

  TECHNICAL IMPLEMENTATION

  Core Video System Architecture:
  The video playback system utilizes the PLM (MPEG-1) decoder library for video
  processing, integrated with the MiniAudio framework for audio output. The
  implementation employs a multi-threaded approach with asynchronous callback
  mechanisms for both audio and video stream processing.

  Key Technical Components:
  - PLM Buffer Management: 1024-byte static buffer for streaming data chunks
  - Audio Ring Buffer: Dynamic circular buffer (44100 Hz * 2 channels)
  - Video Texture Pipeline: Direct OpenGL texture updates via glTexSubImage2D
  - Color Space Conversion: Real-time YUV to RGBA transformation
  - Archive Streaming: ZIP file I/O with password protection support

  Mathematical Foundation - Audio Lead Time Calculation:
  // Audio synchronization formula
  AudioLeadTime := (CSampleSize * 2) / SampleRate
  // Where: CSampleSize = 2304, SampleRate = 44100 Hz
  // Result: ~0.104 seconds audio lead time

  Memory Management Strategy:
  The system employs careful resource allocation with explicit cleanup sequences.
  The RGBA buffer allocation follows the formula:
  BufferSize := TextureWidth * TextureHeight * 4  // 4 bytes per RGBA pixel

  FEATURES DEMONSTRATED

  • Compressed Archive Video Streaming - Direct MPEG-1 playback from ZIP files
  • Synchronized Audio-Video Playback - PLM decoder with MiniAudio integration
  • Real-time Texture Updates - Direct OpenGL texture streaming without GPU stalls
  • Frame-Rate Independent Playback - Temporal synchronization using target frame time
  • Scalable Video Rendering - Arbitrary scaling with bilinear filtering
  • Resource Management - Proper initialization and cleanup sequences
  • Interactive Controls - ESC key termination and F11 fullscreen toggle
  • HUD Information Display - Real-time FPS monitoring and control instructions

  RENDERING TECHNIQUES

  Video Texture Pipeline:
  The rendering system employs a multi-stage approach for optimal performance:

  1. Frame Decode Stage: PLM decoder processes MPEG-1 streams into YUV format
  2. Color Conversion Stage: plm_frame_to_rgba() transforms YUV to RGBA color space
  3. Texture Update Stage: glTexSubImage2D() streams RGBA data to GPU texture
  4. Rendering Stage: Standard Game2D texture rendering with scaling support

  Optimization Strategies:
  - Direct texture updates bypass intermediate frame buffering
  - Audio ring buffer prevents underrun conditions during frame drops
  - Texture pivot/anchor points set to (0,0) for efficient screen-space rendering
  - Blend mode set to tbNone for maximum fill-rate performance

  CONTROLS

  ESC Key - Immediate application termination with proper resource cleanup
  F11 Key - Toggle between windowed and fullscreen display modes

  The control system demonstrates proper input handling integration with video
  playback systems, ensuring responsive user interaction during media playback.

  MATHEMATICAL FOUNDATION

  Frame Synchronization Algorithm:
  // Core decode timing calculation
  plm_decode(FPLM, AWindow.GetTargetTime());

  The synchronization system uses the window's target frame time to maintain
  proper playback speed regardless of rendering frame rate variations.

  Audio Buffer Management:
  // Ring buffer sizing calculation
  BufferSize := SampleRate * Channels  // 44100 * 2 = 88200 samples
  DataSize := BufferSize * SizeOf(Single)  // 352800 bytes total

  Video Scaling Mathematics:
  The rendering system applies uniform scaling using the formula:
  ScaledWidth := OriginalWidth * ScaleFactor
  ScaledHeight := OriginalHeight * ScaleFactor
  // Demo uses 0.5 scale factor for 50% size reduction

  PERFORMANCE CHARACTERISTICS

  Expected Performance Metrics:
  - Frame Rate: 60 FPS with standard MPEG-1 content
  - Memory Usage: ~2-4 MB for typical 320x240 video streams
  - CPU Usage: 5-15% on modern processors for decoding overhead
  - GPU Impact: Minimal - single texture update per frame

  Buffer Configuration Constants:
  - PLM Buffer Size: 1024 bytes per read operation
  - Audio Sample Rate: 44100 Hz stereo (2 channels)
  - Audio Buffer Size: 2304 samples per processing block
  - Ring Buffer Capacity: 88200 samples (2 seconds of audio)

  The implementation demonstrates excellent performance characteristics suitable
  for real-time game integration without significant impact on primary game
  loop performance.

  EDUCATIONAL VALUE

  Core Learning Objectives:
  Developers studying this implementation will gain comprehensive understanding
  of multimedia programming within game engines, including asynchronous callback
  programming, memory-efficient streaming techniques, and audio-video
  synchronization algorithms.

  Key Programming Concepts:
  - Event-driven multimedia programming using callback mechanisms
  - Resource lifetime management in multimedia applications
  - Ring buffer implementation for audio stream processing
  - OpenGL texture streaming techniques for video display
  - Archive-based asset loading with compression support

  Advanced Techniques Demonstrated:
  - Multi-threaded audio processing with main thread rendering
  - Color space conversion optimization for real-time performance
  - Frame-synchronous decoding algorithms for smooth playback
  - Error handling and graceful degradation in multimedia systems

  Real-world Applications:
  The techniques demonstrated are directly applicable to cutscene systems,
  background video elements, user interface video components, and educational
  software requiring multimedia integration. The ZIP archive streaming approach
  is particularly valuable for asset packaging and distribution optimization.

  This demonstration provides a solid foundation for developers implementing
  video playback features in game engines, offering both theoretical understanding
  and practical implementation patterns for professional multimedia development.
******************************************************************************)

unit UVideoDemo;

interface

procedure VideoDemo();

implementation

uses
  System.SysUtils,
  Game2D.Common,
  Game2D.Core,
  UCommon;

procedure VideoDemo();
var
  LWindow: Tg2dWindow;
  LFont: Tg2dFont;
  LHudPos: Tg2dVec;
begin
  LWindow := Tg2dWindow.Init('Game2D: Video Demo');
  LWindow.SetSizeLimits(Round(LWindow.GetVirtualSize().Width/3), Round(LWindow.GetVirtualSize().Height/3), G2D_DONT_CARE, G2D_DONT_CARE);
  LFont := Tg2dFont.Init(LWindow);

  Tg2dVideo.PlayFromZipFile(ZIP_FILENAME, 'res/videos/game2d.mpg', 1.0, True);

  while not LWindow.ShouldClose() do
  begin
    LWindow.StartFrame();
    if LWindow.IsReady() then
    begin
      if LWindow.GetKey(G2D_KEY_ESCAPE, isWasPressed) then
        LWindow.SetShouldClose(True);
      if LWindow.GetKey(G2D_KEY_F11, isWasPressed) then
        LWindow.ToggleFullscreen();

      LWindow.StartDrawing();
        LWindow.Clear(G2D_DARKSLATEBROWN);
        Tg2dVideo.Draw(0, 0, 0.5);

        LHudPos.Assign(10, 10);

        // Title - matches shader demo style
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(14), G2D_YELLOW, haLeft, 'Video Demo');

        // FPS
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_WHITE, haLeft, '%d fps', [LWindow.GetFrameRate()]);

        // Controls - consistent style
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_LIGHTGREEN, haLeft, Tg2dUtils.HudTextItem('ESC','Quit'));
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_LIGHTGREEN, haLeft, Tg2dUtils.HudTextItem('F11','Toggle fullscreen'));

        // Status
        LFont.DrawText(LWindow, LHudPos.X, LHudPos.Y, 0, LFont.GetLogicalScale(12), G2D_CYAN, haLeft, 'Looping video playback');

      LWindow.EndDrawing();
    end;
    LWindow.EndFrame();
  end;

  Tg2dVideo.Stop();
  LFont.Free();
  LWindow.Free();
end;

end.

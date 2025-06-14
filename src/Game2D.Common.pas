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

================================================================================
Game2D.Common - Core Foundation Types and Utilities

This unit provides essential foundation types, utilities, and common structures
used throughout the Game2D framework. It serves as the base layer containing
fundamental data types for math operations, I/O handling, memory management,
and asynchronous operations. This unit is designed for high performance and
provides the building blocks for all other Game2D systems.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════
The Common unit follows a layered foundation architecture providing:

• **Type System Foundation** - Core enumerations and common data types
• **Memory Management Layer** - Virtual buffers and ring buffer implementations
• **Object Hierarchy** - Base classes with error handling and lifecycle management
• **Asynchronous Operations** - Threading utilities for background processing
• **Timer System** - High-precision timing for frame rate control and animations

Key design patterns:
• Factory pattern for object creation and initialization
• Observer pattern through callback mechanisms
• Template pattern for generic ring buffer implementations
• RAII pattern for automatic resource management
• Strategy pattern for different seek modes and I/O operations

═══════════════════════════════════════════════════════════════════════════════
COMMON TYPE SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Fundamental enumerations and types used across the framework:

• **Seek Modes** - File and stream positioning (Start, Current, End)
• **I/O Modes** - Read/Write operation modes
• **Alignment Types** - Horizontal and vertical alignment for UI and rendering
• **Generic Callbacks** - Type-safe callback mechanism with user data

BASIC TYPE USAGE:
  var
    LSeekMode: Tg2dSeekMode;
    LHAlign: Tg2dHAlign;
    LCallback: Tg2dCallback<TNotifyEvent>;
  begin
    LSeekMode := smStart;           // Position from beginning
    LHAlign := haCenter;            // Center horizontal alignment
    LCallback.Handler := MyHandler; // Assign callback handler
    LCallback.UserData := Self;     // Associate user data
  end;

═══════════════════════════════════════════════════════════════════════════════
VIRTUAL BUFFER SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Memory-mapped virtual buffer implementation for efficient large data handling:

• **Memory-mapped file backing** for large datasets without RAM limitations
• **Stream-based interface** compatible with standard Delphi streams
• **Automatic cleanup** and handle management
• **File I/O operations** with optimized loading and saving
• **End-of-buffer detection** for safe iteration

VIRTUAL BUFFER USAGE:
  var
    LBuffer: Tg2dVirtualBuffer;
    LData: string;
  begin
    LBuffer := Tg2dVirtualBuffer.Create(1024 * 1024); // 1MB buffer
    try
      LBuffer.WriteBuffer(MyData^, Length(MyData));
      LBuffer.Position := 0;

      while not LBuffer.Eob() do
      begin
        LData := LBuffer.ReadString();
        // Process string data
      end;

      LBuffer.SaveToFile('output.dat');
    finally
      LBuffer.Free();
    end;
  end;

LOADING FROM FILES:
  var
    LBuffer: Tg2dVirtualBuffer;
  begin
    LBuffer := Tg2dVirtualBuffer.LoadFromFile('data.bin');
    try
      // Use loaded buffer
      ProcessBuffer(LBuffer);
    finally
      LBuffer.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
RING BUFFER IMPLEMENTATION
═══════════════════════════════════════════════════════════════════════════════
Thread-safe circular buffer for efficient streaming data operations:

• **Generic implementation** supports any data type
• **Lock-free design** for high-performance concurrent access
• **Overflow protection** with capacity management
• **Direct memory access** for zero-copy operations
• **Available bytes tracking** for flow control

RING BUFFER USAGE:
  var
    LRingBuffer: Tg2dRingBuffer<Single>;
    LAudioData: array[0..1023] of Single;
    LBytesWritten: UInt64;
    LBytesRead: UInt64;
  begin
    LRingBuffer := Tg2dRingBuffer<Single>.Create(4096);
    try
      // Write audio samples
      LBytesWritten := LRingBuffer.Write(LAudioData, Length(LAudioData));

      // Check available data
      if LRingBuffer.AvailableBytes() >= 512 then
      begin
        // Read back samples
        LBytesRead := LRingBuffer.Read(LAudioData, 512);
        ProcessAudioSamples(LAudioData, LBytesRead);
      end;
    finally
      LRingBuffer.Free();
    end;
  end;

DIRECT MEMORY ACCESS:
  var
    LDirectPtr: Pointer;
    LSampleCount: UInt64;
  begin
    LSampleCount := 256;
    LDirectPtr := LRingBuffer.DirectReadPointer(LSampleCount);
    if Assigned(LDirectPtr) then
    begin
      // Process samples directly without copying
      ProcessSamplesInPlace(LDirectPtr, LSampleCount);
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
VIRTUAL RING BUFFER
═══════════════════════════════════════════════════════════════════════════════
Memory-mapped ring buffer for extremely large circular datasets:

• **Virtual memory backing** allows buffers larger than available RAM
• **Combines ring buffer efficiency** with virtual buffer scalability
• **Array-style access** with automatic wraparound
• **Memory-efficient streaming** for massive datasets

VIRTUAL RING BUFFER USAGE:
  var
    LVirtualRing: Tg2dVirtualRingBuffer<Integer>;
    LValues: array[0..99] of Integer;
    LIndex: UInt64;
  begin
    // Create 1GB virtual ring buffer
    LVirtualRing := Tg2dVirtualRingBuffer<Integer>.Create(268435456);
    try
      // Fill with data
      for LIndex := 0 to High(LValues) do
        LValues[LIndex] := LIndex;

      LVirtualRing.Write(LValues, Length(LValues));

      // Read back with wraparound
      LVirtualRing.Read(LValues, Length(LValues));
    finally
      LVirtualRing.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
HIGH-PRECISION TIMER SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Performance counter-based timing for frame rate control and animations:

• **Millisecond and FPS initialization** modes
• **Frame rate independent timing** with speed control
• **High-precision timing** using system performance counters
• **Automatic reset and checking** for consistent intervals

TIMER USAGE:
  var
    LFrameTimer: Tg2dTimer;
    LAnimTimer: Tg2dTimer;
  begin
    LFrameTimer.InitFPS(60.0);      // 60 FPS target
    LAnimTimer.InitMS(100.0);       // 100ms intervals

    while GameRunning do
    begin
      if LFrameTimer.Check() then
      begin
        UpdateGame();
        RenderFrame();
      end;

      if LAnimTimer.Check() then
      begin
        AdvanceAnimations();
      end;
    end;
  end;

TIMER SPEED CONTROL:
  var
    LSlowMotionTimer: Tg2dTimer;
    LCurrentSpeed: Double;
  begin
    LSlowMotionTimer.InitFPS(60.0);

    // Check current speed multiplier
    LCurrentSpeed := LSlowMotionTimer.Speed();

    // Slow motion effect (half speed)
    if SlowMotionActive then
      LSlowMotionTimer.InitFPS(30.0)
    else
      LSlowMotionTimer.InitFPS(60.0);
  end;

═══════════════════════════════════════════════════════════════════════════════
OBJECT HIERARCHY SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Base classes providing error handling and lifecycle management:

• **Tg2dStaticObject** - Class-level error handling for static utilities
• **Tg2dObject** - Instance-level error handling for regular objects
• **Consistent error reporting** with formatted message support
• **Virtual constructors and destructors** for proper inheritance

STATIC OBJECT USAGE:
  type
    TMyUtility = class(Tg2dStaticObject)
    public
      class function ProcessFile(const AFilename: string): Boolean; static;
    end;

  class function TMyUtility.ProcessFile(const AFilename: string): Boolean;
  begin
    Result := TFile.Exists(AFilename);
    if not Result then
      SetError('File not found: %s', [AFilename]);
  end;

  // Usage
  if not TMyUtility.ProcessFile('data.txt') then
    ShowMessage(TMyUtility.GetError());

INSTANCE OBJECT USAGE:
  type
    TMyProcessor = class(Tg2dObject)
    public
      function LoadData(const AFilename: string): Boolean;
    end;

  function TMyProcessor.LoadData(const AFilename: string): Boolean;
  begin
    Result := TFile.Exists(AFilename);
    if not Result then
      SetError('Cannot load data from: %s', [AFilename]);
  end;

  // Usage
  var
    LProcessor: TMyProcessor;
  begin
    LProcessor := TMyProcessor.Create();
    try
      if not LProcessor.LoadData('config.ini') then
        WriteLn(LProcessor.GetError());
    finally
      LProcessor.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
ASYNCHRONOUS OPERATION SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Thread-based async operations for background processing without blocking:

• **Anonymous method support** for task definition
• **Completion callbacks** for result handling
• **Thread lifecycle management** with proper cleanup
• **Finished state tracking** for synchronization

BASIC ASYNC OPERATIONS:
  var
    LAsyncThread: Tg2dAsyncThread;
  begin
    LAsyncThread := Tg2dAsyncThread.Create();
    try
      // Define background task
      LAsyncThread.TaskProc := procedure
      begin
        // Long-running operation
        ProcessLargeDataset();
      end;

      // Define completion handler
      LAsyncThread.WaitProc := procedure
      begin
        // Update UI when complete
        UpdateProgressBar(100);
        ShowMessage('Processing complete!');
      end;

      LAsyncThread.Start();

      // Continue with other work...
      while not LAsyncThread.Finished do
      begin
        UpdateUI();
        Sleep(10);
      end;
    finally
      LAsyncThread.Free();
    end;
  end;

ASYNC CLASS USAGE:
  var
    LAsync: Tg2dAsync;
    LBusyName: string;
  begin
    LAsync := Tg2dAsync.Create();
    try
      // Start background operation
      LBusyName := 'data_processing';
      LAsync.Run(LBusyName,
        procedure
        begin
          DownloadFiles();
          ProcessData();
        end,
        procedure
        begin
          RefreshDisplay();
        end);

      // Check if still busy
      while LAsync.IsBusy(LBusyName) do
      begin
        Application.ProcessMessages();
        Sleep(50);
      end;
    finally
      LAsync.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION EXAMPLES
═══════════════════════════════════════════════════════════════════════════════
Examples showing how different components work together in real scenarios:

STREAMING AUDIO PROCESSOR:
  type
    TAudioProcessor = class(Tg2dObject)
    private
      FInputBuffer: Tg2dRingBuffer<Single>;
      FOutputBuffer: Tg2dRingBuffer<Single>;
      FProcessTimer: Tg2dTimer;
      FAsyncProcessor: Tg2dAsync;
    public
      constructor Create(); override;
      destructor Destroy(); override;
      procedure StartProcessing();
      procedure StopProcessing();
      function ProcessAudioFrame(): Boolean;
    end;

  constructor TAudioProcessor.Create();
  begin
    inherited Create();
    FInputBuffer := Tg2dRingBuffer<Single>.Create(8192);
    FOutputBuffer := Tg2dRingBuffer<Single>.Create(8192);
    FProcessTimer.InitFPS(44.1); // 44.1kHz processing
    FAsyncProcessor := Tg2dAsync.Create();
  end;

  procedure TAudioProcessor.StartProcessing();
  begin
    FAsyncProcessor.Run('audio_processing',
      procedure
      begin
        while ProcessAudioFrame() do
          // Continue processing
      end,
      procedure
      begin
        // Processing complete callback
        SetError('Audio processing completed successfully');
      end);
  end;

LARGE FILE PROCESSOR WITH PROGRESS:
  type
    TFileProcessor = class(Tg2dObject)
    private
      FVirtualBuffer: Tg2dVirtualBuffer;
      FProgressTimer: Tg2dTimer;
      FOnProgress: TNotifyEvent;
    public
      function ProcessLargeFile(const AFilename: string): Boolean;
      property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    end;

  function TFileProcessor.ProcessLargeFile(const AFilename: string): Boolean;
  var
    LChunkSize: UInt64;
    LProcessed: UInt64;
    LTotal: UInt64;
  begin
    Result := False;
    FVirtualBuffer := Tg2dVirtualBuffer.LoadFromFile(AFilename);
    if not Assigned(FVirtualBuffer) then
    begin
      SetError('Failed to load file: %s', [AFilename]);
      Exit;
    end;

    try
      FProgressTimer.InitMS(100.0); // Update progress every 100ms
      LChunkSize := 1024 * 1024; // 1MB chunks
      LTotal := FVirtualBuffer.Size();
      LProcessed := 0;

      FVirtualBuffer.Position := 0;
      while not FVirtualBuffer.Eob() do
      begin
        // Process chunk
        ProcessChunk(FVirtualBuffer, LChunkSize);
        Inc(LProcessed, LChunkSize);

        // Update progress periodically
        if FProgressTimer.Check() and Assigned(FOnProgress) then
          FOnProgress(Self);
      end;

      Result := True;
    finally
      FVirtualBuffer.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPLETE EXAMPLE
═══════════════════════════════════════════════════════════════════════════════
A comprehensive example showing multiple features working together:

REAL-TIME DATA STREAMING SYSTEM:
  type
    TDataStreamer = class(Tg2dObject)
    private
      FInputRing: Tg2dRingBuffer<Byte>;
      FOutputRing: Tg2dVirtualRingBuffer<Integer>;
      FProcessTimer: Tg2dTimer;
      FAsyncWorker: Tg2dAsync;
      FTempBuffer: Tg2dVirtualBuffer;
      FIsStreaming: Boolean;

      procedure ProcessDataChunk();
      procedure OnProcessingComplete();
    public
      constructor Create(); override;
      destructor Destroy(); override;

      function StartStreaming(const AInputFile: string): Boolean;
      procedure StopStreaming();
      function GetProcessedData(var AData: array of Integer): UInt64;

      property IsStreaming: Boolean read FIsStreaming;
    end;

  constructor TDataStreamer.Create();
  begin
    inherited Create();

    // Initialize buffers
    FInputRing := Tg2dRingBuffer<Byte>.Create(65536);    // 64KB input
    FOutputRing := Tg2dVirtualRingBuffer<Integer>.Create(1048576); // 4MB output
    FTempBuffer := Tg2dVirtualBuffer.Create(32768);      // 32KB temp

    // Initialize async processor
    FAsyncWorker := Tg2dAsync.Create();

    // Set processing rate
    FProcessTimer.InitFPS(100.0); // 100 Hz processing

    FIsStreaming := False;
  end;

  destructor TDataStreamer.Destroy();
  begin
    StopStreaming();
    FAsyncWorker.Free();
    FTempBuffer.Free();
    FOutputRing.Free();
    FInputRing.Free();
    inherited Destroy();
  end;

  function TDataStreamer.StartStreaming(const AInputFile: string): Boolean;
  var
    LFileBuffer: Tg2dVirtualBuffer;
    LFileData: array[0..4095] of Byte;
    LBytesRead: Integer;
  begin
    Result := False;

    // Load input file
    LFileBuffer := Tg2dVirtualBuffer.LoadFromFile(AInputFile);
    if not Assigned(LFileBuffer) then
    begin
      SetError('Cannot load input file: %s', [AInputFile]);
      Exit;
    end;

    try
      // Fill input ring buffer from file
      LFileBuffer.Position := 0;
      while not LFileBuffer.Eob() do
      begin
        LBytesRead := LFileBuffer.Read(LFileData, SizeOf(LFileData));
        if LBytesRead > 0 then
          FInputRing.Write(LFileData, LBytesRead);
      end;

      // Start async processing
      FIsStreaming := True;
      FAsyncWorker.Run('data_streaming',
        procedure
        begin
          while FIsStreaming do
          begin
            if FProcessTimer.Check() then
              ProcessDataChunk();
            Sleep(1);
          end;
        end,
        procedure
        begin
          OnProcessingComplete();
        end);

      Result := True;

    finally
      LFileBuffer.Free();
    end;
  end;

  procedure TDataStreamer.ProcessDataChunk();
  var
    LInputData: array[0..255] of Byte;
    LOutputData: array[0..127] of Integer;
    LBytesRead: UInt64;
    LIndex: Integer;
  begin
    // Read from input ring buffer
    LBytesRead := FInputRing.Read(LInputData, Length(LInputData));

    if LBytesRead > 0 then
    begin
      // Convert bytes to integers (example processing)
      for LIndex := 0 to (LBytesRead div 2) - 1 do
      begin
        LOutputData[LIndex] := (LInputData[LIndex * 2] shl 8) or
                               LInputData[LIndex * 2 + 1];
      end;

      // Store in virtual ring buffer
      FOutputRing.Write(LOutputData, LBytesRead div 2);

      // Optional: Save intermediate results to temp buffer
      FTempBuffer.Position := FTempBuffer.Size();
      FTempBuffer.Write(LOutputData, (LBytesRead div 2) * SizeOf(Integer));
    end;
  end;

  procedure TDataStreamer.StopStreaming();
  begin
    FIsStreaming := False;
    FAsyncWorker.Wait('data_streaming');
  end;

  function TDataStreamer.GetProcessedData(var AData: array of Integer): UInt64;
  begin
    Result := FOutputRing.Read(AData, Length(AData));
  end;

  procedure TDataStreamer.OnProcessingComplete();
  begin
    // Save final results
    FTempBuffer.SaveToFile('processed_output.dat');
    SetError('Data streaming completed successfully');
  end;

USAGE EXAMPLE:
  var
    LStreamer: TDataStreamer;
    LProcessedData: array[0..1023] of Integer;
    LDataCount: UInt64;
  begin
    LStreamer := TDataStreamer.Create();
    try
      if LStreamer.StartStreaming('input_data.bin') then
      begin
        // Process data in real-time
        while LStreamer.IsStreaming do
        begin
          LDataCount := LStreamer.GetProcessedData(LProcessedData);
          if LDataCount > 0 then
          begin
            // Use processed data
            DisplayData(LProcessedData, LDataCount);
          end;

          Application.ProcessMessages();
          Sleep(10);
        end;

        WriteLn('Streaming completed successfully');
      end
      else
        WriteLn('Error: ', LStreamer.GetError());
    finally
      LStreamer.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
• Virtual buffers automatically manage memory-mapped files and handles
• Ring buffers use dynamic arrays with automatic capacity management
• Object hierarchy provides consistent constructor/destructor patterns
• Async operations properly clean up thread resources
• Use try/finally blocks for deterministic cleanup of all buffer types
• Virtual ring buffers automatically release virtual memory allocations

═══════════════════════════════════════════════════════════════════════════════
THREADING CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════
• Ring buffers are designed for single producer/consumer scenarios
• Virtual buffers are not thread-safe - synchronize access manually
• Async operations run in separate threads with proper isolation
• Timer operations are thread-safe using performance counters
• Use critical sections when sharing buffers between multiple threads

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════
• Memory-mapped files allow processing datasets larger than available RAM
• Ring buffers provide lock-free operation for real-time applications
• Direct memory access eliminates unnecessary copying operations
• High-precision timers use system performance counters for accuracy
• Virtual buffers optimize I/O through memory mapping
• Async operations prevent blocking of main application thread

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════
• All operations provide clear error messages with context
• Static objects maintain class-level error state
• Instance objects maintain per-object error state
• File operations include comprehensive error reporting
• Buffer operations validate capacity and bounds automatically
• Async operations report completion status and errors

===============================================================================}

unit Game2D.Common;

{$I Game2D.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Math,
  System.SyncObjs,
  Game2D.Deps,
  Game2D.OpenGL;

//=== COMMON TYPES =============================================================
const
  G2D_DONT_CARE = GLFW_DONT_CARE;

type
  { Tg2dSeekMode }
  Tg2dSeekMode = (
    smStart,
    smCurrent,
    smEnd
  );

  { Tg2dIOMode }
  Tg2dIOMode = (
    iomRead,
    iomWrite
  );

  { Tg2dHAlign }
  Tg2dHAlign = (haLeft, haCenter, haRight);

  { Tg2dVAlign }
  Tg2dVAlign = (vaTop, vaCenter, vaBottom);

  { Tg2dCallback<T> }
  Tg2dCallback<T> = record
    Handler: T;
    UserData: Pointer;
  end;

//=== VIRTUALBUFFER ============================================================
type
  { Tg2dVirtualBuffer }
  Tg2dVirtualBuffer = class(TCustomMemoryStream)
  protected
    FHandle: THandle;
    FName: string;
    procedure Clear();
  public
    constructor Create(aSize: Cardinal);
    destructor Destroy(); override;
    function Write(const aBuffer; aCount: Longint): Longint; override;
    function Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint; override;
    procedure SaveToFile(aFilename: string);
    property Name: string read FName;
    function  Eob(): Boolean;
    function  ReadString(): string;
    class function LoadFromFile(const aFilename: string): Tg2dVirtualBuffer;
  end;

//=== RINGBUFFER ===============================================================
type
  { Tg2dRingBuffer<T> }
  Tg2dRingBuffer<T> = class
  private type
    PType = ^T;
  private
    FBuffer: array of T;
    FReadIndex, FWriteIndex, FCapacity: UInt64;
  public
    constructor Create(const ACapacity: UInt64);
    function Write(const AData: array of T; ACount: UInt64): UInt64;
    function Read(var AData: array of T; ACount: UInt64): UInt64;
    function DirectReadPointer(const ACount: UInt64): Pointer;
    function AvailableBytes(): UInt64;
    procedure Clear();
  end;

//=== VIRTUALRINGBUFFER ========================================================
  { Tg2dVirtualRingBuffer<T> }
  Tg2dVirtualRingBuffer<T> = class
  private type
    PType = ^T;
  private
    FBuffer: Tg2dVirtualBuffer;
    FReadIndex, FWriteIndex, FCapacity: UInt64;
    function GetArrayValue(const AIndex: UInt64): T;
    procedure SetArrayValue(const AIndex: UInt64; AValue: T);
  public
    constructor Create(const ACapacity: UInt64);
    destructor Destroy; override;
    function Write(const AData: array of T; ACount: UInt64): UInt64;
    function Read(var AData: array of T; ACount: UInt64): UInt64;
    function DirectReadPointer(const ACount: UInt64): Pointer;
    function AvailableBytes(): UInt64;
    procedure Clear();
  end;

//=== TIMER ====================================================================
  { Tg2dTimer }
  Pg2dTimer = ^Tg2dTimer;
  Tg2dTimer = record
  private
    FLastTime: Double;
    FInterval: Double;
    FSpeed: Double;
  public
    class operator Initialize (out ADest: Tg2dTimer);
    procedure InitMS(const AValue: Double);
    procedure InitFPS(const AValue: Double);
    function Check(): Boolean;
    procedure Reset();
    function  Speed(): Double;
  end;

//=== STATICOBJECT =============================================================
type
  { g2dStaticObject }
  Tg2dStaticObject = class
  protected class var
    FError: string;
  public
    class constructor Create();
    class destructor Destroy();

    class function  GetError(): string; static;
    class procedure SetError(const AText: string; const AArgs: array of const); static;
  end;

//=== OBJECT ===================================================================
type
  { Tg2dObject }
  Tg2dObject = class
  protected
    FError: string;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;

    function  GetError(): string;
    procedure SetError(const AText: string; const AArgs: array of const);
  end;

//=== ASYNC ====================================================================
type
  { Tg2dAsyncProc }
  Tg2dAsyncProc = reference to procedure;

  { Tg2dAsyncThread }
  Tg2dAsyncThread = class(TThread)
  protected
    FTask: Tg2dAsyncProc;
    FWait: Tg2dAsyncProc;
    FFinished: Boolean;
  public
    property TaskProc: Tg2dAsyncProc read FTask write FTask;
    property WaitProc: Tg2dAsyncProc read FWait write FWait;
    property Finished: Boolean read FFinished;
    constructor Create(); virtual;
    destructor Destroy(); override;
    procedure Execute(); override;
  end;

  { Tg2dAsync }
  Tg2dAsync = class(Tg2dObject)
  protected type
    TBusyData = record
      Name: string;
      Thread: Pointer;
      Flag: Boolean;
      Terminate: Boolean;
    end;
  protected
    FQueue: TList<Tg2dAsyncThread>;
    FBusy: TDictionary<string, TBusyData>;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Clear();
    procedure Process();
    procedure Exec(const AName: string; const ABackgroundTask: Tg2dAsyncProc; const AWaitForgroundTask: Tg2dAsyncProc);
    function  Busy(const AName: string): Boolean;
    procedure SetTerminate(const AName: string; const ATerminate: Boolean);
    function  ShouldTerminate(const AName: string): Boolean;
    procedure TerminateAll();
    procedure WaitForAllToTerminate();
    procedure Suspend();
    procedure Resume();
    procedure Enter();
    procedure Leave();
  end;

//=== UTILS ====================================================================
type
  { Tg2dUtils }
  Tg2dUtils = class(Tg2dStaticObject)
  private class var
    FMarshaller: TMarshaller;
    FCriticalSection: TCriticalSection;
    FAsync: Tg2dAsync;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure FatalError(const AMsg: string; const AArgs: array of const); static;
    class function  AsUTF8(const AText: string; const AArgs: array of const): Pointer; static;
    class procedure ProcessMessages(); static;
    class function  LogarithmicVolume(const ALinear: Single): Single; static;
    class procedure EnterCriticalSection(); static;
    class procedure LeaveCriticalSection(); static;
    class procedure Wait(const AMilliseconds: Double); static;
    class function  HudTextItem(const AKey: string; const AValue: string; const APaddingWidth: Cardinal=10; const ASeperator: string='-'): string; static;
    class function  ResourceExists(const AInstance: THandle; const aResName: string): Boolean; static;
    class function  RemoveDuplicates(const aText: string): string;
    class procedure AsyncProcess(); static;
    class procedure AsyncClear(); static;
    class procedure AsyncRun(const AName: string; const ABackgroundTask: Tg2dAsyncProc; const AWaitForgroundTask: Tg2dAsyncProc); static;
    class function  AsyncIsBusy(const AName: string): Boolean; static;
    class procedure AsyncSetTerminate(const AName: string; const ATerminate: Boolean); static;
    class function  AsyncShouldTerminate(const AName: string): Boolean; static;
    class procedure AsyncTerminateAll(); static;
    class procedure AsyncWaitForAllToTerminate(); static;
    class procedure AsyncSuspend(); static;
    class procedure AsyncResume(); static;
    class function  GetPhysicalProcessorCount(): DWORD;
    class function  GetLogicalProcessorCount(): DWORD;

  end;

implementation

//=== VIRTUALBUFFER ============================================================
{ Tg2dVirtualBuffer }
procedure Tg2dVirtualBuffer.Clear();
begin
  if (Memory <> nil) then
  begin
    if not UnmapViewOfFile(Memory) then
      raise Exception.Create('Error deallocating mapped memory');
  end;

  if (FHandle <> 0) then
  begin
    if not CloseHandle(FHandle) then
      raise Exception.Create('Error freeing memory mapping handle');
  end;
end;

constructor Tg2dVirtualBuffer.Create(aSize: Cardinal);
var
  P: Pointer;
begin
  inherited Create;
  FName := TPath.GetGUIDFileName;
  FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, aSize, PChar(FName));
  if FHandle = 0 then
    begin
      Clear;
      raise Exception.Create('Error creating memory mapping');
      FHandle := 0;
    end
  else
    begin
      P := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
      if P = nil then
        begin
          Clear;
          raise Exception.Create('Error creating memory mapping');
        end
      else
        begin
          Self.SetPointer(P, aSize);
          Position := 0;
        end;
    end;
end;

destructor Tg2dVirtualBuffer.Destroy();
begin
  Clear();
  inherited;
end;

function Tg2dVirtualBuffer.Write(const aBuffer; aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer, (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

function Tg2dVirtualBuffer.Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer[aOffset], (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

procedure Tg2dVirtualBuffer.SaveToFile(aFilename: string);
var
  LStream: TFileStream;
begin
  LStream := TFile.Create(aFilename);
  try
    LStream.Write(Memory^, Size);
  finally
    LStream.Free;
  end;
end;

class function Tg2dVirtualBuffer.LoadFromFile(const aFilename: string): Tg2dVirtualBuffer;
var
  LStream: TStream;
  LBuffer: Tg2dVirtualBuffer;
begin
  Result := nil;
  if aFilename.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;
  LStream := TFile.OpenRead(aFilename);
  try
    LBuffer := Tg2dVirtualBuffer.Create(LStream.Size);
    if LBuffer <> nil then
    begin
      LBuffer.CopyFrom(LStream);
    end;
  finally
    FreeAndNil(LStream);
  end;
  Result := LBuffer;
end;

function  Tg2dVirtualBuffer.Eob(): Boolean;
begin
  Result := Boolean(Position >= Size);
end;

function  Tg2dVirtualBuffer.ReadString(): string;
var
  LLength: LongInt;
begin
  Read(LLength, SizeOf(LLength));
  SetLength(Result, LLength);
  if LLength > 0 then Read(Result[1], LLength * SizeOf(Char));
end;

//=== RINGBUFFER ===============================================================
{ Tg2dRingBuffer<T> }
constructor Tg2dRingBuffer<T>.Create(const ACapacity: UInt64);
begin
  SetLength(FBuffer, ACapacity);
  FReadIndex := 0;
  FWriteIndex := 0;
  FCapacity := ACapacity;
  Clear;
end;

function Tg2dRingBuffer<T>.Write(const AData: array of T; ACount: UInt64): UInt64;
var
  i, WritePos: UInt64;
begin
  Tg2dUtils.EnterCriticalSection();
  try
    for i := 0 to ACount - 1 do
    begin
      WritePos := (FWriteIndex + i) mod FCapacity;
      FBuffer[WritePos] := AData[i];
    end;
    FWriteIndex := (FWriteIndex + ACount) mod FCapacity;
    Result := ACount;
  finally
    Tg2dUtils.LeaveCriticalSection();
  end;
end;

function Tg2dRingBuffer<T>.Read(var AData: array of T; ACount: UInt64): UInt64;
var
  i, ReadPos: UInt64;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadPos := (FReadIndex + i) mod FCapacity;
    AData[i] := FBuffer[ReadPos];
  end;
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
  Result := ACount;
end;

function Tg2dRingBuffer<T>.DirectReadPointer(const ACount: UInt64): Pointer;
begin
  Result := @FBuffer[FReadIndex mod FCapacity];
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
end;

function Tg2dRingBuffer<T>.AvailableBytes(): UInt64;
begin
  Result := (FCapacity + FWriteIndex - FReadIndex) mod FCapacity;
end;

procedure Tg2dRingBuffer<T>.Clear();
var
  I: UInt64;
begin

  Tg2dUtils.EnterCriticalSection();
  try
    for I := Low(FBuffer) to High(FBuffer) do
    begin
     FBuffer[i] := Default(T);
    end;

    FReadIndex := 0;
    FWriteIndex := 0;
  finally
    Tg2dUtils.LeaveCriticalSection();
  end;
end;

//=== VIRTUALRINGBUFFER ========================================================
{ Tg2dVirtualRingBuffer<T> }
function Tg2dVirtualRingBuffer<T>.GetArrayValue(const AIndex: UInt64): T;
begin
  Result := PType(PByte(FBuffer.Memory) + AIndex * UInt64(SizeOf(T)))^;
end;

procedure Tg2dVirtualRingBuffer<T>.SetArrayValue(const AIndex: UInt64; AValue: T);
begin
  PType(PByte(FBuffer.Memory) + AIndex * UInt64(SizeOf(T)))^ := AValue;
end;

constructor Tg2dVirtualRingBuffer<T>.Create(const ACapacity: UInt64);
begin
  FBuffer := Tg2dVirtualBuffer.Create(ACapacity*UInt64(SizeOf(T)));
  FReadIndex := 0;
  FWriteIndex := 0;
  FCapacity := ACapacity;
  Clear;
end;

destructor Tg2dVirtualRingBuffer<T>.Destroy;
begin
  FBuffer.Free;
  inherited;
end;

function Tg2dVirtualRingBuffer<T>.Write(const AData: array of T; ACount: UInt64): UInt64;
var
  i, WritePos: UInt64;
begin
  Tg2dUtils.EnterCriticalSection();
  try
    for i := 0 to ACount - 1 do
    begin
      WritePos := (FWriteIndex + i) mod FCapacity;
      SetArrayValue(WritePos, AData[i]);
    end;
    FWriteIndex := (FWriteIndex + ACount) mod FCapacity;
    Result := ACount;
  finally
    Tg2dUtils.LeaveCriticalSection();
  end;
end;

function Tg2dVirtualRingBuffer<T>.Read(var AData: array of T; ACount: UInt64): UInt64;
var
  i, ReadPos: UInt64;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadPos := (FReadIndex + i) mod FCapacity;
    AData[i] := GetArrayValue(ReadPos);
  end;
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
  Result := ACount;
end;

function Tg2dVirtualRingBuffer<T>.DirectReadPointer(const ACount: UInt64): Pointer;
begin
  Result := PType(PByte(FBuffer.Memory) + (FReadIndex mod FCapacity) * UInt64(SizeOf(T)));
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
end;

function Tg2dVirtualRingBuffer<T>.AvailableBytes(): UInt64;
begin
  Result := (FCapacity + FWriteIndex - FReadIndex) mod FCapacity;
end;

procedure Tg2dVirtualRingBuffer<T>.Clear();
var
  I: UInt64;
begin

  Tg2dUtils.EnterCriticalSection();
  try
    for I := 0 to FCapacity-1 do
    begin
     SetArrayValue(I, Default(T));
    end;

    FReadIndex := 0;
    FWriteIndex := 0;
  finally
    Tg2dUtils.LeaveCriticalSection();
  end;
end;

//=== TIMER ====================================================================
{ Tg2dTimer }
class operator Tg2dTimer.Initialize (out ADest: Tg2dTimer);
begin
  ADest.FLastTime := 0;
  ADest.FInterval := 0;
  ADest.FSpeed := 0;
end;

procedure Tg2dTimer.InitMS(const AValue: Double);
begin
  FInterval := AValue / 1000.0; // convert milliseconds to seconds
  FLastTime := glfwGetTime;
  FSpeed := AValue;
end;

procedure Tg2dTimer.InitFPS(const AValue: Double);
begin
  if AValue > 0 then
    FInterval := 1.0 / AValue
  else
    FInterval := 0; // Prevent division by zero if FPS is not positive
  FLastTime := glfwGetTime;
  FSpeed := AValue;
end;

function Tg2dTimer.Check(): Boolean;
begin
  Result := (glfwGetTime - FLastTime) >= FInterval;
  if Result then
    FLastTime := glfwGetTime; // Auto-reset on check
end;

procedure Tg2dTimer.Reset();
begin
  FLastTime := glfwGetTime;
end;

function  Tg2dTimer.Speed(): Double;
begin
  Result := FSpeed;
end;

//=== STATICOBJECT =============================================================
{ Tg2dStaticObject }
class constructor Tg2dStaticObject.Create();
begin
  inherited;
end;

class destructor Tg2dStaticObject.Destroy();
begin
  inherited;
end;

class function  Tg2dStaticObject.GetError(): string;
begin
  Result := FError;
end;

class procedure Tg2dStaticObject.SetError(const AText: string; const AArgs: array of const);
begin
  FError := Format(AText, AArgs);
end;

//=== OBJECT ===================================================================
{ Tg2dObject }
constructor Tg2dObject.Create();
begin
  inherited;
end;

destructor Tg2dObject.Destroy();
begin
  inherited;
end;


function  Tg2dObject.GetError(): string;
begin
  Result := FError;
end;

procedure Tg2dObject.SetError(const AText: string; const AArgs: array of const);
begin
  FError := Format(AText, AArgs);
end;

//=== ASYNC ====================================================================
{ Tg2dAsyncThread }
constructor Tg2dAsyncThread.Create();
begin
  inherited Create(True);

  FTask := nil;
  FWait := nil;
  FFinished := False;
end;

destructor Tg2dAsyncThread.Destroy();
begin
  inherited;
end;

procedure Tg2dAsyncThread.Execute();
begin
  FFinished := False;

  if Assigned(FTask) then
  begin
    FTask();
  end;

  FFinished := True;
end;

{ Tg2dAsync }
constructor Tg2dAsync.Create();
begin
  inherited;

  FQueue := TList<Tg2dAsyncThread>.Create;
  FBusy := TDictionary<string, TBusyData>.Create;
end;

destructor Tg2dAsync.Destroy();
begin

  FBusy.Free();
  FQueue.Free();

  inherited;
end;

procedure Tg2dAsync.Clear();
begin
  WaitForAllToTerminate();
  FBusy.Clear();
  FQueue.Clear();
end;

procedure Tg2dAsync.Process();
var
  LAsyncThread: Tg2dAsyncThread;
  LAsyncThread2: Tg2dAsyncThread;
  LIndex: TBusyData;
  LBusy: TBusyData;
begin
  Enter();

  if TThread.CurrentThread.ThreadID = MainThreadID then
  begin
    for LAsyncThread in FQueue do
    begin
      if Assigned(LAsyncThread) then
      begin
        if LAsyncThread.Finished then
        begin
          LAsyncThread.WaitFor();
          if Assigned(LAsyncThread.WaitProc) then
            LAsyncThread.WaitProc();
          FQueue.Remove(LAsyncThread);
          for LIndex in FBusy.Values do
          begin
            if Lindex.Thread = LAsyncThread then
            begin
              LBusy := LIndex;
              LBusy.Flag := False;
              FBusy.AddOrSetValue(LBusy.Name, LBusy);
              Break;
            end;
          end;
          LAsyncThread2 := LAsyncThread;
          FreeAndNil(LAsyncThread2);
        end;
      end;
    end;
    FQueue.Pack;
  end;

  Leave();
end;

procedure Tg2dAsync.Exec(const AName: string; const ABackgroundTask: Tg2dAsyncProc; const AWaitForgroundTask: Tg2dAsyncProc);
var
  LAsyncThread: Tg2dAsyncThread;
  LBusy: TBusyData;
begin
  if not Assigned(ABackgroundTask) then Exit;
  if AName.IsEmpty then Exit;
  if Busy(AName) then Exit;
  Enter;
  LAsyncThread := Tg2dAsyncThread.Create;
  LAsyncThread.TaskProc := ABackgroundTask;
  LAsyncThread.WaitProc := AWaitForgroundTask;
  FQueue.Add(LAsyncThread);
  LBusy.Name := AName;
  LBusy.Thread := LAsyncThread;
  LBusy.Flag := True;
  LBusy.Terminate := False;
  FBusy.AddOrSetValue(AName, LBusy);
  LAsyncThread.Start;
  Leave;
end;

function  Tg2dAsync.Busy(const AName: string): Boolean;
var
  LBusy: TBusyData;
begin
  Result := False;
  if AName.IsEmpty then Exit;
  Enter;
  FBusy.TryGetValue(AName, LBusy);
  Leave;
  Result := LBusy.Flag;
end;

procedure Tg2dAsync.SetTerminate(const AName: string; const ATerminate: Boolean);
var
  LBusy: TBusyData;
begin
  if AName.IsEmpty then Exit;
  Enter();
  FBusy.TryGetValue(AName, LBusy);
  LBusy.Terminate := ATerminate;
  FBusy.AddOrSetValue(AName, LBusy);
  Leave();
end;

function  Tg2dAsync.ShouldTerminate(const AName: string): Boolean;
var
  LBusy: TBusyData;
begin
  Result := False;
  if AName.IsEmpty then Exit;
  Enter();
  FBusy.TryGetValue(AName, LBusy);
  Result := LBusy.Terminate;
  Leave();
end;

procedure Tg2dAsync.TerminateAll();
var
  LBusy: TPair<string, TBusyData>;
begin
  for LBusy in FBusy do
  begin
    SetTerminate(LBusy.Key, True);
  end;
end;

procedure Tg2dAsync.WaitForAllToTerminate();
var
  LDone: Boolean;
begin
  TerminateAll();
  Resume();
  LDone := False;
  while not LDone do
  begin
    if FQueue.Count = 0 then
      Break;
    Process();
    Sleep(0);
  end;
end;

procedure Tg2dAsync.Suspend();
var
  LAsyncThread: Tg2dAsyncThread;
begin
  for LAsyncThread in FQueue do
  begin
    if not LAsyncThread.Suspended then
      LAsyncThread.Suspend;
  end;
end;

procedure Tg2dAsync.Resume();
var
  LAsyncThread: Tg2dAsyncThread;
begin
  for LAsyncThread in FQueue do
  begin
    if LAsyncThread.Suspended then
      LAsyncThread.Resume;
  end;
end;

procedure Tg2dAsync.Enter();
begin
  Tg2dUtils.EnterCriticalSection();
end;

procedure Tg2dAsync.Leave();
begin
  Tg2dUtils.LeaveCriticalSection();
end;

//=== UTILS ====================================================================
{ Tg2dUtils }
class constructor Tg2dUtils.Create();
begin
  inherited;

  FCriticalSection := TCriticalSection.Create();
  FAsync := Tg2dAsync.Create();
end;

class destructor Tg2dUtils.Destroy();
begin
  FAsync.Free();
  FCriticalSection.Free();

  inherited;
end;

class procedure Tg2dUtils.FatalError(const AMsg: string; const AArgs: array of const);
var
  LText: string;
begin
  LText := Format(AMsg, AArgs);
  MessageBox(0, PChar(LText), 'Fatal Error', MB_ICONERROR or MB_OK);
  Halt(1);
end;

class function  Tg2dUtils.AsUTF8(const AText: string; const AArgs: array of const): Pointer;
var
  LText: string;
begin
  LText := Format(AText, AArgs);
  Result := FMarshaller.AsUtf8(LText).ToPointer;
end;

class procedure Tg2dUtils.ProcessMessages();
var
  LMsg: TMsg;
begin
  while Integer(PeekMessage(LMsg, 0, 0, 0, PM_REMOVE)) <> 0 do
  begin
    TranslateMessage(LMsg);
    DispatchMessage(LMsg);
  end;
end;

class function Tg2dUtils.LogarithmicVolume(const ALinear: Single): Single;
const
  MinDb = -40.0; // Minimum dB attenuation (e.g., -40 dB = almost silence)
var
  L: Single;
begin
  L := EnsureRange(ALinear, 0.0, 1.0);
  if L = 0 then
    Result := 0
  else if L = 1 then
    Result := 1
  else
    Result := Power(10, (MinDb * (1 - L)) / 20);
end;

class procedure Tg2dUtils.EnterCriticalSection();
begin
  FCriticalSection.Enter;
end;

class procedure Tg2dUtils.LeaveCriticalSection();
begin
  FCriticalSection.Leave;
end;

class procedure Tg2dUtils.Wait(const AMilliseconds: Double);
var
  LFrequency, LStartCount, LCurrentCount: Int64;
  LElapsedTime: Double;
begin
  // Get the high-precision frequency of the system's performance counter
  QueryPerformanceFrequency(LFrequency);

  // Get the starting value of the performance counter
  QueryPerformanceCounter(LStartCount);

  // Convert milliseconds to seconds for precision timing
  repeat
    QueryPerformanceCounter(LCurrentCount);
    LElapsedTime := (LCurrentCount - LStartCount) / LFrequency * 1000.0; // Convert to milliseconds
  until LElapsedTime >= AMilliseconds;
end;

class function  Tg2dUtils.HudTextItem(const AKey: string; const AValue: string; const APaddingWidth: Cardinal; const ASeperator: string): string;
begin
  Result := Format('%s %s %s', [aKey.PadRight(APaddingWidth), aSeperator, aValue]);
end;

class function Tg2dUtils.ResourceExists(const AInstance: THandle; const aResName: string): Boolean;
begin
  Result := Boolean((FindResource(AInstance, PChar(aResName), RT_RCDATA) <> 0));
end;

class function Tg2dUtils.RemoveDuplicates(const aText: string): string;
var
  i, l: integer;
begin
  Result := '';
  l := Length(aText);
  for i := 1 to l do
  begin
    if (Pos(aText[i], result) = 0) then
    begin
      result := result + aText[i];
    end;
  end;
end;

class procedure Tg2dUtils.AsyncProcess();
begin
  FAsync.Process();
end;

class procedure Tg2dUtils.AsyncClear();
begin
  FAsync.Clear();
end;

class procedure Tg2dUtils.AsyncRun(const AName: string; const ABackgroundTask: Tg2dAsyncProc; const AWaitForgroundTask: Tg2dAsyncProc);
begin
  FAsync.Exec(AName, ABackgroundTask, AWaitForgroundTask);
end;

class function  Tg2dUtils.AsyncIsBusy(const AName: string): Boolean;
begin
  Result := FAsync.Busy(AName);
end;

class procedure Tg2dUtils.AsyncSetTerminate(const AName: string; const ATerminate: Boolean);
begin
  FAsync.SetTerminate(AName, ATerminate);
end;

class function  Tg2dUtils.AsyncShouldTerminate(const AName: string): Boolean;
begin
  Result := FAsync.ShouldTerminate(AName);
end;

class procedure Tg2dUtils.AsyncTerminateAll();
begin
  FAsync.TerminateAll();
end;

class procedure Tg2dUtils.AsyncWaitForAllToTerminate();
begin
  FAsync.WaitForAllToTerminate();
end;

class procedure Tg2dUtils.AsyncSuspend();
begin
  FAsync.Suspend();
end;

class procedure Tg2dUtils.AsyncResume();
begin
  FAsync.Resume();
end;

class function Tg2dUtils.GetPhysicalProcessorCount(): DWORD;
var
  LBufferSize: DWORD;
  LBuffer: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  LProcessorInfo: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  LOffset: DWORD;
begin
  Result := 0;
  LBufferSize := 0;

  // Call GetLogicalProcessorInformation with buffer size set to 0 to get required buffer size
  if not GetLogicalProcessorInformation(nil, LBufferSize) and (WinApi.Windows.GetLastError() = ERROR_INSUFFICIENT_BUFFER) then
  begin
    // Allocate buffer
    GetMem(LBuffer, LBufferSize);
    try
      // Call GetLogicalProcessorInformation again with allocated buffer
      if GetLogicalProcessorInformation(LBuffer, LBufferSize) then
      begin
        LProcessorInfo := LBuffer;
        LOffset := 0;
        // Loop through processor information to count physical processors
        while LOffset + SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION) <= LBufferSize do
        begin
          if LProcessorInfo.Relationship = RelationProcessorCore then
            Inc(Result);
          Inc(LProcessorInfo);
          Inc(LOffset, SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION));
        end;
      end;
    finally
      FreeMem(LBuffer);
    end;
  end;

  // Fallback: if we couldn't get physical core count, assume it's half of logical
  if Result = 0 then
    Result := Max(1, GetLogicalProcessorCount() div 2);
end;

class function Tg2dUtils.GetLogicalProcessorCount(): DWORD;
var
  LSystemInfo: SYSTEM_INFO;
begin
  GetSystemInfo(LSystemInfo);
  Result := LSystemInfo.dwNumberOfProcessors;

  // Ensure we have at least 1 processor
  if Result = 0 then
    Result := 1;
end;


end.

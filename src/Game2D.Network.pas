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
Game2D.Network - High-Level Socket API for Multiplayer Gaming

This unit provides a complete networking layer designed specifically for
multiplayer games, offering both high-level abstractions for common gaming
scenarios and low-level socket control for advanced implementations. Built
on WinSock2 with comprehensive support for IPv4/IPv6, TCP/UDP, and modern
async patterns perfect for real-time gameplay.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════

• HIGH-LEVEL GAME NETWORKING: Ready-to-use client/server classes for multiplayer
• LOW-LEVEL SOCKET CONTROL: Direct socket manipulation for custom protocols
• DUAL-STACK NETWORKING: IPv4 and IPv6 support with automatic fallback
• ASYNC NON-BLOCKING I/O: Responsive networking without blocking game loops
• CROSS-PROTOCOL SUPPORT: TCP for reliability, UDP for speed and broadcasts
• NETWORK DISCOVERY: LAN game discovery and broadcast capabilities
• CONNECTION MANAGEMENT: Auto-cleanup, error handling, and state tracking

The architecture follows a layered approach:
- Tg2dNetManager: Global network initialization and utilities
- Tg2dNetSocket: Low-level socket operations and control
- Tg2dNetClient: High-level game client for connecting to servers
- Tg2dNetServer: Multi-client game server with connection management
- Supporting types: Address handling, adapter enumeration, error management

═══════════════════════════════════════════════════════════════════════════════
NETWORK MANAGER
═══════════════════════════════════════════════════════════════════════════════

• Global network subsystem initialization and cleanup
• DNS resolution and IP address validation
• Network adapter enumeration and information
• Socket selection and polling utilities
• Local IP address discovery

INITIALIZATION:
  program MyGame;
  begin
    // Initialize networking before any socket operations
    if not Tg2dNetManager.Initialize() then
    begin
      WriteLn('Failed to initialize networking');
      Exit;
    end;

    // Your game code here

    // Cleanup when exiting
    Tg2dNetManager.Shutdown();
  end;

DNS AND ADDRESS UTILITIES:
  var
    LAddress: Tg2dNetAddress;
    LIPList: TArray<string>;
  begin
    // Resolve hostname to IP
    LAddress := Tg2dNetManager.ResolveHostname('game.example.com', nafIPv4);
    WriteLn('Server IP: ' + LAddress.ToString());

    // Validate IP addresses
    if Tg2dNetManager.IsValidIPv4('192.168.1.100') then
      WriteLn('Valid IPv4 address');

    // Get local IPs for LAN discovery
    LIPList := Tg2dNetManager.GetLocalIPv4Addresses();
    for var LIP in LIPList do
      WriteLn('Local IP: ' + LIP);
  end;

NETWORK ADAPTER INFORMATION:
  var
    LAdapterInfo: Tg2dNetAdapterInfo;
    LAdapterList: TArray<string>;
  begin
    LAdapterList := Tg2dNetManager.GetAdapterList();
    for var LAdapterName in LAdapterList do
    begin
      LAdapterInfo := Tg2dNetManager.GetAdapterInfo(LAdapterName);
      WriteLn('Adapter: ' + LAdapterInfo.Name);
      WriteLn('  IPv4: ' + LAdapterInfo.IPv4Address);
      WriteLn('  Speed: ' + IntToStr(LAdapterInfo.SpeedBps) + ' bps');
      WriteLn('  Wireless: ' + BoolToStr(LAdapterInfo.IsWireless));
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
GAME CLIENT
═══════════════════════════════════════════════════════════════════════════════

• Simple connection to game servers
• Automatic protocol selection (TCP/UDP)
• Text and binary data transmission
• Connection state management
• Error handling and reconnection support

BASIC TCP CONNECTION:
  var LClient: Tg2dNetClient;
  begin
    LClient := Tg2dNetClient.Create();
    try
      // Connect to game server
      if LClient.ConnectTCP('game.server.com', 8080) then
      begin
        // Send player login
        LClient.SendText('LOGIN:PlayerName:Password123');

        // Game loop
        while LClient.IsConnected() do
        begin
          // Send player input
          LClient.SendText('MOVE:X=100,Y=200');

          // Receive server updates
          var LResponse := LClient.RecvText();
          if LResponse <> '' then
            ProcessServerMessage(LResponse);

          Sleep(16); // ~60 FPS
        end;
      end;
    finally
      LClient.Free();
    end;
  end;

UDP REAL-TIME COMMUNICATION:
  var
    LClient: Tg2dNetClient;
    LPlayerData: TPlayerState;
  begin
    LClient := Tg2dNetClient.Create();
    try
      if LClient.ConnectUDP('192.168.1.100', 9090) then
      begin
        // Send fast game state updates
        LPlayerData.X := PlayerPos.X;
        LPlayerData.Y := PlayerPos.Y;
        LPlayerData.Rotation := PlayerAngle;
        LPlayerData.Timestamp := GetTickCount64();

        // Send binary data for efficiency
        LClient.Send(@LPlayerData, SizeOf(LPlayerData));
      end;
    finally
      LClient.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
GAME SERVER
═══════════════════════════════════════════════════════════════════════════════

• Multi-client game hosting
• Configurable client limits
• Per-client data management
• Broadcasting and individual messaging
• Automatic connection cleanup
• Client accept loop management

TCP GAME SERVER SETUP:
  var
    LServer: Tg2dNetServer;
    LNewClient: Tg2dNetServerClient;
    LMessage: string;
    I: Integer;
  begin
    LServer := Tg2dNetServer.Create();
    try
      // Start server on port 8080, max 10 players
      if LServer.StartTCP(8080, 10) then
      begin
        WriteLn('Game server started on port 8080');

        while LServer.IsRunning() do
        begin
          // Accept new players
          LNewClient := LServer.AcceptClient();
          if Assigned(LNewClient) then
          begin
            WriteLn('New player connected: ' + LNewClient.Address.ToString());
            LNewClient.SendText('WELCOME:Game Server v1.0');
          end;

          // Process all connected clients
          for I := 0 to LServer.ClientCount - 1 do
          begin
            LNewClient := LServer.GetClient(I);
            if LNewClient.IsConnected() then
            begin
              LMessage := LNewClient.RecvText();
              if LMessage <> '' then
                ProcessPlayerMessage(LNewClient, LMessage);
            end;
          end;

          // Remove disconnected players
          LServer.RemoveDisconnectedClients();
          Sleep(10);
        end;
      end;
    finally
      LServer.Free();
    end;
  end;

MULTIPLAYER GAME LOOP:
  type
    TPlayerGameData = record
      PlayerID: Integer;
      Name: string;
      Score: Integer;
      LastActivity: UInt64;
    end;
    PPlayerGameData = ^TPlayerGameData;

  var
    LServer: Tg2dNetServer;
    LPlayer: Tg2dNetServerClient;
    LPlayerData: PPlayerGameData;
    LGameInfo: string;
    I: Integer;
  begin
    LServer := Tg2dNetServer.Create();
    try
      LServer.StartTCP(7777, 8); // 8-player game

      repeat
        // Accept new players until game full
        LPlayer := LServer.AcceptClient();
        if Assigned(LPlayer) then
        begin
          New(LPlayerData);
          LPlayerData^.PlayerID := LServer.ClientCount;
          LPlayerData^.Name := 'Player' + IntToStr(LPlayerData^.PlayerID);
          LPlayerData^.Score := 0;
          LPlayer.UserData := LPlayerData; // Attach game data

          LPlayer.SendText('JOINED:ID=' + IntToStr(LPlayerData^.PlayerID));
        end;
      until LServer.ClientCount >= 8;

      // Broadcast game start
      for I := 0 to LServer.ClientCount - 1 do
      begin
        LPlayer := LServer.GetClient(I);
        LPlayer.SendText('GAME_START:Players=' + IntToStr(LServer.ClientCount));
      end;

      // Game loop
      while LServer.IsRunning() do
      begin
        // Process each player
        for I := LServer.ClientCount - 1 downto 0 do
        begin
          LPlayer := LServer.GetClient(I);
          if LPlayer.IsConnected() then
          begin
            LPlayerData := PPlayerGameData(LPlayer.UserData);

            // Handle player input
            var LInput := LPlayer.RecvText();
            if LInput <> '' then
            begin
              ProcessPlayerInput(LPlayer, LPlayerData^, LInput);

              // Broadcast to other players
              LGameInfo := Format('UPDATE:Player%d:%s',
                [LPlayerData^.PlayerID, LInput]);
              BroadcastToOthers(LServer, LPlayer, LGameInfo);
            end;
          end
          else
          begin
            // Cleanup disconnected player
            if Assigned(LPlayer.UserData) then
              Dispose(PPlayerGameData(LPlayer.UserData));
            LServer.RemoveClient(LPlayer);
          end;
        end;

        Sleep(16); // ~60 FPS server tick
      end;
    finally
      LServer.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
LOW-LEVEL SOCKET OPERATIONS
═══════════════════════════════════════════════════════════════════════════════

• Direct WinSock2 socket control
• Custom protocol implementation
• Non-blocking I/O operations
• IPv4/IPv6 dual-stack support
• Broadcast and multicast capabilities
• Advanced socket options

RAW SOCKET USAGE:
  var
    LSocket: Tg2dNetSocket;
    LAddress: Tg2dNetAddress;
    LData: array[0..1023] of Byte;
    LBytesReceived: Integer;
  begin
    LSocket := Tg2dNetSocket.Create();
    try
      // Create UDP socket for custom protocol
      LSocket.CreateUDP4();
      LSocket.SetNonBlocking(True);

      // Bind to local port
      LAddress.Clear();
      LAddress.Family := nafIPv4;
      LAddress.Address := '0.0.0.0';
      LAddress.Port := 5555;
      LSocket.Bind(LAddress);

      // Receive data
      LBytesReceived := LSocket.Recv(@LData, Length(LData));
      if LBytesReceived > 0 then
        ProcessCustomProtocol(@LData, LBytesReceived);
    finally
      LSocket.Free();
    end;
  end;

LAN GAME DISCOVERY:
  var
    LSocket: Tg2dNetSocket;
    LBroadcastAddr: Tg2dNetAddress;
    LGameInfo: string;
  begin
    LSocket := Tg2dNetSocket.Create();
    try
      LSocket.CreateUDP4();
      LSocket.EnableBroadcast(True);

      // Broadcast game announcement
      LBroadcastAddr.Family := nafIPv4;
      LBroadcastAddr.Address := '255.255.255.255';
      LBroadcastAddr.Port := 8888;

      LGameInfo := 'GAME:MyAwesomeGame:Players=2/8:Map=Desert';
      LSocket.SendTo(PAnsiChar(AnsiString(LGameInfo)),
        Length(AnsiString(LGameInfo)), LBroadcastAddr);
    finally
      LSocket.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION EXAMPLES
═══════════════════════════════════════════════════════════════════════════════

COMPLETE MULTIPLAYER SETUP:
  // Server hosting a real-time action game
  procedure StartGameServer();
  var
    LServer: Tg2dNetServer;
    LUDPSocket: Tg2dNetSocket;
    LClient: Tg2dNetServerClient;
    LGameState: TGameState;
    I: Integer;
  begin
    // Initialize networking
    Tg2dNetManager.Initialize();

    LServer := Tg2dNetServer.Create();
    LUDPSocket := Tg2dNetSocket.Create();
    try
      // TCP for reliable commands and chat
      LServer.StartTCP(8080, 16);

      // UDP for fast position updates
      LUDPSocket.CreateUDP4();
      LUDPSocket.SetNonBlocking(True);
      LUDPSocket.Bind(Tg2dNetAddress.Create(nafIPv4, '0.0.0.0', 8081));

      WriteLn('Game server ready - TCP:8080, UDP:8081');

      while True do
      begin
        // Handle new TCP connections
        LClient := LServer.AcceptClient();
        if Assigned(LClient) then
          OnPlayerJoined(LClient);

        // Process TCP messages (chat, commands)
        for I := 0 to LServer.ClientCount - 1 do
        begin
          LClient := LServer.GetClient(I);
          var LMessage := LClient.RecvText();
          if LMessage <> '' then
            ProcessTCPMessage(LClient, LMessage);
        end;

        // Handle UDP position updates
        ProcessUDPUpdates(LUDPSocket);

        // Send game state to all clients
        BroadcastGameState(LServer, LUDPSocket, LGameState);

        // Update game logic
        UpdateGameLogic(LGameState);

        Sleep(16); // 60 FPS
      end;
    finally
      LServer.Free();
      LUDPSocket.Free();
      Tg2dNetManager.Shutdown();
    end;
  end;

CLIENT CONNECTION WITH FALLBACK:
  function ConnectToGame(const AServerList: TArray<string>): Boolean;
  var
    LClient: Tg2dNetClient;
    LServerAddr: string;
  begin
    Result := False;
    LClient := Tg2dNetClient.Create();
    try
      // Try each server in the list
      for LServerAddr in AServerList do
      begin
        WriteLn('Attempting to connect to: ' + LServerAddr);

        // Try IPv4 first, then IPv6
        if LClient.ConnectTCP(LServerAddr, 8080) then
        begin
          WriteLn('Connected successfully!');

          // Verify connection with handshake
          LClient.SendText('CLIENT_HELLO:Version=1.0');
          var LResponse := LClient.RecvText(5000); // 5 second timeout

          if LResponse.StartsWith('SERVER_HELLO') then
          begin
            Result := True;
            Break;
          end;
        end;

        // If failed, try next server
        LClient.Disconnect();
      end;
    finally
      if not Result then
        LClient.Free()
      else
        SetGameClient(LClient); // Store for game use
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════

• NON-BLOCKING I/O: All socket operations support non-blocking mode to prevent
  game loop freezing during network operations
• SOCKET POLLING: Tg2dNetManager.SelectSockets() allows efficient monitoring
  of multiple sockets for activity
• ZERO-COPY OPERATIONS: Direct buffer access for binary data transmission
• CONNECTION POOLING: Server automatically manages client connections with
  efficient add/remove operations
• MEMORY MANAGEMENT: Automatic cleanup of disconnected clients and resources
• BATCH OPERATIONS: Send data to multiple clients efficiently

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════

• AUTOMATIC CLEANUP: All network objects inherit from Tg2dObject with proper
  destructor chains for resource cleanup
• CLIENT DATA: Server clients support UserData pointer for attaching game-
  specific data structures - remember to free manually
• SOCKET LIFECYCLE: Sockets are automatically closed and released in destructors
• CONNECTION TRACKING: Server maintains internal lists that are cleaned up
  when clients disconnect or server shuts down
• ERROR RECOVERY: Failed operations don't leak resources

═══════════════════════════════════════════════════════════════════════════════
THREADING CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════

• SINGLE-THREADED DESIGN: All networking classes are designed for single-
  threaded use within the main game loop
• NON-BLOCKING ALTERNATIVE: Use non-blocking sockets instead of threads to
  maintain responsive gameplay
• THREAD SAFETY: If using multiple threads, protect socket operations with
  critical sections or use separate socket instances per thread
• ASYNC PATTERNS: Polling-based approach works well with game frame timing

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════

• COMPREHENSIVE ERROR REPORTING: All socket operations return detailed error
  codes and messages through LastError and LastErrorMessage properties
• GRACEFUL DEGRADATION: Failed operations return safe default values (False,
  0, empty string) rather than raising exceptions
• CONNECTION STATE TRACKING: IsConnected(), IsBound(), IsListening() properties
  provide reliable state information
• AUTOMATIC CLEANUP: Failed operations clean up partial state automatically

COMMON PITFALLS:
• Always check return values of Connect(), Send(), and Recv() operations
• Initialize networking with Tg2dNetManager.Initialize() before any socket use
• Free UserData manually when removing server clients
• Use non-blocking sockets for responsive gameplay
• Handle partial sends/receives in game protocols

===============================================================================}

unit Game2D.Network;

{$I Game2D.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Winsock2,
  System.SysUtils,
  System.Classes,
  Game2D.Deps,
  Game2D.Common;

//=== TYPES ====================================================================
type
  { Tg2dNetAddressFamily }
  Tg2dNetAddressFamily = (
    nafIPv4,
    nafIPv6
  );

  { Tg2dNetSocketType }
  Tg2dNetSocketType = (
    nstStream,    // TCP
    nstDatagram   // UDP
  );

  { Tg2dNetAddress }
  Tg2dNetAddress = record
    Family: Tg2dNetAddressFamily;
    Address: string;
    Port: Word;
    procedure Clear();
    function ToString(): string;
  end;

  { Tg2dNetAdapterInfo }
  Tg2dNetAdapterInfo = record
    Name: string;
    Description: string;
    MacAddress: string;
    IPv4Address: string;
    IPv6Address: string;
    SpeedBps: UInt64;
    IsWireless: Boolean;
    MTU: Integer;
    InterfaceIndex: Cardinal;
    procedure Clear();
  end;

//=== NETWORK SOCKET ===========================================================
type
  { Tg2dNetSocket }
  Tg2dNetSocket = class(Tg2dObject)
  private
    FHandle: XSocket;
    FFamily: Tg2dNetAddressFamily;
    FSocketType: Tg2dNetSocketType;
    FIsConnected: Boolean;
    FIsBound: Boolean;
    FIsListening: Boolean;
    function GetLastError(): Integer;
    function GetLastErrorMessage(): string;
    function AddressFamilyToX(const AFamily: Tg2dNetAddressFamily): XAddressFamily;
    function SocketTypeToX(const ASocketType: Tg2dNetSocketType): XSocketType;
    function XAddressToG2d(const AXAddr: XAddress): Tg2dNetAddress;
    function G2dAddressToX(const AAddr: Tg2dNetAddress): XAddress;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    // Socket creation and management
    function CreateSocket(const AFamily: Tg2dNetAddressFamily; const ASocketType: Tg2dNetSocketType): Boolean;
    function CreateTCP4(): Boolean;
    function CreateTCP6(): Boolean;
    function CreateUDP4(): Boolean;
    function CreateUDP6(): Boolean;
    procedure CloseSocket();
    function IsValid(): Boolean;
    function SetNonBlocking(const ANonBlocking: Boolean): Boolean;

    // Server operations
    function Bind(const AAddress: Tg2dNetAddress): Boolean;
    function BindAny(const AFamily: Tg2dNetAddressFamily; const APort: Word): Boolean;
    function Listen(const ABacklog: Integer = 10): Boolean;
    function Accept(out AClientAddress: Tg2dNetAddress): Tg2dNetSocket;

    // Client operations
    function Connect(const AAddress: Tg2dNetAddress): Boolean;
    function ConnectTo(const AHost: string; const APort: Word): Boolean;

    // Data transfer
    function Send(const AData: Pointer; const ASize: Integer): Integer;
    function SendText(const AText: string): Integer;
    function Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
    function RecvText(const AMaxLength: Integer = 1024): string;
    function SendTo(const AData: Pointer; const ASize: Integer; const AAddress: Tg2dNetAddress): Integer;
    function RecvFrom(const ABuffer: Pointer; const ASize: Integer; out AFromAddress: Tg2dNetAddress): Integer;

    // Polling and selection
    function WaitForData(const ATimeoutMs: Integer = 0): Boolean;
    function CanSend(const ATimeoutMs: Integer = 0): Boolean;

    // Multicast and broadcast
    function JoinMulticastIPv4(const AGroupIP: string): Boolean;
    function LeaveMulticastIPv4(const AGroupIP: string): Boolean;
    function JoinMulticastIPv6(const AGroupIP: string; const AInterfaceIndex: Cardinal): Boolean;
    function LeaveMulticastIPv6(const AGroupIP: string; const AInterfaceIndex: Cardinal): Boolean;
    function EnableBroadcast(const AEnable: Boolean): Boolean;

    // Properties
    property Handle: XSocket read FHandle;
    property Family: Tg2dNetAddressFamily read FFamily;
    property SocketType: Tg2dNetSocketType read FSocketType;
    property IsConnected: Boolean read FIsConnected;
    property IsBound: Boolean read FIsBound;
    property IsListening: Boolean read FIsListening;
    property LastError: Integer read GetLastError;
    property LastErrorMessage: string read GetLastErrorMessage;
  end;

//=== NETWORK MANAGER ==========================================================
type
  { Tg2dNetManager }
  Tg2dNetManager = class(Tg2dStaticObject)
  private
    class var FInitialized: Boolean;
  public
    class constructor Create();
    class destructor Destroy();

    // Core network management
    class function Initialize(): Boolean;
    class procedure Shutdown();
    class function IsInitialized(): Boolean;

    // DNS and address utilities
    class function ResolveHostname(const AHostname: string; const AFamily: Tg2dNetAddressFamily): Tg2dNetAddress;
    class function ParseIPAddress(const AIPString: string): Tg2dNetAddress;
    class function IsValidIPv4(const AIPString: string): Boolean;
    class function IsValidIPv6(const AIPString: string): Boolean;

    // Network adapter information
    class function GetAdapterCount(): Integer;
    class function GetAdapterList(): TArray<string>;
    class function GetAdapterInfo(const AAdapterName: string): Tg2dNetAdapterInfo;

    // Utility functions
    class function SelectSockets(const ASockets: TArray<Tg2dNetSocket>; const ATimeoutMs: Integer): TArray<Tg2dNetSocket>;
    class function GetLocalIPv4Addresses(): TArray<string>;
    class function GetLocalIPv6Addresses(): TArray<string>;
  end;

//=== NETWORK CLIENT ===========================================================
type
  { Tg2dNetClient }
  Tg2dNetClient = class(Tg2dObject)
  private
    FSocket: Tg2dNetSocket;
    FHost: string;
    FPort: Word;
    FConnected: Boolean;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    function Connect(const AHost: string; const APort: Word; const AUseIPv6: Boolean = False): Boolean;
    function ConnectTCP(const AHost: string; const APort: Word): Boolean;
    function ConnectUDP(const AHost: string; const APort: Word): Boolean;
    procedure Disconnect();
    function Send(const AData: Pointer; const ASize: Integer): Integer;
    function SendText(const AText: string): Integer;
    function Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
    function RecvText(const AMaxLength: Integer = 1024): string;
    function IsConnected(): Boolean;

    property Socket: Tg2dNetSocket read FSocket;
    property Host: string read FHost;
    property Port: Word read FPort;
    property Connected: Boolean read FConnected;
  end;

//=== NETWORK SERVER ===========================================================
type
  { Tg2dNetServerClient }
  Tg2dNetServerClient = class(Tg2dObject)
  private
    FSocket: Tg2dNetSocket;
    FAddress: Tg2dNetAddress;
    FConnected: Boolean;
    FUserData: Pointer;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    procedure Initialize(const ASocket: Tg2dNetSocket; const AAddress: Tg2dNetAddress);
    function Send(const AData: Pointer; const ASize: Integer): Integer;
    function SendText(const AText: string): Integer;
    function Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
    function RecvText(const AMaxLength: Integer = 1024): string;
    procedure Disconnect();
    function IsConnected(): Boolean;

    property Socket: Tg2dNetSocket read FSocket;
    property Address: Tg2dNetAddress read FAddress;
    property Connected: Boolean read FConnected;
    property UserData: Pointer read FUserData write FUserData;
  end;

  { Tg2dNetServer }
  Tg2dNetServer = class(Tg2dObject)
  private
    FSocket: Tg2dNetSocket;
    FPort: Word;
    FMaxClients: Integer;
    FClients: TList;
    FRunning: Boolean;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    function Start(const APort: Word; const AMaxClients: Integer = 10; const AUseIPv6: Boolean = False): Boolean;
    function StartTCP(const APort: Word; const AMaxClients: Integer = 10): Boolean;
    function StartUDP(const APort: Word): Boolean;
    procedure Stop();
    function AcceptClient(): Tg2dNetServerClient;
    function GetClient(const AIndex: Integer): Tg2dNetServerClient;
    function GetClientCount(): Integer;
    procedure RemoveClient(const AClient: Tg2dNetServerClient);
    procedure RemoveDisconnectedClients();
    function IsRunning(): Boolean;

    property Socket: Tg2dNetSocket read FSocket;
    property Port: Word read FPort;
    property MaxClients: Integer read FMaxClients;
    property Running: Boolean read FRunning;
    property ClientCount: Integer read GetClientCount;
  end;

implementation

//=== Tg2dNetAddress ===========================================================
procedure Tg2dNetAddress.Clear();
begin
  Family := nafIPv4;
  Address := '';
  Port := 0;
end;

function Tg2dNetAddress.ToString(): string;
begin
  if Family = nafIPv6 then
    Result := Format('[%s]:%d', [Address, Port])
  else
    Result := Format('%s:%d', [Address, Port]);
end;

//=== Tg2dNetAdapterInfo =======================================================
procedure Tg2dNetAdapterInfo.Clear();
begin
  Name := '';
  Description := '';
  MacAddress := '';
  IPv4Address := '';
  IPv6Address := '';
  SpeedBps := 0;
  IsWireless := False;
  MTU := 0;
  InterfaceIndex := 0;
end;

//=== Tg2dNetSocket ============================================================
constructor Tg2dNetSocket.Create();
begin
  inherited;
  FHandle := INVALID_SOCKET;
  FFamily := nafIPv4;
  FSocketType := nstStream;
  FIsConnected := False;
  FIsBound := False;
  FIsListening := False;
end;

destructor Tg2dNetSocket.Destroy();
begin
  CloseSocket();
  inherited;
end;

function Tg2dNetSocket.GetLastError(): Integer;
begin
  Result := x_net_get_last_error();
end;

function Tg2dNetSocket.GetLastErrorMessage(): string;
var
  LBuffer: array[0..255] of AnsiChar;
begin
  if x_net_get_last_error_message(@LBuffer[0], Length(LBuffer)) = 0 then
    Result := string(LBuffer)
  else
    Result := 'Unknown error';
end;

function Tg2dNetSocket.AddressFamilyToX(const AFamily: Tg2dNetAddressFamily): XAddressFamily;
begin
  case AFamily of
    nafIPv4: Result := X_NET_AF_IPV4;
    nafIPv6: Result := X_NET_AF_IPV6;
  else
    Result := X_NET_AF_IPV4;
  end;
end;

function Tg2dNetSocket.SocketTypeToX(const ASocketType: Tg2dNetSocketType): XSocketType;
begin
  case ASocketType of
    nstStream: Result := X_NET_SOCK_STREAM;
    nstDatagram: Result := X_NET_SOCK_DGRAM;
  else
    Result := X_NET_SOCK_STREAM;
  end;
end;

function Tg2dNetSocket.XAddressToG2d(const AXAddr: XAddress): Tg2dNetAddress;
var
  LBuffer: array[0..255] of AnsiChar;
begin
  Result.Clear();
  
  if x_net_address_to_string(@AXAddr, @LBuffer[0], Length(LBuffer)) = 0 then
  begin
    // Parse the address string (format: "ip:port")
    var LAddrStr: string := string(LBuffer);
    var LColonPos: Integer := LastDelimiter(':', LAddrStr);
    if LColonPos > 0 then
    begin
      Result.Address := Copy(LAddrStr, 1, LColonPos - 1);
      Result.Port := StrToIntDef(Copy(LAddrStr, LColonPos + 1, MaxInt), 0);
    end;
  end;
  
  case AXAddr.family of
    X_NET_AF_IPV4: Result.Family := nafIPv4;
    X_NET_AF_IPV6: Result.Family := nafIPv6;
  end;
end;

function Tg2dNetSocket.G2dAddressToX(const AAddr: Tg2dNetAddress): XAddress;
var
  LIPString: AnsiString;
begin
  x_net_address_clear(@Result);
  LIPString := AnsiString(AAddr.Address);
  x_net_address_from_ip_port(PInt8(PAnsiChar(LIPString)), AAddr.Port, @Result);
end;

function Tg2dNetSocket.CreateSocket(const AFamily: Tg2dNetAddressFamily; const ASocketType: Tg2dNetSocketType): Boolean;
begin
  CloseSocket();
  
  FFamily := AFamily;
  FSocketType := ASocketType;
  FHandle := x_net_socket(AddressFamilyToX(AFamily), SocketTypeToX(ASocketType));
  
  Result := IsValid();
  if not Result then
    SetError('Failed to create socket: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.CreateTCP4(): Boolean;
begin
  Result := CreateSocket(nafIPv4, nstStream);
end;

function Tg2dNetSocket.CreateTCP6(): Boolean;
begin
  Result := CreateSocket(nafIPv6, nstStream);
end;

function Tg2dNetSocket.CreateUDP4(): Boolean;
begin
  Result := CreateSocket(nafIPv4, nstDatagram);
end;

function Tg2dNetSocket.CreateUDP6(): Boolean;
begin
  Result := CreateSocket(nafIPv6, nstDatagram);
end;

procedure Tg2dNetSocket.CloseSocket();
begin
  if IsValid() then
  begin
    x_net_close(FHandle);
    FHandle := INVALID_SOCKET;
    FIsConnected := False;
    FIsBound := False;
    FIsListening := False;
  end;
end;

function Tg2dNetSocket.IsValid(): Boolean;
begin
  Result := x_net_socket_is_valid(FHandle);
end;

function Tg2dNetSocket.SetNonBlocking(const ANonBlocking: Boolean): Boolean;
var
  LValue: Integer;
begin
  if ANonBlocking then LValue := 1 else LValue := 0;
  Result := x_net_set_nonblocking(FHandle, LValue) = 0;
  
  if not Result then
    SetError('Failed to set non-blocking mode: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.Bind(const AAddress: Tg2dNetAddress): Boolean;
var
  LXAddr: XAddress;
begin
  Result := False;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  LXAddr := G2dAddressToX(AAddress);
  Result := x_net_bind(FHandle, @LXAddr);
  
  if Result then
    FIsBound := True
  else
    SetError('Failed to bind socket: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.BindAny(const AFamily: Tg2dNetAddressFamily; const APort: Word): Boolean;
begin
  Result := False;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  Result := x_net_bind_any(FHandle, AddressFamilyToX(AFamily), APort);
  
  if Result then
    FIsBound := True
  else
    SetError('Failed to bind socket to any address: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.Listen(const ABacklog: Integer): Boolean;
begin
  Result := False;
  if not IsValid() or not FIsBound then
  begin
    SetError('Socket not valid or not bound', []);
    Exit;
  end;
  
  Result := x_net_listen(FHandle, ABacklog);
  
  if Result then
    FIsListening := True
  else
    SetError('Failed to listen on socket: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.Accept(out AClientAddress: Tg2dNetAddress): Tg2dNetSocket;
var
  LClientSocket: XSocket;
  LXAddr: XAddress;
begin
  Result := nil;
  AClientAddress.Clear();
  
  if not IsValid() or not FIsListening then
  begin
    SetError('Socket not valid or not listening', []);
    Exit;
  end;
  
  x_net_address_clear(@LXAddr);
  LClientSocket := x_net_accept(FHandle, @LXAddr);
  
  if x_net_socket_is_valid(LClientSocket) then
  begin
    Result := Tg2dNetSocket.Create();
    Result.FHandle := LClientSocket;
    Result.FFamily := FFamily;
    Result.FSocketType := FSocketType;
    Result.FIsConnected := True;
    AClientAddress := XAddressToG2d(LXAddr);
  end
  else
  begin
    SetError('Failed to accept connection: %s', [GetLastErrorMessage()]);
  end;
end;

function Tg2dNetSocket.Connect(const AAddress: Tg2dNetAddress): Boolean;
var
  LXAddr: XAddress;
begin
  Result := False;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  LXAddr := G2dAddressToX(AAddress);
  Result := x_net_connect(FHandle, @LXAddr) = 0;
  
  if Result then
    FIsConnected := True
  else
    SetError('Failed to connect: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.ConnectTo(const AHost: string; const APort: Word): Boolean;
var
  LAddress: Tg2dNetAddress;
begin
  LAddress := Tg2dNetManager.ResolveHostname(AHost, FFamily);
  LAddress.Port := APort;
  Result := Connect(LAddress);
end;

function Tg2dNetSocket.Send(const AData: Pointer; const ASize: Integer): Integer;
begin
  Result := -1;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  Result := Integer(x_net_send(FHandle, AData, ASize));
  if Result < 0 then
    SetError('Failed to send data: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.SendText(const AText: string): Integer;
var
  LData: UTF8String;
begin
  LData := UTF8String(AText);
  Result := Send(PAnsiChar(LData), Length(LData));
end;

function Tg2dNetSocket.Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
begin
  Result := -1;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  Result := Integer(x_net_recv(FHandle, ABuffer, ASize));
  if Result < 0 then
    SetError('Failed to receive data: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.RecvText(const AMaxLength: Integer): string;
var
  LBuffer: TBytes;
  LReceived: Integer;
begin
  Result := '';
  SetLength(LBuffer, AMaxLength);
  
  LReceived := Recv(@LBuffer[0], AMaxLength);
  if LReceived > 0 then
  begin
    SetLength(LBuffer, LReceived);
    Result := TEncoding.UTF8.GetString(LBuffer);
  end;
end;

function Tg2dNetSocket.SendTo(const AData: Pointer; const ASize: Integer; const AAddress: Tg2dNetAddress): Integer;
var
  LXAddr: XAddress;
begin
  Result := -1;
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  LXAddr := G2dAddressToX(AAddress);
  Result := Integer(x_net_sendto(FHandle, AData, ASize, @LXAddr));
  if Result < 0 then
    SetError('Failed to send data to address: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.RecvFrom(const ABuffer: Pointer; const ASize: Integer; out AFromAddress: Tg2dNetAddress): Integer;
var
  LXAddr: XAddress;
begin
  Result := -1;
  AFromAddress.Clear();
  
  if not IsValid() then
  begin
    SetError('Invalid socket', []);
    Exit;
  end;
  
  x_net_address_clear(@LXAddr);
  Result := Integer(x_net_recvfrom(FHandle, ABuffer, ASize, @LXAddr));
  
  if Result >= 0 then
    AFromAddress := XAddressToG2d(LXAddr)
  else
    SetError('Failed to receive data: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.WaitForData(const ATimeoutMs: Integer): Boolean;
begin
  Result := x_net_poll(FHandle, 1, ATimeoutMs) > 0; // 1 = POLLIN
end;

function Tg2dNetSocket.CanSend(const ATimeoutMs: Integer): Boolean;
begin
  Result := x_net_poll(FHandle, 4, ATimeoutMs) > 0; // 4 = POLLOUT
end;

function Tg2dNetSocket.JoinMulticastIPv4(const AGroupIP: string): Boolean;
var
  LGroupIP: AnsiString;
begin
  LGroupIP := AnsiString(AGroupIP);
  Result := x_net_join_multicast_ipv4(FHandle, PInt8(PAnsiChar(LGroupIP)));
  
  if not Result then
    SetError('Failed to join multicast group: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.LeaveMulticastIPv4(const AGroupIP: string): Boolean;
var
  LGroupIP: AnsiString;
begin
  LGroupIP := AnsiString(AGroupIP);
  Result := x_net_leave_multicast_ipv4(FHandle, PInt8(PAnsiChar(LGroupIP)));
  
  if not Result then
    SetError('Failed to leave multicast group: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.JoinMulticastIPv6(const AGroupIP: string; const AInterfaceIndex: Cardinal): Boolean;
var
  LGroupIP: AnsiString;
begin
  LGroupIP := AnsiString(AGroupIP);
  Result := x_net_join_multicast_ipv6(FHandle, PInt8(PAnsiChar(LGroupIP)), AInterfaceIndex);
  
  if not Result then
    SetError('Failed to join IPv6 multicast group: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.LeaveMulticastIPv6(const AGroupIP: string; const AInterfaceIndex: Cardinal): Boolean;
var
  LGroupIP: AnsiString;
begin
  LGroupIP := AnsiString(AGroupIP);
  Result := x_net_leave_multicast_ipv6(FHandle, PInt8(PAnsiChar(LGroupIP)), AInterfaceIndex);
  
  if not Result then
    SetError('Failed to leave IPv6 multicast group: %s', [GetLastErrorMessage()]);
end;

function Tg2dNetSocket.EnableBroadcast(const AEnable: Boolean): Boolean;
begin
  Result := x_net_enable_broadcast(FHandle, AEnable);
  
  if not Result then
    SetError('Failed to enable/disable broadcast: %s', [GetLastErrorMessage()]);
end;

//=== Tg2dNetManager ===========================================================
class constructor Tg2dNetManager.Create();
begin
  FInitialized := False;
end;

class destructor Tg2dNetManager.Destroy();
begin
  if FInitialized then
    Shutdown();
end;

class function Tg2dNetManager.Initialize(): Boolean;
begin
  if FInitialized then
  begin
    Result := True;
    Exit;
  end;
  
  Result := x_net_init();
  if Result then
    FInitialized := True
  else
    SetError('Failed to initialize network subsystem', []);
end;

class procedure Tg2dNetManager.Shutdown();
begin
  if FInitialized then
  begin
    x_net_shutdown();
    FInitialized := False;
  end;
end;

class function Tg2dNetManager.IsInitialized(): Boolean;
begin
  Result := FInitialized;
end;

class function Tg2dNetManager.ResolveHostname(const AHostname: string; const AFamily: Tg2dNetAddressFamily): Tg2dNetAddress;
var
  LHostname: AnsiString;
  LXAddr: XAddress;
  LSocket: Tg2dNetSocket;
begin
  Result.Clear();
  
  LHostname := AnsiString(AHostname);
  LSocket := Tg2dNetSocket.Create();
  try
    x_net_address_clear(@LXAddr);
    if x_net_dns_resolve(PInt8(PAnsiChar(LHostname)), LSocket.AddressFamilyToX(AFamily), @LXAddr) = 0 then
      Result := LSocket.XAddressToG2d(LXAddr)
    else
      SetError('Failed to resolve hostname: %s', [AHostname]);
  finally
    LSocket.Free();
  end;
end;

class function Tg2dNetManager.ParseIPAddress(const AIPString: string): Tg2dNetAddress;
var
  LColonPos: Integer;
begin
  Result.Clear();
  
  // Determine if IPv6 (contains multiple colons or brackets)
  if (Pos('[', AIPString) > 0) or (Pos(':', AIPString) <> LastDelimiter(':', AIPString)) then
    Result.Family := nafIPv6
  else
    Result.Family := nafIPv4;
  
  // Parse address and port
  if Result.Family = nafIPv6 then
  begin
    // IPv6 format: [address]:port or just address
    if Pos('[', AIPString) > 0 then
    begin
      var LBracketEnd: Integer := Pos(']', AIPString);
      if LBracketEnd > 0 then
      begin
        Result.Address := Copy(AIPString, 2, LBracketEnd - 2);
        LColonPos := Pos(':', AIPString, LBracketEnd);
        if LColonPos > 0 then
          Result.Port := StrToIntDef(Copy(AIPString, LColonPos + 1, MaxInt), 0);
      end;
    end
    else
    begin
      Result.Address := AIPString;
    end;
  end
  else
  begin
    // IPv4 format: address:port or just address
    LColonPos := LastDelimiter(':', AIPString);
    if LColonPos > 0 then
    begin
      Result.Address := Copy(AIPString, 1, LColonPos - 1);
      Result.Port := StrToIntDef(Copy(AIPString, LColonPos + 1, MaxInt), 0);
    end
    else
    begin
      Result.Address := AIPString;
    end;
  end;
end;

class function Tg2dNetManager.IsValidIPv4(const AIPString: string): Boolean;
var
  LParts: TArray<string>;
  LPart: string;
  LValue: Integer;
begin
  Result := False;
  
  LParts := AIPString.Split(['.']);
  if Length(LParts) <> 4 then Exit;
  
  for LPart in LParts do
  begin
    if not TryStrToInt(LPart, LValue) then Exit;
    if (LValue < 0) or (LValue > 255) then Exit;
  end;
  
  Result := True;
end;

class function Tg2dNetManager.IsValidIPv6(const AIPString: string): Boolean;
var
  LParts: TArray<string>;
  LPart: string;
  LValue: Integer;
begin
  Result := False;
  
  // Basic IPv6 validation (simplified)
  if Pos('::', AIPString) > 0 then
  begin
    // Compressed format
    Result := True; // TODO: More thorough validation
  end
  else
  begin
    LParts := AIPString.Split([':']);
    if Length(LParts) <> 8 then Exit;
    
    for LPart in LParts do
    begin
      if Length(LPart) > 4 then Exit;
      if not TryStrToInt('$' + LPart, LValue) then Exit;
    end;
    
    Result := True;
  end;
end;

class function Tg2dNetManager.GetAdapterCount(): Integer;
begin
  // TODO: Implement adapter enumeration
  Result := 0;
end;

class function Tg2dNetManager.GetAdapterList(): TArray<string>;
begin
  // TODO: Implement adapter enumeration
  SetLength(Result, 0);
end;

class function Tg2dNetManager.GetAdapterInfo(const AAdapterName: string): Tg2dNetAdapterInfo;
begin
  // TODO: Implement adapter info retrieval
  Result.Clear();
end;

class function Tg2dNetManager.SelectSockets(const ASockets: TArray<Tg2dNetSocket>; const ATimeoutMs: Integer): TArray<Tg2dNetSocket>;
var
  LSockets: array of XSocket;
  LReadyCount: Integer;
  I: Integer;
begin
  SetLength(Result, 0);
  
  if Length(ASockets) = 0 then Exit;
  
  // Prepare socket array
  SetLength(LSockets, Length(ASockets));
  for I := 0 to High(ASockets) do
    LSockets[I] := ASockets[I].Handle;
  
  LReadyCount := x_net_select(@LSockets[0], Length(LSockets), ATimeoutMs);
  
  if LReadyCount > 0 then
  begin
    SetLength(Result, LReadyCount);
    var LResultIndex: Integer := 0;
    for I := 0 to High(ASockets) do
    begin
      if ASockets[I].WaitForData(0) then // Check if ready
      begin
        Result[LResultIndex] := ASockets[I];
        Inc(LResultIndex);
        if LResultIndex >= LReadyCount then Break;
      end;
    end;
  end;
end;

class function Tg2dNetManager.GetLocalIPv4Addresses(): TArray<string>;
begin
  // TODO: Implement local IP enumeration
  SetLength(Result, 0);
end;

class function Tg2dNetManager.GetLocalIPv6Addresses(): TArray<string>;
begin
  // TODO: Implement local IPv6 enumeration
  SetLength(Result, 0);
end;

//=== Tg2dNetClient ============================================================
constructor Tg2dNetClient.Create();
begin
  inherited;
  FSocket := Tg2dNetSocket.Create();
  FHost := '';
  FPort := 0;
  FConnected := False;
end;

destructor Tg2dNetClient.Destroy();
begin
  Disconnect();
  FSocket.Free();
  inherited;
end;

function Tg2dNetClient.Connect(const AHost: string; const APort: Word; const AUseIPv6: Boolean): Boolean;
begin
  Disconnect();
  
  if AUseIPv6 then
    Result := FSocket.CreateTCP6()
  else
    Result := FSocket.CreateTCP4();
  
  if Result then
  begin
    Result := FSocket.ConnectTo(AHost, APort);
    if Result then
    begin
      FHost := AHost;
      FPort := APort;
      FConnected := True;
    end
    else
    begin
      SetError('Failed to connect to %s:%d - %s', [AHost, APort, FSocket.GetError()]);
    end;
  end
  else
  begin
    SetError('Failed to create socket - %s', [FSocket.GetError()]);
  end;
end;

function Tg2dNetClient.ConnectTCP(const AHost: string; const APort: Word): Boolean;
begin
  Result := Connect(AHost, APort, False);
end;

function Tg2dNetClient.ConnectUDP(const AHost: string; const APort: Word): Boolean;
begin
  Disconnect();
  
  Result := FSocket.CreateUDP4();
  if Result then
  begin
    FHost := AHost;
    FPort := APort;
    FConnected := True;
  end
  else
  begin
    SetError('Failed to create UDP socket - %s', [FSocket.GetError()]);
  end;
end;

procedure Tg2dNetClient.Disconnect();
begin
  if FConnected then
  begin
    FSocket.CloseSocket();
    FConnected := False;
    FHost := '';
    FPort := 0;
  end;
end;

function Tg2dNetClient.Send(const AData: Pointer; const ASize: Integer): Integer;
begin
  if FConnected then
    Result := FSocket.Send(AData, ASize)
  else
  begin
    Result := -1;
    SetError('Not connected', []);
  end;
end;

function Tg2dNetClient.SendText(const AText: string): Integer;
begin
  if FConnected then
    Result := FSocket.SendText(AText)
  else
  begin
    Result := -1;
    SetError('Not connected', []);
  end;
end;

function Tg2dNetClient.Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
begin
  if FConnected then
    Result := FSocket.Recv(ABuffer, ASize)
  else
  begin
    Result := -1;
    SetError('Not connected', []);
  end;
end;

function Tg2dNetClient.RecvText(const AMaxLength: Integer): string;
begin
  if FConnected then
    Result := FSocket.RecvText(AMaxLength)
  else
  begin
    Result := '';
    SetError('Not connected', []);
  end;
end;

function Tg2dNetClient.IsConnected(): Boolean;
begin
  Result := FConnected and FSocket.IsValid();
end;

//=== Tg2dNetServerClient ======================================================
constructor Tg2dNetServerClient.Create();
begin
  inherited;
  FSocket := nil;
  FAddress.Clear();
  FConnected := False;
  FUserData := nil;
end;

procedure Tg2dNetServerClient.Initialize(const ASocket: Tg2dNetSocket; const AAddress: Tg2dNetAddress);
begin
  FSocket := ASocket;
  FAddress := AAddress;
  FConnected := True;
end;

destructor Tg2dNetServerClient.Destroy();
begin
  Disconnect();
  inherited;
end;

function Tg2dNetServerClient.Send(const AData: Pointer; const ASize: Integer): Integer;
begin
  if FConnected and Assigned(FSocket) then
    Result := FSocket.Send(AData, ASize)
  else
  begin
    Result := -1;
    SetError('Client not connected', []);
  end;
end;

function Tg2dNetServerClient.SendText(const AText: string): Integer;
begin
  if FConnected and Assigned(FSocket) then
    Result := FSocket.SendText(AText)
  else
  begin
    Result := -1;
    SetError('Client not connected', []);
  end;
end;

function Tg2dNetServerClient.Recv(const ABuffer: Pointer; const ASize: Integer): Integer;
begin
  if FConnected and Assigned(FSocket) then
    Result := FSocket.Recv(ABuffer, ASize)
  else
  begin
    Result := -1;
    SetError('Client not connected', []);
  end;
end;

function Tg2dNetServerClient.RecvText(const AMaxLength: Integer): string;
begin
  if FConnected and Assigned(FSocket) then
    Result := FSocket.RecvText(AMaxLength)
  else
  begin
    Result := '';
    SetError('Client not connected', []);
  end;
end;

procedure Tg2dNetServerClient.Disconnect();
begin
  if FConnected and Assigned(FSocket) then
  begin
    FSocket.CloseSocket();
    FreeAndNil(FSocket);
    FConnected := False;
  end;
end;

function Tg2dNetServerClient.IsConnected(): Boolean;
begin
  Result := FConnected and Assigned(FSocket) and FSocket.IsValid();
end;

//=== Tg2dNetServer ============================================================
constructor Tg2dNetServer.Create();
begin
  inherited;
  FSocket := Tg2dNetSocket.Create();
  FPort := 0;
  FMaxClients := 0;
  FClients := TList.Create();
  FRunning := False;
end;

destructor Tg2dNetServer.Destroy();
begin
  Stop();
  FSocket.Free();
  FClients.Free();
  inherited;
end;

function Tg2dNetServer.Start(const APort: Word; const AMaxClients: Integer; const AUseIPv6: Boolean): Boolean;
begin
  Stop();
  
  if AUseIPv6 then
    Result := FSocket.CreateTCP6()
  else
    Result := FSocket.CreateTCP4();
  
  if Result then
  begin
    if AUseIPv6 then
      Result := FSocket.BindAny(nafIPv6, APort)
    else
      Result := FSocket.BindAny(nafIPv4, APort);
    
    if Result then
    begin
      Result := FSocket.Listen(AMaxClients);
      if Result then
      begin
        FPort := APort;
        FMaxClients := AMaxClients;
        FRunning := True;
      end
      else
      begin
        SetError('Failed to listen on port %d - %s', [APort, FSocket.GetError()]);
      end;
    end
    else
    begin
      SetError('Failed to bind to port %d - %s', [APort, FSocket.GetError()]);
    end;
  end
  else
  begin
    SetError('Failed to create socket - %s', [FSocket.GetError()]);
  end;
end;

function Tg2dNetServer.StartTCP(const APort: Word; const AMaxClients: Integer): Boolean;
begin
  Result := Start(APort, AMaxClients, False);
end;

function Tg2dNetServer.StartUDP(const APort: Word): Boolean;
begin
  Stop();
  
  Result := FSocket.CreateUDP4();
  if Result then
  begin
    Result := FSocket.BindAny(nafIPv4, APort);
    if Result then
    begin
      FPort := APort;
      FMaxClients := 0; // UDP doesn't have client connections
      FRunning := True;
    end
    else
    begin
      SetError('Failed to bind UDP socket to port %d - %s', [APort, FSocket.GetError()]);
    end;
  end
  else
  begin
    SetError('Failed to create UDP socket - %s', [FSocket.GetError()]);
  end;
end;

procedure Tg2dNetServer.Stop();
var
  I: Integer;
begin
  if FRunning then
  begin
    // Disconnect all clients
    for I := FClients.Count - 1 downto 0 do
    begin
      Tg2dNetServerClient(FClients[I]).Free();
    end;
    FClients.Clear();
    
    FSocket.CloseSocket();
    FRunning := False;
    FPort := 0;
    FMaxClients := 0;
  end;
end;

function Tg2dNetServer.AcceptClient(): Tg2dNetServerClient;
var
  LClientSocket: Tg2dNetSocket;
  LClientAddress: Tg2dNetAddress;
begin
  Result := nil;

  if not FRunning or (FSocket.SocketType <> nstStream) then
  begin
    SetError('Server not running or not TCP', []);
    Exit;
  end;

  LClientSocket := FSocket.Accept(LClientAddress);
  if Assigned(LClientSocket) then
  begin
    Result := Tg2dNetServerClient.Create();
    Result.Initialize(LClientSocket, LClientAddress);
    FClients.Add(Result);

    // Remove excess clients if needed
    if (FMaxClients > 0) and (FClients.Count > FMaxClients) then
    begin
      Tg2dNetServerClient(FClients[0]).Free();
      FClients.Delete(0);
    end;
  end
  else
  begin
    SetError('Failed to accept client - %s', [FSocket.GetError()]);
  end;
end;

function Tg2dNetServer.GetClient(const AIndex: Integer): Tg2dNetServerClient;
begin
  if (AIndex >= 0) and (AIndex < FClients.Count) then
    Result := Tg2dNetServerClient(FClients[AIndex])
  else
    Result := nil;
end;

function Tg2dNetServer.GetClientCount(): Integer;
begin
  Result := FClients.Count;
end;

procedure Tg2dNetServer.RemoveClient(const AClient: Tg2dNetServerClient);
var
  LIndex: Integer;
begin
  LIndex := FClients.IndexOf(AClient);
  if LIndex >= 0 then
  begin
    AClient.Free();
    FClients.Delete(LIndex);
  end;
end;

procedure Tg2dNetServer.RemoveDisconnectedClients();
var
  I: Integer;
begin
  for I := FClients.Count - 1 downto 0 do
  begin
    if not Tg2dNetServerClient(FClients[I]).IsConnected() then
    begin
      Tg2dNetServerClient(FClients[I]).Free();
      FClients.Delete(I);
    end;
  end;
end;

function Tg2dNetServer.IsRunning(): Boolean;
begin
  Result := FRunning and FSocket.IsValid();
end;

end.
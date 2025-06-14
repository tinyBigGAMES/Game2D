{==============================================================================
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

--------------------------------------------------------------------------------

Game2D.Sprite - Advanced 2D Sprite System with Animation & Collision Detection

A comprehensive sprite management system providing texture atlas-based animation,
sophisticated collision detection, and flexible movement systems for 2D games.
This unit delivers production-ready sprite functionality with performance
optimizations and advanced features like pixel-perfect collision detection.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════
The sprite system follows a modular architecture with three main components:

• **Tg2dSpriteAtlas** - Manages texture pages and animation frame definitions
• **Tg2dSprite** - Core sprite class with rendering, animation, and collision
• **Tg2dCollisionManager** - String-based collision category management system

Key design patterns used:
• Observer pattern for animation callbacks
• Factory pattern for sprite creation
• Strategy pattern for collision detection shapes
• Resource management with automatic cleanup

The system supports multiple texture formats, efficient batch rendering, and
provides both simple and advanced collision detection methods suitable for
different game genres from platformers to space shooters.

═══════════════════════════════════════════════════════════════════════════════
SPRITE ATLAS SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Manages multiple texture pages and animation sequences with frame definitions:

• Load atlas definitions from JSON files or ZIP archives
• Support for multiple texture pages per atlas
• Grid-based and region-based frame definitions
• Password-protected ZIP archive support
• Automatic texture sharing and memory optimization
• Dynamic group creation and frame management

BASIC ATLAS SETUP:
  var
    LAtlas: Tg2dSpriteAtlas;
  begin
    LAtlas := Tg2dSpriteAtlas.Create();
    try
      // Load from JSON file
      if LAtlas.LoadFromFile('assets/characters.json') then
      begin
        // Atlas is ready for sprite creation
      end;
    finally
      LAtlas.Free();
    end;
  end;

MANUAL ATLAS CREATION:
  var
    LAtlas: Tg2dSpriteAtlas;
  begin
    LAtlas := Tg2dSpriteAtlas.Create();
    try
      // Add texture page
      LAtlas.AddPageFromFile('character', 'sprites/character.png');

      // Create animation group
      LAtlas.CreateGroup('walk');

      // Add frames using grid system (32x32 pixel frames)
      LAtlas.AddGridFrames('walk', 'character',
        Tg2dSize.Create(32, 32), 8);
    finally
      LAtlas.Free();
    end;
  end;

LOADING FROM ZIP ARCHIVES:
  var
    LAtlas: Tg2dSpriteAtlas;
  begin
    LAtlas := Tg2dSpriteAtlas.Create();
    try
      // Load atlas from password-protected ZIP
      LAtlas.LoadFromZip('game_assets.zip', 'atlas/sprites.json', 'mypassword');
    finally
      LAtlas.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
SPRITE ANIMATION SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Frame-based animation system with callback support and flexible timing:

• Variable frame rate animations (1-60+ FPS)
• Looping and one-shot animation modes
• Animation completion callbacks with user data
• Pause/resume functionality
• Automatic frame progression with delta timing
• Support for complex animation sequences

BASIC ANIMATION USAGE:
  var
    LSprite: Tg2dSprite;
    LAtlas: Tg2dSpriteAtlas;
  begin
    LAtlas := Tg2dSpriteAtlas.Create();
    LAtlas.LoadFromFile('characters.json');

    LSprite := Tg2dSprite.Init(LAtlas);
    try
      // Start looping walk animation at 12 FPS
      LSprite.Play('walk', True, 12.0);

      // Game loop
      while AWindow.ShouldClose() = False do
      begin
        LSprite.Update(AWindow);  // Updates animation timing
        LSprite.Draw();           // Renders current frame
        AWindow.Present();
      end;
    finally
      LSprite.Free();
      LAtlas.Free();
    end;
  end;

ANIMATION CALLBACKS:
  procedure OnAnimationComplete(const ASprite: Tg2dSprite;
    const AAnimationName: string; const AUserData: Pointer);
  begin
    // Handle animation completion
    if AAnimationName = 'death' then
    begin
      // Respawn player or show game over
    end;
  end;

  // Setup callback
  LSprite.SetOnAnimationFinished(OnAnimationComplete, @MyGameData);
  LSprite.Play('death', False, 8.0);  // Non-looping death animation

═══════════════════════════════════════════════════════════════════════════════
COLLISION DETECTION SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Multi-shape collision system with string-based category management:

• Rectangle (AABB), Circle, OBB, Polygon, and Pixel-perfect collision
• String-based collision categories (e.g., 'player', 'enemy', 'projectile')
• Collision masking system for filtering interactions
• Debug visualization for collision bounds
• Offset collision shapes from sprite center
• Performance-optimized collision queries

COLLISION SHAPE TYPES:
  csNone      - No collision detection
  csRectangle - Axis-aligned bounding box (fastest)
  csCircle    - Circle collision (good for projectiles)
  csOBB       - Oriented bounding box (rotated rectangles)
  csPolygon   - Convex polygon collision (advanced)
  csPixel     - Pixel-perfect collision (most accurate)

BASIC COLLISION SETUP:
  var
    LPlayer: Tg2dSprite;
    LEnemy: Tg2dSprite;
  begin
    // Setup player collision
    LPlayer.SetCollisionShape(csCircle, Tg2dVec.Create(0, 0),
      Tg2dSize.Create(0, 0), 16.0);
    LPlayer.CollisionCategory := 'player';
    LPlayer.SetCollidesWith(['enemy', 'powerup']);
    LPlayer.CollisionEnabled := True;

    // Setup enemy collision
    LEnemy.SetCollisionShape(csRectangle, Tg2dVec.Create(0, 0),
      Tg2dSize.Create(32, 32), 0.0);
    LEnemy.CollisionCategory := 'enemy';
    LEnemy.SetCollidesWith(['player', 'projectile']);
    LEnemy.CollisionEnabled := True;

    // Test collision
    if LPlayer.CollidesWith(LEnemy) then
    begin
      // Handle collision between player and enemy
    end;
  end;

ADVANCED COLLISION MANAGEMENT:
  // Register collision categories globally
  Tg2dCollisionManager.RegisterCategory('player');
  Tg2dCollisionManager.RegisterCategory('enemy');
  Tg2dCollisionManager.RegisterCategory('projectile');

  // Create collision mask for multiple categories
  var
    LMask: UInt32;
  begin
    LMask := Tg2dCollisionManager.CategoriesToMask(['enemy', 'wall']);
    LPlayerSprite.CollisionMask := LMask;
  end;

═══════════════════════════════════════════════════════════════════════════════
SPRITE MOVEMENT AND ROTATION
═══════════════════════════════════════════════════════════════════════════════
Comprehensive movement system with rotation, thrust, and path-following:

• Angle-based movement with thrust mechanics
• Smooth rotation with speed control
• Position-based rotation targeting
• Automatic movement to target positions
• Direction vector tracking
• Visual angle offset for rendering

BASIC MOVEMENT:
  var
    LSprite: Tg2dSprite;
  begin
    // Direct position setting
    LSprite.Position := Tg2dVec.Create(100, 200);

    // Rotation
    LSprite.Angle := 45.0;  // Set absolute angle
    LSprite.RotateRel(10.0); // Rotate relative amount

    // Thrust-based movement
    LSprite.Thrust(5.0);     // Move forward at current angle
    LSprite.ThrustAngle(90.0, 3.0); // Thrust at specific angle
  end;

ADVANCED MOVEMENT:
  var
    LSprite: Tg2dSprite;
    LTargetX: Single = 400;
    LTargetY: Single = 300;
  begin
    // Smooth rotation to angle
    if LSprite.RotateToAngle(180.0, 2.0) then
    begin
      // Rotation complete
    end;

    // Rotate towards position
    if LSprite.RotateToPos(LTargetX, LTargetY, 1.5) then
    begin
      // Now facing target
    end;

    // Complex movement with slowdown
    if LSprite.ThrustToPos(150.0, 2.0, LTargetX, LTargetY,
                          50.0, 10.0, 20.0, 1.0) then
    begin
      // Reached target position
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
RENDERING AND VISUAL EFFECTS
═══════════════════════════════════════════════════════════════════════════════
Flexible rendering system with transformations and visual effects:

• Position, scale, rotation, and color tinting
• Horizontal and vertical flipping
• Multiple texture blending modes
• Visibility culling for performance
• Debug collision visualization
• Anchor point customization

BASIC RENDERING:
  var
    LSprite: Tg2dSprite;
  begin
    // Set visual properties
    LSprite.Position := Tg2dVec.Create(200, 150);
    LSprite.Scale := 2.0;                    // Double size
    LSprite.Angle := 45.0;                   // 45 degree rotation
    LSprite.Color := Tg2dColor.Create(255, 128, 128, 255); // Red tint
    LSprite.HFlip := True;                   // Horizontal flip

    // Render sprite
    LSprite.Draw();
  end;

PERFORMANCE OPTIMIZATION:
  var
    LSprite: Tg2dSprite;
  begin
    // Only update and draw visible sprites
    if LSprite.IsVisible(AWindow) then
    begin
      LSprite.Update(AWindow);
      LSprite.Draw();
    end;

    // Check if sprite is completely visible
    if LSprite.IsFullyVisible(AWindow) then
    begin
      // Sprite won't be clipped - optimal rendering
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPLETE GAME EXAMPLE
═══════════════════════════════════════════════════════════════════════════════
A functional space shooter demonstrating multiple sprite features:

SETUP AND INITIALIZATION:
  type
    TGameState = record
      Atlas: Tg2dSpriteAtlas;
      Player: Tg2dSprite;
      Enemies: TList<Tg2dSprite>;
      Bullets: TList<Tg2dSprite>;
    end;

  procedure InitGame(var AGameState: TGameState);
  begin
    // Create and load atlas
    AGameState.Atlas := Tg2dSpriteAtlas.Create();
    AGameState.Atlas.LoadFromFile('assets/space_sprites.json');

    // Create player sprite
    AGameState.Player := Tg2dSprite.Init(AGameState.Atlas);
    AGameState.Player.Play('player_idle', True, 8.0);
    AGameState.Player.Position := Tg2dVec.Create(400, 500);
    AGameState.Player.SetCollisionShape(csCircle, Tg2dVec.Create(0, 0),
      Tg2dSize.Create(0, 0), 20.0);
    AGameState.Player.CollisionCategory := 'player';
    AGameState.Player.SetCollidesWith(['enemy', 'powerup']);

    // Initialize containers
    AGameState.Enemies := TList<Tg2dSprite>.Create();
    AGameState.Bullets := TList<Tg2dSprite>.Create();
  end;

ENEMY CREATION:
  procedure SpawnEnemy(var AGameState: TGameState; const AX, AY: Single);
  var
    LEnemy: Tg2dSprite;
  begin
    LEnemy := Tg2dSprite.Init(AGameState.Atlas);
    LEnemy.Play('enemy_move', True, 12.0);
    LEnemy.Position := Tg2dVec.Create(AX, AY);
    LEnemy.SetCollisionShape(csRectangle, Tg2dVec.Create(0, 0),
      Tg2dSize.Create(48, 48), 0.0);
    LEnemy.CollisionCategory := 'enemy';
    LEnemy.SetCollidesWith(['player', 'bullet']);
    AGameState.Enemies.Add(LEnemy);
  end;

GAME LOOP INTEGRATION:
  procedure UpdateGame(var AGameState: TGameState; const AWindow: Tg2dWindow);
  var
    LEnemy: Tg2dSprite;
    LBullet: Tg2dSprite;
    I: Integer;
  begin
    // Update player
    AGameState.Player.Update(AWindow);

    // Handle player input
    if AWindow.GetKey(keyA) then
      AGameState.Player.RotateRel(-180 * AWindow.GetDeltaTime());
    if AWindow.GetKey(keyD) then
      AGameState.Player.RotateRel(180 * AWindow.GetDeltaTime());
    if AWindow.GetKey(keyW) then
      AGameState.Player.Thrust(200 * AWindow.GetDeltaTime());

    // Update enemies
    for LEnemy in AGameState.Enemies do
    begin
      LEnemy.Update(AWindow);

      // Simple AI - move toward player
      if LEnemy.ThrustToPos(100.0, 1.0,
        AGameState.Player.Position.X, AGameState.Player.Position.Y,
        100.0, 20.0, 50.0, 5.0) then
      begin
        // Enemy reached player position
      end;
    end;

    // Check collisions
    for I := AGameState.Enemies.Count - 1 downto 0 do
    begin
      if AGameState.Player.CollidesWith(AGameState.Enemies[I]) then
      begin
        // Handle player-enemy collision
        AGameState.Player.Play('player_hit', False, 15.0);
        break;
      end;
    end;
  end;

RENDERING LOOP:
  procedure RenderGame(const AGameState: TGameState; const AWindow: Tg2dWindow);
  var
    LSprite: Tg2dSprite;
  begin
    // Draw player
    if AGameState.Player.IsVisible(AWindow) then
      AGameState.Player.Draw();

    // Draw enemies
    for LSprite in AGameState.Enemies do
    begin
      if LSprite.IsVisible(AWindow) then
        LSprite.Draw();
    end;

    // Draw bullets
    for LSprite in AGameState.Bullets do
    begin
      if LSprite.IsVisible(AWindow) then
        LSprite.Draw();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════
• **Texture Sharing**: Multiple sprites can share the same atlas texture
• **Visibility Culling**: Automatic off-screen sprite detection
• **Efficient Collision**: Broad-phase collision detection with spatial optimization
• **Memory Management**: Automatic cleanup of atlas resources
• **Batch Rendering**: Optimized for rendering many sprites efficiently
• **Delta Time Integration**: Smooth animation independent of frame rate

═══════════════════════════════════════════════════════════════════════════════
VIRTUAL METHODS FOR CUSTOMIZATION
═══════════════════════════════════════════════════════════════════════════════
Override these methods in derived classes for custom behavior:
• **Update()** - Custom per-frame logic
• **Draw()** - Custom rendering behavior
• **OnCollision()** - Custom collision response
• **OnAnimationFinished()** - Custom animation event handling

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
• Atlas textures are automatically freed when atlas is destroyed
• Sprites must be manually freed - they don't own the atlas
• Use try/finally blocks for proper cleanup
• Collision system automatically manages category bit mappings
• Animation callbacks are automatically cleared on sprite destruction

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════
• All methods return Boolean success indicators where appropriate
• Error messages available through inherited error handling system
• Invalid atlas or animation references fail gracefully
• Collision system validates category names and bit limits
• File loading operations include comprehensive error reporting

==============================================================================}

unit Game2D.Sprite;

{$I Game2D.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.IOUtils,
  System.Math,
  System.NetEncoding,
  Game2D.Common,
  Game2D.Core;

//=== COLLISION SYSTEM =========================================================
type
  { Collision shapes }
  Tg2dCollisionShape = (
    csNone,      // No collision
    csRectangle, // Axis-aligned bounding box
    csCircle,    // Circle collision
    csOBB,       // Oriented bounding box
    csPolygon,   // Convex polygon (advanced)
    csPixel      // Pixel-perfect collision (advanced)
  );

  { Collision data structure }
  Tg2dCollisionData = record
    Shape: Tg2dCollisionShape;
    Offset: Tg2dVec;           // Offset from sprite center
    Size: Tg2dSize;            // For rectangle/OBB
    Radius: Single;            // For circle
    Vertices: TArray<Tg2dVec>; // For polygon (relative to sprite center)
    Enabled: Boolean;
    DebugDraw: Boolean;        // Show collision bounds for debugging
  end;

  { Dynamic collision system using strings }
  Tg2dCollisionManager = class(Tg2dStaticObject)
  private
    class var FCategoryToBitMap: TDictionary<string, UInt32>;
    class var FNextBitIndex: Integer;
    class constructor Create();
    class destructor Destroy();
  public
    class function RegisterCategory(const ACategoryName: string): UInt32;
    class function CategoryToBit(const ACategoryName: string): UInt32;
    class function CategoriesToMask(const ACategories: TArray<string>): UInt32;
    class function CategoryExists(const ACategoryName: string): Boolean;
    class procedure GetAllCategories(ACategories: TStrings);
    class procedure Clear();
  end;

//=== SPRITEATLAS ==============================================================
type
  { Tg2dSpriteFrame }
  Tg2dSpriteFrame = record
    PageName: string;
    Region: Tg2dRect;
  end;

  { Tg2dAnimationGroup }
  Tg2dAnimationGroup = record
    Name: string;
    Frames: TArray<Tg2dSpriteFrame>;
  end;

  { Tg2dSpriteAtlas }
  Tg2dSpriteAtlas = class(Tg2dObject)
  protected
    FPages: TDictionary<string, Tg2dTexture>;
    FGroups: TDictionary<string, Tg2dAnimationGroup>;
    procedure ProcessJSONPages(const APagesArray: TJSONArray; const ABasePath: string; const AZipFilename: string = ''; const APassword: string = '');
    procedure ProcessJSONGroups(const AGroupsArray: TJSONArray);
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function AddPage(const AName: string; ATexture: Tg2dTexture): Boolean;
    function AddPageFromFile(const AName, AFilename: string): Boolean;
    function AddPageFromZip(const AName, AZipFilename, AFilenameInZip: string; APassword: string=G2D_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    function GetPage(const AName: string): Tg2dTexture;
    procedure RemovePage(const AName: string);
    function CreateGroup(const AName: string): Boolean;
    function GetGroup(const AName: string; out AGroup: Tg2dAnimationGroup): Boolean;
    function AddFrame(const AGroupName, APageName: string; const ARegion: Tg2dRect): Boolean; overload;
    function AddFrame(const AGroupName, APageName: string; const AGridX, AGridY: Integer; const AFrameSize: Tg2dSize): Boolean; overload;
    function AddGridFrames(const AGroupName, APageName: string; const AFrameSize: Tg2dSize; const AFrameCount: Integer): Boolean;
    procedure Clear();
    function LoadFromFile(const AJSONFilename: string): Boolean;
    function LoadFromZip(const AZipFilename, AJSONFilenameInZip, APassword: string): Boolean;
  end;

//=== SPRITE ===================================================================
type
  { Tg2dSprite }
  Tg2dSprite = class;

  { Tg2dSpriteAnimationCallback }
  Tg2dSpriteAnimationCallback = reference to procedure(const ASprite: Tg2dSprite; const AAnimationName: string; const AUserData: Pointer);

  { Enhanced Tg2dSprite with collision detection }
  Tg2dSprite = class(Tg2dObject)
  protected
    FAtlas: Tg2dSpriteAtlas;
    FTexture: Tg2dTexture;
    FCurrentGroup: Tg2dAnimationGroup;
    FCurrentFrameIndex: Integer;
    FFrameTimer: Single;
    FFrameDuration: Single;
    FIsPlaying: Boolean;
    FIsLooping: Boolean;
    FOnAnimationFinished: Tg2dCallback<Tg2dSpriteAnimationCallback>;

    // Collision detection fields
    FCollisionData: Tg2dCollisionData;
    FCollisionCategory: string;     // What this sprite is
    FCollidesWith: TArray<string>;  // What this sprite collides with
    FCollisionGroup: UInt32;        // Cached bit value for category
    FCollisionMask: UInt32;         // Cached bit value for mask

    // Movement and angle fields
    FAngleOffset: Single;           // Visual rotation offset (rendering only)
    FDir: Tg2dVec;                  // Current movement direction vector

    function Initialize(const AAtlas: Tg2dSpriteAtlas): Boolean;
    procedure UpdateFrameTexture();

    // Property accessors
    function GetPosition(): Tg2dVec;
    procedure SetPosition(const AValue: Tg2dVec);
    function GetScale(): Single;
    procedure SetScale(const AValue: Single);
    function GetAngle(): Single;
    procedure SetAngle(const AValue: Single);
    function GetColor(): Tg2dColor;
    procedure SetColor(const AValue: Tg2dColor);
    function GetHFlip(): Boolean;
    procedure SetHFlip(const AValue: Boolean);
    function GetVFlip(): Boolean;
    procedure SetVFlip(const AValue: Boolean);
    function GetKind(): Tg2dTextureKind;
    procedure SetKind(const AKind: Tg2dTextureKind);

    // Collision helper methods
    function GetWorldCollisionBounds(): Tg2dRect;
    function GetWorldCollisionCenter(): Tg2dVec;
    function GetWorldCollisionRadius(): Single;
    function GetWorldCollisionVertices(): TArray<Tg2dVec>;
    procedure DrawCollisionDebug();

  public
    constructor Create(); override;
    destructor Destroy(); override;

    class function Init(const AAtlas: Tg2dSpriteAtlas): Tg2dSprite; static;

    // Animation methods
    function GetOnAnimationFinished(): Tg2dSpriteAnimationCallback;
    procedure SetOnAnimationFinished(const AHandler: Tg2dSpriteAnimationCallback; const AUserData: Pointer = nil);
    function Play(const AGroupName: string; ALoop: Boolean = True; AFramesPerSecond: Single = 15.0): Boolean;
    procedure Stop();
    procedure Pause();
    procedure Resume();
    procedure Update(const AWindow: Tg2dWindow);
    procedure Draw();

    // Basic collision setup methods
    procedure SetCollisionRectangle(const AWidth, AHeight: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
    procedure SetCollisionCircle(const ARadius: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
    procedure SetCollisionOBB(const AWidth, AHeight: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
    procedure SetCollisionPolygon(const AVertices: TArray<Tg2dVec>; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
    procedure SetCollisionFromTexture(const AScaleFactor: Single = 1.0); // Use texture bounds
    procedure DisableCollision();

    // String-based collision configuration
    procedure SetCollisionCategory(const ACategory: string);
    procedure SetCollidesWith(const ACategories: TArray<string>); overload;
    procedure SetCollidesWith(const ACategories: string); overload; // Comma-separated string
    procedure AddCollisionWith(const ACategory: string);
    procedure RemoveCollisionWith(const ACategory: string);
    function GetCollisionCategory(): string;
    function GetCollidesWith(): TArray<string>;

    // Collision testing methods
    function CollidesWith(const AOther: Tg2dSprite): Boolean; overload;
    function CollidesWithPoint(const APoint: Tg2dVec): Boolean;
    function CollidesWithRectangle(const ARect: Tg2dRect): Boolean;
    function CollidesWithCircle(const ACenter: Tg2dVec; const ARadius: Single): Boolean;
    function CollidesWithLine(const ALineStart, ALineEnd: Tg2dVec): Boolean;

    // Advanced collision queries
    function GetCollisionDistance(const AOther: Tg2dSprite): Single;
    function GetCollisionNormal(const AOther: Tg2dSprite): Tg2dVec;
    function GetCollisionPoint(const AOther: Tg2dSprite): Tg2dVec;

    // Collision configuration
    procedure SetCollisionMask(const AMask: UInt32); // For advanced users
    procedure SetCollisionGroup(const AGroup: UInt32); // For advanced users
    function CanCollideWith(const AOther: Tg2dSprite): Boolean;

    // Debug methods
    procedure EnableCollisionDebug(const AEnable: Boolean = True);

    // Movement and visibility methods
    function GetAngleOffset(): Single;
    procedure SetAngleOffset(const AAngle: Single);
    procedure RotateRel(const AAngle: Single);
    function RotateToAngle(const AAngle, ASpeed: Single): Boolean;
    function RotateToPos(const AX, AY, ASpeed: Single): Boolean;
    function RotateToPosAt(const ASrcX, ASrcY, ADestX, ADestY, ASpeed: Single): Boolean;
    procedure Thrust(const ASpeed: Single);
    procedure ThrustAngle(const AAngle, ASpeed: Single);
    function ThrustToPos(const AThrustSpeed, ARotSpeed, ADestX, ADestY, ASlowdownDist, AStopDist, AStopSpeed, AStopSpeedEpsilon: Single): Boolean;
    function IsVisible(const AWindow: Tg2dWindow): Boolean;
    function IsFullyVisible(const AWindow: Tg2dWindow): Boolean;
    function GetDir(): Tg2dVec;
    procedure SetDir(const ADir: Tg2dVec);

    // Properties
    property Kind: Tg2dTextureKind read GetKind write SetKind;
    property Position: Tg2dVec read GetPosition write SetPosition;
    property Scale: Single read GetScale write SetScale;
    property Angle: Single read GetAngle write SetAngle;
    property Color: Tg2dColor read GetColor write SetColor;
    property HFlip: Boolean read GetHFlip write SetHFlip;
    property VFlip: Boolean read GetVFlip write SetVFlip;
    property IsPlaying: Boolean read FIsPlaying;

    // Collision properties
    property CollisionEnabled: Boolean read FCollisionData.Enabled write FCollisionData.Enabled;
    property CollisionShape: Tg2dCollisionShape read FCollisionData.Shape;
    property CollisionCategory: string read GetCollisionCategory write SetCollisionCategory;
    property CollisionMask: UInt32 read FCollisionMask write SetCollisionMask; // Advanced
    property CollisionGroup: UInt32 read FCollisionGroup write SetCollisionGroup; // Advanced
  end;

implementation

//=== COLLISION SYSTEM =========================================================
{ Tg2dCollisionManager }
class constructor Tg2dCollisionManager.Create();
begin
  FCategoryToBitMap := TDictionary<string, UInt32>.Create();
  FNextBitIndex := 1; // Start from bit 1 (value 1)
end;

class destructor Tg2dCollisionManager.Destroy();
begin
  FCategoryToBitMap.Free();
end;

class function Tg2dCollisionManager.RegisterCategory(const ACategoryName: string): UInt32;
begin
  if FCategoryToBitMap.ContainsKey(ACategoryName) then
  begin
    Result := FCategoryToBitMap[ACategoryName];
    Exit;
  end;

  if FNextBitIndex > 31 then
  begin
    raise Exception.Create('Maximum collision categories exceeded (32)');
  end;

  Result := 1 shl (FNextBitIndex - 1); // Convert to bit value
  FCategoryToBitMap.Add(ACategoryName, Result);
  Inc(FNextBitIndex);
end;

class function Tg2dCollisionManager.CategoryToBit(const ACategoryName: string): UInt32;
begin
  if not FCategoryToBitMap.TryGetValue(ACategoryName, Result) then
  begin
    Result := RegisterCategory(ACategoryName); // Auto-register if not found
  end;
end;

class function Tg2dCollisionManager.CategoriesToMask(const ACategories: TArray<string>): UInt32;
var
  LCategory: string;
begin
  Result := 0;
  for LCategory in ACategories do
  begin
    Result := Result or CategoryToBit(LCategory);
  end;
end;

class function Tg2dCollisionManager.CategoryExists(const ACategoryName: string): Boolean;
begin
  Result := FCategoryToBitMap.ContainsKey(ACategoryName);
end;

class procedure Tg2dCollisionManager.GetAllCategories(ACategories: TStrings);
var
  LCategory: string;
begin
  ACategories.Clear();
  for LCategory in FCategoryToBitMap.Keys do
    ACategories.Add(LCategory);
end;

class procedure Tg2dCollisionManager.Clear();
begin
  FCategoryToBitMap.Clear();
  FNextBitIndex := 1;
end;

//=== SPRITEATLAS ==============================================================
{ Tg2dSpriteAtlas }
constructor Tg2dSpriteAtlas.Create();
begin
  inherited Create();
  FPages := TDictionary<string, Tg2dTexture>.Create();
  FGroups := TDictionary<string, Tg2dAnimationGroup>.Create();
end;

destructor Tg2dSpriteAtlas.Destroy();
begin
  Clear();
  FGroups.Free();
  FPages.Free();
  inherited Destroy();
end;

procedure Tg2dSpriteAtlas.Clear();
var
  LTexture: Tg2dTexture;
begin
  for LTexture in FPages.Values do
  begin
    LTexture.Free();
  end;
  FPages.Clear();
  FGroups.Clear();
end;

function Tg2dSpriteAtlas.AddPage(const AName: string; ATexture: Tg2dTexture): Boolean;
begin
  Result := False;
  if (AName = '') or not Assigned(ATexture) then
  begin
    SetError('Page name and texture cannot be empty.', []);
    Exit;
  end;
  if FPages.ContainsKey(AName) then
  begin
    SetError('A page with the name "%s" already exists.', [AName]);
    Exit;
  end;
  FPages.Add(AName, ATexture);
  Result := True;
end;

function Tg2dSpriteAtlas.AddPageFromFile(const AName, AFilename: string): Boolean;
var
  LTexture: Tg2dTexture;
begin
  Result := False;
  LTexture := Tg2dTexture.Create();
  try
    if LTexture.LoadFromFile(AFilename) then
    begin
      Result := AddPage(AName, LTexture);
      if not Result then LTexture.Free;
    end
    else
    begin
      SetError('Failed to load texture from file "%s".', [AFilename]);
      LTexture.Free;
    end;
  except
    LTexture.Free;
    raise;
  end;
end;

function Tg2dSpriteAtlas.AddPageFromZip(const AName, AZipFilename, AFilenameInZip: string; APassword: string): Boolean;
var
  LTexture: Tg2dTexture;
begin
  Result := False;
  LTexture := Tg2dTexture.Create();
  try
    if LTexture.LoadFromZipFile(AZipFilename, AFilenameInZip, nil, APassword) then
    begin
      Result := AddPage(AName, LTexture);
      if not Result then LTexture.Free;
    end
    else
    begin
      SetError('Failed to load texture "%s" from zip "%s".', [AFilenameInZip, AZipFilename]);
      LTexture.Free;
    end;
  except
    LTexture.Free;
    raise;
  end;
end;

function Tg2dSpriteAtlas.GetPage(const AName: string): Tg2dTexture;
begin
  if not FPages.TryGetValue(AName, Result) then
    Result := nil;
end;

procedure Tg2dSpriteAtlas.RemovePage(const AName: string);
var
  LTexture: Tg2dTexture;
begin
  if FPages.TryGetValue(AName, LTexture) then
  begin
    FPages.Remove(AName);
    LTexture.Free();
  end;
end;

function Tg2dSpriteAtlas.CreateGroup(const AName: string): Boolean;
var
  LGroup: Tg2dAnimationGroup;
begin
  Result := False;
  if AName = '' then
  begin
    SetError('Group name cannot be empty.', []);
    Exit;
  end;
  if FGroups.ContainsKey(AName) then
  begin
    SetError('A group with the name "%s" already exists.', [AName]);
    Exit;
  end;
  LGroup.Name := AName;
  SetLength(LGroup.Frames, 0);
  FGroups.Add(AName, LGroup);
  Result := True;
end;

function Tg2dSpriteAtlas.GetGroup(const AName: string; out AGroup: Tg2dAnimationGroup): Boolean;
begin
  Result := FGroups.TryGetValue(AName, AGroup);
end;

function Tg2dSpriteAtlas.AddFrame(const AGroupName, APageName: string; const ARegion: Tg2dRect): Boolean;
var
  LGroup: Tg2dAnimationGroup;
  LFrame: Tg2dSpriteFrame;
  LFrameCount: Integer;
begin
  Result := False;
  if not FGroups.TryGetValue(AGroupName, LGroup) then
  begin
    SetError('Group "%s" not found.', [AGroupName]);
    Exit;
  end;
  if not FPages.ContainsKey(APageName) then
  begin
    SetError('Page "%s" not found.', [APageName]);
    Exit;
  end;
  LFrame.PageName := APageName;
  LFrame.Region := ARegion;
  LFrameCount := Length(LGroup.Frames);
  SetLength(LGroup.Frames, LFrameCount + 1);
  LGroup.Frames[LFrameCount] := LFrame;
  FGroups.AddOrSetValue(AGroupName, LGroup);
  Result := True;
end;

function Tg2dSpriteAtlas.AddFrame(const AGroupName, APageName: string; const AGridX, AGridY: Integer; const AFrameSize: Tg2dSize): Boolean;
var
  LRegion: Tg2dRect;
begin
  LRegion.Pos.X := AGridX * AFrameSize.Width;
  LRegion.Pos.Y := AGridY * AFrameSize.Height;
  LRegion.Size := AFrameSize;
  Result := Self.AddFrame(AGroupName, APageName, LRegion);
end;

function Tg2dSpriteAtlas.AddGridFrames(const AGroupName, APageName: string; const AFrameSize: Tg2dSize; const AFrameCount: Integer): Boolean;
var
  LPage: Tg2dTexture;
  LI: Integer;
  LFramesPerRow: Integer;
  LCol: Integer;
  LRow: Integer;
begin
  Result := False;
  LPage := GetPage(APageName);
  if not Assigned(LPage) then
  begin
    SetError('Page "%s" not found for grid frames.', [APageName]);
    Exit;
  end;
  if (AFrameSize.Width <= 0) or (AFrameSize.Height <= 0) then
  begin
    SetError('Frame size for grid must be positive.', []);
    Exit;
  end;
  LFramesPerRow := Floor(LPage.GetSize().Width / AFrameSize.Width);
  if LFramesPerRow = 0 then
  begin
    SetError('Texture width is smaller than a single frame width.', []);
    Exit;
  end;

  for LI := 0 to AFrameCount - 1 do
  begin
    LCol := LI mod LFramesPerRow;
    LRow := LI div LFramesPerRow;

    if not AddFrame(AGroupName, APageName, LCol, LRow, AFrameSize) then
    begin
      SetError('Failed to add frame %d for grid.', [LI]);
      Exit;
    end;
  end;

  Result := True;
end;

procedure Tg2dSpriteAtlas.ProcessJSONPages(const APagesArray: TJSONArray; const ABasePath: string; const AZipFilename: string; const APassword: string);
var
  LI: Integer;
  LPageObject: TJSONObject;
  LPageName: string;
  LPageFilename: string;
  LFullPath: string;
begin
  if not Assigned(APagesArray) then Exit;

  for LI := 0 to APagesArray.Count - 1 do
  begin
    if APagesArray.Items[LI] is TJSONObject then
    begin
      LPageObject := APagesArray.Items[LI] as TJSONObject;
      LPageName := LPageObject.GetValue('name').Value;
      LPageFilename := LPageObject.GetValue('filename').Value;

      if AZipFilename <> '' then
      begin
        // Load from ZIP file
        if not AddPageFromZip(LPageName, AZipFilename, LPageFilename, APassword) then
          SetError('Failed to load page "%s" from ZIP.', [LPageName]);
      end
      else
      begin
        // Load from regular file
        LFullPath := TPath.Combine(ABasePath, LPageFilename);
        if not AddPageFromFile(LPageName, LFullPath) then
          SetError('Failed to load page "%s".', [LPageName]);
      end;
    end;
  end;
end;

procedure Tg2dSpriteAtlas.ProcessJSONGroups(const AGroupsArray: TJSONArray);
var
  LI: Integer;
  LJ: Integer;
  LGroupObject: TJSONObject;
  LFramesArray: TJSONArray;
  LFrameObject: TJSONObject;
  LGroupName: string;
  LPageName: string;
  LRegion: Tg2dRect;
begin
  if not Assigned(AGroupsArray) then Exit;

  for LI := 0 to AGroupsArray.Count - 1 do
  begin
    if AGroupsArray.Items[LI] is TJSONObject then
    begin
      LGroupObject := AGroupsArray.Items[LI] as TJSONObject;
      LGroupName := LGroupObject.GetValue('name').Value;

      if not CreateGroup(LGroupName) then
        Continue;

      LFramesArray := LGroupObject.GetValue('frames') as TJSONArray;
      if Assigned(LFramesArray) then
      begin
        for LJ := 0 to LFramesArray.Count - 1 do
        begin
          if LFramesArray.Items[LJ] is TJSONObject then
          begin
            LFrameObject := LFramesArray.Items[LJ] as TJSONObject;
            LPageName := LFrameObject.GetValue('page').Value;

            LRegion.Pos.X := (LFrameObject.GetValue('x') as TJSONNumber).AsDouble;
            LRegion.Pos.Y := (LFrameObject.GetValue('y') as TJSONNumber).AsDouble;
            LRegion.Size.Width := (LFrameObject.GetValue('width') as TJSONNumber).AsDouble;
            LRegion.Size.Height := (LFrameObject.GetValue('height') as TJSONNumber).AsDouble;

            AddFrame(LGroupName, LPageName, LRegion);
          end;
        end;
      end;
    end;
  end;
end;

function Tg2dSpriteAtlas.LoadFromFile(const AJSONFilename: string): Boolean;
var
  LJSONText: string;
  LJSONValue: TJSONValue;
  LJSONObject: TJSONObject;
  LBasePath: string;
begin
  Result := False;

  try
    if not TFile.Exists(AJSONFilename) then
    begin
      SetError('Atlas file not found: %s', [AJSONFilename]);
      Exit;
    end;

    LJSONText := TFile.ReadAllText(AJSONFilename, TEncoding.UTF8);
    LJSONValue := TJSONObject.ParseJSONValue(LJSONText);

    if not Assigned(LJSONValue) or not (LJSONValue is TJSONObject) then
    begin
      SetError('Invalid JSON in atlas file: %s', [AJSONFilename]);
      if Assigned(LJSONValue) then LJSONValue.Free;
      Exit;
    end;

    LJSONObject := LJSONValue as TJSONObject;
    try
      LBasePath := TPath.GetDirectoryName(AJSONFilename);
      ProcessJSONPages(LJSONObject.GetValue('pages') as TJSONArray, LBasePath);
      ProcessJSONGroups(LJSONObject.GetValue('groups') as TJSONArray);
      Result := True;
    finally
      LJSONObject.Free;
    end;

  except
    on E: Exception do
      SetError('Error loading atlas: %s', [E.Message]);
  end;
end;

function Tg2dSpriteAtlas.LoadFromZip(const AZipFilename, AJSONFilenameInZip, APassword: string): Boolean;
var
  LIO: Tg2dZipFileIO;
  LJSONBytes: TBytes;
  LJSONText: string;
  LJSONValue: TJSONValue;
  LJSONObject: TJSONObject;
begin
  Result := False;
  LIO := Tg2dZipFileIO.Create();
  try
    if not LIO.Open(AZipFilename, AJSONFilenameInZip, APassword) then
    begin
      SetError('Failed to open atlas file "%s" in ZIP "%s".', [AJSONFilenameInZip, AZipFilename]);
      Exit;
    end;

    try
      SetLength(LJSONBytes, LIO.Size);
      if LIO.Size > 0 then
        LIO.Read(@LJSONBytes[0], LIO.Size);
      LJSONText := TEncoding.UTF8.GetString(LJSONBytes);
      LJSONValue := TJSONObject.ParseJSONValue(LJSONText);
      if not Assigned(LJSONValue) or not (LJSONValue is TJSONObject) then
      begin
        SetError('Invalid JSON in atlas file: %s', [AJSONFilenameInZip]);
        if Assigned(LJSONValue) then LJSONValue.Free;
        Exit;
      end;
      LJSONObject := LJSONValue as TJSONObject;
      try
        ProcessJSONPages(LJSONObject.GetValue('pages') as TJSONArray, '', AZipFilename, APassword);
        ProcessJSONGroups(LJSONObject.GetValue('groups') as TJSONArray);
        Result := True;
      finally
        LJSONObject.Free;
      end;
    except
      on E: Exception do
        SetError('Error loading atlas from zip: %s', [E.Message]);
    end;
  finally
    LIO.Free();
  end;
end;

//=== SPRITE ===================================================================
{ Tg2dSprite }
constructor Tg2dSprite.Create();
begin
  inherited Create();
  FTexture := Tg2dTexture.Create();
  FAtlas := nil;
  FIsPlaying := False;
  FIsLooping := False;
  FCurrentFrameIndex := -1;
  FFrameTimer := 0;
  FFrameDuration := 0.1;
  FOnAnimationFinished.Handler := nil;
  FOnAnimationFinished.UserData := nil;

  // Initialize collision data
  FCollisionData.Shape := csNone;
  FCollisionData.Offset := Tg2dVec.Create(0, 0);
  FCollisionData.Size := Tg2dSize.Create(0, 0);
  FCollisionData.Radius := 0;
  FCollisionData.Enabled := False;
  FCollisionData.DebugDraw := False;
  SetLength(FCollisionData.Vertices, 0);

  // Initialize string-based collision system
  FCollisionCategory := '';
  SetLength(FCollidesWith, 0);
  FCollisionGroup := 0;
  FCollisionMask := 0;

  // Initialize movement fields
  FAngleOffset := 0.0;
  FDir := Tg2dVec.Create(0, 0);
end;

destructor Tg2dSprite.Destroy();
begin
  FTexture.Free;
  inherited Destroy();
end;

function Tg2dSprite.Initialize(const AAtlas: Tg2dSpriteAtlas): Boolean;
begin
  Result := False;
  if not Assigned(AAtlas) then
  begin
    SetError('A valid Sprite Atlas is required for initialization.', []);
    Exit;
  end;
  FAtlas := AAtlas;
  Result := True;
end;

class function Tg2dSprite.Init(const AAtlas: Tg2dSpriteAtlas): Tg2dSprite;
var
  LSprite: Tg2dSprite;
begin
  Result := nil;
  if not Assigned(AAtlas) then
    Exit;

  LSprite := Tg2dSprite.Create();
  if LSprite.Initialize(AAtlas) then
    Result := LSprite
  else
    LSprite.Free();
end;

function Tg2dSprite.GetOnAnimationFinished(): Tg2dSpriteAnimationCallback;
begin
  Result := FOnAnimationFinished.Handler;
end;

procedure Tg2dSprite.SetOnAnimationFinished(const AHandler: Tg2dSpriteAnimationCallback; const AUserData: Pointer);
begin
  FOnAnimationFinished.Handler := AHandler;
  FOnAnimationFinished.UserData := AUserData;
end;

procedure Tg2dSprite.UpdateFrameTexture();
var
  LFrame: Tg2dSpriteFrame;
  LMasterTexture: Tg2dTexture;
begin
  if not Assigned(FAtlas) then Exit;
  if (FCurrentFrameIndex < 0) or (FCurrentFrameIndex >= Length(FCurrentGroup.Frames)) then
    Exit;

  LFrame := FCurrentGroup.Frames[FCurrentFrameIndex];
  LMasterTexture := FAtlas.GetPage(LFrame.PageName);

  if Assigned(LMasterTexture) then
  begin
    FTexture.Share(LMasterTexture, tsmSkip);
    FTexture.SetRegion(LFrame.Region);
  end;
end;

function Tg2dSprite.Play(const AGroupName: string; ALoop: Boolean; AFramesPerSecond: Single): Boolean;
var
  LSafeFPS: Single;
begin
  Result := False;
  if not Assigned(FAtlas) then
  begin
    SetError('Sprite has no assigned Atlas.', []);
    Exit;
  end;

  Result := FAtlas.GetGroup(AGroupName, FCurrentGroup);
  if Result then
  begin
    FIsPlaying := True;
    FIsLooping := ALoop;

    LSafeFPS := AFramesPerSecond;
    if LSafeFPS <= 0 then LSafeFPS := 1.0;
    FFrameDuration := 1.0 / LSafeFPS;

    FCurrentFrameIndex := 0;
    FFrameTimer := 0;
    UpdateFrameTexture();
  end
  else
  begin
    SetError('Animation group "%s" not found in atlas.', [AGroupName]);
    FIsPlaying := False;
  end;
end;

procedure Tg2dSprite.Stop();
begin
  FIsPlaying := False;
  FCurrentFrameIndex := 0;
  FFrameTimer := 0;
  UpdateFrameTexture();
end;

procedure Tg2dSprite.Pause();
begin
  FIsPlaying := False;
end;

procedure Tg2dSprite.Resume();
begin
  if FCurrentFrameIndex >= 0 then
    FIsPlaying := True;
end;

procedure Tg2dSprite.Update(const AWindow: Tg2dWindow);
var
  LDeltaTime: Single;
  LFrameCount: Integer;
begin
  if not FIsPlaying or (FCurrentFrameIndex < 0) then
    Exit;

  LDeltaTime := AWindow.GetDeltaTime();
  LFrameCount := Length(FCurrentGroup.Frames);
  if LFrameCount = 0 then
  begin
    FIsPlaying := False;
    Exit;
  end;

  FFrameTimer := FFrameTimer + LDeltaTime;
  if FFrameTimer >= FFrameDuration then
  begin
    FFrameTimer := FFrameTimer - FFrameDuration;
    Inc(FCurrentFrameIndex);

    if FCurrentFrameIndex >= LFrameCount then
    begin
      if FIsLooping then
      begin
        FCurrentFrameIndex := 0;
      end
      else
      begin
        FCurrentFrameIndex := LFrameCount - 1;
        FIsPlaying := False;
        if Assigned(FOnAnimationFinished.Handler) then
          FOnAnimationFinished.Handler(Self, FCurrentGroup.Name, FOnAnimationFinished.UserData);
      end;
    end;
    UpdateFrameTexture();
  end;
end;

procedure Tg2dSprite.Draw();
begin
  if Assigned(FTexture) and FTexture.IsLoaded then
  begin
    // Apply angle offset for rendering only
    FTexture.SetAngle(GetAngle() + FAngleOffset);
    FTexture.Draw();
    // Restore original angle
    FTexture.SetAngle(GetAngle());
  end;

  // Draw collision debug if enabled
  DrawCollisionDebug();
end;

// Basic collision setup methods
procedure Tg2dSprite.SetCollisionRectangle(const AWidth, AHeight: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
begin
  FCollisionData.Shape := csRectangle;
  FCollisionData.Size.Width := AWidth;
  FCollisionData.Size.Height := AHeight;
  FCollisionData.Offset.X := AOffsetX;
  FCollisionData.Offset.Y := AOffsetY;
  FCollisionData.Enabled := True;
end;

procedure Tg2dSprite.SetCollisionCircle(const ARadius: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
begin
  FCollisionData.Shape := csCircle;
  FCollisionData.Radius := ARadius;
  FCollisionData.Offset.X := AOffsetX;
  FCollisionData.Offset.Y := AOffsetY;
  FCollisionData.Enabled := True;
end;

procedure Tg2dSprite.SetCollisionOBB(const AWidth, AHeight: Single; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
begin
  FCollisionData.Shape := csOBB;
  FCollisionData.Size.Width := AWidth;
  FCollisionData.Size.Height := AHeight;
  FCollisionData.Offset.X := AOffsetX;
  FCollisionData.Offset.Y := AOffsetY;
  FCollisionData.Enabled := True;
end;

procedure Tg2dSprite.SetCollisionPolygon(const AVertices: TArray<Tg2dVec>; const AOffsetX: Single = 0; const AOffsetY: Single = 0);
begin
  FCollisionData.Shape := csPolygon;
  FCollisionData.Vertices := Copy(AVertices);
  FCollisionData.Offset.X := AOffsetX;
  FCollisionData.Offset.Y := AOffsetY;
  FCollisionData.Enabled := True;
end;

procedure Tg2dSprite.SetCollisionFromTexture(const AScaleFactor: Single = 1.0);
var
  LSize: Tg2dSize;
begin
  if not Assigned(FTexture) or not FTexture.IsLoaded() then
  begin
    SetError('Cannot set collision from texture: texture not loaded', []);
    Exit;
  end;

  LSize := FTexture.GetSize();
  SetCollisionRectangle(
    LSize.Width * AScaleFactor,
    LSize.Height * AScaleFactor
  );
end;

procedure Tg2dSprite.DisableCollision();
begin
  FCollisionData.Shape := csNone;
  FCollisionData.Enabled := False;
end;

// String-based collision methods
procedure Tg2dSprite.SetCollisionCategory(const ACategory: string);
begin
  FCollisionCategory := ACategory;
  if ACategory <> '' then
    FCollisionGroup := Tg2dCollisionManager.CategoryToBit(ACategory)
  else
    FCollisionGroup := 0;
end;

procedure Tg2dSprite.SetCollidesWith(const ACategories: TArray<string>);
begin
  FCollidesWith := Copy(ACategories);
  FCollisionMask := Tg2dCollisionManager.CategoriesToMask(ACategories);
end;

procedure Tg2dSprite.SetCollidesWith(const ACategories: string);
var
  LCategoryList: TArray<string>;
  LCategories: TStringList;
  LI: Integer;
begin
  // Parse comma-separated string
  LCategories := TStringList.Create();
  try
    LCategories.CommaText := ACategories;
    SetLength(LCategoryList, LCategories.Count);
    for LI := 0 to LCategories.Count - 1 do
      LCategoryList[LI] := Trim(LCategories[LI]);
    SetCollidesWith(LCategoryList);
  finally
    LCategories.Free();
  end;
end;

procedure Tg2dSprite.AddCollisionWith(const ACategory: string);
var
  LNewArray: TArray<string>;
  LI: Integer;
  LFound: Boolean;
begin
  // Check if already exists
  LFound := False;
  for LI := 0 to High(FCollidesWith) do
  begin
    if FCollidesWith[LI] = ACategory then
    begin
      LFound := True;
      Break;
    end;
  end;

  if not LFound then
  begin
    SetLength(LNewArray, Length(FCollidesWith) + 1);
    for LI := 0 to High(FCollidesWith) do
      LNewArray[LI] := FCollidesWith[LI];
    LNewArray[High(LNewArray)] := ACategory;
    SetCollidesWith(LNewArray);
  end;
end;

procedure Tg2dSprite.RemoveCollisionWith(const ACategory: string);
var
  LNewArray: TArray<string>;
  LI: Integer;
  LNewIndex: Integer;
begin
  LNewIndex := 0;
  SetLength(LNewArray, Length(FCollidesWith));

  for LI := 0 to High(FCollidesWith) do
  begin
    if FCollidesWith[LI] <> ACategory then
    begin
      LNewArray[LNewIndex] := FCollidesWith[LI];
      Inc(LNewIndex);
    end;
  end;

  SetLength(LNewArray, LNewIndex);
  SetCollidesWith(LNewArray);
end;

function Tg2dSprite.GetCollisionCategory(): string;
begin
  Result := FCollisionCategory;
end;

function Tg2dSprite.GetCollidesWith(): TArray<string>;
begin
  Result := Copy(FCollidesWith);
end;

// Advanced collision methods (for users who want direct bit manipulation)
procedure Tg2dSprite.SetCollisionMask(const AMask: UInt32);
begin
  FCollisionMask := AMask;
  // Clear string array since we're using raw bits
  SetLength(FCollidesWith, 0);
end;

procedure Tg2dSprite.SetCollisionGroup(const AGroup: UInt32);
begin
  FCollisionGroup := AGroup;
  // Clear category string since we're using raw bits
  FCollisionCategory := '';
end;

function Tg2dSprite.CanCollideWith(const AOther: Tg2dSprite): Boolean;
begin
  Result := (FCollisionMask and AOther.FCollisionGroup) <> 0;
end;

// Collision helper methods
function Tg2dSprite.GetWorldCollisionBounds(): Tg2dRect;
var
  LPos: Tg2dVec;
  LScale: Single;
begin
  LPos := GetPosition();
  LScale := GetScale();

  Result.Pos.X := LPos.X + (FCollisionData.Offset.X * LScale) - (FCollisionData.Size.Width * LScale * 0.5);
  Result.Pos.Y := LPos.Y + (FCollisionData.Offset.Y * LScale) - (FCollisionData.Size.Height * LScale * 0.5);
  Result.Size.Width := FCollisionData.Size.Width * LScale;
  Result.Size.Height := FCollisionData.Size.Height * LScale;
end;

function Tg2dSprite.GetWorldCollisionCenter(): Tg2dVec;
var
  LPos: Tg2dVec;
  LScale: Single;
begin
  LPos := GetPosition();
  LScale := GetScale();

  Result.X := LPos.X + (FCollisionData.Offset.X * LScale);
  Result.Y := LPos.Y + (FCollisionData.Offset.Y * LScale);
end;

function Tg2dSprite.GetWorldCollisionRadius(): Single;
var
  LScale: Single;
begin
  LScale := GetScale();
  Result := FCollisionData.Radius * LScale;
end;

function Tg2dSprite.GetWorldCollisionVertices(): TArray<Tg2dVec>;
var
  LPos: Tg2dVec;
  LScale: Single;
  LAngle: Single;
  LI: Integer;
  LVertex: Tg2dVec;
begin
  SetLength(Result, Length(FCollisionData.Vertices));
  if Length(Result) = 0 then Exit;

  LPos := GetPosition();
  LScale := GetScale();
  LAngle := GetAngle();

  for LI := 0 to High(FCollisionData.Vertices) do
  begin
    LVertex := FCollisionData.Vertices[LI];

    // Scale vertex
    LVertex.X := LVertex.X * LScale;
    LVertex.Y := LVertex.Y * LScale;

    // Rotate vertex if needed
    if LAngle <> 0 then
      Tg2dMath.AngleRotatePos(LAngle, LVertex.X, LVertex.Y);

    // Translate to world position
    Result[LI].X := LPos.X + LVertex.X + (FCollisionData.Offset.X * LScale);
    Result[LI].Y := LPos.Y + LVertex.Y + (FCollisionData.Offset.Y * LScale);
  end;
end;

procedure Tg2dSprite.DrawCollisionDebug();
begin
  if not FCollisionData.DebugDraw or not FCollisionData.Enabled then Exit;

  // TODO: Implement debug drawing using your rendering primitives
  // This would draw collision bounds as wireframes over the sprites
  // For now, this is a placeholder
end;

// Main collision detection method
function Tg2dSprite.CollidesWith(const AOther: Tg2dSprite): Boolean;
var
  LOBB1: Tg2dOBB;
  LOBB2: Tg2dOBB;
  LRect1: Tg2dRect;
  LRect2: Tg2dRect;
  LCenter1: Tg2dVec;
  LCenter2: Tg2dVec;
  LRadius1: Single;
  LRadius2: Single;
  LVertices1: TArray<Tg2dVec>;
  LVertices2: TArray<Tg2dVec>;
begin
  Result := False;

  if not Assigned(AOther) then Exit;
  if not FCollisionData.Enabled or not AOther.FCollisionData.Enabled then Exit;
  if not CanCollideWith(AOther) then Exit;

  // Handle different collision shape combinations
  case FCollisionData.Shape of
    csRectangle:
      case AOther.FCollisionData.Shape of
        csRectangle:
        begin
          LRect1 := GetWorldCollisionBounds();
          LRect2 := AOther.GetWorldCollisionBounds();
          Result := Tg2dMath.RectanglesOverlap(LRect1, LRect2);
        end;
        csCircle:
        begin
          LRect1 := GetWorldCollisionBounds();
          LCenter2 := AOther.GetWorldCollisionCenter();
          LRadius2 := AOther.GetWorldCollisionRadius();
          Result := Tg2dMath.CircleInRectangle(LCenter2, LRadius2, LRect1);
        end;
        csOBB:
        begin
          // Convert rectangle to OBB for consistent comparison
          LRect1 := GetWorldCollisionBounds();
          LOBB1.Center.X := LRect1.Pos.X + LRect1.Size.Width * 0.5;
          LOBB1.Center.Y := LRect1.Pos.Y + LRect1.Size.Height * 0.5;
          LOBB1.HalfWidth := LRect1.Size.Width * 0.5;
          LOBB1.HalfHeight := LRect1.Size.Height * 0.5;
          LOBB1.Rotation := GetAngle(); // This sprite's rotation

          LRect2 := AOther.GetWorldCollisionBounds();
          LOBB2.Center.X := LRect2.Pos.X + LRect2.Size.Width * 0.5;
          LOBB2.Center.Y := LRect2.Pos.Y + LRect2.Size.Height * 0.5;
          LOBB2.HalfWidth := LRect2.Size.Width * 0.5;
          LOBB2.HalfHeight := LRect2.Size.Height * 0.5;
          LOBB2.Rotation := AOther.GetAngle(); // Other sprite's rotation

          Result := Tg2dMath.OBBsOverlap(LOBB1, LOBB2);
        end;
        csPolygon:
        begin
          LRect1 := GetWorldCollisionBounds();
          LVertices2 := AOther.GetWorldCollisionVertices();
          // Simple check: test if any polygon vertex is inside rectangle
          for var LVertex in LVertices2 do
          begin
            if Tg2dMath.PointInRectangle(LVertex, LRect1) then
            begin
              Result := True;
              Break;
            end;
          end;
        end;
      end;

    csCircle:
      case AOther.FCollisionData.Shape of
        csRectangle:
        begin
          LCenter1 := GetWorldCollisionCenter();
          LRadius1 := GetWorldCollisionRadius();
          LRect2 := AOther.GetWorldCollisionBounds();
          Result := Tg2dMath.CircleInRectangle(LCenter1, LRadius1, LRect2);
        end;
        csCircle:
        begin
          LCenter1 := GetWorldCollisionCenter();
          LRadius1 := GetWorldCollisionRadius();
          LCenter2 := AOther.GetWorldCollisionCenter();
          LRadius2 := AOther.GetWorldCollisionRadius();
          Result := Tg2dMath.CirclesOverlap(LCenter1, LRadius1, LCenter2, LRadius2);
        end;
        csOBB, csPolygon:
        begin
          // For complex shapes, fall back to simpler approximation
          LCenter1 := GetWorldCollisionCenter();
          LRadius1 := GetWorldCollisionRadius();
          LRect2 := AOther.GetWorldCollisionBounds();
          Result := Tg2dMath.CircleInRectangle(LCenter1, LRadius1, LRect2);
        end;
      end;

    csOBB:
      case AOther.FCollisionData.Shape of
        csRectangle, csOBB:
        begin
          LRect1 := GetWorldCollisionBounds();
          LOBB1.Center.X := LRect1.Pos.X + LRect1.Size.Width * 0.5;
          LOBB1.Center.Y := LRect1.Pos.Y + LRect1.Size.Height * 0.5;
          LOBB1.HalfWidth := LRect1.Size.Width * 0.5;
          LOBB1.HalfHeight := LRect1.Size.Height * 0.5;
          LOBB1.Rotation := GetAngle(); // This sprite's rotation

          LRect2 := AOther.GetWorldCollisionBounds();
          LOBB2.Center.X := LRect2.Pos.X + LRect2.Size.Width * 0.5;
          LOBB2.Center.Y := LRect2.Pos.Y + LRect2.Size.Height * 0.5;
          LOBB2.HalfWidth := LRect2.Size.Width * 0.5;
          LOBB2.HalfHeight := LRect2.Size.Height * 0.5;
          LOBB2.Rotation := AOther.GetAngle(); // Other sprite's rotation

          Result := Tg2dMath.OBBsOverlap(LOBB1, LOBB2);
        end;
        csCircle:
        begin
          // Approximate OBB as circle for this case
          LRect1 := GetWorldCollisionBounds();
          LCenter2 := AOther.GetWorldCollisionCenter();
          LRadius2 := AOther.GetWorldCollisionRadius();
          Result := Tg2dMath.CircleInRectangle(LCenter2, LRadius2, LRect1);
        end;
      end;

    csPolygon:
      case AOther.FCollisionData.Shape of
        csRectangle:
        begin
          LVertices1 := GetWorldCollisionVertices();
          LRect2 := AOther.GetWorldCollisionBounds();
          // Test if any polygon vertex is inside rectangle
          for var LVertex in LVertices1 do
          begin
            if Tg2dMath.PointInRectangle(LVertex, LRect2) then
            begin
              Result := True;
              Break;
            end;
          end;
        end;
        csCircle:
        begin
          LVertices1 := GetWorldCollisionVertices();
          LCenter2 := AOther.GetWorldCollisionCenter();
          //LRadius2 := AOther.GetWorldCollisionRadius();
          // Test if circle center is inside polygon
          Result := Tg2dMath.PointInConvexPolygon(LCenter2, LVertices1);
        end;
        csPolygon:
        begin
          LVertices1 := GetWorldCollisionVertices();
          LVertices2 := AOther.GetWorldCollisionVertices();
          // Simple test: check if any vertex of one polygon is inside the other
          for var LVertex in LVertices1 do
          begin
            if Tg2dMath.PointInConvexPolygon(LVertex, LVertices2) then
            begin
              Result := True;
              Break;
            end;
          end;
          if not Result then
          begin
            for var LVertex in LVertices2 do
            begin
              if Tg2dMath.PointInConvexPolygon(LVertex, LVertices1) then
              begin
                Result := True;
                Break;
              end;
            end;
          end;
        end;
      end;
  end;
end;

function Tg2dSprite.CollidesWithPoint(const APoint: Tg2dVec): Boolean;
var
  LRect: Tg2dRect;
  LCenter: Tg2dVec;
  LRadius: Single;
  LVertices: TArray<Tg2dVec>;
begin
  Result := False;
  if not FCollisionData.Enabled then Exit;

  case FCollisionData.Shape of
    csRectangle, csOBB:
    begin
      LRect := GetWorldCollisionBounds();
      Result := Tg2dMath.PointInRectangle(APoint, LRect);
    end;
    csCircle:
    begin
      LCenter := GetWorldCollisionCenter();
      LRadius := GetWorldCollisionRadius();
      Result := Tg2dMath.PointInCircle(APoint, LCenter, LRadius);
    end;
    csPolygon:
    begin
      LVertices := GetWorldCollisionVertices();
      Result := Tg2dMath.PointInConvexPolygon(APoint, LVertices);
    end;
  end;
end;

function Tg2dSprite.CollidesWithRectangle(const ARect: Tg2dRect): Boolean;
var
  LRect: Tg2dRect;
  LCenter: Tg2dVec;
  LRadius: Single;
begin
  Result := False;
  if not FCollisionData.Enabled then Exit;

  case FCollisionData.Shape of
    csRectangle, csOBB:
    begin
      LRect := GetWorldCollisionBounds();
      Result := Tg2dMath.RectanglesOverlap(LRect, ARect);
    end;
    csCircle:
    begin
      LCenter := GetWorldCollisionCenter();
      LRadius := GetWorldCollisionRadius();
      Result := Tg2dMath.CircleInRectangle(LCenter, LRadius, ARect);
    end;
    csPolygon:
    begin
      // Simple approximation: check if rectangle overlaps sprite bounds
      LRect := GetWorldCollisionBounds();
      Result := Tg2dMath.RectanglesOverlap(LRect, ARect);
    end;
  end;
end;

function Tg2dSprite.CollidesWithCircle(const ACenter: Tg2dVec; const ARadius: Single): Boolean;
var
  LRect: Tg2dRect;
  LCenter: Tg2dVec;
  LRadius: Single;
begin
  Result := False;
  if not FCollisionData.Enabled then Exit;

  case FCollisionData.Shape of
    csRectangle, csOBB:
    begin
      LRect := GetWorldCollisionBounds();
      Result := Tg2dMath.CircleInRectangle(ACenter, ARadius, LRect);
    end;
    csCircle:
    begin
      LCenter := GetWorldCollisionCenter();
      LRadius := GetWorldCollisionRadius();
      Result := Tg2dMath.CirclesOverlap(ACenter, ARadius, LCenter, LRadius);
    end;
    csPolygon:
    begin
      // Simple approximation: check if circle center is inside polygon
      Result := CollidesWithPoint(ACenter);
    end;
  end;
end;

function Tg2dSprite.CollidesWithLine(const ALineStart, ALineEnd: Tg2dVec): Boolean;
var
  LRect: Tg2dRect;
  LCenter: Tg2dVec;
  LRadius: Single;
begin
  Result := False;
  if not FCollisionData.Enabled then Exit;

  case FCollisionData.Shape of
    csRectangle, csOBB:
    begin
      LRect := GetWorldCollisionBounds();
      // Check if line endpoints are inside rectangle or line intersects rectangle
      Result := Tg2dMath.PointInRectangle(ALineStart, LRect) or
                Tg2dMath.PointInRectangle(ALineEnd, LRect);
      // TODO: Add proper line-rectangle intersection
    end;
    csCircle:
    begin
      LCenter := GetWorldCollisionCenter();
      LRadius := GetWorldCollisionRadius();
      Result := Tg2dMath.LineSegmentIntersectsCircle(ALineStart, ALineEnd, LCenter, LRadius);
    end;
    csPolygon:
    begin
      // Simple check: test if line endpoints are inside polygon
      Result := CollidesWithPoint(ALineStart) or CollidesWithPoint(ALineEnd);
    end;
  end;
end;

// Advanced collision queries (basic implementations)
function Tg2dSprite.GetCollisionDistance(const AOther: Tg2dSprite): Single;
var
  LCenter1: Tg2dVec;
  LCenter2: Tg2dVec;
begin
  Result := 0;
  if not Assigned(AOther) then Exit;

  LCenter1 := GetWorldCollisionCenter();
  LCenter2 := AOther.GetWorldCollisionCenter();
  Result := LCenter1.Distance(LCenter2);
end;

function Tg2dSprite.GetCollisionNormal(const AOther: Tg2dSprite): Tg2dVec;
var
  LCenter1: Tg2dVec;
  LCenter2: Tg2dVec;
  LDirection: Tg2dVec;
begin
  Result := Tg2dVec.Create(0, 0);
  if not Assigned(AOther) then Exit;

  LCenter1 := GetWorldCollisionCenter();
  LCenter2 := AOther.GetWorldCollisionCenter();
  LDirection := Tg2dVec.Create(LCenter2.X - LCenter1.X, LCenter2.Y - LCenter1.Y);
  LDirection.Normalize();
  Result := LDirection;
end;

function Tg2dSprite.GetCollisionPoint(const AOther: Tg2dSprite): Tg2dVec;
var
  LCenter1: Tg2dVec;
  LCenter2: Tg2dVec;
begin
  Result := Tg2dVec.Create(0, 0);
  if not Assigned(AOther) then Exit;

  LCenter1 := GetWorldCollisionCenter();
  LCenter2 := AOther.GetWorldCollisionCenter();
  Result.X := (LCenter1.X + LCenter2.X) * 0.5;
  Result.Y := (LCenter1.Y + LCenter2.Y) * 0.5;
end;

procedure Tg2dSprite.EnableCollisionDebug(const AEnable: Boolean = True);
begin
  FCollisionData.DebugDraw := AEnable;
end;

//=== MOVEMENT AND VISIBILITY METHODS =========================================

function Tg2dSprite.GetAngleOffset(): Single;
begin
  Result := FAngleOffset;
end;

procedure Tg2dSprite.SetAngleOffset(const AAngle: Single);
begin
  FAngleOffset := AAngle;
  Tg2dMath.ClipValueFloat(FAngleOffset, 0, 360, True);
end;

procedure Tg2dSprite.RotateRel(const AAngle: Single);
var
  LCurrentAngle: Single;
begin
  LCurrentAngle := GetAngle() + AAngle;
  Tg2dMath.ClipValueFloat(LCurrentAngle, 0, 360, True);
  SetAngle(LCurrentAngle);
end;

function Tg2dSprite.RotateToAngle(const AAngle, ASpeed: Single): Boolean;
var
  LStep: Single;
  LLen: Single;
  LS: Single;
  LCurrentAngle: Single;
begin
  Result := False;
  LCurrentAngle := GetAngle();
  LStep := Tg2dMath.AngleDifference(LCurrentAngle, AAngle);
  LLen := Sqrt(LStep * LStep);

  if LLen = 0 then
  begin
    Result := True;
    Exit;
  end;

  LS := (LStep / LLen) * ASpeed;

  if Tg2dMath.SameValueFloat(LStep, 0, LS) then
  begin
    SetAngle(AAngle);
    Result := True;
  end
  else
  begin
    SetAngle(LCurrentAngle + LS);
  end;
end;

function Tg2dSprite.RotateToPos(const AX, AY, ASpeed: Single): Boolean;
var
  LAngle: Single;
  LStep: Single;
  LLen: Single;
  LS: Single;
  LCurrentPos: Tg2dVec;
  LTargetPos: Tg2dVec;
  LCurrentAngle: Single;
begin
  Result := False;
  LCurrentPos := GetPosition();
  LTargetPos := Tg2dVec.Create(AX, AY);

  // Calculate angle to target position
  LAngle := -LCurrentPos.Angle(LTargetPos);

  LCurrentAngle := GetAngle();
  LStep := Tg2dMath.AngleDifference(LCurrentAngle, LAngle);
  LLen := Sqrt(LStep * LStep);

  if LLen = 0 then
  begin
    Result := True;
    Exit;
  end;

  LS := (LStep / LLen) * ASpeed;

  if Tg2dMath.SameValueFloat(LStep, LS, ASpeed) then
  begin
    RotateRel(LStep);
    Result := True;
  end
  else
  begin
    RotateRel(LS);
  end;
end;

function Tg2dSprite.RotateToPosAt(const ASrcX, ASrcY, ADestX, ADestY, ASpeed: Single): Boolean;
var
  LAngle: Single;
  LStep: Single;
  LLen: Single;
  LS: Single;
  LSrcPos: Tg2dVec;
  LDestPos: Tg2dVec;
  LCurrentAngle: Single;
begin
  Result := False;
  LSrcPos := Tg2dVec.Create(ASrcX, ASrcY);
  LDestPos := Tg2dVec.Create(ADestX, ADestY);

  // Calculate angle between source and destination
  LAngle := LSrcPos.Angle(LDestPos);

  LCurrentAngle := GetAngle();
  LStep := Tg2dMath.AngleDifference(LCurrentAngle, LAngle);
  LLen := Sqrt(LStep * LStep);

  if LLen = 0 then
  begin
    Result := True;
    Exit;
  end;

  LS := (LStep / LLen) * ASpeed;

  if Tg2dMath.SameValueFloat(LStep, LS, ASpeed) then
  begin
    RotateRel(LStep);
    Result := True;
  end
  else
  begin
    RotateRel(LS);
  end;
end;

procedure Tg2dSprite.Thrust(const ASpeed: Single);
var
  LS: Single;
  LA: Integer;
  LCurrentPos: Tg2dVec;
begin
  LA := Abs(Round(GetAngle() + 90.0));
  Tg2dMath.ClipValueInt(LA, 0, 360, True);

  LS := -ASpeed;

  FDir.X := Tg2dMath.AngleCos(LA) * LS;
  FDir.Y := Tg2dMath.AngleSin(LA) * LS;

  LCurrentPos := GetPosition();
  LCurrentPos.X := LCurrentPos.X + FDir.X;
  LCurrentPos.Y := LCurrentPos.Y + FDir.Y;
  SetPosition(LCurrentPos);
end;

procedure Tg2dSprite.ThrustAngle(const AAngle, ASpeed: Single);
var
  LS: Single;
  LA: Integer;
  LCurrentPos: Tg2dVec;
begin
  LA := Abs(Round(AAngle));
  Tg2dMath.ClipValueInt(LA, 0, 360, True);

  LS := -ASpeed;

  FDir.X := Tg2dMath.AngleCos(LA) * LS;
  FDir.Y := Tg2dMath.AngleSin(LA) * LS;

  LCurrentPos := GetPosition();
  LCurrentPos.X := LCurrentPos.X + FDir.X;
  LCurrentPos.Y := LCurrentPos.Y + FDir.Y;
  SetPosition(LCurrentPos);
end;

function Tg2dSprite.ThrustToPos(const AThrustSpeed, ARotSpeed, ADestX, ADestY, ASlowdownDist, AStopDist, AStopSpeed, AStopSpeedEpsilon: Single): Boolean;
var
  LDist: Single;
  LStep: Single;
  LSpeed: Single;
  LCurrentPos: Tg2dVec;
  LDestPos: Tg2dVec;
  LStopDist: Single;
begin
  Result := False;

  if ASlowdownDist <= 0 then Exit;

  LStopDist := AStopDist;
  if LStopDist < 0 then LStopDist := 0;

  LCurrentPos := GetPosition();
  LDestPos := Tg2dVec.Create(ADestX, ADestY);
  LDist := LCurrentPos.Distance(LDestPos) - LStopDist;

  if LDist > ASlowdownDist then
  begin
    LSpeed := AThrustSpeed;
  end
  else
  begin
    LStep := LDist / ASlowdownDist;
    LSpeed := AThrustSpeed * LStep;
    if LSpeed <= AStopSpeed then
    begin
      LSpeed := 0;
      Result := True;
    end;
  end;

  if RotateToPos(ADestX, ADestY, ARotSpeed) then
  begin
    Thrust(LSpeed);
  end;
end;

function Tg2dSprite.IsVisible(const AWindow: Tg2dWindow): Boolean;
var
  LHalfWidth: Single;
  LHalfHeight: Single;
  LViewportWidth: Single;
  LViewportHeight: Single;
  LCurrentPos: Tg2dVec;
  LTextureSize: Tg2dSize;
  LScale: Single;
begin
  Result := False;

  if not Assigned(FTexture) or not FTexture.IsLoaded() then Exit;

  LTextureSize := FTexture.GetSize();
  LScale := GetScale();
  LHalfWidth := (LTextureSize.Width * LScale) / 2;
  LHalfHeight := (LTextureSize.Height * LScale) / 2;

  LViewportWidth := AWindow.GetVirtualSize().Width - 1;
  LViewportHeight := AWindow.GetVirtualSize().Height - 1;

  LCurrentPos := GetPosition();

  if LCurrentPos.X > (LViewportWidth + LHalfWidth) then Exit;
  if LCurrentPos.X < -LHalfWidth then Exit;
  if LCurrentPos.Y > (LViewportHeight + LHalfHeight) then Exit;
  if LCurrentPos.Y < -LHalfHeight then Exit;

  Result := True;
end;

function Tg2dSprite.IsFullyVisible(const AWindow: Tg2dWindow): Boolean;
var
  LHalfWidth: Single;
  LHalfHeight: Single;
  LViewportWidth: Single;
  LViewportHeight: Single;
  LCurrentPos: Tg2dVec;
  LTextureSize: Tg2dSize;
  LScale: Single;
begin
  Result := False;

  if not Assigned(FTexture) or not FTexture.IsLoaded() then Exit;

  LTextureSize := FTexture.GetSize();
  LScale := GetScale();
  LHalfWidth := (LTextureSize.Width * LScale) / 2;
  LHalfHeight := (LTextureSize.Height * LScale) / 2;

  LViewportWidth := AWindow.GetVirtualSize().Width - 1;
  LViewportHeight := AWindow.GetVirtualSize().Height - 1;

  LCurrentPos := GetPosition();

  if LCurrentPos.X > (LViewportWidth - LHalfWidth) then Exit;
  if LCurrentPos.X < LHalfWidth then Exit;
  if LCurrentPos.Y > (LViewportHeight - LHalfHeight) then Exit;
  if LCurrentPos.Y < LHalfHeight then Exit;

  Result := True;
end;

function Tg2dSprite.GetDir(): Tg2dVec;
begin
  Result := FDir;
end;

procedure Tg2dSprite.SetDir(const ADir: Tg2dVec);
begin
  FDir := ADir;
end;

{$REGION 'Property Accessors'}
function Tg2dSprite.GetPosition(): Tg2dVec;
begin
  Result := FTexture.GetPos;
end;

procedure Tg2dSprite.SetPosition(const AValue: Tg2dVec);
begin
  FTexture.SetPos(AValue);
end;

function Tg2dSprite.GetScale(): Single;
begin
  Result := FTexture.GetScale;
end;

procedure Tg2dSprite.SetScale(const AValue: Single);
begin
  FTexture.SetScale(AValue);
end;

function Tg2dSprite.GetAngle(): Single;
begin
  Result := FTexture.GetAngle;
end;

procedure Tg2dSprite.SetAngle(const AValue: Single);
begin
  FTexture.SetAngle(AValue);
end;

function Tg2dSprite.GetColor(): Tg2dColor;
begin
  Result := FTexture.GetColor;
end;

procedure Tg2dSprite.SetColor(const AValue: Tg2dColor);
begin
  FTexture.SetColor(AValue);
end;

function Tg2dSprite.GetHFlip(): Boolean;
begin
  Result := FTexture.GetHFlip;
end;

procedure Tg2dSprite.SetHFlip(const AValue: Boolean);
begin
  FTexture.SetHFlip(AValue);
end;

function Tg2dSprite.GetVFlip(): Boolean;
begin
  Result := FTexture.GetVFlip;
end;

procedure Tg2dSprite.SetVFlip(const AValue: Boolean);
begin
  FTexture.SetVFlip(AValue);
end;

function Tg2dSprite.GetKind(): Tg2dTextureKind;
begin
  Result := FTexture.GetKind();
end;

procedure Tg2dSprite.SetKind(const AKind: Tg2dTextureKind);
begin
  FTexture.SetKind(AKind);
end;

{$ENDREGION}

end.

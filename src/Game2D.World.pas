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

--------------------------------------------------------------------------------

 Game2D.World - Entity-Component-System Framework

 This unit provides a complete ECS (Entity-Component-System) architecture for 2D
 games with integrated sprite support, collision detection, messaging, and scene
 management.

 ═══════════════════════════════════════════════════════════════════════════════
 CORE ARCHITECTURE
 ═══════════════════════════════════════════════════════════════════════════════

 ENTITIES: Game objects with unique IDs, tags, groups, and lifecycle management
 SCENES:   Layered containers for entities with Z-order rendering
 WORLD:    Top-level manager containing all scenes and global operations

 ═══════════════════════════════════════════════════════════════════════════════
 ENTITY SYSTEM
 ═══════════════════════════════════════════════════════════════════════════════

 • Unique ID system for entity tracking
 • Tag/Group organization for flexible querying
 • Integrated sprite support with automatic memory management
 • Safe termination system with deferred deletion
 • Transform operations (position, scale, rotation, color)
 • Animation control through sprite integration

 BASIC ENTITY USAGE:
   var LPlayer: Tg2dEntity;
   begin
     LPlayer := Tg2dEntity.Create();
     LPlayer.CreateSprite(MyAtlas);           // Auto-managed sprite
     LPlayer.AddTag('player');
     LPlayer.AddGroup('team_blue');
     LPlayer.SetPosition(100, 200);
     LPlayer.PlayAnimation('idle', True, 15.0);
     Scene.AddEntity(LPlayer);
   end;

 TERMINATION SYSTEM:
   // Safe deletion during collision or update
   procedure TBullet.OnCollision(const AOther: Tg2dEntity);
   begin
     if AOther.HasTag('enemy') then
     begin
       AOther.Terminate();                    // Mark for deletion
       Self.Terminate();                      // Both removed after update cycle
     end;

     // Conditional termination
     Self.Terminate(Health <= 0);             // Only if condition met
     Self.Terminate(False);                   // Cancel termination
   end;

 ═══════════════════════════════════════════════════════════════════════════════
 COLLISION DETECTION
 ═══════════════════════════════════════════════════════════════════════════════

 • Full integration with Game2D.Sprite collision system
 • Multiple collision shapes: Rectangle, Circle, OBB, Polygon, Pixel-perfect
 • Category-based collision filtering
 • Automatic collision detection with callbacks
 • Spatial queries (entities in rectangles/circles)

 COLLISION SETUP:
   LEnemy := Tg2dEntity.Create();
   LEnemy.CreateSprite(EnemyAtlas);
   LEnemy.Sprite.SetCollisionRectangle(32, 32);
   LEnemy.Sprite.SetCollisionCategory('enemy');
   LEnemy.Sprite.SetCollidesWith(['player', 'bullet']);
   LEnemy.AddTag('enemy');

 COLLISION HANDLING:
   procedure TEnemy.OnCollision(const AOther: Tg2dEntity);
   begin
     if AOther.HasTag('bullet') then
     begin
       TakeDamage(10);
       AOther.Terminate();                    // Remove bullet
       if Health <= 0 then Terminate();      // Remove enemy if dead
     end;
   end;

 COLLISION QUERIES:
   // Find all entities colliding with area
   LEntitiesInRect := Scene.GetEntitiesInRect(Tg2dRect.Create(0, 0, 100, 100));
   LEntitiesInRange := Scene.GetEntitiesInCircle(PlayerPos, 50.0);

   // Direct collision testing
   if LPlayer.CollidesWith(LEnemy) then
     // Handle collision

   if LPlayer.CollidesWithPoint(MousePos) then
     // Handle mouse click

 ═══════════════════════════════════════════════════════════════════════════════
 SCENE SYSTEM (LAYERED RENDERING)
 ═══════════════════════════════════════════════════════════════════════════════

 • Z-order based rendering (lower values render first)
 • Independent visibility and collision detection per scene
 • Efficient entity management with linked lists
 • Automatic cleanup of terminated entities

 SCENE SETUP:
   BackgroundScene := Tg2dScene.Create();
   BackgroundScene.Init('background', 0);    // Z-order 0 (back)

   GameScene := Tg2dScene.Create();
   GameScene.Init('gameplay', 10);           // Z-order 10 (middle)

   UIScene := Tg2dScene.Create();
   UIScene.Init('ui', 100);                  // Z-order 100 (front)
   UIScene.EnableCollisionDetection := False; // UI doesn't need collision

   World.AddScene(BackgroundScene);
   World.AddScene(GameScene);
   World.AddScene(UIScene);

 ENTITY QUERIES BY SCENE:
   LAllEnemies := GameScene.GetEntitiesWithTag('enemy');
   LTeamRed := GameScene.GetEntitiesWithGroup('team_red');
   LNearbyEntities := GameScene.GetEntitiesInCircle(PlayerPos, 100);

 ═══════════════════════════════════════════════════════════════════════════════
 MESSAGING SYSTEM
 ═══════════════════════════════════════════════════════════════════════════════

 • Flexible entity communication using TValue for data
 • Broadcast to entities by tags, groups, or specific IDs
 • Timestamp tracking for message ordering
 • Type-safe data passing with TValue

 BROADCASTING MESSAGES:
   // Send to all entities with specific tags
   World.BroadcastMessage('level_complete', TValue.From(3), ['player', 'ui']);

   // Send to specific groups
   World.BroadcastMessage('team_bonus', TValue.From(500), ['team_blue'], True);

   // Send to specific entity
   World.SendMessage('take_damage', TValue.From(25), LPlayerEntity);

 MESSAGE HANDLING:
   procedure TPlayer.OnMessage(const AName: string; const AData: TValue);
   begin
     if AName = 'take_damage' then
     begin
       LDamage := AData.AsInteger;
       Health := Health - LDamage;
       PlayAnimation('hurt', False, 24.0);
     end
     else if AName = 'level_complete' then
     begin
       LLevel := AData.AsInteger;
       ShowLevelCompleteUI(LLevel);
     end;
   end;

 ═══════════════════════════════════════════════════════════════════════════════
 SPRITE INTEGRATION
 ═══════════════════════════════════════════════════════════════════════════════

 • Seamless integration with Game2D.Sprite system
 • Automatic sprite lifecycle management
 • Transform operations delegate to sprite
 • Animation control through entity interface

 SPRITE MANAGEMENT:
   // Entity owns and manages sprite
   LEntity.CreateSprite(MyAtlas);             // Auto-cleanup on entity destroy

   // Entity references external sprite
   LEntity.AssignSprite(ExistingSprite, False); // Don't auto-cleanup

   // Clear sprite reference
   LEntity.ClearSprite();

 TRANSFORM OPERATIONS:
   LEntity.SetPosition(100, 200);             // Delegates to sprite
   LEntity.SetScale(2.0);                     // Double size
   LEntity.SetAngle(45);                      // Rotate 45 degrees
   LEntity.SetColor(RED);                     // Tint red

 ANIMATION CONTROL:
   LEntity.PlayAnimation('walk', True, 12.0); // Loop walk at 12 FPS
   LEntity.PlayAnimation('attack', False, 24.0); // Play attack once at 24 FPS
   LEntity.PauseAnimation();
   LEntity.ResumeAnimation();
   LEntity.StopAnimation();

 ═══════════════════════════════════════════════════════════════════════════════
 WORLD MANAGEMENT
 ═══════════════════════════════════════════════════════════════════════════════

 • Central coordinator for all scenes and entities
 • Global collision detection across scenes (optional)
 • Cross-scene entity queries and messaging
 • Unified update/render pipeline

 WORLD OPERATIONS:
   World := Tg2dWorld.Create();
   World.AddScene(MyScene);
   World.EnableGlobalCollisions := True;      // Cross-scene collisions

   // Main game loop
   World.Update(Window);                      // Update all scenes
   World.Render();                           // Render all scenes in Z-order

 GLOBAL QUERIES:
   LAllPlayers := World.GetAllEntitiesWithTag('player');
   LAllEnemies := World.GetAllEntitiesWithGroup('enemies');
   LEntitiesInArea := World.GetAllEntitiesInRect(SearchRect);

 ═══════════════════════════════════════════════════════════════════════════════
 COMPLETE GAME EXAMPLE
 ═══════════════════════════════════════════════════════════════════════════════

 // Setup game world
 procedure SetupGame();
 begin
   World := Tg2dWorld.Create();

   // Create scenes
   BackgroundScene := Tg2dScene.Create();
   BackgroundScene.Init('background', 0);
   GameScene := Tg2dScene.Create();
   GameScene.Init('game', 10);
   UIScene := Tg2dScene.Create();
   UIScene.Init('ui', 100);
   UIScene.EnableCollisionDetection := False;

   World.AddScene(BackgroundScene);
   World.AddScene(GameScene);
   World.AddScene(UIScene);
 end;

 // Create player
 procedure CreatePlayer();
 begin
   LPlayer := Tg2dEntity.Create();
   LPlayer.CreateSprite(PlayerAtlas);
   LPlayer.SetPosition(400, 300);
   LPlayer.AddTag('player');
   LPlayer.Sprite.SetCollisionRectangle(24, 32);
   LPlayer.Sprite.SetCollisionCategory('player');
   LPlayer.Sprite.SetCollidesWith(['enemy', 'powerup', 'hazard']);
   GameScene.AddEntity(LPlayer);
 end;

 // Create enemy
 procedure CreateEnemy(const AX, AY: Single);
 begin
   LEnemy := Tg2dEntity.Create();
   LEnemy.CreateSprite(EnemyAtlas);
   LEnemy.SetPosition(AX, AY);
   LEnemy.AddTag('enemy');
   LEnemy.AddGroup('team_red');
   LEnemy.Sprite.SetCollisionCircle(16);
   LEnemy.Sprite.SetCollisionCategory('enemy');
   LEnemy.Sprite.SetCollidesWith(['player', 'bullet']);
   GameScene.AddEntity(LEnemy);
 end;

 // Fire bullet
 procedure FireBullet(const APos: Tg2dVec; const ADir: Tg2dVec);
 begin
   LBullet := Tg2dEntity.Create();
   LBullet.CreateSprite(BulletAtlas);
   LBullet.SetPosition(APos);
   LBullet.Sprite.SetDir(ADir);               // Set movement direction
   LBullet.AddTag('bullet');
   LBullet.Sprite.SetCollisionCircle(4);
   LBullet.Sprite.SetCollisionCategory('bullet');
   LBullet.Sprite.SetCollidesWith(['enemy']);
   GameScene.AddEntity(LBullet);
 end;

 // Main game loop
 procedure GameLoop();
 begin
   World.Update(Window);                      // Updates all entities & collision
   World.Render();                           // Renders all scenes in Z-order
 end;

 ═══════════════════════════════════════════════════════════════════════════════
 PERFORMANCE FEATURES
 ═══════════════════════════════════════════════════════════════════════════════

 • Efficient linked-list entity storage for fast iteration
 • Deferred deletion prevents mid-update collection modification
 • Selective updates (only active entities)
 • Selective rendering (only visible entities)
 • Optional collision detection per scene
 • Smart collision filtering by categories
 • Z-order scene rendering optimization

 ═══════════════════════════════════════════════════════════════════════════════
 VIRTUAL METHODS FOR INHERITANCE
 ═══════════════════════════════════════════════════════════════════════════════

 Override these methods in your custom entity classes:

   procedure OnStartup(); virtual;            // Called when added to scene
   procedure OnShutdown(); virtual;           // Called when removed from scene
   procedure OnUpdate(const AWindow: Tg2dWindow); virtual;  // Called each frame
   procedure OnRender(); virtual;             // Called during render pass
   procedure OnMessage(const AName: string; const AData: TValue); virtual;
   procedure OnCollision(const AOther: Tg2dEntity); virtual;

===============================================================================}

unit Game2D.World;

{$I Game2D.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Rtti,
  System.Math,
  Game2D.Common,
  Game2D.Core,
  Game2D.Sprite;

//=== MESSAGE SYSTEM ===========================================================
type

  { Tg2dMessage }
  Tg2dMessage = record
    Name: string;
    Data: TValue;
    Timestamp: TDateTime;
    constructor Create(const AName: string; const AData: TValue);
  end;

  { Tg2dMessage }
  Tg2dMessageFilter = record
    Tags: TArray<string>;
    Groups: TArray<string>;
    EntityID: Cardinal;
    constructor Create(const ATags: TArray<string>); overload;
    constructor Create(const AGroups: TArray<string>; const ADummy: Boolean); overload;
    constructor Create(const AEntityID: Cardinal); overload;
  end;

//=== ENTITY SYSTEM ============================================================
type
  { Tg2dScene }
  Tg2dScene = class;

  { Tg2dEntity }
  Tg2dEntity = class(Tg2dObject)
  private
    FID: Cardinal;
    FTags: TList<string>;
    FGroups: TList<string>;
    FActive: Boolean;
    FVisible: Boolean;
    FTerminated: Boolean;
    FScene: Tg2dScene;
    FPrevEntity: Tg2dEntity;
    FNextEntity: Tg2dEntity;
    FSprite: Tg2dSprite;
    FOwnsSprite: Boolean;
    class var FNextID: Cardinal;
    class constructor Create();
  protected
    function GetID(): Cardinal;
    function GetTags(): TArray<string>;
    function GetGroups(): TArray<string>;
    function GetActive(): Boolean;
    function GetVisible(): Boolean;
    function GetTerminated(): Boolean;
    function GetScene(): Tg2dScene;
    function GetSprite(): Tg2dSprite;
    function GetOwnsSprite(): Boolean;
    procedure SetActive(const AValue: Boolean);
    procedure SetVisible(const AValue: Boolean);
    procedure SetTerminated(const AValue: Boolean);
    procedure SetScene(const AValue: Tg2dScene);
    procedure SetSprite(const AValue: Tg2dSprite);
    procedure SetOwnsSprite(const AValue: Boolean);
  public
    constructor Create(); override;
    destructor Destroy(); override;

    // Tag and group management
    function HasTag(const ATag: string): Boolean;
    function HasGroup(const AGroup: string): Boolean;
    procedure AddTag(const ATag: string);
    procedure RemoveTag(const ATag: string);
    procedure AddGroup(const AGroup: string);
    procedure RemoveGroup(const AGroup: string);

    // Sprite management
    procedure CreateSprite(const AAtlas: Tg2dSpriteAtlas);
    procedure AssignSprite(const ASprite: Tg2dSprite; const AOwnsSprite: Boolean = False);
    procedure ClearSprite();

    // Collision methods (delegate to sprite)
    function CollidesWith(const AOther: Tg2dEntity): Boolean; overload;
    function CollidesWith(const ASprite: Tg2dSprite): Boolean; overload;
    function CollidesWithPoint(const APoint: Tg2dVec): Boolean;
    function CollidesWithRectangle(const ARect: Tg2dRect): Boolean;
    function CollidesWithCircle(const ACenter: Tg2dVec; const ARadius: Single): Boolean;

    // Transform methods (delegate to sprite)
    function GetPosition(): Tg2dVec;
    procedure SetPosition(const AValue: Tg2dVec); overload;
    procedure SetPosition(const AX, AY: Single); overload;
    function GetScale(): Single;
    procedure SetScale(const AValue: Single);
    function GetAngle(): Single;
    procedure SetAngle(const AValue: Single);
    function GetColor(): Tg2dColor;
    procedure SetColor(const AValue: Tg2dColor);

    // Animation methods (delegate to sprite)
    function PlayAnimation(const AGroupName: string; const ALoop: Boolean = True; const AFramesPerSecond: Single = 15.0): Boolean;
    procedure StopAnimation();
    procedure PauseAnimation();
    procedure ResumeAnimation();

    // Termination methods
    procedure Terminate(const ATerminate: Boolean = True);
    function IsTerminated(): Boolean;

    // Virtual methods for override
    procedure OnStartup(); virtual;
    procedure OnShutdown(); virtual;
    procedure OnUpdate(const AWindow: Tg2dWindow); virtual;
    procedure OnRender(); virtual;
    procedure OnMessage(const AName: string; const AData: TValue); virtual;
    procedure OnCollision(const AOther: Tg2dEntity); virtual;

    // Properties
    property ID: Cardinal read GetID;
    property Tags: TArray<string> read GetTags;
    property Groups: TArray<string> read GetGroups;
    property Active: Boolean read GetActive write SetActive;
    property Visible: Boolean read GetVisible write SetVisible;
    property Terminated: Boolean read GetTerminated write SetTerminated;
    property Scene: Tg2dScene read GetScene write SetScene;
    property Sprite: Tg2dSprite read GetSprite write SetSprite;
    property OwnsSprite: Boolean read GetOwnsSprite write SetOwnsSprite;
    property PrevEntity: Tg2dEntity read FPrevEntity write FPrevEntity;
    property NextEntity: Tg2dEntity read FNextEntity write FNextEntity;
  end;

//=== SCENE SYSTEM =============================================================

  { Tg2dScene }
  Tg2dScene = class(Tg2dObject)
  private
    FName: string;
    FZOrder: Integer;
    FVisible: Boolean;
    FFirstEntity: Tg2dEntity;
    FLastEntity: Tg2dEntity;
    FEntityCount: Integer;
    FEnableCollisionDetection: Boolean;
  protected
    function GetName(): string;
    function GetZOrder(): Integer;
    function GetVisible(): Boolean;
    function GetEntityCount(): Integer;
    function GetEnableCollisionDetection(): Boolean;
    procedure SetName(const AValue: string);
    procedure SetZOrder(const AValue: Integer);
    procedure SetVisible(const AValue: Boolean);
    procedure SetEnableCollisionDetection(const AValue: Boolean);
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Init(const AName: string; const AZOrder: Integer = 0);

    // Entity management
    procedure AddEntity(const AEntity: Tg2dEntity);
    procedure RemoveEntity(const AEntity: Tg2dEntity);
    procedure ClearEntities();
    procedure UpdateEntities(const AWindow: Tg2dWindow);
    procedure RenderEntities();
    procedure CleanupTerminatedEntities();

    // Collision detection
    procedure CheckCollisions();
    function GetEntitiesInRect(const ARect: Tg2dRect): TArray<Tg2dEntity>;
    function GetEntitiesInCircle(const ACenter: Tg2dVec; const ARadius: Single): TArray<Tg2dEntity>;
    function GetEntitiesWithTag(const ATag: string): TArray<Tg2dEntity>;
    function GetEntitiesWithGroup(const AGroup: string): TArray<Tg2dEntity>;

    // Messaging
    procedure SendMessage(const AMessage: Tg2dMessage; const AFilter: Tg2dMessageFilter);
    function FindEntity(const AID: Cardinal): Tg2dEntity;

    // Properties
    property Name: string read GetName write SetName;
    property ZOrder: Integer read GetZOrder write SetZOrder;
    property Visible: Boolean read GetVisible write SetVisible;
    property EntityCount: Integer read GetEntityCount;
    property EnableCollisionDetection: Boolean read GetEnableCollisionDetection write SetEnableCollisionDetection;
  end;

//=== WORLD SYSTEM =============================================================
type
  { Tg2dWorld }
  Tg2dWorld = class(Tg2dObject)
  private
    FScenes: TList<Tg2dScene>;
    FEnableGlobalCollisions: Boolean;
  protected
    function GetSceneCount(): Integer;
    function GetEnableGlobalCollisions(): Boolean;
    procedure SetEnableGlobalCollisions(const AValue: Boolean);
  public
    constructor Create(); override;
    destructor Destroy(); override;

    // Scene management
    procedure AddScene(const AScene: Tg2dScene);
    procedure RemoveScene(const AScene: Tg2dScene); overload;
    procedure RemoveScene(const AName: string); overload;
    function FindScene(const AName: string): Tg2dScene;
    procedure ClearScenes();

    // Update and render
    procedure Update(const AWindow: Tg2dWindow);
    procedure Render();

    // Global collision detection across scenes
    procedure CheckGlobalCollisions();

    // Messaging
    procedure BroadcastMessage(const AName: string; const AData: TValue; const ATags: TArray<string> = []); overload;
    procedure BroadcastMessage(const AName: string; const AData: TValue; const AGroups: TArray<string>; const ADummy: Boolean); overload;
    procedure SendMessage(const AName: string; const AData: TValue; const AEntityID: Cardinal); overload;
    procedure SendMessage(const AName: string; const AData: TValue; const AEntity: Tg2dEntity); overload;

    // Entity queries across all scenes
    function FindEntity(const AID: Cardinal): Tg2dEntity;
    function GetAllEntitiesWithTag(const ATag: string): TArray<Tg2dEntity>;
    function GetAllEntitiesWithGroup(const AGroup: string): TArray<Tg2dEntity>;
    function GetAllEntitiesInRect(const ARect: Tg2dRect): TArray<Tg2dEntity>;
    function GetAllEntitiesInCircle(const ACenter: Tg2dVec; const ARadius: Single): TArray<Tg2dEntity>;

    // Properties
    property SceneCount: Integer read GetSceneCount;
    property EnableGlobalCollisions: Boolean read GetEnableGlobalCollisions write SetEnableGlobalCollisions;
  end;

implementation

uses
  System.DateUtils;

//=== MESSAGE SYSTEM ===========================================================
{ Tg2dMessage }
constructor Tg2dMessage.Create(const AName: string; const AData: TValue);
begin
  Name := AName;
  Data := AData;
  Timestamp := Now;
end;

constructor Tg2dMessageFilter.Create(const ATags: TArray<string>);
begin
  Tags := ATags;
  Groups := [];
  EntityID := 0;
end;

constructor Tg2dMessageFilter.Create(const AGroups: TArray<string>; const ADummy: Boolean);
begin
  Tags := [];
  Groups := AGroups;
  EntityID := 0;
end;

constructor Tg2dMessageFilter.Create(const AEntityID: Cardinal);
begin
  Tags := [];
  Groups := [];
  EntityID := AEntityID;
end;

//=== ENTITY SYSTEM ============================================================
{ Tg2dEntity }
class constructor Tg2dEntity.Create();
begin
  FNextID := 1;
end;

constructor Tg2dEntity.Create();
begin
  inherited Create();
  FID := FNextID;
  Inc(FNextID);
  FTags := TList<string>.Create();
  FGroups := TList<string>.Create();
  FActive := True;
  FVisible := True;
  FTerminated := False;
  FScene := nil;
  FPrevEntity := nil;
  FNextEntity := nil;
  FSprite := nil;
  FOwnsSprite := False;
end;

destructor Tg2dEntity.Destroy();
begin
  ClearSprite();
  if Assigned(FTags) then
    FTags.Free();
  if Assigned(FGroups) then
    FGroups.Free();
  inherited Destroy();
end;

function Tg2dEntity.GetID(): Cardinal;
begin
  Result := FID;
end;

function Tg2dEntity.GetTags(): TArray<string>;
begin
  Result := FTags.ToArray();
end;

function Tg2dEntity.GetGroups(): TArray<string>;
begin
  Result := FGroups.ToArray();
end;

function Tg2dEntity.GetActive(): Boolean;
begin
  Result := FActive;
end;

function Tg2dEntity.GetVisible(): Boolean;
begin
  Result := FVisible;
end;

function Tg2dEntity.GetTerminated(): Boolean;
begin
  Result := FTerminated;
end;

function Tg2dEntity.GetScene(): Tg2dScene;
begin
  Result := FScene;
end;

function Tg2dEntity.GetSprite(): Tg2dSprite;
begin
  Result := FSprite;
end;

function Tg2dEntity.GetOwnsSprite(): Boolean;
begin
  Result := FOwnsSprite;
end;

procedure Tg2dEntity.SetActive(const AValue: Boolean);
begin
  FActive := AValue;
end;

procedure Tg2dEntity.SetVisible(const AValue: Boolean);
begin
  FVisible := AValue;
end;

procedure Tg2dEntity.SetTerminated(const AValue: Boolean);
begin
  FTerminated := AValue;
end;

procedure Tg2dEntity.SetScene(const AValue: Tg2dScene);
begin
  FScene := AValue;
end;

procedure Tg2dEntity.SetSprite(const AValue: Tg2dSprite);
begin
  ClearSprite();
  FSprite := AValue;
  FOwnsSprite := False;
end;

procedure Tg2dEntity.SetOwnsSprite(const AValue: Boolean);
begin
  FOwnsSprite := AValue;
end;

function Tg2dEntity.HasTag(const ATag: string): Boolean;
begin
  Result := FTags.Contains(ATag);
end;

function Tg2dEntity.HasGroup(const AGroup: string): Boolean;
begin
  Result := FGroups.Contains(AGroup);
end;

procedure Tg2dEntity.AddTag(const ATag: string);
begin
  if not FTags.Contains(ATag) then
    FTags.Add(ATag);
end;

procedure Tg2dEntity.RemoveTag(const ATag: string);
begin
  FTags.Remove(ATag);
end;

procedure Tg2dEntity.AddGroup(const AGroup: string);
begin
  if not FGroups.Contains(AGroup) then
    FGroups.Add(AGroup);
end;

procedure Tg2dEntity.RemoveGroup(const AGroup: string);
begin
  FGroups.Remove(AGroup);
end;

procedure Tg2dEntity.CreateSprite(const AAtlas: Tg2dSpriteAtlas);
begin
  ClearSprite();
  FSprite := Tg2dSprite.Init(AAtlas);
  FOwnsSprite := True;
end;

procedure Tg2dEntity.AssignSprite(const ASprite: Tg2dSprite; const AOwnsSprite: Boolean);
begin
  ClearSprite();
  FSprite := ASprite;
  FOwnsSprite := AOwnsSprite;
end;

procedure Tg2dEntity.ClearSprite();
begin
  if Assigned(FSprite) and FOwnsSprite then
    FSprite.Free();
  FSprite := nil;
  FOwnsSprite := False;
end;

function Tg2dEntity.CollidesWith(const AOther: Tg2dEntity): Boolean;
begin
  Result := False;
  if not Assigned(FSprite) or not Assigned(AOther) or not Assigned(AOther.FSprite) then
    Exit;
  Result := FSprite.CollidesWith(AOther.FSprite);
end;

function Tg2dEntity.CollidesWith(const ASprite: Tg2dSprite): Boolean;
begin
  Result := False;
  if not Assigned(FSprite) or not Assigned(ASprite) then
    Exit;
  Result := FSprite.CollidesWith(ASprite);
end;

function Tg2dEntity.CollidesWithPoint(const APoint: Tg2dVec): Boolean;
begin
  Result := False;
  if not Assigned(FSprite) then
    Exit;
  Result := FSprite.CollidesWithPoint(APoint);
end;

function Tg2dEntity.CollidesWithRectangle(const ARect: Tg2dRect): Boolean;
begin
  Result := False;
  if not Assigned(FSprite) then
    Exit;
  Result := FSprite.CollidesWithRectangle(ARect);
end;

function Tg2dEntity.CollidesWithCircle(const ACenter: Tg2dVec; const ARadius: Single): Boolean;
begin
  Result := False;
  if not Assigned(FSprite) then
    Exit;
  Result := FSprite.CollidesWithCircle(ACenter, ARadius);
end;

function Tg2dEntity.GetPosition(): Tg2dVec;
begin
  if Assigned(FSprite) then
    Result := FSprite.Position
  else
    Result := Tg2dVec.Create(0, 0);
end;

procedure Tg2dEntity.SetPosition(const AValue: Tg2dVec);
begin
  if Assigned(FSprite) then
    FSprite.Position := AValue;
end;

procedure Tg2dEntity.SetPosition(const AX, AY: Single);
begin
  SetPosition(Tg2dVec.Create(AX, AY));
end;

function Tg2dEntity.GetScale(): Single;
begin
  if Assigned(FSprite) then
    Result := FSprite.Scale
  else
    Result := 1.0;
end;

procedure Tg2dEntity.SetScale(const AValue: Single);
begin
  if Assigned(FSprite) then
    FSprite.Scale := AValue;
end;

function Tg2dEntity.GetAngle(): Single;
begin
  if Assigned(FSprite) then
    Result := FSprite.Angle
  else
    Result := 0.0;
end;

procedure Tg2dEntity.SetAngle(const AValue: Single);
begin
  if Assigned(FSprite) then
    FSprite.Angle := AValue;
end;

function Tg2dEntity.GetColor(): Tg2dColor;
begin
  if Assigned(FSprite) then
    Result := FSprite.Color
  else
    Result := G2D_WHITE;
end;

procedure Tg2dEntity.SetColor(const AValue: Tg2dColor);
begin
  if Assigned(FSprite) then
    FSprite.Color := AValue;
end;

function Tg2dEntity.PlayAnimation(const AGroupName: string; const ALoop: Boolean; const AFramesPerSecond: Single): Boolean;
begin
  Result := False;
  if Assigned(FSprite) then
    Result := FSprite.Play(AGroupName, ALoop, AFramesPerSecond);
end;

procedure Tg2dEntity.StopAnimation();
begin
  if Assigned(FSprite) then
    FSprite.Stop();
end;

procedure Tg2dEntity.PauseAnimation();
begin
  if Assigned(FSprite) then
    FSprite.Pause();
end;

procedure Tg2dEntity.ResumeAnimation();
begin
  if Assigned(FSprite) then
    FSprite.Resume();
end;

procedure Tg2dEntity.Terminate(const ATerminate: Boolean);
begin
  FTerminated := ATerminate;
end;

function Tg2dEntity.IsTerminated(): Boolean;
begin
  Result := FTerminated;
end;

procedure Tg2dEntity.OnStartup();
begin
  // Override in derived classes
end;

procedure Tg2dEntity.OnShutdown();
begin
  // Override in derived classes
end;

procedure Tg2dEntity.OnUpdate(const AWindow: Tg2dWindow);
begin
  // Update sprite if present
  if Assigned(FSprite) then
    FSprite.Update(AWindow);
end;

procedure Tg2dEntity.OnRender();
begin
  // Render sprite if present and visible
  if Assigned(FSprite) and FVisible then
    FSprite.Draw();
end;

procedure Tg2dEntity.OnMessage(const AName: string; const AData: TValue);
begin
  // Override in derived classes to handle messages
end;

procedure Tg2dEntity.OnCollision(const AOther: Tg2dEntity);
begin
  // Override in derived classes to handle collisions
end;

//=== SCENE SYSTEM =============================================================
{ Tg2dScene }
constructor Tg2dScene.Create();
begin
  inherited Create();
  FName := '';
  FZOrder := 0;
  FVisible := True;
  FFirstEntity := nil;
  FLastEntity := nil;
  FEntityCount := 0;
  FEnableCollisionDetection := True;
end;

procedure Tg2dScene.Init(const AName: string; const AZOrder: Integer);
begin
  FName := AName;
  FZOrder := AZOrder;
end;

destructor Tg2dScene.Destroy();
begin
  ClearEntities();
  inherited Destroy();
end;

function Tg2dScene.GetName(): string;
begin
  Result := FName;
end;

function Tg2dScene.GetZOrder(): Integer;
begin
  Result := FZOrder;
end;

function Tg2dScene.GetVisible(): Boolean;
begin
  Result := FVisible;
end;

function Tg2dScene.GetEntityCount(): Integer;
begin
  Result := FEntityCount;
end;

function Tg2dScene.GetEnableCollisionDetection(): Boolean;
begin
  Result := FEnableCollisionDetection;
end;

procedure Tg2dScene.SetName(const AValue: string);
begin
  FName := AValue;
end;

procedure Tg2dScene.SetZOrder(const AValue: Integer);
begin
  FZOrder := AValue;
end;

procedure Tg2dScene.SetVisible(const AValue: Boolean);
begin
  FVisible := AValue;
end;

procedure Tg2dScene.SetEnableCollisionDetection(const AValue: Boolean);
begin
  FEnableCollisionDetection := AValue;
end;

procedure Tg2dScene.AddEntity(const AEntity: Tg2dEntity);
begin
  if not Assigned(AEntity) then Exit;

  // Set the entity's scene reference
  AEntity.SetScene(Self);

  // Add to double-linked list
  if not Assigned(FFirstEntity) then
  begin
    // First entity in the scene
    FFirstEntity := AEntity;
    FLastEntity := AEntity;
    AEntity.PrevEntity := nil;
    AEntity.NextEntity := nil;
  end
  else
  begin
    // Add to end of list
    FLastEntity.NextEntity := AEntity;
    AEntity.PrevEntity := FLastEntity;
    AEntity.NextEntity := nil;
    FLastEntity := AEntity;
  end;

  Inc(FEntityCount);

  // Call entity startup
  AEntity.OnStartup();
end;

procedure Tg2dScene.RemoveEntity(const AEntity: Tg2dEntity);
var
  LPrev: Tg2dEntity;
  LNext: Tg2dEntity;
begin
  if not Assigned(AEntity) then Exit;

  // Call entity shutdown
  AEntity.OnShutdown();

  LPrev := AEntity.PrevEntity;
  LNext := AEntity.NextEntity;

  // Update linked list pointers
  if Assigned(LPrev) then
    LPrev.NextEntity := LNext
  else
    FFirstEntity := LNext;

  if Assigned(LNext) then
    LNext.PrevEntity := LPrev
  else
    FLastEntity := LPrev;

  // Clear entity's pointers
  AEntity.PrevEntity := nil;
  AEntity.NextEntity := nil;
  AEntity.SetScene(nil);

  Dec(FEntityCount);
end;

procedure Tg2dScene.ClearEntities();
var
  LCurrent: Tg2dEntity;
  LNext: Tg2dEntity;
begin
  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    LNext := LCurrent.NextEntity;
    RemoveEntity(LCurrent);
    LCurrent := LNext;
  end;
  FFirstEntity := nil;
  FLastEntity := nil;
  FEntityCount := 0;
end;

procedure Tg2dScene.UpdateEntities(const AWindow: Tg2dWindow);
var
  LCurrent: Tg2dEntity;
begin
  if not FVisible then Exit;

  // First pass: Update all active entities
  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    if LCurrent.Active and not LCurrent.Terminated then
      LCurrent.OnUpdate(AWindow);
    LCurrent := LCurrent.NextEntity;
  end;

  // Second pass: Check for collisions if enabled (only non-terminated entities)
  if FEnableCollisionDetection then
    CheckCollisions();

  // Third pass: Cleanup terminated entities
  CleanupTerminatedEntities();
end;

procedure Tg2dScene.RenderEntities();
var
  LCurrent: Tg2dEntity;
begin
  if not FVisible then Exit;

  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    if LCurrent.Visible and not LCurrent.Terminated then
      LCurrent.OnRender();
    LCurrent := LCurrent.NextEntity;
  end;
end;

procedure Tg2dScene.CleanupTerminatedEntities();
var
  LCurrent: Tg2dEntity;
  LNext: Tg2dEntity;
  LTerminatedList: TList<Tg2dEntity>;
  LEntity: Tg2dEntity;
begin
  LTerminatedList := TList<Tg2dEntity>.Create();
  try
    // Collect all terminated entities
    LCurrent := FFirstEntity;
    while Assigned(LCurrent) do
    begin
      LNext := LCurrent.NextEntity;
      if LCurrent.Terminated then
        LTerminatedList.Add(LCurrent);
      LCurrent := LNext;
    end;

    // Remove all terminated entities
    for LEntity in LTerminatedList do
      RemoveEntity(LEntity);

  finally
    LTerminatedList.Free();
  end;
end;

procedure Tg2dScene.CheckCollisions();
var
  LCurrent: Tg2dEntity;
  LOther: Tg2dEntity;
begin
  if not FEnableCollisionDetection then Exit;

  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    if LCurrent.Active and not LCurrent.Terminated and Assigned(LCurrent.Sprite) then
    begin
      LOther := LCurrent.NextEntity;
      while Assigned(LOther) do
      begin
        if LOther.Active and not LOther.Terminated and Assigned(LOther.Sprite) then
        begin
          if LCurrent.CollidesWith(LOther) then
          begin
            LCurrent.OnCollision(LOther);
            LOther.OnCollision(LCurrent);
          end;
        end;
        LOther := LOther.NextEntity;
      end;
    end;
    LCurrent := LCurrent.NextEntity;
  end;
end;

function Tg2dScene.GetEntitiesInRect(const ARect: Tg2dRect): TArray<Tg2dEntity>;
var
  LCurrent: Tg2dEntity;
  LResultList: TList<Tg2dEntity>;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    LCurrent := FFirstEntity;
    while Assigned(LCurrent) do
    begin
      if LCurrent.Active and not LCurrent.Terminated and LCurrent.CollidesWithRectangle(ARect) then
        LResultList.Add(LCurrent);
      LCurrent := LCurrent.NextEntity;
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dScene.GetEntitiesInCircle(const ACenter: Tg2dVec; const ARadius: Single): TArray<Tg2dEntity>;
var
  LCurrent: Tg2dEntity;
  LResultList: TList<Tg2dEntity>;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    LCurrent := FFirstEntity;
    while Assigned(LCurrent) do
    begin
      if LCurrent.Active and not LCurrent.Terminated and LCurrent.CollidesWithCircle(ACenter, ARadius) then
        LResultList.Add(LCurrent);
      LCurrent := LCurrent.NextEntity;
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dScene.GetEntitiesWithTag(const ATag: string): TArray<Tg2dEntity>;
var
  LCurrent: Tg2dEntity;
  LResultList: TList<Tg2dEntity>;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    LCurrent := FFirstEntity;
    while Assigned(LCurrent) do
    begin
      if not LCurrent.Terminated and LCurrent.HasTag(ATag) then
        LResultList.Add(LCurrent);
      LCurrent := LCurrent.NextEntity;
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dScene.GetEntitiesWithGroup(const AGroup: string): TArray<Tg2dEntity>;
var
  LCurrent: Tg2dEntity;
  LResultList: TList<Tg2dEntity>;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    LCurrent := FFirstEntity;
    while Assigned(LCurrent) do
    begin
      if not LCurrent.Terminated and LCurrent.HasGroup(AGroup) then
        LResultList.Add(LCurrent);
      LCurrent := LCurrent.NextEntity;
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

procedure Tg2dScene.SendMessage(const AMessage: Tg2dMessage; const AFilter: Tg2dMessageFilter);
var
  LCurrent: Tg2dEntity;
  LMatches: Boolean;
  LTag: string;
  LGroup: string;
begin
  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    LMatches := False;

    // Check entity ID filter
    if AFilter.EntityID > 0 then
    begin
      LMatches := (LCurrent.ID = AFilter.EntityID);
    end
    else
    begin
      // Check tag filter
      if Length(AFilter.Tags) > 0 then
      begin
        for LTag in AFilter.Tags do
        begin
          if LCurrent.HasTag(LTag) then
          begin
            LMatches := True;
            Break;
          end;
        end;
      end
      else if Length(AFilter.Groups) > 0 then
      begin
        // Check group filter
        for LGroup in AFilter.Groups do
        begin
          if LCurrent.HasGroup(LGroup) then
          begin
            LMatches := True;
            Break;
          end;
        end;
      end
      else
      begin
        // No filter = send to all
        LMatches := True;
      end;
    end;

    if LMatches then
      LCurrent.OnMessage(AMessage.Name, AMessage.Data);

    LCurrent := LCurrent.NextEntity;
  end;
end;

function Tg2dScene.FindEntity(const AID: Cardinal): Tg2dEntity;
var
  LCurrent: Tg2dEntity;
begin
  Result := nil;
  LCurrent := FFirstEntity;
  while Assigned(LCurrent) do
  begin
    if LCurrent.ID = AID then
    begin
      Result := LCurrent;
      Break;
    end;
    LCurrent := LCurrent.NextEntity;
  end;
end;

//=== WORLD SYSTEM =============================================================
constructor Tg2dWorld.Create();
begin
  inherited Create();
  FScenes := TList<Tg2dScene>.Create();
  FEnableGlobalCollisions := False;
end;

destructor Tg2dWorld.Destroy();
begin
  ClearScenes();
  FScenes.Free();
  inherited Destroy();
end;

function Tg2dWorld.GetSceneCount(): Integer;
begin
  Result := FScenes.Count;
end;

function Tg2dWorld.GetEnableGlobalCollisions(): Boolean;
begin
  Result := FEnableGlobalCollisions;
end;

procedure Tg2dWorld.SetEnableGlobalCollisions(const AValue: Boolean);
begin
  FEnableGlobalCollisions := AValue;
end;

procedure Tg2dWorld.AddScene(const AScene: Tg2dScene);
var
  LI: Integer;
  LInserted: Boolean;
begin
  if not Assigned(AScene) then Exit;

  // Insert scene in Z-order (lower values first)
  LInserted := False;
  for LI := 0 to FScenes.Count - 1 do
  begin
    if AScene.ZOrder < FScenes[LI].ZOrder then
    begin
      FScenes.Insert(LI, AScene);
      LInserted := True;
      Break;
    end;
  end;

  if not LInserted then
    FScenes.Add(AScene);
end;

procedure Tg2dWorld.RemoveScene(const AScene: Tg2dScene);
begin
  if Assigned(AScene) then
    FScenes.Remove(AScene);
end;

procedure Tg2dWorld.RemoveScene(const AName: string);
var
  LScene: Tg2dScene;
begin
  LScene := FindScene(AName);
  if Assigned(LScene) then
    FScenes.Remove(LScene);
end;

function Tg2dWorld.FindScene(const AName: string): Tg2dScene;
var
  LScene: Tg2dScene;
begin
  Result := nil;
  for LScene in FScenes do
  begin
    if SameText(LScene.Name, AName) then
    begin
      Result := LScene;
      Break;
    end;
  end;
end;

procedure Tg2dWorld.ClearScenes();
begin
  FScenes.Clear();
end;

procedure Tg2dWorld.Update(const AWindow: Tg2dWindow);
var
  LScene: Tg2dScene;
begin
  for LScene in FScenes do
    LScene.UpdateEntities(AWindow);

  // Check global collisions across scenes if enabled
  if FEnableGlobalCollisions then
    CheckGlobalCollisions();
end;

procedure Tg2dWorld.Render();
var
  LScene: Tg2dScene;
begin
  for LScene in FScenes do
    LScene.RenderEntities();
end;

procedure Tg2dWorld.CheckGlobalCollisions();
var
  LScene1: Tg2dScene;
  LScene2: Tg2dScene;
  LEntity1: Tg2dEntity;
  LEntity2: Tg2dEntity;
  LI: Integer;
  LJ: Integer;
begin
  if not FEnableGlobalCollisions then Exit;

  // Check collisions between entities in different scenes
  for LI := 0 to FScenes.Count - 1 do
  begin
    LScene1 := FScenes[LI];
    for LJ := LI + 1 to FScenes.Count - 1 do
    begin
      LScene2 := FScenes[LJ];

      LEntity1 := LScene1.FFirstEntity;
      while Assigned(LEntity1) do
      begin
        if LEntity1.Active and not LEntity1.Terminated and Assigned(LEntity1.Sprite) then
        begin
          LEntity2 := LScene2.FFirstEntity;
          while Assigned(LEntity2) do
          begin
            if LEntity2.Active and not LEntity2.Terminated and Assigned(LEntity2.Sprite) then
            begin
              if LEntity1.CollidesWith(LEntity2) then
              begin
                LEntity1.OnCollision(LEntity2);
                LEntity2.OnCollision(LEntity1);
              end;
            end;
            LEntity2 := LEntity2.NextEntity;
          end;
        end;
        LEntity1 := LEntity1.NextEntity;
      end;
    end;
  end;
end;

procedure Tg2dWorld.BroadcastMessage(const AName: string; const AData: TValue; const ATags: TArray<string>);
var
  LMessage: Tg2dMessage;
  LFilter: Tg2dMessageFilter;
  LScene: Tg2dScene;
begin
  LMessage := Tg2dMessage.Create(AName, AData);
  LFilter := Tg2dMessageFilter.Create(ATags);

  for LScene in FScenes do
    LScene.SendMessage(LMessage, LFilter);
end;

procedure Tg2dWorld.BroadcastMessage(const AName: string; const AData: TValue; const AGroups: TArray<string>; const ADummy: Boolean);
var
  LMessage: Tg2dMessage;
  LFilter: Tg2dMessageFilter;
  LScene: Tg2dScene;
begin
  LMessage := Tg2dMessage.Create(AName, AData);
  LFilter := Tg2dMessageFilter.Create(AGroups, True);

  for LScene in FScenes do
    LScene.SendMessage(LMessage, LFilter);
end;

procedure Tg2dWorld.SendMessage(const AName: string; const AData: TValue; const AEntityID: Cardinal);
var
  LMessage: Tg2dMessage;
  LFilter: Tg2dMessageFilter;
  LScene: Tg2dScene;
begin
  LMessage := Tg2dMessage.Create(AName, AData);
  LFilter := Tg2dMessageFilter.Create(AEntityID);

  for LScene in FScenes do
    LScene.SendMessage(LMessage, LFilter);
end;

procedure Tg2dWorld.SendMessage(const AName: string; const AData: TValue; const AEntity: Tg2dEntity);
begin
  if Assigned(AEntity) then
    SendMessage(AName, AData, AEntity.ID);
end;

function Tg2dWorld.FindEntity(const AID: Cardinal): Tg2dEntity;
var
  LScene: Tg2dScene;
begin
  Result := nil;
  for LScene in FScenes do
  begin
    Result := LScene.FindEntity(AID);
    if Assigned(Result) then
      Break;
  end;
end;

function Tg2dWorld.GetAllEntitiesWithTag(const ATag: string): TArray<Tg2dEntity>;
var
  LScene: Tg2dScene;
  LSceneEntities: TArray<Tg2dEntity>;
  LResultList: TList<Tg2dEntity>;
  LEntity: Tg2dEntity;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    for LScene in FScenes do
    begin
      LSceneEntities := LScene.GetEntitiesWithTag(ATag);
      for LEntity in LSceneEntities do
        LResultList.Add(LEntity);
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dWorld.GetAllEntitiesWithGroup(const AGroup: string): TArray<Tg2dEntity>;
var
  LScene: Tg2dScene;
  LSceneEntities: TArray<Tg2dEntity>;
  LResultList: TList<Tg2dEntity>;
  LEntity: Tg2dEntity;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    for LScene in FScenes do
    begin
      LSceneEntities := LScene.GetEntitiesWithGroup(AGroup);
      for LEntity in LSceneEntities do
        LResultList.Add(LEntity);
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dWorld.GetAllEntitiesInRect(const ARect: Tg2dRect): TArray<Tg2dEntity>;
var
  LScene: Tg2dScene;
  LSceneEntities: TArray<Tg2dEntity>;
  LResultList: TList<Tg2dEntity>;
  LEntity: Tg2dEntity;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    for LScene in FScenes do
    begin
      LSceneEntities := LScene.GetEntitiesInRect(ARect);
      for LEntity in LSceneEntities do
        LResultList.Add(LEntity);
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

function Tg2dWorld.GetAllEntitiesInCircle(const ACenter: Tg2dVec; const ARadius: Single): TArray<Tg2dEntity>;
var
  LScene: Tg2dScene;
  LSceneEntities: TArray<Tg2dEntity>;
  LResultList: TList<Tg2dEntity>;
  LEntity: Tg2dEntity;
begin
  LResultList := TList<Tg2dEntity>.Create();
  try
    for LScene in FScenes do
    begin
      LSceneEntities := LScene.GetEntitiesInCircle(ACenter, ARadius);
      for LEntity in LSceneEntities do
        LResultList.Add(LEntity);
    end;
    Result := LResultList.ToArray();
  finally
    LResultList.Free();
  end;
end;

end.

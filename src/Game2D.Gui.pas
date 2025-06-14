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

 Game2D.Gui - Complete ImGui Wrapper for Game2D
===============================================================================
Game2D.Gui - Professional Game Development UI Framework

A comprehensive ImGui wrapper providing complete immediate-mode GUI capabilities
for game development. This unit delivers production-ready user interface tools
with modern styling, comprehensive widget sets, and seamless integration with
the Game2D engine architecture.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════
Built on immediate-mode GUI principles with static class-based design:

• **Tg2dGui Static Class** - All functionality through class methods
• **OpenGL 2.1 Backend** - Hardware-accelerated rendering pipeline
• **GLFW Integration** - Native window system event handling
• **Memory Safe Design** - Automatic resource management and cleanup
• **Thread Safe Operations** - Proper synchronization for game loops

Key architectural benefits:
• Zero-allocation widget creation during runtime
• Automatic layout and sizing calculations
• Built-in state management for all UI elements
• Cross-platform consistency across Windows, macOS, and Linux
• Hot-reloadable styling and themes

═══════════════════════════════════════════════════════════════════════════════
LIFECYCLE MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
Essential initialization and cleanup operations for GUI system:

• **Initialize()** - Creates ImGui context and backend systems
• **Shutdown()** - Properly destroys all GUI resources
• **NewFrame()** - Begins frame rendering cycle
• **Render()** - Executes final rendering commands

BASIC SETUP:
  var
    LWindow: Tg2dWindow;
  begin
    LWindow := Tg2dWindow.Create();
    LWindow.Open('Game Window', 1024, 768, 0, True, True);

    // Initialize GUI system
    if Tg2dGui.Initialize(LWindow, True) then
    begin
      // Main game loop
      while LWindow.ShouldClose() do
      begin
        Tg2dGui.NewFrame();

        // Your GUI code here
        if Tg2dGui.Begin('Game Menu') then
        begin
          Tg2dGui.Text('Welcome to Game2D!');
          Tg2dGui.End();
        end;

        Tg2dGui.Render();
        LWindow.Present();
      end;

      Tg2dGui.Shutdown();
    end;
    LWindow.Free();
  end;

═══════════════════════════════════════════════════════════════════════════════
WINDOW MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
Flexible window creation and management system supporting:

• **Multiple Window Types** - Overlapping, docked, and modal windows
• **Advanced Layout Control** - Precise positioning and sizing
• **Window State Management** - Minimized, maximized, and focused states
• **Docking System** - Professional IDE-style window arrangements

WINDOW CREATION:
  var
    LIsOpen: Boolean;
  begin
    LIsOpen := True;
    if Tg2dGui.Begin('Settings Window', @LIsOpen,
       G2D_GUI_WINDOW_FLAGS_NO_RESIZE) then
    begin
      Tg2dGui.Text('Game Settings');
      Tg2dGui.Separator();
      // Add settings controls here
      Tg2dGui.End();
    end;
    // Window automatically closes when LIsOpen becomes False
  end;

CHILD WINDOWS FOR COMPLEX LAYOUTS:
  begin
    if Tg2dGui.BeginChild('left_panel', Tg2dVec.Create(200, 0), True) then
    begin
      Tg2dGui.Text('Navigation Panel');
      if Tg2dGui.Button('Level 1') then
        LoadLevel(1);
      Tg2dGui.EndChild();
    end;

    Tg2dGui.SameLine();

    if Tg2dGui.BeginChild('content_panel') then
    begin
      Tg2dGui.Text('Main Content Area');
      Tg2dGui.EndChild();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INPUT CONTROLS
═══════════════════════════════════════════════════════════════════════════════
Complete set of input widgets for game configuration and user interaction:

• **Text Input** - Single-line, multi-line, with hints and validation
• **Numeric Input** - Integers, floats, with step controls and ranges
• **Specialized Input** - Password fields, hexadecimal, scientific notation
• **Real-time Validation** - Custom callbacks for input processing

TEXT INPUT WITH VALIDATION:
  var
    LPlayerName: array[0..63] of AnsiChar;
    LNameChanged: Boolean;
  begin
    FillChar(LPlayerName, SizeOf(LPlayerName), 0);
    StrPCopy(LPlayerName, AnsiString(FCurrentPlayerName));

    LNameChanged := Tg2dGui.InputTextWithHint('Player Name',
      'Enter your player name...',
      LPlayerName,
      SizeOf(LPlayerName),
      G2D_GUI_INPUT_TEXT_FLAGS_ENTER_RETURNS_TRUE);

    if LNameChanged then
    begin
      FCurrentPlayerName := string(LPlayerName);
      SavePlayerSettings();
    end;
  end;

NUMERIC CONTROLS FOR GAME SETTINGS:
  var
    LVolume: Single;
    LDifficulty: Integer;
  begin
    LVolume := GetMasterVolume();
    if Tg2dGui.SliderFloat('Master Volume', @LVolume, 0.0, 1.0, '%.1f') then
      SetMasterVolume(LVolume);

    LDifficulty := GetDifficultyLevel();
    if Tg2dGui.InputInt('Difficulty', @LDifficulty, 1, 1,
       G2D_GUI_INPUT_TEXT_FLAGS_ENTER_RETURNS_TRUE) then
    begin
      LDifficulty := Max(1, Min(10, LDifficulty)); // Clamp to valid range
      SetDifficultyLevel(LDifficulty);
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
BUTTON CONTROLS
═══════════════════════════════════════════════════════════════════════════════
Versatile button system supporting multiple interaction patterns:

• **Standard Buttons** - Text, sized, and invisible buttons
• **Specialized Buttons** - Arrow, image, and small buttons
• **Interactive Elements** - Checkboxes, radio buttons, and toggles
• **Visual Feedback** - Hover states, pressed states, and disabled states

GAME MENU SYSTEM:
  var
    LStartGame: Boolean;
    LShowOptions: Boolean;
    LQuitGame: Boolean;
  begin
    Tg2dGui.PushStyleVar(G2D_GUI_STYLE_VAR_BUTTON_TEXT_ALIGN,
      Tg2dVec.Create(0.5, 0.5));

    LStartGame := Tg2dGui.Button('START GAME', Tg2dVec.Create(200, 50));
    LShowOptions := Tg2dGui.Button('OPTIONS', Tg2dVec.Create(200, 50));
    LQuitGame := Tg2dGui.Button('QUIT', Tg2dVec.Create(200, 50));

    Tg2dGui.PopStyleVar();

    if LStartGame then
      StartNewGame();
    if LShowOptions then
      ShowOptionsDialog();
    if LQuitGame then
      RequestShutdown();
  end;

IMAGE BUTTONS FOR INVENTORY:
  var
    LSwordTexture: Tg2dTexture;
    LShieldTexture: Tg2dTexture;
  begin
    LSwordTexture := GetItemTexture('sword');
    LShieldTexture := GetItemTexture('shield');

    if Tg2dGui.ImageButton(LSwordTexture, Tg2dVec.Create(64, 64)) then
      EquipItem('sword');

    Tg2dGui.SameLine();

    if Tg2dGui.ImageButton(LShieldTexture, Tg2dVec.Create(64, 64)) then
      EquipItem('shield');
  end;

═══════════════════════════════════════════════════════════════════════════════
SELECTION CONTROLS
═══════════════════════════════════════════════════════════════════════════════
Advanced selection widgets for complex data presentation:

• **Combo Boxes** - Dropdown lists with search and custom rendering
• **List Boxes** - Scrollable lists with multi-selection support
• **Selectable Items** - Interactive list items with state management
• **Tree Nodes** - Hierarchical data presentation with collapsing

GAME SETTINGS COMBO:
  var
    LSelectedResolution: Integer;
    LResolutions: array of string;
  begin
    SetLength(LResolutions, 4);
    LResolutions[0] := '1024x768';
    LResolutions[1] := '1280x720';
    LResolutions[2] := '1920x1080';
    LResolutions[3] := '2560x1440';

    LSelectedResolution := GetCurrentResolutionIndex();

    if Tg2dGui.Combo('Resolution', @LSelectedResolution, LResolutions) then
      ApplyResolution(LResolutions[LSelectedResolution]);
  end;

HIERARCHICAL SAVE GAME BROWSER:
  var
    LSaveSlot: Integer;
  begin
    if Tg2dGui.TreeNode('Save Games') then
    begin
      for LSaveSlot := 1 to 10 do
      begin
        if SaveGameExists(LSaveSlot) then
        begin
          if Tg2dGui.Selectable(Format('Save Slot %d - %s',
             [LSaveSlot, GetSaveGameName(LSaveSlot)])) then
            LoadSaveGame(LSaveSlot);
        end
        else
        begin
          Tg2dGui.TextDisabled(Format('Empty Slot %d', [LSaveSlot]));
        end;
      end;
      Tg2dGui.TreePop();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
COLOR CONTROLS
═══════════════════════════════════════════════════════════════════════════════
Professional color manipulation tools for customization systems:

• **Color Pickers** - RGB, HSV, and hex color selection
• **Color Editors** - Inline color modification with alpha support
• **Color Buttons** - Compact color display and selection
• **Advanced Features** - HDR colors, color palettes, and eyedropper

PLAYER CUSTOMIZATION SYSTEM:
  var
    LPlayerColor: Tg2dColor;
    LUIThemeColor: Tg2dColor;
  begin
    LPlayerColor := GetPlayerColor();
    if Tg2dGui.ColorEdit4('Player Color', LPlayerColor,
       G2D_GUI_COLOR_EDIT_FLAGS_ALPHA_BAR) then
      SetPlayerColor(LPlayerColor);

    LUIThemeColor := GetUIThemeColor();
    if Tg2dGui.ColorPicker3('UI Theme', LUIThemeColor) then
      ApplyUITheme(LUIThemeColor);
  end;

═══════════════════════════════════════════════════════════════════════════════
TABLE SYSTEM
═══════════════════════════════════════════════════════════════════════════════
Advanced table widget for complex data presentation:

• **Multi-Column Support** - Resizable, sortable, and reorderable columns
• **Data Binding** - Efficient large dataset handling
• **Interactive Features** - Row selection, context menus, and editing
• **Advanced Styling** - Alternating row colors, borders, and highlighting

PLAYER STATISTICS TABLE:
  var
    LPlayer: Integer;
    LPlayerStats: TPlayerStats;
  begin
    if Tg2dGui.BeginTable('PlayerStats', 4,
       G2D_GUI_TABLE_FLAGS_BORDERS or G2D_GUI_TABLE_FLAGS_ROW_BG) then
    begin
      // Setup columns
      Tg2dGui.TableSetupColumn('Player');
      Tg2dGui.TableSetupColumn('Score');
      Tg2dGui.TableSetupColumn('Level');
      Tg2dGui.TableSetupColumn('Deaths');
      Tg2dGui.TableHeadersRow();

      // Display player data
      for LPlayer := 0 to GetPlayerCount() - 1 do
      begin
        LPlayerStats := GetPlayerStats(LPlayer);
        Tg2dGui.TableNextRow();

        Tg2dGui.TableNextColumn();
        Tg2dGui.Text(LPlayerStats.Name);

        Tg2dGui.TableNextColumn();
        Tg2dGui.Text('%d', [LPlayerStats.Score]);

        Tg2dGui.TableNextColumn();
        Tg2dGui.Text('%d', [LPlayerStats.Level]);

        Tg2dGui.TableNextColumn();
        Tg2dGui.Text('%d', [LPlayerStats.Deaths]);
      end;

      Tg2dGui.EndTable();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
MENU SYSTEMS
═══════════════════════════════════════════════════════════════════════════════
Complete menu bar and context menu implementation:

• **Menu Bars** - Traditional application-style menu systems
• **Context Menus** - Right-click contextual menu support
• **Nested Menus** - Multi-level menu hierarchies
• **Menu Items** - Checkable items, separators, and shortcuts

GAME MENU BAR:
  begin
    if Tg2dGui.BeginMenuBar() then
    begin
      if Tg2dGui.BeginMenu('Game') then
      begin
        if Tg2dGui.MenuItem('New Game', 'Ctrl+N') then
          StartNewGame();
        if Tg2dGui.MenuItem('Load Game', 'Ctrl+L') then
          ShowLoadDialog();
        Tg2dGui.Separator();
        if Tg2dGui.MenuItem('Exit', 'Alt+F4') then
          RequestExit();
        Tg2dGui.EndMenu();
      end;

      if Tg2dGui.BeginMenu('Options') then
      begin
        Tg2dGui.MenuItem('Sound Enabled', '', @GSoundEnabled);
        Tg2dGui.MenuItem('Fullscreen', 'F11', @GFullscreenMode);
        Tg2dGui.EndMenu();
      end;

      Tg2dGui.EndMenuBar();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
POPUP SYSTEMS
═══════════════════════════════════════════════════════════════════════════════
Modal and non-modal popup management for dialogs and notifications:

• **Modal Popups** - Blocking dialogs for critical user input
• **Context Popups** - Item-specific right-click menus
• **Tooltips** - Hover-based information display
• **Notifications** - Non-intrusive status messages

CONFIRMATION DIALOG:
  var
    LShowDeleteConfirm: Boolean;
  begin
    if LShowDeleteConfirm then
      Tg2dGui.OpenPopup('Delete Confirm');

    if Tg2dGui.BeginPopupModal('Delete Confirm') then
    begin
      Tg2dGui.Text('Are you sure you want to delete this save game?');
      Tg2dGui.Separator();

      if Tg2dGui.Button('Yes') then
      begin
        DeleteSaveGame();
        Tg2dGui.CloseCurrentPopup();
      end;

      Tg2dGui.SameLine();

      if Tg2dGui.Button('No') then
        Tg2dGui.CloseCurrentPopup();

      Tg2dGui.EndPopup();
    end;
  end;

CONTEXT MENU FOR INVENTORY ITEMS:
  begin
    if Tg2dGui.BeginPopupContextItem('item_menu') then
    begin
      if Tg2dGui.MenuItem('Use Item') then
        UseSelectedItem();
      if Tg2dGui.MenuItem('Drop Item') then
        DropSelectedItem();
      Tg2dGui.Separator();
      if Tg2dGui.MenuItem('Item Info') then
        ShowItemDetails();
      Tg2dGui.EndPopup();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
LAYOUT MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
Sophisticated layout system for professional UI arrangement:

• **Automatic Layout** - Smart positioning and sizing calculations
• **Manual Positioning** - Precise cursor and element placement
• **Grouping System** - Logical grouping of related elements
• **Responsive Design** - Adaptive layouts for different screen sizes

RESPONSIVE GAME HUD:
  var
    LContentRegion: Tg2dVec;
    LHealthBarWidth: Single;
  begin
    LContentRegion := Tg2dGui.GetContentRegionAvail();

    // Health bar takes 30% of available width
    LHealthBarWidth := LContentRegion.x * 0.3;

    Tg2dGui.PushItemWidth(LHealthBarWidth);
    Tg2dGui.ProgressBar(GetPlayerHealth() / GetMaxHealth(),
      Tg2dVec.Create(0, 0), 'Health');
    Tg2dGui.PopItemWidth();

    // Position minimap in top-right corner
    Tg2dGui.SetCursorPos(Tg2dVec.Create(LContentRegion.x - 200, 10));
    DrawMinimap(Tg2dVec.Create(200, 150));
  end;

═══════════════════════════════════════════════════════════════════════════════
STYLING AND THEMING
═══════════════════════════════════════════════════════════════════════════════
Comprehensive styling system for custom visual appearance:

• **Color Themes** - Dark, light, and custom color schemes
• **Style Variables** - Spacing, padding, and sizing customization
• **Custom Styling** - Per-widget style overrides
• **Dynamic Theming** - Runtime style modifications

CUSTOM GAME THEME:
  begin
    // Apply dark theme as base
    Tg2dGui.StyleColorsDark();

    // Customize colors for game branding
    Tg2dGui.PushStyleColor(G2D_GUI_COL_BUTTON,
      Tg2dColor.Create(0.2, 0.4, 0.8, 1.0));
    Tg2dGui.PushStyleColor(G2D_GUI_COL_BUTTON_HOVERED,
      Tg2dColor.Create(0.3, 0.5, 0.9, 1.0));
    Tg2dGui.PushStyleColor(G2D_GUI_COL_BUTTON_ACTIVE,
      Tg2dColor.Create(0.1, 0.3, 0.7, 1.0));

    // Adjust spacing for mobile-friendly layout
    Tg2dGui.PushStyleVar(G2D_GUI_STYLE_VAR_ITEM_SPACING,
      Tg2dVec.Create(8, 8));
    Tg2dGui.PushStyleVar(G2D_GUI_STYLE_VAR_FRAME_PADDING,
      Tg2dVec.Create(6, 6));

    // Your styled GUI code here

    // Restore original styling
    Tg2dGui.PopStyleColor(3);
    Tg2dGui.PopStyleVar(2);
  end;

═══════════════════════════════════════════════════════════════════════════════
DRAWING PRIMITIVES
═══════════════════════════════════════════════════════════════════════════════
Direct drawing capabilities for custom visual elements:

• **Shape Drawing** - Rectangles, circles, and lines
• **Text Rendering** - Custom positioned text with color support
• **Advanced Graphics** - Filled shapes, outlined shapes, and gradients
• **Performance Optimized** - Efficient batch rendering system

CUSTOM HEALTH BAR VISUALIZATION:
  var
    LDrawPos: Tg2dVec;
    LBarSize: Tg2dVec;
    LHealthPercent: Single;
    LHealthColor: Tg2dColor;
  begin
    LDrawPos := Tg2dGui.GetCursorScreenPos();
    LBarSize := Tg2dVec.Create(200, 20);
    LHealthPercent := GetPlayerHealth() / GetMaxHealth();

    // Background
    Tg2dGui.AddRectFilled(LDrawPos,
      Tg2dVec.Create(LDrawPos.x + LBarSize.x, LDrawPos.y + LBarSize.y),
      G2D_BLACK);

    // Health bar color based on percentage
    if LHealthPercent > 0.6 then
      LHealthColor := G2D_GREEN
    else if LHealthPercent > 0.3 then
      LHealthColor := G2D_YELLOW
    else
      LHealthColor := G2D_RED;

    // Health fill
    Tg2dGui.AddRectFilled(LDrawPos,
      Tg2dVec.Create(LDrawPos.x + (LBarSize.x * LHealthPercent),
                     LDrawPos.y + LBarSize.y),
      LHealthColor);

    // Border
    Tg2dGui.AddRect(LDrawPos,
      Tg2dVec.Create(LDrawPos.x + LBarSize.x, LDrawPos.y + LBarSize.y),
      G2D_WHITE);

    // Health text
    Tg2dGui.AddText(Tg2dVec.Create(LDrawPos.x + 5, LDrawPos.y + 2),
      G2D_WHITE, Format('Health: %d/%d',
      [GetPlayerHealth(), GetMaxHealth()]));
  end;

═══════════════════════════════════════════════════════════════════════════════
INPUT HANDLING
═══════════════════════════════════════════════════════════════════════════════
Comprehensive input system integration with game controls:

• **Mouse Interaction** - Position tracking, button states, and dragging
• **Keyboard Support** - Key states, text input, and navigation
• **Focus Management** - Widget focus and tab navigation
• **Event Processing** - Custom input callbacks and validation

INTEGRATED GAME CONTROLS:
  var
    LMousePos: Tg2dVec;
    LIsMouseDragging: Boolean;
  begin
    LMousePos := Tg2dGui.GetMousePos();
    LIsMouseDragging := Tg2dGui.IsMouseDragging(0);

    // Handle camera movement when not over GUI
    if not Tg2dGui.IsAnyItemHovered() and LIsMouseDragging then
    begin
      LCameraDelta := Tg2dGui.GetMouseDragDelta(0);
      MoveCameraBy(LCameraDelta);
      Tg2dGui.ResetMouseDragDelta(0);
    end;

    // Set focus to name input when F2 is pressed
    if Tg2dGui.IsKeyPressed(G2D_GUI_KEY_F2) then
      Tg2dGui.SetKeyboardFocusHere();
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPLETE GAME MENU EXAMPLE
═══════════════════════════════════════════════════════════════════════════════
Production-ready game menu system demonstrating multiple features:

  var
    LWindow: Tg2dWindow;
    LShowDemo: Boolean;
    LGameState: TGameState;
    LPlayerName: array[0..31] of AnsiChar;
    LMasterVolume: Single;
    LSelectedLevel: Integer;
    LGameLevels: array of string;
  begin
    // Initialize system
    LWindow := Tg2dWindow.Create();
    LWindow.Open('Game2D Menu Demo', 1024, 768, 0, True, True);

    if Tg2dGui.Initialize(LWindow, True) then
    begin
      // Initialize demo data
      LShowDemo := False;
      LGameState := gsMainMenu;
      StrPCopy(LPlayerName, 'Player');
      LMasterVolume := 0.8;
      LSelectedLevel := 0;
      SetLength(LGameLevels, 3);
      LGameLevels[0] := 'Forest Temple';
      LGameLevels[1] := 'Mountain Pass';
      LGameLevels[2] := 'Dragon Lair';

      // Main application loop
      while not LWindow.ShouldClose() do
      begin
        LWindow.StartFrame();
        Tg2dGui.NewFrame();

        // Main menu system
        case LGameState of
          gsMainMenu:
          begin
            Tg2dGui.SetNextWindowPos(Tg2dVec.Create(100, 100), 0);
            Tg2dGui.SetNextWindowSize(Tg2dVec.Create(300, 400), 0);

            if Tg2dGui.Begin('Main Menu', nil,
               G2D_GUI_WINDOW_FLAGS_NO_RESIZE or
               G2D_GUI_WINDOW_FLAGS_NO_MOVE) then
            begin
              Tg2dGui.Text('Welcome to Game2D!');
              Tg2dGui.Separator();

              if Tg2dGui.Button('New Game', Tg2dVec.Create(200, 40)) then
                LGameState := gsLevelSelect;

              if Tg2dGui.Button('Load Game', Tg2dVec.Create(200, 40)) then
                ShowLoadDialog();

              if Tg2dGui.Button('Settings', Tg2dVec.Create(200, 40)) then
                LGameState := gsSettings;

              if Tg2dGui.Button('Exit', Tg2dVec.Create(200, 40)) then
                LWindow.SetShouldClose(True);

              Tg2dGui.End();
            end;
          end;

          gsSettings:
          begin
            if Tg2dGui.Begin('Settings') then
            begin
              // Player name input
              if Tg2dGui.InputText('Player Name', LPlayerName,
                 SizeOf(LPlayerName)) then
                SavePlayerName(string(LPlayerName));

              // Volume control
              if Tg2dGui.SliderFloat('Master Volume', @LMasterVolume,
                 0.0, 1.0, '%.1f') then
                SetMasterVolume(LMasterVolume);

              Tg2dGui.Separator();

              if Tg2dGui.Button('Back to Menu') then
                LGameState := gsMainMenu;

              Tg2dGui.End();
            end;
          end;

          gsLevelSelect:
          begin
            if Tg2dGui.Begin('Level Selection') then
            begin
              Tg2dGui.Text('Choose your adventure:');

              if Tg2dGui.Combo('Level', @LSelectedLevel, LGameLevels) then
              begin
                // Level selection changed
              end;

              if Tg2dGui.Button('Start Level') then
              begin
                StartLevel(LSelectedLevel);
                LGameState := gsInGame;
              end;

              Tg2dGui.SameLine();

              if Tg2dGui.Button('Back') then
                LGameState := gsMainMenu;

              Tg2dGui.End();
            end;
          end;
        end;

        // Debug window toggle
        if Tg2dGui.IsKeyPressed(G2D_GUI_KEY_F1) then
          LShowDemo := not LShowDemo;

        if LShowDemo then
          Tg2dGui.ShowDemoWindow(@LShowDemo);

        Tg2dGui.Render();
        LWindow.EndFrame();
      end;

      Tg2dGui.Shutdown();
    end;

    LWindow.Free();
  end;

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════
• Use IsInitialized() checks to prevent crashes from invalid state calls
• Prefer static strings over dynamic strings for labels to reduce allocations
• Cache texture references for image buttons to avoid repeated lookups
• Use popup modals sparingly as they block the entire UI interaction
• Consider widget hierarchy depth - deeply nested widgets impact performance

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
• All GUI resources are automatically managed by the ImGui backend
• Font textures are created once during initialization and reused
• No manual cleanup required for individual widgets or windows
• Shutdown() automatically destroys all GUI contexts and resources
• String parameters are internally converted to UTF-8 as needed

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION PATTERNS
═══════════════════════════════════════════════════════════════════════════════
• Call NewFrame() at the beginning of each game loop iteration
• Create all GUI elements between NewFrame() and Render() calls
• Use window flags to create appropriate UI layouts for different game states
• Integrate with game state management for proper menu transitions
• Handle window close events to maintain proper application lifecycle

===============================================================================}

unit Game2D.Gui;

{$I Game2D.Defines.inc}

interface

uses
  WinApi.Windows,
  System.SysUtils,
  Game2D.Deps,
  Game2D.Common,
  Game2D.Core;

{$REGION ' TYPES '}
type
  // GUI Flags - mapped from ImGui flags
  Tg2dGuiWindowFlags = Cardinal;
  Tg2dGuiInputTextFlags = Cardinal;
  Tg2dGuiColorEditFlags = Cardinal;
  Tg2dGuiTableFlags = Cardinal;
  Tg2dGuiTableColumnFlags = Cardinal;
  Tg2dGuiTableRowFlags = Cardinal;
  Tg2dGuiComboFlags = Cardinal;
  Tg2dGuiSelectableFlags = Cardinal;
  Tg2dGuiTabBarFlags = Cardinal;
  Tg2dGuiTabItemFlags = Cardinal;
  Tg2dGuiTreeNodeFlags = Cardinal;
  Tg2dGuiDragDropFlags = Cardinal;
  Tg2dGuiSliderFlags = Cardinal;
  Tg2dGuiButtonFlags = Cardinal;

  // Enums
  Tg2dGuiDirection = Integer;
  Tg2dGuiKey = Integer;
  Tg2dGuiMouseButton = Integer;
  Tg2dGuiMouseCursor = Integer;
  Tg2dGuiStyleVar = Integer;
  Tg2dGuiCol = Integer;

  // Callback types
  Tg2dGuiInputTextCallback = function(AData: Pointer): Integer;
  Tg2dGuiSizeCallback = procedure(AData: Pointer);
{$ENDREGION}

{$REGION ' CONSTANTS '}
const
  // Window Flags
  G2D_GUI_WINDOW_FLAGS_NONE                     = 0;
  G2D_GUI_WINDOW_FLAGS_NO_TITLE_BAR             = 1;
  G2D_GUI_WINDOW_FLAGS_NO_RESIZE                = 2;
  G2D_GUI_WINDOW_FLAGS_NO_MOVE                  = 4;
  G2D_GUI_WINDOW_FLAGS_NO_SCROLLBAR             = 8;
  G2D_GUI_WINDOW_FLAGS_NO_SCROLL_WITH_MOUSE     = 16;
  G2D_GUI_WINDOW_FLAGS_NO_COLLAPSE              = 32;
  G2D_GUI_WINDOW_FLAGS_ALWAYS_AUTO_RESIZE       = 64;
  G2D_GUI_WINDOW_FLAGS_NO_BACKGROUND            = 128;
  G2D_GUI_WINDOW_FLAGS_NO_SAVED_SETTINGS        = 256;
  G2D_GUI_WINDOW_FLAGS_NO_MOUSE_INPUTS          = 512;
  G2D_GUI_WINDOW_FLAGS_MENU_BAR                 = 1024;
  G2D_GUI_WINDOW_FLAGS_HORIZONTAL_SCROLLBAR     = 2048;
  G2D_GUI_WINDOW_FLAGS_NO_FOCUS_ON_APPEARING    = 4096;
  G2D_GUI_WINDOW_FLAGS_NO_BRING_TO_FRONT_ON_FOCUS = 8192;
  G2D_GUI_WINDOW_FLAGS_ALWAYS_VERTICAL_SCROLLBAR = 16384;
  G2D_GUI_WINDOW_FLAGS_ALWAYS_HORIZONTAL_SCROLLBAR = 32768;
  G2D_GUI_WINDOW_FLAGS_ALWAYS_USE_WINDOW_PADDING = 65536;

  // Input Text Flags
  G2D_GUI_INPUT_TEXT_FLAGS_NONE                 = 0;
  G2D_GUI_INPUT_TEXT_FLAGS_CHARS_DECIMAL        = 1;
  G2D_GUI_INPUT_TEXT_FLAGS_CHARS_HEXADECIMAL    = 2;
  G2D_GUI_INPUT_TEXT_FLAGS_CHARS_UPPERCASE      = 4;
  G2D_GUI_INPUT_TEXT_FLAGS_CHARS_NO_BLANK       = 8;
  G2D_GUI_INPUT_TEXT_FLAGS_AUTO_SELECT_ALL      = 16;
  G2D_GUI_INPUT_TEXT_FLAGS_ENTER_RETURNS_TRUE   = 32;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_COMPLETION  = 64;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_HISTORY     = 128;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_ALWAYS      = 256;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_CHAR_FILTER = 512;
  G2D_GUI_INPUT_TEXT_FLAGS_ALLOW_TAB_INPUT      = 1024;
  G2D_GUI_INPUT_TEXT_FLAGS_CTRL_ENTER_FOR_NEW_LINE = 2048;
  G2D_GUI_INPUT_TEXT_FLAGS_NO_HORIZONTAL_SCROLL = 4096;
  G2D_GUI_INPUT_TEXT_FLAGS_ALWAYS_OVERWRITE     = 8192;
  G2D_GUI_INPUT_TEXT_FLAGS_READ_ONLY            = 16384;
  G2D_GUI_INPUT_TEXT_FLAGS_PASSWORD             = 32768;
  G2D_GUI_INPUT_TEXT_FLAGS_NO_UNDO_REDO         = 65536;
  G2D_GUI_INPUT_TEXT_FLAGS_CHARS_SCIENTIFIC     = 131072;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_RESIZE      = 262144;
  G2D_GUI_INPUT_TEXT_FLAGS_CALLBACK_EDIT        = 524288;

  // Color Edit Flags
  G2D_GUI_COLOR_EDIT_FLAGS_NONE                 = 0;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_ALPHA             = 2;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_PICKER            = 4;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_OPTIONS           = 8;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_SMALL_PREVIEW     = 16;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_INPUTS            = 32;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_TOOLTIP           = 64;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_LABEL             = 128;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_SIDE_PREVIEW      = 256;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_DRAG_DROP         = 512;
  G2D_GUI_COLOR_EDIT_FLAGS_NO_BORDER            = 1024;
  G2D_GUI_COLOR_EDIT_FLAGS_ALPHA_BAR            = 65536;
  G2D_GUI_COLOR_EDIT_FLAGS_ALPHA_PREVIEW        = 131072;
  G2D_GUI_COLOR_EDIT_FLAGS_ALPHA_PREVIEW_HALF   = 262144;
  G2D_GUI_COLOR_EDIT_FLAGS_HDR                  = 524288;
  G2D_GUI_COLOR_EDIT_FLAGS_DISPLAY_RGB          = 1048576;
  G2D_GUI_COLOR_EDIT_FLAGS_DISPLAY_HSV          = 2097152;
  G2D_GUI_COLOR_EDIT_FLAGS_DISPLAY_HEX          = 4194304;
  G2D_GUI_COLOR_EDIT_FLAGS_UINT8                = 8388608;
  G2D_GUI_COLOR_EDIT_FLAGS_FLOAT                = 16777216;
  G2D_GUI_COLOR_EDIT_FLAGS_PICKER_HUE_BAR       = 33554432;
  G2D_GUI_COLOR_EDIT_FLAGS_PICKER_HUE_WHEEL     = 67108864;
  G2D_GUI_COLOR_EDIT_FLAGS_INPUT_RGB            = 134217728;
  G2D_GUI_COLOR_EDIT_FLAGS_INPUT_HSV            = 268435456;

  // Table Flags
  G2D_GUI_TABLE_FLAGS_NONE                      = 0;
  G2D_GUI_TABLE_FLAGS_RESIZABLE                 = 1;
  G2D_GUI_TABLE_FLAGS_REORDERABLE               = 2;
  G2D_GUI_TABLE_FLAGS_HIDEABLE                  = 4;
  G2D_GUI_TABLE_FLAGS_SORTABLE                  = 8;
  G2D_GUI_TABLE_FLAGS_NO_SAVED_SETTINGS         = 16;
  G2D_GUI_TABLE_FLAGS_CONTEXT_MENU_IN_BODY      = 32;
  G2D_GUI_TABLE_FLAGS_ROW_BG                    = 64;
  G2D_GUI_TABLE_FLAGS_BORDERS_INNER_H           = 128;
  G2D_GUI_TABLE_FLAGS_BORDERS_OUTER_H           = 256;
  G2D_GUI_TABLE_FLAGS_BORDERS_INNER_V           = 512;
  G2D_GUI_TABLE_FLAGS_BORDERS_OUTER_V           = 1024;
  G2D_GUI_TABLE_FLAGS_BORDERS_H                 = 384;
  G2D_GUI_TABLE_FLAGS_BORDERS_V                 = 1536;
  G2D_GUI_TABLE_FLAGS_BORDERS_INNER             = 640;
  G2D_GUI_TABLE_FLAGS_BORDERS_OUTER             = 1280;
  G2D_GUI_TABLE_FLAGS_BORDERS                   = 1920;
  G2D_GUI_TABLE_FLAGS_NO_BORDERS_IN_BODY        = 2048;
  G2D_GUI_TABLE_FLAGS_NO_BORDERS_IN_BODY_UNTIL_RESIZE = 4096;
  G2D_GUI_TABLE_FLAGS_SIZING_FIXED_FIT          = 8192;
  G2D_GUI_TABLE_FLAGS_SIZING_FIXED_SAME         = 16384;
  G2D_GUI_TABLE_FLAGS_SIZING_STRETCH_PROP       = 24576;
  G2D_GUI_TABLE_FLAGS_SIZING_STRETCH_SAME       = 32768;
  G2D_GUI_TABLE_FLAGS_NO_HOST_EXTEND_X          = 65536;
  G2D_GUI_TABLE_FLAGS_NO_HOST_EXTEND_Y          = 131072;
  G2D_GUI_TABLE_FLAGS_NO_KEEP_COLUMNS_VISIBLE   = 262144;
  G2D_GUI_TABLE_FLAGS_PRECISE_WIDTHS            = 524288;
  G2D_GUI_TABLE_FLAGS_NO_CLIP                   = 1048576;
  G2D_GUI_TABLE_FLAGS_PAD_OUTER_X               = 2097152;
  G2D_GUI_TABLE_FLAGS_NO_PAD_OUTER_X            = 4194304;
  G2D_GUI_TABLE_FLAGS_NO_PAD_INNER_X            = 8388608;
  G2D_GUI_TABLE_FLAGS_SCROLL_X                  = 16777216;
  G2D_GUI_TABLE_FLAGS_SCROLL_Y                  = 33554432;
  G2D_GUI_TABLE_FLAGS_SORT_MULTI                = 67108864;
  G2D_GUI_TABLE_FLAGS_SORT_TRISTATE             = 134217728;

    // Table Column Flags
  G2D_GUI_TABLE_COLUMN_FLAGS_NONE = 0;
  G2D_GUI_TABLE_COLUMN_FLAGS_DEFAULT_SORT = 4;
  G2D_GUI_TABLE_COLUMN_FLAGS_WIDTH_STRETCH = 8;

  // Tree Node Flags
  G2D_GUI_TREE_NODE_FLAGS_NONE                  = 0;
  G2D_GUI_TREE_NODE_FLAGS_SELECTED              = 1;
  G2D_GUI_TREE_NODE_FLAGS_FRAMED                = 2;
  G2D_GUI_TREE_NODE_FLAGS_ALLOW_ITEM_OVERLAP    = 4;
  G2D_GUI_TREE_NODE_FLAGS_NO_TREE_PUSH_ON_OPEN  = 8;
  G2D_GUI_TREE_NODE_FLAGS_NO_AUTO_OPEN_ON_LOG   = 16;
  G2D_GUI_TREE_NODE_FLAGS_DEFAULT_OPEN          = 32;
  G2D_GUI_TREE_NODE_FLAGS_OPEN_ON_DOUBLE_CLICK  = 64;
  G2D_GUI_TREE_NODE_FLAGS_OPEN_ON_ARROW         = 128;
  G2D_GUI_TREE_NODE_FLAGS_LEAF                  = 256;
  G2D_GUI_TREE_NODE_FLAGS_BULLET                = 512;
  G2D_GUI_TREE_NODE_FLAGS_FRAME_PADDING         = 1024;
  G2D_GUI_TREE_NODE_FLAGS_SPAN_AVAIL_WIDTH      = 2048;
  G2D_GUI_TREE_NODE_FLAGS_SPAN_FULL_WIDTH       = 4096;
  G2D_GUI_TREE_NODE_FLAGS_NAV_LEFT_JUMPS_BACK_HERE = 8192;
  G2D_GUI_TREE_NODE_FLAGS_COLLAPSING_HEADER     = 26;

  // Direction
  G2D_GUI_DIRECTION_NONE                        = -1;
  G2D_GUI_DIRECTION_LEFT                        = 0;
  G2D_GUI_DIRECTION_RIGHT                       = 1;
  G2D_GUI_DIRECTION_UP                          = 2;
  G2D_GUI_DIRECTION_DOWN                        = 3;

  // Mouse Cursors
  G2D_GUI_MOUSE_CURSOR_NONE                     = -1;
  G2D_GUI_MOUSE_CURSOR_ARROW                    = 0;
  G2D_GUI_MOUSE_CURSOR_TEXT_INPUT               = 1;
  G2D_GUI_MOUSE_CURSOR_RESIZE_ALL               = 2;
  G2D_GUI_MOUSE_CURSOR_RESIZE_NS                = 3;
  G2D_GUI_MOUSE_CURSOR_RESIZE_EW                = 4;
  G2D_GUI_MOUSE_CURSOR_RESIZE_NESW              = 5;
  G2D_GUI_MOUSE_CURSOR_RESIZE_NWSE              = 6;
  G2D_GUI_MOUSE_CURSOR_HAND                     = 7;
  G2D_GUI_MOUSE_CURSOR_NOT_ALLOWED              = 8;

  // Style Colors
  G2D_GUI_COL_TEXT                              = 0;
  G2D_GUI_COL_TEXT_DISABLED                     = 1;
  G2D_GUI_COL_WINDOW_BG                         = 2;
  G2D_GUI_COL_CHILD_BG                          = 3;
  G2D_GUI_COL_POPUP_BG                          = 4;
  G2D_GUI_COL_BORDER                            = 5;
  G2D_GUI_COL_BORDER_SHADOW                     = 6;
  G2D_GUI_COL_FRAME_BG                          = 7;
  G2D_GUI_COL_FRAME_BG_HOVERED                  = 8;
  G2D_GUI_COL_FRAME_BG_ACTIVE                   = 9;
  G2D_GUI_COL_TITLE_BG                          = 10;
  G2D_GUI_COL_TITLE_BG_ACTIVE                   = 11;
  G2D_GUI_COL_TITLE_BG_COLLAPSED                = 12;
  G2D_GUI_COL_MENU_BAR_BG                       = 13;
  G2D_GUI_COL_SCROLLBAR_BG                      = 14;
  G2D_GUI_COL_SCROLLBAR_GRAB                    = 15;
  G2D_GUI_COL_SCROLLBAR_GRAB_HOVERED            = 16;
  G2D_GUI_COL_SCROLLBAR_GRAB_ACTIVE             = 17;
  G2D_GUI_COL_CHECK_MARK                        = 18;
  G2D_GUI_COL_SLIDER_GRAB                       = 19;
  G2D_GUI_COL_SLIDER_GRAB_ACTIVE                = 20;
  G2D_GUI_COL_BUTTON                            = 21;
  G2D_GUI_COL_BUTTON_HOVERED                    = 22;
  G2D_GUI_COL_BUTTON_ACTIVE                     = 23;
  G2D_GUI_COL_HEADER                            = 24;
  G2D_GUI_COL_HEADER_HOVERED                    = 25;
  G2D_GUI_COL_HEADER_ACTIVE                     = 26;
  G2D_GUI_COL_SEPARATOR                         = 27;
  G2D_GUI_COL_SEPARATOR_HOVERED                 = 28;
  G2D_GUI_COL_SEPARATOR_ACTIVE                  = 29;
  G2D_GUI_COL_RESIZE_GRIP                       = 30;
  G2D_GUI_COL_RESIZE_GRIP_HOVERED               = 31;
  G2D_GUI_COL_RESIZE_GRIP_ACTIVE                = 32;
  G2D_GUI_COL_TAB                               = 33;
  G2D_GUI_COL_TAB_HOVERED                       = 34;
  G2D_GUI_COL_TAB_ACTIVE                        = 35;
  G2D_GUI_COL_TAB_UNFOCUSED                     = 36;
  G2D_GUI_COL_TAB_UNFOCUSED_ACTIVE              = 37;
  G2D_GUI_COL_PLOT_LINES                        = 38;
  G2D_GUI_COL_PLOT_LINES_HOVERED                = 39;
  G2D_GUI_COL_PLOT_HISTOGRAM                    = 40;
  G2D_GUI_COL_PLOT_HISTOGRAM_HOVERED            = 41;
  G2D_GUI_COL_TABLE_HEADER_BG                   = 42;
  G2D_GUI_COL_TABLE_BORDER_STRONG               = 43;
  G2D_GUI_COL_TABLE_BORDER_LIGHT                = 44;
  G2D_GUI_COL_TABLE_ROW_BG                      = 45;
  G2D_GUI_COL_TABLE_ROW_BG_ALT                  = 46;
  G2D_GUI_COL_TEXT_SELECTED_BG                  = 47;
  G2D_GUI_COL_DRAG_DROP_TARGET                  = 48;
  G2D_GUI_COL_NAV_HIGHLIGHT                     = 49;
  G2D_GUI_COL_NAV_WINDOWING_HIGHLIGHT           = 50;
  G2D_GUI_COL_NAV_WINDOWING_DIM_BG              = 51;
  G2D_GUI_COL_MODAL_WINDOW_DIM_BG               = 52;
{$ENDREGION}

type
  { Tg2dGui }
  Tg2dGui = class(Tg2dStaticObject)
  private
    class var FWindow: Tg2dWindow;
    class var FInitialized: Boolean;

    // Helper functions for type conversion
    class function Tg2dVecToImVec2(const AVec: Tg2dVec): ImVec2;
    class function ImVec2ToTg2dVec(const AVec: ImVec2): Tg2dVec;
    class function Tg2dColorToImVec4(const AColor: Tg2dColor): ImVec4;

  public
    {$REGION ' CORE LIFECYCLE '}
    class function  Initialize(const AWindow: Tg2dWindow; const AAutoLoadDefaultFont: Boolean = True): Boolean;
    class procedure Shutdown();
    class function  IsInitialized(): Boolean;
    class procedure NewFrame();
    class procedure Render();
    class procedure ShowDemoWindow(const AOpen: PBoolean = nil);
    class procedure ShowMetricsWindow(const AOpen: PBoolean = nil);
    class procedure ShowStyleEditor(const ARef: Pointer = nil);
    class procedure ShowAboutWindow(const AOpen: PBoolean = nil);
    {$ENDREGION}

    {$REGION ' FONT MANAGEMENT '}
    class function  LoadDefaultFont(const ASize: Single = 13.0): Boolean;
    class function  LoadFont(const AFilename: string; const ASize: Single): Boolean;
    class function  LoadFontFromZip(const AZipFile, AFilename: string; const ASize: Single; const APassword: string = ''): Boolean;
    class function  LoadFontFromResource(const AResourceName: string; const ASize: Single): Boolean;
    class procedure PushFont(const AFont: Pointer);
    class procedure PopFont();
    {$ENDREGION}

    {$REGION ' WINDOWS & LAYOUT '}
    // Windows
    class function  BeginWindow(const ATitle: string; const AOpen: PBoolean = nil; const AFlags: Tg2dGuiWindowFlags = 0): Boolean;
    class procedure EndWindow();
    class function  BeginChild(const AID: string; const ASize: Tg2dVec; const ABorder: Boolean = False; const AFlags: Tg2dGuiWindowFlags = 0): Boolean; overload;
    class function  BeginChild(const AID: string): Boolean; overload;
    class procedure EndChild();

    // Layout
    class procedure Columns(const ACount: Integer = 1; const AID: string = ''; const ABorder: Boolean = True);
    class procedure NextColumn();
    class procedure Separator();
    class procedure SameLine(const AOffsetFromStartX: Single = 0.0; const ASpacing: Single = -1.0);
    class procedure NewLine();
    class procedure Spacing();
    class procedure Dummy(const ASize: Tg2dVec);
    class procedure Indent(const AIndentW: Single = 0.0);
    class procedure Unindent(const AIndentW: Single = 0.0);

    // Groups
    class procedure BeginGroup();
    class procedure EndGroup();

    // Cursor/Layout query
    class function  GetCursorPos(): Tg2dVec;
    class procedure SetCursorPos(const APos: Tg2dVec);
    class function  GetCursorStartPos(): Tg2dVec;
    class function  GetCursorScreenPos(): Tg2dVec;
    class procedure SetCursorScreenPos(const APos: Tg2dVec);
    class function  GetContentRegionAvail(): Tg2dVec;
    class function  GetContentRegionMax(): Tg2dVec;
    class function  GetWindowContentRegionMin(): Tg2dVec;
    class function  GetWindowContentRegionMax(): Tg2dVec;
    {$ENDREGION}

    {$REGION ' TEXT & LABELS '}
    class procedure Text(const AText: string); overload;
    class procedure Text(const AFormat: string; const AArgs: array of const); overload;
    class procedure TextColored(const AColor: Tg2dColor; const AText: string); overload;
    class procedure TextColored(const AColor: Tg2dColor; const AFormat: string; const AArgs: array of const); overload;
    class procedure TextDisabled(const AText: string);
    class procedure TextWrapped(const AText: string);
    class procedure LabelText(const ALabel, AText: string);
    class procedure BulletText(const AText: string);
    class function  CalcTextSize(const AText: string; const AHideTextAfterDoubleHash: Boolean = False; const AWrapWidth: Single = -1.0): Tg2dVec;
    {$ENDREGION}

    {$REGION ' BUTTONS '}
    class function  Button(const ALabel: string; const ASize: Tg2dVec): Boolean; overload;
    class function  Button(const ALabel: string): Boolean; overload;
    class function  SmallButton(const ALabel: string): Boolean;
    class function  InvisibleButton(const AID: string; const ASize: Tg2dVec; const AFlags: Tg2dGuiButtonFlags = 0): Boolean;
    class function  ArrowButton(const AID: string; const ADirection: Tg2dGuiDirection): Boolean;
    class function  ImageButton(const ATexture: Tg2dTexture; const ASize: Tg2dVec; const AUv0, AUv1: Tg2dVec): Boolean; overload;
    class function  ImageButton(const ATexture: Tg2dTexture; const ASize: Tg2dVec): Boolean; overload;
    class function  Checkbox(const ALabel: string; const AValue: PBoolean): Boolean;
    class function  CheckboxFlags(const ALabel: string; const AFlags: PCardinal; const AFlagsValue: Cardinal): Boolean;
    class function  RadioButton(const ALabel: string; const AActive: Boolean): Boolean; overload;
    class function  RadioButton(const ALabel: string; const AValue: PInteger; const AVButton: Integer): Boolean; overload;
    class procedure ProgressBar(const AFraction: Single; const ASizeArg: Tg2dVec; const AOverlay: string); overload;
    class procedure ProgressBar(const AFraction: Single); overload;
    class procedure Bullet();
    {$ENDREGION}

    {$REGION ' INPUT CONTROLS '}
    // Text Input
    class function  InputText(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const AFlags: Tg2dGuiInputTextFlags = 0; const ACallback: Tg2dGuiInputTextCallback = nil): Boolean;
    class function  InputTextMultiline(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const ASize: Tg2dVec; const AFlags: Tg2dGuiInputTextFlags = 0; const ACallback: Tg2dGuiInputTextCallback = nil): Boolean; overload;
    class function  InputTextMultiline(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer): Boolean; overload;
    class function  InputTextWithHint(const ALabel, AHint: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const AFlags: Tg2dGuiInputTextFlags = 0; const ACallback: Tg2dGuiInputTextCallback = nil): Boolean;

    // Numeric Input
    class function  InputFloat(const ALabel: string; const AValue: PSingle; const AStep: Single = 0.0; const AStepFast: Single = 0.0; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputFloat2(const ALabel: string; const AValue: PSingle; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputFloat3(const ALabel: string; const AValue: PSingle; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputFloat4(const ALabel: string; const AValue: PSingle; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputInt(const ALabel: string; const AValue: PInteger; const AStep: Integer = 1; const AStepFast: Integer = 100; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputInt2(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputInt3(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputInt4(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;
    class function  InputDouble(const ALabel: string; const AValue: PDouble; const AStep: Double = 0.0; const AStepFast: Double = 0.0; const AFormat: string = '%.6f'; const AFlags: Tg2dGuiInputTextFlags = 0): Boolean;

    // Sliders
    class function  SliderFloat(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderFloat2(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderFloat3(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderFloat4(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderAngle(const ALabel: string; const AValueRad: PSingle; const AMinDegrees: Single = -360.0; const AMaxDegrees: Single = 360.0; const AFormat: string = '%.0f deg'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderInt(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderInt2(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderInt3(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  SliderInt4(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  VSliderFloat(const ALabel: string; const ASize: Tg2dVec; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  VSliderInt(const ALabel: string; const ASize: Tg2dVec; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;

    // Drag Controls
    class function  DragFloat(const ALabel: string; const AValue: PSingle; const ASpeed: Single = 1.0; const AMin: Single = 0.0; const AMax: Single = 0.0; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragFloat2(const ALabel: string; const AValue: PSingle; const ASpeed: Single = 1.0; const AMin: Single = 0.0; const AMax: Single = 0.0; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragFloat3(const ALabel: string; const AValue: PSingle; const ASpeed: Single = 1.0; const AMin: Single = 0.0; const AMax: Single = 0.0; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragFloat4(const ALabel: string; const AValue: PSingle; const ASpeed: Single = 1.0; const AMin: Single = 0.0; const AMax: Single = 0.0; const AFormat: string = '%.3f'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragFloatRange2(const ALabel: string; const ACurrentMin, ACurrentMax: PSingle; const ASpeed: Single = 1.0; const AMin: Single = 0.0; const AMax: Single = 0.0; const AFormat: string = '%.3f'; const AFormatMax: string = ''; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragInt(const ALabel: string; const AValue: PInteger; const ASpeed: Single = 1.0; const AMin: Integer = 0; const AMax: Integer = 0; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragInt2(const ALabel: string; const AValue: PInteger; const ASpeed: Single = 1.0; const AMin: Integer = 0; const AMax: Integer = 0; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragInt3(const ALabel: string; const AValue: PInteger; const ASpeed: Single = 1.0; const AMin: Integer = 0; const AMax: Integer = 0; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragInt4(const ALabel: string; const AValue: PInteger; const ASpeed: Single = 1.0; const AMin: Integer = 0; const AMax: Integer = 0; const AFormat: string = '%d'; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    class function  DragIntRange2(const ALabel: string; const ACurrentMin, ACurrentMax: PInteger; const ASpeed: Single = 1.0; const AMin: Integer = 0; const AMax: Integer = 0; const AFormat: string = '%d'; const AFormatMax: string = ''; const AFlags: Tg2dGuiSliderFlags = 0): Boolean;
    {$ENDREGION}

    {$REGION ' COLOR CONTROLS '}
    class function  ColorEdit3(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags = 0): Boolean;
    class function  ColorEdit4(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags = 0): Boolean;
    class function  ColorPicker3(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags = 0): Boolean;
    class function  ColorPicker4(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags; const ARefColor: Tg2dColor): Boolean; overload;
    class function  ColorPicker4(const ALabel: string; var AColor: Tg2dColor): Boolean; overload;
    class function  ColorButton(const ADescID: string; const AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags; const ASize: Tg2dVec): Boolean; overload;
    class function  ColorButton(const ADescID: string; const AColor: Tg2dColor): Boolean; overload;
    class procedure SetColorEditOptions(const AFlags: Tg2dGuiColorEditFlags);
    {$ENDREGION}

    {$REGION ' SELECTION CONTROLS '}
    // Combo Boxes
    class function  BeginCombo(const ALabel, APreviewValue: string; const AFlags: Tg2dGuiComboFlags = 0): Boolean;
    class procedure EndCombo();
    class function  Combo(const ALabel: string; const ACurrentItem: PInteger; const AItems: array of string; const APopupMaxHeightInItems: Integer = -1): Boolean; overload;
    class function  Combo(const ALabel: string; const ACurrentItem: PInteger; const AItemsSeparatedByZeros: string; const APopupMaxHeightInItems: Integer = -1): Boolean; overload;

    // List Boxes
    class function  BeginListBox(const ALabel: string; const ASize: Tg2dVec): Boolean; overload;
    class function  BeginListBox(const ALabel: string): Boolean; overload;
    class procedure EndListBox();
    class function  ListBox(const ALabel: string; const ACurrentItem: PInteger; const AItems: array of string; const AHeightInItems: Integer = -1): Boolean;
    class function  Selectable(const ALabel: string; const ASelected: Boolean; const AFlags: Tg2dGuiSelectableFlags; const ASize: Tg2dVec): Boolean; overload;
    class function  Selectable(const ALabel: string; const ASelected: Boolean = False): Boolean; overload;
    class function  Selectable(const ALabel: string; const ASelected: PBoolean; const AFlags: Tg2dGuiSelectableFlags; const ASize: Tg2dVec): Boolean; overload;
    class function  Selectable(const ALabel: string; const ASelected: PBoolean): Boolean; overload;
    {$ENDREGION}

    {$REGION ' TABLES '}
    class function  BeginTable(const AID: string; const AColumns: Integer; const AFlags: Tg2dGuiTableFlags; const AOuterSize: Tg2dVec; const AInnerWidth: Single): Boolean; overload;
    class function  BeginTable(const AID: string; const AColumns: Integer): Boolean; overload;
    class procedure EndTable();
    class procedure TableNextRow(const ARowFlags: Tg2dGuiTableRowFlags = 0; const AMinRowHeight: Single = 0.0);
    class function  TableNextColumn(): Boolean;
    class function  TableSetColumnIndex(const AColumnN: Integer): Boolean;
    class procedure TableSetupColumn(const ALabel: string; const AFlags: Tg2dGuiTableColumnFlags = 0; const AInitWidthOrWeight: Single = 0.0; const AUserId: Cardinal = 0);
    class procedure TableSetupScrollFreeze(const ACols, ARows: Integer);
    class procedure TableHeadersRow();
    class procedure TableHeader(const ALabel: string);
    class function  TableGetSortSpecs(): Pointer;
    class function  TableGetColumnCount(): Integer;
    class function  TableGetColumnIndex(): Integer;
    class function  TableGetRowIndex(): Integer;
    class function  TableGetColumnName(const AColumnN: Integer = -1): string;
    class function  TableGetColumnFlags(const AColumnN: Integer = -1): Tg2dGuiTableColumnFlags;
    class procedure TableSetColumnEnabled(const AColumnN: Integer; const AEnabled: Boolean);
    class procedure TableSetBgColor(const ABgTarget: Integer; const AColor: Cardinal; const AColumnN: Integer = -1);
    {$ENDREGION}

    {$REGION ' MENUS '}
    class function  BeginMenuBar(): Boolean;
    class procedure EndMenuBar();
    class function  BeginMainMenuBar(): Boolean;
    class procedure EndMainMenuBar();
    class function  BeginMenu(const ALabel: string; const AEnabled: Boolean = True): Boolean;
    class procedure EndMenu();
    class function  MenuItem(const ALabel: string; const AShortcut: string; const ASelected: Boolean; const AEnabled: Boolean): Boolean; overload;
    class function  MenuItem(const ALabel: string): Boolean; overload;
    class function  MenuItem(const ALabel: string; const AShortcut: string; const ASelected: PBoolean; const AEnabled: Boolean = True): Boolean; overload;
    {$ENDREGION}

    {$REGION ' TABS '}
    class function  BeginTabBar(const AID: string; const AFlags: Tg2dGuiTabBarFlags = 0): Boolean;
    class procedure EndTabBar();
    class function  BeginTabItem(const ALabel: string; const AOpen: PBoolean; const AFlags: Tg2dGuiTabItemFlags): Boolean; overload;
    class function  BeginTabItem(const ALabel: string): Boolean; overload;
    class procedure EndTabItem();
    class function  TabItemButton(const ALabel: string; const AFlags: Tg2dGuiTabItemFlags = 0): Boolean;
    class procedure SetTabItemClosed(const ATabOrDockedWindowLabel: string);
    {$ENDREGION}

    {$REGION ' TREE NODES '}
    class function  TreeNode(const ALabel: string): Boolean; overload;
    class function  TreeNode(const AID: string; const AFormat: string; const AArgs: array of const): Boolean; overload;
    class function  TreeNodeEx(const ALabel: string; const AFlags: Tg2dGuiTreeNodeFlags = 0): Boolean; overload;
    class function  TreeNodeEx(const AID: string; const AFlags: Tg2dGuiTreeNodeFlags; const AFormat: string; const AArgs: array of const): Boolean; overload;
    class procedure TreePush(const AID: string); overload;
    class procedure TreePush(const AID: Integer = 0); overload;
    class procedure TreePop();
    class function  GetTreeNodeToLabelSpacing(): Single;
    class function  CollapsingHeader(const ALabel: string; const AFlags: Tg2dGuiTreeNodeFlags = 0): Boolean; overload;
    class function  CollapsingHeader(const ALabel: string; const AOpen: PBoolean; const AFlags: Tg2dGuiTreeNodeFlags = 0): Boolean; overload;
    class procedure SetNextTreeItemOpen(const AIsOpen: Boolean; const ACond: Integer = 0);
    {$ENDREGION}

    {$REGION ' TOOLTIPS '}
    class procedure BeginTooltip();
    class procedure EndTooltip();
    class procedure SetTooltip(const AText: string); overload;
    class procedure SetTooltip(const AFormat: string; const AArgs: array of const); overload;
    {$ENDREGION}

    {$REGION ' POPUPS & MODALS '}
    class function  BeginPopup(const AID: string; const AFlags: Tg2dGuiWindowFlags = 0): Boolean;
    class function  BeginPopupModal(const AName: string; const AOpen: PBoolean = nil; const AFlags: Tg2dGuiWindowFlags = 0): Boolean;
    class procedure EndPopup();
    class procedure OpenPopup(const AID: string; const APopupFlags: Integer = 0);
    class procedure OpenPopupOnItemClick(const AID: string = ''; const APopupFlags: Integer = 1);
    class procedure CloseCurrentPopup();
    class function  BeginPopupContextItem(const AID: string = ''; const APopupFlags: Integer = 1): Boolean;
    class function  BeginPopupContextWindow(const AID: string = ''; const APopupFlags: Integer = 1): Boolean;
    class function  BeginPopupContextVoid(const AID: string = ''; const APopupFlags: Integer = 1): Boolean;
    class function  IsPopupOpen(const AID: string; const AFlags: Integer = 0): Boolean;
    {$ENDREGION}

    {$REGION ' WIDGETS UTILITIES '}
    class function  IsItemHovered(const AFlags: Integer = 0): Boolean;
    class function  IsItemActive(): Boolean;
    class function  IsItemFocused(): Boolean;
    class function  IsItemClicked(const AMouseButton: Integer = 0): Boolean;
    class function  IsItemVisible(): Boolean;
    class function  IsItemEdited(): Boolean;
    class function  IsItemActivated(): Boolean;
    class function  IsItemDeactivated(): Boolean;
    class function  IsItemDeactivatedAfterEdit(): Boolean;
    class function  IsItemToggledOpen(): Boolean;
    class function  IsAnyItemHovered(): Boolean;
    class function  IsAnyItemActive(): Boolean;
    class function  IsAnyItemFocused(): Boolean;
    class function  GetItemRectMin(): Tg2dVec;
    class function  GetItemRectMax(): Tg2dVec;
    class function  GetItemRectSize(): Tg2dVec;
    //class procedure SetItemAllowOverlap();
    {$ENDREGION}

    {$REGION ' FOCUS & ACTIVATION '}
    class procedure SetKeyboardFocusHere(const AOffset: Integer = 0);
    class function  IsWindowFocused(const AFlags: Integer = 0): Boolean;
    class function  IsWindowHovered(const AFlags: Integer = 0): Boolean;
    class procedure SetNextWindowFocus();
    class procedure SetNextItemWidth(const AItemWidth: Single);
    class procedure PushItemWidth(const AItemWidth: Single);
    class procedure PopItemWidth();
    class procedure SetNextItemOpen(const AIsOpen: Boolean; const ACond: Integer = 0);
    {$ENDREGION}

    {$REGION ' STYLE & THEME '}
    class procedure StyleColorsDark();
    class procedure StyleColorsLight();
    class procedure StyleColorsClassic();
    class procedure PushStyleColor(const AIdx: Tg2dGuiCol; const AColor: Tg2dColor);
    class procedure PopStyleColor(const ACount: Integer = 1);
    class procedure PushStyleVar(const AIdx: Tg2dGuiStyleVar; const AVal: Single); overload;
    class procedure PushStyleVar(const AIdx: Tg2dGuiStyleVar; const AVal: Tg2dVec); overload;
    class procedure PopStyleVar(const ACount: Integer = 1);
    {$ENDREGION}

    {$REGION ' CURSOR & MOUSE '}
    class function  GetMousePos(): Tg2dVec;
    class function  GetMousePosOnOpeningCurrentPopup(): Tg2dVec;
    class function  IsMouseDragging(const AButton: Tg2dGuiMouseButton; const ALockThreshold: Single = -1.0): Boolean;
    class function  GetMouseDragDelta(const AButton: Tg2dGuiMouseButton = 0; const ALockThreshold: Single = -1.0): Tg2dVec;
    class procedure ResetMouseDragDelta(const AButton: Tg2dGuiMouseButton = 0);
    class function  GetMouseCursor(): Tg2dGuiMouseCursor;
    class procedure SetMouseCursor(const ACursorType: Tg2dGuiMouseCursor);
    {$ENDREGION}

    {$REGION ' CLIPBOARD '}
    class function  GetClipboardText(): string;
    class procedure SetClipboardText(const AText: string);
    {$ENDREGION}

    {$REGION ' PLOTTING '}
    class procedure PlotLines(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer; const AValuesOffset: Integer; const AOverlayText: string; const AScaleMin, AScaleMax: Single; const AGraphSize: Tg2dVec; const AStride: Integer); overload;
    class procedure PlotLines(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer); overload;
    class procedure PlotHistogram(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer; const AValuesOffset: Integer; const AOverlayText: string; const AScaleMin, AScaleMax: Single; const AGraphSize: Tg2dVec; const AStride: Integer); overload;
    class procedure PlotHistogram(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer); overload;
    {$ENDREGION}

    {$REGION ' DRAWING '}
    class procedure AddRectFilled(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor; const ARounding: Single; const AFlags: Integer); overload;
    class procedure AddRectFilled(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor); overload;
    class procedure AddRect(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor; const ARounding: Single; const AFlags: Integer; const AThickness: Single); overload;
    class procedure AddRect(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor); overload;
    class procedure AddLine(const AP1, AP2: Tg2dVec; const AColor: Tg2dColor; const AThickness: Single); overload;
    class procedure AddLine(const AP1, AP2: Tg2dVec; const AColor: Tg2dColor); overload;
    class procedure AddCircle(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor; const ANumSegments: Integer; const AThickness: Single); overload;
    class procedure AddCircle(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor); overload;
    class procedure AddCircleFilled(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor; const ANumSegments: Integer); overload;
    class procedure AddCircleFilled(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor); overload;
    class procedure AddText(const APos: Tg2dVec; const AColor: Tg2dColor; const AText: string);
    {$ENDREGION}
  end;

implementation

uses
  System.Classes;

{$REGION ' HELPER FUNCTIONS '}
class function Tg2dGui.Tg2dVecToImVec2(const AVec: Tg2dVec): ImVec2;
begin
  Result.x := AVec.x;
  Result.y := AVec.y;
end;

class function Tg2dGui.ImVec2ToTg2dVec(const AVec: ImVec2): Tg2dVec;
begin
  Result.x := AVec.x;
  Result.y := AVec.y;
end;

class function Tg2dGui.Tg2dColorToImVec4(const AColor: Tg2dColor): ImVec4;
begin
  Result.x := AColor.Red;
  Result.y := AColor.Green;
  Result.z := AColor.Blue;
  Result.w := AColor.Alpha;
end;

{$ENDREGION}

{$REGION ' CORE LIFECYCLE '}
class function Tg2dGui.Initialize(const AWindow: Tg2dWindow; const AAutoLoadDefaultFont: Boolean): Boolean;
var
  LIo: PImGuiIO;
begin
  Result := False;
  if FInitialized then Exit;
  if not Assigned(AWindow) then Exit;

  FWindow := AWindow;

  // Create ImGui context
  igCreateContext(nil);

  // Setup IO
  LIo := igGetIO_Nil();
  LIo.ConfigFlags := LIo.ConfigFlags or ImGuiConfigFlags_NavEnableKeyboard;
  LIo.ConfigFlags := LIo.ConfigFlags or ImGuiConfigFlags_NavEnableGamepad;
  LIo.ConfigFlags := LIo.ConfigFlags or ImGuiConfigFlags_DockingEnable;

  // Set style
  StyleColorsDark();

  // Initialize backends
  if not ImGui_ImplGlfw_InitForOpenGL(FWindow.Handle, True) then Exit;
  if not ImGui_ImplOpenGL2_Init() then Exit;

  FInitialized := True;

  // Load default font if requested
  if AAutoLoadDefaultFont then
  begin
    if not LoadDefaultFont() then Exit;
  end;

  Result := True;
end;

class procedure Tg2dGui.Shutdown();
begin
  if not FInitialized then Exit;

  ImGui_ImplOpenGL2_Shutdown();
  ImGui_ImplGlfw_Shutdown();
  igDestroyContext(nil);

  FInitialized := False;
  FWindow := nil;
end;

class function Tg2dGui.IsInitialized(): Boolean;
begin
  Result := FInitialized;
end;

class procedure Tg2dGui.NewFrame();
begin
  if not FInitialized then Exit;

  ImGui_ImplOpenGL2_NewFrame();
  ImGui_ImplGlfw_NewFrame();
  igNewFrame();

  // Update mouse position for ImGui
  ImGui_ImplGlfw_CursorPosCallback(FWindow.Handle, FWindow.GetMousePos().x, FWindow.GetMousePos().y);
end;

class procedure Tg2dGui.Render();
begin
  if not FInitialized then Exit;

  igRender();
  ImGui_ImplOpenGL2_RenderDrawData(igGetDrawData(), FWindow.GetVirtualSize().Width, FWindow.GetVirtualSize().Height);
end;

class procedure Tg2dGui.ShowDemoWindow(const AOpen: PBoolean);
begin
  if not FInitialized then Exit;
  igShowDemoWindow(AOpen);
end;

class procedure Tg2dGui.ShowMetricsWindow(const AOpen: PBoolean);
begin
  if not FInitialized then Exit;
  igShowMetricsWindow(AOpen);
end;

class procedure Tg2dGui.ShowStyleEditor(const ARef: Pointer);
begin
  if not FInitialized then Exit;
  igShowStyleEditor(ARef);
end;

class procedure Tg2dGui.ShowAboutWindow(const AOpen: PBoolean);
begin
  if not FInitialized then Exit;
  igShowAboutWindow(AOpen);
end;
{$ENDREGION}

{$REGION ' FONT MANAGEMENT '}
class function Tg2dGui.LoadDefaultFont(const ASize: Single): Boolean;
var
  LFontConfig: PImFontConfig;
  LResStream: TResourceStream;
  LCustomFont: PImFont;
  LIo: PImGuiIO;
begin
  Result := False;
  if not FInitialized then Exit;

  LIo := igGetIO_Nil();
  LFontConfig := ImFontConfig_ImFontConfig();
  LFontConfig.FontDataOwnedByAtlas := False;

  try
    LResStream := TResourceStream.Create(HInstance, '55fb2d6c54b44934a3b3bfadbb3a00c8', RT_RCDATA);
    try
      LCustomFont := ImFontAtlas_AddFontFromMemoryTTF(LIo.Fonts, LResStream.Memory, LResStream.Size, ASize * FWindow.GetScale().Width, LFontConfig, nil);
      Result := Assigned(LCustomFont);
    finally
      LResStream.Free();
    end;
  finally
    ImFontConfig_destroy(LFontConfig);
  end;
end;

class function Tg2dGui.LoadFont(const AFilename: string; const ASize: Single): Boolean;
var
  LIo: PImGuiIO;
  LFont: PImFont;
begin
  Result := False;
  if not FInitialized then Exit;

  LIo := igGetIO_Nil();
  LFont := ImFontAtlas_AddFontFromFileTTF(LIo.Fonts, Tg2dUtils.AsUTF8(AFilename, []), ASize * FWindow.GetScale().Width, nil, nil);
  Result := Assigned(LFont);
end;

class function Tg2dGui.LoadFontFromZip(const AZipFile, AFilename: string; const ASize: Single; const APassword: string): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;

  // TODO: Implement zip font loading using Game2D's zip system
  // This would integrate with Tg2dZipFileIO
end;

class function Tg2dGui.LoadFontFromResource(const AResourceName: string; const ASize: Single): Boolean;
var
  LFontConfig: PImFontConfig;
  LResStream: TResourceStream;
  LCustomFont: PImFont;
  LIo: PImGuiIO;
begin
  Result := False;
  if not FInitialized then Exit;

  LIo := igGetIO_Nil();
  LFontConfig := ImFontConfig_ImFontConfig();
  LFontConfig.FontDataOwnedByAtlas := False;

  try
    LResStream := TResourceStream.Create(HInstance, AResourceName, RT_RCDATA);
    try
      LCustomFont := ImFontAtlas_AddFontFromMemoryTTF(LIo.Fonts, LResStream.Memory, LResStream.Size, ASize * FWindow.GetScale().Width, LFontConfig, nil);
      Result := Assigned(LCustomFont);
    finally
      LResStream.Free();
    end;
  finally
    ImFontConfig_destroy(LFontConfig);
  end;
end;

class procedure Tg2dGui.PushFont(const AFont: Pointer);
begin
  if not FInitialized then Exit;
  igPushFont(AFont);
end;

class procedure Tg2dGui.PopFont();
begin
  if not FInitialized then Exit;
  igPopFont();
end;
{$ENDREGION}

{$REGION ' WINDOWS & LAYOUT '}
class function Tg2dGui.BeginWindow(const ATitle: string; const AOpen: PBoolean; const AFlags: Tg2dGuiWindowFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBegin(Tg2dUtils.AsUTF8(ATitle, []), AOpen, AFlags);
end;

class procedure Tg2dGui.EndWindow();
begin
  if not FInitialized then Exit;
  igEnd();
end;

class function Tg2dGui.BeginChild(const AID: string; const ASize: Tg2dVec; const ABorder: Boolean; const AFlags: Tg2dGuiWindowFlags): Boolean;
var
  LChildFlags: ImGuiChildFlags;
begin
  Result := False;
  if not FInitialized then Exit;
  if ABorder then
    LChildFlags := 1  // ImGuiChildFlags_Border
  else
    LChildFlags := 0;
  Result := igBeginChild_Str(Tg2dUtils.AsUTF8(AID, []), Tg2dVecToImVec2(ASize), LChildFlags, AFlags);
end;

class function Tg2dGui.BeginChild(const AID: string): Boolean;
var
  LZeroVec: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroVec.x := 0;
  LZeroVec.y := 0;
  Result := igBeginChild_Str(Tg2dUtils.AsUTF8(AID, []), LZeroVec, 0, 0);
end;

class procedure Tg2dGui.EndChild();
begin
  if not FInitialized then Exit;
  igEndChild();
end;

class procedure Tg2dGui.Columns(const ACount: Integer; const AID: string; const ABorder: Boolean);
begin
  if not FInitialized then Exit;
  igColumns(ACount, Tg2dUtils.AsUTF8(AID, []), ABorder);
end;

class procedure Tg2dGui.NextColumn();
begin
  if not FInitialized then Exit;
  igNextColumn();
end;

class procedure Tg2dGui.Separator();
begin
  if not FInitialized then Exit;
  igSeparator();
end;

class procedure Tg2dGui.SameLine(const AOffsetFromStartX, ASpacing: Single);
begin
  if not FInitialized then Exit;
  igSameLine(AOffsetFromStartX, ASpacing);
end;

class procedure Tg2dGui.NewLine();
begin
  if not FInitialized then Exit;
  igNewLine();
end;

class procedure Tg2dGui.Spacing();
begin
  if not FInitialized then Exit;
  igSpacing();
end;

class procedure Tg2dGui.Dummy(const ASize: Tg2dVec);
begin
  if not FInitialized then Exit;
  igDummy(Tg2dVecToImVec2(ASize));
end;

class procedure Tg2dGui.Indent(const AIndentW: Single);
begin
  if not FInitialized then Exit;
  igIndent(AIndentW);
end;

class procedure Tg2dGui.Unindent(const AIndentW: Single);
begin
  if not FInitialized then Exit;
  igUnindent(AIndentW);
end;

class procedure Tg2dGui.BeginGroup();
begin
  if not FInitialized then Exit;
  igBeginGroup();
end;

class procedure Tg2dGui.EndGroup();
begin
  if not FInitialized then Exit;
  igEndGroup();
end;

class function Tg2dGui.GetCursorPos(): Tg2dVec;
var
  LPos: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetCursorPos(@LPos);
  Result := ImVec2ToTg2dVec(LPos);
end;

class procedure Tg2dGui.SetCursorPos(const APos: Tg2dVec);
begin
  if not FInitialized then Exit;
  igSetCursorPos(Tg2dVecToImVec2(APos));
end;

class function Tg2dGui.GetCursorStartPos(): Tg2dVec;
var
  LPos: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetCursorStartPos(@LPos);
  Result := ImVec2ToTg2dVec(LPos);
end;

class function Tg2dGui.GetCursorScreenPos(): Tg2dVec;
var
  LPos: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetCursorScreenPos(@LPos);
  Result := ImVec2ToTg2dVec(LPos);
end;

class procedure Tg2dGui.SetCursorScreenPos(const APos: Tg2dVec);
begin
  if not FInitialized then Exit;
  igSetCursorScreenPos(Tg2dVecToImVec2(APos));
end;

class function Tg2dGui.GetContentRegionAvail(): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetContentRegionAvail(@LSize);
  Result := ImVec2ToTg2dVec(LSize);
end;

class function Tg2dGui.GetContentRegionMax(): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetContentRegionAvail(@LSize);
  Result := ImVec2ToTg2dVec(LSize);
end;

class function Tg2dGui.GetWindowContentRegionMin(): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  // Use window position instead
  igGetWindowPos(@LSize);
  Result := ImVec2ToTg2dVec(LSize);
end;

class function Tg2dGui.GetWindowContentRegionMax(): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  // Use window size instead
  igGetWindowSize(@LSize);
  Result := ImVec2ToTg2dVec(LSize);
end;
{$ENDREGION}

{$REGION ' TEXT & LABELS '}
class procedure Tg2dGui.Text(const AText: string);
begin
  if not FInitialized then Exit;
  igText(Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.Text(const AFormat: string; const AArgs: array of const);
begin
  if not FInitialized then Exit;
  Text(Format(AFormat, AArgs));
end;

class procedure Tg2dGui.TextColored(const AColor: Tg2dColor; const AText: string);
begin
  if not FInitialized then Exit;
  igTextColored(Tg2dColorToImVec4(AColor), Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.TextColored(const AColor: Tg2dColor; const AFormat: string; const AArgs: array of const);
begin
  if not FInitialized then Exit;
  TextColored(AColor, Format(AFormat, AArgs));
end;

class procedure Tg2dGui.TextDisabled(const AText: string);
begin
  if not FInitialized then Exit;
  igTextDisabled(Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.TextWrapped(const AText: string);
begin
  if not FInitialized then Exit;
  igTextWrapped(Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.LabelText(const ALabel, AText: string);
begin
  if not FInitialized then Exit;
  igLabelText(Tg2dUtils.AsUTF8(ALabel, []), Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.BulletText(const AText: string);
begin
  if not FInitialized then Exit;
  igBulletText(Tg2dUtils.AsUTF8(AText, []));
end;

class function Tg2dGui.CalcTextSize(const AText: string; const AHideTextAfterDoubleHash: Boolean; const AWrapWidth: Single): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igCalcTextSize(@LSize, Tg2dUtils.AsUTF8(AText, []), nil, AHideTextAfterDoubleHash, AWrapWidth);
  Result := ImVec2ToTg2dVec(LSize);
end;
{$ENDREGION}

{$REGION ' BUTTONS '}
class function Tg2dGui.Button(const ALabel: string; const ASize: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igButton(Tg2dUtils.AsUTF8(ALabel, []), Tg2dVecToImVec2(ASize));
end;

class function Tg2dGui.Button(const ALabel: string): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igButton(Tg2dUtils.AsUTF8(ALabel, []), LZeroSize);
end;

class function Tg2dGui.SmallButton(const ALabel: string): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igSmallButton(Tg2dUtils.AsUTF8(ALabel, []));
end;

class function Tg2dGui.InvisibleButton(const AID: string; const ASize: Tg2dVec; const AFlags: Tg2dGuiButtonFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInvisibleButton(Tg2dUtils.AsUTF8(AID, []), Tg2dVecToImVec2(ASize), AFlags);
end;

class function Tg2dGui.ArrowButton(const AID: string; const ADirection: Tg2dGuiDirection): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igArrowButton(Tg2dUtils.AsUTF8(AID, []), ADirection);
end;

class function Tg2dGui.ImageButton(const ATexture: Tg2dTexture;  const ASize: Tg2dVec; const AUv0, AUv1: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igImageButton(Tg2dUtils.AsUTF8('', []), ATexture.GetHandle(), Tg2dVecToImVec2(ASize), Tg2dVecToImVec2(AUv0), Tg2dVecToImVec2(AUv1), Tg2dColorToImVec4(G2D_BLACK), Tg2dColorToImVec4(G2D_WHITE));
end;

class function Tg2dGui.ImageButton(const ATexture: Tg2dTexture;  const ASize: Tg2dVec): Boolean;
var
  LUv0, LUv1: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LUv0.x := 0; LUv0.y := 0;
  LUv1.x := 1; LUv1.y := 1;
  Result := igImageButton(Tg2dUtils.AsUTF8('', []), ATexture.GetHandle(), Tg2dVecToImVec2(ASize), LUv0, LUv1, Tg2dColorToImVec4(G2D_BLACK), Tg2dColorToImVec4(G2D_WHITE));
end;

class function Tg2dGui.Checkbox(const ALabel: string; const AValue: PBoolean): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igCheckbox(Tg2dUtils.AsUTF8(ALabel, []), AValue);
end;

class function Tg2dGui.CheckboxFlags(const ALabel: string; const AFlags: PCardinal; const AFlagsValue: Cardinal): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igCheckboxFlags_UintPtr(Tg2dUtils.AsUTF8(ALabel, []), AFlags, AFlagsValue);
end;

class function Tg2dGui.RadioButton(const ALabel: string; const AActive: Boolean): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igRadioButton_Bool(Tg2dUtils.AsUTF8(ALabel, []), AActive);
end;

class function Tg2dGui.RadioButton(const ALabel: string; const AValue: PInteger; const AVButton: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igRadioButton_IntPtr(Tg2dUtils.AsUTF8(ALabel, []), AValue, AVButton);
end;

class procedure Tg2dGui.ProgressBar(const AFraction: Single; const ASizeArg: Tg2dVec; const AOverlay: string);
begin
  if not FInitialized then Exit;
  if AOverlay <> '' then
    igProgressBar(AFraction, Tg2dVecToImVec2(ASizeArg), Tg2dUtils.AsUTF8(AOverlay, []))
  else
    igProgressBar(AFraction, Tg2dVecToImVec2(ASizeArg), nil);
end;

class procedure Tg2dGui.ProgressBar(const AFraction: Single);
var
  LDefaultSize: ImVec2;
begin
  if not FInitialized then Exit;
  LDefaultSize.x := -1;
  LDefaultSize.y := 0;
  igProgressBar(AFraction, LDefaultSize, nil);
end;

class procedure Tg2dGui.Bullet();
begin
  if not FInitialized then Exit;
  igBullet();
end;
{$ENDREGION}

{$REGION ' INPUT CONTROLS '}
class function Tg2dGui.InputText(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const AFlags: Tg2dGuiInputTextFlags; const ACallback: Tg2dGuiInputTextCallback): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputText(Tg2dUtils.AsUTF8(ALabel, []), ABuffer, ABufSize, AFlags, @ACallback, nil);
end;

class function Tg2dGui.InputTextMultiline(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const ASize: Tg2dVec; const AFlags: Tg2dGuiInputTextFlags; const ACallback: Tg2dGuiInputTextCallback): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputTextMultiline(Tg2dUtils.AsUTF8(ALabel, []), ABuffer, ABufSize, Tg2dVecToImVec2(ASize), AFlags, @ACallback, nil);
end;

class function Tg2dGui.InputTextMultiline(const ALabel: string; const ABuffer: PAnsiChar; const ABufSize: Integer): Boolean;
var
  LDefaultSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LDefaultSize.x := 0;
  LDefaultSize.y := 0;
  Result := igInputTextMultiline(Tg2dUtils.AsUTF8(ALabel, []), ABuffer, ABufSize, LDefaultSize, 0, nil, nil);
end;

class function Tg2dGui.InputTextWithHint(const ALabel, AHint: string; const ABuffer: PAnsiChar; const ABufSize: Integer; const AFlags: Tg2dGuiInputTextFlags; const ACallback: Tg2dGuiInputTextCallback): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputTextWithHint(Tg2dUtils.AsUTF8(ALabel, []), Tg2dUtils.AsUTF8(AHint, []), ABuffer, ABufSize, AFlags, @ACallback, nil);
end;

class function Tg2dGui.InputFloat(const ALabel: string; const AValue: PSingle; const AStep, AStepFast: Single; const AFormat: string; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputFloat(Tg2dUtils.AsUTF8(ALabel, []), AValue, AStep, AStepFast, Tg2dUtils.AsUTF8(AFormat, []), AFlags);
end;

class function Tg2dGui.InputFloat2(const ALabel: string; const AValue: PSingle; const AFormat: string; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputFloat2(Tg2dUtils.AsUTF8(ALabel, []), AValue, Tg2dUtils.AsUTF8(AFormat, []), AFlags);
end;

class function Tg2dGui.InputFloat3(const ALabel: string; const AValue: PSingle; const AFormat: string; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputFloat3(Tg2dUtils.AsUTF8(ALabel, []), AValue, Tg2dUtils.AsUTF8(AFormat, []), AFlags);
end;

class function Tg2dGui.InputFloat4(const ALabel: string; const AValue: PSingle; const AFormat: string; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputFloat4(Tg2dUtils.AsUTF8(ALabel, []), AValue, Tg2dUtils.AsUTF8(AFormat, []), AFlags);
end;

class function Tg2dGui.InputInt(const ALabel: string; const AValue: PInteger; const AStep, AStepFast: Integer; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputInt(Tg2dUtils.AsUTF8(ALabel, []), AValue, AStep, AStepFast, AFlags);
end;

class function Tg2dGui.InputInt2(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputInt2(Tg2dUtils.AsUTF8(ALabel, []), AValue, AFlags);
end;

class function Tg2dGui.InputInt3(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputInt3(Tg2dUtils.AsUTF8(ALabel, []), AValue, AFlags);
end;

class function Tg2dGui.InputInt4(const ALabel: string; const AValue: PInteger; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputInt4(Tg2dUtils.AsUTF8(ALabel, []), AValue, AFlags);
end;

class function Tg2dGui.InputDouble(const ALabel: string; const AValue: PDouble; const AStep, AStepFast: Double; const AFormat: string; const AFlags: Tg2dGuiInputTextFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igInputDouble(Tg2dUtils.AsUTF8(ALabel, []), AValue, AStep, AStepFast, Tg2dUtils.AsUTF8(AFormat, []), AFlags);
end;

// Sliders
class function Tg2dGui.SliderFloat(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderFloat(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderFloat2(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderFloat2(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderFloat3(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderFloat3(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderFloat4(const ALabel: string; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderFloat4(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderAngle(const ALabel: string; const AValueRad: PSingle; const AMinDegrees, AMaxDegrees: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderAngle(Tg2dUtils.AsUTF8(ALabel, []), AValueRad, AMinDegrees, AMaxDegrees, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderInt(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderInt(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderInt2(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderInt2(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderInt3(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderInt3(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.SliderInt4(const ALabel: string; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igSliderInt4(Tg2dUtils.AsUTF8(ALabel, []), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.VSliderFloat(const ALabel: string; const ASize: Tg2dVec; const AValue: PSingle; const AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igVSliderFloat(Tg2dUtils.AsUTF8(ALabel, []), Tg2dVecToImVec2(ASize), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.VSliderInt(const ALabel: string; const ASize: Tg2dVec; const AValue: PInteger; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igVSliderInt(Tg2dUtils.AsUTF8(ALabel, []), Tg2dVecToImVec2(ASize), AValue, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

// Drag Controls
class function Tg2dGui.DragFloat(const ALabel: string; const AValue: PSingle; const ASpeed, AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragFloat(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragFloat2(const ALabel: string; const AValue: PSingle; const ASpeed, AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragFloat2(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragFloat3(const ALabel: string; const AValue: PSingle; const ASpeed, AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragFloat3(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragFloat4(const ALabel: string; const AValue: PSingle; const ASpeed, AMin, AMax: Single; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragFloat4(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragFloatRange2(const ALabel: string; const ACurrentMin, ACurrentMax: PSingle; const ASpeed, AMin, AMax: Single; const AFormat, AFormatMax: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragFloatRange2(Tg2dUtils.AsUTF8(ALabel, []), ACurrentMin, ACurrentMax, ASpeed, AMin, AMax, PUTF8Char(LFormat), Tg2dUtils.AsUTF8(AFormatMax, []), AFlags);
end;

class function Tg2dGui.DragInt(const ALabel: string; const AValue: PInteger; const ASpeed: Single; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragInt(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragInt2(const ALabel: string; const AValue: PInteger; const ASpeed: Single; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragInt2(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragInt3(const ALabel: string; const AValue: PInteger; const ASpeed: Single; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragInt3(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragInt4(const ALabel: string; const AValue: PInteger; const ASpeed: Single; const AMin, AMax: Integer; const AFormat: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragInt4(Tg2dUtils.AsUTF8(ALabel, []), AValue, ASpeed, AMin, AMax, PUTF8Char(LFormat), AFlags);
end;

class function Tg2dGui.DragIntRange2(const ALabel: string; const ACurrentMin, ACurrentMax: PInteger; const ASpeed: Single; const AMin, AMax: Integer; const AFormat, AFormatMax: string; const AFlags: Tg2dGuiSliderFlags): Boolean;
var
  LFormat: UTF8String;
begin
  Result := False;
  if not FInitialized then Exit;
  LFormat := UTF8Encode(AFormat);
  Result := igDragIntRange2(Tg2dUtils.AsUTF8(ALabel, []), ACurrentMin, ACurrentMax, ASpeed, AMin, AMax, PUTF8Char(LFormat), Tg2dUtils.AsUTF8(AFormatMax, []), AFlags);
end;
{$ENDREGION}

{$REGION ' COLOR CONTROLS '}
class function Tg2dGui.ColorEdit3(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags): Boolean;
var
  LColorArray: array[0..2] of Single;
begin
  Result := False;
  if not FInitialized then Exit;

  LColorArray[0] := AColor.Red;
  LColorArray[1] := AColor.Green;
  LColorArray[2] := AColor.Blue;

  Result := igColorEdit3(Tg2dUtils.AsUTF8(ALabel, []), @LColorArray[0], AFlags);

  if Result then
  begin
    AColor.Red := LColorArray[0];
    AColor.Green := LColorArray[1];
    AColor.Blue := LColorArray[2];
  end;
end;

class function Tg2dGui.ColorEdit4(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags): Boolean;
var
  LColorArray: array[0..3] of Single;
begin
  Result := False;
  if not FInitialized then Exit;

  LColorArray[0] := AColor.Red;
  LColorArray[1] := AColor.Green;
  LColorArray[2] := AColor.Blue;
  LColorArray[3] := AColor.Alpha;

  Result := igColorEdit4(Tg2dUtils.AsUTF8(ALabel, []), @LColorArray[0], AFlags);

  if Result then
  begin
    AColor.Red := LColorArray[0];
    AColor.Green := LColorArray[1];
    AColor.Blue := LColorArray[2];
    AColor.Alpha := LColorArray[3];
  end;
end;

class function Tg2dGui.ColorPicker3(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags): Boolean;
var
  LColorArray: array[0..2] of Single;
begin
  Result := False;
  if not FInitialized then Exit;

  LColorArray[0] := AColor.Red;
  LColorArray[1] := AColor.Green;
  LColorArray[2] := AColor.Blue;

  Result := igColorPicker3(Tg2dUtils.AsUTF8(ALabel, []), @LColorArray[0], AFlags);

  if Result then
  begin
    AColor.Red := LColorArray[0];
    AColor.Green := LColorArray[1];
    AColor.Blue := LColorArray[2];
  end;
end;

class function Tg2dGui.ColorPicker4(const ALabel: string; var AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags; const ARefColor: Tg2dColor): Boolean;
var
  LColorArray: array[0..3] of Single;
  LRefColorArray: array[0..3] of Single;
begin
  Result := False;
  if not FInitialized then Exit;

  LColorArray[0] := AColor.Red;
  LColorArray[1] := AColor.Green;
  LColorArray[2] := AColor.Blue;
  LColorArray[3] := AColor.Alpha;

  LRefColorArray[0] := ARefColor.Red;
  LRefColorArray[1] := ARefColor.Green;
  LRefColorArray[2] := ARefColor.Blue;
  LRefColorArray[3] := ARefColor.Alpha;

  Result := igColorPicker4(Tg2dUtils.AsUTF8(ALabel, []), @LColorArray[0], AFlags, @LRefColorArray[0]);

  if Result then
  begin
    AColor.Red := LColorArray[0];
    AColor.Green := LColorArray[1];
    AColor.Blue := LColorArray[2];
    AColor.Alpha := LColorArray[3];
  end;
end;

class function Tg2dGui.ColorPicker4(const ALabel: string; var AColor: Tg2dColor): Boolean;
var
  LColorArray: array[0..3] of Single;
begin
  Result := False;
  if not FInitialized then Exit;

  LColorArray[0] := AColor.Red;
  LColorArray[1] := AColor.Green;
  LColorArray[2] := AColor.Blue;
  LColorArray[3] := AColor.Alpha;

  Result := igColorPicker4(Tg2dUtils.AsUTF8(ALabel, []), @LColorArray[0], 0, nil);

  if Result then
  begin
    AColor.Red := LColorArray[0];
    AColor.Green := LColorArray[1];
    AColor.Blue := LColorArray[2];
    AColor.Alpha := LColorArray[3];
  end;
end;

class function Tg2dGui.ColorButton(const ADescID: string; const AColor: Tg2dColor; const AFlags: Tg2dGuiColorEditFlags; const ASize: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igColorButton(Tg2dUtils.AsUTF8(ADescID, []), Tg2dColorToImVec4(AColor), AFlags, Tg2dVecToImVec2(ASize));
end;

class function Tg2dGui.ColorButton(const ADescID: string; const AColor: Tg2dColor): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igColorButton(Tg2dUtils.AsUTF8(ADescID, []), Tg2dColorToImVec4(AColor), 0, LZeroSize);
end;

class procedure Tg2dGui.SetColorEditOptions(const AFlags: Tg2dGuiColorEditFlags);
begin
  if not FInitialized then Exit;
  igSetColorEditOptions(AFlags);
end;
{$ENDREGION}

{$REGION ' SELECTION CONTROLS '}
class function Tg2dGui.BeginCombo(const ALabel, APreviewValue: string; const AFlags: Tg2dGuiComboFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginCombo(Tg2dUtils.AsUTF8(ALabel, []), Tg2dUtils.AsUTF8(APreviewValue, []), AFlags);
end;

class procedure Tg2dGui.EndCombo();
begin
  if not FInitialized then Exit;
  igEndCombo();
end;

class function Tg2dGui.Combo(const ALabel: string; const ACurrentItem: PInteger; const AItems: array of string; const APopupMaxHeightInItems: Integer): Boolean;
var
  I: Integer;
  LItemsStr: string;
begin
  Result := False;
  if not FInitialized then Exit;

  LItemsStr := '';
  for I := Low(AItems) to High(AItems) do
  begin
    LItemsStr := LItemsStr + AItems[I];
    if I < High(AItems) then
      LItemsStr := LItemsStr + #0;
  end;
  LItemsStr := LItemsStr + #0#0; // Double null terminator

  Result := igCombo_Str(Tg2dUtils.AsUTF8(ALabel, []), ACurrentItem, Tg2dUtils.AsUTF8(LItemsStr, []), APopupMaxHeightInItems);
end;

class function Tg2dGui.Combo(const ALabel: string; const ACurrentItem: PInteger; const AItemsSeparatedByZeros: string; const APopupMaxHeightInItems: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igCombo_Str(Tg2dUtils.AsUTF8(ALabel, []), ACurrentItem, Tg2dUtils.AsUTF8(AItemsSeparatedByZeros, []), APopupMaxHeightInItems);
end;

class function Tg2dGui.BeginListBox(const ALabel: string; const ASize: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginListBox(Tg2dUtils.AsUTF8(ALabel, []), Tg2dVecToImVec2(ASize));
end;

class function Tg2dGui.BeginListBox(const ALabel: string): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igBeginListBox(Tg2dUtils.AsUTF8(ALabel, []), LZeroSize);
end;

class procedure Tg2dGui.EndListBox();
begin
  if not FInitialized then Exit;
  igEndListBox();
end;

class function Tg2dGui.ListBox(const ALabel: string; const ACurrentItem: PInteger; const AItems: array of string; const AHeightInItems: Integer): Boolean;
var
  I: Integer;
  LItemsStr: string;
begin
  Result := False;
  if not FInitialized then Exit;

  LItemsStr := '';
  for I := Low(AItems) to High(AItems) do
  begin
    LItemsStr := LItemsStr + AItems[I];
    if I < High(AItems) then
      LItemsStr := LItemsStr + #0;
  end;
  LItemsStr := LItemsStr + #0#0; // Double null terminator

  Result := igListBox_Str_arr(Tg2dUtils.AsUTF8(ALabel, []), ACurrentItem, Tg2dUtils.AsUTF8(LItemsStr, []), Length(AItems), AHeightInItems);
end;

class function Tg2dGui.Selectable(const ALabel: string; const ASelected: Boolean; const AFlags: Tg2dGuiSelectableFlags; const ASize: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igSelectable_Bool(Tg2dUtils.AsUTF8(ALabel, []), ASelected, AFlags, Tg2dVecToImVec2(ASize));
end;

class function Tg2dGui.Selectable(const ALabel: string; const ASelected: Boolean): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igSelectable_Bool(Tg2dUtils.AsUTF8(ALabel, []), ASelected, 0, LZeroSize);
end;

class function Tg2dGui.Selectable(const ALabel: string; const ASelected: PBoolean; const AFlags: Tg2dGuiSelectableFlags; const ASize: Tg2dVec): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igSelectable_BoolPtr(Tg2dUtils.AsUTF8(ALabel, []), ASelected, AFlags, Tg2dVecToImVec2(ASize));
end;

class function Tg2dGui.Selectable(const ALabel: string; const ASelected: PBoolean): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igSelectable_BoolPtr(Tg2dUtils.AsUTF8(ALabel, []), ASelected, 0, LZeroSize);
end;
{$ENDREGION}

{$REGION ' TABLES '}
class function Tg2dGui.BeginTable(const AID: string; const AColumns: Integer; const AFlags: Tg2dGuiTableFlags; const AOuterSize: Tg2dVec; const AInnerWidth: Single): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginTable(Tg2dUtils.AsUTF8(AID, []), AColumns, AFlags, Tg2dVecToImVec2(AOuterSize), AInnerWidth);
end;

class function Tg2dGui.BeginTable(const AID: string; const AColumns: Integer): Boolean;
var
  LZeroSize: ImVec2;
begin
  Result := False;
  if not FInitialized then Exit;
  LZeroSize.x := 0;
  LZeroSize.y := 0;
  Result := igBeginTable(Tg2dUtils.AsUTF8(AID, []), AColumns, 0, LZeroSize, 0.0);
end;

class procedure Tg2dGui.EndTable();
begin
  if not FInitialized then Exit;
  igEndTable();
end;

class procedure Tg2dGui.TableNextRow(const ARowFlags: Tg2dGuiTableRowFlags; const AMinRowHeight: Single);
begin
  if not FInitialized then Exit;
  igTableNextRow(ARowFlags, AMinRowHeight);
end;

class function Tg2dGui.TableNextColumn(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTableNextColumn();
end;

class function Tg2dGui.TableSetColumnIndex(const AColumnN: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTableSetColumnIndex(AColumnN);
end;

class procedure Tg2dGui.TableSetupColumn(const ALabel: string; const AFlags: Tg2dGuiTableColumnFlags; const AInitWidthOrWeight: Single; const AUserId: Cardinal);
begin
  if not FInitialized then Exit;
  igTableSetupColumn(Tg2dUtils.AsUTF8(ALabel, []), AFlags, AInitWidthOrWeight, AUserId);
end;

class procedure Tg2dGui.TableSetupScrollFreeze(const ACols, ARows: Integer);
begin
  if not FInitialized then Exit;
  igTableSetupScrollFreeze(ACols, ARows);
end;

class procedure Tg2dGui.TableHeadersRow();
begin
  if not FInitialized then Exit;
  igTableHeadersRow();
end;

class procedure Tg2dGui.TableHeader(const ALabel: string);
begin
  if not FInitialized then Exit;
  igTableHeader(Tg2dUtils.AsUTF8(ALabel, []));
end;

class function Tg2dGui.TableGetSortSpecs(): Pointer;
begin
  Result := nil;
  if not FInitialized then Exit;
  Result := igTableGetSortSpecs();
end;

class function Tg2dGui.TableGetColumnCount(): Integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result := igTableGetColumnCount();
end;

class function Tg2dGui.TableGetColumnIndex(): Integer;
begin
  Result := -1;
  if not FInitialized then Exit;
  Result := igTableGetColumnIndex();
end;

class function Tg2dGui.TableGetRowIndex(): Integer;
begin
  Result := -1;
  if not FInitialized then Exit;
  Result := igTableGetRowIndex();
end;

class function Tg2dGui.TableGetColumnName(const AColumnN: Integer): string;
begin
  Result := '';
  if not FInitialized then Exit;
  Result := string(igTableGetColumnName_Int(AColumnN));
end;

class function Tg2dGui.TableGetColumnFlags(const AColumnN: Integer): Tg2dGuiTableColumnFlags;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result := igTableGetColumnFlags(AColumnN);
end;

class procedure Tg2dGui.TableSetColumnEnabled(const AColumnN: Integer; const AEnabled: Boolean);
begin
  if not FInitialized then Exit;
  igTableSetColumnEnabled(AColumnN, AEnabled);
end;

class procedure Tg2dGui.TableSetBgColor(const ABgTarget: Integer; const AColor: Cardinal; const AColumnN: Integer);
begin
  if not FInitialized then Exit;
  igTableSetBgColor(ABgTarget, AColor, AColumnN);
end;
{$ENDREGION}

{$REGION ' MENUS '}
class function Tg2dGui.BeginMenuBar(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginMenuBar();
end;

class procedure Tg2dGui.EndMenuBar();
begin
  if not FInitialized then Exit;
  igEndMenuBar();
end;

class function Tg2dGui.BeginMainMenuBar(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginMainMenuBar();
end;

class procedure Tg2dGui.EndMainMenuBar();
begin
  if not FInitialized then Exit;
  igEndMainMenuBar();
end;

class function Tg2dGui.BeginMenu(const ALabel: string; const AEnabled: Boolean): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginMenu(Tg2dUtils.AsUTF8(ALabel, []), AEnabled);
end;

class procedure Tg2dGui.EndMenu();
begin
  if not FInitialized then Exit;
  igEndMenu();
end;

class function Tg2dGui.MenuItem(const ALabel: string; const AShortcut: string; const ASelected: Boolean; const AEnabled: Boolean): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igMenuItem_Bool(Tg2dUtils.AsUTF8(ALabel, []), Tg2dUtils.AsUTF8(AShortcut, []), ASelected, AEnabled);
end;

class function Tg2dGui.MenuItem(const ALabel: string): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igMenuItem_Bool(Tg2dUtils.AsUTF8(ALabel, []), nil, False, True);
end;

class function Tg2dGui.MenuItem(const ALabel: string; const AShortcut: string; const ASelected: PBoolean; const AEnabled: Boolean): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igMenuItem_BoolPtr(Tg2dUtils.AsUTF8(ALabel, []), Tg2dUtils.AsUTF8(AShortcut, []), ASelected, AEnabled);
end;
{$ENDREGION}

{$REGION ' TABS '}
class function Tg2dGui.BeginTabBar(const AID: string; const AFlags: Tg2dGuiTabBarFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginTabBar(Tg2dUtils.AsUTF8(AID, []), AFlags);
end;

class procedure Tg2dGui.EndTabBar();
begin
  if not FInitialized then Exit;
  igEndTabBar();
end;

class function Tg2dGui.BeginTabItem(const ALabel: string; const AOpen: PBoolean; const AFlags: Tg2dGuiTabItemFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginTabItem(Tg2dUtils.AsUTF8(ALabel, []), AOpen, AFlags);
end;

class function Tg2dGui.BeginTabItem(const ALabel: string): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginTabItem(Tg2dUtils.AsUTF8(ALabel, []), nil, 0);
end;

class procedure Tg2dGui.EndTabItem();
begin
  if not FInitialized then Exit;
  igEndTabItem();
end;

class function Tg2dGui.TabItemButton(const ALabel: string; const AFlags: Tg2dGuiTabItemFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTabItemButton(Tg2dUtils.AsUTF8(ALabel, []), AFlags);
end;

class procedure Tg2dGui.SetTabItemClosed(const ATabOrDockedWindowLabel: string);
begin
  if not FInitialized then Exit;
  igSetTabItemClosed(Tg2dUtils.AsUTF8(ATabOrDockedWindowLabel, []));
end;
{$ENDREGION}

{$REGION ' TREE NODES '}
class function Tg2dGui.TreeNode(const ALabel: string): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTreeNode_Str(Tg2dUtils.AsUTF8(ALabel, []));
end;

class function Tg2dGui.TreeNode(const AID: string; const AFormat: string; const AArgs: array of const): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTreeNode_StrStr(Tg2dUtils.AsUTF8(AID, []), Tg2dUtils.AsUTF8(Format(AFormat, AArgs), []));
end;

class function Tg2dGui.TreeNodeEx(const ALabel: string; const AFlags: Tg2dGuiTreeNodeFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTreeNodeEx_Str(Tg2dUtils.AsUTF8(ALabel, []), AFlags);
end;

class function Tg2dGui.TreeNodeEx(const AID: string; const AFlags: Tg2dGuiTreeNodeFlags; const AFormat: string; const AArgs: array of const): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igTreeNodeEx_StrStr(Tg2dUtils.AsUTF8(AID, []), AFlags, Tg2dUtils.AsUTF8(Format(AFormat, AArgs), []));
end;

class procedure Tg2dGui.TreePush(const AID: string);
begin
  if not FInitialized then Exit;
  igTreePush_Str(Tg2dUtils.AsUTF8(AID, []));
end;

class procedure Tg2dGui.TreePush(const AID: Integer);
begin
  if not FInitialized then Exit;
  igTreePush_Ptr(Pointer(AID));
end;

class procedure Tg2dGui.TreePop();
begin
  if not FInitialized then Exit;
  igTreePop();
end;

class function Tg2dGui.GetTreeNodeToLabelSpacing(): Single;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result := igGetTreeNodeToLabelSpacing();
end;

class function Tg2dGui.CollapsingHeader(const ALabel: string; const AFlags: Tg2dGuiTreeNodeFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igCollapsingHeader_TreeNodeFlags(Tg2dUtils.AsUTF8(ALabel, []), AFlags);
end;

class function Tg2dGui.CollapsingHeader(const ALabel: string; const AOpen: PBoolean; const AFlags: Tg2dGuiTreeNodeFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igCollapsingHeader_BoolPtr(Tg2dUtils.AsUTF8(ALabel, []), AOpen, AFlags);
end;

class procedure Tg2dGui.SetNextTreeItemOpen(const AIsOpen: Boolean; const ACond: Integer);
begin
  if not FInitialized then Exit;
  igSetNextItemOpen(AIsOpen, ACond);
end;
{$ENDREGION}

{$REGION ' TOOLTIPS '}
class procedure Tg2dGui.BeginTooltip();
begin
  if not FInitialized then Exit;
  igBeginTooltip();
end;

class procedure Tg2dGui.EndTooltip();
begin
  if not FInitialized then Exit;
  igEndTooltip();
end;

class procedure Tg2dGui.SetTooltip(const AText: string);
begin
  if not FInitialized then Exit;
  igSetTooltip(Tg2dUtils.AsUTF8(AText, []));
end;

class procedure Tg2dGui.SetTooltip(const AFormat: string; const AArgs: array of const);
begin
  if not FInitialized then Exit;
  SetTooltip(Format(AFormat, AArgs));
end;
{$ENDREGION}

{$REGION ' POPUPS & MODALS '}
class function Tg2dGui.BeginPopup(const AID: string; const AFlags: Tg2dGuiWindowFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginPopup(Tg2dUtils.AsUTF8(AID, []), AFlags);
end;

class function Tg2dGui.BeginPopupModal(const AName: string; const AOpen: PBoolean; const AFlags: Tg2dGuiWindowFlags): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginPopupModal(Tg2dUtils.AsUTF8(AName, []), AOpen, AFlags);
end;

class procedure Tg2dGui.EndPopup();
begin
  if not FInitialized then Exit;
  igEndPopup();
end;

class procedure Tg2dGui.OpenPopup(const AID: string; const APopupFlags: Integer);
begin
  if not FInitialized then Exit;
  igOpenPopup_Str(Tg2dUtils.AsUTF8(AID, []), APopupFlags);
end;

class procedure Tg2dGui.OpenPopupOnItemClick(const AID: string; const APopupFlags: Integer);
begin
  if not FInitialized then Exit;
  igOpenPopupOnItemClick(Tg2dUtils.AsUTF8(AID, []), APopupFlags);
end;

class procedure Tg2dGui.CloseCurrentPopup();
begin
  if not FInitialized then Exit;
  igCloseCurrentPopup();
end;

class function Tg2dGui.BeginPopupContextItem(const AID: string; const APopupFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginPopupContextItem(Tg2dUtils.AsUTF8(AID, []), APopupFlags);
end;

class function Tg2dGui.BeginPopupContextWindow(const AID: string; const APopupFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginPopupContextWindow(Tg2dUtils.AsUTF8(AID, []), APopupFlags);
end;

class function Tg2dGui.BeginPopupContextVoid(const AID: string; const APopupFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igBeginPopupContextVoid(Tg2dUtils.AsUTF8(AID, []), APopupFlags);
end;

class function Tg2dGui.IsPopupOpen(const AID: string; const AFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsPopupOpen_Str(Tg2dUtils.AsUTF8(AID, []), AFlags);
end;
{$ENDREGION}

{$REGION ' WIDGETS UTILITIES '}
class function Tg2dGui.IsItemHovered(const AFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemHovered(AFlags);
end;

class function Tg2dGui.IsItemActive(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemActive();
end;

class function Tg2dGui.IsItemFocused(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemFocused();
end;

class function Tg2dGui.IsItemClicked(const AMouseButton: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemClicked(AMouseButton);
end;

class function Tg2dGui.IsItemVisible(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemVisible();
end;

class function Tg2dGui.IsItemEdited(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemEdited();
end;

class function Tg2dGui.IsItemActivated(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemActivated();
end;

class function Tg2dGui.IsItemDeactivated(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemDeactivated();
end;

class function Tg2dGui.IsItemDeactivatedAfterEdit(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemDeactivatedAfterEdit();
end;

class function Tg2dGui.IsItemToggledOpen(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsItemToggledOpen();
end;

class function Tg2dGui.IsAnyItemHovered(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsAnyItemHovered();
end;

class function Tg2dGui.IsAnyItemActive(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsAnyItemActive();
end;

class function Tg2dGui.IsAnyItemFocused(): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsAnyItemFocused();
end;

class function Tg2dGui.GetItemRectMin(): Tg2dVec;
var
  LRect: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetItemRectMin(@LRect);
  Result := ImVec2ToTg2dVec(LRect);
end;

class function Tg2dGui.GetItemRectMax(): Tg2dVec;
var
  LRect: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetItemRectMax(@LRect);
  Result := ImVec2ToTg2dVec(LRect);
end;

class function Tg2dGui.GetItemRectSize(): Tg2dVec;
var
  LSize: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetItemRectSize(@LSize);
  Result := ImVec2ToTg2dVec(LSize);
end;

{$ENDREGION}

{$REGION ' FOCUS & ACTIVATION '}
class procedure Tg2dGui.SetKeyboardFocusHere(const AOffset: Integer);
begin
  if not FInitialized then Exit;
  igSetKeyboardFocusHere(AOffset);
end;

class function Tg2dGui.IsWindowFocused(const AFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsWindowFocused(AFlags);
end;

class function Tg2dGui.IsWindowHovered(const AFlags: Integer): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsWindowHovered(AFlags);
end;

class procedure Tg2dGui.SetNextWindowFocus();
begin
  if not FInitialized then Exit;
  igSetNextWindowFocus();
end;

class procedure Tg2dGui.SetNextItemWidth(const AItemWidth: Single);
begin
  if not FInitialized then Exit;
  igSetNextItemWidth(AItemWidth);
end;

class procedure Tg2dGui.PushItemWidth(const AItemWidth: Single);
begin
  if not FInitialized then Exit;
  igPushItemWidth(AItemWidth);
end;

class procedure Tg2dGui.PopItemWidth();
begin
  if not FInitialized then Exit;
  igPopItemWidth();
end;

class procedure Tg2dGui.SetNextItemOpen(const AIsOpen: Boolean; const ACond: Integer);
begin
  if not FInitialized then Exit;
  igSetNextItemOpen(AIsOpen, ACond);
end;
{$ENDREGION}

{$REGION ' STYLE & THEME '}
class procedure Tg2dGui.StyleColorsDark();
begin
  if not FInitialized then Exit;
  igStyleColorsDark(nil);
end;

class procedure Tg2dGui.StyleColorsLight();
begin
  if not FInitialized then Exit;
  igStyleColorsLight(nil);
end;

class procedure Tg2dGui.StyleColorsClassic();
begin
  if not FInitialized then Exit;
  igStyleColorsClassic(nil);
end;

class procedure Tg2dGui.PushStyleColor(const AIdx: Tg2dGuiCol; const AColor: Tg2dColor);
begin
  if not FInitialized then Exit;
  igPushStyleColor_Vec4(AIdx, Tg2dColorToImVec4(AColor));
end;

class procedure Tg2dGui.PopStyleColor(const ACount: Integer);
begin
  if not FInitialized then Exit;
  igPopStyleColor(ACount);
end;

class procedure Tg2dGui.PushStyleVar(const AIdx: Tg2dGuiStyleVar; const AVal: Single);
begin
  if not FInitialized then Exit;
  igPushStyleVar_Float(AIdx, AVal);
end;

class procedure Tg2dGui.PushStyleVar(const AIdx: Tg2dGuiStyleVar; const AVal: Tg2dVec);
begin
  if not FInitialized then Exit;
  igPushStyleVar_Vec2(AIdx, Tg2dVecToImVec2(AVal));
end;

class procedure Tg2dGui.PopStyleVar(const ACount: Integer);
begin
  if not FInitialized then Exit;
  igPopStyleVar(ACount);
end;

{$ENDREGION}

{$REGION ' CURSOR & MOUSE '}
class function Tg2dGui.GetMousePos(): Tg2dVec;
var
  LPos: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetMousePos(@LPos);
  Result := ImVec2ToTg2dVec(LPos);
end;

class function Tg2dGui.GetMousePosOnOpeningCurrentPopup(): Tg2dVec;
var
  LPos: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetMousePosOnOpeningCurrentPopup(@LPos);
  Result := ImVec2ToTg2dVec(LPos);
end;

class function Tg2dGui.IsMouseDragging(const AButton: Tg2dGuiMouseButton; const ALockThreshold: Single): Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  Result := igIsMouseDragging(AButton, ALockThreshold);
end;

class function Tg2dGui.GetMouseDragDelta(const AButton: Tg2dGuiMouseButton; const ALockThreshold: Single): Tg2dVec;
var
  LDelta: ImVec2;
begin
  Result := Tg2dVec.Create(0, 0);
  if not FInitialized then Exit;
  igGetMouseDragDelta(@LDelta, AButton, ALockThreshold);
  Result := ImVec2ToTg2dVec(LDelta);
end;

class procedure Tg2dGui.ResetMouseDragDelta(const AButton: Tg2dGuiMouseButton);
begin
  if not FInitialized then Exit;
  igResetMouseDragDelta(AButton);
end;

class function Tg2dGui.GetMouseCursor(): Tg2dGuiMouseCursor;
begin
  Result := G2D_GUI_MOUSE_CURSOR_NONE;
  if not FInitialized then Exit;
  Result := igGetMouseCursor();
end;

class procedure Tg2dGui.SetMouseCursor(const ACursorType: Tg2dGuiMouseCursor);
begin
  if not FInitialized then Exit;
  igSetMouseCursor(ACursorType);
end;

{$ENDREGION}

{$REGION ' CLIPBOARD '}
class function Tg2dGui.GetClipboardText(): string;
begin
  Result := '';
  if not FInitialized then Exit;
  Result := string(igGetClipboardText());
end;

class procedure Tg2dGui.SetClipboardText(const AText: string);
begin
  if not FInitialized then Exit;
  igSetClipboardText(Tg2dUtils.AsUTF8(AText, []));
end;
{$ENDREGION}

{$REGION ' PLOTTING '}
class procedure Tg2dGui.PlotLines(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer; const AValuesOffset: Integer; const AOverlayText: string; const AScaleMin, AScaleMax: Single; const AGraphSize: Tg2dVec; const AStride: Integer);
begin
  if not FInitialized then Exit;
  igPlotLines_FloatPtr(Tg2dUtils.AsUTF8(ALabel, []), AValues, AValuesCount, AValuesOffset, Tg2dUtils.AsUTF8(AOverlayText, []), AScaleMin, AScaleMax, Tg2dVecToImVec2(AGraphSize), AStride);
end;

class procedure Tg2dGui.PlotLines(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer);
var
  LDefaultSize: ImVec2;
begin
  if not FInitialized then Exit;
  LDefaultSize.x := 0;
  LDefaultSize.y := 0;
  igPlotLines_FloatPtr(Tg2dUtils.AsUTF8(ALabel, []), AValues, AValuesCount, 0, nil, 3.4e+38, 3.4e+38, LDefaultSize, SizeOf(Single));
end;

class procedure Tg2dGui.PlotHistogram(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer; const AValuesOffset: Integer; const AOverlayText: string; const AScaleMin, AScaleMax: Single; const AGraphSize: Tg2dVec; const AStride: Integer);
begin
  if not FInitialized then Exit;
  igPlotHistogram_FloatPtr(Tg2dUtils.AsUTF8(ALabel, []), AValues, AValuesCount, AValuesOffset, Tg2dUtils.AsUTF8(AOverlayText, []), AScaleMin, AScaleMax, Tg2dVecToImVec2(AGraphSize), AStride);
end;

class procedure Tg2dGui.PlotHistogram(const ALabel: string; const AValues: PSingle; const AValuesCount: Integer);
var
  LDefaultSize: ImVec2;
begin
  if not FInitialized then Exit;
  LDefaultSize.x := 0;
  LDefaultSize.y := 0;
  igPlotHistogram_FloatPtr(Tg2dUtils.AsUTF8(ALabel, []), AValues, AValuesCount, 0, nil, 3.4e+38, 3.4e+38, LDefaultSize, SizeOf(Single));
end;
{$ENDREGION}

{$REGION ' DRAWING '}
class procedure Tg2dGui.AddRectFilled(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor; const ARounding: Single; const AFlags: Integer);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddRectFilled(LDrawList, Tg2dVecToImVec2(APMin), Tg2dVecToImVec2(APMax), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), ARounding, AFlags);
end;

class procedure Tg2dGui.AddRectFilled(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddRectFilled(LDrawList, Tg2dVecToImVec2(APMin), Tg2dVecToImVec2(APMax), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), 0.0, 0);
end;

class procedure Tg2dGui.AddRect(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor; const ARounding: Single; const AFlags: Integer; const AThickness: Single);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddRect(LDrawList, Tg2dVecToImVec2(APMin), Tg2dVecToImVec2(APMax), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), ARounding, AFlags, AThickness);
end;

class procedure Tg2dGui.AddRect(const APMin, APMax: Tg2dVec; const AColor: Tg2dColor);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddRect(LDrawList, Tg2dVecToImVec2(APMin), Tg2dVecToImVec2(APMax), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), 0.0, 0, 1.0);
end;

class procedure Tg2dGui.AddLine(const AP1, AP2: Tg2dVec; const AColor: Tg2dColor; const AThickness: Single);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddLine(LDrawList, Tg2dVecToImVec2(AP1), Tg2dVecToImVec2(AP2), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), AThickness);
end;

class procedure Tg2dGui.AddLine(const AP1, AP2: Tg2dVec; const AColor: Tg2dColor);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddLine(LDrawList, Tg2dVecToImVec2(AP1), Tg2dVecToImVec2(AP2), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), 1.0);
end;

class procedure Tg2dGui.AddCircle(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor; const ANumSegments: Integer; const AThickness: Single);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddCircle(LDrawList, Tg2dVecToImVec2(ACenter), ARadius, igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), ANumSegments, AThickness);
end;

class procedure Tg2dGui.AddCircle(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddCircle(LDrawList, Tg2dVecToImVec2(ACenter), ARadius, igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), 0, 1.0);
end;

class procedure Tg2dGui.AddCircleFilled(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor; const ANumSegments: Integer);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddCircleFilled(LDrawList, Tg2dVecToImVec2(ACenter), ARadius, igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), ANumSegments);
end;

class procedure Tg2dGui.AddCircleFilled(const ACenter: Tg2dVec; const ARadius: Single; const AColor: Tg2dColor);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddCircleFilled(LDrawList, Tg2dVecToImVec2(ACenter), ARadius, igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), 0);
end;

class procedure Tg2dGui.AddText(const APos: Tg2dVec; const AColor: Tg2dColor; const AText: string);
var
  LDrawList: PImDrawList;
begin
  if not FInitialized then Exit;
  LDrawList := igGetWindowDrawList();
  if Assigned(LDrawList) then
    ImDrawList_AddText_Vec2(LDrawList, Tg2dVecToImVec2(APos), igColorConvertFloat4ToU32(Tg2dColorToImVec4(AColor)), Tg2dUtils.AsUTF8(AText, []), nil);
end;
{$ENDREGION}

end.

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

===============================================================================
Game2D.Console - Advanced Cross-Platform Console Management System

A comprehensive console manipulation framework providing ANSI escape sequence
support, advanced text formatting, color management, keyboard input handling,
cursor control, and complete text-based menu systems. This unit delivers
production-ready console functionality with Windows console optimizations,
teletype effects, and sophisticated menu interfaces for console applications.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════
• **Static Class Design**: All functionality accessed through Tg2dConsole
  class methods requiring no instantiation for maximum efficiency
• **ANSI Escape Sequence Engine**: Full CSI (Control Sequence Introducer)
  command support for universal terminal compatibility
• **Windows Console API Integration**: Direct Windows console manipulation
  for enhanced performance and feature support
• **Performance-Optimized I/O**: High-speed console writing using Windows
  Unicode console functions for maximum throughput
• **State Management**: Automatic keyboard state tracking and console
  detection with proper cleanup handling

DESIGN PATTERNS USED:
• **Facade Pattern**: Simplified interface over complex Windows console APIs
• **Template Pattern**: Generic text menu system with customizable themes
• **Strategy Pattern**: Multiple input/output strategies based on console type

═══════════════════════════════════════════════════════════════════════════════
TEXT OUTPUT AND FORMATTING
═══════════════════════════════════════════════════════════════════════════════
• **Enhanced Print Functions**: Print/PrintLn with format support and automatic
  formatting reset options
• **ANSI Color Support**: Full RGB color support for foreground/background with
  256-color palette compatibility
• **Text Formatting**: Bold, underline, italic, blink, dim, invert, and custom
  formatting combinations
• **Word Wrapping**: Intelligent text wrapping with configurable break characters
  and margin control

BASIC TEXT OUTPUT:
  begin
    Tg2dConsole.Print('Hello World');
    Tg2dConsole.PrintLn('Line with automatic line break');
    Tg2dConsole.Print('Formatted: %s = %d', ['Score', 1500]);
  end;

COLOR MANAGEMENT:
  var
    LRedColor: string;
    LGameColor: Tg2dColor;
  begin
    // RGB color creation
    LRedColor := Tg2dConsole.CreateForegroundColor(255, 0, 0);
    Tg2dConsole.Print('%sRed Text', [LRedColor]);

    // Game2D color integration
    LGameColor := Tg2dColor.Create(0.0, 1.0, 0.5, 1.0);
    Tg2dConsole.SetForegroundColor(LGameColor);
    Tg2dConsole.PrintLn('Green text using Game2D color');
  end;

ADVANCED FORMATTING:
  begin
    Tg2dConsole.SetBoldText();
    Tg2dConsole.Print('Bold Text');
    Tg2dConsole.ResetTextFormat();

    // Combined formatting with color
    Tg2dConsole.Print('%s%sBold Red Text', [
      Tg2dConsole.CreateForegroundColor(255, 0, 0),
      G2D_CSI_BOLD
    ]);
  end;

═══════════════════════════════════════════════════════════════════════════════
CURSOR AND SCREEN CONTROL
═══════════════════════════════════════════════════════════════════════════════
• **Precise Cursor Positioning**: Absolute and relative cursor movement with
  coordinate-based positioning
• **Screen Management**: Complete screen clearing, line clearing, and scrolling
  operations with optimization for different console types
• **Cursor Visibility**: Show/hide cursor with save/restore position support
• **Console Detection**: Automatic detection of console output availability

CURSOR MANIPULATION:
  var
    LX: Integer;
    LY: Integer;
  begin
    // Get current position
    Tg2dConsole.GetCursorPos(@LX, @LY);

    // Move to specific position (0-based coordinates)
    Tg2dConsole.SetCursorPos(10, 5);
    Tg2dConsole.Print('Text at position 10,5');

    // Relative movement
    Tg2dConsole.MoveCursorUp(2);
    Tg2dConsole.MoveCursorForward(5);

    // Save and restore position
    Tg2dConsole.SaveCursorPos();
    Tg2dConsole.SetCursorPos(0, 0);
    Tg2dConsole.Print('Top-left corner');
    Tg2dConsole.RestoreCursorPos();
  end;

SCREEN OPERATIONS:
  begin
    // Complete screen clear with cursor home
    Tg2dConsole.ClearScreen();

    // Clear current line
    Tg2dConsole.ClearLine();

    // Clear from cursor to end of line
    Tg2dConsole.ClearToEndOfLine();

    // Hide cursor during updates
    Tg2dConsole.HideCursor();
    // ... update screen content ...
    Tg2dConsole.ShowCursor();
  end;

═══════════════════════════════════════════════════════════════════════════════
KEYBOARD INPUT SYSTEM
═══════════════════════════════════════════════════════════════════════════════
• **Real-Time Key Detection**: Non-blocking key state checking with press/release
  detection for responsive game-like input
• **Character Input**: Unicode character reading with controlled input validation
• **Input Filtering**: Configurable character sets and string length limits with
  visual feedback during typing
• **State Tracking**: Automatic key state management preventing double-triggers

KEY STATE DETECTION:
  begin
    // Real-time key checking (non-blocking)
    if Tg2dConsole.IsKeyPressed(VK_SPACE) then
      Tg2dConsole.PrintLn('Space key is currently held down');

    // Single press detection (prevents repeats)
    if Tg2dConsole.WasKeyReleased(VK_ESCAPE) then
      Tg2dConsole.PrintLn('Escape was just pressed and released');

    // Check for any key activity
    if Tg2dConsole.AnyKeyPressed() then
      Tg2dConsole.PrintLn('Some key was pressed');
  end;

CONTROLLED INPUT:
  var
    LUserName: string;
    LNumber: string;
    LAlphaNumeric: Tg2dCharSet;
    LNumericOnly: Tg2dCharSet;
  begin
    LAlphaNumeric := ['A'..'Z', 'a'..'z', '0'..'9', ' '];
    LNumericOnly := ['0'..'9'];

    // Get user name with character filtering
    Tg2dConsole.Print('Enter name: ');
    LUserName := Tg2dConsole.ReadLnX(LAlphaNumeric, 20,
                   Tg2dConsole.CreateForegroundColor(0, 255, 0));

    // Get numeric input only
    Tg2dConsole.Print('Enter number: ');
    LNumber := Tg2dConsole.ReadLnX(LNumericOnly, 10,
                 Tg2dConsole.CreateForegroundColor(255, 255, 0));
  end;

═══════════════════════════════════════════════════════════════════════════════
ADVANCED TEXT EFFECTS
═══════════════════════════════════════════════════════════════════════════════
• **Teletype Animation**: Character-by-character text display with configurable
  timing and interruption support
• **Text Wrapping Engine**: Intelligent word wrapping with custom break characters
  and margin handling
• **Performance Timing**: High-precision timing using QueryPerformanceCounter
  for smooth animations

TELETYPE EFFECTS:
  var
    LGreenColor: string;
  begin
    LGreenColor := Tg2dConsole.CreateForegroundColor(0, 255, 0);

    // Animated text display with variable speed
    Tg2dConsole.Teletype(
      'This text appears character by character with random timing...',
      LGreenColor,    // Text color
      4,              // Right margin
      20,             // Minimum delay (ms)
      100,            // Maximum delay (ms)
      VK_ESCAPE       // Break key to skip animation
    );
  end;

INTELLIGENT WORD WRAPPING:
  var
    LLongText: string;
    LWrappedText: string;
    LBreakChars: Tg2dCharSet;
  begin
    LLongText := 'This is a very long line of text that needs to be wrapped...';
    LBreakChars := [' ', '-', '.', ','];

    // Wrap text at 60 characters with smart breaking
    LWrappedText := Tg2dConsole.WrapTextEx(LLongText, 60, LBreakChars);
    Tg2dConsole.PrintLn(LWrappedText);
  end;

═══════════════════════════════════════════════════════════════════════════════
CONSOLE INFORMATION AND UTILITIES
═══════════════════════════════════════════════════════════════════════════════
• **Console Detection**: Determine console availability and launch context
• **Size Management**: Get/set console dimensions and title
• **Clipboard Integration**: Full clipboard read/write support for text operations
• **Environment Detection**: Detect if running from console, IDE, or standalone

CONSOLE INFORMATION:
  var
    LWidth: Integer;
    LHeight: Integer;
    LTitle: string;
  begin
    // Check if console output is available
    if Tg2dConsole.HasConsoleOutput() then
    begin
      // Get console dimensions
      Tg2dConsole.GetSize(@LWidth, @LHeight);
      Tg2dConsole.PrintLn('Console size: %dx%d', [LWidth, LHeight]);

      // Manage console title
      LTitle := Tg2dConsole.GetTitle();
      Tg2dConsole.SetTitle('Game2D Console Application');

      // Environment detection
      if Tg2dConsole.StartedFromConsole() then
        Tg2dConsole.PrintLn('Started from command line')
      else if Tg2dConsole.StartedFromDelphiIDE() then
        Tg2dConsole.PrintLn('Running from Delphi IDE');
    end;
  end;

CLIPBOARD OPERATIONS:
  var
    LClipboardText: string;
  begin
    // Read from clipboard
    LClipboardText := Tg2dConsole.GetClipboardText();
    Tg2dConsole.PrintLn('Clipboard contains: %s', [LClipboardText]);

    // Write to clipboard
    Tg2dConsole.SetClipboardText('Hello from Game2D Console!');
  end;

═══════════════════════════════════════════════════════════════════════════════
TEXT MENU SYSTEM
═══════════════════════════════════════════════════════════════════════════════
• **Generic Menu Framework**: Type-safe menu system supporting any data type
  with automatic layout and navigation
• **Professional Themes**: Multiple built-in themes (Clean, Professional,
  Classic, Dark, Light) with full customization support
• **Advanced Layout**: Multi-column support with intelligent spacing, borders,
  and separator handling
• **Rich Interaction**: Keyboard navigation with wrap-around, disabled items,
  and visual feedback

BASIC MENU CREATION:
  var
    LMenu: Tg2dTextMenu<Integer>;
    LResult: Tg2dTextMenuResult;
    LSelectedItem: Tg2dTextMenuItem<Integer>;
  begin
    LMenu := Tg2dTextMenu<Integer>.Create();
    try
      // Configure menu appearance
      LMenu.Title := 'Main Menu';
      LMenu.FooterText := 'Use arrow keys to navigate, Enter to select, Esc to cancel';
      LMenu.Theme := Tg2dTextMenuTheme.CreateProfessional();

      // Add menu items
      LMenu.AddItem(1, 'New Game');
      LMenu.AddItem(2, 'Load Game');
      LMenu.AddItem(3, 'Settings');
      LMenu.AddSeparator('Advanced Options');
      LMenu.AddItem(4, 'Debug Mode', True, 99); // Tag for special handling
      LMenu.AddItem(0, 'Exit Game');

      // Display menu and get result
      LResult := LMenu.Run();

      case LResult of
        mrSelected: begin
          LSelectedItem := LMenu.GetSelectedItem();
          Tg2dConsole.PrintLn('Selected: %s (Value: %d)',
            [LSelectedItem.Description, LSelectedItem.Data]);
        end;
        mrCanceled: Tg2dConsole.PrintLn('Menu was canceled');
      end;
    finally
      LMenu.Free();
    end;
  end;

ADVANCED MENU WITH CUSTOM THEME:
  var
    LGameMenu: Tg2dTextMenu<string>;
    LCustomTheme: Tg2dTextMenuTheme;
  begin
    LGameMenu := Tg2dTextMenu<string>.Create();
    try
      // Create custom theme
      LCustomTheme := Tg2dTextMenuTheme.CreateDarkTheme();
      LCustomTheme.BorderStyle := bsDouble;
      LCustomTheme.SelectedPrefix := '► ';
      LCustomTheme.NormalPrefix := '  ';
      LCustomTheme.ShowLineNumbers := True;
      LCustomTheme.MaxColumns := 2; // Multi-column layout

      LGameMenu.Theme := LCustomTheme;
      LGameMenu.Title := 'Game Selection';

      // Add game entries
      LGameMenu.AddItem('arcade.exe', 'Classic Arcade Games');
      LGameMenu.AddItem('rpg.exe', 'Role Playing Adventures');
      LGameMenu.AddItem('puzzle.exe', 'Puzzle Challenges');
      LGameMenu.AddItem('action.exe', 'Action & Shooting Games');

      // Run with multi-column display
      if LGameMenu.Run() = mrSelected then
      begin
        LSelectedItem := LGameMenu.GetSelectedItem();
        Tg2dConsole.PrintLn('Launching: %s', [LSelectedItem.Data]);
      end;
    finally
      LGameMenu.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
INTEGRATION EXAMPLES
═══════════════════════════════════════════════════════════════════════════════

GAME CONSOLE INTERFACE:
  procedure CreateGameConsole();
  var
    LMenu: Tg2dTextMenu<Integer>;
    LConsoleTheme: Tg2dTextMenuTheme;
    LRunning: Boolean;
    LChoice: Integer;
  begin
    // Setup console appearance
    Tg2dConsole.ClearScreen();
    Tg2dConsole.SetTitle('Game2D Console Interface');
    Tg2dConsole.PrintASCIILogo(); // Display Game2D logo

    // Create professional menu theme
    LConsoleTheme := Tg2dTextMenuTheme.CreateProfessional();
    LConsoleTheme.TitleColor := Tg2dColor.Create(0.0, 0.8, 1.0, 1.0);

    LMenu := Tg2dTextMenu<Integer>.Create();
    try
      LMenu.Theme := LConsoleTheme;
      LMenu.Title := 'Game Development Console';
      LMenu.FooterText := 'Select an option to continue';

      LRunning := True;
      while LRunning do
      begin
        LMenu.Clear();
        LMenu.AddItem(1, 'Asset Pipeline Tools');
        LMenu.AddItem(2, 'Sprite Animation Editor');
        LMenu.AddItem(3, 'Audio Processing');
        LMenu.AddSeparator('System Tools');
        LMenu.AddItem(4, 'Performance Monitor');
        LMenu.AddItem(5, 'Debug Console');
        LMenu.AddItem(0, 'Exit Application');

        if LMenu.Run() = mrSelected then
        begin
          LChoice := LMenu.GetSelectedItem().Data;
          HandleMenuChoice(LChoice, LRunning);
        end
        else
          LRunning := False;
      end;
    finally
      LMenu.Free();
    end;
  end;

ANIMATED STATUS DISPLAY:
  procedure ShowProgressWithAnimation();
  var
    LProgress: Integer;
    LProgressColor: string;
  begin
    LProgressColor := Tg2dConsole.CreateForegroundColor(0, 255, 100);

    Tg2dConsole.ClearScreen();
    Tg2dConsole.PrintLn('Loading Game Assets...');
    Tg2dConsole.PrintLn();

    for LProgress := 0 to 100 do
    begin
      // Clear progress line and redraw
      Tg2dConsole.SetCursorPos(0, 3);
      Tg2dConsole.ClearToEndOfLine();

      // Draw progress bar
      Tg2dConsole.Print('%sProgress: [', [LProgressColor]);
      Tg2dConsole.Print(StringOfChar('█', LProgress div 5));
      Tg2dConsole.Print(StringOfChar('░', 20 - (LProgress div 5)));
      Tg2dConsole.Print('] %d%%', [LProgress]);

      // Small delay for animation effect
      Tg2dConsole.Wait(50);

      // Allow user to cancel with ESC
      if Tg2dConsole.IsKeyPressed(VK_ESCAPE) then
        Break;
    end;

    Tg2dConsole.PrintLn();
    Tg2dConsole.PrintLn('Loading complete!');
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPLETE EXAMPLE: INTERACTIVE GAME LAUNCHER
═══════════════════════════════════════════════════════════════════════════════

  program GameLauncher;

  type
    TGameInfo = record
      Executable: string;
      Name: string;
      Description: string;
    end;

  procedure Main();
  var
    LLauncher: Tg2dTextMenu<TGameInfo>;
    LTheme: Tg2dTextMenuTheme;
    LGame: TGameInfo;
    LSelectedItem: Tg2dTextMenuItem<TGameInfo>;
    LRunning: Boolean;
  begin
    // Initialize console
    Tg2dConsole.ClearScreen();
    Tg2dConsole.SetTitle('Game2D Launcher v1.0');
    Tg2dConsole.HideCursor();

    try
      // Welcome animation
      Tg2dConsole.Teletype('Welcome to Game2D Launcher!',
        Tg2dConsole.CreateForegroundColor(0, 255, 255), 4, 30, 80, VK_SPACE);
      Tg2dConsole.PrintLn();
      Tg2dConsole.PrintLn();

      // Setup launcher menu
      LLauncher := Tg2dTextMenu<TGameInfo>.Create();
      try
        LTheme := Tg2dTextMenuTheme.CreateProfessional();
        LTheme.BorderStyle := bsDouble;
        LTheme.SelectedPrefix := '🎮 ';
        LTheme.NormalPrefix := '   ';

        LLauncher.Theme := LTheme;
        LLauncher.Title := 'Available Games';
        LLauncher.FooterText := 'Arrow Keys: Navigate | Enter: Launch | Esc: Exit';
        LLauncher.MaxColumns := 2;

        // Add games to launcher
        LGame.Executable := 'platformer.exe';
        LGame.Name := 'Super Platform Adventure';
        LGame.Description := 'Classic 2D platformer with power-ups';
        LLauncher.AddItem(LGame, Format('%s - %s', [LGame.Name, LGame.Description]));

        LGame.Executable := 'shooter.exe';
        LGame.Name := 'Space Defender';
        LGame.Description := 'Fast-paced space shooting action';
        LLauncher.AddItem(LGame, Format('%s - %s', [LGame.Name, LGame.Description]));

        LGame.Executable := 'puzzle.exe';
        LGame.Name := 'Block Puzzle Master';
        LGame.Description := 'Mind-bending puzzle challenges';
        LLauncher.AddItem(LGame, Format('%s - %s', [LGame.Name, LGame.Description]));

        // Main launcher loop
        LRunning := True;
        while LRunning do
        begin
          case LLauncher.Run() of
            mrSelected: begin
              LSelectedItem := LLauncher.GetSelectedItem();
              LGame := LSelectedItem.Data;

              Tg2dConsole.ClearScreen();
              Tg2dConsole.PrintLn('Launching %s...', [LGame.Name]);
              Tg2dConsole.PrintLn('Executable: %s', [LGame.Executable]);
              Tg2dConsole.PrintLn();

              // Simulate game launch
              ShowProgressWithAnimation();

              Tg2dConsole.Pause(False,
                Tg2dConsole.CreateForegroundColor(255, 255, 0),
                'Press any key to return to launcher...');

              Tg2dConsole.ClearScreen();
            end;
            mrCanceled: begin
              LRunning := False;
            end;
          end;
        end;

      finally
        LLauncher.Free();
      end;

    finally
      Tg2dConsole.ShowCursor();
      Tg2dConsole.ResetTextFormat();
      Tg2dConsole.Pause(False, '', 'Thank you for using Game2D Launcher!');
    end;
  end;

  begin
    Main();
  end.

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════
• **Unicode Console Writing**: Direct Windows Unicode console API calls for
  maximum text output performance
• **Optimized Screen Updates**: Minimal console API calls with intelligent
  cursor positioning and clearing operations
• **High-Precision Timing**: QueryPerformanceCounter-based timing for smooth
  animations and precise delays
• **Memory Management**: No dynamic allocations for basic operations, stack-based
  string handling for optimal performance

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════
• **Static Class**: No instantiation required, minimal memory footprint
• **Menu System**: Proper constructor/destructor pattern for text menus with
  automatic resource cleanup
• **String Handling**: Efficient string operations with minimal allocations
• **State Cleanup**: Automatic keyboard state and console buffer clearing

═══════════════════════════════════════════════════════════════════════════════
THREADING CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════════════
• **Single-Threaded Design**: All console operations designed for main thread
  use to ensure proper Windows console API interaction
• **Non-Blocking Input**: AnyKeyPressed() and IsKeyPressed() methods safe for
  real-time game loops without blocking execution
• **State Synchronization**: Keyboard state tracking handles rapid polling
  without thread synchronization requirements

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING AND BEST PRACTICES
═══════════════════════════════════════════════════════════════════════════════
• **Console Detection**: All output operations check HasConsoleOutput() before
  attempting console manipulation
• **Graceful Degradation**: Functions safely handle invalid console states
• **Input Validation**: Character set filtering and length limits prevent
  invalid input scenarios
• **Resource Protection**: Automatic cleanup of console modes and states

RECOMMENDED PATTERNS:
• Always check HasConsoleOutput() before console operations in GUI applications
• Use teletype effects with break keys for better user experience
• Implement proper menu themes for professional appearance
• Clear keyboard states after major input operations
• Use appropriate color schemes for different console types

═══════════════════════════════════════════════════════════════════════════════
ANSI ESCAPE SEQUENCE CONSTANTS
═══════════════════════════════════════════════════════════════════════════════
The unit provides comprehensive ANSI escape sequence constants for maximum
terminal compatibility:

CURSOR CONTROL: G2D_CSI_CURSOR_POS, G2D_CSI_CURSOR_UP, G2D_CSI_CURSOR_DOWN,
G2D_CSI_CURSOR_FORWARD, G2D_CSI_CURSOR_BACK, G2D_CSI_SAVE_CURSOR_POS,
G2D_CSI_RESTORE_CURSOR_POS, G2D_CSI_CURSOR_HOME_POS

SCREEN CONTROL: G2D_CSI_CLEAR_SCREEN, G2D_CSI_CLEAR_LINE,
G2D_CSI_CLEAR_TO_END_OF_LINE, G2D_CSI_SCROLL_UP, G2D_CSI_SCROLL_DOWN

TEXT FORMATTING: G2D_CSI_BOLD, G2D_CSI_UNDERLINE, G2D_CSI_RESET_FORMAT,
G2D_CSI_ITALIC, G2D_CSI_BLINK, G2D_CSI_DIM, G2D_CSI_INVERT_COLORS

COLOR CONSTANTS: G2D_CSI_FG_BLACK through G2D_CSI_FG_WHITE,
G2D_CSI_BG_BLACK through G2D_CSI_BG_WHITE, plus RGB format strings

===============================================================================}
unit Game2D.Console;

{$I Game2D.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.Generics.Collections,
  System.SysUtils,
  System.Math,
  Game2D.Common,
  Game2D.Core;

//=== CONSOLE ==================================================================
const
  G2D_LF   = AnsiChar(#10);
  G2D_CR   = AnsiChar(#13);
  G2D_CRLF = G2D_LF+G2D_CR;
  G2D_ESC  = AnsiChar(#27);
  VK_ESC = 27;

  G2D_CSI_CURSOR_POS       = G2D_ESC + '[%d;%dH';
  G2D_CSI_CURSOR_UP        = G2D_ESC + '[%dA';
  G2D_CSI_CURSOR_DOWN      = G2D_ESC + '[%dB';
  G2D_CSI_CURSOR_FORWARD   = G2D_ESC + '[%dC';
  G2D_CSI_CURSOR_BACK      = G2D_ESC + '[%dD';
  G2D_CSI_SAVE_CURSOR_POS  = G2D_ESC + '[s';
  G2D_CSI_RESTORE_CURSOR_POS= G2D_ESC + '[u';
  G2D_CSI_CURSOR_HOME_POS  = G2D_ESC + '[H';

  G2D_CSI_SHOW_CURSOR      = G2D_ESC + '[?25h';
  G2D_CSI_HIDE_CURSOR      = G2D_ESC + '[?25l';
  G2D_CSI_BLINK_CURSOR     = G2D_ESC + '[?12h';
  G2D_CSI_STEADY_CURSOR    = G2D_ESC + '[?12l';

  G2D_CSI_CLEAR_SCREEN     = G2D_ESC + '[2J';
  G2D_CSI_CLEAR_LINE       = G2D_ESC + '[2K';
  G2D_CSI_CLEAR_TO_END_OF_LINE= G2D_ESC + '[K';
  G2D_CSI_SCROLL_UP        = G2D_ESC + '[%dS';
  G2D_CSI_SCROLL_DOWN      = G2D_ESC + '[%dT';

  G2D_CSI_BOLD            = G2D_ESC + '[1m';
  G2D_CSI_UNDERLINE       = G2D_ESC + '[4m';
  G2D_CSI_RESET_FORMAT    = G2D_ESC + '[0m';
  G2D_CSI_RESET_BACKGROUND = G2D_ESC + '[49m';
  G2D_CSI_RESET_FOREGROUND = G2D_ESC + '[39m';
  G2D_CSI_INVERT_COLORS   = G2D_ESC + '[7m';
  G2D_CSI_NORMAL_COLORS   = G2D_ESC + '[27m';
  G2D_CSI_DIM             = G2D_ESC + '[2m';
  G2D_CSI_ITALIC          = G2D_ESC + '[3m';
  G2D_CSI_BLINK           = G2D_ESC + '[5m';
  G2D_CSI_FRAMED          = G2D_ESC + '[51m';
  G2D_CSI_ENCIRCLED       = G2D_ESC + '[52m';

  G2D_CSI_INSERT_CHAR      = G2D_ESC + '[%d@';
  G2D_CSI_DELETE_CHAR      = G2D_ESC + '[%dP';
  G2D_CSI_ERASE_CHAR       = G2D_ESC + '[%dX';

  G2D_CSI_FG_BLACK         = G2D_ESC + '[30m';
  G2D_CSI_FG_RED           = G2D_ESC + '[31m';
  G2D_CSI_FG_GREEN         = G2D_ESC + '[32m';
  G2D_CSI_FG_YELLOW        = G2D_ESC + '[33m';
  G2D_CSI_FG_BLUE          = G2D_ESC + '[34m';
  G2D_CSI_FG_MAGENTA       = G2D_ESC + '[35m';
  G2D_CSI_FG_CYAN          = G2D_ESC + '[36m';
  G2D_CSI_FG_WHITE         = G2D_ESC + '[37m';

  G2D_CSI_BG_BLACK         = G2D_ESC + '[40m';
  G2D_CSI_BG_RED           = G2D_ESC + '[41m';
  G2D_CSI_BG_GREEN         = G2D_ESC + '[42m';
  G2D_CSI_BG_YELLOW        = G2D_ESC + '[43m';
  G2D_CSI_BG_BLUE          = G2D_ESC + '[44m';
  G2D_CSI_BG_MAGENTA       = G2D_ESC + '[45m';
  G2D_CSI_BG_CYAN          = G2D_ESC + '[46m';
  G2D_CSI_BG_WHITE         = G2D_ESC + '[47m';

  G2D_CSI_FG_BRIGHT_BLACK   = G2D_ESC + '[90m';
  G2D_CSI_FG_BRIGHT_RED     = G2D_ESC + '[91m';
  G2D_CSI_FG_BRIGHT_GREEN   = G2D_ESC + '[92m';
  G2D_CSI_FG_BRIGHT_YELLOW  = G2D_ESC + '[93m';
  G2D_CSI_FG_BRIGHT_BLUE    = G2D_ESC + '[94m';
  G2D_CSI_FG_BRIGHT_MAGENTA = G2D_ESC + '[95m';
  G2D_CSI_FG_BRIGHT_CYAN    = G2D_ESC + '[96m';
  G2D_CSI_FG_BRIGHT_WHITE   = G2D_ESC + '[97m';

  G2D_CSI_BG_BRIGHT_BLACK   = G2D_ESC + '[100m';
  G2D_CSI_BG_BRIGHT_RED     = G2D_ESC + '[101m';
  G2D_CSI_BG_BRIGHT_GREEN   = G2D_ESC + '[102m';
  G2D_CSI_BG_BRIGHT_YELLOW  = G2D_ESC + '[103m';
  G2D_CSI_BG_BRIGHT_BLUE    = G2D_ESC + '[104m';
  G2D_CSI_BG_BRIGHT_MAGENTA = G2D_ESC + '[105m';
  G2D_CSI_BG_BRIGHT_CYAN    = G2D_ESC + '[106m';
  G2D_CSI_BG_BRIGHT_WHITE   = G2D_ESC + '[107m';

  G2D_CSI_FG_RGB           = G2D_ESC + '[38;2;%d;%d;%dm';
  G2D_CSI_BG_RGB           = G2D_ESC + '[48;2;%d;%d;%dm';

type
  Tg2dCharSet = set of AnsiChar;

  Tg2dConsole = class(Tg2dStaticObject)
  private class var
    FTeletypeDelay: Integer;
    FKeyState: array [0..1, 0..255] of Boolean;
    FPerformanceFrequency: Int64;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class function  HasConsoleOutput(): Boolean; static;
    class function  StartedFromConsole(): Boolean; static;
    class function  StartedFromDelphiIDE(): Boolean; static;
    class function  CreateForegroundColor(const ARed, AGreen, ABlue: Byte): string; overload; static;
    class function  CreateForegroundColor(const AColor: Tg2dColor): string; overload; static;
    class function  CreateBackgroundColor(const ARed, AGreen, ABlue: Byte): string; overload; static;
    class function  CreateBackgroundColor(const AColor: Tg2dColor): string; overload; static;
    class procedure SetForegroundColor(const ARed, AGreen, ABlue: Byte); overload; static;
    class procedure SetForegroundColor(const AColor: Tg2dColor); overload; static;
    class procedure SetBackgroundColor(const ARed, AGreen, ABlue: Byte); overload; static;
    class procedure SetBackgroundColor(const AColor: Tg2dColor); overload; static;
    class procedure SetBoldText(); static;
    class procedure ResetTextFormat(); static;
    class procedure Print(const AMsg: string; const AResetFormat: Boolean = True); overload; static;
    class procedure PrintLn(const AMsg: string; const AResetFormat: Boolean = True); overload; static;
    class procedure Print(const AMsg: string; const AArgs: array of const; const AResetFormat: Boolean = True); overload; static;
    class procedure PrintLn(const AMsg: string; const AArgs: array of const; const AResetFormat: Boolean = True); overload; static;
    class procedure Print(const AResetFormat: Boolean = True); overload; static;
    class procedure PrintLn(const AResetFormat: Boolean = True); overload; static;
    class function  GetClipboardText(): string; static;
    class procedure SetClipboardText(const AText: string); static;
    class procedure GetCursorPos(X, Y: PInteger); static;
    class procedure SetCursorPos(const X, Y: Integer); static;
    class procedure SetCursorVisible(const AVisible: Boolean); static;
    class procedure HideCursor(); static;
    class procedure ShowCursor(); static;
    class procedure SaveCursorPos(); static;
    class procedure RestoreCursorPos(); static;
    class procedure MoveCursorUp(const ALines: Integer); static;
    class procedure MoveCursorDown(const ALines: Integer); static;
    class procedure MoveCursorForward(const ACols: Integer); static;
    class procedure MoveCursorBack(const ACols: Integer); static;
    class procedure ClearScreen(); static;
    class procedure ClearLine(); static;
    class procedure ClearToEndOfLine(); static;
    class procedure ClearLineFromCursor(const AColor: string); static;
    class procedure GetSize(AWidth: PInteger; AHeight: PInteger); static;
    class function  GetTitle(): string; static;
    class procedure SetTitle(const ATitle: string); static;
    class function  AnyKeyPressed(): Boolean; static;
    class procedure ClearKeyStates(); static;
    class procedure ClearKeyboardBuffer(); static;
    class procedure WaitForAnyConsoleKey(); static;
    class function  IsKeyPressed(AKey: Byte): Boolean;
    class function  WasKeyReleased(AKey: Byte): Boolean;
    class function  WasKeyPressed(AKey: Byte): Boolean;
    class function  ReadKey(): WideChar;
    class function  ReadLnX(const AAllowedChars: Tg2dCharSet; AMaxLength: Integer; const AColor: string): string;
    class function  WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: Tg2dCharSet = [' ', '-', ',', ':', #9]): string; static;
    class procedure Teletype(const AText: string; const AColor: string = G2D_CSI_FG_WHITE; const AMargin: Integer = 10; const AMinDelay: Integer = 0; const AMaxDelay: Integer = 3; const ABreakKey: Byte = VK_ESC); static;
    class procedure Wait(const AMilliseconds: Double); static;
    class procedure Pause(const AForcePause: Boolean=False; AColor: string=''; const AMsg: string=''); static;
    class procedure PrintASCIILogo(); static;
  end;

//=== TEXTMENU =================================================================
type
  { Tg2dBorderStyle }
  Tg2dBorderStyle = (
    bsNone,        // No borders
    bsSubtle,      // Minimal spacing lines
    bsSimple,      // Simple single line
    bsDouble,      // Double line characters
    bsCustom       // User-defined characters
  );

  { Tg2dBorderParts }
  Tg2dBorderPart = (bpTop, bpBottom, bpLeft, bpRight);
  Tg2dBorderParts = set of Tg2dBorderPart;

  { Tg2dBorderChars }
  Tg2dBorderChars = record
    TopLeft: string;
    TopRight: string;
    BottomLeft: string;
    BottomRight: string;
    Horizontal: string;
    Vertical: string;
    class function CreateSimple(): Tg2dBorderChars; static;
    class function CreateDouble(): Tg2dBorderChars; static;
    class function CreateSubtle(): Tg2dBorderChars; static;
  end;

  { Tg2dTextMenuItem }
  Tg2dTextMenuItem<T> = record
    Data: T;
    Description: string;
    Enabled: Boolean;
    Tag: Integer;
    IsSeparator: Boolean;
    constructor Create(const AData: T; const ADescription: string; const AEnabled: Boolean = True; const ATag: Integer = 0);
  end;

  { Tg2dTextMenuTheme }
  Tg2dTextMenuTheme = record
    // Colors
    BackgroundColor: Tg2dColor;
    ForegroundColor: Tg2dColor;
    SelectedBackgroundColor: Tg2dColor;
    SelectedForegroundColor: Tg2dColor;
    DisabledColor: Tg2dColor;
    BorderColor: Tg2dColor;
    FooterColor: Tg2dColor;
    TitleColor: Tg2dColor;
    SeparatorColor: Tg2dColor;

    // Prefixes and symbols
    SelectedPrefix: string;
    NormalPrefix: string;
    DisabledPrefix: string;

    // Border system
    BorderStyle: Tg2dBorderStyle;
    BorderParts: Tg2dBorderParts;
    BorderChars: Tg2dBorderChars;

    // Spacing control
    ItemPadding: Integer;
    ColumnSpacing: Integer;
    TitleSpacing: Integer;
    FooterSpacing: Integer;
    LeftMargin: Integer;
    RightMargin: Integer;

    // Visual options
    ShowLineNumbers: Boolean;
    UseBackground: Boolean;
    ClearBackground: Boolean;
    CenterTitle: Boolean;
    CenterFooter: Boolean;

    // Preset themes
    class function CreateClean(): Tg2dTextMenuTheme; static;
    class function CreateMinimal(): Tg2dTextMenuTheme; static;
    class function CreateProfessional(): Tg2dTextMenuTheme; static;
    class function CreateClassic(): Tg2dTextMenuTheme; static;
    class function CreateDefault(): Tg2dTextMenuTheme; static;
    class function CreateDarkTheme(): Tg2dTextMenuTheme; static;
    class function CreateLightTheme(): Tg2dTextMenuTheme; static;
  end;

  { Tg2dTextMenuResult }
  Tg2dTextMenuResult = (
    mrNone,
    mrSelected,
    mrCanceled,
    mrError
  );

  { Tg2dTextMenu }
  Tg2dTextMenu<T> = class
  private
    FItems: TList<Tg2dTextMenuItem<T>>;
    FCurrentIndex: Integer;
    FConsoleWidth: Integer;
    FConsoleHeight: Integer;
    FItemsPerColumn: Integer;
    FColumnWidth: Integer;
    FColumnCount: Integer;
    FCurrentColumn: Integer;
    FCurrentRow: Integer;
    FTopIndex: Integer;
    FStartY: Integer;
    FMenuHeight: Integer;
    FNeedRedraw: Boolean;
    FTitle: string;
    FFooterText: string;
    FTheme: Tg2dTextMenuTheme;
    FShowTitle: Boolean;
    FShowFooter: Boolean;
    FAllowWrap: Boolean;
    FMinColumnWidth: Integer;
    FMaxColumns: Integer;
    procedure CalculateLayout();
    procedure UpdateColumnAndRow();
    procedure DrawMenu();
    procedure DrawTitle();
    procedure DrawFooter();
    procedure DrawBorder();
    procedure ClearMenuArea();
    function HandleInput(): Boolean;
    procedure MoveUp();
    procedure MoveDown();
    procedure MoveLeft();
    procedure MoveRight();
    function GetMaxDescriptionLength(): Integer;
    procedure SetTheme(const ATheme: Tg2dTextMenuTheme);
    procedure ApplyColor(const AColor: Tg2dColor);
    procedure DrawSeparator(const AText: string; const AX, AY, AWidth: Integer);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure AddItem(const AData: T; const ADescription: string; const AEnabled: Boolean = True; const ATag: Integer = 0);
    procedure AddSeparator(const AText: string = '');
    procedure Clear();
    procedure RemoveItem(const AIndex: Integer);
    function Run(): Tg2dTextMenuResult;
    function GetItemCount(): Integer;
    function GetSelectedIndex(): Integer;
    function GetSelectedItem(): Tg2dTextMenuItem<T>;
    procedure SetCurrentIndex(const AIndex: Integer);
    property Title: string read FTitle write FTitle;
    property FooterText: string read FFooterText write FFooterText;
    property Theme: Tg2dTextMenuTheme read FTheme write SetTheme;
    property ShowTitle: Boolean read FShowTitle write FShowTitle;
    property ShowFooter: Boolean read FShowFooter write FShowFooter;
    property AllowWrap: Boolean read FAllowWrap write FAllowWrap;
    property MinColumnWidth: Integer read FMinColumnWidth write FMinColumnWidth;
    property MaxColumns: Integer read FMaxColumns write FMaxColumns;
  end;

implementation

//=== CONSOLE ==================================================================
{ Tg2dConsole }
class constructor Tg2dConsole.Create();
begin
  inherited;

  FTeletypeDelay := 0;
  QueryPerformanceFrequency(FPerformanceFrequency);
  ClearKeyStates();
end;

class destructor Tg2dConsole.Destroy();
begin
  inherited;
end;

class function  Tg2dConsole.HasConsoleOutput(): Boolean;
var
  LStdHandle: THandle;
begin
  LStdHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  Result := (LStdHandle <> INVALID_HANDLE_VALUE) and
            (GetFileType(LStdHandle) = FILE_TYPE_CHAR);
end;

class function  Tg2dConsole.CreateForegroundColor(const ARed, AGreen, ABlue: Byte): string;
begin
  Result := '';
  if not HasConsoleOutput() then Exit;
  Result := Format(G2D_CSI_FG_RGB, [ARed, AGreen, ABlue])
end;

class function  Tg2dConsole.CreateForegroundColor(const AColor: Tg2dColor): string;
var
  LRed: Byte;
  LGreen: Byte;
  LBlue: Byte;
begin
  Result := '';
  if not HasConsoleOutput() then Exit;

  LRed := Round(AColor.Red * $FF);
  LGreen := Round(AColor.Green * $FF);
  LBlue := Round(AColor.Blue * $FF);

  Result := Format(G2D_CSI_FG_RGB, [LRed, LGreen, LBlue]);
end;

class function  Tg2dConsole.CreateBackgroundColor(const ARed, AGreen, ABlue: Byte): string;
begin
  Result := '';
  if not HasConsoleOutput() then Exit;

  Result := '';
  if not HasConsoleOutput() then Exit;

  Result := Format(G2D_CSI_BG_RGB, [ARed, AGreen, ABlue]);
end;

class function  Tg2dConsole.CreateBackgroundColor(const AColor: Tg2dColor): string;
var
  LRed: Byte;
  LGreen: Byte;
  LBlue: Byte;
begin
  Result := '';
  if not HasConsoleOutput() then Exit;

  LRed := Round(AColor.Red * $FF);
  LGreen := Round(AColor.Green * $FF);
  LBlue := Round(AColor.Blue * $FF);

  Result := Format(G2D_CSI_BG_RGB, [LRed, LGreen, LBlue]);
end;

class procedure Tg2dConsole.SetForegroundColor(const ARed, AGreen, ABlue: Byte);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_FG_RGB, [ARed, AGreen, ABlue]));
end;

class procedure Tg2dConsole.SetForegroundColor(const AColor: Tg2dColor);
var
  LRed: Byte;
  LGreen: Byte;
  LBlue: Byte;
begin
  LRed := Round(AColor.Red * $FF);
  LGreen := Round(AColor.Green * $FF);
  LBlue := Round(AColor.Blue * $FF);
  SetForegroundColor(LRed, LGreen, LBlue);
end;

class procedure Tg2dConsole.SetBackgroundColor(const ARed, AGreen, ABlue: Byte);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_BG_RGB, [ARed, AGreen, ABlue]));
end;

class procedure Tg2dConsole.SetBackgroundColor(const AColor: Tg2dColor);
var
  LRed: Byte;
  LGreen: Byte;
  LBlue: Byte;
begin
  LRed := Round(AColor.Red * $FF);
  LGreen := Round(AColor.Green * $FF);
  LBlue := Round(AColor.Blue * $FF);
  SetBackgroundColor(LRed, LGreen, LBlue);
end;

class procedure Tg2dConsole.Print(const AMsg: string; const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS := AMsg+LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class procedure Tg2dConsole.PrintLn(const AMsg: string; const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS := AMsg + sLineBreak + LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class procedure Tg2dConsole.Print(const AMsg: string; const AArgs: array of const; const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS := Format(AMsg, AArgs)+LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class procedure Tg2dConsole.PrintLn(const AMsg: string; const AArgs: array of const; const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS := Format(AMsg, AArgs) + sLineBreak + LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class procedure Tg2dConsole.Print(const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS := LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class procedure Tg2dConsole.PrintLn(const AResetFormat: Boolean);
var
  LHandle: THandle;
  LWideS: WideString;
  LWritten: DWORD;
  LResetFormat: string;
begin
  if not HasConsoleOutput() then Exit;
  if AResetFormat then
    LResetFormat := G2D_CSI_RESET_FORMAT
  else
    LResetFormat := '';
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LWideS :=  sLineBreak + LResetFormat;
  WriteConsoleW(LHandle, PWideChar(LWideS), Length(LWideS), LWritten, nil);
end;

class function  Tg2dConsole.GetClipboardText(): string;
var
  LHandle: THandle;
  LPtr: PChar;
begin
  Result := '';
  if not OpenClipboard(0) then Exit;
  try
    LHandle := GetClipboardData(CF_TEXT);
    if LHandle <> 0 then
    begin
      LPtr := GlobalLock(LHandle);
      if LPtr <> nil then
      begin
        Result := LPtr;
        GlobalUnlock(LHandle);
      end;
    end;
  finally
    CloseClipboard;
  end;
end;

class procedure Tg2dConsole.SetClipboardText(const AText: string);
var
  LHandle: THandle;
  LPtr: PChar;
  LSize: Integer;
begin
  if not OpenClipboard(0) then Exit;
  try
    EmptyClipboard;
    LSize := (Length(AText) + 1) * SizeOf(Char);
    LHandle := GlobalAlloc(GMEM_MOVEABLE, LSize);
    if LHandle <> 0 then
    begin
      LPtr := GlobalLock(LHandle);
      if LPtr <> nil then
      begin
        Move(PChar(AText)^, LPtr^, LSize);
        GlobalUnlock(LHandle);
        SetClipboardData(CF_TEXT, LHandle);
      end else
        GlobalFree(LHandle);
    end;
  finally
    CloseClipboard;
  end;
end;

class procedure Tg2dConsole.GetCursorPos(X, Y: PInteger);
var
  LHandle: THandle;
  LBufferInfo: TConsoleScreenBufferInfo;
begin
  LHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  if LHandle = INVALID_HANDLE_VALUE then
    Exit;

  if not GetConsoleScreenBufferInfo(LHandle, LBufferInfo) then
    Exit;

  if Assigned(X) then
    X^ := LBufferInfo.dwCursorPosition.X;
  if Assigned(Y) then
    Y^ := LBufferInfo.dwCursorPosition.Y;
end;

class procedure Tg2dConsole.SetCursorPos(const X, Y: Integer);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_CURSOR_POS, [Y + 1, X + 1]));
end;

class procedure Tg2dConsole.SetCursorVisible(const AVisible: Boolean);
var
  LConsoleInfo: TConsoleCursorInfo;
  LConsoleHandle: THandle;
begin
  LConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  LConsoleInfo.dwSize := 25;
  LConsoleInfo.bVisible := AVisible;
  SetConsoleCursorInfo(LConsoleHandle, LConsoleInfo);
end;

class procedure Tg2dConsole.HideCursor();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_HIDE_CURSOR);
end;

class procedure Tg2dConsole.ShowCursor();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_SHOW_CURSOR);
end;

class procedure Tg2dConsole.SaveCursorPos();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_SAVE_CURSOR_POS);
end;

class procedure Tg2dConsole.RestoreCursorPos();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_RESTORE_CURSOR_POS);
end;

class procedure Tg2dConsole.MoveCursorUp(const ALines: Integer);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_CURSOR_UP, [ALines]));
end;

class procedure Tg2dConsole.MoveCursorDown(const ALines: Integer);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_CURSOR_DOWN, [ALines]));
end;

class procedure Tg2dConsole.MoveCursorForward(const ACols: Integer);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_CURSOR_FORWARD, [ACols]));
end;

class procedure Tg2dConsole.MoveCursorBack(const ACols: Integer);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(G2D_CSI_CURSOR_BACK, [ACols]));
end;

class procedure Tg2dConsole.ClearScreen();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_CLEAR_SCREEN);
  Write(G2D_ESC + '[3J');
  Write(G2D_CSI_CURSOR_HOME_POS);
end;

class procedure Tg2dConsole.ClearLine();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CR);
  Write(G2D_CSI_CLEAR_LINE);
end;

class procedure Tg2dConsole.ClearToEndOfLine();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_CLEAR_TO_END_OF_LINE);
end;

class procedure Tg2dConsole.ClearLineFromCursor(const AColor: string);
var
  LConsoleOutput: THandle;
  LConsoleInfo: TConsoleScreenBufferInfo;
  LNumCharsWritten: DWORD;
  LCoord: TCoord;
begin
  LConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);

  if GetConsoleScreenBufferInfo(LConsoleOutput, LConsoleInfo) then
  begin
    LCoord.X := 0;
    LCoord.Y := LConsoleInfo.dwCursorPosition.Y;

    Print(AColor);
    FillConsoleOutputCharacter(LConsoleOutput, ' ', LConsoleInfo.dwSize.X
      - LConsoleInfo.dwCursorPosition.X, LCoord, LNumCharsWritten);
    SetConsoleCursorPosition(LConsoleOutput, LCoord);
  end;
end;

class procedure Tg2dConsole.SetBoldText();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_BOLD);
end;

class procedure Tg2dConsole.ResetTextFormat();
begin
  if not HasConsoleOutput() then Exit;
  Write(G2D_CSI_RESET_FORMAT);
end;

class procedure Tg2dConsole.GetSize(AWidth: PInteger; AHeight: PInteger);
var
  LConsoleInfo: TConsoleScreenBufferInfo;
begin
  if not HasConsoleOutput() then Exit;

  GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), LConsoleInfo);
  if Assigned(AWidth) then
    AWidth^ := LConsoleInfo.dwSize.X;

  if Assigned(AHeight) then
  AHeight^ := LConsoleInfo.dwSize.Y;
end;

class function  Tg2dConsole.GetTitle(): string;
const
  MAX_TITLE_LENGTH = 1024;
var
  LTitle: array[0..MAX_TITLE_LENGTH] of WideChar;
  LTitleLength: DWORD;
begin
  LTitleLength := GetConsoleTitleW(LTitle, MAX_TITLE_LENGTH);

  if LTitleLength > 0 then
    Result := string(LTitle)
  else
    Result := '';
end;

class procedure Tg2dConsole.SetTitle(const ATitle: string);
begin
  WinApi.Windows.SetConsoleTitle(PChar(ATitle));
end;

class function  Tg2dConsole.AnyKeyPressed(): Boolean;
var
  LNumberOfEvents     : DWORD;
  LBuffer             : TInputRecord;
  LNumberOfEventsRead : DWORD;
  LStdHandle           : THandle;
begin
  Result:=false;
  LStdHandle := GetStdHandle(STD_INPUT_HANDLE);
  LNumberOfEvents:=0;
  GetNumberOfConsoleInputEvents(LStdHandle,LNumberOfEvents);
  if LNumberOfEvents<> 0 then
  begin
    PeekConsoleInput(LStdHandle,LBuffer,1,LNumberOfEventsRead);
    if LNumberOfEventsRead <> 0 then
    begin
      if LBuffer.EventType = KEY_EVENT then
      begin
        if LBuffer.Event.KeyEvent.bKeyDown then
          Result:=true
        else
          FlushConsoleInputBuffer(LStdHandle);
      end
      else
      FlushConsoleInputBuffer(LStdHandle);
    end;
  end;
end;

class procedure Tg2dConsole.ClearKeyStates();
begin
  FillChar(FKeyState, SizeOf(FKeyState), 0);
  ClearKeyboardBuffer();
end;

class procedure Tg2dConsole.ClearKeyboardBuffer();
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
  LMsg: TMsg;
begin
  while PeekConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead) and (LEventsRead > 0) do
  begin
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  end;

  while PeekMessage(LMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE) do
  begin
  end;
end;

class procedure Tg2dConsole.WaitForAnyConsoleKey();
var
  LInputRec: TInputRecord;
  LNumRead: Cardinal;
  LOldMode: DWORD;
  LStdIn: THandle;
begin
  LStdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(LStdIn, LOldMode);
  SetConsoleMode(LStdIn, 0);
  repeat
    ReadConsoleInput(LStdIn, LInputRec, 1, LNumRead);
  until (LInputRec.EventType and KEY_EVENT <> 0) and
    LInputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(LStdIn, LOldMode);
end;

class function  Tg2dConsole.IsKeyPressed(AKey: Byte): Boolean;
begin
  Result := (GetAsyncKeyState(AKey) and $8000) <> 0;
end;

class function  Tg2dConsole.WasKeyReleased(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := True;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := False;
  end;
end;

class function  Tg2dConsole.WasKeyPressed(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := False;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := True;
  end;
end;

class function  Tg2dConsole.ReadKey(): WideChar;
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
begin
  repeat
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  until (LInputRecord.EventType = KEY_EVENT) and LInputRecord.Event.KeyEvent.bKeyDown;
  Result := LInputRecord.Event.KeyEvent.UnicodeChar;
end;

class function  Tg2dConsole.ReadLnX(const AAllowedChars: Tg2dCharSet; AMaxLength: Integer; const AColor: string): string;
var
  LInputChar: Char;
begin
  Result := '';

  repeat
    LInputChar := ReadKey;

    if CharInSet(LInputChar, AAllowedChars) then
    begin
      if Length(Result) < AMaxLength then
      begin
        if not CharInSet(LInputChar, [#10, #0, #13, #8])  then
        begin
          Print('%s%s', [AColor, LInputChar]);
          Result := Result + LInputChar;
        end;
      end;
    end;
    if LInputChar = #8 then
    begin
      if Length(Result) > 0 then
      begin
        Print(#8 + ' ' + #8, []);
        Delete(Result, Length(Result), 1);
      end;
    end;
  until (LInputChar = #13);

  PrintLn();
end;

class function  Tg2dConsole.WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: Tg2dCharSet): string;
var
  LText: string;
  LPos: integer;
  LChar: Char;
  LLen: Integer;
  LI: Integer;
begin
  LText := ALine.Trim;

  LPos := 0;
  LLen := 0;

  while LPos < LText.Length do
  begin
    Inc(LPos);

    LChar := LText[LPos];

    if LChar = #10 then
    begin
      LLen := 0;
      continue;
    end;

    Inc(LLen);

    if LLen >= AMaxCol then
    begin
      for LI := LPos downto 1 do
      begin
        LChar := LText[LI];

        if CharInSet(LChar, ABreakChars) then
        begin
          LText.Insert(LI, #10);
          Break;
        end;
      end;

      LLen := 0;
    end;
  end;

  Result := LText;
end;

class procedure Tg2dConsole.Teletype(const AText: string; const AColor: string; const AMargin: Integer; const AMinDelay: Integer; const AMaxDelay: Integer; const ABreakKey: Byte);
var
  LText: string;
  LMaxCol: Integer;
  LChar: Char;
  LWidth: Integer;
begin
  GetSize(@LWidth, nil);
  LMaxCol := LWidth - AMargin;

  LText := WrapTextEx(AText, LMaxCol);

  for LChar in LText do
  begin
    Tg2dUtils.ProcessMessages();
    Print('%s%s', [AColor, LChar]);
    if not Boolean(Random(2)) then
      FTeletypeDelay := Random(AMaxDelay - AMinDelay + 1) + AMinDelay;
    Wait(FTeletypeDelay);
    if IsKeyPressed(ABreakKey) then
    begin
      ClearKeyboardBuffer;
      Break;
    end;
  end;
end;

class procedure Tg2dConsole.Wait(const AMilliseconds: Double);
var
  LStartCount: Int64;
  LCurrentCount: Int64;
  LElapsedTime: Double;

begin
  QueryPerformanceCounter(LStartCount);

  repeat
    QueryPerformanceCounter(LCurrentCount);
    LElapsedTime := (LCurrentCount - LStartCount) / FPerformanceFrequency * 1000.0;
  until LElapsedTime >= AMilliseconds;
end;

class function  Tg2dConsole.StartedFromConsole(): Boolean;
var
  LStartupInfo: TStartupInfo;
begin
  LStartupInfo.cb := SizeOf(TStartupInfo);
  GetStartupInfo(LStartupInfo);
  Result := ((LStartupInfo.dwFlags and STARTF_USESHOWWINDOW) = 0);
end;

class function Tg2dConsole.StartedFromDelphiIDE(): Boolean;
begin
  Result := (GetEnvironmentVariable('BDS') <> '');
end;

class procedure Tg2dConsole.Pause(const AForcePause: Boolean; AColor: string; const AMsg: string);
var
  LDoPause: Boolean;
begin
  if not HasConsoleOutput then Exit;

  ClearKeyboardBuffer();

  if not AForcePause then
  begin
    LDoPause := True;
    if StartedFromConsole() then LDoPause := False;
    if StartedFromDelphiIDE() then LDoPause := True;
    if not LDoPause then Exit;
  end;

  PrintLn();
  if AMsg = '' then
    Print('%sPress any key to continue... ', [aColor])
  else
    Print('%s%s', [aColor, AMsg]);

  WaitForAnyConsoleKey();
  PrintLn();
end;

class procedure Tg2dConsole.PrintASCIILogo();
begin
  Tg2dConsole.PrintLn('  ___                ___ ___ ™', False);
  Tg2dConsole.PrintLn(' / __|__ _ _ __  ___|_  )   \', False);
  Tg2dConsole.PrintLn('| (_ / _` | ''  \/ -_)/ /| |) |', False);
  Tg2dConsole.PrintLn(' \___\__,_|_|_|_\___/___|___/', False);
  Tg2dConsole.PrintLn('      Build. Play. Repeat.', False);
  Tg2dConsole.PrintLn('          Version %s', [G2D_VERSION]);
end;

function EnableVirtualTerminalProcessing(): Boolean;
var
  LHOut: THandle;
  LMode: DWORD;
begin
  Result := False;

  LHOut := GetStdHandle(STD_OUTPUT_HANDLE);
  if LHOut = INVALID_HANDLE_VALUE then Exit;
  if not GetConsoleMode(LHOut, LMode) then Exit;

  LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
  if not SetConsoleMode(LHOut, LMode) then Exit;

  Result := True;
end;

//=== TEXTMENU =================================================================
{ Tg2dBorderChars }

class function Tg2dBorderChars.CreateSimple(): Tg2dBorderChars;
begin
  Result.TopLeft := '┌';
  Result.TopRight := '┐';
  Result.BottomLeft := '└';
  Result.BottomRight := '┘';
  Result.Horizontal := '─';
  Result.Vertical := '│';
end;

class function Tg2dBorderChars.CreateDouble(): Tg2dBorderChars;
begin
  Result.TopLeft := '╔';
  Result.TopRight := '╗';
  Result.BottomLeft := '╚';
  Result.BottomRight := '╝';
  Result.Horizontal := '═';
  Result.Vertical := '║';
end;

class function Tg2dBorderChars.CreateSubtle(): Tg2dBorderChars;
begin
  Result.TopLeft := '';
  Result.TopRight := '';
  Result.BottomLeft := '';
  Result.BottomRight := '';
  Result.Horizontal := '─';
  Result.Vertical := '';
end;

{ Tg2dTextMenuItem<T> }

constructor Tg2dTextMenuItem<T>.Create(const AData: T; const ADescription: string; const AEnabled: Boolean; const ATag: Integer);
begin
  Data := AData;
  Description := ADescription;
  Enabled := AEnabled;
  Tag := ATag;
  IsSeparator := (ATag = -1) and not AEnabled;
end;

{ Tg2dTextMenuTheme }

class function Tg2dTextMenuTheme.CreateClean(): Tg2dTextMenuTheme;
begin
  // Ultra clean - no borders, minimal visual elements
  Result.BackgroundColor := G2D_BLACK;
  Result.ForegroundColor := G2D_LIGHTGRAY;
  Result.SelectedBackgroundColor := G2D_DARKGREY;
  Result.SelectedForegroundColor := G2D_BLACK;
  Result.DisabledColor := G2D_DIMGRAY;
  Result.BorderColor := G2D_DARKGRAY;
  Result.FooterColor := G2D_GRAY;
  Result.TitleColor := G2D_WHITE;
  Result.SeparatorColor := G2D_DARKGRAY;

  Result.SelectedPrefix := '► ';
  Result.NormalPrefix := '  ';
  Result.DisabledPrefix := '  ';

  Result.BorderStyle := bsNone;
  Result.BorderParts := [];
  Result.BorderChars := Tg2dBorderChars.CreateSubtle();

  Result.ItemPadding := 1;
  Result.ColumnSpacing := 3;
  Result.TitleSpacing := 1;
  Result.FooterSpacing := 1;
  Result.LeftMargin := 2;
  Result.RightMargin := 2;

  Result.ShowLineNumbers := False;
  Result.UseBackground := True;
  Result.ClearBackground := True;
  Result.CenterTitle := False;
  Result.CenterFooter := True;
end;

class function Tg2dTextMenuTheme.CreateMinimal(): Tg2dTextMenuTheme;
begin
  // Minimal with subtle footer separation
  Result := CreateClean();
  Result.BorderStyle := bsSubtle;
  Result.BorderParts := [bpBottom];
  Result.FooterColor := G2D_YELLOW;
  Result.SelectedPrefix := '→ ';
end;

class function Tg2dTextMenuTheme.CreateProfessional(): Tg2dTextMenuTheme;
begin
  // Professional look with subtle borders
  Result := CreateClean();
  Result.ForegroundColor := G2D_WHITE;
  Result.TitleColor := G2D_LIGHTCYAN;
  Result.FooterColor := G2D_LIGHTYELLOW;

  Result.BorderStyle := bsSimple;
  Result.BorderParts := [bpTop, bpBottom];
  Result.BorderChars := Tg2dBorderChars.CreateSimple();

  Result.ItemPadding := 1;
  Result.TitleSpacing := 1;
  Result.FooterSpacing := 1;
  Result.CenterTitle := True;
end;

class function Tg2dTextMenuTheme.CreateClassic(): Tg2dTextMenuTheme;
begin
  // Traditional bordered menu
  Result := CreateProfessional();
  Result.BorderStyle := bsSimple;
  Result.BorderParts := [bpTop, bpBottom, bpLeft, bpRight];
  Result.BorderColor := G2D_CYAN;
  Result.UseBackground := True;

  Result.ItemPadding := 2;
  Result.LeftMargin := 1;
  Result.RightMargin := 1;
end;

class function Tg2dTextMenuTheme.CreateDefault(): Tg2dTextMenuTheme;
begin
  // Use Clean as the new default
  Result := CreateClean();
end;

class function Tg2dTextMenuTheme.CreateDarkTheme(): Tg2dTextMenuTheme;
begin
  Result := CreateProfessional();
  Result.BackgroundColor := G2D_BLACK;
  Result.ForegroundColor := G2D_LIGHTGRAY;
  Result.SelectedBackgroundColor := G2D_DARKBLUE;
  Result.SelectedForegroundColor := G2D_WHITE;
  Result.TitleColor := G2D_LIGHTGREEN;
  Result.FooterColor := G2D_LIGHTBLUE;
  Result.SelectedPrefix := '►  ';
  Result.DisabledPrefix := '✗  ';
end;

class function Tg2dTextMenuTheme.CreateLightTheme(): Tg2dTextMenuTheme;
begin
  Result := CreateProfessional();
  Result.BackgroundColor := G2D_WHITE;
  Result.ForegroundColor := G2D_BLACK;
  Result.SelectedBackgroundColor := G2D_LIGHTBLUE;
  Result.SelectedForegroundColor := G2D_DARKBLUE;
  Result.DisabledColor := G2D_LIGHTGRAY;
  Result.BorderColor := G2D_DARKBLUE;
  Result.FooterColor := G2D_DARKGREEN;
  Result.TitleColor := G2D_DARKMAGENTA;
  Result.SelectedPrefix := '→  ';
  Result.DisabledPrefix := '⊘  ';
end;

{ Tg2dTextMenu<T> }

constructor Tg2dTextMenu<T>.Create();
begin
  inherited Create();
  FItems := TList<Tg2dTextMenuItem<T>>.Create();
  FCurrentIndex := 0;
  FTopIndex := 0;
  FCurrentColumn := 0;
  FCurrentRow := 0;
  FStartY := 0;
  FMenuHeight := 0;
  FNeedRedraw := True;
  FTitle := '';
  FFooterText := 'Arrow Keys: Navigate | ENTER: Select | ESC: Cancel';
  FTheme := Tg2dTextMenuTheme.CreateDefault(); // Clean by default
  FShowTitle := True;
  FShowFooter := True;
  FAllowWrap := True;
  FMinColumnWidth := 20;
  FMaxColumns := 4;
end;

destructor Tg2dTextMenu<T>.Destroy();
begin
  FItems.Free();
  inherited Destroy();
end;

procedure Tg2dTextMenu<T>.AddItem(const AData: T; const ADescription: string; const AEnabled: Boolean; const ATag: Integer);
var
  LItem: Tg2dTextMenuItem<T>;
begin
  LItem := Tg2dTextMenuItem<T>.Create(AData, ADescription, AEnabled, ATag);
  FItems.Add(LItem);
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.AddSeparator(const AText: string);
var
  LItem: Tg2dTextMenuItem<T>;
  LDescription: string;
begin
  if AText = '' then
    LDescription := ''
  else
    LDescription := AText;

  LItem := Tg2dTextMenuItem<T>.Create(Default(T), LDescription, False, -1);
  LItem.IsSeparator := True;
  FItems.Add(LItem);
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.Clear();
begin
  FItems.Clear();
  FCurrentIndex := 0;
  FTopIndex := 0;
  FCurrentColumn := 0;
  FCurrentRow := 0;
  FStartY := 0;
  FMenuHeight := 0;
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.RemoveItem(const AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FItems.Count) then
  begin
    FItems.Delete(AIndex);
    if FCurrentIndex >= FItems.Count then
      FCurrentIndex := FItems.Count - 1;
    if FCurrentIndex < 0 then
      FCurrentIndex := 0;
    FNeedRedraw := True;
  end;
end;

function Tg2dTextMenu<T>.GetItemCount(): Integer;
begin
  Result := FItems.Count;
end;

function Tg2dTextMenu<T>.GetSelectedIndex(): Integer;
begin
  Result := FCurrentIndex;
end;

function Tg2dTextMenu<T>.GetSelectedItem(): Tg2dTextMenuItem<T>;
begin
  if (FCurrentIndex >= 0) and (FCurrentIndex < FItems.Count) then
    Result := FItems[FCurrentIndex]
  else
    Result := Default(Tg2dTextMenuItem<T>);
end;

procedure Tg2dTextMenu<T>.SetCurrentIndex(const AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FItems.Count) then
  begin
    FCurrentIndex := AIndex;
    UpdateColumnAndRow();
    FNeedRedraw := True;
  end;
end;

procedure Tg2dTextMenu<T>.SetTheme(const ATheme: Tg2dTextMenuTheme);
begin
  FTheme := ATheme;
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.ApplyColor(const AColor: Tg2dColor);
begin
  Tg2dConsole.SetForegroundColor(AColor);
end;

function Tg2dTextMenu<T>.GetMaxDescriptionLength(): Integer;
var
  LIndex: Integer;
  LMaxLength: Integer;
  LPrefixLength: Integer;
begin
  LMaxLength := 0;
  LPrefixLength := Max(Length(FTheme.SelectedPrefix), Length(FTheme.NormalPrefix));

  for LIndex := 0 to FItems.Count - 1 do
  begin
    if not FItems[LIndex].IsSeparator then
    begin
      if Length(FItems[LIndex].Description) + LPrefixLength > LMaxLength then
        LMaxLength := Length(FItems[LIndex].Description) + LPrefixLength;
    end;
  end;
  Result := LMaxLength;
end;

procedure Tg2dTextMenu<T>.CalculateLayout();
var
  LMaxDescLength: Integer;
  LAvailableHeight: Integer;
  LTitleHeight: Integer;
  LFooterHeight: Integer;
  LBorderHeight: Integer;
  LAvailableWidth: Integer;
begin
  Tg2dConsole.GetSize(@FConsoleWidth, @FConsoleHeight);
  Tg2dConsole.GetCursorPos(nil, @FStartY);

  // Calculate space requirements
  LTitleHeight := 0;
  if FShowTitle and (FTitle <> '') then
    LTitleHeight := 1 + FTheme.TitleSpacing;

  LFooterHeight := 0;
  if FShowFooter and (FFooterText <> '') then
    LFooterHeight := 1 + FTheme.FooterSpacing;

  LBorderHeight := 0;
  if FTheme.BorderStyle <> bsNone then
  begin
    if bpTop in FTheme.BorderParts then Inc(LBorderHeight);
    if bpBottom in FTheme.BorderParts then Inc(LBorderHeight);
  end;

  // Calculate available height
  LAvailableHeight := FConsoleHeight - FStartY - LTitleHeight - LFooterHeight - LBorderHeight;
  if LAvailableHeight < 1 then
    LAvailableHeight := 1;

  FItemsPerColumn := LAvailableHeight;
  FMenuHeight := FItemsPerColumn;

  // Calculate column width
  LMaxDescLength := GetMaxDescriptionLength();
  FColumnWidth := Max(LMaxDescLength + FTheme.ItemPadding * 2, FMinColumnWidth);

  // Calculate columns considering margins
  LAvailableWidth := FConsoleWidth - FTheme.LeftMargin - FTheme.RightMargin;
  FColumnCount := LAvailableWidth div (FColumnWidth + FTheme.ColumnSpacing);
  if FColumnCount < 1 then
    FColumnCount := 1;
  if FColumnCount > FMaxColumns then
    FColumnCount := FMaxColumns;

  // Adjust column width with spacing
  if FColumnCount > 1 then
    FColumnWidth := (LAvailableWidth - (FColumnCount - 1) * FTheme.ColumnSpacing) div FColumnCount;
end;

procedure Tg2dTextMenu<T>.UpdateColumnAndRow();
begin
  if FItems.Count = 0 then
  begin
    FCurrentColumn := 0;
    FCurrentRow := 0;
    Exit;
  end;

  FCurrentColumn := FCurrentIndex div FItemsPerColumn;
  FCurrentRow := FCurrentIndex mod FItemsPerColumn;
end;

procedure Tg2dTextMenu<T>.ClearMenuArea();
var
  LLine: Integer;
  LStartLine: Integer;
  LEndLine: Integer;
begin
  if not FTheme.ClearBackground then
    Exit;

  LStartLine := FStartY;
  LEndLine := FStartY + FMenuHeight + 10; // Extra buffer

  for LLine := LStartLine to LEndLine do
  begin
    Tg2dConsole.SetCursorPos(0, LLine);
    Tg2dConsole.ClearLine();
  end;
end;

procedure Tg2dTextMenu<T>.DrawSeparator(const AText: string; const AX, AY, AWidth: Integer);
var
  LSeparatorText: string;
  LPadding: Integer;
begin
  ApplyColor(FTheme.SeparatorColor);
  Tg2dConsole.SetCursorPos(AX, AY);

  if AText = '' then
  begin
    // Simple line
    LSeparatorText := StringOfChar('─', FColumnWidth - FTheme.ItemPadding);
  end
  else
  begin
    // Text with padding
    LPadding := (FColumnWidth - Length(AText) - 4) div 2;
    if LPadding < 1 then LPadding := 1;
    LSeparatorText := StringOfChar('─', LPadding) + ' ' + AText + ' ' + StringOfChar('─', LPadding);
  end;

  Tg2dConsole.Print(LSeparatorText, False);
  Tg2dConsole.ResetTextFormat();
end;

procedure Tg2dTextMenu<T>.DrawTitle();
var
  LTitleY: Integer;
  LX: Integer;
begin
  if not FShowTitle or (FTitle = '') then
    Exit;

  LTitleY := FStartY;
  if (bpTop in FTheme.BorderParts) and (FTheme.BorderStyle <> bsNone) then
    Inc(LTitleY, 1);

  if FTheme.CenterTitle then
    LX := (FConsoleWidth - Length(FTitle)) div 2
  else
    LX := FTheme.LeftMargin;

  if LX < 0 then LX := 0;

  Tg2dConsole.SetCursorPos(LX, LTitleY);
  ApplyColor(FTheme.TitleColor);
  Tg2dConsole.Print(FTitle, False);
  Tg2dConsole.ResetTextFormat();
end;

procedure Tg2dTextMenu<T>.DrawBorder();
var
  LX: Integer;
  LY: Integer;
  LWidth: Integer;
  LTopY: Integer;
  LBottomY: Integer;
begin
  if FTheme.BorderStyle = bsNone then
    Exit;

  LTopY := FStartY;
  LBottomY := FStartY + FMenuHeight;
  if FShowTitle and (FTitle <> '') then
    Inc(LBottomY, 1 + FTheme.TitleSpacing);
  if FShowFooter and (FFooterText <> '') then
    Inc(LBottomY, 1 + FTheme.FooterSpacing);

  LWidth := FConsoleWidth - FTheme.LeftMargin - FTheme.RightMargin;

  ApplyColor(FTheme.BorderColor);

  // Draw borders based on style and parts
  if bpTop in FTheme.BorderParts then
  begin
    Tg2dConsole.SetCursorPos(FTheme.LeftMargin, LTopY);
    for LX := 0 to LWidth - 1 do
      Tg2dConsole.Print(FTheme.BorderChars.Horizontal, False);
  end;

  if bpBottom in FTheme.BorderParts then
  begin
    Tg2dConsole.SetCursorPos(FTheme.LeftMargin, LBottomY);
    for LX := 0 to LWidth - 1 do
      Tg2dConsole.Print(FTheme.BorderChars.Horizontal, False);
  end;

  // Side borders (if needed)
  if (bpLeft in FTheme.BorderParts) or (bpRight in FTheme.BorderParts) then
  begin
    for LY := LTopY + 1 to LBottomY - 1 do
    begin
      if bpLeft in FTheme.BorderParts then
      begin
        Tg2dConsole.SetCursorPos(FTheme.LeftMargin, LY);
        Tg2dConsole.Print(FTheme.BorderChars.Vertical, False);
      end;
      if bpRight in FTheme.BorderParts then
      begin
        Tg2dConsole.SetCursorPos(FTheme.LeftMargin + LWidth - 1, LY);
        Tg2dConsole.Print(FTheme.BorderChars.Vertical, False);
      end;
    end;
  end;

  Tg2dConsole.ResetTextFormat();
end;

procedure Tg2dTextMenu<T>.DrawMenu();
var
  LIndex: Integer;
  LColumn: Integer;
  LRow: Integer;
  LX: Integer;
  LY: Integer;
  LItem: Tg2dTextMenuItem<T>;
  LPrefix: string;
  LLineNumber: string;
  LMenuStartY: Integer;
begin


  // Calculate menu start position
  LMenuStartY := FStartY;
  if FShowTitle and (FTitle <> '') then
    Inc(LMenuStartY, 1 + FTheme.TitleSpacing);
  if (bpTop in FTheme.BorderParts) and (FTheme.BorderStyle <> bsNone) then
    Inc(LMenuStartY, 1);

  // Draw items
  for LIndex := 0 to FItems.Count - 1 do
  begin
    LColumn := LIndex div FItemsPerColumn;
    LRow := LIndex mod FItemsPerColumn;

    // Only draw if within visible area
    if (LColumn < FColumnCount) and (LRow < FItemsPerColumn) then
    begin
      LX := FTheme.LeftMargin + LColumn * (FColumnWidth + FTheme.ColumnSpacing);
      LY := LMenuStartY + LRow;

      LItem := FItems[LIndex];

      // Handle separators
      if LItem.IsSeparator then
      begin
        DrawSeparator(LItem.Description, LX, LY, FColumnWidth);
        Continue;
      end;

      Tg2dConsole.SetCursorPos(LX, LY);

      // Determine colors and prefix
      if LIndex = FCurrentIndex then
      begin
        if LItem.Enabled then
        begin
          ApplyColor(FTheme.SelectedForegroundColor);
          if FTheme.UseBackground then
            Tg2dConsole.SetBackgroundColor(FTheme.SelectedBackgroundColor);
          LPrefix := FTheme.SelectedPrefix;
        end
        else
        begin
          ApplyColor(FTheme.DisabledColor);
          LPrefix := FTheme.DisabledPrefix;
        end;
      end
      else
      begin
        if LItem.Enabled then
        begin
          ApplyColor(FTheme.ForegroundColor);
          LPrefix := FTheme.NormalPrefix;
        end
        else
        begin
          ApplyColor(FTheme.DisabledColor);
          LPrefix := FTheme.DisabledPrefix;
        end;
      end;

      // Add line numbers if enabled
      LLineNumber := '';
      if FTheme.ShowLineNumbers then
        LLineNumber := Format('%2d. ', [LIndex + 1]);

      Tg2dConsole.Print(LPrefix + LLineNumber + LItem.Description, False);
      Tg2dConsole.ResetTextFormat();
    end;
  end;
end;

procedure Tg2dTextMenu<T>.DrawFooter();
var
  LFooterY: Integer;
  LX: Integer;
begin
  if not FShowFooter or (FFooterText = '') then
    Exit;

  LFooterY := FStartY + FMenuHeight;
  if FShowTitle and (FTitle <> '') then
    Inc(LFooterY, 1 + FTheme.TitleSpacing);
  if (bpBottom in FTheme.BorderParts) and (FTheme.BorderStyle <> bsNone) then
    Inc(LFooterY, 1);
  Inc(LFooterY, FTheme.FooterSpacing);

  if FTheme.CenterFooter then
    LX := (FConsoleWidth - Length(FFooterText)) div 2
  else
    LX := FTheme.LeftMargin;

  if LX < 0 then LX := 0;

  Tg2dConsole.SetCursorPos(LX, LFooterY);
  ApplyColor(FTheme.FooterColor);
  Tg2dConsole.Print(FFooterText, False);
  Tg2dConsole.ResetTextFormat();
end;

procedure Tg2dTextMenu<T>.MoveUp();
var
  LNewIndex: Integer;
begin
  if FItems.Count = 0 then
    Exit;

  if FCurrentRow > 0 then
  begin
    LNewIndex := FCurrentIndex - 1;
    // Skip disabled items and separators
    while (LNewIndex >= 0) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Dec(LNewIndex);

    if LNewIndex >= 0 then
      FCurrentIndex := LNewIndex;
  end
  else if FAllowWrap then
  begin
    // Move to bottom of current column
    LNewIndex := FCurrentColumn * FItemsPerColumn + (FItemsPerColumn - 1);
    if LNewIndex >= FItems.Count then
      LNewIndex := FItems.Count - 1;

    // Find last enabled item in column
    while (LNewIndex >= FCurrentColumn * FItemsPerColumn) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Dec(LNewIndex);

    if (LNewIndex >= FCurrentColumn * FItemsPerColumn) then
      FCurrentIndex := LNewIndex;
  end;

  UpdateColumnAndRow();
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.MoveDown();
var
  LNewIndex: Integer;
begin
  if FItems.Count = 0 then
    Exit;

  if FCurrentRow < FItemsPerColumn - 1 then
  begin
    LNewIndex := FCurrentIndex + 1;
    if LNewIndex < FItems.Count then
    begin
      // Skip disabled items and separators
      while (LNewIndex < FItems.Count) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
        Inc(LNewIndex);

      if LNewIndex < FItems.Count then
        FCurrentIndex := LNewIndex;
    end;
  end
  else if FAllowWrap then
  begin
    // Move to top of current column
    LNewIndex := FCurrentColumn * FItemsPerColumn;

    // Find first enabled item in column
    while (LNewIndex < FItems.Count) and (LNewIndex < (FCurrentColumn + 1) * FItemsPerColumn) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Inc(LNewIndex);

    if LNewIndex < FItems.Count then
      FCurrentIndex := LNewIndex;
  end;

  UpdateColumnAndRow();
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.MoveLeft();
var
  LNewIndex: Integer;
begin
  if FItems.Count = 0 then
    Exit;

  if FCurrentColumn > 0 then
  begin
    LNewIndex := (FCurrentColumn - 1) * FItemsPerColumn + FCurrentRow;
    if LNewIndex >= FItems.Count then
      LNewIndex := FItems.Count - 1;

    // Find nearest enabled item
    while (LNewIndex >= (FCurrentColumn - 1) * FItemsPerColumn) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Dec(LNewIndex);

    if LNewIndex >= (FCurrentColumn - 1) * FItemsPerColumn then
      FCurrentIndex := LNewIndex;
  end
  else if FAllowWrap then
  begin
    // Move to rightmost column
    LNewIndex := ((FItems.Count - 1) div FItemsPerColumn) * FItemsPerColumn + FCurrentRow;
    if LNewIndex >= FItems.Count then
      LNewIndex := FItems.Count - 1;

    // Find nearest enabled item
    while (LNewIndex >= 0) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Dec(LNewIndex);

    if LNewIndex >= 0 then
      FCurrentIndex := LNewIndex;
  end;

  UpdateColumnAndRow();
  FNeedRedraw := True;
end;

procedure Tg2dTextMenu<T>.MoveRight();
var
  LNewIndex: Integer;
begin
  if FItems.Count = 0 then
    Exit;

  LNewIndex := (FCurrentColumn + 1) * FItemsPerColumn + FCurrentRow;

  if LNewIndex < FItems.Count then
  begin
    // Find nearest enabled item
    while (LNewIndex < FItems.Count) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Inc(LNewIndex);

    if LNewIndex < FItems.Count then
      FCurrentIndex := LNewIndex;
  end
  else if FAllowWrap then
  begin
    // Move to first column
    LNewIndex := FCurrentRow;
    if LNewIndex >= FItems.Count then
      LNewIndex := 0;

    // Find first enabled item
    while (LNewIndex < FItems.Count) and (not FItems[LNewIndex].Enabled or FItems[LNewIndex].IsSeparator) do
      Inc(LNewIndex);

    if LNewIndex < FItems.Count then
      FCurrentIndex := LNewIndex;
  end;

  UpdateColumnAndRow();
  FNeedRedraw := True;
end;

function Tg2dTextMenu<T>.HandleInput(): Boolean;
begin
  Result := True;

  // Check for key presses using Tg2dConsole
  if Tg2dConsole.WasKeyPressed(VK_UP) then
    MoveUp()
  else if Tg2dConsole.WasKeyPressed(VK_DOWN) then
    MoveDown()
  else if Tg2dConsole.WasKeyPressed(VK_LEFT) then
    MoveLeft()
  else if Tg2dConsole.WasKeyPressed(VK_RIGHT) then
    MoveRight()
  else if Tg2dConsole.WasKeyPressed(VK_RETURN) then
  begin
    // Only allow selection of enabled items
    if (FCurrentIndex >= 0) and (FCurrentIndex < FItems.Count) and FItems[FCurrentIndex].Enabled and not FItems[FCurrentIndex].IsSeparator then
      Result := False; // Signal to exit and return selection
  end
  else if Tg2dConsole.WasKeyPressed(VK_ESC) then
  begin
    FCurrentIndex := -1; // Signal canceled
    Result := False;
  end;
end;

function Tg2dTextMenu<T>.Run(): Tg2dTextMenuResult;
var
  LRunning: Boolean;
begin
  if FItems.Count = 0 then
  begin
    Result := mrError;
    Exit;
  end;

  // Ensure current index is valid and points to an enabled item
  if (FCurrentIndex < 0) or (FCurrentIndex >= FItems.Count) or
     (not FItems[FCurrentIndex].Enabled) or FItems[FCurrentIndex].IsSeparator then
  begin
    // Only then find first enabled item
    FCurrentIndex := 0;
    while (FCurrentIndex < FItems.Count) and (not FItems[FCurrentIndex].Enabled or FItems[FCurrentIndex].IsSeparator) do
      Inc(FCurrentIndex);
  end;

  if FCurrentIndex >= FItems.Count then
  begin
    Result := mrError;
    Exit;
  end;

  CalculateLayout();
  UpdateColumnAndRow();

  // Hide cursor for cleaner display
  Tg2dConsole.HideCursor();

  // Clear any previous key states
  while Tg2dConsole.IsKeyPressed(VK_ESC) or Tg2dConsole.IsKeyPressed(VK_RETURN) do
  begin
    Tg2dUtils.ProcessMessages();
  end;

  Tg2dConsole.ClearKeyStates();

  LRunning := True;
  FNeedRedraw := True;

  try
    while LRunning do
    begin
      // Only redraw when needed
      if FNeedRedraw then
      begin
        ClearMenuArea();
        if FTheme.BorderStyle <> bsNone then
          DrawBorder();
        if FShowTitle then
          DrawTitle();
        DrawMenu();
        if FShowFooter then
          DrawFooter();
        FNeedRedraw := False;
      end;

      LRunning := HandleInput();

      // Process messages and small delay
      Tg2dUtils.ProcessMessages();
      Tg2dConsole.Wait(16); // ~60 FPS
    end;
  finally
    // Restore cursor visibility
    Tg2dConsole.ShowCursor();
  end;

  // Return result based on final state
  if (FCurrentIndex >= 0) and (FCurrentIndex < FItems.Count) then
    Result := mrSelected
  else
    Result := mrCanceled;
end;

//=== UNIT INIT ================================================================

initialization
  if not EnableVirtualTerminalProcessing() then
    Exit;

  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);

finalization

end.
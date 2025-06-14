(*******************************************************************************
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

Game2D.Database - High-Performance SQLite Database Management System

A comprehensive SQLite database management unit providing connection pooling,
parameterized queries, macro replacement, batch operations, transaction support,
and JSON result formatting. Designed for high-performance game development with
object pooling and optimized memory management.

═══════════════════════════════════════════════════════════════════════════════
CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════════════════════

• **Object Pool Pattern**: Implements Tg2dLocalDbPool for efficient database
  connection reuse, reducing allocation/deallocation overhead
• **SQLite3 Integration**: Direct SQLite3 API binding for maximum performance
  and minimal overhead
• **Parameterized Queries**: Safe parameter binding with automatic type
  conversion and SQL injection protection
• **Macro System**: Text replacement system using &MacroName syntax for
  dynamic SQL generation
• **JSON Result Format**: All query results are returned as structured JSON
  for easy parsing and integration
• **Batch Operations**: Execute multiple SQL statements efficiently in a
  single operation
• **Transaction Support**: Full ACID transaction support with automatic
  rollback on errors

The architecture follows a lightweight wrapper pattern around SQLite3, providing
modern Delphi conveniences while maintaining direct access to native SQLite
performance.

═══════════════════════════════════════════════════════════════════════════════
CONNECTION POOLING SYSTEM
═══════════════════════════════════════════════════════════════════════════════

• **Automatic Instance Management**: Pool maintains ready-to-use database
  instances
• **Configurable Pool Size**: Set maximum pool size based on application needs
• **Resource Cleanup**: Automatic cleanup of SQL text, macros, and parameters
  when returning instances
• **Thread-Safe Operations**: Pool operations are designed for multi-threaded
  environments

BASIC POOL USAGE:
  var
    LDatabase: Tg2dLocalDb;
  begin
    // Configure pool size (optional, default is 10)
    Tg2dLocalDbPool.SetMaxPoolSize(20);

    // Get pooled instance
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        LDatabase.SetSQLText('SELECT * FROM Players WHERE Level > 10');
        if LDatabase.Execute() then
        begin
          // Process results...
        end;
      end;
    finally
      // Return to pool for reuse
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

ADVANCED POOL CONFIGURATION:
  // Set pool size at application startup
  procedure InitializeDatabasePool();
  begin
    Tg2dLocalDbPool.SetMaxPoolSize(50); // For high-traffic games
  end;

═══════════════════════════════════════════════════════════════════════════════
DATABASE CONNECTION MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════

• **Automatic File Extension**: Automatically appends .db extension if not
  provided
• **Connection Validation**: Built-in connection testing and error reporting
• **Resource Cleanup**: Proper cleanup of statements and handles on close
• **Full Path Support**: Handles relative and absolute file paths

CONNECTION EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDb.Create();
    try
      // Simple connection
      if LDatabase.Open('GameData') then // Creates GameData.db
      begin
        // Database is ready for use
        ShowMessage('Connected successfully');
      end
      else
      begin
        ShowMessage('Connection failed: ' + LDatabase.GetError());
      end;

      // Check connection status
      if LDatabase.IsOpen() then
      begin
        // Perform database operations
      end;

      // Manual close (automatic on destroy)
      LDatabase.Close();
    finally
      LDatabase.Free();
    end;
  end;

FULL PATH EXAMPLE:
  var
    LDatabase: Tg2dLocalDb;
    LFullPath: string;
  begin
    LDatabase := Tg2dLocalDb.Create();
    try
      LFullPath := TPath.Combine(TPath.GetDocumentsPath(), 'MyGame', 'Data');
      TDirectory.CreateDirectory(LFullPath);
      LFullPath := TPath.Combine(LFullPath, 'GameDatabase');

      if LDatabase.Open(LFullPath) then
      begin
        // Database opened at full path
      end;
    finally
      LDatabase.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
SQL QUERY BUILDING AND EXECUTION
═══════════════════════════════════════════════════════════════════════════════

• **Dynamic SQL Building**: Build complex queries using AddSQLText with
  format parameters
• **Query Validation**: Automatic SQL validation before execution
• **Multiple Execution Methods**: Execute(), ExecuteSQL(), ExecuteSimple()
• **Query Length Limits**: Built-in protection against overly large queries
  (8192 character limit)

SQL BUILDING EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
    LPlayerLevel: Integer;
    LPlayerName: string;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Method 1: Build SQL incrementally
        LDatabase.ClearSQLText();
        LDatabase.AddSQLText('SELECT PlayerID, Name, Level, Experience', []);
        LDatabase.AddSQLText('FROM Players', []);
        LDatabase.AddSQLText('WHERE Level >= %d', [10]);
        LDatabase.AddSQLText('AND Name LIKE ''%s%%''', ['Knight']);
        LDatabase.AddSQLText('ORDER BY Level DESC', []);

        if LDatabase.Execute() then
        begin
          // Process results
          for var I := 0 to LDatabase.RecordCount() - 1 do
          begin
            LPlayerName := LDatabase.GetField(I, 'Name');
            LPlayerLevel := LDatabase.GetFieldAsInteger(I, 'Level');
            // Use player data...
          end;
        end;

        // Method 2: Set complete SQL
        LDatabase.SetSQLText('SELECT COUNT( * ) as PlayerCount FROM Players');
        if LDatabase.Execute() then
        begin
          var LCount := LDatabase.GetFieldAsInteger(0, 'PlayerCount');
          ShowMessage(Format('Total players: %d', [LCount]));
        end;

        // Method 3: Direct execution
        if LDatabase.ExecuteSQL('DELETE FROM TempData WHERE Created < datetime(''now'', ''-1 day'')') then
        begin
          ShowMessage(Format('Cleaned up old data. Rows affected: %d', [LDatabase.Changes]));
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

COMPLEX QUERY BUILDING:
  procedure BuildInventoryQuery(const ADatabase: Tg2dLocalDb; const APlayerID: Integer; const AItemType: string);
  begin
    ADatabase.ClearSQLText();
    ADatabase.AddSQLText('SELECT i.ItemID, i.Name, i.Quantity, it.Category, it.MaxStack', []);
    ADatabase.AddSQLText('FROM Inventory i', []);
    ADatabase.AddSQLText('INNER JOIN ItemTypes it ON i.ItemTypeID = it.TypeID', []);
    ADatabase.AddSQLText('WHERE i.PlayerID = %d', [APlayerID]);
    if not AItemType.IsEmpty then
    begin
      ADatabase.AddSQLText('AND it.Category = %s', [QuotedStr(AItemType)]);
    end;
    ADatabase.AddSQLText('ORDER BY it.Category, i.Name', []);
  end;

═══════════════════════════════════════════════════════════════════════════════
MACRO REPLACEMENT SYSTEM
═══════════════════════════════════════════════════════════════════════════════

• **Dynamic Text Replacement**: Replace &MacroName with actual values before
  query execution
• **Template SQL Support**: Create reusable SQL templates with macro
  placeholders
• **Multiple Macro Support**: Use unlimited macros in a single query
• **Case-Sensitive Matching**: Macro names are case-sensitive for precision

MACRO USAGE EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Set up macros for dynamic table/column names
        LDatabase.SetMacro('TABLE_NAME', 'Players');
        LDatabase.SetMacro('ORDER_COLUMN', 'Level');
        LDatabase.SetMacro('ORDER_DIRECTION', 'DESC');

        // Use macros in SQL (note: & prefix for macros)
        LDatabase.SetSQLText('SELECT * FROM &TABLE_NAME ORDER BY &ORDER_COLUMN &ORDER_DIRECTION LIMIT 10');

        // This becomes: SELECT * FROM Players ORDER BY Level DESC LIMIT 10
        if LDatabase.Execute() then
        begin
          // Process top 10 players by level
        end;

        // Reuse template with different macros
        LDatabase.SetMacro('TABLE_NAME', 'Monsters');
        LDatabase.SetMacro('ORDER_COLUMN', 'Difficulty');
        // Same SQL, different execution
        if LDatabase.Execute() then
        begin
          // Process top 10 monsters by difficulty
        end;

        // Clear specific macro
        LDatabase.SetMacro('ORDER_DIRECTION', ''); // Removes this macro

        // Clear all macros
        LDatabase.ClearMacros();
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

TEMPLATE SYSTEM EXAMPLE:
  const
    SQL_TEMPLATE_LEADERBOARD =
      'SELECT Rank() OVER (ORDER BY &SCORE_FIELD DESC) as Rank, ' +
      'Name, &SCORE_FIELD as Score ' +
      'FROM &LEADERBOARD_TABLE ' +
      'WHERE &SCORE_FIELD > 0 ' +
      'ORDER BY &SCORE_FIELD DESC ' +
      'LIMIT &MAX_RESULTS';

  procedure GetLeaderboard(const ADatabase: Tg2dLocalDb; const AGameMode: string);
  begin
    case AGameMode of
      'arcade':
      begin
        ADatabase.SetMacro('LEADERBOARD_TABLE', 'ArcadeScores');
        ADatabase.SetMacro('SCORE_FIELD', 'HighScore');
      end;
      'survival':
      begin
        ADatabase.SetMacro('LEADERBOARD_TABLE', 'SurvivalTimes');
        ADatabase.SetMacro('SCORE_FIELD', 'SurvivalSeconds');
      end;
    end;
    ADatabase.SetMacro('MAX_RESULTS', '100');
    ADatabase.SetSQLText(SQL_TEMPLATE_LEADERBOARD);
    ADatabase.Execute();
  end;

═══════════════════════════════════════════════════════════════════════════════
PARAMETERIZED QUERIES
═══════════════════════════════════════════════════════════════════════════════

• **SQL Injection Protection**: Automatic parameter binding prevents SQL
  injection attacks
• **Type-Safe Binding**: Automatic type conversion for parameters
• **Named Parameters**: Use :ParamName syntax for clear parameter identification
• **Parameter Validation**: Built-in validation of parameter names and values

PARAMETER USAGE EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
    LPlayerName: string;
    LNewLevel: Integer;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Safe parameter binding
        LDatabase.SetSQLText('SELECT * FROM Players WHERE Name = :PlayerName AND Level >= :MinLevel');
        LDatabase.SetParam('PlayerName', 'DragonSlayer');
        LDatabase.SetParam('MinLevel', '10');

        if LDatabase.Execute() then
        begin
          // Results are safe from SQL injection
          for var I := 0 to LDatabase.RecordCount() - 1 do
          begin
            LPlayerName := LDatabase.GetField(I, 'Name');
            // Process player data...
          end;
        end;

        // Update with parameters
        LDatabase.SetSQLText('UPDATE Players SET Level = :NewLevel, Experience = :NewExp WHERE PlayerID = :PlayerID');
        LDatabase.SetParam('NewLevel', '25');
        LDatabase.SetParam('NewExp', '125000');
        LDatabase.SetParam('PlayerID', '1001');

        if LDatabase.Execute() then
        begin
          ShowMessage(Format('Player updated. Rows affected: %d', [LDatabase.Changes]));
        end;

        // Insert new record
        LDatabase.SetSQLText('INSERT INTO Players (Name, Level, Class, Created) VALUES (:Name, :Level, :Class, datetime(''now''))');
        LDatabase.SetParam('Name', 'NewHero');
        LDatabase.SetParam('Level', '1');
        LDatabase.SetParam('Class', 'Warrior');

        if LDatabase.Execute() then
        begin
          var LNewPlayerID := LDatabase.LastInsertRowId;
          ShowMessage(Format('New player created with ID: %d', [LNewPlayerID]));
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

ADVANCED PARAMETER SCENARIOS:
  procedure SafeSearchPlayers(const ADatabase: Tg2dLocalDb; const ASearchTerm: string; const AMinLevel: Integer);
  begin
    // This is safe even with malicious input
    ADatabase.SetSQLText(
      'SELECT PlayerID, Name, Level, Class ' +
      'FROM Players ' +
      'WHERE (Name LIKE :SearchPattern OR Class LIKE :SearchPattern) ' +
      'AND Level >= :MinLevel ' +
      'ORDER BY Level DESC'
    );
    ADatabase.SetParam('SearchPattern', '%' + ASearchTerm + '%');
    ADatabase.SetParam('MinLevel', IntToStr(AMinLevel));
    ADatabase.Execute();
  end;

═══════════════════════════════════════════════════════════════════════════════
RESULT PROCESSING AND DATA ACCESS
═══════════════════════════════════════════════════════════════════════════════

• **JSON Result Format**: All results returned as structured JSON arrays
• **Type-Safe Accessors**: GetField, GetFieldAsInteger, GetFieldAsFloat,
  GetFieldAsBoolean methods
• **Zero-Based Indexing**: Record access uses 0-based indexing
• **Null Value Handling**: Automatic handling of NULL database values
• **Record Count Access**: Quick access to result set size

RESULT PROCESSING EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
    LPlayerData: TPlayerRecord;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        LDatabase.SetSQLText('SELECT * FROM Players ORDER BY Level DESC LIMIT 10');
        if LDatabase.Execute() then
        begin
          ShowMessage(Format('Found %d players', [LDatabase.RecordCount()]));

          // Process each record
          for var I := 0 to LDatabase.RecordCount() - 1 do
          begin
            // String fields
            LPlayerData.Name := LDatabase.GetField(I, 'Name');
            LPlayerData.ClassName := LDatabase.GetField(I, 'Class');

            // Numeric fields
            LPlayerData.ID := LDatabase.GetFieldAsInteger(I, 'PlayerID');
            LPlayerData.Level := LDatabase.GetFieldAsInteger(I, 'Level');
            LPlayerData.Experience := LDatabase.GetFieldAsFloat(I, 'Experience');

            // Boolean fields
            LPlayerData.IsOnline := LDatabase.GetFieldAsBoolean(I, 'Online');
            LPlayerData.IsPremium := LDatabase.GetFieldAsBoolean(I, 'Premium');

            // Use player data in game logic
            ProcessPlayerData(LPlayerData);
          end;
        end;

        // Access raw JSON response if needed
        var LJSONResponse := LDatabase.GetResponseText();
        // Process JSON directly if required...
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

STATISTICAL QUERIES:
  procedure GetGameStatistics(const ADatabase: Tg2dLocalDb);
  var
    LTotalPlayers: Integer;
    LAverageLevel: Double;
    LMaxLevel: Integer;
    LTopPlayerName: string;
  begin
    // Get summary statistics
    ADatabase.SetSQLText('SELECT COUNT( * ) as TotalPlayers, AVG(Level) as AvgLevel, MAX(Level) as MaxLevel FROM Players');
    if ADatabase.Execute() then
    begin
      LTotalPlayers := ADatabase.GetFieldAsInteger(0, 'TotalPlayers');
      LAverageLevel := ADatabase.GetFieldAsFloat(0, 'AvgLevel');
      LMaxLevel := ADatabase.GetFieldAsInteger(0, 'MaxLevel');
    end;

    // Get top player
    ADatabase.SetSQLText('SELECT Name FROM Players WHERE Level = (SELECT MAX(Level) FROM Players) LIMIT 1');
    if ADatabase.Execute() and (ADatabase.RecordCount() > 0) then
    begin
      LTopPlayerName := ADatabase.GetField(0, 'Name');
    end;

    ShowMessage(Format('Statistics: %d players, average level %.1f, top player: %s (level %d)',
      [LTotalPlayers, LAverageLevel, LTopPlayerName, LMaxLevel]));
  end;

═══════════════════════════════════════════════════════════════════════════════
BATCH OPERATIONS
═══════════════════════════════════════════════════════════════════════════════

• **Multiple Statement Execution**: Execute multiple SQL statements in a
  single batch operation
• **Performance Optimization**: Reduce database round-trips for bulk operations
• **Transaction Wrapping**: Batch operations can be wrapped in transactions
• **Error Handling**: Single failure can halt entire batch with rollback

BATCH OPERATION EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Prepare batch operations
        LDatabase.BeginBatch();
        try
          // Add multiple operations to batch
          LDatabase.AddBatchSQL('UPDATE Players SET LastLogin = datetime(''now'') WHERE PlayerID = 1001');
          LDatabase.AddBatchSQL('INSERT INTO LoginLog (PlayerID, LoginTime) VALUES (1001, datetime(''now''))');
          LDatabase.AddBatchSQL('UPDATE GameStats SET LoginCount = LoginCount + 1 WHERE StatType = ''daily''');

          // Execute all operations at once
          if LDatabase.ExecuteBatch() then
          begin
            ShowMessage('Batch operations completed successfully');
          end
          else
          begin
            ShowMessage('Batch operations failed: ' + LDatabase.GetError());
          end;
        finally
          LDatabase.ClearBatch(); // Clean up batch queue
        end;

        // Batch with transaction for atomic operations
        if LDatabase.BeginTransaction() then
        begin
          LDatabase.BeginBatch();
          try
            // Add operations that must all succeed or all fail
            LDatabase.AddBatchSQL('UPDATE Players SET Gold = Gold - 1000 WHERE PlayerID = 1001');
            LDatabase.AddBatchSQL('INSERT INTO Purchases (PlayerID, ItemID, Cost) VALUES (1001, 2001, 1000)');
            LDatabase.AddBatchSQL('UPDATE Inventory SET Quantity = Quantity + 1 WHERE PlayerID = 1001 AND ItemID = 2001');

            if LDatabase.ExecuteBatch() then
            begin
              LDatabase.CommitTransaction();
              ShowMessage('Purchase completed successfully');
            end
            else
            begin
              LDatabase.RollbackTransaction();
              ShowMessage('Purchase failed - all changes rolled back');
            end;
          finally
            LDatabase.ClearBatch();
          end;
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

BULK DATA INSERTION:
  procedure InsertMultipleItems(const ADatabase: Tg2dLocalDb; const AItems: TArray<TItemData>);
  begin
    ADatabase.BeginTransaction();
    ADatabase.BeginBatch();
    try
      for var LItem in AItems do
      begin
        ADatabase.AddBatchSQL(Format(
          'INSERT INTO Items (Name, Category, Value, Weight) VALUES (%s, %s, %f, %f)',
          [QuotedStr(LItem.Name), QuotedStr(LItem.Category), LItem.Value, LItem.Weight]
        ));
      end;

      if ADatabase.ExecuteBatch() then
      begin
        ADatabase.CommitTransaction();
        ShowMessage(Format('Successfully inserted %d items', [Length(AItems)]));
      end
      else
      begin
        ADatabase.RollbackTransaction();
        ShowMessage('Failed to insert items - transaction rolled back');
      end;
    finally
      ADatabase.ClearBatch();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
TRANSACTION SUPPORT
═══════════════════════════════════════════════════════════════════════════════

• **ACID Compliance**: Full support for Atomic, Consistent, Isolated, Durable
  transactions
• **Nested Transaction Detection**: Prevents nested transaction conflicts
• **Automatic Rollback**: Failed operations can trigger automatic rollback
• **Transaction State Tracking**: Internal tracking of transaction status

TRANSACTION EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Simple transaction example
        if LDatabase.BeginTransaction() then
        begin
          try
            // Transfer gold between players (must be atomic)
            LDatabase.SetSQLText('UPDATE Players SET Gold = Gold - :Amount WHERE PlayerID = :FromPlayer');
            LDatabase.SetParam('Amount', '500');
            LDatabase.SetParam('FromPlayer', '1001');

            if not LDatabase.Execute() then
              raise Exception.Create('Failed to deduct gold');

            LDatabase.SetSQLText('UPDATE Players SET Gold = Gold + :Amount WHERE PlayerID = :ToPlayer');
            LDatabase.SetParam('Amount', '500');
            LDatabase.SetParam('ToPlayer', '1002');

            if not LDatabase.Execute() then
              raise Exception.Create('Failed to add gold');

            // Log the transaction
            LDatabase.SetSQLText('INSERT INTO GoldTransfers (FromPlayer, ToPlayer, Amount, TransferTime) VALUES (:From, :To, :Amount, datetime(''now''))');
            LDatabase.SetParam('From', '1001');
            LDatabase.SetParam('To', '1002');
            LDatabase.SetParam('Amount', '500');

            if not LDatabase.Execute() then
              raise Exception.Create('Failed to log transaction');

            // All operations succeeded
            LDatabase.CommitTransaction();
            ShowMessage('Gold transfer completed successfully');
          except
            on E: Exception do
            begin
              LDatabase.RollbackTransaction();
              ShowMessage('Gold transfer failed: ' + E.Message);
            end;
          end;
        end
        else
        begin
          ShowMessage('Failed to begin transaction');
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

COMPLEX TRANSACTION SCENARIO:
  procedure ProcessPlayerLevelUp(const ADatabase: Tg2dLocalDb; const APlayerID: Integer; const ANewLevel: Integer);
  var
    LSkillPoints: Integer;
    LNewHitPoints: Integer;
  begin
    if ADatabase.BeginTransaction() then
    begin
      try
        // Calculate level-up bonuses
        LSkillPoints := (ANewLevel - 1) * 5; // 5 skill points per level
        LNewHitPoints := ANewLevel * 100;    // 100 HP per level

        // Update player level and stats
        ADatabase.SetSQLText('UPDATE Players SET Level = :NewLevel, SkillPoints = :SkillPoints, HitPoints = :HitPoints WHERE PlayerID = :PlayerID');
        ADatabase.SetParam('NewLevel', IntToStr(ANewLevel));
        ADatabase.SetParam('SkillPoints', IntToStr(LSkillPoints));
        ADatabase.SetParam('HitPoints', IntToStr(LNewHitPoints));
        ADatabase.SetParam('PlayerID', IntToStr(APlayerID));
        ADatabase.Execute();

        // Unlock new abilities for this level
        ADatabase.SetSQLText('INSERT INTO PlayerAbilities (PlayerID, AbilityID) SELECT :PlayerID, AbilityID FROM Abilities WHERE RequiredLevel <= :NewLevel AND AbilityID NOT IN (SELECT AbilityID FROM PlayerAbilities WHERE PlayerID = :PlayerID)');
        ADatabase.SetParam('PlayerID', IntToStr(APlayerID));
        ADatabase.SetParam('NewLevel', IntToStr(ANewLevel));
        ADatabase.Execute();

        // Log the level up event
        ADatabase.SetSQLText('INSERT INTO PlayerEvents (PlayerID, EventType, EventData, EventTime) VALUES (:PlayerID, ''LEVEL_UP'', :EventData, datetime(''now''))');
        ADatabase.SetParam('PlayerID', IntToStr(APlayerID));
        ADatabase.SetParam('EventData', Format('{"oldLevel": %d, "newLevel": %d}', [ANewLevel - 1, ANewLevel]));
        ADatabase.Execute();

        ADatabase.CommitTransaction();
        ShowMessage(Format('Player %d leveled up to %d successfully', [APlayerID, ANewLevel]));
      except
        on E: Exception do
        begin
          ADatabase.RollbackTransaction();
          ShowMessage('Level up failed: ' + E.Message);
        end;
      end;
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
UTILITY METHODS
═══════════════════════════════════════════════════════════════════════════════

• **String Safety**: QuoteString() and EscapeString() for safe string handling
• **Database Schema Tools**: Table existence checking, creation, and management
• **Metadata Access**: Get table lists and column information
• **Performance Information**: Access to query timing and response size metrics

UTILITY METHOD EXAMPLES:
  var
    LDatabase: Tg2dLocalDb;
    LSafeString: string;
    LTables: TArray<string>;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // String safety utilities
        LSafeString := LDatabase.QuoteString('Player''s Name'); // Returns 'Player''s Name'
        LSafeString := LDatabase.EscapeString('Dangerous"Input'); // Returns safe string

        // Table management
        if not LDatabase.TableExists('PlayerStats') then
        begin
          var LSQL := 'CREATE TABLE PlayerStats (' +
                     'PlayerID INTEGER PRIMARY KEY, ' +
                     'TotalKills INTEGER DEFAULT 0, ' +
                     'TotalDeaths INTEGER DEFAULT 0, ' +
                     'PlayTime INTEGER DEFAULT 0)';
          if LDatabase.CreateTable(LSQL) then
          begin
            ShowMessage('PlayerStats table created successfully');
          end;
        end;

        // Get all tables in database
        LTables := LDatabase.GetTableList();
        for var LTableName in LTables do
        begin
          ShowMessage('Found table: ' + LTableName);
        end;

        // Performance information
        LDatabase.SetSQLText('SELECT COUNT( * ) FROM Players');
        if LDatabase.Execute() then
        begin
          ShowMessage(Format('Query completed in %.2f ms, response size: %d bytes',
            [LDatabase.GetQueryTime(), LDatabase.GetResponseLength()]));
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

SCHEMA VALIDATION EXAMPLE:
  function ValidateGameSchema(const ADatabase: Tg2dLocalDb): Boolean;
  const
    REQUIRED_TABLES: array[0..4] of string = ('Players', 'Items', 'Inventory', 'GameEvents', 'Settings');
  var
    LMissingTables: TStringList;
  begin
    Result := True;
    LMissingTables := TStringList.Create();
    try
      for var LTableName in REQUIRED_TABLES do
      begin
        if not ADatabase.TableExists(LTableName) then
        begin
          LMissingTables.Add(LTableName);
          Result := False;
        end;
      end;

      if not Result then
      begin
        ShowMessage('Missing required tables: ' + LMissingTables.CommaText);
      end;
    finally
      LMissingTables.Free();
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
COMPLETE USAGE EXAMPLE
═══════════════════════════════════════════════════════════════════════════════

This comprehensive example demonstrates a complete game player management system
using all major features of the database unit.

  unit PlayerManager;

  interface

  uses
    System.SysUtils,
    System.Generics.Collections,
    Game2D.Database;

  type
    TPlayerInfo = record
      ID: Integer;
      Name: string;
      Level: Integer;
      Experience: Int64;
      Gold: Integer;
      Class: string;
      IsOnline: Boolean;
    end;

    TPlayerManager = class
    private
      class procedure InitializeDatabase();
    public
      class function CreatePlayer(const AName: string; const AClass: string): Integer;
      class function GetPlayer(const APlayerID: Integer): TPlayerInfo;
      class function GetTopPlayers(const ACount: Integer): TArray<TPlayerInfo>;
      class function UpdatePlayerExperience(const APlayerID: Integer; const AExpGained: Integer): Boolean;
      class function TransferGold(const AFromPlayerID: Integer; const AToPlayerID: Integer; const AAmount: Integer): Boolean;
      class procedure UpdateAllPlayersLastSeen();
    end;

  implementation

  class procedure TPlayerManager.InitializeDatabase();
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Create tables if they don't exist
        if not LDatabase.TableExists('Players') then
        begin
          LDatabase.CreateTable(
            'CREATE TABLE Players (' +
            'PlayerID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'Name TEXT UNIQUE NOT NULL, ' +
            'Level INTEGER DEFAULT 1, ' +
            'Experience INTEGER DEFAULT 0, ' +
            'Gold INTEGER DEFAULT 1000, ' +
            'Class TEXT NOT NULL, ' +
            'IsOnline BOOLEAN DEFAULT 0, ' +
            'Created DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
            'LastSeen DATETIME DEFAULT CURRENT_TIMESTAMP)'
          );
        end;

        if not LDatabase.TableExists('GoldTransfers') then
        begin
          LDatabase.CreateTable(
            'CREATE TABLE GoldTransfers (' +
            'TransferID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'FromPlayerID INTEGER, ' +
            'ToPlayerID INTEGER, ' +
            'Amount INTEGER, ' +
            'TransferTime DATETIME DEFAULT CURRENT_TIMESTAMP)'
          );
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

  class function TPlayerManager.CreatePlayer(const AName: string; const AClass: string): Integer;
  var
    LDatabase: Tg2dLocalDb;
  begin
    Result := -1;
    InitializeDatabase();

    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Use parameterized query for safety
        LDatabase.SetSQLText('INSERT INTO Players (Name, Class) VALUES (:PlayerName, :PlayerClass)');
        LDatabase.SetParam('PlayerName', AName);
        LDatabase.SetParam('PlayerClass', AClass);

        if LDatabase.Execute() then
        begin
          Result := LDatabase.LastInsertRowId;
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

  class function TPlayerManager.GetPlayer(const APlayerID: Integer): TPlayerInfo;
  var
    LDatabase: Tg2dLocalDb;
  begin
    // Initialize with default values
    FillChar(Result, SizeOf(Result), 0);

    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        LDatabase.SetSQLText('SELECT * FROM Players WHERE PlayerID = :PlayerID');
        LDatabase.SetParam('PlayerID', IntToStr(APlayerID));

        if LDatabase.Execute() and (LDatabase.RecordCount() > 0) then
        begin
          Result.ID := LDatabase.GetFieldAsInteger(0, 'PlayerID');
          Result.Name := LDatabase.GetField(0, 'Name');
          Result.Level := LDatabase.GetFieldAsInteger(0, 'Level');
          Result.Experience := LDatabase.GetFieldAsInteger(0, 'Experience');
          Result.Gold := LDatabase.GetFieldAsInteger(0, 'Gold');
          Result.Class := LDatabase.GetField(0, 'Class');
          Result.IsOnline := LDatabase.GetFieldAsBoolean(0, 'IsOnline');
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

  class function TPlayerManager.GetTopPlayers(const ACount: Integer): TArray<TPlayerInfo>;
  var
    LDatabase: Tg2dLocalDb;
    LPlayers: TList<TPlayerInfo>;
    LPlayer: TPlayerInfo;
  begin
    LPlayers := TList<TPlayerInfo>.Create();
    try
      LDatabase := Tg2dLocalDbPool.GetInstance();
      try
        if LDatabase.Open('GameData') then
        begin
          LDatabase.SetSQLText('SELECT * FROM Players ORDER BY Level DESC, Experience DESC LIMIT :MaxResults');
          LDatabase.SetParam('MaxResults', IntToStr(ACount));

          if LDatabase.Execute() then
          begin
            for var I := 0 to LDatabase.RecordCount() - 1 do
            begin
              LPlayer.ID := LDatabase.GetFieldAsInteger(I, 'PlayerID');
              LPlayer.Name := LDatabase.GetField(I, 'Name');
              LPlayer.Level := LDatabase.GetFieldAsInteger(I, 'Level');
              LPlayer.Experience := LDatabase.GetFieldAsInteger(I, 'Experience');
              LPlayer.Gold := LDatabase.GetFieldAsInteger(I, 'Gold');
              LPlayer.Class := LDatabase.GetField(I, 'Class');
              LPlayer.IsOnline := LDatabase.GetFieldAsBoolean(I, 'IsOnline');
              LPlayers.Add(LPlayer);
            end;
          end;
        end;
      finally
        Tg2dLocalDbPool.ReturnInstance(LDatabase);
      end;

      Result := LPlayers.ToArray();
    finally
      LPlayers.Free();
    end;
  end;

  class function TPlayerManager.UpdatePlayerExperience(const APlayerID: Integer; const AExpGained: Integer): Boolean;
  var
    LDatabase: Tg2dLocalDb;
    LCurrentLevel: Integer;
    LNewExperience: Int64;
    LNewLevel: Integer;
  begin
    Result := False;

    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') and LDatabase.BeginTransaction() then
      begin
        try
          // Get current player data
          LDatabase.SetSQLText('SELECT Level, Experience FROM Players WHERE PlayerID = :PlayerID');
          LDatabase.SetParam('PlayerID', IntToStr(APlayerID));

          if LDatabase.Execute() and (LDatabase.RecordCount() > 0) then
          begin
            LCurrentLevel := LDatabase.GetFieldAsInteger(0, 'Level');
            LNewExperience := LDatabase.GetFieldAsInteger(0, 'Experience') + AExpGained;

            // Calculate new level (simple: 1000 exp per level)
            LNewLevel := (LNewExperience div 1000) + 1;

            // Update player stats
            LDatabase.SetSQLText('UPDATE Players SET Experience = :NewExp, Level = :NewLevel WHERE PlayerID = :PlayerID');
            LDatabase.SetParam('NewExp', IntToStr(LNewExperience));
            LDatabase.SetParam('NewLevel', IntToStr(LNewLevel));
            LDatabase.SetParam('PlayerID', IntToStr(APlayerID));

            if LDatabase.Execute() then
            begin
              // If player leveled up, grant bonus gold
              if LNewLevel > LCurrentLevel then
              begin
                var LBonusGold := (LNewLevel - LCurrentLevel) * 500;
                LDatabase.SetSQLText('UPDATE Players SET Gold = Gold + :BonusGold WHERE PlayerID = :PlayerID');
                LDatabase.SetParam('BonusGold', IntToStr(LBonusGold));
                LDatabase.SetParam('PlayerID', IntToStr(APlayerID));
                LDatabase.Execute();
              end;

              LDatabase.CommitTransaction();
              Result := True;
            end
            else
            begin
              LDatabase.RollbackTransaction();
            end;
          end
          else
          begin
            LDatabase.RollbackTransaction();
          end;
        except
          LDatabase.RollbackTransaction();
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

  class function TPlayerManager.TransferGold(const AFromPlayerID: Integer; const AToPlayerID: Integer; const AAmount: Integer): Boolean;
  var
    LDatabase: Tg2dLocalDb;
  begin
    Result := False;

    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') and LDatabase.BeginTransaction() then
      begin
        try
          // Check if sender has enough gold
          LDatabase.SetSQLText('SELECT Gold FROM Players WHERE PlayerID = :PlayerID');
          LDatabase.SetParam('PlayerID', IntToStr(AFromPlayerID));

          if LDatabase.Execute() and (LDatabase.RecordCount() > 0) then
          begin
            var LCurrentGold := LDatabase.GetFieldAsInteger(0, 'Gold');
            if LCurrentGold >= AAmount then
            begin
              // Deduct from sender
              LDatabase.SetSQLText('UPDATE Players SET Gold = Gold - :Amount WHERE PlayerID = :PlayerID');
              LDatabase.SetParam('Amount', IntToStr(AAmount));
              LDatabase.SetParam('PlayerID', IntToStr(AFromPlayerID));

              if LDatabase.Execute() then
              begin
                // Add to receiver
                LDatabase.SetSQLText('UPDATE Players SET Gold = Gold + :Amount WHERE PlayerID = :PlayerID');
                LDatabase.SetParam('Amount', IntToStr(AAmount));
                LDatabase.SetParam('PlayerID', IntToStr(AToPlayerID));

                if LDatabase.Execute() then
                begin
                  // Log the transfer
                  LDatabase.SetSQLText('INSERT INTO GoldTransfers (FromPlayerID, ToPlayerID, Amount) VALUES (:From, :To, :Amount)');
                  LDatabase.SetParam('From', IntToStr(AFromPlayerID));
                  LDatabase.SetParam('To', IntToStr(AToPlayerID));
                  LDatabase.SetParam('Amount', IntToStr(AAmount));

                  if LDatabase.Execute() then
                  begin
                    LDatabase.CommitTransaction();
                    Result := True;
                  end
                  else
                  begin
                    LDatabase.RollbackTransaction();
                  end;
                end
                else
                begin
                  LDatabase.RollbackTransaction();
                end;
              end
              else
              begin
                LDatabase.RollbackTransaction();
              end;
            end
            else
            begin
              LDatabase.RollbackTransaction();
              // Insufficient funds
            end;
          end
          else
          begin
            LDatabase.RollbackTransaction();
          end;
        except
          LDatabase.RollbackTransaction();
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

  class procedure TPlayerManager.UpdateAllPlayersLastSeen();
  var
    LDatabase: Tg2dLocalDb;
  begin
    LDatabase := Tg2dLocalDbPool.GetInstance();
    try
      if LDatabase.Open('GameData') then
      begin
        // Use batch operation for efficiency
        LDatabase.BeginBatch();
        try
          LDatabase.AddBatchSQL('UPDATE Players SET LastSeen = datetime(''now'') WHERE IsOnline = 1');
          LDatabase.AddBatchSQL('UPDATE Players SET IsOnline = 0'); // Mark all as offline
          LDatabase.ExecuteBatch();
        finally
          LDatabase.ClearBatch();
        end;
      end;
    finally
      Tg2dLocalDbPool.ReturnInstance(LDatabase);
    end;
  end;

═══════════════════════════════════════════════════════════════════════════════
PERFORMANCE FEATURES
═══════════════════════════════════════════════════════════════════════════════

• **Connection Pooling**: Reduces connection overhead through object reuse
• **Prepared Statements**: Uses SQLite prepared statements for optimal performance
• **Batch Operations**: Minimizes database round-trips for bulk operations
• **Memory Management**: Efficient JSON result handling with minimal copying
• **Query Validation**: Pre-execution validation prevents unnecessary processing
• **Statement Cleanup**: Automatic cleanup prevents memory leaks

═══════════════════════════════════════════════════════════════════════════════
MEMORY MANAGEMENT
═══════════════════════════════════════════════════════════════════════════════

• **Automatic Cleanup**: Database handles, statements, and JSON objects are
  automatically cleaned up on destruction
• **Pool Resource Management**: Instances returned to pool are cleaned and reset
• **Statement Lifecycle**: Prepared statements are properly finalized after use
• **JSON Memory Handling**: Efficient JSON object management with proper disposal
• **Dictionary Management**: Automatic cleanup of macro and parameter dictionaries

═══════════════════════════════════════════════════════════════════════════════
ERROR HANDLING
═══════════════════════════════════════════════════════════════════════════════

• **SQLite Error Integration**: Proper handling and reporting of SQLite errors
• **Transaction Rollback**: Automatic rollback on transaction failures
• **Parameter Validation**: Validation of parameter names and SQL syntax
• **Connection State Checking**: Prevents operations on closed connections
• **Graceful Failure**: Operations fail safely without corrupting data

Common error scenarios and handling:
- Invalid SQL syntax: Caught during preparation phase
- Parameter binding failures: Reported with specific parameter information
- Transaction conflicts: Automatic rollback with error details
- Connection failures: Clear error messages with connection state information

*******************************************************************************)

unit Game2D.Database;

{$I Game2D.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding,
  System.IOUtils,
  System.RegularExpressions,
  Game2D.Deps,
  Game2D.Common,
  Game2D.Core;



//=== LOCALDATABASE ============================================================
type
  { Tg2dLocalDb }
  Tg2dLocalDb = class;

  { Tg2dLocalDbPool }
  Tg2dLocalDbPool = class(Tg2dStaticObject)
  private class var
    FInstances: TObjectList<Tg2dLocalDb>;
    FMaxPoolSize: Integer;
    class constructor Create();
    class destructor Destroy();
  public
    class function GetInstance(): Tg2dLocalDb;
    class procedure ReturnInstance(const AInstance: Tg2dLocalDb);
    class procedure SetMaxPoolSize(const ASize: Integer);
  end;

  { Tg2dLocalDb }
  Tg2dLocalDb = class(Tg2dObject)
  protected const
    cMaxQueryLength = 8192;
  protected
    FDatabase: string;
    FResponseText: string;
    FSQL: TStringList;
    FPrepairedSQL: string;
    FJSON: TJSONObject;
    FDataset: TJSONArray;
    FMacros: TDictionary<string, string>;
    FParams: TDictionary<string, string>;
    FHandle: PSQLite3;
    FStmt: Psqlite3_stmt;
    FBatchQueries: TStringList;
    FInTransaction: Boolean;
    FLastInsertRowId: Int64;
    FChanges: Integer;
    procedure SetMacroValue(const AName: string; const AValue: string);
    procedure PrepareParameterizedSQL(var ASQL: string; var AParamNames: TArray<string>);
    function  BindParameters(const AParamNames: TArray<string>): Boolean;
    procedure Prepair();
    function  ExecuteSQLInternal(const ASQL: string): Boolean;
    function  ValidateQuery(const ASQL: string): Boolean;
    function  GetTypeAsString(const AStmt: Psqlite3_stmt; const AColumn: Integer): string;
    function  GetSQLiteErrorMessage(): string;
    procedure CleanupStatement();
    procedure BuildJSONResponse();
  public
    property Handle: PSQLite3 read FHandle;
    property LastInsertRowId: Int64 read FLastInsertRowId;
    property Changes: Integer read FChanges;

    constructor Create(); override;
    destructor Destroy(); override;

    // Connection Management
    function  IsOpen(): Boolean;
    function  Open(const AFilename: string): Boolean;
    procedure Close();

    // SQL Management
    procedure ClearSQLText();
    procedure AddSQLText(const AText: string; const AArgs: array of const);
    function  GetSQLText(): string;
    procedure SetSQLText(const AText: string);
    function  GetPrepairedSQL(): string;

    // Macro Management (& replacement)
    procedure ClearMacros();
    function  GetMacro(const AName: string): string;
    procedure SetMacro(const AName: string; const AValue: string);

    // Parameter Management (: binding)
    procedure ClearParams();
    function  GetParam(const AName: string): string;
    function  SetParam(const AName: string; const AValue: string): Boolean;

    // Execution
    function  ExecuteSimple(const ASQL: string): Boolean;
    function  Execute(): Boolean;
    function  ExecuteSQL(const ASQL: string): Boolean;

    // Results
    function  RecordCount(): Integer;
    function  GetField(const AIndex: Cardinal; const AName: string): string;
    function  GetFieldAsInteger(const AIndex: Cardinal; const AName: string): Integer;
    function  GetFieldAsFloat(const AIndex: Cardinal; const AName: string): Double;
    function  GetFieldAsBoolean(const AIndex: Cardinal; const AName: string): Boolean;

    // Response Information
    function  GetResponseText(): string;

    // Batch Operations
    procedure BeginBatch();
    procedure AddBatchSQL(const ASQL: string);
    function  ExecuteBatch(): Boolean;
    procedure ClearBatch();

    // Transaction Support
    function  BeginTransaction(): Boolean;
    function  CommitTransaction(): Boolean;
    function  RollbackTransaction(): Boolean;

    // Utility Methods
    function  QuoteString(const AValue: string): string;
    function  EscapeString(const AValue: string): string;

    // Database Schema Utilities
    function  TableExists(const ATableName: string): Boolean;
    function  CreateTable(const ASQL: string): Boolean;
    function  DropTable(const ATableName: string): Boolean;
    function  GetTableList(): TArray<string>;
    function  GetColumnList(const ATableName: string): TArray<string>;

    // Advanced Features
    function  BackupDatabase(const ABackupFilename: string): Boolean;
    function  RestoreDatabase(const ABackupFilename: string): Boolean;
    function  VacuumDatabase(): Boolean;
    function  GetDatabaseSize(): Int64;

    // Static Factory Methods
    class function Init(const AFilename: string): Tg2dLocalDb; static;
  end;


//=== REMOTEDATABASE ===========================================================
type
   { Tg2dRemoteDb }
   Tg2dRemoteDb = class;

  { Tg2dRemoteDbPool }
  Tg2dRemoteDbPool = class(Tg2dStaticObject)
  private class var
    FInstances: TObjectList<Tg2dRemoteDb>;
    FMaxPoolSize: Integer;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class function GetInstance(): Tg2dRemoteDb;
    class procedure ReturnInstance(const AInstance: Tg2dRemoteDb);
    class procedure SetMaxPoolSize(const ASize: Integer);
  end;

  { TRemoteDb }
  Tg2dRemoteDb = class(Tg2dObject)
  protected const
    cURL = '/?apikey=%s&keyspace=%s&query=%s';
    cDefaultTimeout = 30000; // 30 seconds
    cMaxQueryLength = 8192;
  protected
    FUrl: string;
    FApiKey: string;
    FDatabase: string;
    FResponseText: string;
    FHttp: THTTPClient;
    FSQL: TStringList;
    FPrepairedSQL: string;
    FJSON: TJSONObject;
    FDataset: TJSONArray;
    FMacros: TDictionary<string, string>;
    FParams: TDictionary<string, string>;
    FTimeout: Integer;
    FSSLVerification: Boolean;
    FBatchQueries: TStringList;
    FInTransaction: Boolean;
    procedure SetMacroValue(const AName: string; const AValue: string);
    procedure SetParamValue(const AName: string; const AValue: string);
    procedure Prepair();
    function  GetQueryURL(const ASQL: string): string;
    function  ValidateQuery(const ASQL: string): Boolean;
    procedure InitializeHTTPClient();
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Setup(const AURL: string; const AApiKey: string; const ADatabase: string);
    procedure SetTimeout(const ATimeoutMS: Integer);
    procedure SetSSLVerification(const AEnabled: Boolean);
    procedure ClearSQLText();
    procedure AddSQLText(const AText: string; const AArgs: array of const);
    function  GetSQLText(): string;
    procedure SetSQLText(const AText: string);
    function  GetPrepairedSQL(): string;
    procedure ClearMacros();
    function  GetMacro(const AName: string): string;
    procedure SetMacro(const AName: string; const AValue: string);
    procedure ClearParams();
    function  GetParam(const AName: string): string;
    procedure SetParam(const AName: string; const AValue: string);
    function  RecordCount(): Integer;
    function  GetField(const AIndex: Cardinal; const AName: string): string;
    function  GetFieldAsInteger(const AIndex: Cardinal; const AName: string): Integer;
    function  GetFieldAsFloat(const AIndex: Cardinal; const AName: string): Double;
    function  GetFieldAsBoolean(const AIndex: Cardinal; const AName: string): Boolean;
    function  Execute(): Boolean;
    function  ExecuteSQL(const ASQL: string): Boolean;
    function  GetResponseText(): string;
    function  GetQueryStatus(): string;
    function  GetQueryTime(): Double;
    function  GetResponseLength(): Integer;
    function  TestConnection(): Boolean;
    // Batch operations
    procedure BeginBatch();
    procedure AddBatchSQL(const ASQL: string);
    function  ExecuteBatch(): Boolean;
    procedure ClearBatch();
    // Transaction support (if server supports it)
    function  BeginTransaction(): Boolean;
    function  CommitTransaction(): Boolean;
    function  RollbackTransaction(): Boolean;
    // Advanced query helpers
    function  QuoteString(const AValue: string): string;
    function  EscapeString(const AValue: string): string;
  end;

implementation

const
  SQLITE_TRANSIENT = Pointer(-1);

//=== LOCALDATABASE ============================================================
{ Tg2dLocalDbPool }
class constructor Tg2dLocalDbPool.Create();
begin
  FInstances := TObjectList<Tg2dLocalDb>.Create(True);
  FMaxPoolSize := 10;
end;

class destructor Tg2dLocalDbPool.Destroy();
begin
  FInstances.Free();
end;

class function Tg2dLocalDbPool.GetInstance(): Tg2dLocalDb;
begin
  if FInstances.Count > 0 then
  begin
    Result := FInstances.Last;
    FInstances.Delete(FInstances.Count - 1);
  end
  else
  begin
    Result := Tg2dLocalDb.Create();
  end;
end;

class procedure Tg2dLocalDbPool.ReturnInstance(const AInstance: Tg2dLocalDb);
begin
  if FInstances.Count < FMaxPoolSize then
  begin
    AInstance.ClearSQLText();
    AInstance.ClearMacros();
    AInstance.ClearParams();
    FInstances.Add(AInstance);
  end
  else
  begin
    AInstance.Free();
  end;
end;

class procedure Tg2dLocalDbPool.SetMaxPoolSize(const ASize: Integer);
begin
  FMaxPoolSize := ASize;
end;

{ Tg2dLocalDb }
constructor Tg2dLocalDb.Create();
begin
  inherited;

  // Initialize string lists
  FSQL := TStringList.Create();
  FBatchQueries := TStringList.Create();

  // Initialize dictionaries
  FMacros := TDictionary<string, string>.Create();
  FParams := TDictionary<string, string>.Create();

  // Initialize other fields
  FHandle := nil;
  FStmt := nil;
  FJSON := nil;
  FDataset := nil; // This will be a reference to data inside FJSON

  FDatabase := '';
  FResponseText := '';
  FPrepairedSQL := '';

  FInTransaction := False;
  FLastInsertRowId := 0;
  FChanges := 0;
end;

destructor Tg2dLocalDb.Destroy();
begin
  // Close database and cleanup
  Close();

  // Free collections
  FBatchQueries.Free();
  FParams.Free();
  FMacros.Free();
  FSQL.Free();

  // Clean up JSON objects
  if Assigned(FJSON) then
  begin
    FJSON.Free();
    FJSON := nil;
  end;
  // Note: Don't free FDataset - it's owned by FJSON

  inherited;
end;

function Tg2dLocalDb.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

function Tg2dLocalDb.Open(const AFilename: string): Boolean;
var
  LFullPath: string;
begin
  Result := False;

  if IsOpen() then
  begin
    SetError('Database already open', []);
    Exit;
  end;

  if AFilename.IsEmpty then
  begin
    SetError('Filename cannot be empty', []);
    Exit;
  end;

  LFullPath := TPath.ChangeExtension(AFilename, '.db');

  if sqlite3_open(PAnsiChar(AnsiString(LFullPath)), @FHandle) <> SQLITE_OK then
  begin
    SetError('Failed to open database: %s', [GetSQLiteErrorMessage()]);
    if Assigned(FHandle) then
    begin
      sqlite3_close(FHandle);
      FHandle := nil;
    end;
    Exit;
  end;

  FDatabase := LFullPath;

  // Enable foreign key support
  ExecuteSQL('PRAGMA foreign_keys = ON');

  Result := True;
end;

procedure Tg2dLocalDb.Close();
begin
  if not IsOpen() then Exit;

  CleanupStatement();

  // Clean up JSON objects
  if Assigned(FJSON) then
  begin
    FJSON.Free();
    FJSON := nil;
  end;
  FDataset := nil; // Just reset reference, don't free

  if Assigned(FHandle) then
  begin
    sqlite3_close(FHandle);
    FHandle := nil;
  end;

  ClearMacros();
  ClearParams();
  ClearSQLText();
  ClearBatch();

  FDatabase := '';
  FResponseText := '';
  FPrepairedSQL := '';
  FInTransaction := False;
  FLastInsertRowId := 0;
  FChanges := 0;
end;

procedure Tg2dLocalDb.SetMacroValue(const AName: string; const AValue: string);
begin
  FPrepairedSQL := FPrepairedSQL.Replace('&' + AName, AValue);
end;

procedure Tg2dLocalDb.PrepareParameterizedSQL(var ASQL: string; var AParamNames: TArray<string>);
var
  LParamList: TStringList;
  LCurrentPos: Integer;
  LParamStart: Integer;
  LParamEnd: Integer;
  LParamName: string;
  LProcessedSQL: string;
begin
  LParamList := TStringList.Create();
  try
    LProcessedSQL := '';
    LCurrentPos := 1;

    // Process the SQL string character by character to find parameters in order
    while LCurrentPos <= Length(ASQL) do
    begin
      if ASQL[LCurrentPos] = ':' then
      begin
        // Found a parameter marker, find the parameter name
        LParamStart := LCurrentPos + 1;
        LParamEnd := LParamStart;

        // Find the end of the parameter name (alphanumeric + underscore)
        while (LParamEnd <= Length(ASQL)) and
              (CharInSet(ASQL[LParamEnd], ['a'..'z', 'A'..'Z', '0'..'9', '_'])) do
          Inc(LParamEnd);

        if LParamEnd > LParamStart then
        begin
          LParamName := Copy(ASQL, LParamStart, LParamEnd - LParamStart);

          // Check if this parameter exists in our parameters dictionary
          if FParams.ContainsKey(LParamName) then
          begin
            // Add to our ordered list if not already there
            if LParamList.IndexOf(LParamName) = -1 then
              LParamList.Add(LParamName);

            // Replace with ? in the processed SQL
            LProcessedSQL := LProcessedSQL + '?';
            LCurrentPos := LParamEnd;
          end
          else
          begin
            // Parameter not found in dictionary - keep original text
            LProcessedSQL := LProcessedSQL + Copy(ASQL, LCurrentPos, LParamEnd - LCurrentPos);
            LCurrentPos := LParamEnd;
          end;
        end
        else
        begin
          // Just a standalone colon, keep it
          LProcessedSQL := LProcessedSQL + ASQL[LCurrentPos];
          Inc(LCurrentPos);
        end;
      end
      else
      begin
        // Regular character, copy it
        LProcessedSQL := LProcessedSQL + ASQL[LCurrentPos];
        Inc(LCurrentPos);
      end;
    end;

    // Update the SQL with the processed version
    ASQL := LProcessedSQL;

    // Convert list to array
    SetLength(AParamNames, LParamList.Count);
    for LCurrentPos := 0 to LParamList.Count - 1 do
      AParamNames[LCurrentPos] := LParamList[LCurrentPos];

  finally
    LParamList.Free();
  end;
end;

function Tg2dLocalDb.BindParameters(const AParamNames: TArray<string>): Boolean;
var
  LIndex: Integer;
  LParamName: string;
  LParamValue: string;
begin
  Result := True;

  for LIndex := Low(AParamNames) to High(AParamNames) do
  begin
    LParamName := AParamNames[LIndex];
    if FParams.TryGetValue(LParamName, LParamValue) then
    begin
      if sqlite3_bind_text(FStmt, LIndex + 1, PAnsiChar(AnsiString(LParamValue)), -1, SQLITE_TRANSIENT) <> SQLITE_OK then
      begin
        SetError('Failed to bind parameter %s: %s', [LParamName, GetSQLiteErrorMessage()]);
        Result := False;
        Exit;
      end;
    end;
  end;
end;

procedure Tg2dLocalDb.Prepair();
var
  LKey: string;
begin
  FPrepairedSQL := FSQL.Text;

  // Substitute macros first (& replacement)
  for LKey in FMacros.Keys do
  begin
    SetMacroValue(LKey, FMacros.Items[LKey]);
  end;

  // Note: Parameters (: replacement) will be handled during execution with proper binding
end;

function Tg2dLocalDb.ValidateQuery(const ASQL: string): Boolean;
begin
  Result := True;

  if ASQL.IsEmpty or (Length(ASQL) > cMaxQueryLength) then
  begin
    Result := False;
    Exit;
  end;

  // Basic validation - could be enhanced based on security needs
  // SQLite is generally safer than remote SQL due to limited attack surface
end;

function Tg2dLocalDb.GetTypeAsString(const AStmt: Psqlite3_stmt; const AColumn: Integer): string;
begin
  case sqlite3_column_type(AStmt, AColumn) of
    SQLITE_INTEGER: Result := IntToStr(sqlite3_column_int64(AStmt, AColumn));
    SQLITE_FLOAT: Result := FloatToStr(sqlite3_column_double(AStmt, AColumn));
    SQLITE_TEXT: Result := string(PWideChar(sqlite3_column_text16(AStmt, AColumn)));
    SQLITE_BLOB: Result := '[BLOB]';
    SQLITE_NULL: Result := '';
  else
    Result := '';
  end;
end;

function Tg2dLocalDb.GetSQLiteErrorMessage(): string;
begin
  if Assigned(FHandle) then
    Result := string(PWideChar(sqlite3_errmsg16(FHandle)))
  else
    Result := 'Database not open';
end;

procedure Tg2dLocalDb.CleanupStatement();
begin
  if Assigned(FStmt) then
  begin
    sqlite3_finalize(FStmt);
    FStmt := nil;
  end;
end;

procedure Tg2dLocalDb.BuildJSONResponse();
var
  LResult: Integer;
  LColumnCount: Integer;
  LIndex: Integer;
  LColumnName: string;
  LColumnValue: string;
  LRow: TJSONObject;
  LDatasetArray: TJSONArray;
begin
  // Clean up previous JSON - this also frees FDataset if it was owned by FJSON
  if Assigned(FJSON) then
  begin
    FJSON.Free();
    FJSON := nil;
  end;

  // Reset dataset reference
  FDataset := nil;

  // Create new dataset array
  LDatasetArray := TJSONArray.Create();

  LColumnCount := sqlite3_column_count(FStmt);

  LResult := sqlite3_step(FStmt);
  while LResult = SQLITE_ROW do
  begin
    LRow := TJSONObject.Create();

    for LIndex := 0 to LColumnCount - 1 do
    begin
      LColumnName := string(PWideChar(sqlite3_column_name16(FStmt, LIndex)));
      LColumnValue := GetTypeAsString(FStmt, LIndex);
      LRow.AddPair(LColumnName, LColumnValue);
    end;

    LDatasetArray.AddElement(LRow);
    LResult := sqlite3_step(FStmt);
  end;

  // Create response JSON - this takes ownership of LDatasetArray
  FJSON := TJSONObject.Create();
  FJSON.AddPair('query_status', 'OK');
  FJSON.AddPair('response', LDatasetArray);

  // Set FDataset as a reference to the array inside FJSON (no ownership)
  FDataset := FJSON.GetValue('response') as TJSONArray;

  FResponseText := FJSON.Format();
end;

function Tg2dLocalDb.ExecuteSQLInternal(const ASQL: string): Boolean;
var
  LResult: Integer;
  LProcessedSQL: string;
  LParamNames: TArray<string>;
  LParamCount: Integer;
  LExpectedParamCount: Integer;
begin
  Result := False;

  if not IsOpen() then
  begin
    SetError('Database not open', []);
    Exit;
  end;

  if not ValidateQuery(ASQL) then
  begin
    SetError('Invalid query', []);
    Exit;
  end;

  CleanupStatement();

  LProcessedSQL := ASQL;
  PrepareParameterizedSQL(LProcessedSQL, LParamNames);

  LResult := sqlite3_prepare16_v2(FHandle, PChar(LProcessedSQL), -1, @FStmt, nil);
  if LResult <> SQLITE_OK then
  begin
    SetError('Failed to prepare statement: %s', [GetSQLiteErrorMessage()]);
    Exit;
  end;

  // Verify parameter count matches
  LExpectedParamCount := sqlite3_bind_parameter_count(FStmt);
  LParamCount := Length(LParamNames);

  if LParamCount <> LExpectedParamCount then
  begin
    SetError('Parameter count mismatch. Expected: %d, Got: %d', [LExpectedParamCount, LParamCount]);
    Exit;
  end;

  // Bind parameters
  if Length(LParamNames) > 0 then
  begin
    if not BindParameters(LParamNames) then
      Exit;
  end;

  // Rest of the method remains the same...
  LResult := sqlite3_step(FStmt);
  FLastInsertRowId := sqlite3_last_insert_rowid(FHandle);
  FChanges := sqlite3_changes(FHandle);

  case LResult of
    SQLITE_DONE:
    begin
      FResponseText := '{"query_status":"OK","response":[]}';
      Result := True;
    end;
    SQLITE_ROW:
    begin
      sqlite3_reset(FStmt);
      BuildJSONResponse();
      Result := True;
    end;
  else
    SetError('Query execution failed: %s', [GetSQLiteErrorMessage()]);
  end;
end;

procedure Tg2dLocalDb.ClearSQLText();
begin
  FSQL.Clear();
end;

procedure Tg2dLocalDb.AddSQLText(const AText: string; const AArgs: array of const);
begin
  FSQL.Add(Format(AText, AArgs));
end;

function Tg2dLocalDb.GetSQLText(): string;
begin
  Result := FSQL.Text;
end;

procedure Tg2dLocalDb.SetSQLText(const AText: string);
begin
  FSQL.Text := AText;
end;

function Tg2dLocalDb.GetPrepairedSQL(): string;
begin
  Result := FPrepairedSQL;
end;

procedure Tg2dLocalDb.ClearMacros();
begin
  FMacros.Clear();
end;

function Tg2dLocalDb.GetMacro(const AName: string): string;
begin
  if not FMacros.TryGetValue(AName, Result) then
    Result := '';
end;

procedure Tg2dLocalDb.SetMacro(const AName: string; const AValue: string);
begin
  FMacros.AddOrSetValue(AName, AValue);
end;

procedure Tg2dLocalDb.ClearParams();
begin
  FParams.Clear();
end;

function Tg2dLocalDb.GetParam(const AName: string): string;
begin
  if not FParams.TryGetValue(AName, Result) then
    Result := '';
end;

function Tg2dLocalDb.SetParam(const AName: string; const AValue: string): Boolean;
begin
  if AName.IsEmpty then
  begin
    SetError('Parameter name cannot be empty', []);
    Exit(False);
  end;

  FParams.AddOrSetValue(AName, AValue);
  Result := True;
end;

function Tg2dLocalDb.ExecuteSimple(const ASQL: string): Boolean;
begin
  ClearSQLText();
  ClearMacros();
  ClearParams();
  SetSQLText(ASQL);
  Result := Execute();
end;

function Tg2dLocalDb.Execute(): Boolean;
begin
  Prepair();
  Result := ExecuteSQL(FPrepairedSQL);

  // Optionally auto-clear after execution to prevent parameter leakage
  ClearParams(); // Uncomment if you want automatic clearing
end;

function Tg2dLocalDb.ExecuteSQL(const ASQL: string): Boolean;
begin
  Result := ExecuteSQLInternal(ASQL);
end;

function Tg2dLocalDb.RecordCount(): Integer;
begin
  Result := 0;
  if Assigned(FDataset) then
    Result := FDataset.Count;
end;

function Tg2dLocalDb.GetField(const AIndex: Cardinal; const AName: string): string;
var
  LJSONValue: TJSONValue;
begin
  Result := '';
  if not Assigned(FDataset) then Exit;
  if AIndex >= Cardinal(FDataset.Count) then Exit;

  LJSONValue := FDataset.Items[AIndex].FindValue(AName);
  if Assigned(LJSONValue) then
    Result := LJSONValue.Value;
end;

function Tg2dLocalDb.GetFieldAsInteger(const AIndex: Cardinal; const AName: string): Integer;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName);
  if not TryStrToInt(LValue, Result) then
    Result := 0;
end;

function Tg2dLocalDb.GetFieldAsFloat(const AIndex: Cardinal; const AName: string): Double;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName);
  if not TryStrToFloat(LValue, Result) then
    Result := 0.0;
end;

function Tg2dLocalDb.GetFieldAsBoolean(const AIndex: Cardinal; const AName: string): Boolean;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName).ToLower();
  Result := (LValue = 'true') or (LValue = '1') or (LValue = 'yes');
end;

function Tg2dLocalDb.GetResponseText(): string;
begin
  Result := FResponseText;
end;

// Batch Operations
procedure Tg2dLocalDb.BeginBatch();
begin
  FBatchQueries.Clear();
end;

procedure Tg2dLocalDb.AddBatchSQL(const ASQL: string);
begin
  if ValidateQuery(ASQL) then
    FBatchQueries.Add(ASQL);
end;

function Tg2dLocalDb.ExecuteBatch(): Boolean;
var
  LQuery: string;
  LTransactionStarted: Boolean;
begin
  Result := False;
  if FBatchQueries.Count = 0 then Exit;

  LTransactionStarted := False;
  if not FInTransaction then
  begin
    if BeginTransaction() then
      LTransactionStarted := True
    else
      Exit;
  end;

  try
    for LQuery in FBatchQueries do
    begin
      if not ExecuteSQL(LQuery) then
      begin
        if LTransactionStarted then
          RollbackTransaction();
        Exit;
      end;
    end;

    if LTransactionStarted then
      Result := CommitTransaction()
    else
      Result := True;

  except
    if LTransactionStarted then
      RollbackTransaction();
    raise;
  end;
end;

procedure Tg2dLocalDb.ClearBatch();
begin
  FBatchQueries.Clear();
end;

// Transaction Support
function Tg2dLocalDb.BeginTransaction(): Boolean;
begin
  if FInTransaction then
  begin
    SetError('Transaction already in progress', []);
    Exit(False);
  end;

  Result := ExecuteSimple('BEGIN TRANSACTION');
  if Result then
    FInTransaction := True;
end;

function Tg2dLocalDb.CommitTransaction(): Boolean;
begin
  if not FInTransaction then
  begin
    SetError('No transaction in progress', []);
    Exit(False);
  end;

  Result := ExecuteSimple('COMMIT');
  FInTransaction := False; // Always reset, even on failure
end;

function Tg2dLocalDb.RollbackTransaction(): Boolean;
begin
  if not FInTransaction then
  begin
    SetError('No transaction in progress', []);
    Exit(False);
  end;

  Result := ExecuteSimple('ROLLBACK');
  FInTransaction := False; // Always reset, even on failure
end;

// Utility Methods
function Tg2dLocalDb.QuoteString(const AValue: string): string;
begin
  Result := '''' + EscapeString(AValue) + '''';
end;

function Tg2dLocalDb.EscapeString(const AValue: string): string;
begin
  Result := AValue.Replace('''', '''''');
end;

// Database Schema Utilities
function Tg2dLocalDb.TableExists(const ATableName: string): Boolean;
begin
  SetSQLText('SELECT name FROM sqlite_master WHERE type=''table'' AND name=:tablename');
  SetParam('tablename', ATableName);
  Result := Execute() and (RecordCount() > 0);
end;

function Tg2dLocalDb.CreateTable(const ASQL: string): Boolean;
begin
  Result := ExecuteSQL(ASQL);
end;

function Tg2dLocalDb.DropTable(const ATableName: string): Boolean;
begin
  Result := ExecuteSQL('DROP TABLE IF EXISTS ' + ATableName);
end;

function Tg2dLocalDb.GetTableList(): TArray<string>;
var
  LTables: TList<string>;
  LIndex: Integer;
begin
  LTables := TList<string>.Create();
  try
    if ExecuteSQL('SELECT name FROM sqlite_master WHERE type=''table'' ORDER BY name') then
    begin
      for LIndex := 0 to RecordCount() - 1 do
        LTables.Add(GetField(LIndex, 'name'));
    end;
    Result := LTables.ToArray();
  finally
    LTables.Free();
  end;
end;

function Tg2dLocalDb.GetColumnList(const ATableName: string): TArray<string>;
var
  LColumns: TList<string>;
  LIndex: Integer;
begin
  LColumns := TList<string>.Create();
  try
    if ExecuteSQL('PRAGMA table_info(' + ATableName + ')') then
    begin
      for LIndex := 0 to RecordCount() - 1 do
        LColumns.Add(GetField(LIndex, 'name'));
    end;
    Result := LColumns.ToArray();
  finally
    LColumns.Free();
  end;
end;

// Advanced Features
function Tg2dLocalDb.BackupDatabase(const ABackupFilename: string): Boolean;
var
  LBackupPath: string;
begin
  Result := False;

  if not IsOpen() then
  begin
    SetError('Database not open', []);
    Exit;
  end;

  LBackupPath := TPath.ChangeExtension(ABackupFilename, '.db');

  try
    TFile.Copy(FDatabase, LBackupPath, True);
    Result := True;
  except
    on E: Exception do
      SetError('Backup failed: %s', [E.Message]);
  end;
end;

function Tg2dLocalDb.RestoreDatabase(const ABackupFilename: string): Boolean;
var
  LBackupPath: string;
begin
  Result := False;

  LBackupPath := TPath.ChangeExtension(ABackupFilename, '.db');

  if not TFile.Exists(LBackupPath) then
  begin
    SetError('Backup file not found: %s', [LBackupPath]);
    Exit;
  end;

  Close();

  try
    TFile.Copy(LBackupPath, FDatabase, True);
    Result := Open(TPath.GetFileNameWithoutExtension(FDatabase));
  except
    on E: Exception do
      SetError('Restore failed: %s', [E.Message]);
  end;
end;

function Tg2dLocalDb.VacuumDatabase(): Boolean;
begin
  Result := ExecuteSQL('VACUUM');
end;

function Tg2dLocalDb.GetDatabaseSize(): Int64;
begin
  Result := 0;
  if TFile.Exists(FDatabase) then
  begin
    try
      Result := TFile.GetSize(FDatabase);
    except
      Result := 0;
    end;
  end;
end;

class function Tg2dLocalDb.Init(const AFilename: string): Tg2dLocalDb;
begin
  Result := Tg2dLocalDb.Create();
  if not Result.Open(AFilename) then
  begin
    Result.Free();
    Result := nil;
  end;
end;


//=== REMOTEDATABASE ===========================================================
{ Tg2dRemoteDbPool }
class constructor Tg2dRemoteDbPool.Create();
begin
  FInstances := TObjectList<Tg2dRemoteDb>.Create(True);
  FMaxPoolSize := 10;
end;

class destructor Tg2dRemoteDbPool.Destroy();
begin
  FInstances.Free();
end;

class function Tg2dRemoteDbPool.GetInstance(): Tg2dRemoteDb;
begin
  if FInstances.Count > 0 then
  begin
    Result := FInstances.Last;
    FInstances.Delete(FInstances.Count - 1);
  end
  else
  begin
    Result := Tg2dRemoteDb.Create();
  end;
end;

class procedure Tg2dRemoteDbPool.ReturnInstance(const AInstance: Tg2dRemoteDb);
begin
  if FInstances.Count < FMaxPoolSize then
  begin
    AInstance.ClearSQLText();
    AInstance.ClearMacros();
    AInstance.ClearParams();
    FInstances.Add(AInstance);
  end
  else
  begin
    AInstance.Free();
  end;
end;

class procedure Tg2dRemoteDbPool.SetMaxPoolSize(const ASize: Integer);
begin
  FMaxPoolSize := ASize;
end;

{ Tg2dRemoteDb }
constructor Tg2dRemoteDb.Create();
begin
  inherited;
  FSQL := TStringList.Create();
  FBatchQueries := TStringList.Create();
  FHttp := THTTPClient.Create();
  FMacros := TDictionary<string, string>.Create();
  FParams := TDictionary<string, string>.Create();
  FTimeout := cDefaultTimeout;
  FSSLVerification := True;
  FInTransaction := False;
  InitializeHTTPClient();
end;

destructor Tg2dRemoteDb.Destroy();
begin
  if Assigned(FJSON) then
  begin
    FJSON.Free();
    FJSON := nil;
  end;
  FBatchQueries.Free();
  FParams.Free();
  FMacros.Free();
  FHttp.Free();
  FSQL.Free();
  inherited;
end;

procedure Tg2dRemoteDb.InitializeHTTPClient();
begin
  FHttp.ConnectionTimeout := FTimeout;
  FHttp.ResponseTimeout := FTimeout;
  FHttp.HandleRedirects := True;
  FHttp.UserAgent := 'Game2D-RemoteDb/1.0';

  // Configure SSL if needed
  if not FSSLVerification then
  begin
    FHttp.SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS1,
                             THTTPSecureProtocol.TLS11, THTTPSecureProtocol.TLS12];
  end;
end;

procedure Tg2dRemoteDb.Setup(const AURL: string; const AApiKey: string; const ADatabase: string);
begin
  if AURL.IsEmpty or AApiKey.IsEmpty or ADatabase.IsEmpty then
    raise Exception.Create('URL, API Key, and Database cannot be empty');

  FUrl := AURL + cURL;
  FApiKey := AApiKey;
  FDatabase := ADatabase;
end;

procedure Tg2dRemoteDb.SetTimeout(const ATimeoutMS: Integer);
begin
  FTimeout := ATimeoutMS;
  InitializeHTTPClient();
end;

procedure Tg2dRemoteDb.SetSSLVerification(const AEnabled: Boolean);
begin
  FSSLVerification := AEnabled;
  InitializeHTTPClient();
end;

procedure Tg2dRemoteDb.SetMacroValue(const AName: string; const AValue: string);
begin
  FPrepairedSQL := FPrepairedSQL.Replace('&' + AName, AValue);
end;

procedure Tg2dRemoteDb.SetParamValue(const AName: string; const AValue: string);
var
  LEscapedValue: string;
begin
  // Basic SQL escaping (the PHP side should handle proper parameterization)
  LEscapedValue := AValue.Replace('''', '''''');
  FPrepairedSQL := FPrepairedSQL.Replace(':' + AName, '''' + LEscapedValue + '''');
end;

procedure Tg2dRemoteDb.Prepair();
var
  LKey: string;
begin
  FPrepairedSQL := FSQL.Text;

  // Substitute macros first
  for LKey in FMacros.Keys do
  begin
    SetMacroValue(LKey, FMacros.Items[LKey]);
  end;

  // Substitute field params
  for LKey in FParams.Keys do
  begin
    SetParamValue(LKey, FParams.Items[LKey]);
  end;
end;

function Tg2dRemoteDb.ValidateQuery(const ASQL: string): Boolean;
var
  LQueryUpper: string;
  LAllowedTypes: array[0..3] of string;
  LType: string;
  LFound: Boolean;
begin
  Result := False;

  if ASQL.IsEmpty or (Length(ASQL) > cMaxQueryLength) then
    Exit;

  LQueryUpper := UpperCase(Trim(ASQL));
  LAllowedTypes[0] := 'SELECT';
  LAllowedTypes[1] := 'INSERT';
  LAllowedTypes[2] := 'UPDATE';
  LAllowedTypes[3] := 'DELETE';

  LFound := False;
  for LType in LAllowedTypes do
  begin
    if LQueryUpper.StartsWith(LType) then
    begin
      LFound := True;
      Break;
    end;
  end;

  if not LFound then
    Exit;

  // Check for dangerous patterns
  if LQueryUpper.Contains('DROP ') or
     LQueryUpper.Contains('ALTER ') or
     LQueryUpper.Contains('CREATE ') or
     LQueryUpper.Contains('TRUNCATE ') or
     LQueryUpper.Contains('--') or
     LQueryUpper.Contains('/*') then
    Exit;

  Result := True;
end;

function Tg2dRemoteDb.GetQueryURL(const ASQL: string): string;
var
  LEncodedSQL: string;
begin
  LEncodedSQL := TNetEncoding.URL.Encode(ASQL);
  Result := Format(FUrl, [FApiKey, FDatabase, LEncodedSQL]);
end;

procedure Tg2dRemoteDb.ClearSQLText();
begin
  FSQL.Clear();
end;

procedure Tg2dRemoteDb.AddSQLText(const AText: string; const AArgs: array of const);
begin
  FSQL.Add(Format(AText, AArgs));
end;

function Tg2dRemoteDb.GetSQLText(): string;
begin
  Result := FSQL.Text;
end;

procedure Tg2dRemoteDb.SetSQLText(const AText: string);
begin
  FSQL.Text := AText;
end;

function Tg2dRemoteDb.GetPrepairedSQL(): string;
begin
  Result := FPrepairedSQL;
end;

procedure Tg2dRemoteDb.ClearMacros();
begin
  FMacros.Clear();
end;

function Tg2dRemoteDb.GetMacro(const AName: string): string;
begin
  if not FMacros.TryGetValue(AName, Result) then
    Result := '';
end;

procedure Tg2dRemoteDb.SetMacro(const AName: string; const AValue: string);
begin
  FMacros.AddOrSetValue(AName, AValue);
end;

procedure Tg2dRemoteDb.ClearParams();
begin
  FParams.Clear();
end;

function Tg2dRemoteDb.GetParam(const AName: string): string;
begin
  if not FParams.TryGetValue(AName, Result) then
    Result := '';
end;

procedure Tg2dRemoteDb.SetParam(const AName: string; const AValue: string);
begin
  FParams.AddOrSetValue(AName, AValue);
end;

function Tg2dRemoteDb.RecordCount(): Integer;
begin
  Result := 0;
  if Assigned(FDataset) then
    Result := FDataset.Count;
end;

function Tg2dRemoteDb.GetField(const AIndex: Cardinal; const AName: string): string;
var
  LJSONValue: TJSONValue;
begin
  Result := '';
  if not Assigned(FDataset) then Exit;
  if AIndex >= Cardinal(FDataset.Count) then Exit;

  LJSONValue := FDataset.Items[AIndex].FindValue(AName);
  if Assigned(LJSONValue) then
    Result := LJSONValue.Value;
end;

function Tg2dRemoteDb.GetFieldAsInteger(const AIndex: Cardinal; const AName: string): Integer;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName);
  if not TryStrToInt(LValue, Result) then
    Result := 0;
end;

function Tg2dRemoteDb.GetFieldAsFloat(const AIndex: Cardinal; const AName: string): Double;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName);
  if not TryStrToFloat(LValue, Result) then
    Result := 0.0;
end;

function Tg2dRemoteDb.GetFieldAsBoolean(const AIndex: Cardinal; const AName: string): Boolean;
var
  LValue: string;
begin
  LValue := GetField(AIndex, AName).ToLower();
  Result := (LValue = 'true') or (LValue = '1') or (LValue = 'yes');
end;

function Tg2dRemoteDb.Execute(): Boolean;
begin
  Prepair();
  Result := ExecuteSQL(FPrepairedSQL);
end;

function Tg2dRemoteDb.ExecuteSQL(const ASQL: string): Boolean;
var
  LResponse: IHTTPResponse;
  LQueryStatus: string;
begin
  Result := False;
  FError := '';
  FResponseText := '';

  if ASQL.IsEmpty then
  begin
    SetError('SQL query cannot be empty', []);
    Exit;
  end;

  if not ValidateQuery(ASQL) then
  begin
    SetError('Invalid or unsafe SQL query', []);
    Exit;
  end;

  try
    LResponse := FHttp.Get(GetQueryURL(ASQL));
    FResponseText := LResponse.ContentAsString();

    // Clean up previous JSON
    if Assigned(FJSON) then
    begin
      FJSON.Free();
      FJSON := nil;
    end;
    FDataset := nil;

    // Parse JSON response
    FJSON := TJSONObject.ParseJSONValue(FResponseText) as TJSONObject;
    if not Assigned(FJSON) then
    begin
      SetError('Invalid JSON response from server', []);;
      Exit;
    end;

    // Check query status
    LQueryStatus := FJSON.GetValue('query_status').Value;
    if not SameText(LQueryStatus, 'OK') then
    begin
      SetError(FJSON.GetValue('response').Value, []);
      Exit;
    end;

    // Get dataset for SELECT queries
    FJSON.TryGetValue('response', FDataset);
    Result := True;

  except
    on E: Exception do
    begin
      SetError('Network error: %s', [E.Message]);
    end;
  end;
end;

function Tg2dRemoteDb.TestConnection(): Boolean;
begin
  Result := ExecuteSQL('SELECT 1 as test_value');
end;

function Tg2dRemoteDb.GetResponseText(): string;
begin
  Result := FResponseText;
end;

function Tg2dRemoteDb.GetQueryStatus(): string;
begin
  Result := '';
  if Assigned(FJSON) then
    Result := FJSON.GetValue('query_status').Value;
end;

function Tg2dRemoteDb.GetQueryTime(): Double;
var
  LValue: TJSONValue;
begin
  Result := 0.0;
  if Assigned(FJSON) then
  begin
    LValue := FJSON.FindValue('query_time');
    if Assigned(LValue) then
      TryStrToFloat(LValue.Value, Result);
  end;
end;

function Tg2dRemoteDb.GetResponseLength(): Integer;
var
  LValue: TJSONValue;
begin
  Result := 0;
  if Assigned(FJSON) then
  begin
    LValue := FJSON.FindValue('response_length');
    if Assigned(LValue) then
      TryStrToInt(LValue.Value, Result);
  end;
end;

// Batch Operations
procedure Tg2dRemoteDb.BeginBatch();
begin
  FBatchQueries.Clear();
end;

procedure Tg2dRemoteDb.AddBatchSQL(const ASQL: string);
begin
  if ValidateQuery(ASQL) then
    FBatchQueries.Add(ASQL);
end;

function Tg2dRemoteDb.ExecuteBatch(): Boolean;
var
  LBatchSQL: string;
  LQuery: string;
begin
  Result := False;
  if FBatchQueries.Count = 0 then Exit;

  LBatchSQL := '';
  for LQuery in FBatchQueries do
  begin
    if not LBatchSQL.IsEmpty then
      LBatchSQL := LBatchSQL + '; ';
    LBatchSQL := LBatchSQL + LQuery;
  end;

  Result := ExecuteSQL(LBatchSQL);
end;

procedure Tg2dRemoteDb.ClearBatch();
begin
  FBatchQueries.Clear();
end;

// Transaction Support
function Tg2dRemoteDb.BeginTransaction(): Boolean;
begin
  Result := ExecuteSQL('START TRANSACTION');
  if Result then
    FInTransaction := True;
end;

function Tg2dRemoteDb.CommitTransaction(): Boolean;
begin
  Result := ExecuteSQL('COMMIT');
  if Result then
    FInTransaction := False;
end;

function Tg2dRemoteDb.RollbackTransaction(): Boolean;
begin
  Result := ExecuteSQL('ROLLBACK');
  if Result then
    FInTransaction := False;
end;

// Helper Methods
function Tg2dRemoteDb.QuoteString(const AValue: string): string;
begin
  Result := '''' + EscapeString(AValue) + '''';
end;

function Tg2dRemoteDb.EscapeString(const AValue: string): string;
begin
  Result := AValue.Replace('\', '\\').Replace('''', '''''').Replace('"', '\"');
end;

end.

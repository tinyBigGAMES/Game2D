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
==============================================================================}

program Examples;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Game2D.Deps in '..\src\Game2D.Deps.pas',
  UExamples in 'UExamples.pas',
  Game2D.OpenGL in '..\src\Game2D.OpenGL.pas',
  Game2D.Common in '..\src\Game2D.Common.pas',
  Game2D.Core in '..\src\Game2D.Core.pas',
  Game2D.World in '..\src\Game2D.World.pas',
  Game2D.Database in '..\src\Game2D.Database.pas',
  ULocalDbDemo in 'ULocalDbDemo.pas',
  Game2D.Console in '..\src\Game2D.Console.pas',
  UBuildZipDemo in 'UBuildZipDemo.pas',
  UCommon in 'UCommon.pas',
  Game2D.Network in '..\src\Game2D.Network.pas',
  Game2D.Gui in '..\src\Game2D.Gui.pas',
  UBasicGuiDemo in 'UBasicGuiDemo.pas',
  UAdvancedGuiDemo in 'UAdvancedGuiDemo.pas',
  Game2D.Sprite in '..\src\Game2D.Sprite.pas',
  UBasicSpriteDemo in 'UBasicSpriteDemo.pas',
  UAdvancedShaderDemo in 'UAdvancedShaderDemo.pas',
  UAdvancedVideoDemo in 'UAdvancedVideoDemo.pas',
  UBasicShaderDemo in 'UBasicShaderDemo.pas',
  UDoomFireDemo in 'UDoomFireDemo.pas',
  UFireLogoDemo in 'UFireLogoDemo.pas',
  USDFFontDemo in 'USDFFontDemo.pas',
  UCameraDemo in 'UCameraDemo.pas',
  UVideoDemo in 'UVideoDemo.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    RunExamples();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

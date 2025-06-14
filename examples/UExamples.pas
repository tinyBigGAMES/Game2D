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

unit UExamples;

interface

procedure RunExamples();

implementation

uses
  System.SysUtils,
  Game2D.Core,
  Game2D.Console,
  UBuildZipDemo,
  ULocalDbDemo,
  UBasicGuiDemo,
  UAdvancedGuiDemo,
  UBasicSpriteDemo,
  UBasicShaderDemo,
  UAdvancedShaderDemo,
  UVideoDemo,
  UAdvancedVideoDemo,
  UDoomFireDemo,
  UFireLogoDemo,
  USDFFontDemo,
  UCameraDemo,
  UBasicStructureDemo;

procedure RunExamples();
var
  LMenu: Tg2dTextMenu<TProc>;
  LResult: Tg2dTextMenuResult;
  LItem: Tg2dTextMenuItem<TProc>;
  LDone: Boolean;
begin
  LMenu := Tg2dTextMenu<TProc>.Create();
  try
    LMenu.AddItem(BuildZipDemo, 'Build Zip Demo <--- Run First');
    LMenu.AddItem(BasicStructureDemo, 'Basic Structure Demo');
    LMenu.AddItem(VideoDemo, 'Video Demo');
    LMenu.AddItem(AdvancedVideoDemo, 'Advanced Video Demo');
    LMenu.AddItem(SDFFontDemo, 'SDF Font Demo');
    LMenu.AddItem(CameraDemo, 'Camera Demo');
    LMenu.AddItem(BasicShaderDemo, 'Basic Shader Demo');
    LMenu.AddItem(AdvancedShaderDemo, 'Advanced Shader Demo');
    LMenu.AddItem(DoomFireDemo, 'Doom Fire Demo');
    LMenu.AddItem(FireLogoDemo, 'Fire Logo Demo');
    LMenu.AddItem(LocalDbDemo, 'Local Database Demo');
    LMenu.AddItem(BasicGuiDemo, 'Basic Gui Demo');
    LMenu.AddItem(AdvancedGuiDemo, 'Advanced Gui Demo');
    LMenu.AddItem(BasicSpriteDemo, 'Basic Sprite Demo');

    LDone := False;

    while not LDone do
    begin
      Tg2dConsole.ClearScreen();
      Tg2dConsole.SetForegroundColor(G2D_PURPLE);
      Tg2dConsole.PrintASCIILogo();
      Tg2dConsole.PrintLn();

      LResult := LMenu.Run();

      case LResult of
        mrNone:
        begin
        end;

        mrSelected:
        begin
          LItem := LMenu.GetSelectedItem();
          LItem.Data();
        end;

        mrCanceled:
        begin
          LDone := True;
        end;

        mrError:
        begin
        end;
      end;
    end;

  finally
    LMenu.Free();
  end;
end;

end.

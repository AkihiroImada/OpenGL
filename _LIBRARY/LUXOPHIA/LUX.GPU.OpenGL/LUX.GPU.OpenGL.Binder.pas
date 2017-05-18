﻿unit LUX.GPU.OpenGL.Binder;

interface //#################################################################### ■

uses System.Generics.Collections,
     Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.GPU.OpenGL, LUX.GPU.OpenGL.Buffer.Vert, LUX.GPU.OpenGL.Buffer.Unif;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLVerPlug

     TGLVerPlug = record
     private
     public
       BuffV :IGLBufferV;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLUniPlug

     TGLUniPlug = record
     private
     public
       BuffU :IGLBufferU;
       Start :Integer;
       Count :Integer;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLVerPlugs

     TGLVerPlugs = class( TDictionary<GLuint,TGLVerPlug> )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLUniPlugs

     TGLUniPlugs = class( TDictionary<GLuint,TGLUniPlug> )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPlugerV

     TGLPlugerV = class( TGLObject )
     private
     protected
       _Plugs :TGLVerPlugs;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Plugs :TGLVerPlugs read _Plugs;
       ///// メソッド
       procedure Add( const BindP_:GLuint; const BuffV_:IGLBufferV );
       procedure Use;
       procedure Unuse;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPlugerU

     TGLPlugerU = class( TGLObject )
     private
     protected
       _Plugs :TGLUniPlugs;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Plugs :TGLUniPlugs read _Plugs;
       ///// メソッド
       procedure Add( const BindP_:GLuint;
                      const BuffU_:IGLBufferU;
                      const Start_:Integer = -1;
                      const Count_:Integer = 1 );
       procedure Use;
       procedure Unuse;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLVerPlug

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLUniPlug

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLVerPlugs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLUniPlugs

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPlugerV

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPlugerV.Create;
begin
     inherited;

     _Plugs := TGLVerPlugs.Create;
end;

destructor TGLPlugerV.Destroy;
begin
     _Plugs.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPlugerV.Add( const BindP_:GLuint; const BuffV_:IGLBufferV );
var
   B :TGLVerPlug;
begin
     with B do
     begin
          BuffV := BuffV_;
     end;

     _Plugs.AddOrSetValue( BindP_, B );
end;

//------------------------------------------------------------------------------

procedure TGLPlugerV.Use;
var
   P :TPair<GLuint,TGLVerPlug>;
begin
     for P in _Plugs do
     begin
          with P do Value.BuffV.Use( Key );
     end;
end;

procedure TGLPlugerV.Unuse;
var
   P :TPair<GLuint,TGLVerPlug>;
begin
     for P in _Plugs do
     begin
          with P do Value.BuffV.Unuse( Key );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPlugerU

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPlugerU.Create;
begin
     inherited;

     _Plugs := TGLUniPlugs.Create;
end;

destructor TGLPlugerU.Destroy;
begin
     _Plugs.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPlugerU.Add( const BindP_:GLuint;
                          const BuffU_:IGLBufferU;
                          const Start_:Integer = -1;
                          const Count_:Integer = 1 );
var
   B :TGLUniPlug;
begin
     with B do
     begin
          BuffU := BuffU_;
          Start := Start_;
          Count := Count_;
     end;

     _Plugs.AddOrSetValue( BindP_, B );
end;

//------------------------------------------------------------------------------

procedure TGLPlugerU.Use;
var
   P :TPair<GLuint,TGLUniPlug>;
begin
     for P in _Plugs do
     begin
          with P, Value do
          begin
               if Start = -1 then BuffU.Use( Key )
                             else BuffU.Use( Key, Start, Count );
          end;
     end;
end;

procedure TGLPlugerU.Unuse;
var
   P :TPair<GLuint,TGLUniPlug>;
begin
     for P in _Plugs do
     begin
          with P do Value.BuffU.Unuse( Key );
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
﻿unit LUX.GPU.OpenGL.Engine;

interface //#################################################################### ■

uses System.Generics.Collections,
     Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.GPU.OpenGL, LUX.GPU.OpenGL.Buffer, LUX.GPU.OpenGL.Buffer.Verter,
     LUX.GPU.OpenGL.Buffer.Unifor, LUX.GPU.OpenGL.Shader, LUX.GPU.OpenGL.Progra;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortV

     TGLPortV = record
     private
     public
       Name :String;
       EleN :GLint;
       EleT :GLenum;
       Offs :GLuint;
       /////
       constructor Create( const Name_:String;
                           const EleN_:GLint;
                           const EleT_:GLenum;
                           const Offs_:GLuint = 0 );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortU

     TGLPortU = record
     private
     public
       Name :String;
       /////
       constructor Create( const Name_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortI

     TGLPortI = record
     private
     public
       Name :String;
       /////
       constructor Create( const Name_:String );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsV

     TGLPortsV = class( TGLPorts<TGLPortV> )
     private
     protected
       _Varray :TGLVarray;
       ///// メソッド
       procedure AddPort( const BinP_:GLuint; const Port_:TGLPortV ); override;
       procedure DelPort( const BinP_:GLuint; const Port_:TGLPortV ); override;
     public
       constructor Create( const Progra_:TGLProgra );
       destructor Destroy; override;
       ///// メソッド
       procedure Add( const BinP_:GLuint; const Name_:String;
                                          const EleN_:GLint;
                                          const EleT_:GLenum;
                                          const Offs_:GLuint = 0 );
       procedure Use; override;
       procedure Unuse; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsU

     TGLPortsU = class( TGLPorts<TGLPortU> )
     private
     protected
       ///// メソッド
       procedure AddPort( const BinP_:GLuint; const Port_:TGLPortU ); override;
       procedure DelPort( const BinP_:GLuint; const Port_:TGLPortU ); override;
     public
       ///// メソッド
       procedure Add( const BinP_:GLuint; const Name_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsI

     TGLPortsI = class( TGLPorts<TGLPortI> )
     private
     protected
       ///// メソッド
       procedure AddPort( const BinP_:GLuint; const Port_:TGLPortI ); override;
       procedure DelPort( const BinP_:GLuint; const Port_:TGLPortI ); override;
     public
       ///// メソッド
       procedure Add( const BinP_:GLuint; const Name_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLEngine

     IGLEngine = interface( IGLProgra )
     ['{0B2FDEDE-30D3-439B-AC76-E61F9E028CD0}']
     {protected}
       ///// アクセス
       function GetVerters :TGLPortsV;
       function GetUnifors :TGLPortsU;
       function GetImagers :TGLPortsI;
     {public}
       ///// プロパティ
       property Verters :TGLPortsV read GetVerters;
       property Unifors :TGLPortsU read GetUnifors;
       property Imagers :TGLPortsI read GetImagers;
       ///// メソッド
       procedure Use;
       procedure Unuse;
     end;

     TGLEngine = class( TGLProgra, IGLEngine )
     private
     protected
       _Verters :TGLPortsV;
       _Unifors :TGLPortsU;
       _Imagers :TGLPortsI;
       ///// アクセス
       function GetVerters :TGLPortsV;
       function GetUnifors :TGLPortsU;
       function GetImagers :TGLPortsI;
       ///// イベント
       procedure DoOnLinked; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// プロパティ
       property Verters :TGLPortsV read GetVerters;
       property Unifors :TGLPortsU read GetUnifors;
       property Imagers :TGLPortsI read GetImagers;
       ///// メソッド
       procedure Use; override;
       procedure Unuse; override;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortV

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPortV.Create( const Name_:String;
                             const EleN_:GLint;
                             const EleT_:GLenum;
                             const Offs_:GLuint );
begin
     Name := Name_;
     EleN := EleN_;
     EleT := EleT_;
     Offs := Offs_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortU

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPortU.Create( const Name_:String );
begin
     Name := Name_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortI

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPortI.Create( const Name_:String );
begin
     Name := Name_;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsV

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsV.AddPort( const BinP_:GLuint; const Port_:TGLPortV );
var
   L :GLuint;
begin
     L := _Progra.glGetVertLoca( Port_.Name );

     with _Varray do
     begin
          Bind;

            glEnableVertexAttribArray( L );

            with Port_ do
            begin
                 case EleT of
                 GL_INT   :glVertexAttribIFormat( L, EleN, EleT, Offs );
                 GL_FLOAT :glVertexAttribFormat( L, EleN, EleT, GL_FALSE, Offs );
                 end;
            end;

            glVertexAttribBinding( L, BinP_ );

          Unbind;
     end;
end;

procedure TGLPortsV.DelPort( const BinP_:GLuint; const Port_:TGLPortV );
var
   L :GLuint;
begin
     L := _Progra.glGetVertLoca( Port_.Name );

     with _Varray do
     begin
          Bind;

            glDisableVertexAttribArray( L );

          Unbind;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPortsV.Create( const Progra_:TGLProgra );
begin
     inherited;

     _Varray := TGLVarray.Create;
end;

destructor TGLPortsV.Destroy;
begin
     _Varray.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsV.Use;
begin
     _Varray.Bind;
end;

procedure TGLPortsV.Unuse;
begin
     _Varray.Unbind;
end;

//------------------------------------------------------------------------------

procedure TGLPortsV.Add( const BinP_:GLuint; const Name_:String;
                                             const EleN_:GLint;
                                             const EleT_:GLenum;
                                             const Offs_:GLuint = 0 );
var
   P :TGLPortV;
begin
     with P do
     begin
          Name := Name_;
          EleN := EleN_;
          EleT := EleT_;
          Offs := Offs_;
     end;

     inherited Add( BinP_, P );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsU

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsU.AddPort( const BinP_:GLuint; const Port_:TGLPortU );
var
   L :GLuint;
begin
     L := _Progra.glGetBlocLoca( Port_.Name );

     glUniformBlockBinding( _Progra.ID, L, BinP_ );
end;

procedure TGLPortsU.DelPort( const BinP_:GLuint; const Port_:TGLPortU );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsU.Add( const BinP_:GLuint; const Name_:String );
var
   P :TGLPortU;
begin
     with P do
     begin
          Name := Name_;
     end;

     inherited Add( BinP_, P );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPortsI

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsI.AddPort( const BinP_:GLuint; const Port_:TGLPortI );
var
   L :GLuint;
begin
     with _Progra do
     begin
          L := glGetUnifLoca( Port_.Name );

          Use;

            glUniform1i( L, BinP_ );

          Unuse;
     end;
end;

procedure TGLPortsI.DelPort( const BinP_:GLuint; const Port_:TGLPortI );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPortsI.Add( const BinP_:GLuint; const Name_:String );
var
   P :TGLPortI;
begin
     with P do
     begin
          Name := Name_;
     end;

     inherited Add( BinP_, P );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLEngine

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLEngine.GetVerters :TGLPortsV;
begin
     Result := _Verters;
end;

function TGLEngine.GetUnifors :TGLPortsU;
begin
     Result := _Unifors;
end;

function TGLEngine.GetImagers :TGLPortsI;
begin
     Result := _Imagers;
end;

/////////////////////////////////////////////////////////////////////// イベント

procedure TGLEngine.DoOnLinked;
begin
     _Verters.AddPorts;
     _Unifors.AddPorts;
     _Imagers.AddPorts;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLEngine.Create;
begin
     inherited Create;

     _Verters := TGLPortsV.Create( Self );
     _Unifors := TGLPortsU.Create( Self );
     _Imagers := TGLPortsI.Create( Self );
end;

destructor TGLEngine.Destroy;
begin
     _Verters.DisposeOf;
     _Unifors.DisposeOf;
     _Imagers.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLEngine.Use;
begin
     inherited;

     _Verters.Use;
     _Unifors.Use;
     _Imagers.Use;
end;

procedure TGLEngine.Unuse;
begin
     _Verters.Unuse;
     _Unifors.Unuse;
     _Imagers.Unuse;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
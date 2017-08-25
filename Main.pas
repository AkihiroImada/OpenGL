unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL.Viewer, LUX.GPU.OpenGL.Shader,
  MYX.Camera,
  MYX.Shaper,
  MYX.Matery,
  System.Threading, FMX.Edit, FMX.EditBox, FMX.NumberBox;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
      TabItemV: TTabItem;
        Rectangle2: TRectangle;
          GLViewer4: TGLViewer;
      TabItemS: TTabItem;
        TabControlS: TTabControl;
          TabItemSV: TTabItem;
            MemoSVS: TMemo;
            SplitterSV: TSplitter;
            MemoSVE: TMemo;
          TabItemSF: TTabItem;
            MemoSFS: TMemo;
            SplitterSF: TSplitter;
            MemoSFE: TMemo;
      TabItemP: TTabItem;
        MemoP: TMemo;
    Memo1: TMemo;
    Distance: TLabel;
    Label1: TLabel;
    Rectangle1: TRectangle;
    Rectangle3: TRectangle;
    TrackBar1: TTrackBar;
    MessStrength: TLabel;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Label3: TLabel;
    Button1: TButton;
    NumberBox1: TNumberBox;
    GLViewer1: TGLViewer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GLViewer4DblClick(Sender: TObject);
    procedure GLViewer4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure GLViewer4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure GLViewer4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure MemoSVSChangeTracking(Sender: TObject);
    procedure MemoSFSChangeTracking(Sender: TObject);
    procedure GLViewer4MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  const
    IPD = 63.5 * 0.01 * 0.1; {瞳孔63.5mm}
  private
    { private 宣言 }
    _MouseA :TSingle2D;
    _MouseS :TShiftState;
    _MouseP :TSingle2D;
    _WheelTotal :Integer;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public
    { public 宣言 }
    _CameraL :TMyCamera;
    _CameraR :TMyCamera;
    _Matery  :TMyMatery;
    _Matery2 :TMyMatery;
    _Shaper  :TMyShaper;
    _Shaper2 :TMyShaper;
    /// メソッド
    procedure InitCamera;
    procedure InitMatery;
    procedure InitMatery2;
    procedure InitShaper;
    procedure InitShaper2;
    procedure InitViewer;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

/// アニメーションボタン
procedure TForm1.Button1Click(Sender: TObject);
var
  I : Integer;
  rate : Single;
begin
  for I := 0 to Trunc(Numberbox1.Value) do
  begin
    rate := I.ToSingle / Trunc(Numberbox1.Value);
    TrackBar1.Value := TrackBar1.Max * rate;
    GLViewer4.MakeScreenShot.SaveToFile('animation\image'+I.ToString+'.png');
  end;
end;

procedure TForm1.EditShader( const Shader_:TGLShader; const Memo_:TMemo );
begin
     if Memo_.IsFocused then
     begin
          TabItemV.Enabled := False;

          TIdleTask.Run( procedure
          begin
               Shader_.Source.Assign( Memo_.Lines );

               with _Matery.Engine do
               begin
                    TabItemV.Enabled := Status;

                    if not Status then TabControl1.TabIndex := 1;
               end;
          end );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitCamera;
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   C :TMyCameraData;
begin
     with C do
     begin
          Proj := TSingleM4.ProjPers( -_N/2, +_N/2, -_N/2, +_N/2, _N, _F );
          Pose := TsingleM4.Translate(-IPD/2, 0, +10);
     end;
     _CameraL.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjPers( -_N/2, +_N/2, -_N/2, +_N/2, _N, _F );
          Pose := TsingleM4.Translate(IPD/2, 0, +10);
     end;
     _CameraR.Data := C;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitMatery;
begin
     with _Matery do
     begin
          with ShaderV do
          begin
               OnCompiled := procedure
               begin
                    MemoSVE.Lines.Assign( Errors );

                    _Matery.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderV_Random.glsl' );

               MemoSVS.Lines.Assign( Source );
          end;

          with ShaderF do
          begin
               OnCompiled := procedure
               begin
                    MemoSFE.Lines.Assign( Errors );

                    _Matery.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

               MemoSFS.Lines.Assign( Source );
          end;

          with Engine do
          begin
               OnLinked := procedure
               begin
                    MemoP.Lines.Assign( Errors );
               end;
          end;

          Imager.LoadFromFile( '..\..\_DATA\color_noise.png' );
     end;
end;

procedure TForm1.InitMatery2;
begin
     with _Matery2 do
     begin
          with ShaderV do
          begin
               OnCompiled := procedure
               begin
                    MemoSVE.Lines.Assign( Errors );

                    _Matery2.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          end;

          with ShaderF do
          begin
               OnCompiled := procedure
               begin
                    MemoSFE.Lines.Assign( Errors );

                    _Matery2.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderF_Skybox.glsl' );

          end;

          with Engine do
          begin
               OnLinked := procedure
               begin
                    MemoP.Lines.Assign( Errors );
               end;
          end;

          Imager.LoadFromFile( '..\..\_DATA\Milkyway_BG.png' );
     end;
end;

//------------------------------------------------------------------------------

function BraidedTorus( const T_:TdSingle2D ) :TdSingle3D;
const
     LoopR :Single = 1.0;  LoopN :Integer = 3; 
     TwisR :Single = 0.5;  TwisN :Integer = 5;
     PipeR :Single = 0.3;
var
   T :TdSingle2D;
   cL, cT, cP, TX, PX, R,
   sL, sT, sP, TY, PY, H :TdSingle;
begin
     T := Pi2 * T_;

     CosSin( LoopN * T.U, cL, sL );
     CosSin( TwisN * T.U, cT, sT );
     CosSin(         T.V, cP, sP );

     TX := TwisR * cT;  PX := PipeR * cP;
     TY := TwisR * sT;  PY := PipeR * sP;

     R := LoopR * ( 1 + TX ) + PX  ;
     H := LoopR * (     TY   + PY );

     with Result do
     begin
          X := R * cL;
          Y := H     ;
          Z := R * sL;
     end;
end;

// リンゴ関数
function Apple(const T_:TdSingle2D ) :TdSingle3D;
const
  SCALE : Single = 0.3;
var
  u : TdSingle;
  v : TdSingle;
  v_ : Single;
begin
  u := Pi2 * T_.U;
  v := Pi2 * T_.V - Pi;
  // Ln使うためにこんな書き方してます．
  v_ := v.o;

  with Result do
  begin
    X := Cos(u)*(4 + 3.8*Cos(v));
    Y := Sin(u)*(4 + 3.8*Cos(v));
    Z :=(Cos(v)+Sin(v)-1)*(1+Sin(v))*Ln(1.0-Pi*v_/10.0)+7.5*Sin(v);
    X := X*SCALE;
    Y := Y*SCALE;
    Z := Z*SCALE;
  end;

end;

// 天球の関数
function SkyBox(const T_:TdSingle2D):TdSingle3D;
const SCALE = 500;
var
  U : TdSingle;
  V : TdSingle;
begin
  U := (2*T_.U - 1) * PI;
  V := (2*T_.V - 1) * PI;
  with Result do
  begin
    X := Cos(U)*Cos(V);
    Y := Sin(U)*Cos(V);
    Z := Sin(V);

    X := X*SCALE;
    Y := Y*SCALE;
    Z := Z*SCALE;
  end;
end;

procedure TForm1.InitShaper;
var
   S :TMyShaperData;
begin
     with _Shaper do
     begin
          LoadFormFunc( Apple, 1000, 1000 );

          with S do
          begin
               Pose := TSingleM4.Identify * TSingleM4.RotateX(1.5*PI);
               Strength := 0;
          end;

          Data := S;
     end;
end;

/// 乱雑さ調整バー
procedure TForm1.TrackBar1Change(Sender: TObject);
var
   S :TMyShaperData;
begin
   Label2.Text := TTrackBar(Sender).Value.ToString;
    with S do
     begin
          Pose := _Shaper.Data.Pose;
          Strength := TrackBar1.Value;
     end;
   _Shaper.Data := S;
   GLViewer4.Repaint;
end;


procedure TForm1.InitShaper2;
var
   S :TMyShaperData;
begin
     with _Shaper2 do
     begin
          LoadFormFunc(Skybox, 4,4);

          with S do
          begin
               Pose := TSingleM4.Identify;
          end;

          Data := S;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitViewer;
begin
     GLViewer4.OnPaint := procedure
     begin
          _CameraL.Use;
          _Matery .Use;
          _Shaper .DrawPoint;
          _Matery2.Use;
          _Shaper2 .Draw;
     end;
     GLViewer1.OnPaint := procedure
     begin
          _CameraR.Use;
          _Matery .Use;
          _Shaper .DrawPoint;
          _Matery2.Use;
          _Shaper2 .Draw;
     end;
end;






procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseA := TSingle2D.Create( 0, 0 );
     _MouseS := [];

     _CameraL := TMyCamera.Create;
     _CameraR := TMyCamera.Create;
     _Matery  := TMyMatery.Create;
     _Matery2 := TMyMatery.Create;
     _Shaper  := TMyShaper.Create;
     _Shaper2 := TMyShaper.Create;

     InitCamera;
     InitMatery;
     InitMatery2;
     InitShaper;
     InitShaper2;
     InitViewer;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _CameraL.DisposeOf;
     _CameraR.DisposeOf;
     _Matery .DisposeOf;
     _Matery2.DisposeOf;
     _Shaper .DisposeOf;
     _Shaper2.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.GLViewer4DblClick(Sender: TObject);
begin
     with GLViewer4.MakeScreenShot do
     begin
          SaveToFile( 'Viewer4.png' );

          DisposeOf;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.GLViewer4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     _MouseS := Shift;
     _MouseP := TSingle2D.Create( X, Y );
end;

procedure TForm1.GLViewer4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   P :TSingle2D;
   C :TMyCameraData;
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          with C do
          begin
               Proj := _CameraL.Data.Proj;
               Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                     * TSingleM4.RotateY( DegToRad( _MouseA.X ) )
                     * TsingleM4.Translate(-IPD/2, 0, +10+_WheelTotal);
          end;
          _CameraL.Data := C;
          with C do
          begin
               Proj := _CameraL.Data.Proj;
               Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                     * TSingleM4.RotateY( DegToRad( _MouseA.X ) )
                     * TsingleM4.Translate(IPD/2, 0, +10+_WheelTotal);
          end;
          _CameraR.Data := C;

          GLViewer4.Repaint;
          GLViewer1.Repaint;

          _MouseP := P;
     end;
end;

procedure TForm1.GLViewer4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     GLViewer4MouseMove( Sender, Shift, X, Y );
     _MouseS := [];
end;

procedure TForm1.GLViewer4MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
const
  _N :Single = 0.1;
  _F :Single = 1000;
var
  C :TMyCameraData;
begin
  _WheelTotal := _WheelTotal - WheelDelta div 120;
  Label1.Text := (10+_WheelTotal).ToString;
  with C do
  begin
    Proj := _CameraL.Data.Proj;
    Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
    * TSingleM4.RotateY( DegToRad( _MouseA.X ) )
    * TsingleM4.Translate(-IPD/2, 0, +10+_WheelTotal);
  end;
  _CameraL.Data := C;
  with C do
  begin
    Proj := _CameraR.Data.Proj;
    Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
    * TSingleM4.RotateY( DegToRad( _MouseA.X ) )
    * TsingleM4.Translate(IPD/2, 0, +10+_WheelTotal);
  end;
  _CameraR.Data := C;
  GLViewer4.Repaint;
  GLViewer1.Repaint;

end;

//------------------------------------------------------------------------------

procedure TForm1.MemoSVSChangeTracking(Sender: TObject);
begin
     EditShader( _Matery.ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChangeTracking(Sender: TObject);
begin
     EditShader( _Matery.ShaderF, MemoSFS );
end;

end. //######################################################################### ■

#version 150

////////////////////////////////////////////////////////////////////////////////【定数】

const float Pi  = 3.141592653589793;
const float Pi2 = Pi * 2.0;
const float P2i = Pi / 2.0;

////////////////////////////////////////////////////////////////////////////////【ルーチン】

vec2 VecToSky( vec4 Vector_ )
{
    vec2 Result;

    Result.x = ( Pi - atan( -Vector_.x, -Vector_.z ) ) / Pi2;
    Result.y =        acos(  Vector_.y             )   / Pi ;

    return Result;
}

////////////////////////////////////////////////////////////////////////////////【共通定数】

layout(std140) uniform TViewerScal
{
  layout(row_major) mat4 _ViewerScal;
};

layout(std140) uniform TCameraData
{
  layout(row_major) mat4 Proj;
  layout(row_major) mat4 Pose;
}
_Camera;

layout(std140) uniform TShaperData
{
  layout(row_major) mat4 Pose;
  float Strength;
}
_Shaper;

uniform sampler2D _Imager;

////////////////////////////////////////////////////////////////////////////////【入出力】

in TSendVF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Sender;

//------------------------------------------------------------------------------

out vec4 _FramerCol;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  if(length(gl_PointCoord * 2.0 -1.0f) > 0.4) discard;
  vec4 C = _Camera.Pose * vec4( 0, 0, 0, 1 );
  vec4 V = normalize( _Sender.Pos - C );
  float D = dot(V, normalize( _Sender.Nor ));

  _FramerCol = vec4(1,D,0,1);
}

//##############################################################################

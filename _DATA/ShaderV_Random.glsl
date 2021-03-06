﻿#version 150

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

////////////////////////////////////////////////////////////////////////////////【入出力】

uniform sampler2D _Imager;

in vec4 _VerterPos;
in vec4 _VerterNor;
in vec2 _VerterTex;
//------------------------------------------------------------------------------

out TSendVF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Result;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  vec4 C = texture( _Imager, _VerterTex );
  float Bri = C.r * 0.3 + C.g *0.6 + C.b * 0.1 + 0.1;
  vec4 Offseted = _VerterPos - normalize(_VerterNor) * _Shaper.Strength * Bri;
  _Result.Pos =                     _Shaper.Pose     * Offseted;
  _Result.Nor = transpose( inverse( _Shaper.Pose ) ) * _VerterNor;
  _Result.Tex =                                        _VerterTex;
  gl_Position = _ViewerScal * _Camera.Proj * inverse( _Camera.Pose ) * _Result.Pos;
}

//##############################################################################

#version 150
#define HEIGHT_BIT 13
#define MAX_BIT 10
#define ADD_OFFSET 4095
#define DISPLAY_HEIGHT 8192.0 / 40.0
#define DEFAULT_OFFSET 10
#define SHADER_VERSION 2
#moj_import <fog.glsl>
#if SHADER_VERSION >= 3
#moj_import <dynamictransforms.glsl>
in float sphericalVertexDistance;in float cylindricalVertexDistance;
#else
uniform vec4 ColorModulator;uniform float FogStart;uniform float FogEnd;uniform vec4 FogColor;in float vertexDistance;
#endif
uniform sampler2D Sampler0;in vec4 vertexColor;in vec2 texCoord0;out vec4 fragColor;in float applyColor;bool isEncodeColor(vec4 color) {return color.x == 1.0 / 255.0 && color.y == 2.0 / 255.0 && color.z == 3.0 / 255.0;}vec4 betterhealthbar_fog_distance(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {if (vertexDistance <= fogStart) {return inColor;}float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);}void main() {vec4 texColor = texture(Sampler0, texCoord0);vec4 color = texColor * vertexColor * ColorModulator;if (applyColor > 0 && texColor.a > 0) {color = vec4(texColor.rgb, isEncodeColor(texColor) ? 0.0 : 1.0) * vertexColor * ColorModulator;}if (color.a < 0.1) {discard;}
#if SHADER_VERSION >= 3
fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
#else
fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
#endif
}
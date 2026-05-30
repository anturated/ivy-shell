#version 450

layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float leftStart;   float leftEnd;   float leftIntensity;
    float rightStart;  float rightEnd;  float rightIntensity;
    float topStart;    float topEnd;    float topIntensity;
    float bottomStart; float bottomEnd; float bottomIntensity;
};

float getFade(float val, float start, float end) {
    if (abs(start - end) < 0.0001) {
        return val > start ? 1.0 : 0.0;
    }
    return smoothstep(start, end, val);
}

void main() {
    vec4 color = texture(source, vTexCoord);

    float fLeft   = getFade(vTexCoord.x, leftStart, leftEnd);
    float fRight  = getFade(1 - vTexCoord.x, rightStart, rightEnd);
    float fTop    = getFade(vTexCoord.y, topStart, topEnd);
    float fBottom = getFade(1 - vTexCoord.y, bottomStart, bottomEnd);

    float aLeft   = mix(1.0, fLeft,   leftIntensity);
    float aRight  = mix(1.0, fRight,  rightIntensity);
    float aTop    = mix(1.0, fTop,    topIntensity);
    float aBottom = mix(1.0, fBottom, bottomIntensity);

    // float finalAlpha = min(min(aLeft, aRight), min(aTop, aBottom));
    float finalAlpha = aLeft * aRight * aTop * aBottom;

    fragColor = color * finalAlpha;
}

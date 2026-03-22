#version 450

layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix; // Must match the layout of the vertex shader block
    float fadeStart;
};

void main() {
    vec4 color = texture(source, vTexCoord);
    float alpha = smoothstep(fadeStart, 1.0, vTexCoord.x);
    fragColor = color * alpha; // Standard premultiplied alpha
}

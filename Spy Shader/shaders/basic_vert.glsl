#version 460

#define WIGGLE_AMOUNT 0.05 //[0.0 0.01 0.05 0.1 0.25 0.5 0.75 1]

in vec3 vaPosition; //ts is pointy mcpointface place(vertex position)
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform int frameCounter;

out vec2 texCoord;
out vec3 foliageColor;
out vec2 lightMapCoords;

void main() {
    texCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);

    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition+chunkOffset, 1)).xyz;

    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition+cos(frameCounter * WIGGLE_AMOUNT));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition+chunkOffset - sin(distanceFromCamera + (frameCounter * WIGGLE_AMOUNT)) - (distanceFromCamera * 0.1), 1);
}
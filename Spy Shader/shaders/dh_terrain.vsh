#version 460 compatibility

#define WIGGLE_AMOUNT 0.05 //[0.0 0.01 0.05 0.1 0.25 0.5 0.75 1]

uniform vec3 cameraPosition;
uniform vec3 chunkOffset;
uniform int frameCounter;

out vec4 blockColor;
out vec2 lightMapCoords;

void main() {
    blockColor = gl_Color;
    lightMapCoords = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    vec3 worldSpaceVertexPosition = cameraPosition + (inverse(gl_ModelViewMatrix) * gl_ModelViewMatrix * vec4(gl_Vertex.xyz+chunkOffset, 1)).xyz;

    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition+cos(frameCounter * WIGGLE_AMOUNT));

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * vec4(gl_Vertex.xyz.xyz+chunkOffset - sin(distanceFromCamera + (frameCounter * WIGGLE_AMOUNT)) - (distanceFromCamera * 0.1), 1);
}
//dh_terrain: io.github.douira.glsl_transformer.parser.ParsingException: Unexpected token ')'
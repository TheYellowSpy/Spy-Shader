#version 460 compatibility

#define WIGGLE_AMOUNT 0.05 //[0.0 0.01 0.05 0.1 0.25 0.5 0.75 1]
#define COLOR_AMOUNT 3 //[0 1 2 3 4]

uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform float viewHeight;
uniform float viewWidth;
uniform int frameCounter;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec4 blockColor;
in vec2 lightMapCoords;

void main() {
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb,vec3(2.2));

    vec4 outputColorData = blockColor;
    vec3 outputColor = pow(outputColorData.rgb, vec3(2.2)) * lightColor;
    float transparency = outputColorData.a;
    if (transparency < .1) {
        discard;
    }
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;

    if (depth != 1.0) {
        discard;
    }

    outColor0 = pow(vec4(outputColor, transparency), vec4(1/2.2));
    outColor0.r += sin(frameCounter * WIGGLE_AMOUNT)/COLOR_AMOUNT;
    outColor0.g += sin(frameCounter * WIGGLE_AMOUNT + 1.0471975511965977461542144610932)/COLOR_AMOUNT;
    outColor0.b += sin(frameCounter * WIGGLE_AMOUNT + 2.0943951023931954923084289221863)/COLOR_AMOUNT;
}
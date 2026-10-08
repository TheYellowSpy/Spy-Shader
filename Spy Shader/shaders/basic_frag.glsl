#version 460

#define WIGGLE_AMOUNT 0.05 //[0.0 0.01 0.05 0.1 0.25 0.5 0.75 1]
#define COLOR_AMOUNT 3 //[0 1 2 3 4]

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform int frameCounter;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;

void main() {

    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb, vec3(2.2));

    vec4 outColorData = pow(texture(gtexture, texCoord), vec4(2.2));
    vec3 outColor = outColorData.rgb * pow(foliageColor, vec3(2.2)) * lightColor;
    float transparency = outColorData.a;
    if (transparency < .1) {
        discard;
    }
    outColor0 = pow(vec4(outColor, transparency), vec4(1/2.2));
    outColor0.r += sin(frameCounter * WIGGLE_AMOUNT)/COLOR_AMOUNT;
    outColor0.g += sin(frameCounter * WIGGLE_AMOUNT + 1.0471975511965977461542144610932)/COLOR_AMOUNT;
    outColor0.b += sin(frameCounter * WIGGLE_AMOUNT + 2.0943951023931954923084289221863)/COLOR_AMOUNT;
}
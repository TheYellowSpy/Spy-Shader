#version 460 compatibility

#define WIGGLE_AMOUNT 0.05 //[0.0 0.01 0.05 0.1 0.25 0.5 0.75 1]
#define COLOR_AMOUNT 3 //[0 1 2 3 4]

uniform int renderStage;
uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int frameCounter;

in vec4 glcolor;

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, gbufferModelView[1].xyz); //not much, what's up with you?
	return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
}

vec3 screenToView(vec3 screenPos) {
	vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
	vec4 tmp = gbufferProjectionInverse * ndcPos;
	return tmp.xyz / tmp.w;
}

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	if (renderStage == MC_RENDER_STAGE_STARS) {
		color = glcolor;
	} else {
		vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
		color.r += sin(frameCounter * WIGGLE_AMOUNT)/COLOR_AMOUNT;
    	color.g += sin(frameCounter * WIGGLE_AMOUNT + 1.0471975511965977461542144610932)/COLOR_AMOUNT;
    	color.b += sin(frameCounter * WIGGLE_AMOUNT + 2.0943951023931954923084289221863)/COLOR_AMOUNT;
	}

}
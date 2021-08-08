#version 330

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

void main()
{
	// Creating the UV map texture
    vec2 uv = gl_FragCoord.xy/uResolution;
    
    
    outColor = vec4(uv, 0.,1.0);
}
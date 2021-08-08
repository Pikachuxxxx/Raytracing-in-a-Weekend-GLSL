#version 330

// Input uniform variables
uniform vec2 uResolution;
uniform float uTime;

// Outout color varaibles
out vec4 outColor;

// Ray
struct Ray
{
	vec3 origin; // Beginning point of the ray
	vec3 dir;	// Direction of the ray
};

void main()
{
	// Creating the UV map texture
    vec2 uv = gl_FragCoord.xy/uResolution;
    
    
    outColor = vec4(uv, 0.,1.0);
}
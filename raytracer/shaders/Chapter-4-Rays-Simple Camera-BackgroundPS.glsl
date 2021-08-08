#version 410

// Input uniform variables
uniform vec2 uResolution;

// Outout color varaibles
out vec4 outColor;

/********************************************************/
/* Ray */
struct Ray
{
	vec3 origin; // Beginning point of the ray
	vec3 dir;	// Direction of the ray
};

// Gets the positon of ray at any point in the space using the parametric equation of st. line
vec3 RayAt(Ray r, float t)
{
	return r.origin + r.dir*t;
}

// Gets the color of the ray being incident
vec3 RayColor(Ray r)
{
	// Gets the direcition of the ray in NDC
	vec3 unitDir = normalize(r.dir);
	// Get the parametric point to get a point in ray
	// TODO: How is this t and ray color decided? determined?
	float t = 0.5 * (unitDir.y + 1.0);
	// Returns a color of the ray based on the parametric equation p = a + b.t
	return (1.0 - t)*vec3(1.0) + t*vec3(0.7, 0.8, 1.0);
}

/********************************************************/
/* Camera Systems */
struct Camera
{
	// Camera world space properties
	vec3 origin;
	vec3 up;
	vec3 right;
	vec3 lowerLeftCorner;
};

// Creates the camera for the scence
Camera CreateCamera()
{
	// Camera Viewport properties
	float aspectRatio = (uResolution.x / uResolution.y);
	float viewportHeight = 2.0f;
	float viewportWidth = viewportHeight * aspectRatio;
	float focalLength = 1.0;

	// Create the camera vectors
	vec3 origin = vec3(0.0);
	vec3 camUp = vec3(0.0, viewportHeight, 0.0);
	vec3 camRight = vec3(viewportWidth, 0.0, 0.0);
	vec3 lowerLeft = origin - camUp / 2 - camRight / 2 - vec3(0.0, 0.0, focalLength);
	
	// Create the camera struct the with initial data
	return Camera(origin, camUp, camRight, lowerLeft);
}

// Gets the Ray from the eye of the camera to the pixel on the screen
Ray GetRayFromCamera(Camera c, vec2 uv)
{
	Ray r = Ray(c.origin, normalize(c.lowerLeftCorner + uv.x * c.right + uv.y * c.up - c.origin));
	return r;
}
/********************************************************/

void main()
{
	// Creating the UV map texture
    vec2 uv = gl_FragCoord.xy/uResolution;
    
    // Create the scene camera
    Camera cam = CreateCamera();
    // Get the ray from cam to uv pixel
    Ray r = GetRayFromCamera(cam, uv);
    // Get the pixel color after the ray has intersected with the pixel
    vec3 rayColor = RayColor(r);
    
    // Final fragment color
    outColor = vec4(rayColor, 1.0);
}
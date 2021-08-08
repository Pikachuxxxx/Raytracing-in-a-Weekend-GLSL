#version 410

// Input uniform variables
uniform vec2 uResolution;

// Outout color varaibles
out vec4 outColor;

/********************************************************/
/* Geometry */
struct Sphere
{
  	vec3 center;
  	float radius;
};
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

/* Geometry Hit Functions */
// Sphere Hit
bool RayHasHitSphere(Sphere s, Ray r)
{
 	vec3 oc = r.origin - s.center;
  	float a = dot(r.dir,r.dir);
  	float b = 2. * dot(oc, r.dir);
  	float c = dot(oc,oc) - s.radius*s.radius;
  	float d = b*b - 4.*a*c;
  	if(d < 0.){ return false;}
  	
  	// check if we are inside the sphere and the closest intersection is behind us.
  	float t1 = (-b - sqrt(d)) / (2.*a);
  	float t2 = (-b + sqrt(d)) / (2.*a);
  	float t = t1 < 0.05 ? t2 : t1;

  	if(t < 0.05 || t > 1000.)
    	return false;

  	return true;
}

// Gets the color of the ray being incident
vec3 RayColor(Ray r)
{
	// Gets the direcition of the ray in NDC
	vec3 unitDir = normalize(r.dir);
	
	Sphere s = Sphere(vec3(0.0, 0.0, -1.0), 0.2);
	// Check if the ray has hit the sphere 
	if(RayHasHitSphere(s, r))
		return vec3(1.0, 0.0, 0.0);
		
	/*
	 * If it doesn't hit anything then draw the Sky
	 * Use the parametric equation to get a point in ray and 
	 * draw a gradient of the color over the screen
	 */
	// TODO: How is this t determined in the next line?
	float t = 0.5 * (unitDir.y + 1.0);
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
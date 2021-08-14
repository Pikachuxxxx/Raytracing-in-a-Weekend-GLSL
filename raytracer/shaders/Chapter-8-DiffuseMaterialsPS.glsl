#version 410

// Input uniform variables
uniform vec2 uResolution;
uniform sampler2D uTex;

// Outout color varaibles
out vec4 outColor;
/********************************************************/
/* Helper math functions */
#define PI 3.1415926535897932385

float Deg2Rad(float deg)
{
  return deg*PI / 180.;
}

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

/* Abstraction of hittable objects */
struct HitInfo
{
	vec3 point;
	vec3 normal;
	float t;
	bool isFrontFace;
};

// Gets the positon of ray at any point in the space using the parametric equation of st. line
vec3 RayAt(Ray r, float t)
{
	return r.origin + r.dir*t;
}

/* Geometry Hit Functions */
// Sphere Hit
bool RayHasHitSphere(Sphere s, Ray r, inout HitInfo hitInfo)
{
  vec3 oc = r.origin - s.center;
  float a = dot(r.dir, r.dir);
  float halfB = dot(oc,r.dir);
  float c = dot(oc, oc) - s.radius * s.radius;
  float d = halfB * halfB - a * c;
  if(d < 0.){ return false; }	
  	
  	// check if we are inside the sphere and the closest intersection is behind us.
  float t1 = (-halfB - sqrt(d));
  float t2 = (-halfB + sqrt(d));
  float t = t1 < 0.05 ? t2 : t1;
  	
  	// Get the hit record deets
  	vec3 hitPoint = RayAt(r, t);
  	vec3 hitNormal = hitPoint - s.center;
  	
    // if it is the front face, the ray is inside the sphere, so invert the normal
	bool frontFace = dot(r.dir, hitNormal) > 0.0;
	hitNormal = frontFace ? -hitNormal : hitNormal;
	// Normalize the normal length
	hitNormal /= s.radius;
	
	// If not roots return no hit 
  	if(t < 0.05 || t > 1000.)
    	return false;
    
    // If it hit something return true along with the hit data of the hit
    hitInfo = HitInfo(hitPoint, hitNormal, t, frontFace);

  	return true;
}

// Ray Caster with the objects in the world to render them
bool RayCastWorld(const in Ray r, inout HitInfo hitInfo)
{
	// Draw the red sphere first (with that rays that hit that object)
	Sphere redSphere = Sphere(vec3(0.0, 0.0, -1.0), 0.4);
	// Now draw the plane as a very huge sphere
	Sphere ground = Sphere(vec3(0.,-100.5, -1.), 100.);
	
	// Check if the ray has hit anything , if yes return true with the hitInfo
	bool hasHitAnything = false;
	hasHitAnything = RayHasHitSphere(ground, r, hitInfo) || hasHitAnything;
	hasHitAnything = RayHasHitSphere(redSphere, r, hitInfo) || hasHitAnything;
	return hasHitAnything;
}

// Gets the color of the ray being incident
vec3 RayColor(Ray r)
{
	// Gets the direction of the ray in NDC
	vec3 unitDir = normalize(r.dir);
	HitInfo hitInfo;
	bool hasHitAnything = RayCastWorld(r, hitInfo);
	// Draw with the color of their normal surface (that's why ground is green see tip of sphere)
	if(hasHitAnything)
		return 0.5 * (hitInfo.normal + vec3(1.0));
		
	/*
	 * If it doesn't hit anything then draw the Sky
	 * Use the parametric equation to get a point in ray and 
	 * draw a gradient of the color over the screen
	 */
	// TODO: How is this t determined in the next line?
	float t = 0.5 * (unitDir.y + 1.0);
	return (1.0 - t)*vec3(1.0) + t*vec3(0.5, 0.7, 1.0);
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
    
    // Antialiasing
    vec2 rcpRes = vec2(1.0) / uResolution.xy;
	vec3 col = vec3(0.0);
	int numSamples = 4;
	float rcpNumSamples = 1.0 / float(numSamples);
	
	// Simple box filtering
	for(int x = 0; x < numSamples; ++x)
	{
    	for(int y = 0; y < numSamples; ++y)
    	{
        	vec2 adj = vec2(float(x), float(y));
        	vec2 uv = (gl_FragCoord.xy + adj * rcpNumSamples) * rcpRes;
        	// Get the ray from cam to uv pixel
    		Ray r = GetRayFromCamera(cam, uv);
    		// Get the pixel color after the ray has intersected with the pixel
        	col += RayColor(r);
    	}
	}
	col /= float(numSamples * numSamples);
	
	// Accumulate the output to a buffer
	if(PASS_INDEX == 0)
	{
	}


    // Final fragment color
	outColor = vec4(col, 1.0);
    
}
# Raytracing-in-a-Weekend-GLSL
Implementing the [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) by Peter Shirley in GLSL using fragment shaders.

I used a software called [SHADERed](https://github.com/dfranx/SHADERed/tree/460717edf74dcb85111b1702f64b59d304e6ac08) by [dfransx](https://github.com/dfranx) to debug and render the GLSL shaders into images, it's a great tool to debug glsl/hlsl shaders like we do with normal code and render to Quad primitives and has many other powerful features.

(_The following code can also be run in ShaderToy by just changing some the uniform variables_)

The fragment shader goes through every pixel and renders the images. I have arranged them into different shaders and output images as per the output from the chapters.

_At the core, the ray tracer sends rays through pixels and computes the color seen in the direction of those rays._ [Peter Shirley](https://raytracing.github.io/books/RayTracingInOneWeekend.html)

### Chapter 2 : [Output an Image](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/shaders/Chapter-2-Output-To-ImagePS.glsl)
![](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/Chapter-2-Output%20an%20Image.png)

### Chapter 4 : [Rays, Camera and Background](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/shaders/Chapter-4-Rays-Simple%20Camera-BackgroundPS.glsl)

![](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/Chapter-4-Rays-Simple%20Camera-Background.png)

### Chapter 5 : [Adding a Sphere](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/shaders/Chapter-5-Adding-a-SpherePS.glsl)
![](https://github.com/Pikachuxxxx/Raytracing-in-a-Weekend-GLSL/blob/master/raytracer/Chapter-5-Simple-Red-Sphere.png)

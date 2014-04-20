/**************************************************************************
**
**   SNOW - CS224 BROWN UNIVERSITY
**
**   vector.cu
**   Authors: evjang, mliberma, taparson, wyegelwe
**   Created: 15 Apr 2014
**
**************************************************************************/

#ifndef VECTOR_CU
#define VECTOR_CU

#include <cuda.h>
#include <cuda_runtime.h>

#ifndef GLM_FORCE_RADIANS
    #define GLM_FORCE_RADIANS
#endif
#include "glm/vec3.hpp"

#include "common/math.h"

struct vec3
{
    union {
        float data[3];
        struct { float x, y, z; };
    };

    __host__ __device__ __forceinline__
    vec3() { x = 0.f; y = 0.f; z = 0.f; }

    __host__ __device__ __forceinline__
    vec3( float v ) { x = v; y = v; z = v; }

    __host__ __device__ __forceinline__
    vec3( float xx, float yy, float zz ) { x = xx; y = yy; z = zz; }

    __host__ __device__ __forceinline__
    vec3( const vec3 &v ) { x = v.x; y = v.y; z = v.z; }

    __host__ __device__ __forceinline__
    vec3( const glm::vec3 &v ) { x = v.x; y = v.y; z = v.z; }

    __host__ __device__ __forceinline__
    vec3& operator = ( const vec3 &rhs ) { x = rhs.x; y = rhs.y; z = rhs.z; return *this; }

    __host__ __device__ __forceinline__
    vec3& operator = ( const glm::vec3 &rhs ) { x = rhs.x; y = rhs.y; z = rhs.z; return *this; }

    __host__ __device__ __forceinline__
    int majorAxis() { return ( (x>y) ? ((x>z) ? 0 : 2) : ((y>z) ? 1 : 2) ); }

    __host__ __device__ __forceinline__
    float& operator [] ( int i ) { return data[i]; }

    __host__ __device__ __forceinline__
    float operator [] ( int i ) const { return data[i]; }

    __host__ __device__ __forceinline__
    static float dot( const vec3 &a, const vec3 &b ) { return a.x*b.x + a.y*b.y + a.z*b.z; }

    __host__ __device__ __forceinline__
    static vec3 cross( const vec3 &a, const vec3 &b )
    {
        return vec3( a.y*b.z - a.z*b.y,
                     a.z*b.x - a.x*b.z,
                     a.x*b.y - a.y*b.x );
    }

    __host__ __device__ __forceinline__
    static vec3 floor( const vec3 &v ) { return vec3( floorf(v.x), floorf(v.y), floorf(v.z) ); }

    __host__ __device__ __forceinline__
    static vec3 ceil( const vec3 &v ) { return vec3( ceilf(v.x), ceilf(v.y), ceilf(v.z) ); }

    __host__ __device__ __forceinline__
    static vec3 abs( const vec3 &v ) { return vec3( fabsf(v.x), fabsf(v.y), fabsf(v.z) ); }

    __host__ __device__ __forceinline__
    static vec3 round( const vec3 &v ) { return vec3( roundf(v.x), roundf(v.y), roundf(v.z) ); }

    //From http://stackoverflow.com/questions/1903954/is-there-a-standard-sign-function-signum-sgn-in-c-c
    __host__ __device__ __forceinline__
    static float sign( const float v ) { return (0 < v) - (v < 0);}

    //From http://stackoverflow.com/questions/1903954/is-there-a-standard-sign-function-signum-sgn-in-c-c
    __host__ __device__ __forceinline__
    static vec3 sign( const vec3 &v ) { return vec3(sign(v.x), sign(v.y), sign(v.z) );}

    __host__ __device__ __forceinline__
    static vec3 min( const vec3 &v, const vec3 &w ) { return vec3( fminf(v.x, w.x), fminf(v.y, w.y), fminf(v.z,w.z) ); }

    __host__ __device__ __forceinline__
    static vec3 max( const vec3 &v, const vec3 &w ) { return vec3( fmaxf(v.x, w.x), fmaxf(v.y, w.y), fmaxf(v.z,w.z) ); }

    __host__ __device__ __forceinline__
    static float length2( const vec3 &v ) { return v.x*v.x + v.y*v.y + v.z*v.z; }

    __host__ __device__ __forceinline__
    static float length( const vec3 &v ) { return sqrtf( v.x*v.x + v.y*v.y + v.z*v.z ); }

    __host__ __device__ __forceinline__
    static vec3 normalize( const vec3 &v ) { float f = 1.f/sqrtf(v.x*v.x+v.y*v.y+v.z*v.z); return vec3( f*v.x, f*v.y, f*v.z ); }

    __host__ __device__ __forceinline__
    vec3& mult (float f ) { x *= f; y *= f; z *= f; return *this;}

    __host__ __device__ __forceinline__
    vec3& add (float f ) { x += f; y += f; z += f; return *this;}

    __host__ __device__ __forceinline__
    vec3& add (const vec3 &v ) { x += v.x; y += v.y; z += v.z; return *this;}

    __host__ __device__ __forceinline__
    vec3& operator += ( const vec3 &rhs ) { x += rhs.x; y += rhs.y; z += rhs.z; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator + ( const vec3 &rhs ) const { return vec3( x+rhs.x, y+rhs.y, z+rhs.z ); }

    __host__ __device__ __forceinline__
    vec3& operator -= ( const vec3 &rhs ) { x -= rhs.x; y -= rhs.y; z -= rhs.z; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator - ( const vec3 &rhs ) const { return vec3( x-rhs.x, y-rhs.y, z-rhs.z ); }

    __host__ __device__ __forceinline__
    vec3& operator *= ( const vec3 &rhs ) { x *= rhs.x; y *= rhs.y; z *= rhs.z; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator * ( const vec3 &rhs ) const { return vec3( x*rhs.x, y*rhs.y, z*rhs.z ); }

    __host__ __device__ __forceinline__
    vec3& operator /= ( const vec3 &rhs ) { x /= rhs.x; y /= rhs.y; z /= rhs.z; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator / ( const vec3 &rhs ) const { return vec3( x/rhs.x, y/rhs.y, z/rhs.z ); }

    __host__ __device__ __forceinline__
    vec3& operator *= ( float f )  { x *= f; y *= f; z *= f; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator * ( float f ) const { return vec3( f*x, f*y, f*z ); }

    __host__ __device__ __forceinline__
    vec3& operator /= ( float f ) { float fi = 1./f; x *= fi; y *= fi; z *= fi; return *this; }

    __host__ __device__ __forceinline__
    vec3 operator / ( float f ) const { float fi = 1.f/f; return vec3( x*fi, y*fi, z*fi ); }

};

__host__ __device__ __forceinline__
vec3 operator - ( const vec3 &v ) { return vec3( -v.x, -v.y, -v.z ); }

__host__ __device__ __forceinline__
vec3 operator * ( float f, const vec3 &v ) { return vec3( f*v.x, f*v.y, f*v.z ); }

#endif // VECTOR_CU

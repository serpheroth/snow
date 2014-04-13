/**************************************************************************
**
**   SNOW - CS224 BROWN UNIVERSITY
**
**   mesh.h
**   Author: mliberma
**   Created: 8 Apr 2014
**
**************************************************************************/

#ifndef MESH_H
#define MESH_H

#include <QVector>

#include "common/types.h"
#include "scene/renderable.h"

typedef unsigned int GLuint;

class Mesh : public Renderable
{

public:

    struct Tri {
        union {
            struct { int a, b, c; };
            int corners[3];
        };
        Tri() : a(-1), b(-1), c(-1) {}
        Tri( int i0, int i1, int i2 ) : a(i0), b(i1), c(i2) {}
        Tri( const Tri &other ) : a(other.a), b(other.b), c(other.c) {}
        inline void reverse() { int tmp = a; a = c; c = tmp; }
        inline int& operator [] ( int i ) { return corners[i]; }
        inline int operator [] ( int i ) const { return corners[i]; }
    };

    Mesh();
    Mesh( const QVector<Vertex> &vertices, const QVector<Tri> &tris );
    Mesh( const QVector<Vertex> &vertices, const QVector<Tri> &tris, const QVector<Normal> &normals );

    virtual ~Mesh();

    void computeNormals();

    inline void addVertex( const Vertex &vertex ) { m_vertices += vertex; }
    inline int getNumVertices() const { return m_vertices.size(); }
    inline Vertex& getVertex( int i ) { return m_vertices[i]; }
    inline Vertex getVertex( int i ) const { return m_vertices[i]; }
    inline QVector<Vertex>& getVertices() { return m_vertices; }
    inline const QVector<Vertex>& getVertices() const { return m_vertices; }

    inline void addTri( const Tri &tri ) { m_tris += tri; }
    inline int getNumTris() const { return m_tris.size(); }
    inline Tri& getTri( int i ) { return m_tris[i]; }
    inline Tri getTri( int i ) const { return m_tris[i]; }
    inline QVector<Tri>& getTris() { return m_tris; }
    inline const QVector<Tri>& getTris() const { return m_tris; }

    inline void addNormal( const Normal &normal ) { m_normals += normal; }
    inline int getNumNormals() const { return m_normals.size(); }
    inline Normal& getNormal( int i ) { return m_normals[i]; }
    inline Normal getNormal( int i ) const { return m_normals[i]; }
    inline QVector<Normal>& getNormals() { return m_normals; }
    inline const QVector<Normal>& getNormals() const { return m_normals; }

    virtual void render();

private:

    // List of vertices
    QVector<Vertex> m_vertices;

    // List of tris, which index into vertices
    QVector<Tri> m_tris;

    // List of vertex normals
    QVector<Normal> m_normals;

    // OpenGL stuff
    GLuint m_vbo;
    Color m_color;

    bool hasVBO() const;
    void buildVBO();
    void deleteVBO();
    void renderVBO();

};

#endif // MESH_H
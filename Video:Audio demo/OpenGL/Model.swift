//
//  Model.swift
//  Model
//
//  Created by burt on 2016. 2. 27..
//  Copyright © 2016 BurtK. All rights reserved.
//.
import GLKit

class Model {
    var shader: BaseEffect!
    var name: String!
    var vertices: [Vertex]!
    var vertexCount: GLuint! //
    var indices: [GLubyte]!
    var indexCount: GLuint! //
    
    var vao: GLuint = 0
    var vertexBuffer: GLuint = 0
    var indexBuffer: GLuint = 0
    var texture: GLuint = 0
    
    
    // ModelView Transformation
    var position : GLKVector3 = GLKVector3(v: (0.0, 0.0, 0.0))
    var rotationX : Float = 0.0
    var rotationY : Float = 0.0
    var rotationZ : Float = 0.0
    var scale : Float = 1.0
    
    init(name: String, shader: BaseEffect, vertices: [Vertex], indices: [GLubyte]) {
        self.name = name
        self.shader = shader
        self.vertices = vertices
        self.vertexCount = GLuint(vertices.count)
        self.indices = indices
        self.indexCount = GLuint(indices.count)
        
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
        
//        var framebuffer = GLuint()
//        glGenFramebuffers(1, &framebuffer)
//        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer)
//        let width = GLsizei()
//        let height = GLsizei()
//
//        var colorRenderbuffer = GLuint()
//        glGenRenderbuffers(1, &colorRenderbuffer)
//        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
//        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8), width, height)
//        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer)
//        var depthRenderbuffer = GLuint()
//        glGenRenderbuffers(1, &depthRenderbuffer)
//        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthRenderbuffer)
//        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), width, height)
//        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthRenderbuffer)
//        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
//        if(status != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
//            print("failed to make complete framebuffer object \(status)")
//        }
//        var texture = GLuint()
//        glGenTextures(1, &texture)
//        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
//        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
//        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA8,  width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil)
//        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texture, 0)
        
        
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0))
        
        
        glEnableVertexAttribArray(VertexAttributes.color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a :: offset is 3*sizeof(GLfloat)
        
        
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v :: offset is (3+4)*sizeof(GLfloat)
        
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4+2) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v | nx, ny, nz :: offset is (3+4+2)*sizeof(GLfloat)

        
        // 바인딩을 끈다
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    func modelMatrix() -> GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale)
        return modelMatrix
    }
    
    func renderWithParentMoelViewMatrix(_ parentModelViewMatrix: GLKMatrix4) {
        
        let modelViewMatrix : GLKMatrix4 = GLKMatrix4Multiply(parentModelViewMatrix, modelMatrix())
        
        shader.modelViewMatrix = modelViewMatrix
        shader.texture = self.texture
        shader.prepareToDraw()
        
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)

    }
    
    func updateWithDelta(_ dt: TimeInterval) {
        
    }
    
    func loadTexture(_ filename: String) {
        
        let path = Bundle.main.path(forResource: filename, ofType: nil)!
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            
        }
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
    }
}

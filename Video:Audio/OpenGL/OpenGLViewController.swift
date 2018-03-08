//
//  ViewController.swift
//  SpecularLight
//
//  Created by burt on 2016. 3. 1..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import GLKit

class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : OpenGLViewController!
    
    init(glkViewController : OpenGLViewController) {
        self.glkViewController = glkViewController
    }
    
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        self.glkViewController.cube.updateWithDelta(self.glkViewController.timeSinceLastUpdate)
    }
}


class OpenGLViewController: GLKViewController {
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    var shader : BaseEffect!
    var square : Square!
    var cube : Cube!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        //Transfomr4: Viewport: Normalized -> Window
        //glViewport(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        //이건 GLKit이 자동으로 해준다
        glClearColor(236/255.0, 239/255.0, 241/255.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        let viewMatrix : GLKMatrix4 =  GLKMatrix4Rotate(GLKMatrix4MakeTranslation(0, 0, -5), GLKMathDegreesToRadians(20), 1, 0, 0)
        
        //self.square.renderWithParentMoelViewMatrix(viewMatrix)
        self.cube.renderWithParentMoelViewMatrix(viewMatrix)
    }
    
}

extension OpenGLViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)!
        glkView.drawableDepthFormat = .format16         // for depth testing
        EAGLContext.setCurrent(glkView.context)
        
        let myContext = EAGLContext(api: .openGLES2)!
//        let myEAGLLayer = CAEAGLLayer()
//        
        var colorRenderbuffer = GLuint()
        glGenRenderbuffers(1, &colorRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        myContext.presentRenderbuffer(Int(GL_RENDERBUFFER))
//        myContext.renderbufferStorage(Int(GL_RENDERBUFFER), from: myEAGLLayer)
//        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        
//        var width = GLint()
//        var height = GLint()
//        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
//        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupScene() {
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        self.shader.projectionMatrix = GLKMatrix4MakePerspective(
            GLKMathDegreesToRadians(85.0),
            GLfloat(self.view.bounds.size.width / self.view.bounds.size.height),
            1,
            150)
        
        self.cube = Cube(shader: self.shader)
        
    }
    
    
}

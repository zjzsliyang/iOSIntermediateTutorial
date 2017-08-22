/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import Metal

class cube: Node {
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    
    static var flag = false
    
    init(device: MTLDevice){
        
//        let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
//        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
//        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
//        let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
//        
//        let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
//        let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
//        let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
//        let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let A = vertex(x: -1.0, y:   1.0, z:   1.0, r:  236/255.0, g:  239/255.0, b:  241/255.0, a:  1.0)
        let B = vertex(x: -1.0, y:  -1.0, z:   1.0, r:  207/255.0, g:  216/255.0, b:  220/255.0, a:  1.0)
        let C = vertex(x:  1.0, y:  -1.0, z:   1.0, r:  176/255.0, g:  190/255.0, b:  197/255.0, a:  1.0)
        let D = vertex(x:  1.0, y:   1.0, z:   1.0, r:  144/255.0, g:  164/255.0, b:  174/255.0, a:  1.0)
        
        let Q = vertex(x: -1.0, y:   1.0, z:  -1.0, r:  120/255.0, g:  144/255.0, b:  156/255.0, a:  1.0)
        let R = vertex(x:  1.0, y:   1.0, z:  -1.0, r:  96/255.0, g:  125/255.0, b:  139/255.0, a:  1.0)
        let S = vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  84/255.0, g:  110/255.0, b:  122/255.0, a:  1.0)
        let T = vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  69/255.0, g:  90/255.0, b:  100/255.0, a:  1.0)
        
        let verticesArray:Array<vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right
            
            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        super.init(name: "Cube", vertices: verticesArray, device: device)
        
        //接受通知
        NotificationCenter.default.addObserver(self, selector: #selector(getNot(notification:)), name: Notification.Name.init(rawValue: "posChanged"), object: nil)
    }
    
    override func updateWithDelta(delta: CFTimeInterval) {
        
        super.updateWithDelta(delta: delta)
        
//        let secsPerMove: Float = 6.0
//        rotationY = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
//        rotationX = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        
        if cube.flag {
            
            rotationY += Matrix4.degrees(toRad: Float(dx) * 2.0 * Float(M_PI))
            rotationX += Matrix4.degrees(toRad: Float(dy) * 2.0 * Float(M_PI))
            
        }
        
    }
    
    @objc func getNot(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        
        dx = userInfo["dx"]! as! CGFloat
        dy = userInfo["dy"]! as! CGFloat
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

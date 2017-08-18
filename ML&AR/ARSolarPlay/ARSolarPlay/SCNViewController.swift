//
//  SCNViewController.swift
//  ARSolarPlay
//
//  Created by Yang Li on 18/08/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class SCNViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
  var arSCNView = ARSCNView()
  var arSession = ARSession()
  var arSessionConfiguration = ARSessionConfiguration()
  
  var sunNode: SCNNode!
  var sunHaloNode: SCNNode!
  var mercuryNode: SCNNode!
  var venusNode: SCNNode!
  var earthNode: SCNNode!
  var moonNode: SCNNode!
  var earthGroupNode: SCNNode!
  var marsNode: SCNNode!
  var jupiterNode: SCNNode!
  var jupiterLoopNode: SCNNode!
  var jupiterGroupNode: SCNNode!
  var saturnNode: SCNNode!
  var saturnLoopNode: SCNNode!
  var saturnGroupNode: SCNNode!
  var uranusNode: SCNNode!
  var uranusLoopNode: SCNNode!
  var uranusGroupNode: SCNNode!
  var neptuneNode: SCNNode!
  var neptuneLoopNode: SCNNode!
  var neptuneGroupNode: SCNNode!
  var plutoNode: SCNNode!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    arSession.delegate = self
    
    arSCNView.frame = self.view.bounds
    arSCNView.delegate = self
    arSCNView.session = self.arSession
    arSCNView.automaticallyUpdatesLighting = true
    let configuration = ARWorldTrackingSessionConfiguration()
    configuration.planeDetection = .horizontal
    arSessionConfiguration = configuration
    arSessionConfiguration.isLightEstimationEnabled = true
    initNode()
    self.view.addSubview(arSCNView)
    self.arSession.run(arSessionConfiguration)
  }
  
  func initNode() {
    sunNode = SCNNode(geometry: SCNSphere(radius: 0.25))
    mercuryNode = SCNNode(geometry: SCNSphere(radius: 0.02))
    venusNode = SCNNode(geometry: SCNSphere(radius: 0.04))
    earthNode = SCNNode(geometry: SCNSphere(radius: 0.05))
    moonNode = SCNNode(geometry: SCNSphere(radius: 0.01))
    earthGroupNode = SCNNode()
    marsNode = SCNNode(geometry: SCNSphere(radius: 0.03))
    jupiterNode = SCNNode(geometry: SCNSphere(radius: 0.15))
    saturnNode = SCNNode(geometry: SCNSphere(radius: 0.12))
    saturnLoopNode = SCNNode(geometry: SCNBox(width: 0.6, height: 0, length: 0.6, chamferRadius: 0))
    saturnGroupNode = SCNNode()
    uranusNode = SCNNode(geometry: SCNSphere(radius: 0.09))
    neptuneNode = SCNNode(geometry: SCNSphere(radius: 0.08))
    plutoNode = SCNNode(geometry: SCNSphere(radius: 0.04))
    
    moonNode.position = SCNVector3Make(0.1, 0, 0)
    earthGroupNode.addChildNode(earthNode)
    
    saturnLoopNode.opacity = 0.4
    saturnLoopNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/saturn_loop.png"
    saturnLoopNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
    saturnLoopNode.rotation = SCNVector4Make(-0.5, -1, 0, Float.pi / 2)
    saturnLoopNode.geometry?.firstMaterial?.lightingModel = .constant
    saturnGroupNode.addChildNode(saturnLoopNode)
    saturnGroupNode.addChildNode(saturnNode)
    
    mercuryNode.position = SCNVector3Make(0.4, 0, 0)
    venusNode.position = SCNVector3Make(0.6, 0, 0)
    earthGroupNode.position = SCNVector3Make(0.8, 0, 0)
    marsNode.position = SCNVector3Make(1.0, 0, 0)
    jupiterNode.position = SCNVector3Make(1.4, 0, 0)
    saturnGroupNode.position = SCNVector3Make(1.68, 0, 0)
    uranusNode.position = SCNVector3Make(1.95, 0, 0)
    neptuneNode.position = SCNVector3Make(2.14, 0, 0)
    plutoNode.position = SCNVector3Make(2.319, 0, 0)
    sunNode.position = SCNVector3Make(0, -0.1, 3)
    
    self.arSCNView.scene.rootNode.addChildNode(sunNode)
    
    sunNode.geometry?.firstMaterial?.multiply.contents = "art.scnassets/sun.jpg"
    sunNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/sun.jpg"
    mercuryNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/mercury.jpg"
    venusNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/venus.jpg"
    earthNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth-diffuse-mini.jpg"
    earthNode.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth-emissive-mini.jpg"
    earthNode.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth-specular-mini.jpg"
    moonNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/moon.jpg"
    marsNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/mars.jpg"
    jupiterNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/jupiter.jpg"
    saturnNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/saturn.jpg"
    saturnLoopNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/saturn_loop.jpg"
    uranusNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/uranus.jpg"
    neptuneNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/neptune.jpg"
    plutoNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/pluto.jpg"
    
    sunNode.geometry?.firstMaterial?.multiply.intensity = 0.5
    sunNode.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.geometry?.firstMaterial?.multiply.wrapS = .repeat
    sunNode.geometry?.firstMaterial?.diffuse.wrapS = .repeat
    sunNode.geometry?.firstMaterial?.multiply.wrapT = .repeat
    sunNode.geometry?.firstMaterial?.diffuse.wrapT = .repeat
    
    sunNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    mercuryNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    venusNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    earthNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    moonNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    marsNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    jupiterNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    saturnNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    uranusNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    neptuneNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    plutoNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
    
    mercuryNode.geometry?.firstMaterial?.shininess = 0.1
    venusNode.geometry?.firstMaterial?.shininess = 0.1
    earthNode.geometry?.firstMaterial?.shininess = 0.1
    moonNode.geometry?.firstMaterial?.shininess = 0.1
    marsNode.geometry?.firstMaterial?.shininess = 0.1
    jupiterNode.geometry?.firstMaterial?.shininess = 0.1
    saturnNode.geometry?.firstMaterial?.shininess = 0.1
    uranusNode.geometry?.firstMaterial?.shininess = 0.1
    neptuneNode.geometry?.firstMaterial?.shininess = 0.1
    plutoNode.geometry?.firstMaterial?.shininess = 0.1
    
    mercuryNode.geometry?.firstMaterial?.specular.intensity = 0.5
    venusNode.geometry?.firstMaterial?.specular.intensity = 0.5
    earthNode.geometry?.firstMaterial?.specular.intensity = 0.5
    moonNode.geometry?.firstMaterial?.specular.intensity = 0.5
    marsNode.geometry?.firstMaterial?.specular.intensity = 0.5
    jupiterNode.geometry?.firstMaterial?.specular.intensity = 0.5
    saturnNode.geometry?.firstMaterial?.specular.intensity = 0.5
    uranusNode.geometry?.firstMaterial?.specular.intensity = 0.5
    neptuneNode.geometry?.firstMaterial?.specular.intensity = 0.5
    plutoNode.geometry?.firstMaterial?.specular.intensity = 0.5
    
    moonNode.geometry?.firstMaterial?.specular.contents = UIColor.gray
    
    self.roationNode()
    self.addOtherNode()
    self.addLight()
  }
  
  func roationNode() {
    earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    
    var animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 1.5
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    moonNode.addAnimation(animation, forKey: "moon rotation")
    
    let moonRotationNode = SCNNode()
    moonRotationNode.addChildNode(moonNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 15.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    moonRotationNode.addAnimation(animation, forKey: "moon rotation around earth")
    
    earthGroupNode.addChildNode(moonRotationNode)
    
    let earthRotationNode = SCNNode()
    sunNode.addChildNode(earthRotationNode)
    earthRotationNode.addChildNode(earthGroupNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 30.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    earthRotationNode.addAnimation(animation, forKey: "earth rotation around sun")
    
    mercuryNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    venusNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    marsNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    jupiterNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    saturnNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    uranusNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    neptuneNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    plutoNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    
    saturnGroupNode.addChildNode(saturnNode)
    
    let mercuryRotationNode = SCNNode()
    mercuryRotationNode.addChildNode(mercuryNode)
    sunNode.addChildNode(mercuryRotationNode)
    
    let venusRotationNode = SCNNode()
    venusRotationNode.addChildNode(venusNode)
    sunNode.addChildNode(venusRotationNode)
    
    let marsRotationNode = SCNNode()
    marsRotationNode.addChildNode(marsNode)
    sunNode.addChildNode(marsRotationNode)
    
    let jupiterRotationNode = SCNNode()
    jupiterRotationNode.addChildNode(jupiterNode)
    sunNode.addChildNode(jupiterRotationNode)
    
    let saturnRotationNode = SCNNode()
    saturnRotationNode.addChildNode(saturnNode)
    sunNode.addChildNode(saturnRotationNode)
    
    let uranusRotationNode = SCNNode()
    uranusRotationNode.addChildNode(uranusNode)
    sunNode.addChildNode(uranusRotationNode)
    
    let neptuneRotationNode = SCNNode()
    neptuneRotationNode.addChildNode(neptuneNode)
    sunNode.addChildNode(neptuneRotationNode)
    
    let plutoRotationNode = SCNNode()
    plutoRotationNode.addChildNode(plutoNode)
    sunNode.addChildNode(plutoRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 25.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    mercuryRotationNode.addAnimation(animation, forKey: "mercury rotation around sun")
    sunNode.addChildNode(mercuryRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 40.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    mercuryRotationNode.addAnimation(animation, forKey: "venus rotation around sun")
    sunNode.addChildNode(venusRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 35.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    marsRotationNode.addAnimation(animation, forKey: "mars rotation around sun")
    sunNode.addChildNode(marsRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 90.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    jupiterRotationNode.addAnimation(animation, forKey: "jupiter rotation around sun")
    sunNode.addChildNode(jupiterRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 80.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    saturnRotationNode.addAnimation(animation, forKey: "saturn rotation around sun")
    sunNode.addChildNode(saturnRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 55.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    uranusRotationNode.addAnimation(animation, forKey: "uranus rotation around sun")
    sunNode.addChildNode(uranusRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 50.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    neptuneRotationNode.addAnimation(animation, forKey: "neptune rotation around sun")
    sunNode.addChildNode(neptuneRotationNode)
    
    animation = CABasicAnimation(keyPath: "rotation")
    animation.duration = 100.0
    animation.toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, Float.pi * 2))
    animation.repeatCount = .greatestFiniteMagnitude
    plutoRotationNode.addAnimation(animation, forKey: "pluto rotation around sun")
    sunNode.addChildNode(plutoRotationNode)
    
    addAnimationToSun()
  }
  
  func addAnimationToSun() {
    var animation = CABasicAnimation(keyPath: "contentsTransform")
    animation.duration = 10.0
    animation.fromValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3)))
    animation.toValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3)))
    animation.repeatCount = .greatestFiniteMagnitude
    sunNode.geometry?.firstMaterial?.diffuse.addAnimation(animation, forKey: "sun-texture")
    
    animation = CABasicAnimation(keyPath: "contentsTransform")
    animation.duration = 30.0
    animation.fromValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5)))
    animation.toValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5)))
    animation.repeatCount = .greatestFiniteMagnitude
    sunNode.geometry?.firstMaterial?.multiply.addAnimation(animation, forKey: "sun-texture2")
  }
  
  func mathRotation() {
    let totalDuration = 10.0
    let duration = totalDuration / 360
    let customAction = SCNAction.customAction(duration: duration) { (node, elapsedTime) in
      if Double(elapsedTime) == duration {
        let position = node.position
        let angle = 1.0 / 180 * Double.pi
        var x = (Double(position.x) - 0.0) * cos(angle)
        x -= (Double(position.z) - 0) * sin(angle)
        var z = (Double(position.x) - 0) * sin(angle)
        z -= (Double(position.z) - 0) * cos(angle)
        node.position = SCNVector3Make(Float(x), node.position.y, Float(z))
      }
    }
    let repeatAction = SCNAction.repeatForever(customAction)
    earthGroupNode.runAction(repeatAction)
  }
  
  func addOtherNode() {
    let cloudsNode = SCNNode()
    cloudsNode.geometry = SCNSphere(radius: 0.06)
    earthNode.addChildNode(cloudsNode)
    
    cloudsNode.opacity = 0.5
    cloudsNode.geometry?.firstMaterial?.transparent.contents = "art.scnassets/cloudsTransparency.png"
    cloudsNode.geometry?.firstMaterial?.transparencyMode = .rgbZero
    
    sunHaloNode = SCNNode()
    sunHaloNode.geometry = SCNPlane(width: 2.5, height: 2.5)
    sunHaloNode.rotation = SCNVector4Make(1, 0, 0, 0)
    sunHaloNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/sun_halo.png"
    sunHaloNode.geometry?.firstMaterial?.lightingModel = .constant
    sunHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false
    sunHaloNode.opacity = 0.2
    sunNode.addChildNode(sunHaloNode)
    
    let mercuryOrbit = SCNNode()
    mercuryOrbit.opacity = 0.4
    mercuryOrbit.geometry = SCNBox(width: 0.86, height: 0, length: 0.86, chamferRadius: 0)
    mercuryOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    mercuryOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    mercuryOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    mercuryOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(mercuryOrbit)
    
    let venusOrbit = SCNNode()
    venusOrbit.opacity = 0.4
    venusOrbit.geometry = SCNBox(width: 1.29, height: 0, length: 1.29, chamferRadius: 0)
    venusOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    venusOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    venusOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    venusOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(venusOrbit)
    
    let earthOrbit = SCNNode()
    earthOrbit.opacity = 0.4
    earthOrbit.geometry = SCNBox(width: 1.72, height: 0, length: 1.72, chamferRadius: 0)
    earthOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    earthOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    earthOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    earthOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(earthOrbit)
    
    let marsOrbit = SCNNode()
    marsOrbit.opacity = 0.4
    marsOrbit.geometry = SCNBox(width: 2.14, height: 0, length: 2.14, chamferRadius: 0)
    marsOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    marsOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    marsOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    marsOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(marsOrbit)
    
    let jupiterOrbit = SCNNode()
    jupiterOrbit.opacity = 0.4
    jupiterOrbit.geometry = SCNBox(width: 2.95, height: 0, length: 2.95, chamferRadius: 0)
    jupiterOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    jupiterOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    jupiterOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    jupiterOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(jupiterOrbit)
    
    let saturnOrbit = SCNNode()
    saturnOrbit.opacity = 0.4
    saturnOrbit.geometry = SCNBox(width: 3.57, height: 0, length: 3.57, chamferRadius: 0)
    saturnOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    saturnOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    saturnOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    saturnOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(saturnOrbit)
    
    let uranusOrbit = SCNNode()
    uranusOrbit.opacity = 0.4
    uranusOrbit.geometry = SCNBox(width: 4.19, height: 0, length: 4.19, chamferRadius: 0)
    uranusOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    uranusOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    uranusOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    uranusOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(uranusOrbit)
    
    let neptuneOrbit = SCNNode()
    neptuneOrbit.opacity = 0.4
    neptuneOrbit.geometry = SCNBox(width: 4.54, height: 0, length: 4.54, chamferRadius: 0)
    neptuneOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    neptuneOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    neptuneOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    neptuneOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(neptuneOrbit)
    
    let plutoOrbit = SCNNode()
    plutoOrbit.opacity = 0.4
    plutoOrbit.geometry = SCNBox(width: 4.98, height: 0, length: 4.98, chamferRadius: 0)
    plutoOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/orbit.png"
    plutoOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
    plutoOrbit.rotation = SCNVector4Make(0, 1, 0, Float.pi / 2)
    plutoOrbit.geometry?.firstMaterial?.lightingModel = .constant
    sunNode.addChildNode(plutoOrbit)
  }
  
  func addLight() {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.color = UIColor.black
    lightNode.light?.type = .omni
    sunNode.addChildNode(lightNode)
    
    lightNode.light?.attenuationEndDistance = 19
    lightNode.light?.attenuationStartDistance = 21
    
    SCNTransaction.begin()
    SCNTransaction.animationDuration = 1
    lightNode.light?.color = UIColor.white
    sunHaloNode.opacity = 0.5
    SCNTransaction.commit()
  }
  
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    sunNode.position = SCNVector3Make(-3 * frame.camera.transform.columns.3.x,
                                      -0.1 - 3 * frame.camera.transform.columns.3.y,
                                      -2 - 3 * frame.camera.transform.columns.3.z)
  }
}


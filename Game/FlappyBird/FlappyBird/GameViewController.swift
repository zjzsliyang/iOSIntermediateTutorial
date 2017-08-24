//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Yang Li on 22/08/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
  class func unarchiveFromFile(_ file : String) -> SKNode? {
    let sceneData: Data?
    do {
      sceneData = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: "sks")!), options: .mappedIfSafe)
    } catch _ {
      sceneData = nil
    }
    let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
    
    archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
    let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
    archiver.finishDecoding()
    return scene
  }
}

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
      let skView = self.view as! SKView
      skView.showsFPS = true
      skView.showsNodeCount = true
      skView.ignoresSiblingOrder = true
      scene.scaleMode = .aspectFill
      skView.presentScene(scene)
    }
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
}

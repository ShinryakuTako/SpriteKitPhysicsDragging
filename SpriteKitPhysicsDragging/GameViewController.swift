//
//  GameViewController.swift
//  SpriteKitPhysicsDragging
//
//  Created by ShinryakuTako@InvadingOctopus.io on 2018/07/10.
//  Copyright © 2018 Invading Octopus. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            fatalError("Cannot setup SKView.")
        }
        
        let scene = GameScene(size: view.frame.size)
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
        
        // Debugging aids
        view.ignoresSiblingOrder = true
        view.showsPhysics = true
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

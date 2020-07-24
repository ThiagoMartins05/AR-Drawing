//
//  ViewController.swift
//  AR Drawing
//
//  Created by Thiago Martins on 16/07/20.
//  Copyright © 2020 ThiagoMartins. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()//detecta orientação e posição do dispositivo
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else{return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.sync {
            if self.draw.isHighlighted{
                    let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                    sphereNode.position = currentPositionOfCamera
                    self.sceneView.scene.rootNode.addChildNode(sphereNode)
                    sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                        print("Draw button is being pressed")
                          }
                   else{
//                let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPositionOfCamera
                    
                    self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//                        if node.geometry is SCNBox{
//                           node.removeFromParentNode()
//                        }
                        if node.name == "pointer"{
                            node.removeFromParentNode()
                        }
                        
                    }
                    
                    self.sceneView.scene.rootNode.addChildNode(pointer)
                    pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    }
        }
        
       
    }

}

func +(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    
}

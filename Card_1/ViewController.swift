//
//  ViewController.swift
//  Card_1
//
//  Created by Tapan Patel on 28/01/20.
//  Copyright © 2020 Tapan Patel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import WebKit


class ViewController: UIViewController, ARSCNViewDelegate ,WKNavigationDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    var planeNode : SCNNode!

    var facebookNode : SCNNode!
    var facebookTextNode : SCNNode!

    var InstagramNode : SCNNode!
    var InstagramTextNode : SCNNode!
    
    var TwitterNode : SCNNode!
    var TwitterTextNode : SCNNode!
    
    var DPNode :SCNNode!
    var DPText :SCNNode!
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        let tapGesture = UITapGestureRecognizer(target: self, action:   #selector(handleTap))
        // Set the scene to the view
        sceneView.addGestureRecognizer(tapGesture)
        sceneView.scene = scene
        
        let instaTextScene = SCNScene(named: "art.scnassets/Links.scn")
        InstagramTextNode = instaTextScene?.rootNode.childNode(withName: "InstagramLink", recursively: false)
        InstagramTextNode?.name = "InstagramTextNode"
        
        let FBTextScene = SCNScene(named: "art.scnassets/Links.scn")
        facebookTextNode = FBTextScene?.rootNode.childNode(withName: "FacebookLink", recursively: false)
        facebookTextNode?.name = "FacebookTextNode"
        
        let TwitterTextScene = SCNScene(named: "art.scnassets/Links.scn")
        TwitterTextNode = TwitterTextScene?.rootNode.childNode(withName: "TwitterLink", recursively: false)
        TwitterTextNode?.name = "TwitterTextNode"
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer)
    {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in:sceneViewTappedOn)
        let hittest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hittest.isEmpty
        {
            
            // print("scene")
        }
        else
        {
            let result = hittest.first!
            print(result)
            _ = result.node.position
            let name = result.node.name
            
            print(name!)
            if name == "TwitterNode"
            {
                TwitterTextNode.removeFromParentNode()
                TwitterNode.runAction(SCNAction.rotate(by: .pi * 2, around: SCNVector3(0,1,0), duration: 0.5))
                planeNode.addChildNode(TwitterTextNode)
            }
            if name == "FacebookNode"
            {
                facebookTextNode.removeFromParentNode()
                facebookNode.runAction(SCNAction.rotate(by: .pi * 2, around: SCNVector3(0,1,0), duration: 0.5))
                planeNode.addChildNode(facebookTextNode)
//                facebookTextNode.removeAllActions()
//                facebookTextNode.removeAllAnimations()
            }
            if name == "InstagramNode"
            {
                InstagramTextNode.removeFromParentNode()
                InstagramNode.runAction(SCNAction.rotate(by: .pi * 2, around: SCNVector3(0,1,0), duration: 0.5))
                planeNode.addChildNode(InstagramTextNode)
            }
           
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            else { return }
        configuration.trackingImages = trackingImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func getSocialMediaNode(fromLocation location:String, positionedAT at:SCNVector3,waitTill duration:TimeInterval,runtTill sec:TimeInterval)->SCNNode
    {
        let scene = SCNScene(named: location)
        let node = scene?.rootNode.childNodes.first!
        node?.position = at
        node?.renderingOrder = 200
        node?.runAction( SCNAction.sequence([SCNAction.wait(duration: duration),SCNAction.moveBy(x: 0.02, y: 0, z: 0, duration: sec)])  )
        return node!
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor
        {
            let referenceImage = imageAnchor.referenceImage
            
            //Detection Plane Node
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height:                                        referenceImage.physicalSize.height)
            planeNode = SCNNode(geometry: plane)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.2)
            planeNode.eulerAngles.x = -.pi/2
            planeNode.name = "DetectionPlane"
            
            //Twitter Node
            TwitterNode = getSocialMediaNode(fromLocation: "art.scnassets/twitter.scn", positionedAT: SCNVector3(0.03,0.02,0), waitTill: 2, runtTill: 0.5)
            TwitterNode.name = "TwitterNode"
            planeNode.addChildNode(TwitterNode)
            
            //Instagram Node
            InstagramNode = getSocialMediaNode(fromLocation: "art.scnassets/instagram.scn", positionedAT: SCNVector3(0.03,0,0), waitTill: 2.5, runtTill: 0.5)
            InstagramNode.name = "InstagramNode"
            planeNode.addChildNode(InstagramNode)
            
            //Facebook Node
            facebookNode = getSocialMediaNode(fromLocation: "art.scnassets/facebook.scn", positionedAT: SCNVector3(0.03,-0.015,0), waitTill: 3, runtTill: 0.5)
            facebookNode.name = "FacebookNode"
            planeNode.addChildNode(facebookNode)
            
            //Display Pic Node
            let dpPlane = SCNPlane(width: 0.06, height: 0.06)
            DPNode = SCNNode(geometry: dpPlane)
            dpPlane.firstMaterial?.diffuse.contents = UIImage(named: "oval.png")
            DPNode.renderingOrder = 200
            DPNode.position.x = -0.02
            DPNode.runAction( SCNAction.sequence([SCNAction.wait(duration: 3.5),.moveBy(x: 0, y: -0.06, z: 0, duration: 1)]) )
            DPNode.name = "DpNode"
            planeNode.addChildNode(DPNode)
            
            //DP TEXT
            let textScene = SCNScene(named: "art.scnassets/name.scn")
            DPText = textScene?.rootNode.childNodes.first!
            DPText?.scale = SCNVector3(0,0,0)
            DPText?.position.x = 0.03
            DPText?.position.y = 0.005
            DPText?.runAction( SCNAction.sequence([SCNAction.wait(duration: 4.5),.scale(to: 0.04, duration: 0.5)]) )
            DPText?.name = "TextNode"
            DPNode.addChildNode(DPText!)
            /*
             // create a web view
             let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
             let request = URLRequest(url: URL(string: "http://www.amazon.com")!)
             
             webView.loadRequest(request)
             let plane = SCNPlane(width: 1.0, height: 0.75)
             plane.firstMaterial?.diffuse.contents = webView
             plane.firstMaterial?.isDoubleSided = true
             
             let planeNode = SCNNode(geometry: plane)
             
             var translation = matrix_identity_float4x4
             translation.columns.3.z = -1.0
             
             planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
             plane.eulerAngles = SCNVector3(0,0,0)
             
             self.sceneView.scene.rootNode.addChildNode(planeNode)
             */
            //create a web view
//            DispatchQueue.main.async {
//                let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
//                let request = URLRequest(url: URL(string: "http://www.google.com")!)
//                webView.load(request)
//                let webPlane = SCNPlane(width: 0.1, height: 0.1)
//                webPlane.firstMaterial?.diffuse.contents = webView
//                plane.firstMaterial?.isDoubleSided = true
//
//                let webPlaneNode = SCNNode(geometry: webPlane)
//
//                var translation = matrix_identity_float4x4
//
//                webPlaneNode.simdTransform = matrix_multiply((self.sceneView.session.currentFrame?.camera.transform)!,translation)
//                webPlaneNode.eulerAngles = SCNVector3(0,0,0)
//
//                self.planeNode.addChildNode(webPlaneNode)
//            }
           
            
            
            
            
            
            //Mask box
            let box = SCNBox(width: 0.1, height:0.05, length: 0.01, chamferRadius: 0)
            box.firstMaterial?.diffuse.contents = UIColor.red
            let boxNode = SCNNode(geometry: box)
            boxNode.position.z = 0.03
            boxNode.position.x = -0.015
            boxNode.geometry?.firstMaterial?.transparency = 0.000001
            boxNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 5),.hide()]))
            boxNode.name = "MaskNode"
            planeNode.addChildNode(boxNode)
            
            print("image dettectedd")
            node.addChildNode(planeNode)
            // sceneView.scene.rootNode.addChildNode(node)
            //            boxNode.removeFromParentNode()
        }
        return node
    }
}




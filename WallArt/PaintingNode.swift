//
//  PaintingNode.swift
//  WallArt
//
//  Created by Olena Stepaniuk on 30.05.2021.
//

import Foundation
import ARKit

class PaintingNode: SCNNode {
    
    var image: UIImage
    var imageAspectRatio: CGFloat {
        return image.size.width/image.size.height
    }
    
    lazy var width: CGFloat = image.size.width / 10000
    lazy var height: CGFloat = image.size.height / 10000
    
    let topBottomFrameHeight: CGFloat = 0.03
    let leftRightFrameHeight: CGFloat = 0.04
    let frameLength: CGFloat = 0.04
    
    var backgroundBoxNode: SCNNode?
    var imageNode: SCNNode?
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    required init?(coder: NSCoder) {
        image = UIImage(systemName: "person.fill")!
        super.init(coder: coder)
    }
    
    private func setupBackground(position: SCNVector3) {
        // create image background
        let backgroundBox = SCNBox(width: width, height: height, length: frameLength/2, chamferRadius: 0.001)
//        backgroundBox.firstMaterial?.diffuse.contents = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        backgroundBox.firstMaterial?.diffuse.contents = UIColor.white
        backgroundBoxNode = SCNNode(geometry: backgroundBox)
        if let backgroundBoxNode = backgroundBoxNode {
            backgroundBoxNode.eulerAngles.x -= Float.pi/2
            backgroundBoxNode.position = SCNVector3(position.x, position.y + Float(backgroundBox.length/2), position.z)
            addChildNode(backgroundBoxNode)
        }
    }
    
    func setupImageNode(position: SCNVector3) {
        guard let backgroundBoxNode = backgroundBoxNode else { return }
        // create image node
        let imageGeometry = SCNPlane(width: width*0.9, height: height*0.9)
        print("width \(width) height \(height)")
        
        let material = SCNMaterial()
        material.diffuse.contents = image
        imageGeometry.materials = [material]
        
        imageNode = SCNNode(geometry: imageGeometry)
        if let imageNode = imageNode {
            imageNode.position = SCNVector3(backgroundBoxNode.position.x, position.y, position.z + Float(frameLength)/4 + 0.001)
            print("Position of image node: \(imageNode.position)")
            backgroundBoxNode.addChildNode(imageNode)
        }
    }
    
    func setup(position: SCNVector3) {
        setupBackground(position: position)
        setupImageNode(position: position)
        
        let frame = Frame(width: width, height: height, topBottomFrameHeight: topBottomFrameHeight, leftRightFrameHeight: leftRightFrameHeight, frameLength: frameLength, position: position)
        addChildNode(frame)
       
    }
}

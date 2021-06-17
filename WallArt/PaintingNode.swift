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
    let leftRightFrameHeight: CGFloat = 0.03
    let frameLength: CGFloat = 0.03
    
    var backgroundBoxNode: SCNNode?
    var imageNode: SCNNode?
    var glassNode: SCNNode?
    var glassNode1: SCNNode?
    
    lazy var lowReflection = SCNMaterial().then {
        $0.lightingModel = .physicallyBased
//        $0.diffuse.contents = UIColor.gray
        $0.specular.contents = UIColor(white: 0.6, alpha: 1.0)
        $0.roughness.contents = 0.1
        $0.metalness.contents = 0.2
        $0.transparency = 0.3
    }
    
    lazy var hightReflection = SCNMaterial().then {
        $0.lightingModel = .physicallyBased
        $0.roughness.contents = 0.05
        $0.metalness.contents = 1.0
        $0.transparency = 0.3
    }
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    required init?(coder: NSCoder) {
        image = UIImage(systemName: "person.fill")!
        super.init(coder: coder)
    }
    
    func changeReflection() {
        guard let element = glassNode?.geometry else { return }
        if element.materials.contains(hightReflection) {
            glassNode?.geometry?.materials = [lowReflection]
        } else {
            glassNode?.geometry?.materials = [hightReflection]
        }
    }
    
    func setReflection(metalness: Float? = nil, roughness: Float? = nil) {
        guard let m = glassNode?.geometry?.materials.first?.metalness, let r = glassNode?.geometry?.materials.first?.roughness else { return }
        if metalness != nil {
        m.contents = metalness
        }
        if roughness != nil {
        r.contents = roughness
        }
    }
    
    private func setupBackground(position: SCNVector3) {
        // create image background
        let backgroundBox = SCNBox(width: width, height: height, length: frameLength/3, chamferRadius: 0.001)
        //        backgroundBox.firstMaterial?.diffuse.contents = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        backgroundBox.firstMaterial?.diffuse.contents = UIColor.white
        backgroundBoxNode = SCNNode(geometry: backgroundBox)
        if let backgroundBoxNode = backgroundBoxNode {
            backgroundBoxNode.eulerAngles.x -= Float.pi/2
            backgroundBoxNode.position = SCNVector3(position.x, position.y, position.z)
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
            imageNode.position = SCNVector3(backgroundBoxNode.position.x, position.y, position.z + Float(frameLength)/6 + 0.001)
            print("Position of image node: \(imageNode.position)")
            backgroundBoxNode.addChildNode(imageNode)
        }
    }
    
    func setupForeground(position: SCNVector3) {
        guard let backgroundBoxNode = backgroundBoxNode else { return }
        let reflectiveGlass = SCNBox(width: width/2, height: height, length: 0.001, chamferRadius: 0)
        
        reflectiveGlass.materials = [hightReflection]
        
        glassNode = SCNNode(geometry: reflectiveGlass)
        if let node = glassNode {
            node.position = SCNVector3(backgroundBoxNode.position.x + Float(width)/4, position.y, position.z + Float(frameLength)/6 + 0.0011)
            backgroundBoxNode.addChildNode(node)
        }
        
        let nonReflectiveGlass = SCNBox(width: width/2, height: height, length: 0.001, chamferRadius: 0)
        
        nonReflectiveGlass.materials = [lowReflection]
        
        glassNode1 = SCNNode(geometry: nonReflectiveGlass)
        if let node = glassNode1 {
            node.position = SCNVector3(backgroundBoxNode.position.x - Float(width)/4, position.y, position.z + Float(frameLength)/6 + 0.0011)
            backgroundBoxNode.addChildNode(node)
        }
    }
    
    func setup(position: SCNVector3) {
        setupBackground(position: position)
        setupImageNode(position: position)
        setupForeground(position: position)
        
        let frame = Frame(width: width, height: height, topBottomFrameHeight: topBottomFrameHeight, leftRightFrameHeight: leftRightFrameHeight, frameLength: frameLength)
        guard let backBox = backgroundBoxNode else { return }
        frame.position = SCNVector3(backBox.position.x, backBox.position.y + Float(frameLength/1.25), backBox.position.z)
        addChildNode(frame)
    }
}

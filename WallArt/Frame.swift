//
//  Frame.swift
//  WallArt
//
//  Created by Olena Stepaniuk on 30.05.2021.
//

import Foundation
import ARKit

class Frame: SCNNode {
    var width: CGFloat
    var height: CGFloat
    
    var frameHeight: CGFloat
    var frameLength: CGFloat
    
    let nodePosition: SCNVector3
    
    var topSideNode: SCNNode?
    var leftSideNode: SCNNode?
    var rightSideNode: SCNNode?
    var bottomSideNode: SCNNode?
    
    var topLeftAngleNode: SCNNode?
    var topRightAngleNode: SCNNode?
    var bottomLeftAngleNode: SCNNode?
    var bottomRightAngleNode: SCNNode?
    
    init(width: CGFloat, height: CGFloat, frameHeight: CGFloat, frameLength: CGFloat, position: SCNVector3) {
        self.width = width
        self.height = height
        self.nodePosition = position
        self.frameHeight = frameHeight
        self.frameLength = frameLength
        super.init()
        
        setupFrameSides()
        setupFrameAngles()
    }
    
    required init?(coder: NSCoder) {
        self.width = 0
        self.height = 0
        self.frameLength = 0
        self.frameHeight = 0
        self.nodePosition = SCNVector3(0, 0, 0)
        super.init(coder: coder)
    }
    
    func setupFrameSides() {
        // create top side of the frame
        let topPart = SCNBox(width: width, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        topPart.firstMaterial?.diffuse.contents = UIImage(named: "SilverColor.jpg")
        topPart.firstMaterial?.normal.contents = UIImage(named: "SilverNormal.jpg")
        topPart.firstMaterial?.roughness.contents = UIImage(named: "SilverRoughness.jpg")

        topSideNode = SCNNode(geometry: topPart)
        if let topSideNode = topSideNode {
            topSideNode.eulerAngles.x -= Float.pi / 2
            topSideNode.position = SCNVector3(0, topPart.length/2, -height/2 - topPart.height/2)
            print("Position of top part: \(topSideNode.position)")
            addChildNode(topSideNode)
        }
        
        // create left side of the frame
        let leftSide = SCNBox(width: height, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        leftSide.firstMaterial?.diffuse.contents = UIImage(named: "SilverColor.jpg")
        leftSide.firstMaterial?.normal.contents = UIImage(named: "SilverNormal.jpg")
        leftSide.firstMaterial?.roughness.contents = UIImage(named: "SilverRoughness.jpg")
        leftSideNode = SCNNode(geometry: leftSide)
        if let leftSideNode = leftSideNode {
            leftSideNode.eulerAngles.y -= Float.pi / 2
            leftSideNode.eulerAngles.x -= Float.pi / 2
            leftSideNode.position = SCNVector3(-width/2 - leftSide.height/2, leftSide.length/2, 0)
            print("Position of left part: \(leftSideNode.position)")
            addChildNode(leftSideNode)
        }
        
        // create right part of the frame
        let rightSide = SCNBox(width: height, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        rightSide.firstMaterial?.diffuse.contents = UIImage(named: "SilverColor.jpg")
        rightSide.firstMaterial?.normal.contents = UIImage(named: "SilverNormal.jpg")
        rightSide.firstMaterial?.roughness.contents = UIImage(named: "SilverRoughness.jpg")
        rightSideNode = SCNNode(geometry: rightSide)
        if let rightSideNode = rightSideNode {
            rightSideNode.eulerAngles.y -= Float.pi / 2
            rightSideNode.eulerAngles.x -= Float.pi / 2
            rightSideNode.position = SCNVector3(width/2 + rightSide.height/2, rightSide.length/2, 0)
            print("Position of right part: \(rightSideNode.position)")
            addChildNode(rightSideNode)
        }
        
        // create bottom side of the frame
        let bottomSide = SCNBox(width: width, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        bottomSide.firstMaterial?.diffuse.contents = UIImage(named: "SilverColor.jpg")
        bottomSide.firstMaterial?.normal.contents = UIImage(named: "SilverNormal.jpg")
        bottomSide.firstMaterial?.roughness.contents = UIImage(named: "SilverRoughness.jpg")
        bottomSideNode = SCNNode(geometry: bottomSide)
        if let bottomSideNode = bottomSideNode {
            bottomSideNode.eulerAngles.x -= Float.pi / 2
            bottomSideNode.position = SCNVector3(0, bottomSide.length/2, height/2 + bottomSide.height/2)
            print("Position of bottom part: \(bottomSideNode.position)")
            addChildNode(bottomSideNode)
        }
    }
    
    func setupFrameAngles() {
        // create top left angle
        let topLeftAngle = SCNBox(width: frameHeight, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        topLeftAngle.firstMaterial?.diffuse.contents = UIColor.red
        topLeftAngleNode = SCNNode(geometry: topLeftAngle)
        if let topLeftAngleNode = topLeftAngleNode, let topSideNode = topSideNode {
            topLeftAngleNode.eulerAngles.x -= Float.pi/2
            topLeftAngleNode.position = SCNVector3(topSideNode.position.x - Float(width/2) - Float(topLeftAngle.height)/2, topSideNode.position.y, topSideNode.position.z)
            print("Position of topLeftAngleNode: \(topLeftAngleNode.position)")
            addChildNode(topLeftAngleNode)
        }
        
        // create top right angle
        let topRightAngle = SCNBox(width: frameHeight, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        topRightAngle.firstMaterial?.diffuse.contents = UIColor.red
        topRightAngleNode = SCNNode(geometry: topRightAngle)
        if let topRightAngleNode = topRightAngleNode, let topSideNode = topSideNode {
            topRightAngleNode.eulerAngles.x -= Float.pi/2
            topRightAngleNode.position = SCNVector3(topSideNode.position.x + Float(width/2) + Float(topRightAngle.height)/2, topSideNode.position.y, topSideNode.position.z)
            print("Position of topRightAngleNode: \(topRightAngleNode.position)")
            addChildNode(topRightAngleNode)
        }
        
        // create bottom left angle
        let bottomLeftAngle = SCNBox(width: frameHeight, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        bottomLeftAngle.firstMaterial?.diffuse.contents = UIColor.red
        bottomLeftAngleNode = SCNNode(geometry: bottomLeftAngle)
        if let bottomLeftAngleNode = bottomLeftAngleNode, let bottomSideNode = bottomSideNode {
            bottomLeftAngleNode.eulerAngles.x -= Float.pi/2
            bottomLeftAngleNode.position = SCNVector3(bottomSideNode.position.x - Float(width/2) - Float(bottomLeftAngle.height)/2, bottomSideNode.position.y, bottomSideNode.position.z)
            print("Position of bottomLeftAngleNode: \(bottomLeftAngleNode.position)")
            addChildNode(bottomLeftAngleNode)
            
        }
        
        // create bottom right angle
        let bottomRightAngle = SCNBox(width: frameHeight, height: frameHeight, length: frameLength, chamferRadius: 0.001)
        bottomRightAngle.firstMaterial?.diffuse.contents = UIColor.red
        bottomRightAngleNode = SCNNode(geometry: bottomLeftAngle)
        if let bottomRightAngleNode = bottomRightAngleNode, let bottomSideNode = bottomSideNode {
            bottomRightAngleNode.eulerAngles.x -= Float.pi/2
            bottomRightAngleNode.position = SCNVector3(bottomSideNode.position.x + Float(width/2) + Float(bottomRightAngle.height)/2, bottomSideNode.position.y, bottomSideNode.position.z)
            addChildNode(bottomRightAngleNode)
        }
    }
}

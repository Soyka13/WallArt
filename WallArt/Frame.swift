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
    
    var topBottomFrameHeight: CGFloat
    var leftRightFrameHeight: CGFloat
    var frameLength: CGFloat
    
    init(width: CGFloat, height: CGFloat, topBottomFrameHeight: CGFloat, leftRightFrameHeight: CGFloat, frameLength: CGFloat) {
        self.width = width
        self.height = height
        self.topBottomFrameHeight = topBottomFrameHeight
        self.leftRightFrameHeight = leftRightFrameHeight
        self.frameLength = frameLength
        super.init()
        
        setupFrameSides()
    }
    
    required init?(coder: NSCoder) {
        self.width = 0
        self.height = 0
        self.frameLength = 0
        self.topBottomFrameHeight = 0
        self.leftRightFrameHeight = 0
        super.init(coder: coder)
    }
    
    func setupFrameSides() {
        let topBottomTrapezoid = UIBezierPath()
        topBottomTrapezoid.move(to: CGPoint(x: -width/2, y: topBottomFrameHeight/2))
        topBottomTrapezoid.addLine(to: CGPoint(x: width/2, y: topBottomFrameHeight/2))
        topBottomTrapezoid.addLine(to: CGPoint(x: width/2 + topBottomFrameHeight, y: -topBottomFrameHeight/2))
        topBottomTrapezoid.addLine(to: CGPoint(x: -width/2 - topBottomFrameHeight, y: -topBottomFrameHeight/2))
        topBottomTrapezoid.close()
        
        let rightLeftTrapezoid = UIBezierPath()
        rightLeftTrapezoid.move(to: CGPoint(x: -height/2, y: leftRightFrameHeight/2))
        rightLeftTrapezoid.addLine(to: CGPoint(x: height/2, y: leftRightFrameHeight/2))
        rightLeftTrapezoid.addLine(to: CGPoint(x: height/2 + leftRightFrameHeight, y: -leftRightFrameHeight/2))
        rightLeftTrapezoid.addLine(to: CGPoint(x: -height/2 - leftRightFrameHeight , y: -leftRightFrameHeight/2))
        rightLeftTrapezoid.close()
        
        let top = SCNShape(path: topBottomTrapezoid, extrusionDepth: frameLength)
        top.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        let bodyNode = SCNNode(geometry: top)
        bodyNode.position = SCNVector3(0, frameLength/2, -height/2 - topBottomFrameHeight/2)
        bodyNode.eulerAngles = SCNVector3(90.degreesToRadians(), 0, 0)
        addChildNode(bodyNode)
        
        let left = SCNShape(path: rightLeftTrapezoid, extrusionDepth: frameLength)
        left.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        let leftNode = SCNNode(geometry: left)
        leftNode.position = SCNVector3(-width/2 - leftRightFrameHeight/2, frameLength/2, 0)
        leftNode.eulerAngles = SCNVector3(90.degreesToRadians(), 90.degreesToRadians(), 0)
        addChildNode(leftNode)
        
        let right = SCNShape(path: rightLeftTrapezoid, extrusionDepth: frameLength)
        right.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        let rightNode = SCNNode(geometry: right)
        rightNode.position = SCNVector3(width/2 + leftRightFrameHeight/2, frameLength/2, 0)
        rightNode.eulerAngles = SCNVector3(90.degreesToRadians(), -90.degreesToRadians(), 0)
        addChildNode(rightNode)

        let bot = SCNShape(path: topBottomTrapezoid, extrusionDepth: frameLength)
        bot.firstMaterial?.diffuse.contents = UIImage(named: "wood")
        let bottomNode = SCNNode(geometry: bot)
        bottomNode.position = SCNVector3(0, frameLength/2, height/2 + topBottomFrameHeight/2)
        bottomNode.eulerAngles = SCNVector3(90.degreesToRadians(), 180.degreesToRadians(), 0)
        addChildNode(bottomNode)
    }
}

extension Int {
    func degreesToRadians() -> CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}

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
        // The vertices
        let h = topBottomFrameHeight
        let r = height/2
        let w = width
        let l = frameLength
        
        //TOP
        let v0 = SCNVector3(-w/2, r, -l/2)
        let v3 = SCNVector3(-w/2-h, r+h, 0)
        let v1 = SCNVector3(w/2, r, -l/2)
        let v2 = SCNVector3(w/2+h, r+h, 0)
        
        let v4 = SCNVector3(-w/2, r, -l)
        let v6 = SCNVector3(-w/2-h, r+h, -l)
        let v5 = SCNVector3(w/2, r, -l)
        let v7 = SCNVector3(w/2+h, r+h, -l)

        //LEFT
        let v8 = SCNVector3(-w/2-h, r+h, 0)
        let v9 = SCNVector3(-w/2, r, -l/2)
        let v10 = SCNVector3(-w/2-h, -r-h, 0)
        let v11 = SCNVector3(-w/2, -r, -l/2)
        
        let v12 = SCNVector3(-w/2-h, r+h, -l)
        let v13 = SCNVector3(-w/2, r, -l)
        let v14 = SCNVector3(-w/2-h, -r-h, -l)
        let v15 = SCNVector3(-w/2, -r, -l)

        //BOT
        let v18 = SCNVector3(-w/2, -r, -l/2)
        let v16 = SCNVector3(-w/2-h, -r-h, 0)
        let v19 = SCNVector3(w/2, -r, -l/2)
        let v17 = SCNVector3(w/2+h, -r-h, 0)

        let v22 = SCNVector3(-w/2, -r, -l)
        let v20 = SCNVector3(-w/2-h, -r-h, -l)
        let v23 = SCNVector3(w/2, -r, -l)
        let v21 = SCNVector3(w/2+h, -r-h, -l)

        //RIGHT
        let v24 = SCNVector3(w/2, -r, -l/2)
        let v25 = SCNVector3(w/2+h, -r-h, 0)
        let v26 = SCNVector3(w/2, r, -l/2)
        let v27 = SCNVector3(w/2+h, r+h, 0)

        let v28 = SCNVector3(w/2, -r, -l)
        let v29 = SCNVector3(w/2+h, -r-h, -l)
        let v30 = SCNVector3(w/2, r, -l)
        let v31 = SCNVector3(w/2+h, r+h, -l)

        let vertices: [SCNVector3] = [
            /// TOP SIDE
            // Front
            v0, v2, v3,
            v0, v1, v2,
            // Bottom
            v4, v1, v0,
            v4, v5, v1,
            // Top
            v3, v7, v6,
            v3, v2, v7,
            // Back
            v5, v6, v7,
            v5, v4, v6,

            /// LEFT SIDE
            // Front
            v11, v8, v10,
            v11, v9, v8,
            // Back
            v13, v14, v12,
            v13, v15, v14,
            //Left
            v10, v12, v14,
            v10, v8, v12,
            // Right
            v15, v9, v11,
            v15, v13, v9,

            /// BOTTOM SIDE
            // Front
            v19, v16, v17,
            v19, v18, v16,
            // Bottom
            v17, v20, v21,
            v17, v16, v20,
            // Back
            v22, v21, v20,
            v22, v23, v21,
            // Top
            v23, v18, v19,
            v23, v22, v18,

            /// RIGHT SIDE
            // Front
            v26, v25, v27,
            v26, v24, v25,
            // Back
            v28, v31, v29,
            v28, v30, v31,
            // Left
            v30, v24, v26,
            v30, v28, v24,
            // Right
            v27, v29, v31,
            v27, v25, v29
        ]

        let indices = vertices.enumerated().map{Int32($0.0)}
        print(indices)
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        let topBotTexturesOffset = ((1 / (width+2*topBottomFrameHeight))) * leftRightFrameHeight
        let leftRightTexturesOffset = ((1 / (height+2*leftRightFrameHeight))) * topBottomFrameHeight
        
        let textcoord: [CGPoint] =
            [
                //TOP
                CGPoint(x: topBotTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: topBotTexturesOffset, y: 1),
                CGPoint(x: 1-topBotTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                //LEFT
                CGPoint(x: leftRightTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: leftRightTexturesOffset, y: 1),
                CGPoint(x: 1-leftRightTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                //BOT
                CGPoint(x: topBotTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: topBotTexturesOffset, y: 1),
                CGPoint(x: 1-topBotTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                //RIGHT
                CGPoint(x: leftRightTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: leftRightTexturesOffset, y: 1),
                CGPoint(x: 1-leftRightTexturesOffset, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
                
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 0),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 1, y: 1),
                CGPoint(x: 1, y: 0),
            ]
                
        let textSource = SCNGeometrySource(textureCoordinates: textcoord)

        let geometry = SCNGeometry(sources: [source, textSource], elements: [element])
        let material = SCNMaterial().then {
            $0.isDoubleSided = true
            $0.lightingModel = .physicallyBased
            $0.diffuse.contents = UIImage(named: "art.scnassets/diffuse.tif")
            $0.normal.contents = UIImage(named: "art.scnassets/normal.tif")
            $0.roughness.contents = UIImage(named: "art.scnassets/roughness.tif")
//            $0.displacement.contents = UIImage(named: "displacement")
            $0.ambientOcclusion.contents = UIImage(named: "art.scnassets/occlusion.tif")
            $0.metalness.contents = UIImage(named: "art.scnassets/metalic.tif")

            $0.diffuse.wrapS = .clamp
            $0.diffuse.wrapT = .clamp
            $0.selfIllumination.wrapS = .clamp
            $0.selfIllumination.wrapT = .clamp
        }
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)

        node.eulerAngles.x -= Float.pi/2
        addChildNode(node)
    }
}

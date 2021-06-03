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
        
        let v0 = SCNVector3(-w/2-h, r, 0)
        let v3 = SCNVector3(-w/2-h, r+h, 0)
        let v1 = SCNVector3(w/2+h, r, 0)
        let v2 = SCNVector3(w/2+h, r+h, 0)
        let v4 = SCNVector3(-w/2-h, r, -l)
        let v6 = SCNVector3(-w/2-h, r+h, -l)

        let v5 = SCNVector3(w/2+h, r, -l)
        let v7 = SCNVector3(w/2+h, r+h, -l)

        let v8 = SCNVector3(-w/2-h, r, 0)
        let v9 = SCNVector3(-w/2, r, 0)
        let v10 = SCNVector3(-w/2-h, -r, 0)
        let v11 = SCNVector3(-w/2, -r, 0)
        let v12 = SCNVector3(-w/2-h, r, -l)
        let v13 = SCNVector3(-w/2, r, -l)
        let v14 = SCNVector3(-w/2-h , -r, -l)
        let v15 = SCNVector3(-w/2, -r, -l)

        let v18 = SCNVector3(-w/2-h, -r, 0)
        let v16 = SCNVector3(-w/2-h, -r-h, 0)
        let v19 = SCNVector3(w/2+h, -r, 0)
        let v17 = SCNVector3(w/2, -r-h, 0)

        let v22 = SCNVector3(-w/2-h, -r, -l)
        let v20 = SCNVector3(-w/2-h, -r-h, -l)
        let v23 = SCNVector3(w/2, -r, -l)
        let v21 = SCNVector3(w/2, -r-h, -l)

        let v24 = SCNVector3(w/2, -r-h, 0)
        let v25 = SCNVector3(w/2+h, -r-h, 0)
        let v26 = SCNVector3(w/2, r+h, 0)
        let v27 = SCNVector3(w/2+h, r+h, 0)

        let v28 = SCNVector3(w/2, -r-h, -l)
        let v29 = SCNVector3(w/2+h, -r-h, -l)
        let v30 = SCNVector3(w/2, r+h, -l)
        let v31 = SCNVector3(w/2+h, r+h, -l)

        let vertices: [SCNVector3] = [
            /// TOP SIDE
            // Front
            v0, v2, v3,
            v0, v1, v2,
            // Left
            v2, v5, v1,
            v2, v7, v5,
            // Bottom
            v5, v0, v1,
            v5, v4, v0,
            // Top
            v7, v3, v2,
            v7, v6, v3,
            // Right
            v3, v4, v6,
            v3, v0, v4,
            // Back
            v4, v7, v5,
            v4, v6, v7,

            /// LEFT SIDE
            // Front
            v10, v9, v8,
            v10, v11, v9,
            // Top
            v9, v12, v8,
            v9, v13, v12,
            // Left
            v12, v10, v14,
            v12, v8, v10,
            // Right
            v13, v11, v9,
            v13, v15, v11,
            // Bottom
            v11, v14, v15,
            v11, v10, v14,
            // Back
            v14, v13, v12,
            v14, v15, v13,

            /// BOTTOM SIDE
            // Front
            v16, v19, v18,
            v16, v17, v19,
            // Right
            v19, v21, v17,
            v19, v23, v21,
            // Bottom
            v21, v16, v17,
            v21, v20, v16,
            // Left
            v16, v22, v18,
            v16, v20, v22,
            // Back
            v22, v21, v20,
            v22, v23, v21,
            // Top
            v23, v18, v22,
            v23, v19, v18,

            /// RIGHT SIDE
            // Front
            v24, v27, v26,
            v24, v25, v27,
            // Top
            v27, v30, v26,
            v27, v31, v30,
            // Left
            v30, v24, v26,
            v30, v28, v24,
            // Bottom
            v24, v29, v25,
            v24, v28, v29,
            // Right
            v29, v27, v31,
            v29, v25, v27,
            // Back
            v31, v28, v30,
            v31, v29, v28
        ]

        let indices = vertices.enumerated().map{Int32($0.0)}
        print(indices)
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        let textcoord: [CGPoint] = vertices.map {CGPoint(x: CGFloat($0.x), y: CGFloat($0.y))}
        
        let textSource = SCNGeometrySource(textureCoordinates: textcoord)

        let geometry = SCNGeometry(sources: [source, textSource], elements: [element])
        let material = SCNMaterial().then {
            $0.isDoubleSided = true
            $0.diffuse.contents = UIImage(named: "SilverColor")
            $0.normal.contents = UIImage(named: "SilverNormal")
            $0.roughness.contents = UIImage(named: "SilverRoughness")
            $0.diffuse.wrapS = .repeat
            $0.diffuse.wrapT = .repeat
            $0.selfIllumination.wrapS = .repeat
            $0.selfIllumination.wrapT = .repeat
        }
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)

        node.eulerAngles.x -= Float.pi/2
        addChildNode(node)
    }
}

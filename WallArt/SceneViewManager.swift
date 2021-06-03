//
//  SceneViewManager.swift
//  WallArt
//
//  Created by Olena Stepaniuk on 30.05.2021.
//

import Foundation
import ARKit
import SceneKit

class SceneViewManager {
    
    private var sceneView: ARSCNView

    private var currentNode: SCNNode?

    private var planes = [PlaneNode]()
    
    private(set) var pictureNode: PaintingNode?

    var isObjectPlaced: Bool {
        return currentNode != nil
    }
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func setupARSessionConfig() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.session.run(configuration)
        showSceneDebugInfo()
    }

    func pauseARSession() {
        guard let config = sceneView.session.configuration as? ARWorldTrackingConfiguration else { return }
        config.planeDetection = []
        print("AR session paused")
        sceneView.session.pause()
    }

    func resetARSession() {
        guard let config = sceneView.session.configuration as? ARWorldTrackingConfiguration else { return }
        config.planeDetection = .vertical
        print("session reseted")
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func showSceneDebugInfo() {
        sceneView.debugOptions = .showFeaturePoints
        sceneView.showsStatistics = true
    }

    func removeARPlaneNode(node: SCNNode) {
        for childNode in node.childNodes {
            childNode.removeFromParentNode()
        }
    }
    
    func addObject(_ image: UIImage, to node: SCNNode) {
        sceneView.scene.rootNode.enumerateChildNodes { [weak self](node, stop) in
            if node is PaintingNode {
                node.removeFromParentNode()
                    self?.currentNode = nil
            }
        }
        sceneView.setNeedsDisplay()
        if !isObjectPlaced {
            pictureNode = PaintingNode(image: image)
            guard let pictureNode = pictureNode else { return }
            pictureNode.setup(position: node.position)
            node.addChildNode(pictureNode)
            currentNode = pictureNode
        }
    }

    func addNodeAnchor(worldTransform: simd_float4x4) {
        sceneView.session.add(anchor: ARAnchor(name: "node_anchor", transform: worldTransform))
    }

    func addPlane(to node: SCNNode, anchor: ARPlaneAnchor) {
        let grid = PlaneNode(anchor: anchor)
        self.planes.append(grid)
        node.addChildNode(grid)
    }

    func getPlane(with identifier: UUID) -> PlaneNode? {
        let grid = planes.filter { grid in
            return grid.anchor.identifier == identifier
        }.first
        return grid
    }

    func removePlanes() {
        planes.forEach { $0.removeFromParentNode() }
    }

    func resetProperties() {
        currentNode = nil
        planes.removeAll()
    }
}

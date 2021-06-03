//
//  ViewController.swift
//  WallArt
//
//  Created by Olena Stepaniuk on 30.05.2021.
//

import UIKit
import SceneKit
import ARKit
import Then
import SnapKit

class ARViewController: UIViewController {
    
    private var objectImage: UIImage?
    
    private lazy var arSceneManager = SceneViewManager(sceneView: sceneView)
    
    let imagePicker = UIImagePickerController()
    
    private lazy var sceneView = ARSCNView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.session.delegate = self
        $0.delegate = self
    }
    
    private lazy var galleryButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.setTitle("G", for: .normal)
        $0.titleLabel?.textColor = .blue
        $0.setTitleColor(.blue, for: .normal)
    }
    
    private lazy var glassButton = UIButton().then {
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(changleGlass), for: .touchUpInside)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.setTitle("Reflect", for: .normal)
        $0.titleLabel?.textColor = .blue
        $0.setTitleColor(.blue, for: .normal)
    }
    
    private var viewCenter: CGPoint {
        let viewBounds = view.bounds
        return CGPoint(x: viewBounds.width / 2.0, y: viewBounds.height / 2.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sceneView.showsStatistics = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped(gesture:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arSceneManager.setupARSessionConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arSceneManager.pauseARSession()
    }
    
    @objc func screenTapped(gesture: UITapGestureRecognizer) {
        guard let query = sceneView.raycastQuery(from: viewCenter,
                                                 allowing: .existingPlaneGeometry, alignment: .vertical) else {
           return
        }

        let results = sceneView.session.raycast(query)

        if let hitTestResult = results.first {
            arSceneManager.addNodeAnchor(worldTransform: hitTestResult.worldTransform)
        }
    }
}

private extension ARViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(sceneView)
        sceneView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
        
        // create gallery button
        view.addSubview(galleryButton)
        galleryButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        view.addSubview(glassButton)
        glassButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(100)
            $0.right.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchorName = anchor.name, let objectImage = objectImage, anchorName == "node_anchor" {
            
            arSceneManager.addObject(objectImage, to: node)
            arSceneManager.removePlanes()
            glassButton.isHidden = false
            return
        }

        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical,
           !arSceneManager.isObjectPlaced {
            arSceneManager.addPlane(to: node, anchor: planeAnchor)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        guard let grid = arSceneManager.getPlane(with: planeAnchor.identifier) else { return }
        grid.update(anchor: planeAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        arSceneManager.removeARPlaneNode(node: node)
    }
}

extension ARViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func showImagePicker() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .automatic
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func changleGlass() {
        arSceneManager.pictureNode?.changeReflection()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imagePicker.dismiss(animated: true, completion: nil)
        self.objectImage = image
    }
}

// MARK: - ARSessionDelegate
extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        arSceneManager.resetProperties()
    }

    func sessionWasInterrupted(_ session: ARSession) {
        arSceneManager.resetProperties()
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        arSceneManager.resetARSession()
    }
}

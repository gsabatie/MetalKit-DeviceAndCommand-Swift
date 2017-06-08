//
//  GameViewController.swift
//  Devices-CommandsSwift
//
//  Created by Guillaume Sabatie on 6/8/17.
//  Copyright © 2017 Guillaume Sabatie. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class GameViewController:UIViewController {
    fileprivate var _view :MTKView!
    fileprivate var _renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view = view as! MTKView
        _view.device = MTLCreateSystemDefaultDevice()
        if _view.device == nil {
            print("Metal is not supported on this device")
            self.view =  UIView()
        }
        
        _renderer = Renderer(with: _view)
        
        if _renderer == nil {
            print("Renderer failed initialization")
        }
        _view.delegate = _renderer
        
        _view.preferredFramesPerSecond = 60
    }
    
}

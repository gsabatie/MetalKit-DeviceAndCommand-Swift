//
//  APPLRenderer.swift
//  Devices-CommandsSwift
//
//  Created by Guillaume Sabatie on 6/8/17.
//  Copyright © 2017 Guillaume Sabatie. All rights reserved.
//

import Foundation
import MetalKit

public struct Color {
    var red:Float
    var green:Float
    var blue:Float
    var alpha:Float
}

class Renderer : NSObject{
    
    fileprivate var device : MTLDevice!
    fileprivate var commandQueue : MTLCommandQueue!
    
    
    init(with metalKitView:MTKView) {
        super.init()
        device = metalKitView.device
        commandQueue = device?.makeCommandQueue()
    }
    
    private func makeFancyColor() -> Color {
         struct fancyColorDescriptor {
            static var growing = true
            static var primaryChannel = 0
            static var colorChannels : [Float] = [1.0, 0.0 ,0.0, 1.0]
        }
        
        let dynamicColorRate: Float = 0.015
        
        if (fancyColorDescriptor.growing) {
            let  dynamicChannelIndex = (fancyColorDescriptor.primaryChannel + 1) % 3
            fancyColorDescriptor.colorChannels[dynamicChannelIndex] += dynamicColorRate
            if(fancyColorDescriptor.colorChannels[dynamicChannelIndex] >= 1.0)
            {
                fancyColorDescriptor.growing = false
                fancyColorDescriptor.primaryChannel = dynamicChannelIndex;
            }
        } else {
            let dynamicChannelIndex = (fancyColorDescriptor.primaryChannel + 2) % 3
            fancyColorDescriptor.colorChannels[dynamicChannelIndex] -= dynamicColorRate
            if(fancyColorDescriptor.colorChannels[dynamicChannelIndex] <= 0.0)
            {
                fancyColorDescriptor.growing = true
            }
        }
     return  Color(red: fancyColorDescriptor.colorChannels[0],green: fancyColorDescriptor.colorChannels[1], blue: fancyColorDescriptor.colorChannels[2], alpha: fancyColorDescriptor.colorChannels[3])
        
   }
}

extension Renderer :MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        let color = makeFancyColor()
        
        view.clearColor = MTLClearColor(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer.label = "myCommandBuffer"
        
        if let renderPassDescriptor = view.currentRenderPassDescriptor {
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder.label = "myRenderEncoder"
            
            renderEncoder.endEncoding()
            
            if let currentDrawable = view.currentDrawable {
                commandBuffer.present(view.currentDrawable)
            }
        }
        commandBuffer.commit()
    }
    
    
}

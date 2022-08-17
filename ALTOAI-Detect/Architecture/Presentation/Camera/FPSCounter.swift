//
//  FPSCounter.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 17/08/2022.
//

import Foundation
import QuartzCore

final class FPSCounter {
    
    var frames = 0
    var startTime: CFTimeInterval = 0
    
    private(set) public var fps: Double = 0
    
    func start() {
        frames = 0
        startTime = CACurrentMediaTime()
    }
    
    func frameCompleted() {
        frames += 1
        let now = CACurrentMediaTime()
        let elapsed = now - startTime
        if elapsed >= 0.01 {
            fps = Double(frames) / elapsed
            if elapsed >= 1 {
                frames = 0
                startTime = now
            }
        }
    }
}

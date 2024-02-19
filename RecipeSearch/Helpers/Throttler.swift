//
//  Throttler.swift
//  RecipeSearch
//
//  Created by user on 18.02.2024.
//

import Foundation

class Throttler {
    private var workItem: DispatchWorkItem?
    
    func throttle(delay: TimeInterval, block: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem {
            block()
        }
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}

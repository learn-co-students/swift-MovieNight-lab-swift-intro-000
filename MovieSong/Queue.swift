//
//  Queue.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit


final class Queue {
    
    typealias Operation = (() -> Void)
    
    var operations: [(Operation, UIViewAnimationOptions, Double)] = []
    var performingOperations = false
    let imageView: UIImageView
    
    init(imageView: UIImageView) { self.imageView = imageView }
    
    func addOperation(@autoclosure(escaping) op: Operation, animation: UIViewAnimationOptions = .TransitionCrossDissolve, duration: Double = 0.1 ) {
        operations.append((op, animation, duration))
        if !performingOperations { performNextOperation() }
    }
    
    func performNextOperation() {
        guard !performingOperations else { return }
        guard !operations.isEmpty else { return }
        performingOperations = true
        let (operation, animation, duration) = operations.first!
        
        UIView.transitionWithView(imageView, duration: duration, options: [animation, .AllowUserInteraction], animations: operation) { _ in
            if !self.operations.isEmpty {
            _ = self.operations.removeFirst()
            self.performingOperations = false
            self.performNextOperation()
            }
        }
    }
    
    func clearOperations() {
        operations.removeAll()
        performingOperations = false
    }
    
}
//
//  MovieImageState.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

enum MovieImageState {
    
    case Loading(UIImage)
    case Downloaded(UIImage)
    case NoImage(UIImage)
    case Nothing
    
    init() {
        self = .Nothing
    }
    
    mutating func noImage() {
        self = .NoImage(UIImage(imageLiteralResourceName: "MoviePoster"))
    }
    
    mutating func loadingImage() {
        self = .Loading(UIImage(imageLiteralResourceName: "LoadingPoster"))
    }
    
    mutating func nothingImage() {
        self = .Nothing
    }
    
}

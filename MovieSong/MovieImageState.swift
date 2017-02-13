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
    
    case loading(UIImage)
    case downloaded(UIImage)
    case NoImage(UIImage)
    case nothing
    
    init() {
        self = .nothing
    }
    
    mutating func noImage() {
        self = .NoImage(UIImage(imageLiteral: "MoviePoster"))
    }
    
    mutating func loadingImage() {
        self = .loading(UIImage(imageLiteral: "LoadingPoster"))
    }
    
    mutating func nothingImage() {
        self = .nothing
    }
    
}

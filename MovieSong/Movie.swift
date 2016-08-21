//
//  Movie.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
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
        self = .NoImage(UIImage(imageLiteral: "MoviePoster"))
    }
    
    mutating func loadingImage() {
        self = .Loading(UIImage(imageLiteral: "LoadingPoster"))
    }
    
}

protocol MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie)
    
}

final class Movie {
    
    let title: String
    let year: String
    let imdbID: String
    let posterURLString: String?
    
    var rated: String = "No Rating"
    var released: String = "No Release Date"
    var director: String = "No Director"
    var imdbRating: String = "N/A"
    var tomatoMeter: String = "N/A"
    var plot: String = "No Plot"
    
    var attemptedToDownloadImage = false
    var movieImageDelegate: MovieImageDelegate?
    
    var shouldKickOffImageDownload: Bool {
        switch (imageState, attemptedToDownloadImage) {
        case (.Loading(_), false): return true
        case (.Nothing, false): return true
        default: return false
        }
    }
    
    var image: UIImage? {
        
        switch imageState {
        case .Loading(let image):
            if shouldKickOffImageDownload { downloadImage() }
            return image
        case .Downloaded(let image):
            return image
        case .NoImage(let image):
            return image
        case .Nothing:
            if shouldKickOffImageDownload {  downloadImage() }
            return nil
        }
    }
        
    var imageState = MovieImageState() {
        didSet {
            movieImageDelegate?.imageUpdate(withMovie: self)
        }
    }
    
    init(json: JSONResponseDictionary, movieImageDelegate: MovieImageDelegate? = nil) {
        title = json["Title"] ?? "No Title"
        year = json["Year"] ?? "No Year"
        rated = json["Rated"] ?? "No Rating"
        released = json["Released"] ?? "No Release Date"
        director = json["Director"] ?? "No Director"
        posterURLString = json["Poster"]
        imdbRating = json["imdbRating"] ?? "N/A"
        tomatoMeter = json["tomatoMeter"] ?? "N/A"
        imdbID = json["imdbID"] ?? "N/A"
        plot = json["Plot"] ?? "No Plot"
        
        self.movieImageDelegate = movieImageDelegate
    }
    
    init(searchJSON: JSONResponseDictionary, movieImageDelegate: MovieImageDelegate? = nil) {
        title = searchJSON["Title"] ?? "No Title"
        year = searchJSON["Year"] ?? "No Year"
        imdbID = searchJSON["imdbID"] ?? "N/A"
        posterURLString = searchJSON["Poster"]
        self.movieImageDelegate = movieImageDelegate
    }
    
}

// MARK: Download Image Methods

extension Movie {
    
    func downloadImage()  {
        self.imageState = .Nothing
        loadingImage()
        guard attemptedToDownloadImage == false else { return }
        attemptedToDownloadImage = true
        guard let posterURLString = posterURLString, let posterURL = NSURL(string: posterURLString) else { noImage(); return }
        downloadImage(withURL: posterURL)
    }
    
    func downloadImage(withURL URL: NSURL) {
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        defaultSession.dataTaskWithURL(URL) { data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                if error != nil || data == nil { self.noImage() }
                if data != nil {
                    let image = UIImage(data: data!)
                    if image == nil {
                       self.noImage()
                    } else {
                        self.imageState = .Downloaded(image!)
                    }
                }
            })
            }.resume()
    }
    
    func noImage() {
        imageState.noImage()
    }
    
    func loadingImage() {
        imageState.loadingImage()
    }
    
}
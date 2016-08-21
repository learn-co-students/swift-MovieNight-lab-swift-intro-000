//
//  Movie.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

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
    var shouldKickOffImageDownload: Bool { return shouldKickOffTheDownload() }
    var image: UIImage? { return retrieveImage() }
        
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

// MARK: Image Methods

extension Movie {
    
    private func retrieveImage() -> UIImage? {
        switch imageState {
        case .Loading(let image):
            if shouldKickOffImageDownload { downloadImage() }
            return image
        case .Downloaded(let image): return image
        case .NoImage(let image): return image
        case .Nothing:
            if shouldKickOffImageDownload {  downloadImage() }
            return nil
        }
    }
    
    func noImage() {
        imageState.noImage()
    }
    
    func loadingImage() {
        imageState.loadingImage()
    }
    
    func nothingImage() {
        imageState.nothingImage()
    }
    
}

// MARK: Download Image Methods

extension Movie {
    
    func downloadImage()  {
        nothingImage()
        loadingImage()
        guard !attemptedToDownloadImage else { return }
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
    
    private func shouldKickOffTheDownload() -> Bool {
        switch (imageState, attemptedToDownloadImage) {
        case (.Loading(_), false): return true
        case (.Nothing, false): return true
        default: return false
        }
    }
    
}
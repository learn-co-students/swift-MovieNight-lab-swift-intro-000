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
    
    var title: String
    var year: String
    var imdbID: String
    var posterURLString: String?
    var hasFullInfo = false
    var rated = "No Rating"
    var released = "No Release Date"
    var director = "No director"
    var imdbRating = "N/A"
    var tomatoMeter = "N/A"
    var plot = "No Plot"
    
    var attemptedToDownloadImage = false
    var movieImageDelegate: MovieImageDelegate?
    var shouldKickOffImageDownload: Bool { return shouldKickOffTheDownload() }
    var image: UIImage? { return retrieveImage() }
    var imageState = MovieImageState() {
        didSet {
            movieImageDelegate?.imageUpdate(withMovie: self)
        }
    }
    
    init(dictionary: [String: String]) {
        self.title = dictionary["Title"] ?? "No Title"
        self.year = dictionary["Year"] ?? "No Year"
        self.imdbID = dictionary["imdbID"] ?? "No imdbID"
        self.posterURLString = dictionary["Poster"]
    }
    
    // TODO: Instruction #4, create the updateFilmInfo(_:) method
    
    func updateFilmInfo(_ jsonResponse: [String: String]) {
        guard let rated = jsonResponse["Rated"], let released = jsonResponse["Released"], let director = jsonResponse["Director"], let imdbRating = jsonResponse["imdbRating"], let tomatoMeter = jsonResponse["tomatoMeter"], let plot = jsonResponse["Plot"] else { return }
        self.hasFullInfo = true
        self.rated = rated
        self.released = released
        self.director = director
        self.imdbRating = imdbRating
        self.tomatoMeter = tomatoMeter
        self.plot = plot
    }
}


// MARK: Image Methods
extension Movie {
    
    fileprivate func retrieveImage() -> UIImage? {
        switch imageState {
        case .loading(let image):
            if shouldKickOffImageDownload { downloadImage() }
            return image
        case .downloaded(let image): return image
        case .NoImage(let image): return image
        case .nothing:
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
        guard let posterURLString = posterURLString, let posterURL = URL(string: posterURLString) else { noImage(); return }
        downloadImage(withURL: posterURL)
    }
    
    func downloadImage(withURL URL: Foundation.URL) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        defaultSession.dataTask(with: URL, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: {
                if error != nil || data == nil { self.noImage() }
                if data != nil {
                    let image = UIImage(data: data!)
                    if image == nil {
                       self.noImage()
                    } else {
                        self.imageState = .downloaded(image!)
                    }
                }
            })
            }) .resume()
    }
    
    fileprivate func shouldKickOffTheDownload() -> Bool {
        switch (imageState, attemptedToDownloadImage) {
        case (.loading(_), false): return true
        case (.nothing, false): return true
        default: return false
        }
    }
    
}


// MARK: Update Info
extension Movie {
    
    func updateInfo(handler: @escaping (Bool) -> Void) throws {
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        guard let urlString = imdbID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else { throw MovieError.badSearchString("Unable to encode \(title) to use within our search.") }
        
        guard let searchURL = URL(string: "http://www.omdbapi.com/?i=\(urlString)&plot=full&r=json&tomatoes=true")
            else { throw MovieError.badSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTask(with: searchURL) { [unowned self] data, response, error in
            DispatchQueue.main.async(execute: {
                if error != nil { handler(false) }
                if data == nil { handler(false) }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! JSONResponseDictionary
                    else { handler(false); return }
                            
                self.updateFilmInfo(jsonResponse)
            
                self.hasFullInfo = true

                handler(true)
            })
            }.resume()
    }

}


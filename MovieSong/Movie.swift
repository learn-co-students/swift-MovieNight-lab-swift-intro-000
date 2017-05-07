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
    
    // TODO: Instruction #1, create instance properties
    
    let title: String
    let year: String
    let imdbID: String
    let posterURLString: String?
    
    
    // TODO: Instruction #4, create more instance properties
    
    var hasFullInfo: Bool = false
    var rated: String = "No rating"
    var released: String = "No Release Date"
    var director: String = "No director"
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
    
    
    // TODO: Instruction #2, create Initializer 
    init(response: [String : String]) {
        
        //Nil Coalescing
        title = response["Title"] ?? "No Title"
        year = response["Year"] ?? "Year Unknown"
        imdbID = response["imdbID"] ?? "imdbID Unknown"
        posterURLString = response["Poster"]
        
    }
    
    // TODO: Instruction #4, create the updateFilmInfo(_:) method
    func updateFilmInfo(_ response: [String: String]) {
        rated = response["Rated"] ?? "N/A"
        released = response["Released"] ?? "N/A"
        director = response["Director"] ?? "N/A"
        imdbRating = response["imdbRating"] ?? "N/A"
        tomatoMeter = response["tomatoMeter"] ?? "N/A"
        plot = response["Plot"] ?? "N/A"
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
    
    func updateInfo(_ handler: @escaping (Bool) -> Void) throws {
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

        guard let urlString = imdbID.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            else { throw MovieError.badSearchString("Unable to encode \(title) to use within our search.") }
        
        guard let searchURL = URL(string: "http://www.omdbapi.com/?i=\(urlString)&plot=full&r=json&tomatoes=true")
            else { throw MovieError.badSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTask(with: searchURL, completionHandler: { [unowned self] data, response, error in
            DispatchQueue.main.async(execute: {
                if error != nil { handler(false) }
                if data == nil { handler(false) }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! JSONResponseDictionary
                    else { handler(false); return }
                            
                self.updateFilmInfo(jsonResponse)
            
                self.hasFullInfo = true

                handler(true)
            })
            }) .resume()
    }

}


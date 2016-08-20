//
//  MovieManager.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/19/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit

typealias JSONResponseDictionary = [String : String]

enum MovieError: ErrorType {
    
    case BadSearchString(String)
    case BadSearchURL(String)
    case NoData(String)
    case BadJSONconversion(String)
    
}

final class MovieManager {
    
    var delegate: MovieImageDelegate?
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    init(delegate: MovieImageDelegate? = nil) {
        self.delegate = delegate
    }
    
}


// MARK: Search Methods

extension MovieManager {
    
    func search(forFilm film: String, withHandler handler: (Movie?, MovieError?) -> Void) throws {
        guard let urlString = film.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else { throw MovieError.BadSearchString("Unable to encode \(film) to use within our search.") }
        
        guard let searchURL = NSURL(string: "http://www.omdbapi.com/?t=\(urlString)&y=&plot=short&r=json")
            else { throw MovieError.BadSearchURL("Unable to create URL with the search term: \(film)") }
        
        defaultSession.dataTaskWithURL(searchURL) { [unowned self] data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                if error != nil { handler(nil, MovieError.NoData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.NoData("Data has come back nil.")) }
                
                guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! JSONResponseDictionary
                    else { handler(nil, MovieError.BadJSONconversion("Unable to convert data to JSON")); return }
                
                let movie = Movie(json: jsonResponse, movieImageDelegate: self.delegate)
                
                handler(movie, nil)
            })
            }.resume()
    }
    
}



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
    let rated: String
    let released: String
    let director: String
    let posterURLString: String?
    let imdbRating: String
    let tomatoMeter: String
    var attemptedToDownloadImage = false
    var movieImageDelegate: MovieImageDelegate?
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
        self.movieImageDelegate = movieImageDelegate
    }
    
}

// MARK: Download Image Methods

extension Movie {
    
    func downloadImage()  {
        loadingImage()
        guard attemptedToDownloadImage == false
            else { return }
        
        attemptedToDownloadImage = true
        
        
        guard let posterURLString = posterURLString, let posterURL = NSURL(string: posterURLString)
            else { noImage(); return }
        
        downloadImage(withURL: posterURL)
    }
    
    
    func downloadImage(withURL URL: NSURL) {
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        defaultSession.dataTaskWithURL(URL) { data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                if error != nil || data == nil { self.imageState = .NoImage(UIImage(imageLiteral: "MoviePoster")) }
                let image = UIImage(data: data!)
                if image == nil { self.imageState = .NoImage(UIImage(imageLiteral: "MoviePoster")) }
                self.imageState = .Downloaded(image!)
                
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
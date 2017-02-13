//
//  MovieManager.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/19/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit


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
typealias JSONResponseDictionary = [String : String]
typealias JSONSearchDictionary = [String : [[String : String]]]

extension MovieManager {
    
    func search(forFilmWithID film: String, withHandler handler: (Movie?, MovieError?) -> Void) throws {
        guard let urlString = film.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else { throw MovieError.BadSearchString("Unable to encode \(film) to use within our search.") }
        
        guard let searchURL = NSURL(string: "http://www.omdbapi.com/?i=\(urlString)&plot=full&r=json")
            else { throw MovieError.BadSearchURL("Unable to create URL with the search term: \(film)") }
        
        defaultSession.dataTaskWithURL(searchURL) { [unowned self] data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                if error != nil { handler(nil, MovieError.NoData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.NoData("Data has come back nil.")) }
                
                guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! JSONResponseDictionary
                    else { handler(nil, MovieError.BadJSONconversion("Unable to convert data to JSON")); return }
                
                let movie = Movie(searchJSON: jsonResponse)
                
                movie.movieImageDelegate = self.delegate
                
                handler(movie, nil)
            })
            }.resume()
    }
    
    func search(forFilmsWithTitle title: String, handler: ([Movie]?, MovieError?) -> Void) throws {
        guard let urlString = title.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else { throw MovieError.BadSearchString("Unable to encode \(title) to use within our search.") }
        
        guard let searchURL = NSURL(string: "http://www.omdbapi.com/?s=\(urlString)&y=&plot=full&r=json")
            else { throw MovieError.BadSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTaskWithURL(searchURL) { [unowned self] data, response, error in
            dispatch_async(dispatch_get_main_queue(),{
                if error != nil { handler(nil, MovieError.NoData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.NoData("Data has come back nil.")) }
                
                guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject], let search = jsonResponse["Search"]
                    else { handler(nil, MovieError.BadJSONconversion("Unable to convert data to JSON")); return }
                
                let actualSearch: [[String : String]] = search as! [[String : String]]
                
                let movies = actualSearch.map { movieJSON in Movie(searchJSON: movieJSON, movieImageDelegate: self.delegate) }
                
                handler(movies, nil)
            })
            }.resume()
        
    }
    
}


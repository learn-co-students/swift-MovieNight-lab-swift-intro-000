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
                
                var movies: [Movie] = []
            
                
                // TODO: Insctruction #3, Loop through the actualSearch array, create movie objects within the for loop using the Initializer you created that can take in an argument of type [String : String]. Then append these newly made movies to the movies variable.
                
                for movieJSON in actualSearch {
                    let movie = Movie(searchJSON: movieJSON)
                    
                        movie.movieImageDelegate = self.delegate
                        movies.append(movie)
                    
                }
                handler(movies, nil)
            })
            }.resume()
        
    }
    
}


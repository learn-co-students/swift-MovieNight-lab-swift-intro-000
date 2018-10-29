//
//  MovieManager.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/19/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit


enum MovieError: Error {
    
    case BadSearchString(String)
    case BadSearchURL(String)
    case NoData(String)
    case BadJSONconversion(String)
    
}

final class MovieManager {
    
    var delegate: MovieImageDelegate?
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(delegate: MovieImageDelegate? = nil) {
        self.delegate = delegate
    }
    
}


// MARK: Search Methods

typealias JSONResponseDictionary = [String : String]
typealias JSONSearchDictionary = [String : [[String : String]]]

extension MovieManager {
    
    func search(forFilmsWithTitle title: String, handler: @escaping ([Movie]?, MovieError?) -> Void) throws {
        guard let urlString = title.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            else { throw MovieError.BadSearchString("Unable to encode \(title) to use within our search.") }
        
        guard let searchURL = NSURL(string: "http://www.omdbapi.com/?s=\(urlString)&y=&plot=full&r=json")
            else { throw MovieError.BadSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTask(with: searchURL as URL) { [unowned self] data, response, error in
            DispatchQueue.main.async {
                if error != nil { handler(nil, MovieError.NoData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.NoData("Data has come back nil.")) }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject], let search = jsonResponse["Search"]
                    else { handler(nil, MovieError.BadJSONconversion("Unable to convert data to JSON")); return }
                
                print(jsonResponse)
                
                let actualSearch: [[String : String]] = search as! [[String : String]]
                
                var movies: [Movie] = []
            
                
                // TODO: Insctruction #3, Loop through the actualSearch array, create movie objects within the for loop using the Initializer you created that can take in an argument of type [String : String]. Then append these newly made movies to the movies variable.
                
                for result in actualSearch {
                    movies.append(Movie(movieJSON: result))
                }
                
                for movie in movies {
                    movie.movieImageDelegate = self.delegate
                }
                
                handler(movies, nil)
            }
            }.resume()
        
    }
    
}


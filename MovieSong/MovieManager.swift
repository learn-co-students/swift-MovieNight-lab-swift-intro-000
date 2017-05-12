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
    
    case badSearchString(String)
    case badSearchURL(String)
    case noData(String)
    case badJSONconversion(String)
    
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
        guard let urlString = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            else { throw MovieError.badSearchString("Unable to encode \(title) to use within our search.") }
        
        guard let searchURL = URL(string: "http://www.omdbapi.com/?s=\(urlString)&y=&plot=full&r=json")
            else { throw MovieError.badSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTask(with: searchURL, completionHandler: { [unowned self] data, response, error in
            DispatchQueue.main.async(execute: {
                if error != nil { handler(nil, MovieError.noData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.noData("Data has come back nil.")) }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject], let search = jsonResponse["Search"]
                    else { handler(nil, MovieError.badJSONconversion("Unable to convert data to JSON")); return }
                
                let actualSearch: [[String : String]] = search as! [[String : String]]
                
                let movies: [Movie] = []
            
                
                // TODO: Insctruction #3, Loop through the actualSearch array, create movie objects within the for loop using the Initializer you created that can take in an argument of type [String : String]. Then append these newly made movies to the movies variable.
                for search in actualSearch {
                    let newMovie: Movie = Movie(movieJSON: search)
                    movies.append(newMovie)
                }
                
                for movie in movies {
                    movie.movieImageDelegate = self.delegate
                }
                
                handler(movies, nil)
            })
            }) .resume()
        
    }
    
}


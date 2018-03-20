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
        print("search()-input: searchTitle = \(title)")
        guard let urlString = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            else { throw MovieError.badSearchString("Unable to encode \(title) to use within our search.") }
        print("search()-input: urlString = \(urlString)")
        guard let searchURL = URL(string: "http://www.omdbapi.com/?apikey=375048c5&s=\(urlString)&y=&plot=full&r=json")
            else { throw MovieError.badSearchURL("Unable to create URL with the search term: \(title)") }
        
        defaultSession.dataTask(with: searchURL, completionHandler: { [unowned self] data, response, error in
            DispatchQueue.main.async(execute: {
                if error != nil { handler(nil, MovieError.noData(error!.localizedDescription)) }
                if data == nil { handler(nil, MovieError.noData("Data has come back nil.")) }
                print("data1 = \(String(describing: data))")
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject], let search = jsonResponse["Search"]
                    else { handler(nil, MovieError.badJSONconversion("Unable to convert data to JSON")); return }
                
                let actualSearch: [[String : String]] = search as! [[String : String]]
                
                var movies: [Movie] = []
                
                
                for hits in actualSearch {
                    //print("hits(in MovieManager.swift) = \(hits)")
                    let movieHit = Movie(movieJSON: hits)
                    print("after Movie(movieJSON:), movieHit.imdbID = \(movieHit.year)")
                    movies.append(movieHit)
                }
                print("movies= \(movies)")
                
                // TODO: Insctruction #3, Loop through the actualSearch array, create movie objects within the for loop using the Initializer you created that can take in an argument of type [String : String]. Then append these newly made movies to the movies variable.
                
                
                for movie in movies {
                    movie.movieImageDelegate = self.delegate
                    
                }
                
                
                handler(movies, nil)
            })
            }) .resume()
        
    }
    
}


//
//  MovieViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/19/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movieManager: MovieManager!
    var queue: Queue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = Queue(imageView: posterImageView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        movieManager = MovieManager(delegate: self)
        
        do {
            
            try movieManager.search(forFilm: "Titanic") { movie, error in
                
                movie?.downloadImage()
            }
            
        } catch MovieError.BadSearchString(let errorMessage) {
            
            print("Bad Search String: \(errorMessage)")
            
        } catch MovieError.BadSearchURL(let errorMessage) {
            
            print("Bad Search URL: \(errorMessage)")
            
        } catch {
            
            // TODO: Catch other errors
            
        }

    }
    
    
}

extension MovieViewController: MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie) {
        switch movie.imageState {
        case .Loading(let image):
            print("Adding loading operation dude!!!")
            queue.addOperation(self.posterImageView.image = image, animation: .TransitionCrossDissolve, duration: 10.0)
        case .NoImage(let image):
            print("Add NO IMAGE OPERATION!!!!!!!!")
            queue.addOperation(self.posterImageView.image = image)
       case .Downloaded(let image):
        queue.addOperation(self.posterImageView.image = image)
        case .Nothing:
            fatalError()
        }
    }
    
}



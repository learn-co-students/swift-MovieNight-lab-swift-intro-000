//
//  MovieDetailViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieScores: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var moviePlot: UITextView!
    

    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllViews()
        handleLayoutOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}


// MARK: Setup

extension MovieDetailViewController {
    
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        
        movieTitle.alpha = 0.0
        movieDirector.alpha = 0.0
        movieReleaseDate.alpha = 0.0
        movieRating.alpha = 0.0
        movieScores.alpha = 0.0
        moviePoster.alpha = 0.0
        moviePlot.alpha = 0.0
        
    }
    
    func unHideAllViews() {
        UIView.animate(withDuration: 0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            self.movieTitle.alpha = 1.0
            self.movieDirector.alpha = 1.0
            self.movieReleaseDate.alpha = 1.0
            self.movieRating.alpha = 1.0
            self.movieScores.alpha = 1.0
            self.moviePoster.alpha = 1.0
            self.moviePlot.alpha = 1.0
    
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
       movieTitle.text = movie.title
        movieDirector.text = movie.director
        movieReleaseDate.text = movie.released
        movieRating.text = movie.rated
        movieScores.text = "IMDB: \(movie.imdbRating) / rt: \(movie.tomatoMeter)%"
        moviePoster.image = movie.image
        moviePlot.text = movie.plot
        
        unHideAllViews()
    }
    
    func handleLayoutOnLoad() {
        if movie.hasFullInfo {
            setupAllTheViews()
        }
        
        if !movie.hasFullInfo {
            retrieveInfoForMovie()
        }
    }
    
    func retrieveInfoForMovie() {
        try! movie.updateInfo { [unowned self] success in
            if success {
                self.setupAllTheViews()
            }
        }
    }
    
}


// MARK: Gesture Recognizer

extension MovieDetailViewController {
    
    // TODO: Instruction #6, E.T. Go Home
    
    
    

}

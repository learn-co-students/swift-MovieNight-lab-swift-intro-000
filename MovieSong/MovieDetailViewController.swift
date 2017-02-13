//
//  MovieDetailViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var moviePlot: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllViews()
        handleLayoutOnLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}


// MARK: Setup

extension MovieDetailViewController {
    
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        
        moviePosterImage.alpha = 0.0
        movieTitleLabel.alpha = 0.0
        directorLabel.alpha = 0.0
        releaseDateLabel.alpha = 0.0
        movieRatingLabel.alpha = 0.0
        imdbRating.alpha = 0.0
        moviePlot.alpha = 0.0
        
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            self.moviePosterImage.alpha = 1.0
            self.movieTitleLabel.alpha = 1.0
            self.directorLabel.alpha = 1.0
            self.releaseDateLabel.alpha = 1.0
            self.movieRatingLabel.alpha = 1.0
            self.imdbRating.alpha = 1.0
            self.moviePlot.alpha = 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
        
        moviePosterImage.image = movie.image
        movieTitleLabel.text = movie.title
        directorLabel.text = movie.director
        releaseDateLabel.text = movie.released
        movieRatingLabel.text = movie.rated
        imdbRating.text = "imdb: \(movie.imdbRating) / rt: \(movie.tomatoMeter)"
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
            } else {
                
                print("Could not update info")
            }
        }
    }
    
}


// MARK: Gesture Recognizer

extension MovieDetailViewController {
    
    // TODO: Instruction #6, E.T. Go Home

}

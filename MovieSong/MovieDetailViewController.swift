//
//  MovieDetailViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var tomatoLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var plotTextView: UITextView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 30
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
        
        changeDetailsAlpha(for: 0.0)

    }
    
    func unHideAllViews() {
        UIView.animate(withDuration: 0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
       
        titleLabel.text = movie.title
        directorLabel.text = movie.director
        releaseLabel.text = movie.released
        ratingLabel.text = movie.rated
        imdbLabel.text = "IMDB rating: \(movie.imdbRating)"
        tomatoLabel.text = "RottenTomato: \(movie.tomatoMeter)%"
        posterImageView.image = movie.image
        plotTextView.text = movie.plot
        
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
    
    func changeDetailsAlpha(for alpha: CGFloat) {
        titleLabel.alpha = alpha
        directorLabel.alpha = alpha
        releaseLabel.alpha = alpha
        ratingLabel.alpha = alpha
        imdbLabel.alpha = alpha
        tomatoLabel.alpha = alpha
        posterImageView.alpha = alpha
        plotTextView.alpha = alpha
    }

}

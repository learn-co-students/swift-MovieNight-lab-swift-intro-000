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

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieReleasedLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieScoreLabel: UILabel!
    @IBOutlet weak var moviePlotTextView: UITextView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllViews()
        handleLayoutOnLoad()
        contentView.layer.cornerRadius = 15.0
        contentView.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupGestureView()
    }
    
}


// MARK: Setup

extension MovieDetailViewController {
    
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        movieTitleLabel.alpha = 0.0
        movieDirectorLabel.alpha = 0.0
        movieReleasedLabel.alpha = 0.0
        movieRatingLabel.alpha = 0.0
        movieScoreLabel.alpha = 0.0
        moviePlotTextView.alpha = 0.0
        moviePosterImageView.alpha = 0.0
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            self.movieTitleLabel.alpha = 1.0
            self.movieDirectorLabel.alpha = 1.0
            self.movieReleasedLabel.alpha = 1.0
            self.movieRatingLabel.alpha = 1.0
            self.movieScoreLabel.alpha = 1.0
            self.moviePlotTextView.alpha = 1.0
            self.moviePosterImageView.alpha = 1.0
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
        movieTitleLabel.text = movie.title
        movieDirectorLabel.text = movie.director
        movieReleasedLabel.text = movie.released
        movieRatingLabel.text = movie.rated
        movieScoreLabel.text = "imdb: \(movie.imdbRating)/ rt: \(movie.tomatoMeter)"
        moviePlotTextView.text = movie.plot
        moviePosterImageView.image = movie.image
        
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
    func setupGestureView() {
        let gestureView = UIView(frame: view.bounds)
        gestureView.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureView.addGestureRecognizer(gestureRecognizer)
        view.insertSubview(gestureView, atIndex: 0)
    }

    func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

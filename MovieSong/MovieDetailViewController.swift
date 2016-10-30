//
//  MovieDetailViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var criticRatingLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    var movie: Movie!
    
    let movieManager = MovieManager()

    
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
        directorLabel.alpha = 0.0
        releaseDateLabel.alpha = 0.0
        ratingLabel.alpha = 0.0
        criticRatingLabel.alpha = 0.0
        plotTextView.alpha = 0.0
        moviePosterImageView.alpha = 0.0
        
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            self.movieTitleLabel.alpha = 1.0
            self.directorLabel.alpha = 1.0
            self.releaseDateLabel.alpha = 1.0
            self.ratingLabel.alpha = 1.0
            self.criticRatingLabel.alpha = 1.0
            self.plotTextView.alpha = 1.0
            self.moviePosterImageView.alpha = 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
        movieTitleLabel.text = movie.title
        directorLabel.text = movie.director
        releaseDateLabel.text = movie.released
        ratingLabel.text = movie.rated
        criticRatingLabel.text = "imdb: \(movie.imdbRating) / rt: \(movie.tomatoMeter)%"
        plotTextView.text = movie.plot
        moviePosterImageView.image = movie.image
    
        plotTextView.scrollRangeToVisible(NSMakeRange(0, 0))
       
        
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
            if success && self.movieTitleLabel != nil {
            if success {
                self.setupAllTheViews()
            }
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

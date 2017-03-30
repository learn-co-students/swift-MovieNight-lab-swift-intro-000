//
//  MovieDetailViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/21/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var audienceRatingLabel: UILabel!
    @IBOutlet weak var imbdAndRottenRating: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerDismiss: UIView!
    

    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllViews()
        handleLayoutOnLoad()
        setupGesture()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}


// MARK: Setup

extension MovieDetailViewController {
    
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        
        titleLabel.alpha = 0.0
        directorLabel.alpha = 0.0
        releaseLabel.alpha = 0.0
        audienceRatingLabel.alpha = 0.0
        imbdAndRottenRating.alpha = 0.0
        plotTextView.alpha = 0.0
        posterImage.alpha = 0.0
        backgroundView.alpha = 0.0
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            self.titleLabel.alpha = 1.0
            self.directorLabel.alpha = 1.0
            self.releaseLabel.alpha = 1.0
            self.audienceRatingLabel.alpha = 1.0
            self.imbdAndRottenRating.alpha = 1.0
            self.plotTextView.alpha = 1.0
            self.posterImage.alpha = 1.0
            self.backgroundView.alpha = 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
        
        titleLabel.text = movie.title
        directorLabel.text = movie.director
        releaseLabel.text = movie.released
        audienceRatingLabel.text = movie.rated
        imbdAndRottenRating.text = "\(movie.imbdRating) \(movie.tomatoMeter)"
        posterImage.image = movie.image
        
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
    
    func dismissDetail() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDetail))
        gestureRecognizer.numberOfTapsRequired = 1
        containerDismiss.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
}

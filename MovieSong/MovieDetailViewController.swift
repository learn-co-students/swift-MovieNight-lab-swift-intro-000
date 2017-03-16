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
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var IMDBRating: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTextField: UITextView!
    @IBOutlet weak var directorLabel: UILabel!
    
    var movie: Movie!
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
        
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
       
        
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

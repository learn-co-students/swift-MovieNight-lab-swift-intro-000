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
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tomatoLabel: UILabel!
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var plotTextView: UITextView!
    
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
        moviePosterImageView.alpha = 0.0
        plotTextView.alpha = 0.0
        tomatoLabel.alpha = 0.0
        directorLabel.alpha = 0.0
        titleLabel.alpha = 0.0
        ratingLabel.alpha = 0.0
        releaseDateLabel.alpha = 0.0
    }
    
    func unHideAllViews() {
        UIView.animate(withDuration: 0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            self.moviePosterImageView.alpha = 1.0
            self.plotTextView.alpha = 1.0
            self.tomatoLabel.alpha = 1.0
            self.directorLabel.alpha = 1.0
            self.titleLabel.alpha = 1.0
            self.ratingLabel.alpha = 1.0
            self.releaseDateLabel.alpha = 1.0
            
            }, completion: nil)
    }
    
    func setupAllTheViews() {
        // TODO: Instruction #5, Implement the setupAllTheViews() function.
        print("imported movie array = \(movie)")
        titleLabel.text = movie.title
        directorLabel.text = movie.director
        releaseDateLabel.text = movie.released
        ratingLabel.text = movie.rated
        tomatoLabel.text = movie.imdbRating
        
        moviePosterImageView.image = movie.image
        plotTextView.text = movie?.plot
        
        print("titleLabel= \(String(describing: titleLabel.text))")
        print("directorLabel= \(String(describing: directorLabel.text))")
        print("releaseDateLabel= \(String(describing: releaseDateLabel.text))")
        print("ratingLabel= \(String(describing: ratingLabel.text))")
        print("tomatoLabel= \(String(describing: tomatoLabel.text))")
        print("moviePosterImageView= \(String(describing: moviePosterImageView.image))")
        print("plotTextView= \(plotTextView.text)")
        
        unHideAllViews()
    }
    
    func handleLayoutOnLoad() {
        if (movie?.hasFullInfo)! {
            setupAllTheViews()
        }
        
        if !(movie?.hasFullInfo)! {
            retrieveInfoForMovie()
        }
    }
    
    func retrieveInfoForMovie() {
        try! movie?.updateInfo { [unowned self] success in
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

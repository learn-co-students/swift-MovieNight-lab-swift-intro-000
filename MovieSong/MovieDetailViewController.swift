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
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func dismissCurrentView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var plotText: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllViews()
        handleLayoutOnLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        gestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: Setup

extension MovieDetailViewController {
    
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        self.titleLabel.text = "Title"
        self.directorLabel.text = "No Director"
        self.releasedLabel.text = "No Release Date"
        self.ratedLabel.text = "Not Rated"
        self.scoreLabel.text = "No Rating"
        
        self.plotText.text = "No Plot"
        
        self.imageView.image = nil
        
    }
    
    func unHideAllViews() {
        UIView.animate(withDuration: 0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            self.titleLabel.text = self.movie.title
            self.directorLabel.text = self.movie.director
            self.releasedLabel.text = self.movie.released
            self.ratedLabel.text = self.movie.rated
            self.scoreLabel.text = "imdb: " + self.movie.imdbRating + " / " + "rt: " + self.movie.tomatoMeter
            
            self.plotText.text = self.movie.plot
            
            self.imageView.image = self.movie.image
            
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

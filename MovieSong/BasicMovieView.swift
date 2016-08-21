//
//  BasicMovieView.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

protocol CanDisplayImageDelegate {
    
    func canDisplayImage(view: BasicMovieView) -> Bool
    
}

final class BasicMovieView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    var queue: Queue!
    var displayImageDelegate: CanDisplayImageDelegate?
    var hasMovie: Bool { return movie != nil }
    
    var movie: Movie! {
        didSet {
            print("Did set of movie called in BasicMovieView for \(movie.title)")
            movie.movieImageDelegate = self
            moviePosterImageView.image = movie.image
            movieTitleLabel.text = movie.year
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NSBundle.mainBundle().loadNibNamed("BasicMovieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        contentView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        contentView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        contentView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        
        queue = Queue(imageView: moviePosterImageView)
        
    }
    
}

// MARK: Re-Use Methods

extension BasicMovieView {
    
    func clearContentsForReUse() {
        queue.clearOperations()
        moviePosterImageView.layer.removeAllAnimations()
        contentView.layer.removeAllAnimations()
        movieTitleLabel.text = ""
        moviePosterImageView.image = nil
    }
    
}

// MARK: Movie Image Delegate Methods

extension BasicMovieView: MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie) {
//        if displayImageDelegate?.canDisplayImage(self) == false { print("Cant display dude"); return }
        
        switch movie.imageState {
        case .Loading:
            print("Loading Case for movie \(movie.title)")
            let loadingImage1 = UIImage(imageLiteral: "Loading1")
            let loadingImage2 = UIImage(imageLiteral: "Loading2")
            let loadingImage4 = UIImage(imageLiteral: "Loading4")
            queue.addOperation(self.moviePosterImageView.image = loadingImage2, animation: .TransitionCrossDissolve, duration: 0.6)
            queue.addOperation(self.moviePosterImageView.image = loadingImage4, duration: 0.6)
        case .NoImage(let image):
            print("No Image Case for movie \(movie.title)")
            queue.addOperation(self.moviePosterImageView.image = image, duration: 0.6)
        case .Downloaded(let image):
            let animations: [UIViewAnimationOptions] = [.TransitionCurlDown, .TransitionFlipFromTop, .TransitionFlipFromLeft, .TransitionFlipFromRight, .TransitionFlipFromBottom]
            
            let randomIndex = Int(arc4random_uniform(UInt32(animations.count)))
            let randomAnimation = animations[randomIndex]

            
            print("Downloaded Case for movie \(movie.title)")
            queue.addOperation(self.moviePosterImageView.image = image, animation: randomAnimation, duration: 0.8)

        case .Nothing:
            print("Nothing Case for movie \(movie.title)")
            queue.addOperation(self.moviePosterImageView.image = nil, animation: .TransitionCrossDissolve, duration: 0.6)
        }
    }
    
}

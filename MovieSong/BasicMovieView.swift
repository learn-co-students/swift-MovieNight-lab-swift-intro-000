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
            if movie.image != nil { moviePosterImageView.image = movie.image }
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

// MARK: Movie Image Delegate Methods

extension BasicMovieView: MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie) {
        if displayImageDelegate?.canDisplayImage(self) == false { print("Cant display dude"); return }
        
        switch movie.imageState {
        case .Loading(let image):
            print("Add Loading to the queue.")
            queue.addOperation(self.moviePosterImageView.image = image, duration: 1.0)
        case .NoImage(let image):
            print("Add no image to the queue.")
            queue.addOperation(self.moviePosterImageView.image = image)
        case .Downloaded(let image):
            print("Add download to the queue")
            queue.addOperation(self.moviePosterImageView.image = image, duration: 1.0)

        case .Nothing:
            queue.addOperation(self.moviePosterImageView.image = nil, animation: .TransitionCrossDissolve, duration: 0.2)
        }
    }
    
}

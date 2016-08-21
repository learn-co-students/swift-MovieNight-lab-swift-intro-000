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

protocol MovieSelected {
    func movieSelected(movie: Movie)
}

final class BasicMovieView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    var queue: Queue!
    var displayImageDelegate: CanDisplayImageDelegate?
    var movieSelectedDelegate: MovieSelected?
    var hasMovie: Bool { return movie != nil }
    
    var movie: Movie! {
        didSet {
            movieTitleLabel.text = movie.year
            movie.movieImageDelegate = self
            moviePosterImageView.image = movie.image
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
        setupGestureRecognizer()
    }
    
}

// MARK: Tapping ImageView Methods

extension BasicMovieView {
    
    func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        gestureRecognizer.numberOfTapsRequired = 1
        moviePosterImageView.userInteractionEnabled = true
        moviePosterImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func imageViewTapped() {
        movieSelectedDelegate?.movieSelected(movie)
    }
    
}

// MARK: Re-Use Methods

extension BasicMovieView {
    
    func clearContentsForReUse() {
        queue.clearOperations()
        moviePosterImageView.layer.removeAllAnimations()
        contentView.layer.removeAllAnimations()
        movieTitleLabel.text = " "
        moviePosterImageView.image = UIImage(imageLiteral: "Nothing")
    }
    
}

// MARK: Movie Image Delegate Methods

extension BasicMovieView: MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie) {
        //        if displayImageDelegate?.canDisplayImage(self) == false { print("Cant display dude"); return }
        switch movie.imageState {
        case .Loading:
            
            let images = (1...8).map { index -> UIImage in
                let imageName = "Loading" + String(index)
                print("Image name is \(imageName)")
                let image = UIImage(imageLiteral: imageName)
                return image
            }
        
            for i in images {
                queue.addOperation(self.moviePosterImageView.image = i)
            }
            
        case .NoImage(let image):
            queue.addOperation(self.moviePosterImageView.image = image, duration: 0.6)
        case .Downloaded(let image):
            let animations: [UIViewAnimationOptions] = [.TransitionCurlDown]
            let randomIndex = Int(arc4random_uniform(UInt32(animations.count)))
            let randomAnimation = animations[randomIndex]
            queue.addOperation(self.moviePosterImageView.image = image, animation: randomAnimation, duration: 0.8)
        case .Nothing:
            let image = UIImage(imageLiteral: "Nothing")
            queue.addOperation(self.moviePosterImageView.image = image, animation: .TransitionCrossDissolve, duration: 0.1)
        }
    }
    
}

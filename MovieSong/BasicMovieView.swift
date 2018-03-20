//
//  BasicMovieView.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

protocol CanDisplayImageDelegate {
    func canDisplayImage(_ view: BasicMovieView) -> Bool
}

protocol MovieSelected {
    func movieSelected(_ movie: Movie)
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
        Bundle.main.loadNibNamed("BasicMovieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        queue = Queue(imageView: moviePosterImageView)
        setupGestureRecognizer()
    }
    
}

// MARK: Tapping ImageView Methods

extension BasicMovieView {
    
    func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        gestureRecognizer.numberOfTapsRequired = 1
        moviePosterImageView.isUserInteractionEnabled = true
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
        //moviePosterImageView.image = UIImage(imageLiteral: "Nothing")
        moviePosterImageView.image = UIImage(imageLiteralResourceName: "Nothing")
    }
    
}

// MARK: Movie Image Delegate Methods

extension BasicMovieView: MovieImageDelegate {
    
    func imageUpdate(withMovie movie: Movie) {
        // TODO: Remove this comment. Look to see if indexPath is still on screen. Maybe? It's working without it probably because of some saftey check I'm doing elsewhere.
        switch movie.imageState {
        case .loading:
            
            let images = (1...8).map { index -> UIImage in
                let imageName = "Loading" + String(index)
                let image = UIImage(imageLiteralResourceName: imageName)
                return image
            }
        
            for i in images {
                queue.addOperation(self.moviePosterImageView.image = i)
            }
            
        case .NoImage(let image):
            queue.addOperation(self.moviePosterImageView.image = image, duration: 0.6)
        case .downloaded(let image):
            // TODO: No longer is there this list of random animations, you should clean this up.
            let animations: [UIViewAnimationOptions] = [.transitionCurlDown]
            let randomIndex = Int(arc4random_uniform(UInt32(animations.count)))
            let randomAnimation = animations[randomIndex]
            queue.addOperation(self.moviePosterImageView.image = image, animation: randomAnimation, duration: 0.8)
        case .nothing:
            let image = UIImage(imageLiteralResourceName: "Nothing")
            queue.addOperation(self.moviePosterImageView.image = image, animation: .transitionCrossDissolve, duration: 0.1)
        }
    }
    
}

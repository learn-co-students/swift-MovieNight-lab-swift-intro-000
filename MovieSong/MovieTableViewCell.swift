//
//  MovieTableViewCell.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieView: MovieView!
    var movieSelectedDelegate: MovieSelected? {
        didSet {
            movieView.leftBasicMovieView.movieSelectedDelegate = movieSelectedDelegate
            movieView.rightBasicMovieView.movieSelectedDelegate = movieSelectedDelegate
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieView.clearContentsForReUse()
    }
    
}

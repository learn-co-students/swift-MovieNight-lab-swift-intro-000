//
//  MovieView.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftBasicMovieView: BasicMovieView!
    @IBOutlet weak var rightBasicMovieView: BasicMovieView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NSBundle.mainBundle().loadNibNamed("MovieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        contentView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        contentView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        contentView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
    }
    
    func clearContentsForReUse() {
        leftBasicMovieView.clearContentsForReUse()
        rightBasicMovieView.clearContentsForReUse()
    }
    
}
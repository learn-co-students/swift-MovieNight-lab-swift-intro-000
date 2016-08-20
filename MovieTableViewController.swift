//
//  MovieTableViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    let movieManager = MovieManager()
    var searchTerm: String = String() {
        didSet {
            title = searchTerm
        }
    }

    var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTerm = "Love"
        
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        
        print("view did Load is happening.")
        try! movieManager.search(forFilmsWithTitle: searchTerm) { [unowned self] movies, error in
            print("Back in block - \(error)")
            guard let newMovies = movies else { return }
            self.movies = newMovies
            
        }
    }
    
    func changeBackground() {
        
        
        
        
//        UIImage *backgroundImage = [UIImage imageNamed:@"iphone_skyline3.jpg"];
//        Second create a UIImageView. Set the frame size to the parent's (self) frame size. This is important as the frame size will vary on different devices. Stretching will occur depending on the image size. Next assign the image to the view.
//        
//        UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
//        backgroundImageView.image=backgroundImage;
//        Finally, to keep the image behind all controls do the following. It is important if you are setting the image as a background for your app.
//            
//            [self.view insertSubview:backgroundImageView atIndex:0];
        
    }
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Movie count is \(movies.count)")
        return movies.count % 2 == 0 ? movies.count / 2 : (movies.count / 2) + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let movieCell = cell as! MovieTableViewCell
    
        if indexPath.row == 0 {
            let firstFilm = movies[indexPath.row]
            movieCell.movieView.leftBasicMovieView.movie = firstFilm
            if indexPath.row + 1 <= movies.count {
                let secondFilm = movies[indexPath.row + 1]
                movieCell.movieView.rightBasicMovieView.movie = secondFilm
            }
        } else {
            
            let index = indexPath.row * 2
            let firstFilm = movies[index]
            movieCell.movieView.leftBasicMovieView.movie = firstFilm
            if index + 1 <= movies.count {
                let secondFilm = movies[index + 1]
                movieCell.movieView.rightBasicMovieView.movie = secondFilm
            }

            
            
            
            
            
            
        }
        
        
        
        
        
    }

}

extension MovieTableViewController: CanDisplayImageDelegate {
    
    func canDisplayImage(view: BasicMovieView) -> Bool {
        let viewableCells = tableView.visibleCells as! [MovieTableViewCell]
        for cell in viewableCells {
            if cell.movieView.leftBasicMovieView.hasMovie { if view.movie.title == cell.movieView.leftBasicMovieView.movie.title  { return true } }
            if cell.movieView.rightBasicMovieView.hasMovie { if view.movie.title == cell.movieView.rightBasicMovieView.movie.title  { return true } }
        }
        return false
    }
}

//
//  MovieTableViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    let movieManager = MovieManager()
    var searchTerm: String = String() {
        didSet {
            title = searchTerm
            searchForMovie()
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
//        tableView.showsVerticalScrollIndicator = false
    }
    
    func searchForMovie() {
        try! movieManager.search(forFilmsWithTitle: searchTerm) { [unowned self] movies, error in
            print("Back in block - \(error)")
            guard var newMovies = movies else { return }
            newMovies += self.movies
            self.movies = []
            self.movies = newMovies
        }
        
    }
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count % 2 == 0 ? movies.count / 2 : (movies.count / 2) + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        if indexPath.row == 0 {
            let firstFilm = movies[indexPath.row]
            cell.movieView.leftBasicMovieView.movie = firstFilm
            if indexPath.row + 1 <= movies.count {
                let secondFilm = movies[indexPath.row + 1]
                cell.movieView.rightBasicMovieView.movie = secondFilm
            }
        } else {
            
            let index = indexPath.row * 2
            let firstFilm = movies[index]
            cell.movieView.leftBasicMovieView.movie = firstFilm
            if index + 1 <= movies.count {
                let secondFilm = movies[index + 1]
                cell.movieView.rightBasicMovieView.movie = secondFilm
            }
        }
        
        return cell
    }
    
    

}

// MARK: Segue Methods

extension MovieTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! SearchViewController
        destVC.searchDelegate = self
    }
}

extension MovieTableViewController: SearchDelegate {
    
    func search(withTitle title: String) {
        searchTerm = title
    }
}

//MARK: Can Display Image Delegate Methods

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

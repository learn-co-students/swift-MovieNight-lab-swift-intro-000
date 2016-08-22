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
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
    }
    
}

// MARK: Movie Selected

extension MovieTableViewController: MovieSelected {
    
    func movieSelected(movie: Movie) {
        performSegueWithIdentifier("MovieDetail", sender: movie)
    }
    
}


// MARK: Table view delegate

extension MovieTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    
}


// MARK: Table view data source

extension MovieTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count % 2 == 0 ? movies.count / 2 : (movies.count / 2) + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        if cell.movieSelectedDelegate == nil { cell.movieSelectedDelegate = self }
        
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
            if index + 1 < movies.count {
                let secondFilm = movies[index + 1]
                cell.movieView.rightBasicMovieView.movie = secondFilm
            }
        }
        
        return cell
    }
    
}


// MARK: Segue

extension MovieTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "SearchSegue":
            let destVC = segue.destinationViewController as! SearchViewController
            destVC.searchDelegate = self
        case "MovieDetail":
            let destVC = segue.destinationViewController as! MovieDetailViewController
            let chosenMovie = sender as! Movie
            destVC.movie = chosenMovie
        default:
            break
        }
    }
    
}


// MARK: Search

extension MovieTableViewController: SearchDelegate {
    
    func search(withTitle title: String) {
        searchTerm = title
    }
    
    func searchForMovie() {
        try! movieManager.search(forFilmsWithTitle: searchTerm) { [unowned self] movies, error in
            guard var newMovies = movies else { return }
            newMovies += self.movies
            self.movies.removeAll()
            self.movies = newMovies
        }
        
    }
}


//MARK: Can Display Image Delegate

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

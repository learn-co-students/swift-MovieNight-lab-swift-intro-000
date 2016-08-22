# Final Project

![](https://s3.amazonaws.com/learn-verified/MovieSearchBilb.jpg)

> All that is gold does not glitter,  
Not all those who wander are lost;  
The old that is strong does not wither,  
Deep roots are not reached by the frost.  
From the ashes a fire shall be woken,  
A light from the shadows shall spring;  
Renewed shall be blade that was broken,  
The crownless again shall be king -[Bilbo Baggins](https://en.wikipedia.org/wiki/All_that_is_gold_does_not_glitter)

---

# Movie Search

![](https://s3.amazonaws.com/learn-verified/MovieSearchFinalImage.png)



You made it to the final project! 

This iOS app is titled Movie Search. When a user opens the app, they're presented with a screen that will allow them to search for a movie. The search will display the poster images of those films on a screen where the user can then scroll through the search results. When a poster image is tapped, it will bring up a detailed view which displays information about the film.

What you will be responsible for making (please don't begin coding, this is just a brief overview of what you will be doing--these aren't instructions):

* `Movie.swift` - This file will define a `Movie` class. This object is pretty self-explanatory, it will represent a film. A film has a title, rating, year of release, etc.
* `MovieView.swift` - This file will define a `MovieView` class which is subclassed from `UIView`. This view object will be added to our table view cell. It's sole responsibility is to display the Movie Poster images within the table view cell.
* `BasicMovieView.swift` - This file will define a `BasicMovieView` class which is subclassed from `UIView`. This object is responsible for the various animations that occur when a movie poster is downloading from the internet. When that download is complete, this view is responsible for then displaying it on screen. The `MovieView` object will have two instanceProperties, both of which are instances of `BasicMovieView`.
* `MovieTableViewCell.swift` - This file will define a `MovieTableViewCell` class which is subclassed from `UITableViewCell`. It will have a `MovieView` instance property.
* `MovieTableViewController.swift`, `SearchViewController.swift`, `MovieDetailViewController.swift` - These are the three controllers in our application. You will be implementing various functions between all of them which will get this app up and running.


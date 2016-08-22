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

---

# Instructions

First things first, we need to understand how we can even get movies. Do we create each and every one in code and store it locally to the iPhone? Obviously, no. Would you even have the time to type out every single film in the world. Not only that, what if our user is only interested in searching for "Toy Story".

We can work with an API.

![](https://s3.amazonaws.com/learn-verified/MovieSearchAPI.png)

There is some data that lives in the cloud (some server) and our app needs to be able to communicate with that cloud (it's holding what we want). Here's how a conversation might go (with our server).

I need all movies titled "Horse Bucket".

The server does its thing going through its file system to locate all movies titled "Rocky" It then gives it back to us in one chunk. The process isn't instantaneous, we're dealing with the Web now. There are multiple variables at stake (one of them being your internet connection).

OK, so we've heard back from our server and they've given us what we wanted. We got back all movies titled "Horse Bucket"

But what format is that in? It gives it back to us in the form of JSON (JavaScript Object Notation). JSON is a lightweight format that is used for data interchanging.

JSON is built on two structures:
* A collection of name/value pairs. In various languages, this is realized as an object, record, struct, dictionary, hash table, keyed list, or associative array.
* An ordered list of values. In most languages, this is realized as an array, vector, list, or sequence.

JSON in Swift is recognized as [`String` : `AnyObject?`]. It's a dictionary where the `key`'s are of type `String` and the `value`'s are of type `AnyObject?`. But we can be even more specific when we're the ones communicating with the API within our code. We can narrow down the `AnyObject?` type to what the type actually is. How do we know what type it is? We'll get there.

What API are we working with here? [OMDb API](http://www.omdbapi.com)--The OMDb API is a free web service to obtain movie information, all content and images on the site are contributed and maintained by their users.

Here's how OMDb (our API we're working with) gives us back one movie. It's in the form of a dictionary where the `key`'s are of type `String` and the `value`'s are of type `String`.

[`String` : `String`]

```swift
{ 	
	"Title" : "Jurassic Park",
 	"Year" : "1993",
 	"imdbID" : "tt0107290",
 	"Type" : "movie",
 	"Poster" : "http://ia.media-imdb.com/images/M/MV5BMjM2MDgxMDg0Nl5BMl5BanBnXkFtZTgwNTM2OTM5NDE@._V1_SX300.jpg" 
}
```

First, do the one thing I know you want to do right now. Copy and paste that URL into a browser.

**1.** Create the necessary instance properties in the `Movie.swift` which will ultimately store the various `value`'s from this dictionary. You can exclude creating an instance property which will deal with the "movie" `value` from the "Type" `key`. The others we are definitely interested in. What type should our instance properties be? They should all be of type `String`.  
* `title` of type `String`
* `year` of type `String`
* `imdbID` of type `String`
* `posterURLString` of type `String`

**2.** To make our lives easier, and to make it easy to instantiate a `Movie` object, lets create an initializer within our `Movie` class that takes in as an argument a dictionary of type [`String` : `String`]. That way, within our initializer--we can parse through this dictionary (knowing that we know what the `key`'s are). Most API's within their documentation will show you what the `JSON` looks like--that way you know exactly what `key`'s you're dealing with.

Within the implementation of this initializer, using the `key`'s in our Jurassic Park example above, assign `value`'s to the instance properties you just defined in the prior instruction. But not just any `value`. Utilize the dictionary argument which is of type [`String` : `String`], you will be betting back a dictionary that looks _identical_ to the Jurassic Park example above. The various `key`'s are "Title", "Year", "imdbID", "Type", and "Poster".












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

The server does its thing going through its file system to locate all movies titled "Horse Bucket" It then gives it back to us in one chunk. The process isn't instantaneous, we're dealing with the Web now. There are multiple variables at stake (one of them being your internet connection).

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

# 1
 Create the necessary instance properties in the `Movie.swift` which will ultimately store the various `value`'s from this dictionary. You can exclude creating an instance property which will deal with the "movie" `value` from the "Type" `key`. The others we are definitely interested in. What type should our instance properties be? They should be as follows: 
* `title` of type `String`
* `year` of type `String`
* `imdbID` of type `String`
* `posterURLString` of type `String?` <-- notice that this is an optional `String`, the others aren't.


# 2
 To make our lives easier, and to make it easy to instantiate a `Movie` object, lets create an initializer within our `Movie` class that takes in as an argument a dictionary of type [`String` : `String`]. That way, within our initializer--we can parse through this dictionary (knowing that we know what the `key`'s are). Most API's within their documentation will show you what the `JSON` looks like--that way you know exactly what `key`'s you're dealing with.

Within the implementation of this initializer, using the `key`'s in our Jurassic Park example above, assign `value`'s to the instance properties you just defined in the prior instruction. But not just any `value`. Utilize the dictionary argument which is of type [`String` : `String`], you will be betting back a dictionary that looks _identical_ to the Jurassic Park example above. The various `key`'s are "Title", "Year", "imdbID", "Type", and "Poster".

There's one caveat. When you look to retrieve a value from a dictionary, for example if we attempt to do the following:

```swift
let movieJSON = [
    "Title" : "Jurassic Park",
    "Year" : "1993"
]
        
let movieTitle = movieJSON["Title"]
```

What type is `movieTitle` here in my example? It's of type `String?`, _not_ `String`. Because when you retrieve a value from a dictionary, it's not guaranteed that you will get back something.

```swift
let movieLikes = movieJSON["Likes"]
```

`movieLikes` in this example is also of type `String?`. We either will get back a `String` or we won't in that it will be `nil`, hence why it's an optional `String`. So it's on us (the developer) to check to see that what we got back is indeed not `nil`. If it's not `nil`, then we can proceed to assigning the unwrapped value to our instance property. Like so:

```swift
if let movieTitle = movieJSON["Title"] {
   title = movieTitle
}
````

This is assigning the unwrapped value (if it was able to unwrap it in that `movieJSON["Title"]` returned back to us a value that was not `nil`, if it was not `nil`, the value (which is of type `String`) has been assigned to this local constant we've named `movieTitle`--so within the scope of those curly braces we will have access to a constant called `movieTitle` of type `String`. Our `title` instance property is of type `String`--so we should be able to assign this value to it with no problem.

One more problem. What if `movieJSON["Title"]` returns back to us a `nil` value, what are we to do? We can write in an `else` clause like so:

```swift
if let movieTitle = movieJSON["Title"] {
     title = movieTitle
} else {
     title = "No Title"
}
```

If `movieJSON["Title"]` returns back to us a `nil` value in that it was unable to retrieve a value for the key "Title", then we enter this `else` statement. Inside that else statement we're assigning some default value to this instance property. The default value is a `String` literal, "No Title".  This solves our problem.

But.....this is a lot of code to write for a simple operation, and you're not just looking to do this for one key-value pair in this dictionary, we're looking to assign values to all four of our instance properties we've made. This would be some ugly looking code. There's an answer.

Here's a great word for you, Nil Coalescing. That's our answer--Nil Coalescing. It's something we can do in Swift to handle our `if-else` statement above more elegantly. It works in the same way, if there's a value in this optional, unwrap it and return it back to me, else return back this default value. Here's what it looks like:

```swift
title = movieJSON["Title"] ?? "No Title"
```

This does the _exact_ same thing as our `if-else` statement above. If `movieJSON["Title"]` returns back a value that is not `nil`, then we will assign that value to our `title` instance property. If not (in that it returns back to us a `nil` value, then we will return back the value "No Title" and assign that value to our `title` instance property.

Within your `init` function, do this for all of your instance properties except the `posterURLString` coming up with your own phrase for what happens if the value returns back `nil`. What do I mean, except the `posterURLString`. I want you to assign the value from the dictionary, storing it to our `posterURLString` _not_ using nil coalescing. I want this instance property to be `nil` if in fact this dictionary doesn't have a value for the key "Poster"--if the dictionary returns back `nil`, I want our `posterURLString` instance property to be `nil` then. The reason for that is how I decided to download the images at this URL later on. If this is `nil`, obviously I make no attempt to download the image, I display a default image instead. You can argue then that I should probably do that right here and now though! You might be right!

# TODO: I didn't have them include the following in their init function yet. It's not even part of their init definition yet.

```swift
self.movieImageDelegate = movieImageDelegate
```

# 3

### TODO: Have them create the method to deal with this response object only pulling out what's necessary. What's necessaryis listed as instance properties in my complete Xcode project - Movie.swift file.

```swift
{
	"Title":"Jurassic Park",
	"Year":"1993",
	"Rated":"PG-13",
	"Released":"11 Jun 1993",
	"Runtime":"127 min",
	"Genre":"Adventure,	 Sci-Fi, Thriller",
	"Director":"Steven Spielberg",
	"Writer":"Michael Crichton (novel), Michael Crichton (screenplay), David Koepp (screenplay)",
	"Actors":"Sam Neill, Laura Dern, Jeff Goldblum, Richard Attenborough",
	"Plot":"Huge advancements in scientific technology have enabled a mogul to create an island full of living dinosaurs. John Hammond has invited four individuals, along with his two grandchildren, to join him at Jurassic Park. But will everything go according to plan? A park employee attempts to steal dinosaur embryos, critical security systems are shut down and it now becomes a race for survival with dinosaurs roaming freely over the island.",
	"Language":"English, Spanish",
	"Country":"USA",
	"Awards":"Won 3 Oscars. Another 28 wins & 17 nominations.",
	"Poster":"http://ia.media-imdb.com/images/M/MV5BMjM2MDgxMDg0Nl5BMl5BanBnXkFtZTgwNTM2OTM5NDE@._V1_SX300.jpg",
	"Metascore":"68",
	"imdbRating":"8.1",
	"imdbVotes":"613,972",
	"imdbID":"tt0107290",
	"Type":"movie",
	"tomatoMeter":"93",
	"tomatoImage":"certified",
	"tomatoRating":"8.3",
	"tomatoReviews":"117",
	"tomatoFresh":"109",
	"tomatoRotten":"8",
	"tomatoConsensus":"Jurassic Park is a spectacle of special effects and life-like animatronics, with some of Spielberg's best sequences of sustained awe and sheer terror since Jaws.",
	"tomatoUserMeter":"91",
	"tomatoUserRating":"3.6",
	"tomatoUserReviews":"1066442",
	"tomatoURL":"http://www.rottentomatoes.com/m/jurassic_park/",
	"DVD":"10 Oct 2000",
	"BoxOffice":"N/A",
	"Production":"Universal City Studios",
	"Website":"http://www.jurassicpark.com/maingate_flash.html",
	"Response":"True"
}
```







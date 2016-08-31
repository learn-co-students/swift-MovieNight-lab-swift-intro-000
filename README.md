# FINAL PROJECT

![](http://i.imgur.com/saf6STN.jpg?1)

> Live as if you were to die tomorrow. Learn as if you were to live forever. -[Mahatma Gandhi](https://en.wikipedia.org/wiki/Mahatma_Gandhi)

---

# Movie Search Introduction

![](https://s3.amazonaws.com/learn-verified/MovieSearchFinalImage.png)



You made it to the final project! 

This iOS app is titled Movie Search. When a user opens the app, they're presented with a screen that will allow them to search for a movie. The search result will display the poster images of those films on a screen where the user can then scroll through the search results. When a poster image is tapped, it will bring up a detailed view which displays information about the film.


---

# API Overview

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

We know this is a dictionary of type [`String` : `String`] because when working with API's they will allow you to test out their API and take a look at what the response looks like. Go to this link [here](http://www.omdbapi.com)--this is the OMDb API. 

Type in Cast Way in the 'Title' box and hit search, you should be met with the following screen:

![](https://s3.amazonaws.com/learn-verified/MovieSearchURL.png)

_NOTE: Why is the Response in your screenshot different than the Jurassic Park example you showed us above? That's because in that example above (not the screenshot), I've added `s` as a parameter to the URL in my search which gives us back a whole slew of movie objects (condensed with only the Title, Year, imdbID, Type and Poster). In my screenshot, the Response contains a lot more information because we're not including `s` as a parameter in the URL (when communicating with OMDd), by doing that we're searching for one specific title._

The "Response:" is surrounded by these curly braces

```swift
{ }
```
This tells us it's a dictionary. OK--then what are the key value pairs. Most (if not all) of the time, they keys are of type `String`. We know that because of these lovely little guys:

```swift
"    "
```

Any letters or numbers surrounded by double quotes are of type `String`. 

Since all of the values of this dictionary are of type `String` as well, in that they are all surrounded by double quotes, we're dealing with a response object which is a dictionary of type [`String` : `String`]. 

If you see this in a response:

```swift
[  ]
```
Then you're working with an Array. We don't see that here which makes our life easier, we're just dealing with `String`'s as keys and `String`'s as values in this dictionary.



# 1. Movie Instance Properties

 Create the necessary instance properties in the `Movie.swift` which will ultimately store the various `value`'s from this dictionary. You can exclude creating an instance property which will deal with the "movie" `value` from the "Type" `key`. The others we are definitely interested in. What type should our instance properties be? They should be as follows: 
* `title` of type `String`
* `year` of type `String`
* `imdbID` of type `String`
* `posterURLString` of type `String?` <-- notice that this is an optional `String`, the others aren't.

This class has already been started for you. There are instance properties and methods defined within this `Movie.swift` file, don't mess with them--but feel free to check them out. Most of them relate to making it easy to download images from the web and display them within a table view cell.

# 2. Movie Initializer

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

#3. Create the Movie Objects

Locate the `MovieManager.swift` file. This class has been created for you--it will manage our conversation with the OMDb API. An instance of this class will be able to search for movie titles and handle the response back from the API (the JSON object). Scrolling down towards the bottom of the file, you will see the implementation of the following method:

`search(forFilmsWithTitle:handler:)`

Within the implementation of this method you will find a **TODO:** comment. Before we go into what this **TODO:** comment is asking you to do, take a look at the two variables created above this comment.

```swift
let actualSearch: [[String : String]] = search as! [[String : String]]
                
var movies: [Movie] = []
```

The first is a constant named `actualSearch` of type [[`String` : `String`]]. That's a funky looking type. It's an array of dictionaries. The Dictionaries have keys of type `String` and values of type `String`. Just like any other array, we can loop over it with  a for-in loop. In creating a for-in loop with this array, for each iteration we would be working with a dictionary of type [`String` : `String`]. That's because when we do a search for lets say "Jurassic Park", we're given an array of dictionaries--each dictionary being the JSON object of some movie. A dictionary that looks similar to the first example given of a JSON object above.

Well, you already create an initializer within the `Movie` class that will allow for us to create movie objects passing in a dictionary of type [`String` : `String`] to it. Before we utilize this, you should see the variable called `movies` created for you below `actualSearch` constant--which is about to come in handy (it will be your job to fill it with `Movie` objects).

Loop over the `actualSearch` constant. Within that for-in loop--for each iteration, create a `Movie` object. After creating that movie object, I want you to append it to the `movies` variable--and that's it!


# 4. Update Film Movie Method

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

The above is a JSON response object. It's much larger than the one we dealt with earlier--can you guess what type it is? Meaning... is it an Array, is it a Dictionary?

It's a dictionary where the `key`'s are of type `String` and the `value`'s are of type `String`.

How our application works is as follows:

We the app first loads, the user is presented with the option of searching for a film. If they type in lets say the film "Jurassic" they would be met with the following results:

![](https://s3.amazonaws.com/learn-verified/MovieSearchJurassicP.png)

At this point we are creating multiple `Movie` objects--utilizing the initializer you created in the first instruction. If the `Movie` object is to be displayed on screen, we download its image at the imageURL you stored in the original initializer and display that within the cell. In this initial request (when you type in "Jurassic Park" in the movie search text field)--we're given a list of movies in the [`String` : `AnyObject`] format, which you've been able to work with so far. We asked for you to also store the IMDB id associated with the film within the initializer. Why? Because in this initial _general_ request when you type in "Juarssic" we're given a list of films, but not data specific to just _one_ film. That big json object above is data associated with one specific film.

In order to do that (when working with the API), we have to make another request to IMDB. This time, in our request--we don't want to ask it for "Jurassic Park"--that's too general, we want specific info for a specific film. So how do we do that? Well.. we call up to IMDB asking for more info but we need to provide it with something--we provide it with the IMDB id of the film we want more info on.

Think of it like a phone call. We call up our friend named IMDB and say.. "Hey, I have this ID for a film from your database, can you give me _all_ the info you have on it". So IMDB does its thing which could take under a second, could take a minute, could take FOREVER (foreva eva). Maybe your internet connection is slow, maybe you don't even have an internet connection or maybe IMDB is asleep (server is down).

But when IMDB gets back to you.. it's going to give you back the JSON object of type [`String` : `String`] listed above.

We need to add additional instance properties within our `Movie` class. So lets do that:

**Create the following instance properties**: 

* `hasFullInfo` - a variable of type `Bool` with a default value of `false`
* `rated` - a variable of type `String` with a default value of "No Rating"
* `released` - a variable of type `String` with a default value of "No Release Date"
* `director` - a variable of type `String` with a default value of "No Director"
* `imdbRating` - a variable of type `String` with a default value of "N/A"
* `tomatoMeter` - a variable of type `String` with a default value of "N'A"
* `plot` - a variable of type `String` with a default value of "No Plot"

**Create the following method:**

So here's what I want you to do. Create a function named `updateFilmInfo(_:)`within our `Movie` class  which takes in one argument called `jsonResponse` of type [`String` : `String`]. In your implementation of this function, update the appropriate instance properties (you just created) with JSON response object above. You might have to do some digging. The `key`'s you should be using to access the `value`'s have a near identical name to the instance properties you've created (some do, some differ by just the first letter being capitalized)

# 5. Movie Detail View Controller

Quick recap. Our app loads, they're presented with a view that contains a text field. The user types in a film, hits search and that will be where we make our first call up to IMDB asking for all films associated with what was typed in that text field. Thanks to you--we then initialize multiple movie objects and begin to display their posters within multiple table view cells. If a user taps one of these poster images, we should be brought to a screen like this:

![](https://s3.amazonaws.com/learn-verified/MovieSearchJaws.png)

Does it have to look _exactly_ like this? No--but I would like for you to incorporate the following pieces of info relating to the movie in this screenshot:

* Title
* Movie Poster Image
* Director
* Release Date
* Movie Rating
* IMDB & Rotten tomatoes rating in one line
* Movie Plot

In my example, I've utilized the following to tackle this problem:

* `UITextView`
* Five `UILabel`'s
* `UIImageView`


Have fun with this. Don't be constrained by only having to display what I decided to display here. If you want to display the actors, then create a new instance property within the `Movie` object--and then make sure to assign a value to that instance property within the `updateFilmInfo(_:)` method.

Locate the **Movie Detail View Controller Scene** in the `Main.storyboard` file. This scene's View Controller is where you will be laying out your views (make sure to add constraints). This Movie Detail View Controller has already had its custom class set to the `MovieDetailViewController.swift` file. Create outlets for all your views you've made to this `MovieDetailViewController.swift` file giving these outlets the appropriate names. The `View` object already in place within this Scene has a black background which is see-through (opacity is below 100%).

After setting up these views and their outlets, head on over to the `MovieDetailViewController.swift` file. Locate the `setupAllTheViews()` function. It will be your job to implement it. You have access to the `movie` instance property on this view controller. This `movie` object here is the one that was selected from the prior screen. At this point, this `movie` object contains all the info we need--so update the various view objects you created outlets for here within this function to equal the various properties on this `movie` object.

As well, you should see the following methods with **TODO:** comments:

```swift
    func hideAllViews() {
        
        // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 0.0
        
    }
    
    func unHideAllViews() {
        UIView.animateWithDuration(0.6, animations: {
            
            // TODO: Instruction #5, Set the .alpha property of all the views (outlets you created) here to 1.0
            
            }, completion: nil)
    }
```

My only instruction here will be to listen to the **TODO:** comments here and do what they say (they're almost like the Deku tree in the Zelda games)

If you run your app, things should be looking pretty good (so far). You might notice that there's no way to get back to the prior screen when we get to our Movie Detail View Controller. How can we go back?

# 6. Last Instruction

This is the last instruction given to you in this entire course and I want to thank you for coming along this journey. It's been such an incredible pleasure putting all of these various lessons and readings together, I've hope you enjoyed yourself and learned something along the way.

As a programmer, there are many tools you need to have in your toolkit. One of them is being able to use Google and Stack Overflow. These will become an invaluable tool as you move forward. You will be in a position where you have a question that you can't solve, like "How can I create a round `UIButton`" and you might find some Stack Overflow with an answer from 2011 in Objective-C that you have to transfer over to Swift. Not every question is met with an answer that works. Programming is a struggle--but the reward is incredible. Stick with it, stay focused, trial & error and get to the answer.

So, instead of providing you with detailed instructions on how to do this. The very last instruction you will receive is this:

Figure out a way where you can dismiss the `MovieDetailViewController` when they tap anywhere outside of the movie info being displayed. When they tap outside that view, the `MovieDetailViewController` should dismiss itself so you can continue to tap other movies or search for new ones.

# 7. Fun

Have fun with this. Expand upon it, run it on your iPhone--keep it around with you if anyone ever asks you about a specific movie. I like the idea of incorporating more detailed information on a film. Looking into the other `.swift` files in this project to see how we incorporating searching for a film or how we performed certain animations. 

In case I don't see ya', good afternoon, good evening and goodnight.

![](https://media.giphy.com/media/BjQTWPEVZjM6Q/giphy.gif)















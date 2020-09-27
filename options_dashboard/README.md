# Intro

This is my first app that I consider somewhat complete. I started knowing barely anything about Flutter, or options trading for that matter and ended with a workable options dashboard.


#The app in action

Video of the app can be seen here:
https://www.youtube.com/watch?v=a_CkPDlQ6yg



# What I learned

Given that this was my first app, I learned an insane amount and watched errors that I made in the beginning grow to difficult to manage sizes.

The first thing that became an issue is that I had not heard of the principles of writing clean code, so many of my functions take too many inputs, do too much without being broken into subfunctions, and have an inconsistent naming convention. The other thing is that number of files that I made quickly became unwieldy with the segregation of each widget into its own file.

The biggest example of ugly code in this project is IMO “getQuote” because the name isn’t exactly what it does, it’s about 200 lines with no custom functions to simplify or explain what’s going on, and there is also a lot of repeated code.

The second thing that I learned was how not to do state management. This project started using a stateful widget, which I built on for a while. I was reading a lot about Flutter and heard lots of people talking about the Provider package as a nice state management tool, so I switched the code to Provider easily enough. I didn’t understand what made Provider valuable, so my widgets ended up needing to rebuild when basically anything from 2-3 classes changed.

The valuable thing about Provider is it allows you to rebuild PARTS of your UI without having to rebuild the whole thing, but if everything is dependent on 2-3 providers you end up having to rebuild the whole thing anyway.

This is really just the same lesson that I learned when it comes to project architecture because if I had have planned things well before, I would not have run into these problems.

In the future, I will attempt to start with the end in mind. In this case, I had no idea what the scope of this project would be, and I added a lot of things as I was going.

# Intro

This is my first app that I consider somewhat complete. I started knowing barely anything about Flutter, or options trading for that matter and ended with a workable options dashboard.



# The app in action

Video of the app can be seen here:
https://www.youtube.com/watch?v=a_CkPDlQ6yg

In short, upon starting the app you see a table of stock symbols and their corresponding names sorted by ticker. You can click on either to look up that security or click the search icon to search from S&P listed securities.

On completion of a search, you are presented with a PageView of a payoff chart and a list of trades at the bottom. You can customize a strategy with up to 5 trades, including any number of stocks, calls, or puts. You can choose to have options with several different expiration dates, and you will still get a max and min risk as well as breakeven points (breakeven points not solved analytically for multi date strategies).

Clicking on the Returns button (probably not the best name) you can customize the date(defaults to now) and volatility and watch the value curve of the strategy change in real-time. It also gives you some info on the value at a given time and how much the value will change holding to expiry. N.B. I base everything on the average IV of the first OTM call and OTM put, so there may be so weird artifacts, especially for calendar spreads.

There is a tab with the PDF of the price of the security at expiration based on the previously mentioned IV.

I try to break down the strategy further, using English to describe theta and vega and provide an average payoff ratio on4 standard deviations (p=0.000063342484) and tabulate the net Greeks (units might not correct).

The last PageView is an options chain that the user can click on the bid or ask prices to immediately add that trade to their strategy on the Strategy page. This also has a few more columns, although I did not make them sortable.

Finally, there is a playbook stored safely in the drawer that allows users to look up “plays”. When they click on the banner at the bottom the strategy that they were browsing is then offered as the default when they go back to the dashboard (the suggest trade icon is also highlighted).




# What I learned

Given that this was my first app, I learned an insane amount and watched errors that I made in the beginning grow to difficult to manage sizes.

The first thing that became an issue is that I had not heard of the principles of writing clean code, so many of my functions take too many inputs, do too much without being broken into subfunctions, and have an inconsistent naming convention. The other thing is that number of files that I made quickly became unwieldy with the segregation of each widget into its own file.

The biggest example of ugly code in this project is IMO “getQuote” because the name isn’t exactly what it does, it’s about 200 lines with no custom functions to simplify or explain what’s going on, and there is also a lot of repeated code.

The second thing that I learned was how not to do state management. This project started using a stateful widget, which I built on for a while. I was reading a lot about Flutter and heard lots of people talking about the Provider package as a nice state management tool, so I switched the code to Provider easily enough. I didn’t understand what made Provider valuable, so my widgets ended up needing to rebuild when basically anything from 2-3 classes changed.

The valuable thing about Provider is it allows you to rebuild PARTS of your UI without having to rebuild the whole thing, but if everything is dependent on 2-3 providers you end up having to rebuild the whole thing anyway.

This is really just the same lesson that I learned when it comes to project architecture because if I had have planned things well before, I would not have run into these problems.

In the future, I will attempt to start with the end in mind. In this case, I had no idea what the scope of this project would be, and I added a lot of things as I was going.

Finally, I learned a lot about Flutter and Dart. In the beginning, I was an absolute novice in both. Id didn’t know the language and I had trouble implementing basically anything because I was tri[[ing over syntax and other things, I feel so much more comfortable now.


# Conclusions

I feel liked I learned a lot on this project. I used a layout builder to make the UI responsive (try turning your screen on The Dashboard screen), some SQLite for search history, and a few other things that I am not thinking of right now.

I wish there were better graphing resources in Flutter, I don’t know what is available in other languages, but I felt like the packages that we had access to were just good enough (fl_charts and syncfusion at one point in this project), my only real gripe with fl_charts is there is a graphical glitch when you customize price, IV or date.

I had a lot of fun, and look forward to continuing learning Flutter and programing in general.

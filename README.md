# JWCardViewControllerTransitioning

The missing iOS 11 Card ViewController Transition famous from Apple Music and Podcastsusable addable in just one line of code.

## Demo
![](https://github.com/janwasgint/JWCardViewControllerTransitioning/blob/master/demo.gif)

## Usage
To start presenting ViewControllers from a certain point in a NavigationController as cards, simply call

```
JWCardNavigationControllerDelegate.startPresentingViewControllersAsCards(
            inNavigationController: navigationController!)
```

in the ViewControllers `viewDidLoad()`. All sub-ViewControllers will then be presented as cards. No storyboard adjustments required.


## License

Free to use, also commercially. Happy about credits, but not required. Feel free to leave a star or tell me about it if you could use my Framework.


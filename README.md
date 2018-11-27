# JWCardViewControllerTransitioning

The missing iOS 11 Card ViewController Transition famous from Apple Music, Mail and Podcasts addable in just one line of code.

## Demo
![](https://github.com/janwasgint/JWCardViewControllerTransitioning/blob/master/demo.gif)

## Usage
To start presenting ViewControllers from a certain point in a NavigationController as cards, simply call

```
JWCardNavigationControllerDelegate.startPresentingViewControllersAsCards(
            inNavigationController: navigationController!)
```

in the ViewControllers `viewDidLoad()`. All sub-ViewControllers will then be presented as cards. All higher ViewControllers won't be affected. No storyboard adjustments required.


## License

Free to use, also commercially. Happy about credits. Feel free to leave a star or tell me about it if you could use my Framework.


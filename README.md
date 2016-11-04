# MMParallaxCollectionView

[![CI Status](http://img.shields.io/travis/Millman YANG/MMParallaxCollectionView.svg?style=flat)](https://travis-ci.org/Millman YANG/MMParallaxCollectionView)
[![Version](https://img.shields.io/cocoapods/v/MMParallaxCollectionView.svg?style=flat)](http://cocoapods.org/pods/MMParallaxCollectionView)
[![License](https://img.shields.io/cocoapods/l/MMParallaxCollectionView.svg?style=flat)](http://cocoapods.org/pods/MMParallaxCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/MMParallaxCollectionView.svg?style=flat)](http://cocoapods.org/pods/MMParallaxCollectionView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

    iOS 8.0+
    Xcode 8.0+
    Swift 3.0+
## Use

Step:

1.set your headerStyle
       
    public enum HeaderStyle {
        case rear
        case front
        case normal
    }
    collectionVIew.setHeaderStyle(style: .front)
 
2.Parallax
  
    collectionView.addParallax(view: yourView,height: 180)
      
3."UICollectionReusableView" need to inherit MMHeaderReuseView
  
     class HeaderTitleView: MMHeaderReuseView {
     }
     
4.Control yourself is show the bar
    
    collectionView.showNavigationBar(isShow: false, animated: false)

## Installation

MMParallaxCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MMParallaxCollectionView"
```

## Author

Millman YANG, millmanyang@gmail.com

## License

MMParallaxCollectionView is available under the MIT license. See the LICENSE file for more info.

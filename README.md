# JKImagePicker

[![CI Status](http://img.shields.io/travis/jamesTheKid/JKImagePicker.svg?style=flat)](https://travis-ci.org/jamesTheKid/JKImagePicker)
[![Version](https://img.shields.io/cocoapods/v/JKImagePicker.svg?style=flat)](http://cocoapods.org/pods/JKImagePicker)
[![License](https://img.shields.io/cocoapods/l/JKImagePicker.svg?style=flat)](http://cocoapods.org/pods/JKImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/JKImagePicker.svg?style=flat)](http://cocoapods.org/pods/JKImagePicker)

![](https://image.ibb.co/jmrqmS/Screen_Shot_2018_02_16_at_20_18_38.png)
![](https://image.ibb.co/hvVSY7/Screen_Shot_2018_02_16_at_20_47_57.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift 3.2

  iOS 9
  

## Installation

JKImagePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JKImagePicker'
```

## Features

* Load all photos from Photo library
* Select which library photos to load
* Zoom-in and zoom-out with Gestures
* Zoom-in and zoom-out button like instagram
* Grid view while editing/touch begins
* Crop Image while maintaining aspect ratio of image
* Crop Image With original image resolution
* Take square-sized image with camera

## JKImagePicker Usage

Import JKImagePicker ```import JKImagePicker``` then use the following :

```Swift
let imagePicker = JKImagePickerViewController()
imagePicker = self
self.present(self.imagePicker!, animated: true, completion: nil)
```

#### Delegate methods

```Swift
// Return the image which is selected from library or taken with the camera.
func didFinishPickingPhoto(image: UIImage) {

print("image picked")

}

// Called after click on cancel button.
func didCancelPickingPhoto() {

print("Cancel button clicked")
}
```

## TO-DO

* Swift 4 support
* Add filters
* Add Edits (Brightness, Contrast, Saturation...)
* Make all the components configurable


## Author

**Jimmy Kumako**  ,  https://twitter.com/jamesthakid

## License

JKImagePicker is available under the MIT license. See the LICENSE file for more info.

## Special Credits

This project is based on **Fahid Attique** project  **FAImageCropper**  -  https://github.com/fahidattique55/FAImageCropper


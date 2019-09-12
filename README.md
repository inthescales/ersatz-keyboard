# Tasty Imitation Keyboard Cocoapod

A Swift 4.2 / 5.0 compatible imitation of the en-US Apple native keyboard.  Useful as a base for creating your own keyboard extensions.  Designed to be quick to integrate using Cocoapods.

Based on [Project by Archagon](https://github.com/archagon/tasty-imitation-keyboard/) which sadly has been unmaintained for a few years.

## Fantastic Additions

* Swift 4.2 / 5.0 Support
* Cocoapod Spec / Integration

## Original Fantastic Features

* No bitmaps! Everything is rendered using CoreGraphics.
* Dynamic layouts! All the keys are laid out programmatically, meaning that the keyboard is much easier to extend and will automatically work on devices of all sizes.
* Auto-capitalization, period shortcut, keyboard clicks.
* An extensible settings screen.
* Dark mode and solid color mode.
* This keyboard is an iOS8 extension

## Aged but relevant Screenshots

![Portrait](./Screenshot-Portrait.png "Portrait")

![Landscape](./Screenshot-Landscape.png "Landscape")

![Settings](./Settings-Portrait.png "Settings")

## Current State

Updated for iOS 13 and Swift 4.2 / Swift 5.0 - No other major changes from original build

## Cocoapod Integration

1. Add Pod target to your keyboard extension in .podfile

    ```ruby
    target 'keyboard-extension' do
      project 'project/project.xcodeproj'
      pod 'TastyKeyboard'
    end
    ```

1. In your keyboard view controller subclass `TastyKeyboardViewController`

    ```swift
    import UIKit
    import TastyKeyboard

    class KeyboardViewController: TastyKeyboardViewController {
      // ... Custom implementation here
    }
    ```

1. There is no step 3

## Build Instructions

If you'd like to mess with TastyKeyboard, this repo has the original project and hosting app in it.  Clone the repo and:

1. Edit Scheme for the Keyboard target and set the Executable to be HostingApp.app.
2. Run the Keyboard target.
3. Go to `Settings → General → Keyboard → Keyboards → Add New Keyboard` on your device and add the third-party keyboard.
4. Go back to the app. You should be able to select the keyboard via the globe icon.

## Other Stuff

Please consult [the project wiki](https://github.com/archagon/tasty-imitation-keyboard/wiki) for technical details. You may find it handy if you're implementing your own keyboard!

## License

This project is licensed under the 3-clause ("New") BSD license. Go Beers!

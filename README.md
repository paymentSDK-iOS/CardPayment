# PaymentSDK

[![Build](https://travis-ci.org/simplifycom/simplify-ios-sdk-swift.svg?branch=master)](https://travis-ci.org/simplifycom/simplify-ios-sdk-swift) 

The iOS SDK by PaymentSDK allows you to create a apikey for payment and create a card token using apikey (one time use token representing card details) in your iOS app to send to a server to enable it to make a payment. By creating a card token, PaymentSDK allows you to avoid sending card details to your server. The SDK can help with formatting and validating card information before the information is tokenized.

<p align="center">
    <img src="https://github.com/paymentSDK-iOS/CardPayment/blob/main/ScreenShot.png" width="250" height="500"/>
    <img src="https://github.com/paymentSDK-iOS/CardPayment/blob/main/ScreenShot1.png" width="250" height="500"/>
</p>



## Requirements
  - Swift 5 or higher

## Installation

The iOS SDK can be manualy included in your project by downloading or cloning the SDK project and adding it as a subproject in your project.  


If you would like to use [Carthage]( https://github.com/Carthage/Carthage) to integrate the sdk into your project, you can do so with the following line in your cartfile.

```
  pod 'PaymentFramework'
```

## Usage

## Import the SDK
Import the PaymentFramework SDK into your project

```swift
import PaymentFramework
```

## Initialialize the SDK
In order to use the SDK, you must inharite the `CardPaymentViewController` class

```swift
class ViewController: CardPaymentViewController {
    ...
}
```

In `ViewController` in `viewDidLoad()` assign your email, amount, country currency and endpoint  
```swift
class ViewController: CardPaymentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        email = "payment@gmail.com"
        amount = 125
        country = "IE"
        currency = "EUR"
        endpoint = "some endpoint"
        ...
    }
}
```

In `viewDidLoad()` cardPaymentView properties assign `placeHolderColor`,`themColor`,`iconColor`,`borderColor`,`errorColor`,`textColor` and `NavigationTitle`
```swift
override func viewDidLoad() {
    ...
    cardPaumentView.placeHolderColor = .blue
    cardPaumentView.themeColor = .purple
    NavigationTitle = "PayTM"
    cardPaumentView.iconColor = .green
    cardPaumentView.borderColor = .green
    cardPaumentView.errorColor = .systemRed
    cardPaumentView.textColor = .green
    ...
}
```

---

## Sample App
This project includes a sample app to demonstrate SDK usage. To configure the sample app, add your public key to the `CardPaymentViewController` in the project.


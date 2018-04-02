[![Build Status](https://travis-ci.org/rubygarage/shopapp-ios.svg?branch=master)](https://travis-ci.org/rubygarage/shopapp-ios)
[![codecov](https://codecov.io/gh/rubygarage/shopapp-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/rubygarage/shopapp-ios)

# ShopApp for iOS
ShopApp connects with popular ecommerce platforms like Shopify, Magento, BigCommerce, and WooCommerce to transfer them into a mobile app for iOS and Android. 


![ ](https://github.com/rubygarage/shopapp-ios/blob/master/assets/shopapp-main-screen.gif?raw=true)
***
So far, we’ve developed a [Shopify provider for iOS](https://github.com/rubygarage/shopapp-shopify-ios) and [Shopify provider for Android](https://github.com/rubygarage/shopapp-shopify-android).
Currently we’re working on adding more providers and extending the features list, so stay in touch with our updates. 

## Set up environment
To build and submit an application to the App Store, you're required to have XCode 9 installed. If it's not installed yet, follow the instructions from the official website https://developer.apple.com/xcode/ to install XCode 9.

To install the dependencies required for the application build, ShopApp uses CocoaPods.  Connect one of the providers for an online store and install all the dependencies. Here we'll use Shopify as an example.

1. Add the following line to the Podfile:

```
pod "ShopApp_Shopify", "~> 1.0"
```

2. Install all the dependencies:

```
pod install
```

3. You'll also have to configure the provider to get an access to your online store. To get an access, follow the instructions on a provider's [page](https://github.com/rubygarage/shopapp-shopify-ios).

Here's how to configure the Shopify provider. Add the following code:

```
container.register(Repository.self) { _ in
    return ShopifyRepository(apiKey: "API KEY",
        shopDomain: "SHOP DOMAIN",
        adminApiKey: "ADMIN API KEY",
        adminPassword: "ADMIN PASSWORD",
        applePayMerchantId: "APPLE PAY MERCHANT ID")
}
```

to the file **ShopApp/Data/DI/DataAssembly.swift**. 

4. As the result, you'll be able to open the project file and launch an app.

To create a client for another SaaS, you'll have to add the following pod:
```
pod 'ShopApp_Gateway', '~> 1.0.3'
```
to the dependencies. 

5. Next, you have to create the class that'll work with the main application and implement the Repository protocol in it. 

After that, you can add a new client to the [main ShopApp application](https://github.com/rubygarage/shopapp-ios)

## Requirements
* iOS 10+
* XCode 9 for app development and submission to Apple App Store
* Cocoapods to install all the dependencies

## License
The ShopApp Shopify for iOS provider is licensed under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0)
***
<a href="https://rubygarage.org/"><img src="https://github.com/rubygarage/shopapp-shopify-ios/blob/master/assets/rubygarage.png?raw=true" alt="RubyGarage Logo" width="415" height="128"></a>

RubyGarage is a leading software development and consulting company in Eastern Europe. Our main expertise includes Ruby and Ruby on Rails, but we successfuly employ other technologies to deliver the best results to our clients. [Check out our portoflio](https://rubygarage.org/portfolio) for even more exciting works!

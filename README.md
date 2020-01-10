# WordpressReader
An iOS application to parse WordPress blogs

## Features
- [X] Supports latest WordPress REST API
- [ ] GraphQL support
- [X] WordPress MultiSite compatible
- [x] Network interruptions handling
- [X] Google Firebase Analytics
- [x] Swift 5
- [X] iOS 13 compatible

## Requirements
- macOS 10.15+
- iOS 13.0+
- Xcode 11.0+
- Swift 5

## Usage

### Basics

1. Clone this repository

```swift
git clone https://github.com/uvcmedia/WordpressReader
```

2. Install CocoaPods dependencies

```swift
pod install
```


### Setup

Add a Wordpress site
```swift
let myWordpressSite = WordpressSite(name: "", apiURL: "https://<wordpress url>.com/wp-json/wp/v2", logoURL: "https://<logo url>.com/logo.png", apiType: .rest)
currentSite = myWordpressSite
```

### Build, run, enjoy!

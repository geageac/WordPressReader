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

License
-------
All files in this repository are under the Apache 2 license:

    Copyright 2020 UVC Media. All rights reserved.
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

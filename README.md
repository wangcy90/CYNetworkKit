# CYNetworkKit

[![Version](https://img.shields.io/cocoapods/v/CYNetworkKit.svg?style=flat)](http://cocoapods.org/pods/CYNetworkKit)
[![License](https://img.shields.io/cocoapods/l/CYNetworkKit.svg?style=flat)](http://cocoapods.org/pods/CYNetworkKit)
[![Platform](https://img.shields.io/cocoapods/p/CYNetworkKit.svg?style=flat)](http://cocoapods.org/pods/CYNetworkKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

| Minimum iOS Target | Minimum OS X Target | Minimum watchOS Target | Minimum tvOS Target |
| :-: | :-: | :-: | :-: |
| 8.0 | 10.9 | 2.0 | 9.0 |


##Usage


######Creating a Request


```Objective-C
NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
[[[[[CYURLRequest request] GET:@"http://example.com" parameters:parameters] success:^(id  _Nullable responseObject) {
        
}] failure:^(NSError * _Nullable error) {
        
}] send];
```


######additiional configuration


```Objective-C
NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};

CYURLRequest *request = [[CYURLRequest request] GET:@"http://example.com" parameters:parameters];
   
[request addHTTPHeaders:^NSDictionary<NSString *,NSString *> * _Nonnull{
    return @{@"Content-type": @"text/html"};
}];
    
[request log:YES]; // only when debug
    
[request timeout:20]; // timeout
    
[request progress:^(float progress) {
    // update progress
}];
    
[request transform:^id _Nonnull(id  _Nonnull responseObject) {
    // convert responseObject to model or anything.
    return responseObject;
}];
    
[request success:^(id  _Nullable responseObject) {
    // success callback
}];
    
[request failure:^(NSError * _Nullable error) {
    // failure callback
}];

// add form data
[request addFormData:[CYURLRequestFormData dataWithName:@"image" fileURL:[NSURL URLWithString:@"filePath"]]];
    
[request sslConfiguration:^(CYURLRequestSSLConfiguration * _Nonnull config) {
    // ssl config
}];

NSURLSessionTask *task = [request send];
    
[task cancel];//cancel request

```


######specific serializer


```Objective-C

NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};

CYURLRequest *request = [[CYURLRequest request] GET:@"http://example.com" parameters:parameters];

[[request requestSerializerJSON] responseSerializerJSON];

[request send];

```


######CYURLRequest + ReactiveObjc

If you are using ReactiveObjc for networking and you want to create request with RACSignal, you can add `#define CYURLREQUEST_RAC_SUPPORT` before `#import <CYNetworkKit/CYNetworkKit.h>` or add `#define CYURLREQUEST_RAC_SUPPORT` to your pch file.

```Objective-C

NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
RACDisposable *disposable = [[[[CYURLRequest request] GET:@"http://example.com" parameters:parameters] rac_send] subscribeNext:^(id  _Nullable x) {
        
} error:^(NSError * _Nullable error) {
        
} completed:^{
        
}];
    
[disposable dispose];//cancel request

```

## Installation

CYNetworkKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CYNetworkKit'
```

## License

CYNetworkKit is available under the MIT license. See the LICENSE file for more info.



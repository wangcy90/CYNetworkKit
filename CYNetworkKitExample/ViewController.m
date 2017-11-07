//
//  ViewController.m
//  CYNetworkKit
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2017/11/6.
//  Copyright © 2017年 WangChongyang. All rights reserved.
//

#import "ViewController.h"

#define CYURLREQUEST_RAC_SUPPORT

#import <CYNetworkKit/CYNetworkKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)testRequest {
    
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
    [[[[[CYURLRequest request] GET:@"http://example.com" parameters:parameters] success:^(id  _Nullable responseObject) {
        
    }] failure:^(NSError * _Nullable error) {
        
    }] send];
    
}

- (void)testWithAdditionalConfiguration {
    
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
    CYURLRequest *request = [[CYURLRequest request] GET:@"http://example.com" parameters:parameters];
    
    [request addHTTPHeaders:^NSDictionary<NSString *,NSString *> * _Nonnull{
        return @{@"Content-type": @"text/html"};
    }];
    
    [request log:YES]; // only when debug
    
    [request timeout:20]; //
    
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
    
}

- (void)specificSerializer {
    
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
    CYURLRequest *request = [[CYURLRequest request] GET:@"http://example.com" parameters:parameters];
    
    [[request requestSerializerJSON] responseSerializerJSON];
    
    [request send];
    
}

- (void)testRequestWithRAC {
    
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    
    RACDisposable *disposable = [[[[CYURLRequest request] GET:@"http://example.com" parameters:parameters] rac_send] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    
    [disposable dispose];//cancel request
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

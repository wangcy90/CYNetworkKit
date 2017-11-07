//
//  CYURLRequest+RACSignalSupport.h
//  CYNetworkKit
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2017/7/16.
//  Copyright © 2017年 WangChongyang. All rights reserved.
//

#ifdef CYURLREQUEST_RAC_SUPPORT

#import "CYURLRequest.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYURLRequest (RACSignalSupport)

- (RACSignal *)rac_send;

@end

@implementation CYURLRequest (RACSignalSupport)

- (RACSignal *)rac_send {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionTask *task = [[[self success:^(id  _Nullable responseObject) {
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
        }] failure:^(NSError * _Nullable error) {
            
            [subscriber sendError:error];
            
        }] send];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
            
        }];
        
    }];
    
}

@end

NS_ASSUME_NONNULL_END

#endif

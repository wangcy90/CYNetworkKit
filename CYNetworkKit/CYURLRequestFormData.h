//
//  CYURLRequestFormData.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYURLRequestFormData : NSObject

+ (instancetype)dataWithName:(NSString *)name fileData:(NSData *)fileData;

+ (instancetype)dataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;

+ (instancetype)dataWithName:(NSString *)name fileURL:(NSURL *)fileURL;

+ (instancetype)dataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END

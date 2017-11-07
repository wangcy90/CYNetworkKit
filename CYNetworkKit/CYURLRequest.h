//
//  CYURLRequest.h
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

typedef NS_ENUM(NSUInteger, CYSSLPinningMode) {
    CYSSLPinningModeNone,
    CYSSLPinningModePublicKey,
    CYSSLPinningModeCertificate,
};

NS_ASSUME_NONNULL_BEGIN

@class CYURLRequestFormData,CYURLRequestSSLConfiguration;

@interface CYURLRequest : NSObject

+ (instancetype)request;

- (CYURLRequest *)GET:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)HEAD:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)POST:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)PUT:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)PATCH:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)DELETE:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)upload:(NSString *)url parameters:(nullable id)parameters;

- (CYURLRequest *)download:(NSString *)url toDestination:(NSString *)destination;

- (CYURLRequest *)addFormData:(CYURLRequestFormData *)formData;

- (CYURLRequest *)addFormDatas:(NSArray<CYURLRequestFormData *> *)formDatas;

- (CYURLRequest *)addHTTPHeaders:(NSDictionary<NSString *, NSString *> * (^)(void))block;

- (CYURLRequest *)sslConfiguration:(void (^)(CYURLRequestSSLConfiguration *config))block;

- (CYURLRequest *)timeout:(NSTimeInterval)interval;

- (CYURLRequest *)log:(BOOL)enable;

- (CYURLRequest *)transform:(id (^)(id responseObject))block;

- (CYURLRequest *)progress:(nullable void (^)(float progress))block;

- (CYURLRequest *)success:(nullable void (^)(id _Nullable responseObject))block;

- (CYURLRequest *)failure:(nullable void (^)(NSError * _Nullable error))block;

- (NSURLSessionTask *)send;

@end

@interface CYURLRequest (Serializer)

- (CYURLRequest *)requestSerializerHTTP;

- (CYURLRequest *)requestSerializerJSON;

- (CYURLRequest *)requestSerializerPropertyList;

- (CYURLRequest *)responseSerializerHTTP;

- (CYURLRequest *)responseSerializerJSON;

- (CYURLRequest *)responseSerializerPropertyList;

- (CYURLRequest *)responseSerializerXMLParser;

@end

@interface CYURLRequestSSLConfiguration : NSObject

@property(nonatomic,assign)CYSSLPinningMode SSLPinningMode;

@property(nonatomic,strong,nullable)NSSet<NSData *> *pinnedCertificates;

@property(nonatomic,assign)BOOL allowInvalidCertificates;

@property(nonatomic,assign)BOOL validatesDomainName;

@end

NS_ASSUME_NONNULL_END

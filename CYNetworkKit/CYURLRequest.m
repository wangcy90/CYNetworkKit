//
//  CYURLRequest.m
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

#import "CYURLRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "CYURLRequestFormData.h"

#pragma mark - CYURLRequestConfiguration

typedef NS_ENUM(NSInteger,CYURLRequestMethod) {
    CYURLRequestMethod_GET,
    CYURLRequestMethod_HEAD,
    CYURLRequestMethod_POST,
    CYURLRequestMethod_PUT,
    CYURLRequestMethod_PATCH,
    CYURLRequestMethod_DELETE,
    CYURLRequestMethod_DOWNLOAD,
    CYURLRequestMethod_UPLOAD
};

@interface CYURLRequestConfiguration : NSObject

@property(nonatomic,copy)NSString *url;

@property(nonatomic,strong)NSDictionary<NSString *, NSString *> *headers;

@property(nonatomic,strong)id parameters;

@property(nonatomic,copy)NSString *downloadPath;

@property(nonatomic,assign)NSTimeInterval timeoutInterval;

@property(nonatomic,assign)BOOL logEnabled;

@property(nonatomic,assign)CYURLRequestMethod method;

@end

@implementation CYURLRequestConfiguration

@end

#pragma mark - CYURLRequestFormData

@interface CYURLRequestFormData()

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *fileName;

@property(nonatomic,copy)NSString *mimeType;

@property(nonatomic,strong)NSData *fileData;

@property(nonatomic,strong)NSURL *fileURL;

@end

@implementation CYURLRequestFormData

+ (instancetype)dataWithName:(NSString *)name fileData:(NSData *)fileData {
    return [[self alloc]initWithName:name fileName:nil mimeType:nil fileData:fileData];
}

+ (instancetype)dataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    return [[self alloc]initWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
}

+ (instancetype)dataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    return [[self alloc]initWithName:name fileName:nil mimeType:nil fileURL:fileURL];
}

+ (instancetype)dataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    return [[self alloc]initWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
}

- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    if (self = [super init]) {
        self.name = name;
        self.fileName = fileName;
        self.mimeType = mimeType;
        self.fileData = fileData;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    if (self = [super init]) {
        self.name = name;
        self.fileName = fileName;
        self.mimeType = mimeType;
        self.fileURL = fileURL;
    }
    return self;
}

@end

#pragma mark - CYURLRequestSSLConfiguration

@implementation CYURLRequestSSLConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.validatesDomainName = YES;
    }
    return self;
}

@end

#pragma mark - CYURLRequest

@interface CYURLRequest()

@property(nonatomic,strong)CYURLRequestConfiguration *configuration;

@property(nonatomic,strong)AFSecurityPolicy *securityPolicy;

@property(nonatomic,strong)NSMutableArray *formDatas;

@property(nonatomic,copy)id (^transformBlock)(id responseObject);

@property(nonatomic,copy)void (^progressBlock)(float progress);

@property(nonatomic,copy)void (^successBlock)(id responseObject);

@property(nonatomic,copy)void (^failureBlock)(NSError *error);

@property(nonatomic,strong)AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

@property(nonatomic,strong)AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

@end

@implementation CYURLRequest

#pragma mark - lifecycle

- (void)dealloc {
#ifdef DEBUG
    if (self.configuration.logEnabled) {
        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    }
#endif
    self.configuration = nil;
    self.formDatas = nil;
    self.transformBlock = nil;
    self.progressBlock = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
    self.requestSerializer = nil;
    self.responseSerializer = nil;
}

+ (instancetype)request {
    return [[self alloc] init];
}

#pragma mark - public

- (CYURLRequest *)GET:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_GET;
    return self;
}

- (CYURLRequest *)HEAD:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_HEAD;
    return self;
}

- (CYURLRequest *)POST:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_POST;
    return self;
}

- (CYURLRequest *)PUT:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_PUT;
    return self;
}

- (CYURLRequest *)PATCH:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_PATCH;
    return self;
}

- (CYURLRequest *)DELETE:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_DELETE;
    return self;
}

- (CYURLRequest *)upload:(NSString *)url parameters:(id)parameters {
    self.configuration.url = url;
    self.configuration.parameters = parameters;
    self.configuration.method = CYURLRequestMethod_UPLOAD;
    return self;
}

- (CYURLRequest *)download:(NSString *)url toDestination:(NSString *)destination {
    self.configuration.url = url;
    self.configuration.downloadPath = destination;
    self.configuration.method = CYURLRequestMethod_DOWNLOAD;
    return self;
}

- (CYURLRequest *)addFormData:(CYURLRequestFormData *)formData {
    if (formData) {
        [self.formDatas addObject:formData];
    }
    return self;
}

- (CYURLRequest *)addFormDatas:(NSArray<CYURLRequestFormData *> *)formDatas {
    [self.formDatas addObjectsFromArray:formDatas];
    return self;
}

- (CYURLRequest *)addHTTPHeaders:(NSDictionary<NSString *,NSString *> * _Nonnull (^)(void))block {
    if (block) {
        self.configuration.headers = block();
    }
    return self;
}

- (CYURLRequest *)sslConfiguration:(void (^)(CYURLRequestSSLConfiguration *))block {
    if (block) {
        CYURLRequestSSLConfiguration *config = [CYURLRequestSSLConfiguration new];
        block(config);
        AFSSLPinningMode mode = (AFSSLPinningMode)config.SSLPinningMode;
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:mode];
        policy.allowInvalidCertificates = config.allowInvalidCertificates;
        policy.validatesDomainName = config.validatesDomainName;
        if (config.pinnedCertificates) {
            policy.pinnedCertificates = config.pinnedCertificates;
        }
        self.securityPolicy = policy;
    }
    return self;
}

- (CYURLRequest *)timeout:(NSTimeInterval)interval {
    self.configuration.timeoutInterval = interval;
    return self;
}

- (CYURLRequest *)log:(BOOL)enable {
    self.configuration.logEnabled = enable;
    return self;
}

- (CYURLRequest *)transform:(id (^)(id responseObject))block {
    self.transformBlock = block;
    return self;
}

- (CYURLRequest *)progress:(void (^)(float))block {
    self.progressBlock = block;
    return self;
}

- (CYURLRequest *)success:(void (^)(id _Nullable))block {
    self.successBlock = block;
    return self;
}

- (CYURLRequest *)failure:(void (^)(NSError * _Nullable))block {
    self.failureBlock = block;
    return self;
}

- (NSURLSessionTask *)send {
    
    AFHTTPSessionManager *manager = self.manager;
    
    switch (self.configuration.method) {
        case CYURLRequestMethod_GET:
            
            return [self manager:manager GET:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_HEAD:
            
            return [self manager:manager HEAD:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_POST:
            
            return [self manager:manager POST:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_PUT:
            
            return [self manager:manager PUT:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_PATCH:
            
            return [self manager:manager PATCH:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_DELETE:
            
            return [self manager:manager DELETE:self.configuration.url parameters:self.configuration.parameters];
            
        case CYURLRequestMethod_DOWNLOAD:
            
            return [self manager:manager DOWNLOAD:self.configuration.url destination:self.configuration.downloadPath];
            
        case CYURLRequestMethod_UPLOAD:
            
            return [self manager:manager UPLOAD:self.configuration.url parameters:self.configuration.parameters];
            
    }
    
}

#pragma mark - private

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager GET:(NSString *)URLString parameters:(id)parameters {
    
    return [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [self executeProgress:downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:responseObject error:nil];
        
        [self executeSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager HEAD:(NSString *)URLString parameters:(id)parameters {
    
    return [manager HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:nil];
        
        [self executeSuccess:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager POST:(NSString *)URLString parameters:(id)parameters {
    
    return [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self executeProgress:uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:responseObject error:nil];
        
        [self executeSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager PUT:(NSString *)URLString parameters:(id)parameters {
    
    return [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:responseObject error:nil];
        
        [self executeSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager PATCH:(NSString *)URLString parameters:(id)parameters {
    
    return [manager PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:responseObject error:nil];
        
        [self executeSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager DELETE:(NSString *)URLString parameters:(id)parameters {
    
    return [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:responseObject error:nil];
        
        [self executeSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self logURL:task.currentRequest.URL headers:task.currentRequest.allHTTPHeaderFields responseObject:nil error:error];
        
        [self executeFailure:error];
        
    }];
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager DOWNLOAD:(NSString *)URLString destination:(NSString *)destination {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [manager.requestSerializer.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:mutableRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [self executeProgress:downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (destination) {
            
            return [[NSURL fileURLWithPath:destination] URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [self logURL:response.URL headers:nil responseObject:filePath error:error];
        
        error ? [self executeFailure:error] : [self executeSuccess:filePath];
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
}

- (NSURLSessionTask *)manager:(AFHTTPSessionManager *)manager UPLOAD:(NSString *)URLString parameters:(id)parameters {
    
    __block NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [self.formDatas enumerateObjectsUsingBlock:^(CYURLRequestFormData *obj, NSUInteger idx, BOOL *stop) {
            
            if (obj.fileData) {
                
                if (obj.fileName && obj.mimeType) {
                    
                    [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                    
                } else {
                    
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                    
                }
                
            } else if (obj.fileURL) {
                
                if (obj.fileName && obj.mimeType) {
                    
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&serializationError];
                    
                } else {
                    
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&serializationError];
                    
                }
                
                if (serializationError) {
                    *stop = YES;
                }
                
            }
            
        }];
        
    } error:&serializationError];
    
    if (serializationError) {
        
        [self executeFailure:serializationError];
        
        return nil;
        
    }
    
    NSURLSessionDataTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self executeProgress:uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount];
        
    } completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        [self logURL:response.URL headers:nil responseObject:responseObject error:error];
        
        error ? [self executeFailure:error] : [self executeSuccess:responseObject];
        
    }];
    
    [uploadTask resume];
    
    return uploadTask;
    
}

- (void)executeProgress:(float)progress {
    
    if (self.progressBlock) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.progressBlock(progress);
            
        });
        
    }
    
}

- (void)executeSuccess:(id)responseObject {
    
    if (self.transformBlock) responseObject = self.transformBlock(responseObject);
    
    if (self.successBlock) self.successBlock(responseObject);
    
}

- (void)executeFailure:(NSError *)error {
    
    if (self.failureBlock) self.failureBlock(error);
    
}

- (void)logURL:(NSURL *)URL headers:(NSDictionary *)headerFields responseObject:(id)responseObject error:(NSError *)error {
    
#ifdef DEBUG
    if (self.configuration.logEnabled) {
        
        NSString *logMsg = [NSString stringWithFormat:@"\n============%@============\n============[URL]============\n%@",self,URL];
        
        if (headerFields) {
            logMsg = [logMsg stringByAppendingFormat:@"\n============[HTTPHeaderFields]============\n%@",headerFields];
        }
        
        if (responseObject) {
            logMsg = [logMsg stringByAppendingFormat:@"\n============[responseObject]============\n%@",responseObject];
        }
        
        if (error) {
            logMsg = [logMsg stringByAppendingFormat:@"\n============[error]============\n%@",error];
        }
        
        NSLog(@"%@",logMsg);
        
    }
#endif
    
}

- (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (self.requestSerializer) {
        manager.requestSerializer = self.requestSerializer;
    }
    
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }
    
    NSDictionary *headers = self.configuration.headers;
    
    for (NSString *key in headers) {
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    }
    
    if (self.configuration.timeoutInterval > 0) {
        manager.requestSerializer.timeoutInterval = self.configuration.timeoutInterval;
    }
    
    if (self.securityPolicy) {
        manager.securityPolicy = self.securityPolicy;
    }
    
    return manager;
    
}

#pragma mark - getters

- (CYURLRequestConfiguration *)configuration {
    
    if (!_configuration) {
        _configuration = [CYURLRequestConfiguration new];
    }
    return _configuration;
    
}

- (NSMutableArray *)formDatas {
    
    if (!_formDatas) {
        _formDatas = [NSMutableArray arrayWithCapacity:1];
    }
    return _formDatas;
    
}

@end

@implementation CYURLRequest (Serializer)

- (CYURLRequest *)requestSerializerHTTP {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    return self;
}

- (CYURLRequest *)requestSerializerJSON {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (CYURLRequest *)requestSerializerPropertyList {
    self.requestSerializer = [AFPropertyListRequestSerializer serializer];
    return self;
}

- (CYURLRequest *)responseSerializerHTTP {
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    return self;
}

- (CYURLRequest *)responseSerializerJSON {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;
}

- (CYURLRequest *)responseSerializerPropertyList {
    self.responseSerializer = [AFPropertyListResponseSerializer serializer];
    return self;
}

- (CYURLRequest *)responseSerializerXMLParser {
    self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    return self;
}

@end

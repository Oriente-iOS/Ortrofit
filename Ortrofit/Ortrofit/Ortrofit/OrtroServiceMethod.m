//
//  OrtroServiceMethod.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroServiceMethod.h"
#import "OrtroSessionTaskFactory.h"
#import "ORRequestAdaptor.h"
#import "ORResponseAdaptor.h"
#import "Ortrofit.h"
#import "ORMethod.h"
#import "OrtroMacro.h"
#import "AFNetworking.h"
#import "ORRequestAdaptorFactory.h"
#import "ORRequestAdaptor.h"
#import "ORResponseAdaptorFactory.h"
#import "ORResponseAdaptor.h"
#import "OrtroCallAdaptorFactory.h"
#import "OrtroCallAdaptor.h"
#import "OrtroServiceMethod+ParamHandler.h"

@interface OrtroServiceMethod()

@property (nonatomic, strong) OrtroSessionTaskFactory *sessionTaskFactory;
@property (nonatomic, strong) NSArray *requestAdaptorFactories;
@property (nonatomic, strong) NSArray *responseAdaptorFactories;
@property (nonatomic, strong) OrtroCallAdaptor *callAdaptor;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, strong) OrtroPath *path;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSArray *paramKeys;
@property (nonatomic, strong) NSNumber *timeOut;
@property (nonatomic, copy) NSDictionary*(^dynamicHeaders)(void);

//@property (nonatomic, strong) NSString *contentType;
//@property (nonatomic, assign) BOOL hasBody;
//@property (nonatomic, assign) BOOL isFormEncoded;
//@property (nonatomic, assign) BOOL iseMultipart;

@end

@implementation OrtroServiceMethod

- (instancetype)initWithOtrofit:(Ortrofit *)ortrofit orMethod:(ORMethod *)orMethod{
    if (self = [super init]) {
        [self buildServiceApi:ortrofit orMethod:orMethod];
    }
    return self;
}

- (void)buildServiceApi:(Ortrofit *) ortrofit orMethod:(ORMethod *) orMethod{
    self.sessionTaskFactory = ortrofit.taskFactory;
    self.requestAdaptorFactories = ortrofit.requestFactories;
    self.responseAdaptorFactories = ortrofit.responseFactories;
    self.baseUrl = ortrofit.baseUri;
    self.timeOut = ortrofit.timeOut;
    //获取参数的名称
    self.paramKeys = [orMethod getParameterAnnotations];
    //获取请求的方法、Path等
    NSDictionary *apiAnnotations = [orMethod getAnnotations];
    self.httpMethod = [apiAnnotations objectForKey:kHttpMethod];
    self.path = [apiAnnotations objectForKey:kHttpPath];
    NSDictionary *apiHeaders = [apiAnnotations objectForKey:kHttpHeaders];
    NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
    if (ortrofit.ortroHeaders.count > 0) {
        [requestHeaders addEntriesFromDictionary:ortrofit.ortroHeaders];
    }
    if (apiHeaders.count > 0) {
        [requestHeaders addEntriesFromDictionary:apiHeaders];
    }
    
    if (ortrofit.ortroDynamicHeaders) {
        self.dynamicHeaders = ortrofit.ortroDynamicHeaders;
        [requestHeaders addEntriesFromDictionary:ortrofit.ortroDynamicHeaders()];
    }
    
    self.headers = requestHeaders.copy;

    NSString *returnType = [[orMethod getAnnotations] objectForKey:kReturnType];
    if (returnType && NSClassFromString(returnType)) {
        self.callAdaptor = [ortrofit callAdaptor:NSClassFromString(returnType) annotations:[orMethod getAnnotations]];
    }
    if (!self.callAdaptor) {
        self.callAdaptor = [[OrtroCallAdaptor alloc] init];
    }
}

- (id)adapt:(OrtroCall *)ortroCall{
    return [self.callAdaptor adapt:ortroCall];
}

- (NSURLSessionTask *)toTask:(NSArray *) requestParameterValues
              serviceSuccess:(ServiceSuccess) success
              serviceFailure:(ServiceFailure) failure{
    AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
//    AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    jsonRequestSerializer.stringEncoding = NSUTF8StringEncoding;
    if ([self.timeOut floatValue] > 1) {
        jsonRequestSerializer.timeoutInterval = [self.timeOut floatValue];
    }else{
        jsonRequestSerializer.timeoutInterval = 30.0f;
    }
    NSString *fullUrl = nil;
    NSString *urlPath = [self renderPath:requestParameterValues];
    if ([self.baseUrl hasSuffix:@"/"] && [urlPath hasPrefix:@"/"]) {
        fullUrl = [[self.baseUrl substringToIndex:self.baseUrl.length -1] stringByAppendingString:urlPath];
    }else if ([self.baseUrl hasSuffix:@"/"]) {
        fullUrl = [self.baseUrl stringByAppendingString:urlPath];
    }else{
        fullUrl = [[self.baseUrl stringByAppendingString:@"/"] stringByAppendingString:urlPath];
    }
    NSError *error;
    NSMutableURLRequest *mRequest = [jsonRequestSerializer requestWithMethod:self.httpMethod URLString:fullUrl parameters:[self parseRequestParams:requestParameterValues] error:&error];
    if (error) {
        failure(nil,nil,error);
    }
    //设置请求头部
    NSMutableDictionary *realHeaders = [self.headers mutableCopy]?:@{};
    if (self.dynamicHeaders) {
        [realHeaders addEntriesFromDictionary:self.dynamicHeaders()];
    }
    for (NSString *key in realHeaders) {
        [mRequest setValue:[realHeaders objectForKey:key] forHTTPHeaderField:key];
    }
    //处理请求的拦截
    NSURLRequest *adaptedRequest = [mRequest copy];
    for (id<ORRequestAdaptorFactoryProtocol> adaptorFactory in self.requestAdaptorFactories) {
        id<ORRequestAdaptorProtocol> adaptor = [adaptorFactory getAdaptor:adaptedRequest];
        if (adaptor) {
           adaptedRequest = [adaptor adapt:adaptedRequest];
        }
    }
    return [self.sessionTaskFactory generateTask:adaptedRequest success:success failure:failure];
}

- (id)adaptResponse:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error{
    id result = nil;
    for (id<ORResponseAdaptorFactoryProtocol> adaptorFactory in self.responseAdaptorFactories) {
        id<ORResponseAdaptorProtocol> adptor = [adaptorFactory getAdaptor:sessionTask responseObject:responseObject error:error];
        if (adptor) {
            id adaptorResult = [adptor adapt:sessionTask responseObject:responseObject error:error];
            if (adaptorResult) {
                result = adaptorResult;
            }
        }
    }
    return result;
}

@end

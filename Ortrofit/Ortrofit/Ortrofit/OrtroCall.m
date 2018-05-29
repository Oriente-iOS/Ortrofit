//
//  OrtroCall.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/4.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroCall.h"
#import "OrtroServiceMethod.h"
#import "OrtroServiceMethod+ParamHandler.h"

@interface OrtroCall()

@property (nonatomic, strong) OrtroServiceMethod *serviceMethod;
@property (nonatomic, strong) NSArray *requestParamValues;
@property (nonatomic, weak) NSURLSessionTask *sessionTask;
@property (nonatomic, strong) OrtroCallSignature *callSignature;

@end

@implementation OrtroCall

- (instancetype)initWithServiceMethod:(OrtroServiceMethod*) serviceMethod requestParams:(NSArray *) params{
    if (self = [super init]) {
        _serviceMethod = serviceMethod;
        _requestParamValues = params;
        
        NSLog(@"ortroCall## created!!!");
    }
    return self;
}

- (void)enqueue:(ServiceSuccess) success failure:(ServiceFailure) failure{
    self.sessionTask = [self.serviceMethod toTask:self.requestParamValues serviceSuccess:^(NSURLResponse * urlResponse, id responseObject){
        //DO Interceptor
        id result = [self.serviceMethod adaptResponse:self.sessionTask responseObject:responseObject error:nil];
        success(urlResponse,result?:responseObject);
    } serviceFailure:^(NSURLResponse * urlResponse, id responseObject, NSError *error){
        //DO Interceptor
        id result = [self.serviceMethod adaptResponse:self.sessionTask responseObject:responseObject  error:error];
        failure(urlResponse,result?:responseObject,error);
    }];
    [self.sessionTask resume];
}


- (void)cancel{
    [self.sessionTask cancel];
}

- (OrtroCallSignature *)callSignature{
    if (!_callSignature) {
        _callSignature = [OrtroCallSignature new];
        _callSignature.url = [self.serviceMethod renderPath:self.requestParamValues];
        _callSignature.params = [self.serviceMethod parseRequestParams:self.requestParamValues];
        _callSignature.headers = self.serviceMethod.headers;
        _callSignature.method = self.serviceMethod.httpMethod;
    }
    return _callSignature;
}

- (void)dealloc{
    NSLog(@"ortroCall## dealloced!!!");
}

@end

//
//  Ortrofit.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "Ortrofit.h"
#import "OrtroProxy.h"
#import "OrInvocationHandler.h"
#import "ReactiveCocoa.h"
#import "OrtroServiceMethod.h"
#import "ORMethod.h"
#import "OrtroSessionTaskFactory.h"
#import "OrtroCall.h"
#import "OrtroCallAdaptor.h"
#import "OrtroCallAdaptorFactory.h"

@interface Ortrofit()

@property (nonatomic, copy) NSString *baseUri;
@property (nonatomic, strong) NSDictionary *ortroHeaders;
@property (nonatomic, strong) NSArray *requestFactories;
@property (nonatomic, strong) NSArray *responseFactories;
@property (nonatomic, strong) NSArray *callAdaptorFacroties;
@property (nonatomic, strong) OrtroSessionTaskFactory *taskFactory;
@property (nonatomic, strong) NSNumber *timeOut;

@property (nonatomic, strong) NSMutableDictionary *serviceMethodCache;

@end

@implementation Ortrofit

- (instancetype)init{
    if (self = [super init]) {
        _serviceMethodCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (ConfigSetting)baseURL{
    return ^(NSString *baseURL){
        self.baseUri = baseURL;
        return self;
    };
}

- (ConfigSetting)headers{
    return ^(NSDictionary *headers){
        self.ortroHeaders = headers;
        return self;
    };
}

- (ConfigSetting)requestAdaptorFactories{
    return ^(NSArray<id<ORRequestAdaptorFactoryProtocol>> *adaptorFactories){
        self.requestFactories = adaptorFactories;
        return self;
    };
}

- (ConfigSetting)responseAdaptorFactories{
    return ^(NSArray<id<ORResponseAdaptorFactoryProtocol>> *adaptorFactories){
        self.responseFactories = adaptorFactories;
        return self;
    };
}

- (ConfigSetting)callFactories{
    return ^(NSArray *callFactories){
        self.callAdaptorFacroties = callFactories;
        return self;
    };
}

- (ConfigSetting)sessionTaskFactory{
    return ^(OrtroSessionTaskFactory *taskFactory){
        self.taskFactory = taskFactory;
        return self;
    };
}

- (ConfigSetting)requestTimeOut{
    return ^(NSNumber *time){
        self.timeOut = time;
        return self;
    };
}

- (id)create:(Class)claz{
    @weakify(self);
    return [OrtroProxy newProxyInstance:claz invocationHandler:[[OrInvocationHandler alloc] initWithHandler:^id(ORMethod *method, NSArray *params) {
        @strongify(self);
        OrtroServiceMethod *serviceMethod = [self loadServiceMethod:method];
        OrtroCall *call = [[OrtroCall alloc] initWithServiceMethod:serviceMethod requestParams:params];
        return [serviceMethod adapt:call];
    }]];
}

- (OrtroServiceMethod *)loadServiceMethod:(ORMethod *) method{
    OrtroServiceMethod *serviceMethod = [self.serviceMethodCache objectForKey:method.uniqueKey];
    if (serviceMethod) {
        return serviceMethod;
    }
    @synchronized(self.serviceMethodCache){
        serviceMethod = [self.serviceMethodCache objectForKey:method.uniqueKey];
        if (!serviceMethod) {
            serviceMethod = [[OrtroServiceMethod alloc] initWithOtrofit:self orMethod:method];
            [self.serviceMethodCache setValue:serviceMethod forKey:method.uniqueKey];
        }
    }
    return serviceMethod;
}

- (id)callAdaptor:(Class)returnType annotations:(NSDictionary *)annotations{
    for (OrtroCallAdaptorFactory *adaptorFactory in self.callAdaptorFacroties) {
        OrtroCallAdaptor *callAdaptor = [adaptorFactory getCallAdaptor:returnType annotations:annotations];
        if (callAdaptor) {
            return callAdaptor;
        }
    }
    return nil;
}

@end

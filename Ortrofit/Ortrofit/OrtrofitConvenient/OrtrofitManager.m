//
//  OrtrofitManager.m
//  Cashalo
//
//  Created by mathewwang on 2018/4/9.
//  Copyright © 2018年 oriente. All rights reserved.
//

#import "OrtrofitManager.h"
#import "OrtroSessionTaskFactory.h"
#import "OrtroRACCallAdaptorFactory.h"
#import "AFNetworking.h"

static ORNetworkStatus  networkStatus;

@implementation OrtrofitManager

+ (Ortrofit *)sharedOrtrofit{
    static dispatch_once_t ortrofitToken;
    static Ortrofit *ortrofitInstance = nil;
    dispatch_once(&ortrofitToken, ^{
        ortrofitInstance = Ortrofit.new.baseURL(@"")
                                   .sessionTaskFactory([OrtroSessionTaskFactory new])
                                   .callFactories(@[[OrtroRACCallAdaptorFactory new],
                                                    [OrtroCallAdaptorFactory new]])
                                   .requestTimeOut(@(30.0f));
    });
    return ortrofitInstance;
}

+ (id)serviceInstance:(Class)service{
    return [[OrtrofitManager sharedOrtrofit] create:service];
}

#pragma mark - 检查网络
+ (ORNetworkStatus)networkStatus{
    [self checkNetworkStatus];
    return networkStatus;
}

+ (void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = ORNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = ORNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = ORNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = ORNetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = ORNetworkStatusUnknown;
                break;
        }
        
    }];
}

@end

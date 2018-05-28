//
//  OrtrofitManager.h
//  Cashalo
//
//  Created by mathewwang on 2018/4/9.
//  Copyright © 2018年 oriente. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ortrofit.h"

//快捷方法
#define Ortrofit(claz,instance) claz * instance = [OrtrofitManager serviceInstance:[claz class]]

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, ORNetworkStatus) {
    /**
     *  未知网络
     */
    ORNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    ORNetworkStatusNotReachable        = 1 << 1,
    /**
     *  WWAN网络
     */
    ORNetworkStatusReachableViaWWAN    = 1 << 2,
    /**
     *  WiFi网络
     */
    ORNetworkStatusReachableViaWiFi    = 1 << 3
};

@interface OrtrofitManager : NSObject

+ (Ortrofit *) sharedOrtrofit;

+ (id)serviceInstance:(Class) service;

+ (ORNetworkStatus)networkStatus;

@end

//
//  ORRequestRedirectAdaptorFactory.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/6.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "ORRequestRedirectAdaptorFactory.h"
#import "ORRequestRedirectAdaptor.h"

@implementation ORRequestRedirectAdaptorFactory

- (id<ORRequestAdaptorProtocol>)getAdaptor:(NSURLRequest *)request{
    NSString *requestUrl = [request.URL  absoluteString];
    //TO DO 增加开关判断：如果需要打开https但是目前是http，或者需要打开http但是目前是https的时候需要执行重定向
    if (([requestUrl hasPrefix:@"http://service.cashalo.com"])
        || [requestUrl hasPrefix:@"https://service.cashalo.com"]) {
        return [[ORRequestRedirectAdaptor alloc] init];
    }else{
        return nil;
    }
}

@end

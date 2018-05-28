//
//  ORResponseAdaptorFactory.m
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/28.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import "ORResponseAdaptorFactory.h"
#import "ORResponseAdaptor.h"

@implementation ORResponseAdaptorFactory

- (id<ORResponseAdaptorProtocol>) getAdaptor:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error{
    return [[ORResponseAdaptor alloc] init];
}

@end

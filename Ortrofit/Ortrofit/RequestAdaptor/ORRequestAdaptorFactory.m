//
//  ORRequestAdaptorFactory.m
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/27.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import "ORRequestAdaptorFactory.h"
#import "ORRequestAdaptor.h"

@implementation ORRequestAdaptorFactory

- (id<ORRequestAdaptorProtocol>) getAdaptor:(NSURLRequest *) request{
    return [[ORRequestAdaptor alloc] init];
}

@end

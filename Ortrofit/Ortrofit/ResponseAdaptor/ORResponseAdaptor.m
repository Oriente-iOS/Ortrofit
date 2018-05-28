//
//  ORResponseAdaptor.m
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/28.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import "ORResponseAdaptor.h"

@implementation ORResponseAdaptor

- (id)adapt:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error{
    // as default, nothing to do
    return nil;
}

@end

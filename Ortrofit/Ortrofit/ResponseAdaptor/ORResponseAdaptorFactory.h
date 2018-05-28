//
//  ORResponseAdaptorFactory.h
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/28.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORResponseAdaptorProtocol;
@class ORResponseAdaptor;

@protocol ORResponseAdaptorFactoryProtocol<NSObject>

/*
 *
 */
- (id<ORResponseAdaptorProtocol>) getAdaptor:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error;

@end

@interface ORResponseAdaptorFactory : NSObject<ORResponseAdaptorFactoryProtocol>

@end

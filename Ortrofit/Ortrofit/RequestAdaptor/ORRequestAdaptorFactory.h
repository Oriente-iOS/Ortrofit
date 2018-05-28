//
//  ORRequestAdaptorFactory.h
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/27.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORRequestAdaptorProtocol;
@class ServiceMethodModel;


@protocol ORRequestAdaptorFactoryProtocol<NSObject>

/*
 *
 */
- (id<ORRequestAdaptorProtocol>) getAdaptor:(NSURLRequest *) request;

@end

@interface ORRequestAdaptorFactory : NSObject<ORRequestAdaptorFactoryProtocol>


@end

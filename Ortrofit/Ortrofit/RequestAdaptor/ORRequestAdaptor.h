//
//  ORRequestAdaptor.h
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/27.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORRequestAdaptorProtocol<NSObject>

/*
 *
 */
- (NSURLRequest *) adapt:(NSURLRequest *) request;

@end

@interface ORRequestAdaptor : NSObject<ORRequestAdaptorProtocol>


@end

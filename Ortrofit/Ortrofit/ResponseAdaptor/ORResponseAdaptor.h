//
//  ORResponseAdaptor.h
//  OrientNetworking
//
//  Created by mathewwang on 2018/3/28.
//  Copyright © 2018年 mathewwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORResponseAdaptorProtocol<NSObject>

/*
 *
 */
- (id)adapt:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error;

@end

@interface ORResponseAdaptor : NSObject<ORResponseAdaptorProtocol>

@end

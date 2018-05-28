//
//  OrInvocationHandler.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrtroProxy;
@class ORMethod;


typedef id(^InvacationHandler)(ORMethod *method, NSArray *params);

@interface OrInvocationHandler : NSObject

@property (nonatomic, strong, readonly) InvacationHandler invocationHandler;

/*
 *
 */
- (instancetype)initWithHandler:(InvacationHandler) handler;

/*
 *
 */
- (void)invokeWith:(ORMethod *) method params:(NSArray *) params result:(NSObject **) result;

@end

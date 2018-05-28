//
//  OrInvocationHandler.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrInvocationHandler.h"

@interface OrInvocationHandler()

@property (nonatomic, strong) InvacationHandler invocationHandler;

@end

@implementation OrInvocationHandler

- (instancetype)initWithHandler:(InvacationHandler)handler{
    if (self = [super init]) {
        _invocationHandler = handler;
    }
    return self;
}

- (void)invokeWith:(ORMethod *) method params:(NSArray *) params result:(NSObject **)result{
    if (self.invocationHandler) {
        *result = self.invocationHandler(method, params);
    }
//    return nil;
}

@end

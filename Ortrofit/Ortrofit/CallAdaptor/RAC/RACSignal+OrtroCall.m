//
//  RACSignal+OrtroCall.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/9.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "RACSignal+OrtroCall.h"
#import <objc/runtime.h>

@implementation RACSignal (OrtroCall)

@dynamic ortroCall;

- (OrtroCall *)ortroCall{
    return  objc_getAssociatedObject(self, @selector(ortroCall));
}

- (void)setOrtroCall:(OrtroCall *)ortroCall{
    objc_setAssociatedObject(self, @selector(ortroCall), ortroCall, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

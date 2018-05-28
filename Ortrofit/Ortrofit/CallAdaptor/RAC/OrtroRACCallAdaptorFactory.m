//
//  OrtroRACCallAdaptorFactory.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroRACCallAdaptorFactory.h"
#import "ReactiveCocoa.h"
#import "OrtroRACCallAdaptor.h"

@implementation OrtroRACCallAdaptorFactory

- (id)getCallAdaptor:(Class)returnType annotations:(NSDictionary *)annotations{
    if ([returnType isEqual:[RACSignal class]] ||
        [returnType isSubclassOfClass:[RACSignal class]]) {
        return [OrtroRACCallAdaptor new];
    }
    return nil;
}

@end

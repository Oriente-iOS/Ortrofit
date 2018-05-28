//
//  OrtroCallAdaptorFactory.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroCallAdaptorFactory.h"
#import "OrtroCallAdaptor.h"
#import "OrtroCall.h"

@implementation OrtroCallAdaptorFactory

- (id)getCallAdaptor:(Class)returnType annotations:(NSDictionary *) annotations{
    if ([returnType isEqual:[OrtroCall class]] ||
        [returnType isSubclassOfClass:[OrtroCall class]]) {
        return [OrtroCallAdaptor new];
    }
    return nil;
}

@end

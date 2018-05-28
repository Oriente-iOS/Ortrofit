//
//  OrtroRACCallAdaptor.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroRACCallAdaptor.h"
#import "ReactiveCocoa.h"
#import <objc/runtime.h>
#import "RACSignal+OrtroCall.h"

@implementation OrtroRACCallAdaptor

- (id)adapt:(OrtroCall *)call{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [call enqueue:^(NSURLResponse *urlResponse, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLResponse *urlResponse, id responseObject, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [call cancel];
        }];
    }];
    //将Call绑到signal上面，方便后面取值
    signal.ortroCall = call;
    
    return signal;
}

@end

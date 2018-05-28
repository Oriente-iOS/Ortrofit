//
//  OrtroProxy.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrInvocationHandler;


@interface OrtroProxy : NSObject

/*
 *
 */
+ (id)newProxyInstance:(Class) serviceClaz
     invocationHandler:(OrInvocationHandler *) invocationHandler;

@end

//
//  OrtroCall.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/4.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrtroMacro.h"
#import "OrtroCallSignature.h"

@class OrtroServiceMethod;

@interface OrtroCall : NSObject

@property (nonatomic, weak, readonly) NSURLSessionTask *sessionTask;
@property (nonatomic, strong, readonly) OrtroCallSignature *callSignature;

/*
 *
 */
- (instancetype)initWithServiceMethod:(OrtroServiceMethod *) serviceMethod
                        requestParams:(NSArray *) params;

/*
 *
 */
- (void)enqueue:(ServiceSuccess) success
        failure:(ServiceFailure) failure;

/*
 *
 */
- (void)cancel;

/*
 *
 */
- (OrtroCallSignature *)callSignature;

@end

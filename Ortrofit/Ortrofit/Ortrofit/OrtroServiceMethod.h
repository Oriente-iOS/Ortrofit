//
//  OrtroServiceMethod.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrtroMicro.h"
#import "OrtroPath.h"

@class Ortrofit;
@class ORMethod;
@class OrtroCall;

@interface OrtroServiceMethod : NSObject
@property (nonatomic, copy, readonly) NSString *baseUrl;
@property (nonatomic, strong, readonly) OrtroPath *path;
@property (nonatomic, copy, readonly) NSString *httpMethod;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSArray *paramKeys;

/*
 *
 */
- (instancetype)initWithOtrofit:(Ortrofit *) ortrofit
                       orMethod:(ORMethod *) orMethod;

/*
 *
 */
- (NSURLSessionTask *)toTask:(NSArray *) requestParameterValues
              serviceSuccess:(ServiceSuccess) success
              serviceFailure:(ServiceFailure) failure;

/*
 *
 */
- (id)adapt:(OrtroCall *)ortroCall;

/*
 *
 */
- (id)adaptResponse:(NSURLSessionTask *) sessionTask responseObject:(id) responseObject error:(NSError *) error;

@end

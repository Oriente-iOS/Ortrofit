//
//  OrtroServiceCallFactory.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrtroMacro.h"

@class AFURLSessionManager;

@interface OrtroSessionTaskFactory : NSObject

@property (nonatomic, strong, readonly) AFURLSessionManager *sessionManager;

/*
 *
 */
- (NSURLSessionTask *) generateTask:(NSURLRequest *) request
                            success:(ServiceSuccess) success
                            failure:(ServiceFailure) failure;

@end

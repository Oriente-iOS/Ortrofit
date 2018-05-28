//
//  OrtroServiceCallFactory.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrtroMicro.h"

@interface OrtroSessionTaskFactory : NSObject

/*
 *
 */
- (NSURLSessionTask *) generateTask:(NSURLRequest *) request
                            success:(ServiceSuccess) success
                            failure:(ServiceFailure) failure;

@end

//
//  OrtroServiceMethod+ParamHandler.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroServiceMethod.h"

@interface OrtroServiceMethod (ParamHandler)

- (NSString *)renderPath:(NSArray *) paramValues;

- (NSDictionary *)parseRequestParams:(NSArray *) paramValues;

@end

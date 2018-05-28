//
//  OrtroServiceMethod+ParamHandler.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroServiceMethod+ParamHandler.h"

@implementation OrtroServiceMethod (ParamHandler)

- (NSString *)renderPath:(NSArray *) paramValues{
    NSString *realPath = self.path.pathStr;
    for (NSString *comp in [self.path parseParams]) {
        if ([self.paramKeys containsObject:comp]) {
            NSInteger index = [self.paramKeys indexOfObject:comp];
            if (index < paramValues.count) {
                NSString *value = [paramValues objectAtIndex:index];
                if ([value isKindOfClass:[NSNull class]]) {
                    realPath = [realPath stringByReplacingOccurrencesOfString:comp withString:@""];
                }else{
                    realPath = [realPath stringByReplacingOccurrencesOfString:comp withString:value?:@""];
                }
            }else{
                realPath = [realPath stringByReplacingOccurrencesOfString:comp withString:@""];
            }
        }
    }
    return realPath;
}

- (NSDictionary *)parseRequestParams:(NSArray *)paramValues{
    NSMutableDictionary *mParams = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.paramKeys.count; i++) {
        NSString *key = [self.paramKeys objectAtIndex:i];
        if (i < paramValues.count) {
            NSObject *value = paramValues[i];
            //判断是否是NSDictionary类型
            if ([key hasPrefix:@"ortro_param_map_"] &&
                ([value isKindOfClass:[NSDictionary class]] || [value isMemberOfClass:[NSDictionary class]])) {
                for (NSString *key in (NSDictionary *)value) {
                    [mParams setValue:[(NSDictionary *)value objectForKey:key] forKey:key];
                }
            }else{
                if (![paramValues[i] isKindOfClass:[NSNull class]] &&
                    ![key hasPrefix:@"{"]) { //过滤掉Path参数
                    [mParams setValue:paramValues[i] forKey:key];
                }
            }
        }else{
            break;
        }
    }
    return [mParams copy];
}

@end

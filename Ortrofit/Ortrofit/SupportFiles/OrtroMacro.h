//
//  OrtroMacro.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroPath.h"

#ifndef OrtroMacro_h
#define OrtroMacro_h

typedef void(^ServiceSuccess)(NSURLResponse * urlResponse, id responseObject);
typedef void(^ServiceFailure)(NSURLResponse * urlResponse, id responseObject, NSError *error);

#define kHttpMethod @"method"
#define kHttpPath @"path"
#define kHttpParamsKey @"requestParams"
#define kHttpHeaders @"requestHeaders"
#define kReturnType @"returnType"

#if DEBUG
#define ortro_keywordify autoreleasepool {}
#else
#define ortro_keywordify try {} @catch (...) {}
#endif

#define ortro_concat(a,b) __CONCAT(a,b)

#define BEGIN \
NSMutableDictionary *apiParams = [NSMutableDictionary dictionary]; \
NSMutableArray *requestParams = [NSMutableArray array]; \
NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary]; \

#define END \
[apiParams setValue:requestParams forKey:kHttpParamsKey]; \
[apiParams setValue:requestHeaders forKey:kHttpHeaders]; \
return [apiParams copy]; \

#define ReturnType(type) \
ortro_keywordify \
[apiParams setValue:@__STRING(type) forKey:kReturnType];

#define Method(type) \
ortro_keywordify \
[apiParams setValue:@__STRING(type) forKey:kHttpMethod];

#define Path(path) \
ortro_keywordify \
OrtroPath *orPath = [[OrtroPath alloc] initWithPath:@__STRING(path)]; \
[apiParams setValue:orPath forKey:kHttpPath]; \
for (NSString *comp in [orPath parseParams]) { \
    [requestParams addObject:comp];\
} \

#define ParameterMap(paramName) \
ortro_keywordify \
[requestParams addObject:[NSString stringWithFormat:@"ortro_param_map_%@",@__STRING(paramName)]];

#define ParameterName(paramName) \
ortro_keywordify \
[requestParams addObject:@__STRING(paramName)];

#define Header(key,value) \
ortro_keywordify \
[requestHeaders setValue:@__STRING(value) forKey:@__STRING(key)]; \

#define EXPORT_API(selName) \
class Ortrofit; \
+(NSDictionary *)ortro_concat(ortro_concat(ortro_api_,selName),__LINE__) \

#endif /* OrtroMacro_h */

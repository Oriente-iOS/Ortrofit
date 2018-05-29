//
//  ORMethod.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AnalyzeType) {
    AnalyzeTypeAnnatations = 0,
    AnalyzeTypeParameterAnnatation,
    AnalyzeTypeParameterType,
};

@interface ORMethod : NSObject

@property (nonatomic, strong, readonly) Class declareClaz;
@property (nonatomic, strong, readonly) NSString *selector;

- (instancetype)initWitClaz:(Class) claz selectorStr:(NSString *) selectorStr;

/*
 *
 */
- (NSString *)uniqueKey;

/*
 *
 */
- (NSDictionary *)getAnnotations;

/*
 *
 */
- (NSArray *)getGenericParameterTypes;

/*
 *
 */
- (NSArray *)getParameterAnnotations;

@end

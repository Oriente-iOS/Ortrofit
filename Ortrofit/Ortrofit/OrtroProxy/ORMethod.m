//
//  ORMethod.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "ORMethod.h"
#import <objc/runtime.h>
#import "OrtroMacro.h"

@interface ORMethod()

@property (nonatomic, strong) Class declareClaz;
@property (nonatomic, strong) NSString *selector;
@property (nonatomic, strong) NSMethodSignature *methodSignature;

@end

@implementation ORMethod

- (instancetype)initWitClaz:(Class)claz selectorStr:(NSString *)selectorStr{
    if (self = [super init]) {
        _declareClaz = claz;
        _selector = selectorStr;
    }
    [self analyzeMethodAnnotation:0];
    return self;
}

- (NSString *)uniqueKey{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(self.declareClaz),self.selector];
}

- (NSDictionary *)getAnnotations{
    return [self analyzeMethodAnnotation:AnalyzeTypeAnnatations];
}

- (NSArray *)getParameterAnnotations{
    return [self analyzeMethodAnnotation:AnalyzeTypeParameterAnnatation];
}

- (NSArray *)getGenericParameterTypes{
    return [self analyzeMethodAnnotation:AnalyzeTypeParameterType];
}

#pragma mark PrivateMethod
- (id)analyzeMethodAnnotation:(AnalyzeType) analyzeType{
    NSDictionary *apiAnnotations = nil;
    NSString *ortroSelStr = [NSString stringWithFormat:@"ortro_api_%@",[self.selector stringByReplacingOccurrencesOfString:@":" withString:@"_"]];
    unsigned int clazMethodCount;
    Method *clazMethodList = class_copyMethodList(object_getClass(self.declareClaz), &clazMethodCount);
    for (int i = 0; i < clazMethodCount; i++) {
        Method clazMethod = clazMethodList[i];
        NSString *clazMethodStr = NSStringFromSelector(method_getName(clazMethod));
        if ([clazMethodStr hasPrefix:ortroSelStr]
            && [self isPureNumber:[clazMethodStr substringFromIndex:ortroSelStr.length]]) {
            SEL selector = NSSelectorFromString(clazMethodStr);
            if ([self.declareClaz respondsToSelector: selector]) {
                apiAnnotations  = ((NSDictionary*(*)(id, SEL))[self.declareClaz methodForSelector:selector])(self.declareClaz,selector);
            }
            break;
        }
    }
    free(clazMethodList);
    switch (analyzeType) {
        case AnalyzeTypeAnnatations:{
            NSMutableDictionary *mAnnotations = apiAnnotations.mutableCopy;
            [mAnnotations removeObjectForKey:kHttpParamsKey];
            return [mAnnotations copy];
        }
            break;
        case AnalyzeTypeParameterType:{
            //TO DO
        }
            break;
        case AnalyzeTypeParameterAnnatation:{
            return [apiAnnotations objectForKey:kHttpParamsKey];
        }
            break;
    }
    return nil;
}

- (BOOL) isPureNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

@end

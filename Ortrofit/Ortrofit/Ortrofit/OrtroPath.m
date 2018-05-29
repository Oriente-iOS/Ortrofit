//
//  OrtroPath.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/19.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroPath.h"

@interface OrtroPath()

@property (nonatomic, strong) NSString *pathStr;

@end

@implementation OrtroPath

- (instancetype)initWithPath:(NSString *)path{
    if (self = [super init]) {
        _pathStr = path;
    }
    return self;
}

- (NSArray *)parseParams{
    NSMutableArray *values = [NSMutableArray array];
    if ([self.pathStr containsString:@"{"]) {
        NSMutableString *numberString = [[NSMutableString alloc] init];
        NSScanner *scanner = [NSScanner scannerWithString:self.pathStr?:@""];
        NSCharacterSet *tokens = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
        NSString *valueStr = nil;
        NSString *tokenStr = nil;
        while (![scanner isAtEnd]) {
            [scanner scanUpToCharactersFromSet:tokens intoString:&valueStr];
            [scanner scanCharactersFromSet:tokens intoString:&tokenStr];
            if ([tokenStr isEqualToString:@"{"]) {
                numberString = @"".mutableCopy;
                [numberString appendString:tokenStr];
            }else if ([tokenStr isEqualToString:@"}"] &&
                      [numberString isEqualToString:@"{"]){
                [numberString appendString:valueStr];
                [numberString appendString:tokenStr];
                [values addObject:numberString];
            }
            tokenStr = @"";
            valueStr = @"";
        }
    }
    return values.copy;
}

@end

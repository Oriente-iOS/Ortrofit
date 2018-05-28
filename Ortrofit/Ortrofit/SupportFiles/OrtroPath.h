//
//  OrtroPath.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/19.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrtroPath : NSObject

@property (nonatomic, strong, readonly) NSString *pathStr;

- (instancetype)initWithPath:(NSString *)path;

- (NSArray *)parseParams;

@end

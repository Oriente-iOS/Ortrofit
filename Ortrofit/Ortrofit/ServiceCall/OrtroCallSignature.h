//
//  OrtroCallSignature.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/13.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrtroCallSignature : NSObject

//completed url of current request
@property (nonatomic, copy) NSString *url;

//method of current request
@property (nonatomic, copy) NSString *method;

//header of current request
@property (nonatomic, strong) NSDictionary *headers;

//params of current request
@property (nonatomic, strong) NSDictionary *params;

@end

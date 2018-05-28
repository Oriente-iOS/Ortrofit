//
//  ORRequestRedirectAdaptor.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/6.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "ORRequestRedirectAdaptor.h"

@implementation ORRequestRedirectAdaptor

- (NSURLRequest *)adapt:(NSURLRequest *)request{
    NSString *originUrl = [request.URL absoluteString];
    NSMutableURLRequest *mRequest = request.mutableCopy;
    //如果是https则改成http
    if ([originUrl hasPrefix:@"https://"]) {
        [mRequest setURL:[NSURL URLWithString:[originUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"]]];
    //如果是http则改成https
    }else if ([originUrl hasPrefix:@"http://"]){
        [mRequest setURL:[NSURL URLWithString:[originUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]]];
    }
    return [mRequest copy];
}

@end

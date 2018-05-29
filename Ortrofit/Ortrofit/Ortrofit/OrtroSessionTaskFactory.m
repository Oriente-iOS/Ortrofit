//
//  OrtroServiceCallFactory.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroSessionTaskFactory.h"
#import "AFNetworking.h"


@interface OrtroSessionTaskFactory()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation OrtroSessionTaskFactory

- (instancetype)init{
    if (self = [super init]) {
        _sessionManager = [[AFURLSessionManager alloc] init];
    }
    return self;
}

- (NSURLSessionTask *) generateTask:(NSURLRequest *) request
                            success:(ServiceSuccess) success
                            failure:(ServiceFailure) failure{
    
    return [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                          if (error) {
                                              if (failure) {
                                                  failure(response,responseObject, error);
                                              }
                                          } else {
                                              if (success) {
                                                  success(response,responseObject);
                                              }
                                          }
                                      }];
}

@end

//
//  OrtroCallAdaptorFactory.h
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "ORRequestAdaptor.h"

@interface OrtroCallAdaptorFactory : NSObject

/*
 *
 */
- (id)getCallAdaptor:(Class) returnType
         annotations:(NSDictionary *) annotations;

@end

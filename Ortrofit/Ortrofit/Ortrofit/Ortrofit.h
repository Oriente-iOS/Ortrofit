//
// Ortrofit.h
//
//  Copyright © 2018年 Oriente. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@protocol ORRequestAdaptorFactoryProtocol;
@protocol ORResponseAdaptorFactoryProtocol;
@class Ortrofit;
@class OrtroSessionTaskFactory;

/*
 * 定义一个ConfigSetting类型的block，用户进行相关网络参数的配置，返回类型为Ortrofit自身以此便
 * 于链式的方式进行配置
 */
typedef Ortrofit*(^ConfigSetting)(id param);


/**
 Ortrofit的核心类，建议该类的实例个数与工程的Domain个数相同，如果整个App只有一个Dmain，那么只
 需要实例化一个Ortrofit实例。
 */
@interface Ortrofit : NSObject

/**
 全局的公共请求链接，通常是请求的URL的Domain部分，如：http://xxx.xxx.xxx/
 */
@property (nonatomic, copy, readonly) NSString *baseUri;
@property (nonatomic, strong ,readonly) NSDictionary *ortroHeaders;
@property (nonatomic, copy ,readonly) NSDictionary*(^ortroDynamicHeaders)(void);
@property (nonatomic, strong, readonly) NSArray *requestFactories;
@property (nonatomic, strong, readonly) NSArray *responseFactories;
@property (nonatomic, strong, readonly) NSArray *callAdaptorFacroties;
@property (nonatomic, strong, readonly) NSNumber *timeOut;
@property (nonatomic, strong, readonly) OrtroSessionTaskFactory *taskFactory;

/*
 *全局公共请求链接配置函数
 */
- (ConfigSetting)baseURL;

/*
 *该方法可以配置公共的请求头信息
 */
- (ConfigSetting)headers;
/*
 *
 */

- (Ortrofit*(^)(NSDictionary*(^)(void)))dynamicHeaders;

/*
 *
 */
- (ConfigSetting)requestAdaptorFactories;

/*
 *
 */
- (ConfigSetting)responseAdaptorFactories;

/*
 *
 */
- (ConfigSetting)sessionTaskFactory;

/*
 *
 */
- (ConfigSetting)callFactories;

/*
 *
 */
- (ConfigSetting)requestTimeOut;

/*
 *
 *
 */
- (id)callAdaptor:(Class) returnType
      annotations:(NSDictionary *) annotations;

/*
 *
 */
- (id)create:(Class) claz;


@end

# Ortrofit
A convenient network API framework based on AFNetworking

## 介绍
**Ortrofit**是一款在**AFNetworking**前端网络网络框架的基础之上封装出来的一套新的网络API框架。它的主要思想源于安卓的基于**OkHttp**封装出来的**Retrofit**，因此取名为**Ortrofit**也是为了向其致敬。**Ortrofit**旨在使用Annotation的方式简洁的描述一个网络请求的API，并在Request和Response中实现自定义的APO拦截，同时也增加了对于RAC的支持。
## 依赖 
* pod 'AFNetworking', '3.1.0' 
* pod 'ReactiveCocoa', '2.5'

## 开始

#### 创建并配置一个Ortrofit
```objective-c
      Ortrofit *ortrofitInstance = Ortrofit.new.baseURL(@"https://oriente.com/")
                                   .sessionTaskFactory([OrtroSessionTaskFactory new])
                                   .callFactories(@[[OrtroRACCallAdaptorFactory new],
                                                    [OrtroCallAdaptorFactory new]])
                                   .headers(@{@"mobile-agent":@"xxx"})
                                   .requestTimeOut(@(30.0f));
```
通过上面👆代码可以创建一个**Ortrofit**并进行了常规的配置, 建议业务使用时只需要一个 **Ortrofit** 实例。

* **baseURL:** 网络请求连接中前面相同的部分可以提前配置，后面的请求API只需要配置Path即可。
* **OrtroSessionTaskFactory:** 工厂方法，可以被业务层继承并复写，默认返回一个**NSURLSessionTask**的实例。
* **OrtroRACCallAdaptorFactory:** 工厂方法，继承自**OrtroCallAdaptorFactory**在其 *-(id)adapt:* 方法内包装了**OrtroCall**并返回了**RACSignal**实例。
* **OrtroCallAdaptorFactory:** **OrtroCall**的默认工厂方法，接受**OrtroCall** 实例并直接返回不作处理。

#### 网络服务定义
```objective-c
@class RACSignal;
@class OrtroCall;

@interface UserService : NSObject

- (RACSignal*)getUserInfo:(NSString *) idNO;
- (OrtroCall*)setUserInfo:(NSString *) phoneNO name:(NSString *) name;

@end

#import "OrtroMicro.h"

@implementation UserService

@EXPORT_API(getUserInfo_){
    BEGIN
    @ReturnType(RACSignal)
    @Method(GET)
    @Path(user/getuserinfo)
    @ParameterName(idNO)
    END
}
- (RACSignal*)getUserInfo:(NSString *)idNO{ return nil; }

@EXPORT_API(setUserInfo_name_){
    BEGIN
    @ReturnType(OrtroCall)
    @Method(POST)
    @Path(user/setuserinfo)
    @ParameterName(phoneNO)
    @ParameterName(name)
    END
}
- (OrtroCall*)setUserInfo:(NSString *)phoneNO name:(NSString *)name { return nil; }

@end

```
上面代码创建了一个UserService的服务类，里面包含了根据用户id获取用户信息和设置用户信息两个接口，第一个接口返回一个**RACSignal**实例,第二个接口返回**OrtroCall**实例。

* **@EXPORT_API:** 必须添加，根据传人的方法名参数定位这些配置参数是应用到具体哪一个网络请求API，参数名就是API的SEL名并把":"替换成"_"。
* **BEGIN / END:** 必须添加，表示API描述的开始和结束。
* **@ReturnType:** 必须添加(除：OrtroCall)，表示API返回的类型。
* **@Method:** 必须添加，网络请求的类型，如：GET、POST。
* **@Path:** 必须添加，网络请求的Path路径。
* **@ParameterName:** 如果有参数必须添加，网络请求的参数名称定义，与API的入参顺序一致。

#### 更多支持
* **@Path**

除了支持常规的url外，还支持路径上参数{xxx}的解析，如：

```objective-c
@Path(user/{phoneNO}/getuserinfo)

```
请求路径上面的参数会和 **@ParameterName**一起排序后与API的请求参数值进行合并。

* **@Header** 

对于单个请求需要设置特殊的请求头信息也是可以支持的，如：

```objective-c
@Header(@"language":@"CN")
```
#### 网络服务调用
业务场景中进行网络服务调用无需再去记住各式各样的Path，拼装各种参数，只需要知道需要调用某个服务的某个API即可直接调用,如：

```objective-c
//RAC 调用的例子
    UserService *user = [ortrofit create:[UserService class]];
    [user getUserInfo:@"1234"] subscribeNext:^(id x) {
        NSLog(@"success");
    }];

//常规 调用的例子
    UserService *user = [ortrofit create:[UserService class]];
    OrtroCall *call = [user setUserInfo:@"1234567" name:@"mathew"];
    [call enqueue:^(NSURLResponse *urlResponse, id responseObject) {
 			NSLog(@"success");
	} failure:^(NSURLResponse *urlResponse, id responseObject, NSError *error) {
			NSLog(@"failure");
	}];
	
```

//
//  OrtroProxy.m
//  OrienteUtility
//
//  Created by mathewwang on 2018/4/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "OrtroProxy.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "OrInvocationHandler.h"
#import "ORMethod.h"

static NSString *const OrtroProxySubclassSuffix = @"_ortro_proxy_";
static NSString *const OrtroProxyMessagePrefix = @"ortro_proxy_";
static NSMutableDictionary *invocationHandlerCache;

@implementation OrtroProxy

+ (id)newProxyInstance:(Class)serviceClaz invocationHandler:(OrInvocationHandler *)invocationHandler{
    __block id serviceInstance = nil;
    _ortro_swizzledClasses(^(NSMutableDictionary *ortroSwizzledClasses) {
        if ([ortroSwizzledClasses objectForKey:NSStringFromClass(serviceClaz)]) {
            serviceInstance = [ortroSwizzledClasses objectForKey:NSStringFromClass(serviceClaz)];
        }else{
            serviceInstance = [[serviceClaz alloc] init];
            [ortroSwizzledClasses setValue:serviceInstance forKey:NSStringFromClass(serviceClaz)];
            unsigned int num;
            Method *methodList = class_copyMethodList(serviceClaz, &num);
            for (int i = 0; i < num; i++) {
                Method method = methodList[i];
                SEL selName = method_getName(method);
                ortro_add(serviceInstance,selName,invocationHandler,nil);
            }
            free(methodList);
        }
    });
    return serviceInstance;
}

static void ortro_add(id self, SEL selector, OrInvocationHandler *invocationHandler, NSError **error) {
    NSCParameterAssert(self);
    NSCParameterAssert(selector);
    NSCParameterAssert(invocationHandler);
    
    aspect_performLocked(^{
        ortro_cacheInvacationHanler(self, invocationHandler);
        // Modify the class to allow message interception.
        ortro_prepareClassAndHookSelector(self, selector, nil);
    });
}

static void ortro_cacheInvacationHanler(NSObject *obj, OrInvocationHandler *invocationHandler){
    static dispatch_once_t invocationToken;
    dispatch_once(&invocationToken, ^{
        invocationHandlerCache = [NSMutableDictionary dictionary];
    });
    if (![invocationHandlerCache objectForKey:NSStringFromClass([obj class])]) {
        [invocationHandlerCache setObject:invocationHandler forKey:NSStringFromClass([obj class])];
    }
}

static void aspect_performLocked(dispatch_block_t block) {
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}

static void ortro_prepareClassAndHookSelector(NSObject *self, SEL selector, NSError **error) {
    NSCParameterAssert(selector);
    Class klass = ortro_hookClass(self, error);
    Method targetMethod = class_getInstanceMethod(klass, selector);
    IMP targetMethodIMP = method_getImplementation(targetMethod);
    if (!ortro_isMsgForwardIMP(targetMethodIMP)) {
        // Make a method alias for the existing method implementation, it not already copied.
        const char *typeEncoding = method_getTypeEncoding(targetMethod);
        SEL aliasSelector = ortro_aliasForSelector(selector);
        if (![klass instancesRespondToSelector:aliasSelector]) {
            __unused BOOL addedAlias = class_addMethod(klass, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
            NSCAssert(addedAlias, @"Original implementation for %@ is already copied to %@ on %@", NSStringFromSelector(selector), NSStringFromSelector(aliasSelector), klass);
        }
        // We use forwardInvocation to hook in.
        class_replaceMethod(klass, selector, ortro_getMsgForwardIMP(self, selector), typeEncoding);
    }
}

static SEL ortro_aliasForSelector(SEL selector) {
    NSCParameterAssert(selector);
    return NSSelectorFromString([OrtroProxyMessagePrefix stringByAppendingFormat:@"_%@", NSStringFromSelector(selector)]);
}

static Class ortro_hookClass(NSObject *self, NSError **error) {
    NSCParameterAssert(self);
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);
    NSString *className = NSStringFromClass(baseClass);
    
    // Already subclassed
    if ([className hasSuffix:OrtroProxySubclassSuffix]) {
        return baseClass;
    }
    const char *subclassName = [className stringByAppendingString:OrtroProxySubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        if (subclass != nil) {
            ortro_swizzleForwardInvocation(subclass);
            ortro_hookedGetClass(subclass, statedClass);
            ortro_hookedGetClass(object_getClass(subclass), statedClass);
            objc_registerClassPair(subclass);
            
            object_setClass(self, subclass);
        }
    }
    return subclass;
}

static void ortro_hookedGetClass(Class class, Class statedClass) {
    NSCParameterAssert(class);
    NSCParameterAssert(statedClass);
    Method method = class_getInstanceMethod(class, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, @selector(class), newIMP, method_getTypeEncoding(method));
}

static NSString *const OrtroProxyForwardInvocationSelectorName = @"__ortro_proxy_forwardInvocation:";
static void ortro_swizzleForwardInvocation(Class klass) {
    NSCParameterAssert(klass);
    // If there is no method, replace will act like class_addMethod.
    class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__PROXY_ARE_BEING_CALLED__, "v@:@");
}

static void __PROXY_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSCParameterAssert(self);
    NSCParameterAssert(invocation);
    ORMethod *realMethod = [[ORMethod alloc] initWitClaz:[invocation.target class] selectorStr:NSStringFromSelector(invocation.selector)];
    OrInvocationHandler *invacationHandler = [invocationHandlerCache objectForKey:NSStringFromClass([invocation.target class])];
    //解析参数值
    NSMutableArray *parameterValues = [NSMutableArray array];
    Method method  = class_getInstanceMethod([self class], invocation.selector);
    NSMethodSignature *methodSignature =[NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
    for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
        id __unsafe_unretained value;//!!!
        [invocation getArgument:&value atIndex:i];
        [parameterValues addObject:value?:[NSNull null]];
    }
    
    id  ret = nil;
    [invacationHandler invokeWith:realMethod params:[parameterValues copy] result:&ret];
    id __autoreleasing newRet = ret;
    [invocation setReturnValue:&newRet];
    [invocation retainArguments];
}

static void _ortro_swizzledClasses(void (^block)(NSMutableDictionary *ortroSwizzledClasses)) {
    static NSMutableDictionary *ortroSwizzledClasses;
    static dispatch_once_t ortro_pred;
    dispatch_once(&ortro_pred, ^{
        ortroSwizzledClasses = [NSMutableDictionary dictionary];
    });
    @synchronized(ortroSwizzledClasses) {
        block(ortroSwizzledClasses);
    }
}

static BOOL ortro_isMsgForwardIMP(IMP impl) {
    return impl == _objc_msgForward
#if !defined(__arm64__)
    || impl == (IMP)_objc_msgForward_stret
#endif
    ;
}

static IMP ortro_getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

@end

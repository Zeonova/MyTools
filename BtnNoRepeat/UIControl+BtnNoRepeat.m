//
//  UIControl+BtnNoRepeat.m
//  TestRuntime
//
//  Created by 疯兔 on 15/9/23.
//  Copyright © 2015年 DYW. All rights reserved.
//

#import "UIControl+BtnNoRepeat.h"
#import <objc/runtime.h>

@implementation UIControl (BtnNoRepeat)
//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成。
@dynamic amc_acceptEventInerval;
@dynamic amc_ignoreEvent;
//运行时关联对象

static char kAcceptEventInervalKey;
static char kIgnoreEventKey;

-(NSTimeInterval)amc_acceptEventInerval
{
    return [objc_getAssociatedObject(self, &kAcceptEventInervalKey) doubleValue];
}
-(void)setAmc_acceptEventInerval:(NSTimeInterval)amc_acceptEventInerval
{
    objc_setAssociatedObject(self, &kAcceptEventInervalKey, @(amc_acceptEventInerval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)amc_ignoreEvent
{
    return [objc_getAssociatedObject(self, &kIgnoreEventKey) boolValue];
}
-(void)setAmc_ignoreEvent:(BOOL)amc_ignoreEvent
{
    objc_setAssociatedObject(self, &kIgnoreEventKey, @(amc_ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}
//启动时交换实现方法
+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__amc_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}
- (void)__amc_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.amc_ignoreEvent) return;
    if (self.amc_acceptEventInerval > 0)
    {
        self.amc_ignoreEvent = YES;
        [self performSelector:@selector(setAmc_ignoreEvent:) withObject:@(NO) afterDelay:self.amc_acceptEventInerval];
    }
    [self __amc_sendAction:action to:target forEvent:event];//这里不是循环，而是调用了sendAction:to:forEvent:，原始的方法
}
@end
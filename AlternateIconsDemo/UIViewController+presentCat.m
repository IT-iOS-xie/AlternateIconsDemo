//
//  UIViewController+presentCat.m
//  AlternateIconsDemo
//
//  Created by xie on 2017/12/28.
//  Copyright © 2017年 ryan. All rights reserved.
//

#import "UIViewController+presentCat.h"
#import  <objc/runtime.h>
@implementation UIViewController (presentCat)






+(void)load{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(xjw_presentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)xjw_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {// 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self xjw_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self xjw_presentViewController:viewControllerToPresent animated:flag completion:completion];
}
@end

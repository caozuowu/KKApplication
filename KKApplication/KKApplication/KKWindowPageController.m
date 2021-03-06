//
//  KKWindowPageController.m
//  KKApplication
//
//  Created by hailong11 on 2017/12/31.
//  Copyright © 2017年 kkmofang.cn. All rights reserved.
//

#import "KKWindowPageController.h"
#include <objc/runtime.h>

@implementation KKWindowPageController

@synthesize action = _action;

-(void) setAction:(NSDictionary *)action {
    _action = action;
    self.path = [action kk_getString:@"path"];
    self.query = [action kk_getValue:@"query"];
}

-(void) showInView:(UIView *) view {
    
    [self run];

    [self.element layout:view.bounds.size];
    [self.element obtainView:view];
    
    objc_setAssociatedObject(self.element.view, "_KKWindowPageController", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    {
        //更新布局
        __weak KKWindowPageController * v = self;
        __weak UIView * vv = view;
        
        [self.observer on:^(id value, NSArray *changedKeys, void *context) {
            
            if(v && vv) {
                
                if([changedKeys count] ==0 ||
                   [[v elementNeedsLayoutDataKeys] containsObject:changedKeys[0]]) {
                    
                    [v.element layout:vv.bounds.size];
                    [v.element obtainView:vv];
                }
                
            }
            
        } keys:@[] children:true priority:KKOBSERVER_PRIORITY_LOW context:nil];
        
        [self.observer on:^(id value, NSArray *changedKeys, void *context) {
            
            if(v && value) {
                [v closeAfterDelay:[value doubleValue]];
            }
            
        } keys:@[@"action",@"close"] context:nil];
        
    }
    
}

-(void) show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) close  {
    [self.element.view removeFromSuperview];
    objc_setAssociatedObject(self.element.view, "_KKWindowPageController", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) closeAfterDelay:(NSTimeInterval) afterDelay {
    [self performSelector:@selector(close) withObject:nil afterDelay:afterDelay];
}

@end

//
//  UIButton+CustomButton.m
//  RunTimeDemo
//
//  Created by liicon on 2017/6/15.
//  Copyright © 2017年 max. All rights reserved.
//

#import "UIButton+CustomButton.h"
#import <objc/runtime.h>

static char *kIndexPathKey = "indexPathKey";

@implementation UIButton (CustomButton)

- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &kIndexPathKey, indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSIndexPath *)indexPath{
    return objc_getAssociatedObject(self, &kIndexPathKey);
}

@end

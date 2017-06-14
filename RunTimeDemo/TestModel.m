//
//  TestModel.m
//  RunTimeDemo
//
//  Created by liicon on 2017/6/14.
//  Copyright © 2017年 max. All rights reserved.
//

#import "TestModel.h"
#import <objc/runtime.h>

@interface TestModel ()

@property(nonatomic,strong) NSString *address;

@end

@implementation TestModel

+ (void)initialize{
    NSLog(@"%s",__func__);
}


- (instancetype)init{
    self = [super init];
    if (self) {
        _describe = @"我是不能改的";
        self.address = @"广东";
    }
    return self;
}

- (void)changeName:(NSString *)name{
    self.name = name;
    
}

- (void)addDescribeWithChangeName:(NSString *)name{
    
    self.name =  name;
    NSLog(@"me_name is %@",self.name);
}

+ (void)load{
    
    NSLog(@"%s",__func__);
    
    Method changeName = class_getClassMethod(self, @selector(changeName:));
    Method addDescribewithName = class_getClassMethod(self, @selector(addDescribeWithChangeName:));
    
    method_exchangeImplementations(changeName, addDescribewithName);
    
}

- (void)printPrivatePropertyValue{
    NSLog(@"%@",_address);
}

@end

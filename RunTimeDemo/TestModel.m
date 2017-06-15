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

- (NSString *)getModelAddress{
    return self.address;
}

- (NSString *)printAndGetModelAddress{
    NSLog(@"更改方法后打印");
    return _address;
}

+(void)nameLog{
    NSLog(@"xiaoming");
}

- (void)printPrivatePropertyValue{
    NSLog(@"%@",_address);
}


- (void)printExchangePrivateMethod{
    [self exChangemoethod];
}

- (void)exChangemoethod{
    NSLog(@"exchange log is %@",_address);
}

@end

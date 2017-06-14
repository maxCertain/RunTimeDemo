//
//  TestModel.h
//  RunTimeDemo
//
//  Created by liicon on 2017/6/14.
//  Copyright © 2017年 max. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestModel : NSObject


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *nicName;
@property(nonatomic,readonly, strong) NSString *describe;

- (void)printPrivatePropertyValue;

@end

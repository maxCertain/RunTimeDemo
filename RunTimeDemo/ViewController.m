//
//  ViewController.m
//  RunTimeDemo
//
//  Created by liicon on 2017/6/14.
//  Copyright © 2017年 max. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import <objc/runtime.h>
#import "RunTimeTools.h"

@interface ViewController ()

@property(nonatomic, strong) TestModel *testModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testModel = [[TestModel alloc] init];
    
//    NSArray *properties = propertiesWithObject(self.testModel);
    
    id value = getValueWithObjectProperty(_testModel, @"_name");
    if ([value isKindOfClass:[NSString class]]) {
        NSLog(@"name is %@",value);
    }
    
    //Runtime 有点多余
    setValueWithObjectProperty(_testModel, @"_describe", @"will change");
    NSLog(@"%@",self.testModel.describe);

    //KVC
    [_testModel setValue:@"改了" forKeyPath:@"_describe"];
    NSLog(@"%@",self.testModel.describe);
    
    
    NSLog(@"%@",getValueWithObjectProperty(_testModel, @"_address"));
    
    setValueWithObjectProperty(_testModel, @"_address", @"深圳");
    [_testModel printPrivatePropertyValue];
    [_testModel setValue:@"广州" forKeyPath:@"_address"];
    [_testModel printPrivatePropertyValue];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

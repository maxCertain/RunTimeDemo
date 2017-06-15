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
#import "UIButton+CustomButton.h"

@interface ViewController ()

@property(nonatomic, strong) TestModel *testModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testModel = [[TestModel alloc] init];
    self.testModel.name = @"xiaoming";
    
//    NSArray *properties = propertiesWithObject(self.testModel);
    
    id value = getValueWithObjectProperty(_testModel, @"_name");
    if ([value isKindOfClass:[NSString class]]) {
        NSLog(@"name is %@",value);
    }
    
    //Runtime 
    setValueWithObjectProperty(_testModel, @"_describe", @"will change");
    NSLog(@"%@",self.testModel.describe);

    //KVC
    [_testModel setValue:@"改了" forKeyPath:@"_describe"];
    NSLog(@"%@",self.testModel.describe);
    
    
    NSLog(@"%@",getValueWithObjectProperty(_testModel, @"_address"));
    
    setValueWithObjectProperty(_testModel, @"_address", @"深圳");
    [_testModel printPrivatePropertyValue];
    [_testModel setValue:@"广州" forKeyPath:@"_address"];
    
    [self methodTest];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
    NSLog(@"section is  %li row is %li",btn.indexPath.section,btn.indexPath.row);
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)methodTest{
    
    //方法替代
    SEL originAddMethod = @selector(getModelAddress);
    IMP changeGetAddM = class_getMethodImplementation([_testModel class], @selector(printAndGetModelAddress));
    class_replaceMethod([_testModel class], originAddMethod, changeGetAddM, NULL);
    NSLog(@"%@",[_testModel getModelAddress]);
    NSLog(@"%@",[_testModel printAndGetModelAddress]);
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    NSLog(@"交换方法测试1---------------");
    //与私有方法交换
    Method changeM1 = class_getInstanceMethod([_testModel class], @selector(exChangemoethod));
    Method changeM2 = class_getInstanceMethod([_testModel class], @selector(printPrivatePropertyValue));
    method_exchangeImplementations(changeM1, changeM2);
    [_testModel printPrivatePropertyValue];
    [_testModel printExchangePrivateMethod];
    
    
    NSLog(@"交换方法测试2---------------");
    
    //与其他类方法交换
    Method m3 = class_getInstanceMethod([self class], @selector(nameChange));
    Method m4 = class_getInstanceMethod([_testModel class], @selector(name));
    method_exchangeImplementations(m4, m3);
    NSLog(@"log property is %@",_testModel.name);
    NSLog(@"%@",[self nameChange]);
    

    Method m5 = class_getClassMethod([_testModel class], @selector(nameLog));
    method_exchangeImplementations(m3, m5);
    [self nameChange];
    
    
    //获取类方法  class_getMethodImplementation(<#__unsafe_unretained Class cls#>, <#SEL name#>)
    
    //获取实例方法 class_getInstanceMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)
    
#pragma clang diagnostic pop
}

- (NSString *)nameChange{
    NSLog(@"nameChange");
    return @"小明";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

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
    
    [self methodTest];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
    NSLog(@"section is  %li row is %li",btn.indexPath.section,btn.indexPath.row);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 60, 30);
    [self.view addSubview:btn];
    [btn setShowsTouchWhenHighlighted:YES];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(btnEvents:) forControlEvents:UIControlEventTouchDown];
    
    //添加方法
    class_addMethod([_testModel class], @selector(nameChange), [self methodForSelector:@selector(nameChange)], NULL);
    [_testModel performSelector:@selector(nameChange)];
    [self performSelector:@selector(changeName:obj:age:) withObject:@"xiaoming" withObject:@"13"];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)btnEvents:(UIButton *)btn{
    
}

- (void)coutDelay{
    
}

- (void)changeName:(NSString *)name obj:(id)obj age:(NSInteger)age{
    NSLog(@"%@",name);
    NSLog(@"%@",obj);
    NSLog(@"%ld",(long)age);
}

- (void)methodTest{
    
    //方法替代
    SEL originAddMethod = @selector(getModelAddress);
    IMP changeGetAddM = class_getMethodImplementation([_testModel class], @selector(printAndGetModelAddress));
    class_replaceMethod([_testModel class], originAddMethod, [_testModel methodForSelector:@selector(printAndGetModelAddress)], NULL);
    NSLog(@"更改后->原始 %@",[_testModel getModelAddress]);
    NSLog(@"%@",[_testModel printAndGetModelAddress]);
    
    NSLog(@"%p",changeGetAddM);
    NSLog(@"%p",[_testModel methodForSelector:@selector(printAndGetModelAddress)]);
    
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
    
    
    //获取类方法  class_getMethodImplementation(__unsafe_unretained Class cls, SEL name)
    
    //获取实例方法 class_getInstanceMethod(__unsafe_unretained Class cls, SEL name)
    
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

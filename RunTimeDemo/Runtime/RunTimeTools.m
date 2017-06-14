//
//  RunTimeTools.m
//  RunTimeDemo
//
//  Created by liicon on 2017/6/14.
//  Copyright © 2017年 max. All rights reserved.
//

#import "RunTimeTools.h"


NSString* getPropertyType(objc_property_t property)
{
    NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
    
    NSArray *components = [attr componentsSeparatedByString:@"\""];
    NSString *type = nil;
    if (components.count > 1) {
        type = components[1];
    }
    return type;
}

/**
 获取对象的属性名

 @param obj 对象

 @return 返回属性名的数组
 */
NSArray *propertiesWithObject(id obj){
    
    getValueWithObjectProperty(obj, @"");
    
    NSMutableArray *propertiesNames = [NSMutableArray array];
    u_int cout;
    objc_property_t *properties = class_copyPropertyList([obj class], &cout);
    
    for (int i = 0; i < cout; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithFormat:@"%s",property_getName(property)];
        [propertiesNames addObject:name];
    }
    free(properties);

    return propertiesNames;
}

id getValueWithObjectProperty(id object,NSString *propertyName){
    
    const char *name = [propertyName UTF8String];
    Ivar ivar = class_getInstanceVariable([object class], name);
    id value = object_getIvar(object, ivar);
    return value;
}

void setValueWithObjectProperty(id object,NSString *name,id value){
    
    Ivar ivar = class_getInstanceVariable([object class], [name UTF8String]);
    object_setIvar(object, ivar, value);
}


//
//  RunTimeTools.h
//  RunTimeDemo
//
//  Created by liicon on 2017/6/14.
//  Copyright © 2017年 max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NSString* getPropertyType(objc_property_t property);

NSArray *propertiesWithObject(id obj);

id getValueWithObjectProperty(id object,NSString *propertyName);

void addPropertyWithObjectPropertyName(id object,NSString *propertyName);

void setValueWithObjectProperty(id object,NSString *name,id value);



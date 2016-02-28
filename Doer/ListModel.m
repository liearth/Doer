//
//  ListModel.m
//  Doer
//
//  Created by Liearth on 15/1/31.
//  Copyright (c) 2015年 Liearth. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (id)initWithDict:(NSMutableDictionary *)dict
{
    if (self = [super init]) {
        self.item = dict[@"item"];
        self.state = dict[@"state"];
        self.list = dict[@"list"];
    }
    
    return self;
}

+ (id)listWithDict:(NSMutableDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end

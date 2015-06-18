//
//  ListModel.h
//  Doer
//
//  Created by Liearth on 15/1/31.
//  Copyright (c) 2015年 Liearth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy)NSString *item;
@property (nonatomic, copy)NSString *state;
@property (nonatomic, copy)NSString *list;

- (id)initWithDict:(NSMutableDictionary *)dict;
+ (id)listWithDict:(NSMutableDictionary *)dict;

@end

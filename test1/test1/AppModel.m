//
//  AppModel.m
//  test1
//
//  Created by 杨雷 on 2016/10/30.
//  Copyright © 2016年 Yang.L. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    AppModel *model = [[AppModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
    
}


@end

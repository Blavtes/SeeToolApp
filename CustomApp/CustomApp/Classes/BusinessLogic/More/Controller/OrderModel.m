//
//  OrderModel.m
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (instancetype)initWithDic:(id)object
{
    if (self = [super initWithDic:object]) {
        [self GJSAutoSetPropertySafety:object];
//        [self test];
    }
    return self;
}

@end

@implementation OldOrderModel
- (instancetype)initWithDic:(id)object
{
    if (self = [super initWithDic:object]) {
        [self GJSAutoSetPropertySafety:object];
        self.idStr = [object objectForKeyForSafetyValue:@"id"];
    }
    return self;
}

@end

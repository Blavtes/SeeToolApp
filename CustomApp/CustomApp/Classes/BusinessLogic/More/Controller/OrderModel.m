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
        [self test];
    }
    return self;
}

- (void)test
{
    self.phone = @"135353535323";
    self.url = @"http://ywhdnnd.djhfs/werhhsdf.sdfhsfjsdfwe./werewrw/wdgfsd/fwr.guwrw23232";
    self.outtime = @"2018-04-23 23:11:32";
    self.dirverName = @"c2";
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

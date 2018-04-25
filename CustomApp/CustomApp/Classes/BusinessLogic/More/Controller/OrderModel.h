//
//  OrderModel.h
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "SFArchiverBaseModel.h"

@interface OrderModel : SFArchiverBaseModel
@property (nonatomic, strong) NSString *outTime;
@property (nonatomic, strong) NSString *dirverName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *msg;

- (instancetype)initWithDic:(id)object;
@end

@interface OldOrderModel : SFArchiverBaseModel
@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *dirverName;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *lOutTime;
@property (nonatomic, strong) NSString *ordertime;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *paytime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *sOutTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithDic:(id)object;
@end

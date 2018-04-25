//
//  OldOrderTableViewCell.h
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
typedef void(^CellClickBlock)(NSIndexPath *path);

@interface OldOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pidLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *outTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *dirverLabel;
@property (nonatomic, copy) CellClickBlock cellClickBlock;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setModel:(OldOrderModel *)model;

@end

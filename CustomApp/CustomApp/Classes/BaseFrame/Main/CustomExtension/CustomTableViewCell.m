//
//  CustomTableViewCell.m
//  CustomApp
//
//  Created by Blavtes on 2017/4/27.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    DLog(@"setSelected %d %@",selected, self);
    // Configure the view for the selected state
}


@end

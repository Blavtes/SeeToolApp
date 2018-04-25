//
//  OldOrderTableViewCell.m
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "OldOrderTableViewCell.h"

@implementation OldOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)copyAllClick:(id)sender {
    if (self.cellClickBlock) {
        self.cellClickBlock(_indexPath);
    }
    
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"过期时间：%@\n1、点击手机号复制 %@\n2、打开粘贴 https://weixin110.qq.com/security/readtemplate?t=signup_verify/w_wxteam_help\n设备名:%@",_outTimelabel.text,_phoneLabel.text,_dirverLabel.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end

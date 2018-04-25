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
    Show_iToast(@"复制成功~");
}

- (void)setModel:(OldOrderModel *)model
{
    self.phoneLabel.text = model.phone;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    NSString *status = model.status;
    if ([model.status isEqualToString:@"0"]) {
        status = @"(失败)";
//        self.statusLabel.textColor = COMMON_RED_COLOR;
        self.statusLabel.backgroundColor = COMMON_RED_COLOR;
    } else  if ([model.status isEqualToString:@"1"]) {
        status = @"(成功)";
//        self.statusLabel.textColor = COMMON_BLACK_COLOR;
        self.statusLabel.backgroundColor = COMMON_WHITE_COLOR;

    } else {
        status = @"(进行中)";
//        self.statusLabel.textColor = COMMON_BLACK_COLOR;
        self.statusLabel.backgroundColor = COMMON_WHITE_COLOR;


    }
    self.statusLabel.text = status;
    self.pidLabel.text = [NSString stringWithFormat:@"编号:%@",model.pId];
    self.payTimeLabel.text = [NSString stringWithFormat:@"结算时间:%@",model.paytime];
    self.dirverLabel.text = [NSString stringWithFormat:@"设备名:%@",model.dirverName];
    self.outTimelabel.text = [NSString stringWithFormat:@"有效期:%@",model.sOutTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end

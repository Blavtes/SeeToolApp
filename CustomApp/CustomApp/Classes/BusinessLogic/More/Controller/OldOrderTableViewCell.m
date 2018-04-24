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
    
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",_phoneLabel.text,_statusLabel.text,_pidLabel.text,_payTimeLabel.text,_outTimelabel.text,_dirverLabel.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

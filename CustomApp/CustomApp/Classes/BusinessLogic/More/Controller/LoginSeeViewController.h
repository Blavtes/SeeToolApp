//
//  LoginSeeViewController.h
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "CustomBaseViewController.h"

typedef void(^LoginBlock)(NSString *name);

@interface LoginSeeViewController : UIViewController
@property (nonatomic, copy) LoginBlock loginBlock;
@end

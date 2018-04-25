//
//  CustomBaseLayoutViewController.h
//  GjFax
//
//  Created by Blavtes on 2017/5/17.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavTopFrameLayout.h"

@class MyFrameLayout;
@class MyLinearLayout;

typedef void(^HiddenKeyBoard)(void);
/**
 自定义layout vc 基类
 */
@interface CustomBaseLayoutViewController : UIViewController

@property (nonatomic, weak) MyFrameLayout       *frameLayout;
@property (nonatomic, weak) CustomNavTopFrameLayout      *navTopView;
@property (nonatomic, weak) MyLinearLayout      *contentLayout;
@property (nonatomic, copy) HiddenKeyBoard hiddenKeyBoard;
@end

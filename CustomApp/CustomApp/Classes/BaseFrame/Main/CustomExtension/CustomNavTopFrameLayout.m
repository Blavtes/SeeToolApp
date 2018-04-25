//
//  CustomNavTopFrameLayout.m
//  GjFax
//
//  Created by Blavtes on 2017/6/7.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomNavTopFrameLayout.h"


static CGFloat  kSpaceWidth  = 20.0f;

@implementation CustomNavTopFrameLayout

- (instancetype)initWithTitle:(NSString *)title backClickHandle:(BackClickHandle)handle
{
    return [self initWithTitle:title showBackImage:YES rightTitle:nil backClickHandle:handle rightClickHandle:nil];
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightClickHandle:(RightClickHandle)rightClick
{
    return [self initWithTitle:title showBackImage:NO rightTitle:rightTitle backClickHandle:nil rightClickHandle:rightClick];
}

- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightTitle:(NSString *)rightTitle backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick
{
    if (self = [super init]) {
        self.myTop = 0;
        self.myLeft = 0;
        self.myRight = 0;
        self.myHeight = 64 + IPHONE_X_Top_Normal_Height;
        self.backgroundColor = COMMON_BLUE_GREEN_COLOR;
        
        if (show) {
            [self showBackHandle:handle];
        }
        
        [self showTitle:title];
        
        
        if (rightTitle.length > 0) {
            [self showRightTitle:rightTitle];
        }
        _backClick = handle;
        _rightClick = rightClick;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick
{
    
    if (self = [super init]) {
        self.myTop = 0;
        self.myLeft = 0;
        self.myRight = 0;
        self.myHeight = 64 + IPHONE_X_Top_Normal_Height;
        self.backgroundColor = COMMON_BLUE_COLOR;
        
        if (show) {
            [self showBackHandle:handle];
        }
        
        [self showTitle:title];
        
        
        [self showRightBtnNorImageName:rightNor highlight:rightHight];
        
        _backClick = handle;
        _rightClick = rightClick;
        
    }
    return self;
}

- (void)showRightTitle:(NSString *)rightTitle
{
    
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateHighlighted];
    
    [self.rightBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize kTitleSize = [rightTitle getTextSize:kCommonFontSizeSubDesc_14 maxWidth:88];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
  
    _rightBtn.myTop = 20 + IPHONE_X_Top_Normal_Height;
    _rightBtn.myWidth = kTitleSize.width;
    _rightBtn.myHeight = 44;
    _rightBtn.myRight = 20;
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)showRightBtnNorImageName:(NSString *)nor highlight:(NSString *)highlight
{
    
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    
    [_rightBtn setImage:[UIImage imageWithName:nor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageWithName:highlight] forState:UIControlStateHighlighted];
    
    //  设置大小
    //_rightBtn.size = _rightBtn.currentBackgroundImage.size;
    
    //  按钮点击高光
    _rightBtn.showsTouchWhenHighlighted = YES;
    
    //  监听点击事件
//    _rightBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH - 40, 22, 40, 40);
    _rightBtn.myTop = 20 + IPHONE_X_Top_Normal_Height;
    _rightBtn.myWidth = 40;
    _rightBtn.myHeight = 40;
    _rightBtn.myRight = 20;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(rightHandleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn = btn;
    }
    return _rightBtn;
}

- (void)rightHandleClick:(id)sender
{
    
    if (_rightClick) {
        self.rightClick(sender);
    }
}

- (void)showRightTitle:(NSString *)title rightHandle:(RightClickHandle)handle
{
    [self showRightTitle:title];
    _rightClick = handle;
}

- (void)showRightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight rightHandle:(RightClickHandle)handle
{
    [self showRightBtnNorImageName:rightNor highlight:rightHight];
    _rightClick = handle;
}

- (void)showTitle:(NSString *)title
{
    self.titleLabel.text = title;

//    [self showTapLoadingView];
}

- (void)showNavLoadingView
{
    if (!_topLoadingView) {
        UIActivityIndicatorView *loading = [UIActivityIndicatorView new];
        [self addSubview:loading];
        _topLoadingView = loading;
    }
    NSString *titleStr = self.titleLabel.text;
    CGSize size  = [titleStr strSizeWithFont:kCommonFontSizeTitle_18 maxSize:CGSizeMake(MAIN_SCREEN_WIDTH, self.height)];
    DLog(@"size %f",size.width);
    if (titleStr.length == 0) {
       _topLoadingView.myLeft = MAIN_SCREEN_WIDTH / 2.0f - 20;
    } else {

        _topLoadingView.myLeft = (MAIN_SCREEN_WIDTH - size.width) / 2.0f - 20;
    }
     _topLoadingView.myTop = 42 + IPHONE_X_Top_Normal_Height;
    _topLoadingView.hidden = NO;
    [_topLoadingView startAnimating];
}

- (void)hiddenNavLoadingView
{
    _topLoadingView.hidden = YES;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.myTop = 27 + IPHONE_X_Top_Normal_Height;
        label.myLeft = 40;
        label.myRight = 40;
        label.myHeight = 30;
        label.font = [UIFont boldSystemFontOfSize:kCommonFontSizeTitle_18];
        label.textColor = COMMON_WHITE_COLOR;
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        //        label.adjustsFontSizeToFitWidth = YES;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (void)showBackHandle:(BackClickHandle)handle
{
    [self backBtn];
    _backClick = handle;
}

- (void)showBackTitle:(NSString *)title backHandle:(BackClickHandle)handle
{
    [self.backBtn setImage:nil forState:UIControlStateNormal];
    [self.backBtn setImage:nil forState:UIControlStateHighlighted];
    
    [self.backBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    CGSize kTitleSize = [title getTextSize:kCommonFontSizeSubDesc_14 maxWidth:88];
  
    self.backBtn.myTop = 38 + IPHONE_X_Top_Normal_Height;
    self.backBtn.myLeft = kSpaceWidth * 0.5;
    self.backBtn.myWidth = kTitleSize.width;
    self.backBtn.myHeight = kSpaceWidth * 2.2;
    
    [self.backBtn  setTitle:title forState:UIControlStateNormal];
    _backClick = handle;
}

- (void)showBackImageName:(NSString *)backNor backHighlightImageName:(NSString *)backHight backHandle:(BackClickHandle)handle
{
    [self showRightBtnNorImageName:backNor highlight:backHight];
    _backClick = handle;
}

- (void)showBackBtnNorImageName:(NSString *)nor highlight:(NSString *)highlight
{
    
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    
    [self.backBtn setImage:[UIImage imageWithName:nor] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageWithName:highlight] forState:UIControlStateHighlighted];
    
    //  设置大小
    //_rightBtn.size = _rightBtn.currentBackgroundImage.size;
    
    //  按钮点击高光
    self.backBtn.showsTouchWhenHighlighted = YES;
  
    self.backBtn.myTop = kSpaceWidth * 1.1 + IPHONE_X_Top_Normal_Height;
    self.backBtn.myLeft = kSpaceWidth * 0.4;
    self.backBtn.myWidth = kSpaceWidth * 2;
    self.backBtn.myHeight = kSpaceWidth * 2;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        //  设置背景图片
        UIButton *backBtn = [[UIButton alloc] init];
        
        [backBtn setImage:[UIImage imageWithName:@"btn_navi_back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageWithName:@"btn_navi_back_selected"] forState:UIControlStateHighlighted];
     
        backBtn.myTop = kSpaceWidth * 1.1 + IPHONE_X_Top_Normal_Height;
        backBtn.myLeft = kSpaceWidth * 0.4;
        backBtn.myWidth = kSpaceWidth * 2;
        backBtn.myHeight = kSpaceWidth * 2;
        //  按钮点击高光
        // backBtn.showsTouchWhenHighlighted = YES;
        
        //  监听点击事件
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:backBtn];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (void)backAction:(id)sender
{
    if (_backClick) {
        self.backClick(sender);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)hideBack
{
    self.backBtn.hidden = YES;
}

- (void)itemWithTaget:(id)taget backHandle:(BackClickHandle)handle
{
    if (_loginBtn) {
        [_loginBtn removeFromSuperview];
        _loginBtn = nil;
    }
    _backClick = handle;
    self.backBtn.hidden = YES;
    self.loginBtn.hidden = NO;
    
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        UIButton * loginBtn = [UIButton new];
        [loginBtn addTarget:self action:@selector(log:)  forControlEvents:UIControlEventTouchUpInside];
//        loginBtn.center = CGPointMake(36, 38);
//        //  设置大小
//        loginBtn.size = CGSizeMake(40, 40);
        
        loginBtn.myTop = kSpaceWidth * 0.9 + IPHONE_X_Top_Normal_Height;
        loginBtn.myLeft = kSpaceWidth * 0.8;
        loginBtn.myWidth = kSpaceWidth * 2;
        loginBtn.myHeight = kSpaceWidth * 2;
        
        [self addSubview:loginBtn];
        _loginBtn = loginBtn;
    }
    return _loginBtn;
}

- (UIButton *)closeAllBtn
{
    if (!_closeAllBtn) {
        UIButton *closeAllBtn = [[UIButton alloc] init];
        
        [closeAllBtn setImage:[UIImage imageWithName:@"webView_CloseAll"] forState:UIControlStateNormal];
        [closeAllBtn setImage:[UIImage imageWithName:@"CloseAll_Selected"] forState:UIControlStateHighlighted];
//        closeAllBtn.center = CGPointMake(55, 22);
//        //  设置大小
//        closeAllBtn.size = CGSizeMake(40, 40);
        closeAllBtn.myTop = kSpaceWidth * 0.1 + IPHONE_X_Top_Normal_Height;
        closeAllBtn.myLeft = kSpaceWidth * 1.75;
        closeAllBtn.myWidth = kSpaceWidth * 2;
        closeAllBtn.myHeight = kSpaceWidth * 2;
        
        //  按钮点击高光
        // backBtn.showsTouchWhenHighlighted = YES;
        
        //  监听点击事件
        [closeAllBtn addTarget:self action:@selector(closeAllAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeAllBtn];
        _closeAllBtn = closeAllBtn;
    }
    return _closeAllBtn;
}

- (UIView *)closeLine
{
    if (!_closeLine) {
        //  设置背景图片
        UIView *line = [[UIView alloc] init];
        
        line.userInteractionEnabled = NO;
        line.backgroundColor = COMMON_GREY_WHITE_COLOR;
        
//        line.center = CGPointMake(47, 32);
//        line.size = CGSizeMake(0.5, 20);
        line.alpha = 0.8;
        
        line.myTop = kSpaceWidth * 2.2 + IPHONE_X_Top_Normal_Height;
        line.myLeft = kSpaceWidth * 2.35;
        line.myWidth = 0.5;
        line.myHeight = kSpaceWidth;
        [self addSubview:line];
        _closeLine = line;
    }
    
    return _closeLine;
}

- (void)closeAllAction:(UIButton *)btn
{
    if (self.closeAllClick) {
        self.closeAllClick(btn);
    }
}

- (void)showCloseAllClickHandle:(CloseAllClickHandle)close
{
    //  中间的竖线
    //    self.lineBarBtn = [self itemWithImageName:@"webView_Line"];
    self.closeAllBtn.hidden = NO;
    self.closeLine.hidden = NO;
    _closeAllClick = close;
    
    [self checkoutTitleFrame];
}

//web view 调整title frame
- (void)checkoutTitleFrame
{
    CGSize size = [self.titleLabel.text strSizeWithFont:kCommonFontSizeTitle_18 maxSize:CGSizeMake(MAIN_SCREEN_WIDTH , 30)];
    if (size.width > MAIN_SCREEN_WIDTH - 180) {
//        self.titleLabel.frame = CGRectMake(90, 27, MAIN_SCREEN_WIDTH - 90 - 40, 30);
        self.titleLabel.myLeft = 90;
        self.titleLabel.myRight = 40;
        self.titleLabel.myTop = 27 + IPHONE_X_Top_Normal_Height;
        self.titleLabel.myHeight = 30;
    } else {
//        self.titleLabel.frame = CGRectMake(90, 27, MAIN_SCREEN_WIDTH - 180, 30);
        self.titleLabel.myLeft = 90;
        self.titleLabel.myRight = 90;
        self.titleLabel.myTop = 27 + IPHONE_X_Top_Normal_Height;
        self.titleLabel.myHeight = 30;
    }
}

- (void)hideCloseAll
{
    self.closeAllBtn.hidden = YES;
    self.closeLine.hidden = YES;
}
- (void)dealloc
{
    DLog(@"dealloc %@",NSStringFromClass([self class]));
    _backClick = nil;
}


@end

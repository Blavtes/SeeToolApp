//
//  CustomBaseLayoutViewController.m
//  GjFax
//
//  Created by Blavtes on 2017/5/17.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomBaseLayoutViewController.h"
#import "MyLayout.h"
#import "CustomNavTopFrameLayout.h"

@interface CustomBaseLayoutViewController ()
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation CustomBaseLayoutViewController

- (void)loadView
{
    MyFrameLayout *frameLayout = [MyFrameLayout new];
    frameLayout.backgroundColor = COMMON_GREY_WHITE_COLOR;
    self.view = frameLayout;
    _frameLayout = frameLayout;
    
    
    __weak typeof(self) weakSelf = self;
    CustomNavTopFrameLayout *top = [[CustomNavTopFrameLayout alloc] initWithTitle:@"" backClickHandle:^(UIButton *view) {
        [weakSelf back];
    }];
    [self.view addSubview:top];
    _navTopView = top;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    scrollView.myTop = top.myHeight;
    scrollView.myLeft = scrollView.myRight = scrollView.myBottom = 0;
    scrollView.alwaysBounceVertical = YES;
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //     CGRect sz = [frameLayout estimateLayoutRect:CGSizeMake(0, 0)];
//    scrollView.heightSize.lBound(frameLayout.heightSize, 10, 1);
//    scrollView.wrapContentSize = YES;
    
    [self.view addSubview: scrollView];
    _scrollView = scrollView;
    
    MyLinearLayout *layout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
//    layout.myMargin = 0;
    layout.myHorzMargin = 0;
    layout.backgroundColor = COMMON_GREY_WHITE_COLOR;
    layout.adjustScrollViewContentSizeMode = MyAdjustScrollViewContentSizeModeYes;
    layout.wrapContentHeight = YES;
    layout.gravity = MyGravity_Horz_Fill;
    layout.heightSize.lBound(scrollView.heightSize, 10, 1);
    [scrollView addSubview: layout];
    
    _contentLayout = layout;
    [layout setTarget:self action:@selector(handleHideKeyboard:)];  //设置布局上的触摸事件。布局视图支持触摸事件的设置，可以使用setTarget方法来实现。

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
//    UILabel *label = [UILabel new];
//    label.myTop = 27;
//    label.myLeft = 40;
//    label.myRight = 40;
//    label.myHeight = 30;
//    label.font = [UIFont boldSystemFontOfSize:kCommonFontSizeTitle_18];
//    label.textColor = COMMON_WHITE_COLOR;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.navTopView addSubview:label];
//    label.text = title;
    [self.navTopView showTitle:title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
    if (self.hiddenKeyBoard) {
        self.hiddenKeyBoard();
    }
}

- (void)dealloc
{
    DLog(@"dealloc %@",NSStringFromClass([self class]));
    
//    if (_frameLayout) {
//        [_frameLayout removeFromSuperview];
//        _frameLayout = nil;
//    }
//    
//    if (_navTopView) {
//        [_navTopView removeFromSuperview];
//        _navTopView = nil;
//    }
//    if (_contentLayout) {
//        
//    
//    [_contentLayout removeFromSuperview];
//    _contentLayout = nil;
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

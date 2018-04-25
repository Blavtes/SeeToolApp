//
//  OneViewController.m
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "OneViewController.h"
#import "LoginSeeViewController.h"
#import "HttpToolManager.h"
#import "HttpToolDataEntity.h"
#import "OrderModel.h"
#import "OldOrderTableViewCell.h"
#import "GJSShareManager.h"
#import "NSTimer+Safety.h"

@interface OneViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *showBgView;
@property (weak, nonatomic) IBOutlet UIButton *getOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *reflashBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *loginName;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (nonatomic ,strong) OldOrderModel *orderModel;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) NSString *phoneCopyStr;
@property (nonatomic, strong) NSString *allCopyStr;
@property (nonatomic, strong) NSTimer *time;
@end

@implementation OneViewController

- (IBAction)switchClick:(id)sender {
    UISwitch *swi = (UISwitch*)sender;
    if (swi.on) {
        if (_time) {
            [_time invalidate];
            _time = nil;
        }
        __weak typeof(self)weakSelf = self;
        _time = [NSTimer SafetyTimerWithTimeInterval:2 repeats:YES target:sender block:^(NSTimer *timer) {
            [weakSelf reflashClick:nil];
            NSLog(@"reflashClick");
        }];
    } else {
        [_time invalidate];
        _time = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBGView];
    _listArr = [NSMutableArray arrayWithCapacity:1];
//    _loginName = @"15820498438";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navTopView.hidden = YES;
    self.title = @"海鱼工作室";
    [self login];
    [self.view endEditing:YES];
    _showBgView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    UITapGestureRecognizer *p2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePan:)];
    [_imageView addGestureRecognizer:p2];
    
    UITapGestureRecognizer *p3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPan:)];
    
    [_showBgView addGestureRecognizer:p3];
//    
//    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [_backgroundView addGestureRecognizer:pan];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http:\/\/www.shyl8.net\/WechatData\/2018-04-23\/13285287478.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
//    _tableView.mj_footer =
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_loginName.length > 0) {
        [self reflashAllClick:nil];
    }
}

//显示二维码
- (void)showPan:(id)sender
{
    _showBgView.hidden = YES;
    _tableView.hidden = NO;
    self.navTopView.backgroundColor = COMMON_BLACK_COLOR;
    [UIView animateWithDuration:0.2 animations:^{
        _imageView.frame = CGRectMake(_textView.right + 5, _textView.y, MAIN_SCREEN_WIDTH - _textView.right - 10, _textView.height);
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.url] placeholderImage:[UIImage imageNamed:@"code"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }];
    
}

//隐藏二维码
//http:\/\/www.shyl8.net\/WechatData\/2018-04-23\/13285287478.jpg
- (void)imagePan:(id)sender
{
    if (_orderModel.url.length > 0) {
        if (!_showBgView.isHidden) {
            [self showPan:nil];
        } else {
            self.navTopView.backgroundColor = COMMON_BLUE_GREEN_COLOR;
            _showBgView.hidden = NO;
            _tableView.hidden = YES;
            [UIView animateWithDuration:0.2 animations:^{
                _imageView.frame = CGRectMake(_textView.right + 5, _textView.y, MAIN_SCREEN_WIDTH / 2 , MAIN_SCREEN_WIDTH / 2);
                _imageView.center = CGPointMake( MAIN_SCREEN_WIDTH / 2,  MAIN_SCREEN_HEIGHT / 2);
            }];
        }
    }
}

- (void)showImageView
{
    
}

- (void)pan:(id)sender
{
    [self hideKeyBoardClick];
}

- (void)hideKeyBoardClick
{
    [_textView resignFirstResponder];
}


- (void)login
{
    __weak typeof(self) weakSelf = self;
    
    LoginSeeViewController *more = [[LoginSeeViewController alloc] initWithNibName:
    @"LoginSeeViewController" bundle:[NSBundle mainBundle]];
    more.loginBlock = ^(NSString *name) {
        weakSelf.loginName = name;
    };
    [self presentViewController:more animated:YES completion:^{
        
    }];
}

- (void)configBGView
{
    
    float width = (MAIN_SCREEN_WIDTH - 40 - 60) / 6;
    
    UIColor *nomarlColor = COMMON_BLUE_GREEN_COLOR;
    UIColor *hightColor = COMMON_GREY_COLOR;
    UIColor *backColor = UIColorFromRGBHex(0xDADCDC);
    
    UIButton *codeAll = [[UIButton alloc] initWithFrame:CGRectMake(5, 2.5 , width, _bgView.height - 5)];
    [codeAll addTarget:self action:@selector(codeAllContent:) forControlEvents:UIControlEventTouchUpInside];
    [codeAll setTitleColor:nomarlColor forState:UIControlStateNormal];
    [codeAll setTitleColor:hightColor forState:UIControlStateHighlighted];
    [codeAll setBackgroundColor:backColor forState:UIControlStateNormal];
    [codeAll setBackgroundColor:backColor forState:UIControlStateHighlighted];
    
    codeAll.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    codeAll.titleLabel.textAlignment = NSTextAlignmentCenter;
    [codeAll setTitle:@"二维码" forState:UIControlStateNormal];
    codeAll.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:codeAll];
    
    UIButton *copyAll = [[UIButton alloc] initWithFrame:CGRectMake(width + 15, 2.5 , width, _bgView.height - 5)];
    [copyAll addTarget:self action:@selector(copyAllContent:) forControlEvents:UIControlEventTouchUpInside];
    [copyAll setTitleColor:nomarlColor forState:UIControlStateNormal];
    [copyAll setTitleColor:hightColor forState:UIControlStateHighlighted];
    [copyAll setBackgroundColor:backColor forState:UIControlStateNormal];
    [copyAll setBackgroundColor:backColor forState:UIControlStateHighlighted];

    copyAll.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    copyAll.titleLabel.textAlignment = NSTextAlignmentCenter;
    [copyAll setTitle:@"复制全部\n内容" forState:UIControlStateNormal];
    copyAll.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:copyAll];
    
    UIButton *copyNumber = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 2 + 5 ,2.5, width, _bgView.height  - 5)];
    [copyNumber addTarget:self action:@selector(copyNumber:) forControlEvents:UIControlEventTouchUpInside];
    [copyNumber setTitleColor:nomarlColor forState:UIControlStateNormal];
    [copyNumber setTitleColor:hightColor forState:UIControlStateHighlighted];
    [copyNumber setBackgroundColor:backColor forState:UIControlStateNormal];
    [copyNumber setBackgroundColor:backColor forState:UIControlStateHighlighted];

    copyNumber.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    copyNumber.titleLabel.textAlignment = NSTextAlignmentCenter;
    [copyNumber setTitle:@"复制手\n机号" forState:UIControlStateNormal];
    copyNumber.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:copyNumber];
    
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 3 + 5, 2.5 , width, _bgView.height - 5)];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:nomarlColor forState:UIControlStateNormal];
    [shareBtn setTitleColor:hightColor forState:UIControlStateHighlighted];
    [shareBtn setBackgroundColor:backColor forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:backColor forState:UIControlStateHighlighted];

    shareBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [shareBtn setTitle:@"分享二维\n码" forState:UIControlStateNormal];
    shareBtn.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:shareBtn];
    
    
    UIButton *reflashBtn = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 4  + 5, 2.5, width, _bgView.height - 5)];
    [reflashBtn addTarget:self action:@selector(reflashAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [reflashBtn setTitleColor:nomarlColor forState:UIControlStateNormal];
    [reflashBtn setTitleColor:hightColor forState:UIControlStateHighlighted];
    [reflashBtn setBackgroundColor:backColor forState:UIControlStateNormal];
    [reflashBtn setBackgroundColor:backColor forState:UIControlStateHighlighted];

    reflashBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    reflashBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [reflashBtn setTitle:@"刷新订单\n列表" forState:UIControlStateNormal];
    reflashBtn.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:reflashBtn];
    
    UIButton *allCount = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 5 + 5, 2.5, width, _bgView.height - 5)];
    [allCount addTarget:self action:@selector(allCountClick:) forControlEvents:UIControlEventTouchUpInside];
    [allCount setTitleColor:nomarlColor forState:UIControlStateNormal];
    [allCount setTitleColor:hightColor forState:UIControlStateHighlighted];
    [allCount setBackgroundColor:backColor forState:UIControlStateNormal];
    [allCount setBackgroundColor:backColor forState:UIControlStateHighlighted];

    allCount.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    allCount.titleLabel.textAlignment = NSTextAlignmentCenter;
    [allCount setTitle:@"查看当天\n统计" forState:UIControlStateNormal];
    allCount.titleLabel.lineBreakMode = 0;
    [_bgView addSubview:allCount];
    
  
}

- (void)codeAllContent:(id)sender
{
    if (!_showBgView.isHidden) {
        [self showPan:nil];
    } else {
        self.navTopView.backgroundColor = COMMON_BLUE_GREEN_COLOR;
        _showBgView.hidden = NO;
        _tableView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            _imageView.frame = CGRectMake(_textView.right + 5, _textView.y, MAIN_SCREEN_WIDTH / 2 , MAIN_SCREEN_WIDTH / 2);
            _imageView.center = CGPointMake( MAIN_SCREEN_WIDTH / 2,  MAIN_SCREEN_HEIGHT / 2);
            _imageView.image = [UIImage imageNamed:@"code"];
        }];
    }
}

//复制全部
- (void)copyAllContent:(id)sender
{
    [self hideKeyBoardClick];
    if (_allCopyStr.length > 0) {
        [UIPasteboard generalPasteboard].string = _allCopyStr;
        Show_iToast(@"复制成功~");
    } else  {
        Show_iToast(@"复制失败~");
    }
}

//复制手机号
- (void)copyNumber:(id)sender
{
    [self hideKeyBoardClick];
    if (_phoneCopyStr.length > 0) {
        [UIPasteboard generalPasteboard].string = _phoneCopyStr;
        Show_iToast(@"复制成功~");
    } else {
        Show_iToast(@"复制失败~");
    }

}

//分享
- (void)shareClick:(id)sender
{
    [self hideKeyBoardClick];
    NSString *title = @"分享";
    NSString *url = @"https://weixin110.qq.com/security/readtemplate?t=signup_verify/w_wxteam_help";
    NSString *content = [NSString stringWithFormat:@"过期时间：%@，手机号：%@,设备名:%@",_orderModel.sOutTime ,_orderModel.phone,_orderModel.dirverName ];
    NSString *imagePath = _orderModel.url;
    
    if (title.length > 0) {
        NSMutableDictionary * shareParams = [GJSShareManager shareParamsWithTitleString:title
                                                                          contentString:content
                                                                         imageUrlString:imagePath
                                                                          linkUrlString:url];
        [GJSShareManager showShareAlertSheet:self withParameter:shareParams];
    } else {
        Show_iToast(@"暂无数据")
    }
    
}

//获取订单列表
- (void)reflashAllClick:(id)sender
{
    [self hideKeyBoardClick];
    HttpToolDataEntity *entity = [HttpToolDataEntity new];
    entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
    entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_loginName,@"hiyu_ordeRecord", nil];
    __weak typeof(self) weakSelf = self;
    
    [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
        NSLog(@"response %@",response);
        
        NSArray *arr = (NSArray *)response;
        [weakSelf.listArr removeAllObjects];
        for (NSDictionary *dict in arr) {
            OldOrderModel *model = [[OldOrderModel alloc] initWithDic:dict];
            [weakSelf.listArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.listArr.count > 0) {
                OldOrderModel *model = weakSelf.listArr[0];
                [weakSelf showText:model.sOutTime phone:model.phone dirverName:model.dirverName url:model.url];
              
            }
          
            [weakSelf.tableView reloadData];
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock %@",error);
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
}

//获取统计
- (void)allCountClick:(id)sender
{
    [self hideKeyBoardClick];
    __block  UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    HttpToolDataEntity *entity = [HttpToolDataEntity new];
    entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
    entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_loginName,@"hiyu_detailsDay", nil];
    __weak typeof(self) weakSelf = self;
    
    [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
        NSLog(@"response %@",response);
        btn.enabled = YES;
        
        
        NSDictionary *dict = response[0];
        NSString *successCount = [dict objectForKeyForSafetyValue:@"successCount"];
        NSString *failCount = [dict objectForKeyForSafetyValue:@"failCount"];
        NSString *settlementCount = [dict objectForKeyForSafetyValue:@"settlementCount"];
        NSString *total = [dict objectForKeyForSafetyValue:@"total"];
        
        
        CustomAlertViewForFuncJump *alertView = [[CustomAlertViewForFuncJump alloc] initWithCompletionBlock:^(id  _Nonnull alertView) {
            
            [alertView dismiss];
        }];
        alertView.titleType = CustomAlertViewTitleShow;
        alertView.btnType = CustomAlertViewBtnNormal;
        alertView.textLabel.text = [NSString stringWithFormat:@"完成订单数：%@\n失败订单数：%@\n未结算 :%@",successCount,failCount,settlementCount];
        alertView.textLabel.textColor = COMMON_BLACK_COLOR;
        alertView.textLabel.height = 50;
        alertView.title = @"今日订单统计";
        alertView.textLabel.textAlignment = NSTextAlignmentCenter;
//        alertView.textLabel.frame = CGRectMake(20, 20, alertView.width - 40, alertView.height = 60);
        alertView.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
        alertView.textLabel.numberOfLines = 0;
        alertView.confirmBtnTitle = @"确定";
        [alertView show];
      
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock %@",error);
        btn.enabled = YES;
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
}

//接单
- (IBAction)getOrderClick:(id)sender
{
    [self hideKeyBoardClick];
    HttpToolDataEntity *entity = [HttpToolDataEntity new];
    entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
    entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_loginName,@"hiyu_getOrder", nil];
    __weak typeof(self) weakSelf = self;
    
    [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
        NSLog(@"response %@",response);
        NSDictionary *dict = response[0];
      
        OrderModel *model = [[OrderModel alloc] initWithDic:dict];
       
        
        if ([model.code  isEqualToString:@"0"]) {
            weakSelf.orderModel = [OldOrderModel new];
            weakSelf.orderModel.sOutTime = model.outTime;
            weakSelf.orderModel.phone = model.msg;
            weakSelf.orderModel.dirverName = model.dirverName;
            weakSelf.orderModel.url = model.url;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showText:weakSelf.orderModel.sOutTime phone:weakSelf.orderModel.phone dirverName:weakSelf.orderModel.dirverName url:weakSelf.orderModel.url];
            });
            [weakSelf reflashAllClick:nil];
        } else {
            weakSelf.phoneCopyStr = @"";
            weakSelf.allCopyStr = @"";
            Show_iToast([dict objectForKeyForSafetyValue:@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock %@",error);
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
}

//填充
- (void)showText:(NSString *)outtime phone:(NSString *)phone dirverName:(NSString *)dirverName url:(NSString *)url
{
    self.textView.text = [NSString stringWithFormat:@"过期时间：%@\n1、点击手机号复制 %@\n2、打开粘贴 https://weixin110.qq.com/security/readtemplate?t=signup_verify/w_wxteam_help\n设备名:%@",outtime,phone,dirverName];
    self.phoneCopyStr = phone;
    self.allCopyStr = self.textView.text;
    __block UIImageView *imageview = self.imageView;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
             imageview.image = image;
        });
    }];
}

//刷新可接个数
- (IBAction)reflashClick:(id)sender
{
    [self hideKeyBoardClick];
    HttpToolDataEntity *entity = [HttpToolDataEntity new];
    entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
    entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_loginName,@"hiyu_availableOrder", nil];
    __weak typeof(self) weakSelf = self;
    
    [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
        NSLog(@"response %@",response);
        NSString *count = [response[0] objectForKeyForSafetyValue:@"count"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.reflashBtn setTitle:[NSString stringWithFormat:@"刷新可接单数量(%@)",count] forState:UIControlStateNormal];
            
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock %@",error);
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_listArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _listArr.count - 1) {
        return 2;
    }
    
    return kTableViewFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kTableViewFooterHeight)];
    footerView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"oldOrderTableViewCell";
    
    
    OldOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OldOrderTableViewCell" owner:self options:nil] lastObject];
    }
    OldOrderModel *model = [_listArr objectAtIndex:indexPath.row];
  
    __weak typeof(self) weakSelf = self;

    cell.cellClickBlock = ^(NSIndexPath *index) {
        OldOrderModel *model = [weakSelf.listArr objectAtIndex:index.row];

        [weakSelf showText:model.sOutTime phone:model.phone dirverName:model.dirverName url:model.url];
    };
    [cell setModel:model];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectCellData:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - tableCell 选中跳转

- (void)selectCellData:(NSIndexPath *)indexPath
{
    [self hideKeyBoardClick];
    
    OldOrderModel *model = [self.listArr objectAtIndex:indexPath.row];
    _orderModel = model;
    [self showText:model.sOutTime phone:model.phone dirverName:model.dirverName url:model.url];
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

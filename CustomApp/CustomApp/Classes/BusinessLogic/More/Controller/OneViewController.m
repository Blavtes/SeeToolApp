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

@interface OneViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *getOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *reflashBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *loginName;

@property (nonatomic ,strong) OrderModel *orderModel;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) NSString *phoneCopyStr;
@property (nonatomic, strong) NSString *allCopyStr;
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBGView];
    _listArr = [NSMutableArray arrayWithCapacity:1];
//    _loginName = @"15820498438";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.navTopView hideBack];
    self.title = @"海鱼辅助平台";
    [self login];
    // Do any additional setup after loading the view from its nib.
}

- (void)login
{
    __weak typeof(self) weakSelf = self;
    
    LoginSeeViewController *more = [LoginSeeViewController new];
    more.loginBlock = ^(NSString *name) {
        weakSelf.loginName = name;
    };
    [self presentViewController:more animated:YES completion:^{
        
    }];
}

- (void)configBGView
{
    
    float width = (_bgView.width - 40 - 5) / 5;
    
    UIColor *nomarlColor = UIColorFromRGBHex(0x1D84FB);
    UIColor *hightColor = COMMON_GREY_COLOR;
    UIColor *backColor = UIColorFromRGBHex(0xDADCDC);
    
    UIButton *copyAll = [[UIButton alloc] initWithFrame:CGRectMake(2.5, 2.5 , width, _bgView.height - 5)];
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
    
    UIButton *copyNumber = [[UIButton alloc] initWithFrame:CGRectMake( width + 10 ,2.5, width, _bgView.height  - 5)];
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
    
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 2 , 2.5 , width, _bgView.height - 5)];
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
    
    
    UIButton *reflashBtn = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 3 , 2.5, width, _bgView.height - 5)];
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
    
    UIButton *allCount = [[UIButton alloc] initWithFrame:CGRectMake( (width + 10) * 4 , 2.5, width, _bgView.height - 5)];
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

- (void)copyAllContent:(id)sender
{
    if (_allCopyStr.length > 0) {
        [UIPasteboard generalPasteboard].string = _allCopyStr;

    }
}

- (void)copyNumber:(id)sender
{
    if (_phoneCopyStr.length > 0) {
        [UIPasteboard generalPasteboard].string = _phoneCopyStr;

    }

}

- (void)shareClick:(id)sender
{
    NSString *title = _orderModel.phone;
    NSString *url = _orderModel.url;
    NSString *content = [NSString stringWithFormat:@"过期时间：%@，手机号： %@，url :%@,设备名: %@",_orderModel.outtime ,_orderModel.phone,_orderModel.url,_orderModel.dirverName ];
    NSString *imagePath = _orderModel.url;
    
 
    NSMutableDictionary * shareParams = [GJSShareManager shareParamsWithTitleString:title
                                                                      contentString:content
                                                                     imageUrlString:imagePath
                                                                      linkUrlString:url];
    [GJSShareManager showShareAlertSheet:self withParameter:shareParams];
}

- (void)reflashAllClick:(id)sender
{
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
                
                [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
            }
          
            [weakSelf.tableView reloadData];
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock %@",error);
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        
    }];
}

- (void)allCountClick:(id)sender
{
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

- (IBAction)getOrderClick:(id)sender
{
    HttpToolDataEntity *entity = [HttpToolDataEntity new];
    entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
    entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_loginName,@"hiyu_getOrder", nil];
    __weak typeof(self) weakSelf = self;
    
    [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
        NSLog(@"response %@",response);
        NSDictionary *dict = response[0];
      
        OrderModel *model = [[OrderModel alloc] initWithDic:dict];
       
        
        if ([model.code  isEqualToString:@"0"]) {
            weakSelf.orderModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.textView.text = [NSString stringWithFormat:@"过期时间：%@\n1、点击手机号复制 %@\n2、打开粘贴 %@\n设备名:%@",model.outtime,model.phone,model.url,model.dirverName];
                weakSelf.phoneCopyStr = model.phone;
                weakSelf.allCopyStr = weakSelf.textView.text;
                
                [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
            });
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

- (IBAction)reflashClick:(id)sender
{
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
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _listArr.count - 1) {
        return 0.001f;
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
    cell.phoneLabel.text = model.phone;
    NSString *status = model.status;
    if ([model.phone isEqualToString:@"0"]) {
        status = @"(失败)";
    } else  if ([model.phone isEqualToString:@"1"]) {
        status = @"(成功)";
    } else {
        status = @"(进行中)";
    }
    cell.statusLabel.text = status;
    cell.pidLabel.text = [NSString stringWithFormat:@"编号:%@",model.pId];
    cell.payTimeLabel.text = [NSString stringWithFormat:@"结算时间:%@",model.paytime];
    cell.dirverLabel.text = [NSString stringWithFormat:@"设备名:%@",model.dirverName];
    cell.outTimelabel.text = [NSString stringWithFormat:@"有效期:%@",model.sOutTime];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

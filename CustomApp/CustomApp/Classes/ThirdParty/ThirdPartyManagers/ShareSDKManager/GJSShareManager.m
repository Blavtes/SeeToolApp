//
//  GJSShareManager.m
//  GjFax
//
//  Created by gjfax on 2017/8/3.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "GJSShareManager.h"

@class GJSAlertController;

@interface GJSShareManager()
{
    TencentOAuth *_tencentOAth;
    

}
@property (nonatomic, assign) __block BOOL isDefaultData;
@property (nonatomic, assign) __block BOOL isNewData;
@property (nonatomic, strong) GJSAlertController *alertController;
@end

@implementation GJSShareManager

#pragma mark - 统一注册
+ (void)regeistShareModule {
     /*微信注册 */
    [WXApi registerApp:ShareModule_WeChat_AppID];
     /*微博注册 */
//    [WeiboSDK registerApp:ShareModule_SinaWeibo_AppKey];
     /*QQ注册 */
//    [[self manager] registerQQ];
}
// 注册QQ
- (void)registerQQ {
    
    _tencentOAth = [[TencentOAuth alloc] initWithAppId:ShareSDK_QQAndQZone_AppID andDelegate:(id )[[UIApplication sharedApplication] delegate]];
    
}


#pragma mark - 统一格式的参数（url）
+ (NSMutableDictionary *)shareParamsWithTitleString:(NSString *)title
                                      contentString:(NSString *)content
                                     imageUrlString:(NSString *)imageUrl
                                      linkUrlString:(NSString *)linkUrl {
    NSMutableDictionary *mutableDictionary =  [NSMutableDictionary dictionary];
    [mutableDictionary setValue:title forKey:@"title"];
    [mutableDictionary setValue:content forKey:@"content"];
    [mutableDictionary setValue:imageUrl forKey:@"imageUrl"];
    [mutableDictionary setValue:linkUrl forKey:@"linkUrl"];
    
    return mutableDictionary;
}

#pragma mark - 统一返回格式的参数（image）
+ (NSMutableDictionary *)shareParamsWithTitleString:(NSString *)title
                                      contentString:(NSString *)content
                                              image:(UIImage *)image
                                      linkUrlString:(NSString *)linkUrl {
    NSMutableDictionary *mutableDictionary =  [NSMutableDictionary dictionary];
    UIImage *fitImage = [self returnImageWithImage:image];
    [mutableDictionary setValue:title forKey:@"title"];
    [mutableDictionary setValue:content forKey:@"content"];
    [mutableDictionary setValue:fitImage forKey:@"image"];
    [mutableDictionary setValue:linkUrl forKey:@"linkUrl"];
    
    return mutableDictionary;
}
#pragma mark - 统一显示底部弹出sheet类方法（url）
+ (void)showShareAlertSheet:(UIViewController *)viewcontroller withParameter:(NSMutableDictionary *)shareParameters {
    
// 未安装的情况：暂时只做微信分享
    if (![WXApi isWXAppInstalled]) {
        Show_iToast(@"分享平台[微信]尚未安装客户端！无法进行分享");
        return;
    }
//    if (!([WXApi isWXAppInstalled] || [WeiboSDK isWeiboAppInstalled] || [QQApiInterface isQQInstalled])) {
//        Show_iToast(@"尚未安装分享平台[微信][微博][QQ]客户端！无法进行分享");
//        return;
//    }
 //
    
//弹出分享框
    [[self manager] showShareAlertSheet:viewcontroller withParameter:shareParameters];
}

#pragma mark -统一弹出底部分享sheet（image）
+ (void)showShareAlertSheet:(UIViewController *)viewcontroller withImageParameter:(NSMutableDictionary *)shareParameters {
    if (![WXApi isWXAppInstalled]) {
        Show_iToast(@"分享平台[微信]尚未安装客户端！无法进行分享");
        return;
    }
    //    if (!([WXApi isWXAppInstalled] || [WeiboSDK isWeiboAppInstalled] || [QQApiInterface isQQInstalled])) {
    //        Show_iToast(@"尚未安装分享平台[微信][微博][QQ]客户端！无法进行分享");
    //        return;
    //    }
    
    [[self manager] showShareAlertSheet:viewcontroller withImageParameter:shareParameters];
}

#pragma mark - 统一显示底部弹出sheet对象方法(url)
- (void)showShareAlertSheet:(UIViewController *)viewcontroller withParameter:(NSMutableDictionary *)shareParameters {

/*alert控制器 */
    GJSAlertController *alertController = [self getAlertControllerWithParameter:shareParameters];
    
/*弹出 */
    [viewcontroller presentViewController:alertController animated:YES completion:NULL];
    
}

#pragma mark - 统一显示底部弹出sheet对象方法(image)
- (void)showShareAlertSheet:(UIViewController *)viewcontroller withImageParameter:(NSMutableDictionary *)shareParameters {
    
    GJSAlertController *alertController = [self getAlertControllerWithImageParameter:shareParameters];
    /*弹出 */
    [viewcontroller presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - 懒加载获取统一的弹框（url）
- (GJSAlertController *)getAlertControllerWithParameter:(NSMutableDictionary *)shareParameters
{

    if (!_alertController) {
        
        /*可以显示的分享按钮数量 */
//            NSInteger buttonCount = [self canDisplayShareButtonCounts:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSInteger buttonCount = [self canDisplayShareButtonCounts:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*可以显示的分享按钮图片名称 */
//            NSMutableArray *buttonImageNamesArray = [self canDisplayShareButtonImageNames:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonImageNamesArray = [self canDisplayShareButtonImageNames:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*可以显示的分享按钮文字描述 */
//            NSMutableArray *buttonDescriptionsArray = [self canDisplayShareButtonDescripitons:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonDescriptionsArray = [self canDisplayShareButtonDescripitons:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*可以显示的按钮tag */
//            NSMutableArray *buttonTagsArray = [self canDisplayShareButtonTags:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonTagsArray = [self canDisplayShareButtonTags:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*机型匹配参数 */
        CGSize imageSize = [UIImage imageNamed:@"share_icon_3"].size;
        UIFont *labelFont = [UIFont systemFontOfSize:11];
        CGFloat alertHeight = 200.f;
        NSString *messageString = @"\n\n\n\n\n";
        if (isRetina || iPhone5) {
            messageString = @"\n\n\n\n";
            imageSize = CGSizeMake(50, 50);
            labelFont = [UIFont systemFontOfSize:9];
            alertHeight = 170.f;
        }
        _alertController = [[GJSAlertController alloc] init];
        _alertController.view.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, alertHeight);
        _alertController.message = messageString;
       
        CGFloat gapFloat = (_alertController.view.bounds.size.width - imageSize.width* buttonCount ) / (buttonCount + 1);
        //    NSArray *displayWordsArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        for (int i = 1; i<= buttonCount; i++) {
            /*图片 */
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(gapFloat*i + imageSize.width* (i - 1), 15, imageSize.width,imageSize.width)];
            NSString *imageName = buttonImageNamesArray[i - 1];
            [imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [imageButton addTarget:_alertController action:@selector(shareFunction:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag =  [buttonTagsArray[i - 1] integerValue];
            imageButton.adjustsImageWhenHighlighted = NO;
            [_alertController.view addSubview:imageButton];
            
            /*文字 */
            UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageButton.frame.origin.x, imageButton.frame.origin.y +imageButton.frame.size.height + 10, imageButton.bounds.size.width, 20)];
            displayLabel.text = buttonDescriptionsArray[i-1];
            displayLabel.font = labelFont;
            displayLabel.textAlignment = NSTextAlignmentCenter;
            [_alertController.view addSubview:displayLabel];
        }
        
        /*底部sheet */
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [_alertController addAction:action];
    }
    __weak typeof(self) weakSelf = self;

    _alertController.shareButtonBlock = ^(int buttonTag) {
        [weakSelf shareResponse:buttonTag andParameter:shareParameters];
    };
    return _alertController;
}

#pragma mark - 懒加载获取统一的弹框（iamge）
- (GJSAlertController *)getAlertControllerWithImageParameter:(NSMutableDictionary *)shareParameters {
    if (!_alertController) {
        /*可以显示的分享按钮数量 */
//            NSInteger buttonCount = [self canDisplayShareButtonCounts:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSInteger buttonCount = [self canDisplayShareButtonCounts:[WXApi isWXAppInstalled] and:NO and:NO];

        /*可以显示的分享按钮图片名称 */
//            NSMutableArray *buttonImageNamesArray = [self canDisplayShareButtonImageNames:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonImageNamesArray = [self canDisplayShareButtonImageNames:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*可以显示的分享按钮文字描述 */
//            NSMutableArray *buttonDescriptionsArray = [self canDisplayShareButtonDescripitons:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonDescriptionsArray = [self canDisplayShareButtonDescripitons:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*可以显示的按钮tag */
//            NSMutableArray *buttonTagsArray = [self canDisplayShareButtonTags:[WXApi isWXAppInstalled] and:[WeiboSDK isWeiboAppInstalled] and:[QQApiInterface isQQInstalled]];
        NSMutableArray *buttonTagsArray = [self canDisplayShareButtonTags:[WXApi isWXAppInstalled] and:NO and:NO];
        
        /*机型匹配参数 */
        CGSize imageSize = [UIImage imageNamed:@"share_icon_3"].size;
        UIFont *labelFont = [UIFont systemFontOfSize:11];
        CGFloat alertHeight = 200.f;
        NSString *messageString = @"\n\n\n\n\n";
        if (isRetina || iPhone5) {
            messageString = @"\n\n\n\n";
            imageSize = CGSizeMake(50, 50);
            labelFont = [UIFont systemFontOfSize:9];
            alertHeight = 170.f;
        }
        /*alert控制器 */
        _alertController = [[GJSAlertController alloc] init];
        _alertController.view.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, alertHeight);
        _alertController.message = messageString;
   
        CGFloat gapFloat = (_alertController.view.bounds.size.width - imageSize.width* buttonCount ) / (buttonCount + 1);
        //    NSArray *displayWordsArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        for (int i = 1; i<= buttonCount; i++) {
            /*图片 */
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(gapFloat*i + imageSize.width* (i - 1), 15, imageSize.width,imageSize.width)];
            NSString *imageName = buttonImageNamesArray[i - 1];
            [imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [imageButton addTarget:_alertController action:@selector(shareFunction:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag =  [buttonTagsArray[i - 1] integerValue];
            imageButton.adjustsImageWhenHighlighted = NO;
            [_alertController.view addSubview:imageButton];
            
            /*文字 */
            UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageButton.frame.origin.x, imageButton.frame.origin.y +imageButton.frame.size.height + 10, imageButton.bounds.size.width, 20)];
            displayLabel.text = buttonDescriptionsArray[i-1];
            displayLabel.font = labelFont;
            displayLabel.textAlignment = NSTextAlignmentCenter;
            [_alertController.view addSubview:displayLabel];
        }
        
        /*底部sheet */
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [_alertController addAction:action];
    }
    __weak typeof(self) weakSelf = self;

    _alertController.shareButtonBlock = ^(int buttonTag) {
    [weakSelf shareResponse:buttonTag andImageParameter:shareParameters];
    };
    return _alertController;
    
}
#pragma mark - 收起分享弹框：实例方法
- (void)dismissAlertViewController{
    
    [[GJSShareManager manager].alertController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 收起分享弹框：类方法
+ (void)dismissAlertViewController {
    
    [[GJSShareManager manager].alertController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 可以显示的分享按钮数量
- (NSInteger )canDisplayShareButtonCounts:(BOOL)isWeiXinInstalled and:(BOOL)isWeiBoInstalled and:(BOOL)isQQInstalled {
    NSInteger weiXinCount = isWeiXinInstalled ? 2 : 0;
    NSInteger weiBoCount = isWeiBoInstalled ? 1 : 0;
    NSInteger qqCount = isQQInstalled ? 2 : 0;
    return (weiXinCount + weiBoCount + qqCount);
}
#pragma mark - 可以显示的分享按钮图片名称
- (NSMutableArray *)canDisplayShareButtonImageNames:(BOOL)isWeiXinInstalled and:(BOOL)isWeiBoInstalled and:(BOOL)isQQInstalled {
    NSMutableArray *mutalbleArray = [NSMutableArray array];
    if (isWeiXinInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"share_icon_1",@"share_icon_2"]];
    }
    if (isWeiBoInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"share_icon_3"]];
    }
    if (isQQInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"share_icon_4",@"share_icon_5"]];
    }
    return mutalbleArray;
}
#pragma mark - 可以显示的分享按钮文字描述
- (NSMutableArray *)canDisplayShareButtonDescripitons:(BOOL)isWeiXinInstalled and:(BOOL)isWeiBoInstalled and:(BOOL)isQQInstalled {
    NSMutableArray *mutalbleArray = [NSMutableArray array];
    if (isWeiXinInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"微信好友",@"微信朋友圈"]];
    }
    if (isWeiBoInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"新浪微博"]];
    }
    if (isQQInstalled) {
        [mutalbleArray addObjectsFromArray:@[@"QQ好友",@"QQ空间"]];
    }
    return mutalbleArray;
}
#pragma mark - 可以显示的按钮tag
- (NSMutableArray *)canDisplayShareButtonTags:(BOOL)isWeiXinInstalled and:(BOOL)isWeiBoInstalled and:(BOOL)isQQInstalled {
    NSMutableArray *mutalbleArray = [NSMutableArray array];
    if (isWeiXinInstalled) {
        [mutalbleArray addObjectsFromArray:@[@10001,@10002]];
    }
    if (isWeiBoInstalled) {
        [mutalbleArray addObjectsFromArray:@[@10003]];
    }
    if (isQQInstalled) {
        [mutalbleArray addObjectsFromArray:@[@10004,@10005]];
    }
    return mutalbleArray;
}

#pragma mark - 统一点击图片响应：（url）
- (void)shareResponse:(int)buttonTag andParameter:(NSMutableDictionary *)shareParameters{
     NSString *title = (NSString *)[shareParameters GJSObjectFortKeySafe:@"title"];
     NSString *content = (NSString *)[shareParameters GJSObjectFortKeySafe:@"content"];
     NSString *imageUrl = (NSString *)[shareParameters GJSObjectFortKeySafe:@"imageUrl"];
     NSString *linkUrl = (NSString *)[shareParameters GJSObjectFortKeySafe:@"linkUrl"];
    
    
    switch ( buttonTag) {
            
        case 10001:
//            NSLog(@"微信好友");
            [[self class] wxShareWithType:WXSceneSession TitleString:title contentString:content imageUrlString:imageUrl linkUrlString:linkUrl];
            break;
            
        case 10002:
//            NSLog(@"微信朋友圈");
            [[self class] wxShareWithType:WXSceneTimeline TitleString:title contentString:content imageUrlString:imageUrl linkUrlString:linkUrl];
            break;
            
        case 10003:
//            NSLog(@"微博");
            [[self class] wbShareWithTitleString:title contentString:content imageUrlString:imageUrl linkUrlString:linkUrl];
            break;
            
        case 10004:
//            NSLog(@"QQ好友");
            [[self class] qqShareWithType:QQShare_Friends TitleString:title contentString:content imageUrlString:imageUrl linkUrlString:linkUrl];
            break;
            
        case 10005:
//            NSLog(@"QQ空间");
            [[self class] qqShareWithType:QQShare_Qzone TitleString:title contentString:content imageUrlString:imageUrl linkUrlString:linkUrl];
            break;
            
        default:
            
            break;
    }
    
    
}

#pragma mark - 统一点击图片响应：（image）
- (void)shareResponse:(int)buttonTag andImageParameter:(NSMutableDictionary *)shareParameters{
    NSString *title = (NSString *)[shareParameters GJSObjectFortKeySafe:@"title"];
    NSString *content = (NSString *)[shareParameters GJSObjectFortKeySafe:@"content"];
    UIImage *image = (UIImage *)[shareParameters GJSObjectFortKeySafe:@"image"];
    NSString *linkUrl = (NSString *)[shareParameters GJSObjectFortKeySafe:@"linkUrl"];
    
    
    switch ( buttonTag) {
            
        case 10001:
            //            NSLog(@"微信好友");
            [[self class] wxShareWithType:WXSceneSession TitleString:title contentString:content image:image linkUrlString:linkUrl];
            break;
            
        case 10002:
            //            NSLog(@"微信朋友圈");
            [[self class] wxShareWithType:WXSceneTimeline TitleString:title contentString:content image:image linkUrlString:linkUrl];
            break;
            
        case 10003:
            //            NSLog(@"微博");
            [[self class] wbShareWithTitleString:title contentString:content image:image linkUrlString:linkUrl];
            
        case 10004:
            //            NSLog(@"QQ好友");
            [[self class] qqShareWithType:QQShare_Friends TitleString:title contentString:content image:image linkUrlString:linkUrl];
            break;
            
        case 10005:
            //            NSLog(@"QQ空间");
            [[self class] qqShareWithType:QQShare_Qzone TitleString:title contentString:content image:image linkUrlString:linkUrl];
            break;
            
        default:
            
            break;
    }
    
    
}

#pragma mark - 微信分享(imageUrl)
+ (void )wxShareWithType:(enum WXScene)wxType
                 TitleString:(NSString *)title
               contentString:(NSString *)content
              imageUrlString:(NSString *)imageUrl
               linkUrlString:(NSString *)linkUrl {
    if (![WXApi isWXAppInstalled]) {
        Show_iToast(@"分享平台[微信]尚未安装客户端！无法进行分享");
        return;
    }
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = content;
//    NSURL *url = [NSURL URLWithString:imageUrl];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    if (image) {
//        // url图片
//        [message setThumbImage:image];
//    } else {
//        // 本地图片
//        [message setThumbImage:[UIImage imageNamed:@"icon80x80"]];
//    }
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = linkUrl;
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = wxType;
//    [WXApi sendReq:req];
    
    GJSShareManager *manager = [GJSShareManager manager];

    if (imageUrl && ![imageUrl isNullStr]) {
/*2秒内拿到结果，立刻分享（可能拿到结果，但结果为空，已在webview中作处理） */
        NSURL *url = [NSURL URLWithString:imageUrl];
        __block NSData * data = [NSData data];
        dispatch_queue_t globalQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image && !manager.isDefaultData) {
                manager.isNewData = YES;
                [manager sendMessageWithType:wxType TitleString:title contentString:content image:image linkUrlString:linkUrl];
            }
        });
/*2秒内没拿到结果，分享默认图片 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!manager.isNewData) {
                UIImage *image = [UIImage imageNamed:@"icon80x80"];
                [manager sendMessageWithType:wxType TitleString:title contentString:content image:image linkUrlString:linkUrl];
                manager.isDefaultData = YES;
            }
        });
        
    } else {
/*返回为空字符串，分享默认图片 */
        UIImage *image = [UIImage imageNamed:@"icon80x80"];
        [manager sendMessageWithType:wxType TitleString:title contentString:content image:image linkUrlString:linkUrl];
    }

}
#pragma mark - 微信分享实例方法（image）
- (void)sendMessageWithType:(enum WXScene)wxType
                TitleString:(NSString *)title
              contentString:(NSString *)content
             image:(UIImage *)image
              linkUrlString:(NSString *)linkUrl {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    [message setThumbImage:image];
 
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = linkUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = wxType;
    [WXApi sendReq:req];
    
    //收起弹框
    [self dismissAlertViewController];
}

#pragma mark - 微信分享类方法（image）
+ (void)wxShareWithType:(enum WXScene)wxType
                TitleString:(NSString *)title
              contentString:(NSString *)content
                      image:(UIImage *)image
              linkUrlString:(NSString *)linkUrl {
    
    if (![WXApi isWXAppInstalled]) {
        Show_iToast(@"分享平台[微信]尚未安装客户端！无法进行分享");
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = linkUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = wxType;
    [WXApi sendReq:req];
    
    //收起弹框
    [self dismissAlertViewController];
}

#pragma mark - 微博分享（url）
+ (void )wbShareWithTitleString:(NSString *)title
           contentString:(NSString *)content
          imageUrlString:(NSString *)imageUrl
           linkUrlString:(NSString *)linkUrl {
    if (![WeiboSDK isWeiboAppInstalled]) {
        Show_iToast(@"分享平台[新浪微博]尚未安装客户端！无法进行分享");
        return;
    }
/*授权 */
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://www.sina.com";
    authRequest.scope = @"all";
/*图片 */
    WBImageObject *imageObject = [WBImageObject object];
    NSData *imageData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    if (imageData) {
        // url图片
        imageObject.imageData = imageData;
    } else {
        // 本地图片
        imageObject.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon80x80"]);
    }
    
/*分享的消息体 */
    WBMessageObject *message = [WBMessageObject message];
    message.text = FMT_STR(@"%@%@",content,linkUrl);
    message.imageObject = imageObject;
    /**
     返回一个 WBSendMessageToWeiboRequest 对象
     当用户安装了可以支持微博客户端內分享的微博客户端时,会自动唤起微博并分享
     当用户没有安装微博客户端或微博客户端过低无法支持通过客户端內分享的时候会自动唤起SDK內微博发布器
     @param message 需要发送给微博的消息对象
     @param authRequest 授权相关信息,与access_token二者至少有一个不为空,当access_token为空并且需要弹出SDK內发布器时会通过此信息先进行授权后再分享
     @param access_token 第三方应用之前申请的Token,当此值不为空并且无法通过客户端分享的时候,会使用此token进行分享。
     @return 返回一个*自动释放的*WBSendMessageToWeiboRequest对象
     */
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];

    //收起弹框
    [self dismissAlertViewController];
}
#pragma mark - 微博分享（image）
+ (void )wbShareWithTitleString:(NSString *)title
                  contentString:(NSString *)content
                 image:(UIImage *)image
                  linkUrlString:(NSString *)linkUrl {
    if (![WeiboSDK isWeiboAppInstalled]) {
        Show_iToast(@"分享平台[新浪微博]尚未安装客户端！无法进行分享");
        return;
    }
    /*授权 */
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://www.sina.com";
    authRequest.scope = @"all";
    /*图片 */
    WBImageObject *imageObject = [WBImageObject object];
    NSData *imageData =  UIImagePNGRepresentation(image)?UIImageJPEGRepresentation(image,1.0f):UIImagePNGRepresentation(image);
    if (imageData) {
        // url图片
        imageObject.imageData = imageData;
    } else {
        // 本地图片
        imageObject.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon80x80"]);
    }
    
    /*分享的消息体 */
    WBMessageObject *message = [WBMessageObject message];
    message.text = FMT_STR(@"%@%@",content,linkUrl);
    message.imageObject = imageObject;
    /**
     返回一个 WBSendMessageToWeiboRequest 对象
     当用户安装了可以支持微博客户端內分享的微博客户端时,会自动唤起微博并分享
     当用户没有安装微博客户端或微博客户端过低无法支持通过客户端內分享的时候会自动唤起SDK內微博发布器
     @param message 需要发送给微博的消息对象
     @param authRequest 授权相关信息,与access_token二者至少有一个不为空,当access_token为空并且需要弹出SDK內发布器时会通过此信息先进行授权后再分享
     @param access_token 第三方应用之前申请的Token,当此值不为空并且无法通过客户端分享的时候,会使用此token进行分享。
     @return 返回一个*自动释放的*WBSendMessageToWeiboRequest对象
     */
    //    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    //    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
    //                         @"Other_Info_1": [NSNumber numberWithInt:123],
    //                         @"Other_Info_2": @[@"obj1", @"obj2"],
    //                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
    
    //收起弹框
    [self dismissAlertViewController];
}
#pragma mark - QQ分享(url)
+ (void )qqShareWithType:(enum QQShare_Type)qqType
             TitleString:(NSString *)title
           contentString:(NSString *)content
          imageUrlString:(NSString *)imageUrl
           linkUrlString:(NSString *)linkUrl {
    
    if (![QQApiInterface isQQInstalled]) {
        Show_iToast(@"分享平台[QQ]尚未安装客户端！无法进行分享");
        return;
    }
    NSURL *linkImageUrl = [NSURL URLWithString:linkUrl];
    NSURL *shareImageUrl = [NSURL URLWithString:imageUrl];
    
    //通过QQAPIObject来创建将要分享的对象
    QQApiObject *newsObj = [[QQApiObject alloc] init];
    if (shareImageUrl) {
            // url图片
           newsObj = [QQApiNewsObject objectWithURL:linkImageUrl title:title description:content previewImageURL:shareImageUrl targetContentType:QQApiURLTargetTypeNews];
    } else {
            // 本地图片
        newsObj = [QQApiNewsObject objectWithURL:linkImageUrl title:title description:content previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"icon80x80"]) targetContentType:QQApiURLTargetTypeNews];
    }
 
    //设置分享Req对象
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    switch (qqType)
    {
            //分享给QQ好友
        case QQShare_Friends:
        {
            [QQApiInterface sendReq:req];
            //收起弹框
            [self dismissAlertViewController];
            break;
        }
            //分享给QQ空间
        case QQShare_Qzone:
        {
            [QQApiInterface SendReqToQZone:req];
            //收起弹框
            [self dismissAlertViewController];
            break;
        }
        default:
            break;
    }

}

#pragma mark - QQ分享(image)
+ (void )qqShareWithType:(enum QQShare_Type)qqType
             TitleString:(NSString *)title
           contentString:(NSString *)content
          image:(UIImage *)image
           linkUrlString:(NSString *)linkUrl {
    
    if (![QQApiInterface isQQInstalled]) {
        Show_iToast(@"分享平台[QQ]尚未安装客户端！无法进行分享");
        return;
    }
    NSURL *linkImageUrl = [NSURL URLWithString:linkUrl];
    NSData *imageData =  UIImagePNGRepresentation(image)?UIImageJPEGRepresentation(image,1.0f):UIImagePNGRepresentation(image);
    //通过QQAPIObject来创建将要分享的对象
    QQApiObject *newsObj = [[QQApiObject alloc] init];
    if (imageData && ![imageData isNilObj]) {
        // image图片
        newsObj = [QQApiNewsObject objectWithURL:linkImageUrl title:title description:content previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];
        
    } else {
        // 本地图片
        newsObj = [QQApiNewsObject objectWithURL:linkImageUrl title:title description:content previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"icon80x80"]) targetContentType:QQApiURLTargetTypeNews];
    }
    
    //设置分享Req对象
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    switch (qqType)
    {
            //分享给QQ好友
        case QQShare_Friends:
        {
            [QQApiInterface sendReq:req];
            //收起弹框
            [self dismissAlertViewController];
            break;
        }
            //分享给QQ空间
        case QQShare_Qzone:
        {
            [QQApiInterface SendReqToQZone:req];
            //收起弹框
            [self dismissAlertViewController];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark - 返回30K的image
+ (UIImage *)returnImageWithImage:(UIImage *)image {
    
  NSData * imageData = UIImageJPEGRepresentation(image,1);
   CGFloat  length = [imageData length]/1024;
    if (length > 30) {
        UIImage *newImage = [self compressImageSize:image toByte:30 * 1024];
        return newImage;
    } else {
        return image;
    };
}

#pragma mark - 压缩图片到指定大小
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}

#pragma mark - 单例实例
+ (GJSShareManager *)manager
{
    static GJSShareManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GJSShareManager alloc] init];
    });
    
    return _sharedInstance;
}

@end



@implementation GJSAlertController

- (void)shareFunction:(UIButton *)imageButton
{
    if (self.shareButtonBlock) {
        self.shareButtonBlock((int )imageButton.tag);
    }
}

@end

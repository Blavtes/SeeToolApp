//
//  GJSShareManager.h
//  GjFax
//
//  Created by gjfax on 2017/8/3.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信相关：http://open.weixin.qq.com
#define ShareModule_WeChat_AppID               @"wxe601b71af2f471d9"//@"wx7cbda2643bc8fef2"
#define ShareModule_WeChat_AppSecret           @"c88c67691f4c9b3bd789fb1a9abcf9f5"//@"319eac587bbb99887593c473bbd76b17"

//微博相关：http://open.weibo.com
#define ShareModule_SinaWeibo_AppKey           @"2009276461"
#define ShareModule_SinaWeibo_AppSecret        @"01e307b32e77d1fba740e81da5acd4c3"
#define ShareModule_SinaWeibo_AppRedirectUri   @"https://www.gjfax.com"


//QQ相关：http://open.qq.com/
//URL schemes :QQ41DB8C01, tencent1104907265 这2个必须填写。
//其中，QQ+16进制appID 1104907265的16进制：41DB8C01   1104360125的16进制：41D332BD
#define ShareSDK_QQAndQZone_AppID           @"1104360125"//@"1104907265"
#define ShareSDK_QQAndQZone_AppKey          @"DhdBAM5aKoAFJ8XU" //@"bpiqrM9SS5RVojNK"

typedef NS_ENUM(NSInteger,QQShare_Type) {
    QQShare_Friends = 0,
    QQShare_Qzone = 1,
} ;
@class GJSAlertController;
@interface GJSShareManager : NSObject

 /*单例实例 */
+ (GJSShareManager *)manager;

/*统一注册 */
+ (void)regeistShareModule;

/*统一返回格式的参数（imageUrl） */
+ (NSMutableDictionary *)shareParamsWithTitleString:(NSString *)title
                                      contentString:(NSString *)content
                                     imageUrlString:(NSString *)imageUrl
                                      linkUrlString:(NSString *)linkUrl;
/*统一弹出底部分享sheet（imageUrl） */
+ (void)showShareAlertSheet:(UIViewController *)viewcontroller withParameter:(NSMutableDictionary *)shareParameters;


/*统一返回格式的参数（image） */
+ (NSMutableDictionary *)shareParamsWithTitleString:(NSString *)title
                                      contentString:(NSString *)content
                                      image:        (UIImage *)image
                                      linkUrlString:(NSString *)linkUrl;

/*统一弹出底部分享sheet（image） */
+ (void)showShareAlertSheet:(UIViewController *)viewcontroller withImageParameter:(NSMutableDictionary *)shareParameters;

/*微信分享 */
      /**WXSceneSession     = 0< 聊天界面    */
      /**WXSceneTimeline    = 1< 朋友圈     */
      /**WXSceneFavorite    = 2< 收藏      */

// 图片分享的是url
+ (void )wxShareWithType:(enum WXScene)wxType
           TitleString:(NSString *)title
         contentString:(NSString *)content
        imageUrlString:(NSString *)imageUrl
         linkUrlString:(NSString *)linkUrl;

//  图片分享的是image
+ (void)wxShareWithType:(enum WXScene)wxType
                TitleString:(NSString *)title
              contentString:(NSString *)content
                      image:(UIImage *)image
              linkUrlString:(NSString *)linkUrl;

/*微博分享 */
+ (void )wbShareWithTitleString:(NSString *)title
                  contentString:(NSString *)content
                 imageUrlString:(NSString *)imageUrl
                  linkUrlString:(NSString *)linkUrl;

/*QQ分享 */
     /**QQShare_Friends  = 0< QQ好友    */
     /**QQShare_Qzone    = 1< QQ空间    */
+ (void )qqShareWithType:(enum QQShare_Type)qqType
             TitleString:(NSString *)title
           contentString:(NSString *)content
          imageUrlString:(NSString *)imageUrl
           linkUrlString:(NSString *)linkUrl;


@end


#pragma mark - 监听点击的按钮
typedef void(^ShareButtonBlock)(int buttonTag);
@interface GJSAlertController : UIAlertController
@property (nonatomic, copy) ShareButtonBlock shareButtonBlock;
- (void)shareFunction:(UIButton *)imageButton;

@end

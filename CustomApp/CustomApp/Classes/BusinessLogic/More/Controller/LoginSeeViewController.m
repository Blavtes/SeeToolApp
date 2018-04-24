//
//  LoginSeeViewController.m
//  CustomApp
//
//  Created by Blavtes on 24/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "LoginSeeViewController.h"
#import "HttpToolManager.h"
#import "HttpToolDataEntity.h"


@interface LoginSeeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation LoginSeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)loginClik:(id)sender {
//    _textField.text = @"15820498438";
    if (_textField.text.length > 0) {
        HttpToolDataEntity *entity = [HttpToolDataEntity new];
        entity.urlString = @"http://shyl8.net/HyArtifact0603.php";
        entity.parameters = [NSDictionary dictionaryWithObjectsAndKeys:_textField.text,@"hiyu_agentLogin", nil];
        __weak typeof(self) weakSelf = self;
        
        [HttpToolManager htm_request_GETWithEntity:entity successBlock:^(id response) {
            NSLog(@"response %@",response);
            NSString *ret = [response[0] objectForKeyForSafetyValue:@"ret"];
            if ([ret isEqualToString:@"0"]) {
                if (weakSelf.loginBlock) {
                    weakSelf.loginBlock(weakSelf.textField.text);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } else {
                Show_iToast(ret);
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"failureBlock %@",error);

        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

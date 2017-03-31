//
//  SettingVC.m
//  music
//
//  Created by sghy on 17/3/11.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "SettingVC.h"
#import "SDImageCache.h"
#import <UMSocialCore/UMSocialCore.h>

@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *dataSizeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoIcn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *outLoginBtn;

@end

@implementation SettingVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self jiSuanSize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[Config share] isLogin])
    {
        [_photoIcn sd_setImageWithURL:[NSURL URLWithString:[[Config share] getUserIcn]]];
        _userNameLab.text = [[Config share] getUserName];
    }
    else
    {
        [_photoIcn sd_setImageWithURL:[NSURL URLWithString:@""]];
        _userNameLab.text = @"使用第三方登录";
        _outLoginBtn.hidden = YES;
    }
}
- (void)jiSuanSize
{
    //计算缓存大小
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    //
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[NSString fileSizeWithInterge:intg]];
    
    [_dataSizeBtn setTitle:[NSString stringWithFormat:@"缓存大小(%@)",currentVolum] forState:UIControlStateNormal];
}
- (IBAction)ThirdTypeClick:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    UMSocialPlatformType  platformType;
    switch (btn.tag)
    {
        case 0:
        {
            platformType = UMSocialPlatformType_QQ;
        }
            break;
        case 1:
        {
            platformType = UMSocialPlatformType_WechatSession;
        }
            break;
        case 2:
        {
            platformType = UMSocialPlatformType_Sina;
        }
            break;
        default:
            break;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if(error)
        {
            return ;
        }
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        [_photoIcn sd_setImageWithURL:[NSURL URLWithString:resp.iconurl]];
        _userNameLab.text = resp.name;
        
        [[Config share] saveIsLogin:YES];
        [[Config share] saveUserName:resp.name];
        [[Config share] saveUserIcn:resp.iconurl];
         _outLoginBtn.hidden = NO;
    }];
}
- (IBAction)outLogin:(id)sender {
     [[Config share] saveIsLogin:NO];
    _outLoginBtn.hidden = YES;
    [_photoIcn sd_setImageWithURL:[NSURL URLWithString:@""]];
    _userNameLab.text = @"使用第三方登录";
}

- (IBAction)clearBtnClick:(UIButton *)sender {
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self jiSuanSize];
    }];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}
@end

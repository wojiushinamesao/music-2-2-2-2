//
//  SharePlayMusicVC.m
//  music
//
//  Created by sghy on 17/3/10.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "SharePlayMusicVC.h"

@interface SharePlayMusicVC ()

@end

@implementation SharePlayMusicVC

+ (SharePlayMusicVC *)sharedManager
{
    static SharePlayMusicVC *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        if(manager == nil)
        {
            manager = [[SharePlayMusicVC alloc]init];
        }
    } );
    return manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

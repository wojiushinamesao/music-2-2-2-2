//
//  NewsDetail.m
//  music
//
//  Created by sghy on 17/3/16.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "NewsDetail.h"
#import "ViewController.h"
@interface NewsDetail ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
@end

@implementation NewsDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -110, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.detailUrlStr]]]];
    [self.view addSubview:self.webView];
    
    
    UIBarButtonItem * rightItm = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(rightItmClick)];
    self.navigationItem.rightBarButtonItem = rightItm;
    
}
- (void)rightItmClick
{
    ViewController * vc = [[ViewController alloc]init];
    vc.isNewsShare = YES;
    vc.shareTitle = _shareTitle;
    vc.shareImageStr = _shareImageStr;
    vc.detailUrlStr = _detailUrlStr;
    [vc shareApp:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
@end

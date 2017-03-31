//
//  routeVCViewController.m
//  music
//
//  Created by sghy on 17/3/27.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "routeVCViewController.h"

@interface routeVCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *busBtn;
@property (weak, nonatomic) IBOutlet UIButton *walkBtn;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet UITextField *endTF;

@property (weak, nonatomic) IBOutlet UITextField *startTF;
@end

@implementation routeVCViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"路线规划";
    
    _busBtn.backgroundColor = [UIColor blueColor];
    [_busBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _walkBtn.backgroundColor = [UIColor whiteColor];
    [_walkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _carBtn.backgroundColor = [UIColor whiteColor];
    [_carBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTF:) name:RouteChangeTF object:nil];
}
- (void)changeTF:(NSNotification *)noti
{
    NSDictionary * dic = (NSDictionary *)noti.object;
    if ([dic.allKeys containsObject:@"end"])
    {
        _endTF.text = dic[@"end"];
    }
    else
    {
        _startTF.text = dic[@"start"];
    }
}
- (IBAction)routeType:(UIButton *)sender
{
    [self updateBtnStatue:sender];
}
- (IBAction)startTF:(UITextField *)sender {
    [_startTF resignFirstResponder];
    if (_backBlock)
    {
        _backBlock(searchStart);
    }
}
- (IBAction)endTF:(UITextField *)sender {
    [_endTF resignFirstResponder];
    if (_backBlock)
    {
        _backBlock(searchEnd);
    }
}
- (IBAction)searchClick:(UIButton *)sender
{
    if (_startTF.text.length == 0 ||  _endTF.text.length ==0)
    {
        [PubFunction showMessage:@"请选择起始位置" keepTime:1.5];
        return;
    }
    if (_routeBlock)
    {
        _routeBlock(_startTF.text,_endTF.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)updateBtnStatue:(UIButton *)btn
{
    if (btn == _busBtn)
    {
        _busBtn.backgroundColor = [UIColor blueColor];
        [_busBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _walkBtn.backgroundColor = [UIColor whiteColor];
        [_walkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _carBtn.backgroundColor = [UIColor whiteColor];
        [_carBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    else if (btn == _walkBtn)
    {
        _busBtn.backgroundColor = [UIColor whiteColor];
        [_busBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _walkBtn.backgroundColor = [UIColor blueColor];
        [_walkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _carBtn.backgroundColor = [UIColor whiteColor];
        [_carBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    else if (btn == _carBtn)
    {
        _busBtn.backgroundColor = [UIColor whiteColor];
        [_busBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _walkBtn.backgroundColor = [UIColor whiteColor];
        [_walkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _carBtn.backgroundColor = [UIColor blueColor];
        [_carBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
@end

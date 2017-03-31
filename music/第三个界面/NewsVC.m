//
//  NewsVC.m
//  music
//
//  Created by sghy on 17/3/16.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "NewsVC.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "NewsDetail.h"
@interface NewsVC ()
@property (nonatomic, strong) FirstViewController * firstVC;
@property (nonatomic, strong) SecondViewController * secondVC;
@property (nonatomic, strong) ThreeViewController * threeVC;

@property (nonatomic ,strong) UIViewController *currentVC;
@property (nonatomic ,strong) UIScrollView *headScrollView;  //  顶部滚动视图
@property (nonatomic ,strong) NSArray *headArray;
@property (nonatomic ,strong) NSString *newsType;
@property (nonatomic ,assign) NSInteger typeTag;
@end

@implementation NewsVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)customNav
{
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    title.text = @"新闻";
    title.textAlignment = 1;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:17];
    [navView addSubview:title];
    [self.view addSubview:navView];
}
#pragma mark 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNav];
    self.title = @"新闻";
    self.headArray = @[@"娱乐",@"科技",@"军事"];
    /**
     *   automaticallyAdjustsScrollViewInsets   又被这个属性坑了
//     */
    self.headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    self.headScrollView.backgroundColor = RGBCOLOR(221, 221, 221);
    self.headScrollView.contentSize = CGSizeMake(560, 0);
    self.headScrollView.bounces = NO;
    self.headScrollView.pagingEnabled = YES;
    [self.view addSubview:self.headScrollView];
    for (int i = 0; i < [self.headArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0 + i*80, 0, 80, 40);
        [button setTitle:[self.headArray objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i + 100;
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headScrollView addSubview:button];
        if (i == 0)
        {
            button.backgroundColor = [UIColor grayColor];
        }
    }
    
    //先创建 和添加一个默认的控制器
    self.firstVC = [[FirstViewController alloc] init];
    [self.firstVC.view setFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-40-TAB_BAR_HEIGHT)];
    [self addChildViewController:_firstVC];
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.firstVC.view];
    
    self.secondVC = [[SecondViewController alloc] init];
    [self.secondVC.view setFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-40-TAB_BAR_HEIGHT)];
    
    self.threeVC = [[ThreeViewController alloc] init];
    [self.threeVC.view setFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-40-TAB_BAR_HEIGHT)];
    
    //储存当前选择的控制器
    self.currentVC = self.firstVC;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNewsDetailPage:) name:NEWS_GO_Detail object:nil];
}
- (void)changeBrnState
{
    for (UIButton *btn in self.headScrollView.subviews)
    {
        if (btn.tag == _typeTag)
        {
            btn.backgroundColor = [UIColor grayColor];
        }
        else
        {
            btn.backgroundColor = RGBCOLOR(221, 221, 221);
        }
    }
}
#pragma mark 跳转到详情页
- (void)goNewsDetailPage:(NSNotification *)noti
{
    NSDictionary * dic = (NSDictionary *)noti.object;
    NewsDetail * detailVC = [[NewsDetail alloc]init];
    detailVC.detailUrlStr = dic[@"docurl"];
    detailVC.shareTitle = dic[@"title"];
    detailVC.shareImageStr = dic[@"imgurl"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 顶部滚动按钮点击事件
- (void)didClickHeadButtonAction:(UIButton *)button
{
    //  点击处于当前页面的按钮,直接跳出
    if ((self.currentVC == self.firstVC && button.tag == 100)||(self.currentVC == self.secondVC && button.tag == 101)||( self.currentVC == self.threeVC && button.tag == 102))
    {
        return;
    }else
    {
        switch (button.tag) {
            case 100:
            {
                [self replaceController:self.currentVC newController:self.firstVC];
                _newsType = @"ent";
                _typeTag = 100;
            }
                break;
            case 101:
            {
                [self replaceController:self.currentVC newController:self.secondVC];
                _newsType = @"tech";
                _typeTag = 101;
            }
                break;
            case 102:
            {
                [self replaceController:self.currentVC newController:self.threeVC];
                _newsType = @"war";
                _typeTag = 102;
            }
                break;
            default:
                break;
        }
    }
    [self changeBrnState];
}
#pragma mark 切换控制器
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:2 options:UIViewAnimationOptionAllowUserInteraction animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_newsType,@"type", nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NEWS_RELODATA object:dic];
        }else{
            
            self.currentVC = oldController;
        }
    }];
}
@end

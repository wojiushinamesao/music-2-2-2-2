//
//  mainTableViewCell.m
//  music
//
//  Created by sghy on 17/3/16.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "mainTableViewCell.h"
@interface mainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icnImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation mainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}
- (void)drawDic:(NSDictionary *)dic
{
//    [_icnImage sd_setImageWithURL:[NSURL URLWithString:dic[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"default_iamgeView.jpg"]];
//    _titleLab.text = dic[@"title"];
}
@end

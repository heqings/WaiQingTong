//
//  ApplyViewDetailViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApplyViewDetailViewController.h"

@implementation ApplyViewDetailViewController
@synthesize type,scroll,apply,applyTime;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"申请详情";
    
    applyTime.text=apply.applyTime;
    
    UIImage *img;
    if([apply.appType isEqualToString:@"H"]){
        type.text=@"活动";
         img= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shenqing_icon_hd" ofType:@"png"]];

    }else if([apply.appType isEqualToString:@"F"]){
         type.text=@"费用";
        img= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shenqing_icon_fy" ofType:@"png"]];
    }else if([apply.appType isEqualToString:@"C"]){
         type.text=@"出差";
        img= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shenqing_icon_cc" ofType:@"png"]];
    }else if([apply.appType isEqualToString:@"Q"]){
         type.text=@"其他";
        img= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shenqing_icon_qt" ofType:@"png"]];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    imageView.frame=CGRectMake(30, 20, 45, 45);
    [self.scroll addSubview:imageView];
    
    UIFont *fontOne = [UIFont systemFontOfSize:17.0];//设置字体大小
    CGSize maximumLabelSizeOne = CGSizeMake(194,MAXFLOAT);
    CGSize expectedLabelSizeOne = [apply.content sizeWithFont:fontOne
                                              constrainedToSize:maximumLabelSizeOne
                                                  lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect pointValueRect = CGRectMake(106, 143 ,194, expectedLabelSizeOne.height);
    UILabel *info = [[UILabel alloc] initWithFrame:pointValueRect];
    info.lineBreakMode = UILineBreakModeWordWrap;
    info.numberOfLines = 0;
    info.text = apply.content;
    
    [self.scroll addSubview:info];
    
    scroll.contentSize=CGSizeMake(320,expectedLabelSizeOne.height+143);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    apply=nil;
    scroll=nil;
}

@end

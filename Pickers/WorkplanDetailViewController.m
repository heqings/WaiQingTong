//
//  WorkplanDetailViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WorkplanDetailViewController.h"

@implementation WorkplanDetailViewController
@synthesize workLog,scroll,starTime,endTime,type;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"工作详情";
    
    starTime.text=workLog.startTime;
    endTime.text=workLog.endTime;
    
    if([workLog.type isEqualToString:@"P"]){
        type.text=@"工作计划";
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"workicon_2" ofType:@"png"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
         imageView.frame=CGRectMake(30, 112, 45, 45);
        [self.scroll addSubview:imageView];
    }else{
        type.text=@"工作总结";
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"workicon_1" ofType:@"png"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        imageView.frame=CGRectMake(30, 112, 45, 45);
        [self.scroll addSubview:imageView];
    }
    
    UIFont *fontOne = [UIFont systemFontOfSize:17.0];//设置字体大小
    CGSize maximumLabelSizeOne = CGSizeMake(194,MAXFLOAT);
    CGSize expectedLabelSizeOne = [workLog.content sizeWithFont:fontOne
                                       constrainedToSize:maximumLabelSizeOne
                                           lineBreakMode:UILineBreakModeWordWrap];
    
  
    CGRect pointValueRect = CGRectMake(106, 286 ,194, expectedLabelSizeOne.height);
    UILabel *info = [[UILabel alloc] initWithFrame:pointValueRect];
    info.lineBreakMode = UILineBreakModeWordWrap;
    info.numberOfLines = 0;
    info.text = workLog.content;
    
    [self.scroll addSubview:info];

    scroll.contentSize=CGSizeMake(320,expectedLabelSizeOne.height+286);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    workLog=nil;
    scroll=nil;
}

@end

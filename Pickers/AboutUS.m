//
//  AboutUS.m
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutUS.h"


@implementation AboutUS
@synthesize versionLab;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationItem.title=@"关于我们";
    NSString *currentVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionLab.text=currentVersion;

    UIImage *img=[UIImage imageNamed:@"logo"];
    UIImageView *imgView=[[UIImageView alloc]init];
    imgView.image=img;
    imgView.frame=CGRectMake(64,40, 176, 46);
    
    [self.view addSubview:imgView];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(IBAction)callTel:(id)sender{
    [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:@"telprompt://400-168-0756"]];
}

@end

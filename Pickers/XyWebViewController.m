//
//  XyWebViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XyWebViewController.h"

@implementation XyWebViewController
@synthesize scroll;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSString *msg=@"为了更有效地使用易协作服务，促进业务的健康、有序发展，企业单位在使用易协作服务中，做出如下承诺：\n一、遵守国家有关法律、法规和政策。\n二、严格遵守国家有关电信行业的法律法规和信息产业部关于电信业务使用的各项规定。\n三、遵循诚实、信用的原则，遵守商业道德。在规定的业务范围内使用易协作。不转让或变相转让易协作使用权，并保证业务开通后在《易协作服务使用协议》规定的期限内不取消。\n四、企业单位因不当使用易协作造成的一切后果，特别是与终端用户的隐私纠纷，由企业单位自行承担，与珠海高泰信息科技有限公司无关。\n五、建立完善安全保密体系，保守商业秘密，保护公民的隐私。不得向他人提供终端用户定位位置信息，国家法律另有规定的除外。\n六、保证不发生下列行为：1、在未征得终端用户本人任何形式的同意之前，擅自对该终端用户定位；2、擅自将该终端用户位置信息泄露给他人；3、将易协作作为其它非法用途。若发生以上行为，由企业单位自行承担一切后果和法律责任，与珠海高泰信息科技有限公司无关。\n七、如实提供材料，保证所提供资料的真实、完整。\n八、如企业单位违反上述承诺，珠海高泰信息科技有限公司保留停止服务并解除《易协作服务使用协议》的权利。";
    UIFont *fontOne = [UIFont systemFontOfSize:17.0];//设置字体大小
    CGSize maximumLabelSizeOne = CGSizeMake(280,MAXFLOAT);
    CGSize expectedLabelSizeOne = [msg sizeWithFont:fontOne
                                  constrainedToSize:maximumLabelSizeOne
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect pointValueRect = CGRectMake(20, 20 ,280, expectedLabelSizeOne.height);
    UILabel *info = [[UILabel alloc] initWithFrame:pointValueRect];
    info.backgroundColor=[UIColor clearColor];
    info.lineBreakMode = UILineBreakModeWordWrap;
    info.numberOfLines = 0;
    info.text = msg;
    
    [self.scroll addSubview:info];
    
    scroll.contentSize=CGSizeMake(320,expectedLabelSizeOne.height+30);
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
     scroll=nil;
    [super viewDidUnload];
}


//返回按钮事件
-(IBAction)backBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


@end

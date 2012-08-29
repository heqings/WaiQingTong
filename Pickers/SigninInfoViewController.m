//
//  SigninInfoViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SigninInfoViewController.h"

@interface SigninInfoViewController (private)
-(NSInteger)getHeight:(NSString *)param;
@end

@implementation SigninInfoViewController
@synthesize attendance,signIn,poiInfo,scroll,type;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"标注详情";
    
    UIImage *image;           
    if([signIn.signInType isEqualToString:@"KH"]){//客户
        image = [UIImage imageNamed:@"icon_kh"];
        type.text=@"客户";
    }else if([signIn.signInType isEqualToString:@"MD"]){//门店
        image = [UIImage imageNamed:@"icon_qy"];
        type.text=@"门店";
    }else if([signIn.signInType isEqualToString:@"QD"]){//渠道
        image = [UIImage imageNamed:@"icon_qd"];
        type.text=@"渠道";
    }else if([signIn.signInType isEqualToString:@"QT"]){//其他
        image = [UIImage imageNamed:@"icon_qt"];
        type.text=@"其他";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    imageView.frame=CGRectMake(30, 20, 45, 45);
    [self.scroll addSubview:imageView];

    UIFont *font = [UIFont systemFontOfSize:17.0];
    
   //标注名称
    UILabel *nameLab=[[UILabel alloc]init];
    nameLab.frame=CGRectMake(20, 94, 85, 21);
    nameLab.text=@"标注名称：";
    nameLab.font=font;
    
    CGRect nameVal = CGRectMake(106, 94 ,200,[self getHeight:signIn.signInName]);
    UILabel *name=[[UILabel alloc]initWithFrame:nameVal];
    name.text=signIn.signInName;
    name.lineBreakMode = UILineBreakModeWordWrap;
    name.numberOfLines = 0;
    
    [self.scroll addSubview:nameLab];
    [self.scroll addSubview:name];
    
    //标注地址
    UILabel *addressLab=[[UILabel alloc]init];
    addressLab.frame=CGRectMake(20, 111+name.frame.size.height, 85, 21);
    addressLab.text=@"标注地址：";
    addressLab.font=font;
    
    CGRect addressVal = CGRectMake(106, 111+name.frame.size.height ,200,[self getHeight:signIn.signInAddress]);
    UILabel *address = [[UILabel alloc] initWithFrame:addressVal];
    address.lineBreakMode = UILineBreakModeWordWrap;
    address.numberOfLines = 0;
    address.text = signIn.signInAddress;
    
    [self.scroll addSubview:addressLab];
    [self.scroll addSubview:address];
    
    //标注时间
    UILabel *createTime=[[UILabel alloc]init];
    createTime.text=signIn.createTime;
    createTime.frame=CGRectMake(106, 165+address.frame.size.height, 205, 21);
    
    UILabel *createTimeLab=[[UILabel alloc]init];
    createTimeLab.text=@"标注时间：";
    createTimeLab.frame=CGRectMake(20, 165+address.frame.size.height, 85, 21);
    
    [self.scroll addSubview:createTime];
    [self.scroll addSubview:createTimeLab];
    
    //标注描述
    UILabel *remarkLab=[[UILabel alloc]init];
    remarkLab.text=@"标注描述：";
    remarkLab.frame=CGRectMake(20, 225+createTime.frame.size.height, 85, 21);
    
    CGRect remarkVal = CGRectMake(106,225+createTime.frame.size.height,194,[self getHeight:signIn.signInRemark]);
    UILabel *remark = [[UILabel alloc] initWithFrame:remarkVal];
    remark.lineBreakMode = UILineBreakModeWordWrap;
    remark.numberOfLines = 0;
    remark.text = signIn.signInRemark;
    
    [self.scroll addSubview:remarkLab];
    [self.scroll addSubview:remark];
    
    NSArray *arry = [signIn.signInImgUrl componentsSeparatedByString:@","];
    if([arry count]>0){
        NSString *path=[arry objectAtIndex:0];
        
        UIImage *signinImg=[[UIImage alloc] initWithContentsOfFile:path];
        
        UIImageView *signinImgView = [[UIImageView alloc] initWithImage:[signinImg stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        signinImgView.frame=CGRectMake(25, 260+remark.frame.size.height, 270, 180);
        
        signinImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [signinImgView addGestureRecognizer:singleTap];
        
        [self.scroll addSubview:signinImgView];
        
        scroll.contentSize=CGSizeMake(320,260+remark.frame.size.height+190);
    }else{
        scroll.contentSize=CGSizeMake(320,225+createTime.frame.size.height+[self getHeight:signIn.signInRemark]);
    }
}

-(void)imgClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    MainViewController *m=[[MainViewController alloc]init];
    m.array=[signIn.signInImgUrl componentsSeparatedByString:@","];
    [self.navigationController pushViewController:m animated:true];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    signIn=nil;
    poiInfo=nil;
    attendance=nil;
    scroll=nil;

}

-(NSInteger)getHeight:(NSString *)param{
    UIFont *fontOne = [UIFont systemFontOfSize:17.0];//设置字体大小
    CGSize maximumLabelSizeOne = CGSizeMake(200,MAXFLOAT);
    CGSize expectedLabelSizeOne = [param sizeWithFont:fontOne
                                                  constrainedToSize:maximumLabelSizeOne
                                                      lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSizeOne.height;
}

@end

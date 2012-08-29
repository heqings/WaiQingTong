//
//  MessageInfoViewController.m
//  Pickers
//
//  Created by 张飞 on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageInfoViewController.h"

@implementation MessageInfoViewController
@synthesize scroll,button,nameLabel,depLabel,openTelBtn,openMettingBtn,loginLabel,nickeLabel,img,bodyView;

#pragma mark - View lifecycle

//创建返回按钮，页面跳转动画
-(void)pageForward{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    //self.navigationItem.backBarButtonItem= backbutton;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.title=@"个人信息";
    People *people=[[PeopleServices getConnection]findBySpId:[[NSUserDefaults standardUserDefaults] integerForKey:@"choosePeople"]];
    img.image=[Global getPeopleTopImage:people];
    nameLabel.text=people.name;
    depLabel.text=[NSString stringWithFormat:@"部门：",people.groupDp];
    loginLabel.text=[NSString stringWithFormat:@"(登录帐号：%@)",people.mobile];
    nickeLabel.text=[NSString stringWithFormat:@"昵称：%@",people.nicke];
    
    scroll.contentSize=CGSizeMake(320,418);    
    button.backgroundColor=[UIColor clearColor];
    segmentedControl = [[UISegmentedControl alloc]init];    
    segmentedControl.frame = CGRectMake(10.0, 178.0, 300.0, 54.0);   
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;//设置样式  
    segmentedControl.momentary = YES;//设置在点击后是否恢复原样  
    [segmentedControl addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventValueChanged];
    //UIColor *myTint = [[ UIColor alloc]initWithRed:235 green:235 blue:235 alpha:0.8];
    //segmentedControl.tintColor = myTint;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 54)];
    UIImage *img=[UIImage imageNamed:@"bodyinfo_font_kq"];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, 35, 35)];
    imgView.image=img;
    [view addSubview:imgView];
    [segmentedControl insertSegmentWithImage:img atIndex:0 animated:YES];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(75, 0, 75, 54)];
    UIImage *img2=[UIImage imageNamed:@"bodyinfo_font_rz"];
    UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, 35, 35)];
    imgView2.image=img2;
    [view2 addSubview:imgView2];
    [segmentedControl insertSegmentWithImage:img2 atIndex:1 animated:YES];

    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(150, 0, 75, 54)];
    UIImage *img3=[UIImage imageNamed:@"bodyinfo_font_sq"];
    UIImageView *imgView3=[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, 35, 35)];
    imgView3.image=img3;
    [view3 addSubview:imgView3];
    [segmentedControl insertSegmentWithImage:img3 atIndex:2 animated:YES];
    
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(225, 0, 75, 54)];
    UIImage *img4=[UIImage imageNamed:@"bodyinfo_font_rw"];
    UIImageView *imgView4=[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, 35, 35)];
    imgView4.image=img4;
    [view4 addSubview:imgView4];
    [segmentedControl insertSegmentWithImage:img4 atIndex:3 animated:YES];
    
   // [scroll addSubview:segmentedControl];

    [button setImage:[UIImage imageNamed:@"bodyinfo_font_smsbtn_r"] forState:UIControlStateHighlighted];
    [openTelBtn setImage:[UIImage imageNamed:@"btn_tel"] forState:UIControlStateNormal];
    [openTelBtn addTarget:self action:@selector(openTel:) forControlEvents:UIControlEventTouchUpInside];
    [openMettingBtn setImage:[UIImage imageNamed:@"btn_metting"] forState:UIControlStateNormal];
    
    
    self.bodyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body_info_bg"]];
    self.bodyView.opaque = NO;
    
    self.scroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_bg"]];
    self.scroll.opaque = NO;
}

-(void)viewDidUnload{
    segmentedControl=nil;
    [super viewDidUnload];
}

//-(void)segmentBtnClick:(id)sender{
//    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
//    switch (myUISegmentedControl.selectedSegmentIndex) {
//        case 0:
//        {
//            [self pageForward];
//            KaoqinViewController *kaoqin = [[KaoqinViewController alloc]init] ;  
//            [self.navigationController pushViewController:kaoqin animated:YES];
//            
//            break;
//        }    
//        case 1:
//        {
//            [self pageForward];
//            WorkplanViewController *work = [[WorkplanViewController alloc]init];  
//            [self.navigationController pushViewController:work animated:YES]; 
//            break;
//        }
//        case 2:
//        {
//            [self pageForward];
//            ApplyViewController *apply = [[ApplyViewController alloc]init];  
//            [self.navigationController pushViewController:apply animated:YES]; 
//            break;
//        }
//        case 3:
//        {
//            [self pageForward];
//            
//            break;
//        }    
//        default:
//            break;
//    }
//}

//语音聊天
-(IBAction)sendMessage:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    //self.navigationController.delegate = self;
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    People *people=[[PeopleServices getConnection]findBySpId:[[NSUserDefaults standardUserDefaults] integerForKey:@"choosePeople"]];
    
    NSMutableArray *serverIds=[[NSMutableArray alloc]init];
    [serverIds addObject:[NSNumber numberWithInteger:people.spId]];
    [serverIds addObject:[NSNumber numberWithInteger:user.userId]];
    
    NSArray* arrayIds = [serverIds sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *idsIdentity=[[NSMutableString alloc]init];
    
    for(int i=0;i<[arrayIds count];i++){
        [idsIdentity appendString:[NSString stringWithFormat:@"%@",[arrayIds objectAtIndex:i]]];
    }

    NSString *identityString = [NSString stringWithFormat:@"%@",idsIdentity];   
    Notify *notify=[[NotifyServices getConnection]findByGroup:identityString];
    if(notify.toUser==nil){
        [[NotifyServices getConnection] insertNotify:people.name isRead:@"Y" readCount:0 ntDate:[Global getCurrentTime] toUser:[NSString stringWithFormat:@"%i",people.spId] groupId:identityString ntType:[Global getNOTIFY_YY] detailText:@""];    
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[NotifyServices getConnection]findByGroup:identityString].ntId forKey:@"notifyId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    OtherViewController *other=[[OtherViewController alloc] init];
    [self.navigationController pushViewController:other animated:YES];
}

//拨打电话
-(void)openTel:(id)sender{
    People *people=[[PeopleServices getConnection]findBySpId:[[NSUserDefaults standardUserDefaults] integerForKey:@"choosePeople"]];
    
    NSString *tel=[NSString stringWithFormat:@"telprompt://%@",people.mobile];
    [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:tel]];
}

//约见
-(IBAction)openMetting:(id)sender{
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"功能尚未实现"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

    /*
    AppointmentViewcontroller *app = [[AppointmentViewcontroller alloc]init]; 
    [self presentModalViewController:app animated:YES];
     */
}

@end

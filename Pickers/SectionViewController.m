//
//  SectionViewController.m
//  Pickers
//
//  Created by HeQing on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtils.h"
#import "SectionViewController.h"
#import "CustomBadge.h"
#import "NetworkUtils.h"
#import "UIRecognizeController.h"
#import "MBProgressHUD.h"
#import "GeneralSettingService.h"
#import "NotifyPlanViewController.h"
#import "JsonServer.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#pragma mark MAC addy

@interface SectionViewController(private)
-(void)hideTabBar:(BOOL)hide;
@end

@implementation SectionViewController
@synthesize table,cellsDataArray;

-(void)downloadGeneralSetting:(NSNotification*)notification
{
    GeneralSettingService* gs = [GeneralSettingService getConnection];
    NSDictionary* dic = [NSDictionary dictionaryWithObject:@"" forKey:@"t_area_people"];
  
    [gs insertGeneralSetting:dic];
}
-(void)userLoginSucceed:(NSNotification*) notification{
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"初始化中..." animated:TRUE];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{ 
            @try{
    
            [self downloadGeneralSetting:nil];
            [self downloadUserinfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSocketServer" object:nil];
                
            [self downloadCompanygates:nil];
            [self downloadClient:nil];    
            //[self downloadAreaPeople:nil];暂时不要下载地区树目录
             //登录
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];  
            }@catch (NSException* e) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([e.name isEqualToString:@"NetError"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参数错误"
                                                                    message:e.reason
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }@finally {
  
            }
        });  
    });  
    
  [[NSUserDefaults standardUserDefaults] setValue:@"Inited" forKey:@"Status"];
}
-(void)updateTermaInfo:(id)temp
{
    NSString* imei=[[NSUserDefaults standardUserDefaults] objectForKey:@"imei"];
    //向服务器请求用户数据
    NSDictionary* i1 = [JsonServer getAreajson:imei key:[Global getKey]];
    //存入用户数据
    GeneralSettingService* gs=[GeneralSettingService getConnection];

    NSString* str = [i1 JSONRepresentation];

    NSMutableDictionary* ds = [[NSMutableDictionary alloc]init];
    
    [ ds setValue:str forKey:@"t_area_people"];
    [gs updateGeneralSetting:ds];
}

-(void)downloadUserinfo:(id)temp
{
   
    NSString* imei=[[NSUserDefaults standardUserDefaults] objectForKey:@"imei"];
    //向服务器请求用户数据
    NSDictionary* i1 = [JsonServer getUserInfo:imei Key:[Global getKey]];
    
    NSDictionary* info= [i1 valueForKey:@"data"];
    //存入用户数据
    UserServices* us=[UserServices getConnection];
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    User* user = [[User alloc]init];
    user.userId = [[info valueForKey:@"id"]intValue];
    user.mobile=[info valueForKey:@"mobile"];
    user.nicke = [info valueForKey:@"nike"] ;
    user.name =[info valueForKey:@"name"];
    user.email =[info valueForKey:@"email"];
    user.pwd = [info valueForKey:@"md5pwd"];
    user.qyId = [[info valueForKey:@"companyid"] intValue];
    user.imei = [info valueForKey:@"imei"];
    user.sex = [info valueForKey:@"sex"];
    user.area = [info valueForKey:@"area"];
    user.topimage = [info valueForKey:@"topimg"];
    user.autograph = [info valueForKey:@"autograph"];
    user.modified = 0;
    user.token = token;
    
    [us insertUser: user ];
    //下载用户头像
    if(![user.topimage isEqualToString:@""])
    [JsonServer downloadUserTopImage:user.topimage];
    //上传token码
    [JsonServer updateUserInfoToServer:user];

    NSData *t = [NSKeyedArchiver archivedDataWithRootObject:user]; 
    [[NSUserDefaults standardUserDefaults] setObject:t forKey:@"User"]; 
    
}

-(void)downloadClient:(id)temp{
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    ClientServices *conn=[ClientServices getConnection];
    [conn clearClient];
    [[ClientInfoServices getConnection]clearClientInfo];
    
    NSArray* result = [JsonClientServer getCompanGates:user isShow:NO];
    for (Client* c in result)
    {
        [conn insertClient:c];
        //每次加入一个联系人都重新刷新界面  
    }   
}

-(void)downloadCompanygates:(id)temp{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        PeopleServices *conn=[PeopleServices getConnection];
        
        NSArray* result = [JsonServer getCompanGates:user];
        for (People* p in result)
        {
            [conn insertPeople:p];
            if(![p.topimg isEqualToString:@""])
            {
                [JsonServer downloadUserTopImage:p.topimg];
            }
            //每次加入一个联系人都重新刷新界面         
        }   
}

-(void)viewDidLoad{
    
    // 要使用百度地图，请先启动BaiduMapManager
	mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [mapManager start:@"9883ACBA3E65682FF2968AADBC14BD3357CE896E" generalDelegate:self];
	if (!ret) {
        
	}
    
    NSString *jsonString =@"{\"1\":[\"位置上传\",\"位置查询\"],\"2\":[\"我的申请\",\"我的拜访\",\"工作日志\"],\"3\":[\"我的客户\"]}";
    
    cellsDataArray = [jsonString JSONValue]; 
    
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    NSString* status = [[NSUserDefaults standardUserDefaults] valueForKey:@"Status"];  
    if([status isEqualToString:@"Logining"]){
        [self userLoginSucceed:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"Logined" forKey:@"Status"];
    }
}
-(void)viewDidUnload{
    [super viewDidUnload];
}

//创建返回按钮，页面跳转动画
-(void)pageForward{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
   
}
-(bool)judgeLogin
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(user == nil)
    {
        LoginViewController *login = [[LoginViewController alloc]init]; 
        [self presentModalViewController:login animated:true];
        return true;
    }else
        return false;

}


//视图显示前调用
-(void)viewWillAppear:(BOOL)animated{
    isHidden=NO;
    [self hideTabBar:NO];
}

//视图跳转不显示时调用
-(void)viewWillDisappear:(BOOL)animated{
    if(isHidden==YES){
        [self hideTabBar:YES];
    }
}

//隐藏底部菜单栏
-(void)hideTabBar:(BOOL)hide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.tabBarController.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480-49, view.frame.size.width, view.frame.size.height)];
            }
        } else {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480-49)];
            }
        }
    }
    [UIView commitAnimations];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [cellsDataArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* temp=   [[cellsDataArray allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return [[cellsDataArray valueForKey:[temp objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger count=[indexPath row];
    NSArray* temp=   [[cellsDataArray allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[cellsDataArray valueForKey:[temp objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    if([text isEqualToString:@"位置上传"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_1"];
    }else if([text isEqualToString:@"位置查询"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_2"];
    }else if([text isEqualToString:@"我的申请"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_3"];
    }else if([text isEqualToString:@"我的拜访"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_4"];
    }else if([text isEqualToString:@"工作日志"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_7"];
    }else if([text isEqualToString:@"我的客户"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_5"];
    }else if([text isEqualToString:@"云知识库"]){
        cell.imageView.image = [UIImage imageNamed:@"yingyong_6"];
    }

	[cell.textLabel setText:text];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* temp=   [[cellsDataArray allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[cellsDataArray valueForKey:[temp objectAtIndex:indexPath.section]] objectAtIndex:[indexPath row]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    if([text isEqualToString:@"位置上传"]){
        if([self judgeLogin])
            return;
        
        isHidden=YES;
        [self pageForward];
        
        siteUploadViewController *site=[[siteUploadViewController alloc]init];
        [self.navigationController pushViewController:site animated:YES];
    }else if([text isEqualToString:@"位置查询"]){
        if([self judgeLogin])
            return;
        
        PlaceViewController *p = [[PlaceViewController alloc]init];
        [self.navigationController pushViewController:p animated:YES];
    }else if([text isEqualToString:@"我的申请"]){
        if([self judgeLogin])
            return;
        
        ApplyViewController *apply = [[ApplyViewController alloc]init];

        [self.navigationController pushViewController:apply animated:YES];
    }else if([text isEqualToString:@"我的拜访"]){
        if([self judgeLogin])
            return;
        
        VisitListViewController *visit = [[VisitListViewController alloc]init];

        [self.navigationController pushViewController:visit animated:YES];
    }else if([text isEqualToString:@"工作日志"]){
        if([self judgeLogin])
            return;
        
        WorkplanViewController *work = [[WorkplanViewController alloc]init];

        [self.navigationController pushViewController:work animated:YES];
    }else if([text isEqualToString:@"我的客户"]){
        if([self judgeLogin])
            return;
        
        ClientViewController *client = [[ClientViewController alloc]init];

        [self.navigationController pushViewController:client animated:YES];
    } else if([text isEqualToString:@"云知识库"]){
        if([self judgeLogin])
            return;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"该功能尚未开放" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}

@end

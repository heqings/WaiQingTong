//
//  GTAppDelegate.m
//  Pickers
//
//  Created by HeQing on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GTAppDelegate.h"
#import "InitDataServer.h"
#import "UserServices.h"
#import "AnyMore.h"
#import "DoubleComponentPickerViewController.h"
#import "OtherViewController.h"
#import "SectionViewController.h"
#import "NetworkUtils.h"
#import "JsonServer.h"
#import "RegisterViewController.h"
#import "NotifyServices.h"

@interface GTAppDelegate (private)
-(void)connectedSocket;
@end


@implementation GTAppDelegate

@synthesize rootController,sendSocket,window,workUtilsDelegate;

-(void)userRegister:(NSNotification*) notification
{
 
    [rootController dismissModalViewControllerAnimated:FALSE];

}
-(void)loginSocketServer:(NSNotification*) notification
{
    
     [self loginSocketServer];
    
}
-(void)sendDataBySocketServer:(NSNotification*) notification
{
    
    NSData* data= [notification.userInfo valueForKey:@"data"];
    [sendSocket writeData: data withTimeout: -1 tag: 0];
    
}   


-(void)checkversion{
    @try{
        Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
        [reach startNotifier];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        
        if (status != NotReachable) {
            NSString *retrunVal=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=536500293"] encoding:NSUTF8StringEncoding error:nil];
            if(retrunVal!=nil){
                NSDictionary *resultDict= [retrunVal JSONValue];
                if(resultDict!=nil){
                    NSArray *array=[resultDict objectForKey:@"results"];
                    double currentVersion=[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] doubleValue];
                    
                    double newVersion=[[[array objectAtIndex:0] objectForKey:@"version"] doubleValue];
                    
                    if(newVersion >currentVersion){
                        url=[[NSString alloc]init];
                        url=[[array objectAtIndex:0] objectForKey:@"trackViewUrl"];
                        
                        NSString *title=[NSString stringWithFormat:@"升级到%@版",[[[array objectAtIndex:0] objectForKey:@"version"] substringToIndex:3]];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                        message:[[array objectAtIndex:0] objectForKey:@"releaseNotes"]
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"升级", nil];
                        [alert show];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
} 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self checkversion];
    
    //程序启后把提示数字设为0
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    //初始化表格
    InitDataServer *conn=[InitDataServer getConnection];
    [conn initAttendance];
    [conn initWorklog];
    [conn initApply];
    [conn initNotify];
    [conn initNotifyInfo];
    [conn initUser];
    [conn initPeople];
    [conn initGeneralSetting];
    [conn initAppGlobal];
    [conn initNotifyGzrz];
    [conn initNotifyTz];
    [conn initNotifySq];
    [conn initNotifyGzrw];
    [conn initNotifyPlan];
    [conn initNotifyPoi];
    [conn initPoiInfo];
    [conn initPoiHistory];
    [conn initSignIn];
    [conn initPlace];
    [conn initClient];
    [conn initClientInfo];
    
    [NSThread sleepForTimeInterval:2];
    
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSBundle mainBundle] loadNibNamed:@"GTViewController" owner:self options:nil];
    [window addSubview:rootController.view];
    [window makeKeyAndVisible];
    
    rootController.delegate = self;
    
    //消息推送支持的类型
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types]; 
   
    //从数据库中加载用户
    UserServices* us = [UserServices getConnection];
    User* dic = [us getLoginUser];
    if(dic != nil)
    {   
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic]; 
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"User"];  
        [[NSUserDefaults standardUserDefaults] setObject:@"Logined" forKey:@"Status"];  
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Inited" forKey:@"Status"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //register notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRegister:) name:@"userRegister" object:nil];
    //socket notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSocketServer:) name:@"loginSocketServer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDataBySocketServer:) name:@"sendDataBySocketServer" object:nil];
    
    msgArray = [[NSMutableArray alloc]initWithCapacity:10];

    bRunningBackground=false;

    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:
                       [NSCharacterSet characterSetWithCharactersInString:@"<>"]]; //去掉"<>"     
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格 
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{//NSLog(@"Failed to get token, error: %@", error);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (![sendSocket isConnected]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
    }
}


-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    //NSLog(@"have wriddata");
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	//NSLog(@"%s %d", __FUNCTION__, __LINE__); 
    [self loginSocketServer];
    [sendSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    
    [sendSocket readDataWithTimeout: -1 tag: 0];
}

// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    @try{
        NSString *msg = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
        //NSLog(@"消息信息：%@---------------",msg);
        NSString* suf = [msg substringFromIndex:[msg length]-4];
        if([suf isEqualToString:@"}eof"])
        {
            NSArray *msgNum=[msg componentsSeparatedByString:@"eof"];
            for(int i=0;i<(msgNum.count-1);i++){

                NSDictionary *dic=[[msgNum objectAtIndex:i] JSONValue];;
                NSString *notifyType=[Global getNotifyType:[dic objectForKey:@"type"]];
                if([notifyType isEqualToString:[Global getNOTIFY_GZRZ]]){//工作日志
                    [NotifyWork runNotifyWork:dic];
                }else if([notifyType isEqualToString:[Global getNOTIFY_GZRW]]){//工作任务
                    [NotifyTask runNotifyTask:dic];
                }else if([notifyType isEqualToString:[Global getNOTIFY_BF]]){//工作拜访
                    [NotifyPlan runNotifyPlan:dic];
                }else if([notifyType isEqualToString:[Global getNOTIFY_SQ]]){//申请
                    [NotifyAudit runNotifyAudit:dic];
                }else if([notifyType isEqualToString:[Global getNOTIFY_TZ]]){//通知
                    [NotifyTz runNotifyTz:dic];
                    
                }else if([notifyType isEqualToString:[Global getNOTIFY_YY]]){//语音
                    
                    [SoundUtils insertNotify:dic];
                    [SoundUtils runNotifySound:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoifyChatMessage" object:nil userInfo:dic];
                }
                
                [msgArray removeAllObjects];
                if([[self rootController]selectedIndex]==1){
                    [workUtilsDelegate reloadTableView];
                }
            }
        }else{
            [msgArray addObject:msg];
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        [sendSocket readDataWithTimeout: -1 tag: 0];
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //NSLog(@"socket已断开链接－－－－－－－－－－－－－－－－－");
   
    if(bRunningBackground==false && [sendSocket isConnected]== false)//如果不是后台运行而断开连接，则进行重连，并重新登录服务器
    {
        [self connectSocket];
        [self loginSocketServer];
    }

}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController* ga = (UINavigationController*)viewController;
    
    if ([[ga.viewControllers objectAtIndex:0]  isKindOfClass:[SectionViewController class]] == false) 
    {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(dic == nil)
        {
            
            LoginViewController *login = [[LoginViewController alloc]init]; 
            [rootController presentModalViewController:login animated:TRUE];
            
            return NO;
        }
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{

    bRunningBackground = true;
    [self disconnectSocket];
    //sendSocket=nil;
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    //
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    [self connectSocket];
    bRunningBackground = false;
   
    //[[[[[self rootController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:@"1"];
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
    //[[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    rootController = nil;
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
-(void)disconnectSocket{
    if(sendSocket !=nil)
    {
        if([sendSocket isConnected])
        {

            [sendSocket disconnect];
        }
        sendSocket = nil;
    }
}
-(BOOL)loginSocketServer{
   if([sendSocket isConnected] == true)
   {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(user!=nil){
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:@"",@"",@"",@"",@"",[Global getOAUTH],user.imei,nil]
                           forKeys:
                           [NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                           ];
        
        NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"];  
        NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];
        [sendSocket writeData: newData withTimeout: -1 tag: 0];
         return TRUE;
    } else
        return FALSE;
   }
    return FALSE;
}

-(BOOL)connectSocket{
    BOOL connectOK = NO;
    
    if(sendSocket == nil){
        sendSocket= [[AsyncSocket alloc] initWithDelegate: self];
    }
    if([sendSocket isConnected ] == false){
        NSError *error;
        connectOK = [sendSocket connectToHost: [Global getServerIp] onPort: [Global getServerPort] error: &error];
        
        if (!connectOK){
            //NSLog(@"can't connect server");
            return false;
        }
        [sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
        return true;
}

@end

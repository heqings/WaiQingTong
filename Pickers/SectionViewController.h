//
//  SectionViewController.h
//  Pickers
//
//  Created by HeQing on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtils.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BMapKit.h"
#import "PlaceViewController.h"
#import "ApplyViewController.h"
#import "VisitListViewController.h"
#import "WorkplanViewController.h"
#import "ClientViewController.h"
#import "UserServices.h"
#import "User.h"
#import "PeopleServices.h"
#import "LoginViewController.h"
#import "siteUploadViewController.h"
#import "MBProgressHUD.h"



@interface SectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,BMKGeneralDelegate,UIAlertViewDelegate>{
    
    BMKMapManager *mapManager;//百度地图管理器
    BOOL isHidden;
    NetworkUtils* util;
    
    IBOutlet UITableView *table;
    NSDictionary *cellsDataArray;
    NSString *url;
}
@property(nonatomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)NSDictionary *cellsDataArray;

-(bool)judgeLogin;
-(void)downloadGeneralSetting:(NSNotification*)notification;
-(void)userLoginSucceed:(NSNotification*) notification;
-(void)downloadCompanygates:(id)temp;
-(void)downloadTopimage:(id)temp;
-(void)downloadUserinfo:(id)temp;
-(void)downloadAreaPeople:(id)temp;
-(NSString*)toUnichar:(NSString*)src;
@end

//
//  ClientListFromViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUtilsDelegate.h"
#import "BMapKit.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "User.h"
#import "NetUtils.h"
#import "Global.h"
#import "Client.h"
#import "ClientServices.h"

@interface ClientListFromViewController:UIViewController<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKSearchDelegate,WorkUtilsDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    UITableView *myTable;
    NSDictionary *myData;
    BMKMapView *mapView;
    BMKSearch *search;
    NSTimer *timer;//采集经纬度定时器
    BOOL isSuccess;//是否定位成功
    NSString *address;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    float lng;
    float lat;
}
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong) BMKSearch *search;
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@end

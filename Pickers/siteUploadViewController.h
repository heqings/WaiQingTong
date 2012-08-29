//
//  siteUploadViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MBProgressHUD.h"
#import "HistorySiteViewController.h"
#import "NetUtils.h"
#import "User.h"
#import "JSON.h"
#import "poiViewController.h"
#import "SigninViewHistoryDetailViewController.h"

@interface siteUploadViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,UIActionSheetDelegate>{
    BMKMapView *mapView;
    BMKSearch *search;
    NSTimer *timer;//采集经纬度定时器
    
    BOOL isSuccess;//是否定位成功
    
    double latitude;
    double longitude;
    NSString *address;
}
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong) BMKSearch *search;
@end

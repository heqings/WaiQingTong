//
//  AppointmentViewcontroller.h
//  Pickers
//
//  Created by 张飞 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "Global.h"
#import "MBProgressHUD.h"

@interface AppointmentViewcontroller : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,UITextFieldDelegate>{
    BMKMapView *_mapView;
    BMKSearch *search;
    
    NSTimer *timer;//采集经纬度定时器
    int toDo;//去目的的方式 0巴士 1自驾  2步行
    NSString *city;
    NSString *currentAddress;
    NSString *endAddress;
    
    CLLocationCoordinate2D startPt;//开始点
    CLLocationCoordinate2D endPt;//结束点
    BOOL isLoading;//是否加载了路线
    BOOL isSuccess;//是否定位成功
    BOOL isSearching;//是否查询中
}
@property(nonatomic,strong)BMKMapView *_mapView;
@property(nonatomic,strong) BMKSearch *search;
@end

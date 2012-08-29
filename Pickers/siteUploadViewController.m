//
//  siteUploadViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "siteUploadViewController.h"
#define KAOQIN	100
#define QIANDAO	200
#define BIAOZHU	300

@implementation siteUploadViewController
@synthesize mapView,search;

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(!isSuccess){
        [timer invalidate];
    }    
    timer=nil; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:@"历史" 
                                                                    style:UITabBarSystemItemContacts target:self action:@selector(historyBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= historyButton;

    self.navigationItem.title=@"位置上报";
    mapView= [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    mapView.delegate = self;
    mapView.showsUserLocation=YES;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findPoint) userInfo:nil repeats:YES];	
    self.view= mapView;

    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"定位中..." animated:NO];
}

-(void)historyBtnClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    HistorySiteViewController *history=[[HistorySiteViewController alloc]init];
    [self.navigationController pushViewController:history animated:YES];
}

- (void)viewDidUnload
{
    mapView=nil;
    search=nil;
    timer=nil;
    address=nil;
    [super viewDidUnload];
}

//获取定位信息定时器
-(void)findPoint{
    if(mapView.userLocation.location.coordinate.latitude>0.0f&&mapView.userLocation.location.coordinate.longitude>0.0f){
        if(!isSuccess){
            latitude=mapView.userLocation.location.coordinate.latitude;
            longitude=mapView.userLocation.location.coordinate.longitude;
            
            [timer invalidate];
            
            mapView.zoomLevel=16;
            [mapView setCenterCoordinate:CLLocationCoordinate2DMake(mapView.userLocation.location.coordinate.latitude,mapView.userLocation.location.coordinate.longitude) animated:YES];
            
            search = [[BMKSearch alloc]init];
            search.delegate = self;
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){mapView.userLocation.location.coordinate.latitude,mapView.userLocation.location.coordinate.longitude};    
            [search reverseGeocode:pt];
            
            isSuccess=TRUE;
        }
    }
}


//考勤事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)kaoqinClick:(id)sender{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定要提交考勤信息吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}    

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==actionSheet.destructiveButtonIndex){
        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude],address,[Global getKey],user.imei,nil]
                           forKeys:[NSArray arrayWithObjects:@"lat",@"lng",@"address",@"key",@"imei",nil]
                           ];
        
        NSString *json=[dic JSONRepresentation];
        
        NSMutableData *postBody = [NSMutableData data];
        NSString *param =[NSString stringWithFormat:@"param=%@",json];
        [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
        
        [[NetUtils shareNetworkHelper] requestDataFromURL:@"attendance!sumitattendance.action" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"kaoqinSuccess:" withFaildRequestMethod:@"kaoqinFaild:" contentType:NO];
    }
}

- (void)kaoqinSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){

        AttendanceServices *conn=[AttendanceServices getConnection];
        [conn insertAttendance:[[resultDict objectForKey:@"data"] objectForKey:@"createtime"] address:address];
        [self alertWithMassage:@"考勤成功！"];
    }else{
        [self alertWithMassage:[resultDict objectForKey:@"msg"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)kaoqinFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//考勤事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


//签到事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)qiandaoClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    poiViewController *p=[[poiViewController alloc]init];
    p.latitude=latitude;
    p.longitude=longitude;
    [self.navigationController pushViewController:p animated:true];
}
//签到事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


//标注事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)biaozhuClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    SigninViewHistoryDetailViewController *s=[[SigninViewHistoryDetailViewController alloc] init];
    s.address=address;
    s.longitude=longitude;
    s.latitude=latitude;
    [self.navigationController pushViewController:s animated:true];
}
//标注事件－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


-(void)dealloc{
    [mapView setShowsUserLocation:NO];
    mapView.delegate=nil;
    search.delegate=nil;
}

//定位失败调用
-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:@"定位失败，请查看网络配置！"];
}

//根据经纬度获取地址
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
	if (error == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        address=result.strAddr;
        UIButton *kaoqin=[[UIButton alloc]initWithFrame:CGRectMake(28, 355, 88, 45)];
        [kaoqin setImage:[UIImage imageNamed:@"map_tool_kq"] forState:UIControlStateNormal];
        [kaoqin setImage:[UIImage imageNamed:@"map_tool_kq_hover"] forState:UIControlStateHighlighted];
        [kaoqin addTarget:self action:@selector(kaoqinClick:) forControlEvents:UIControlEventTouchUpInside];
        kaoqin.tag=KAOQIN;
        
        [self.view addSubview:kaoqin];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(115, 355, 2, 45)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jiange"]];
        view.opaque = NO;
        [self.view addSubview:view];
        
        UIButton *qiandao=[[UIButton alloc]initWithFrame:CGRectMake(117, 355, 88, 45)];
        [qiandao setImage:[UIImage imageNamed:@"map_tool_qd"] forState:UIControlStateNormal];
        [qiandao setImage:[UIImage imageNamed:@"map_tool_qd_hover"] forState:UIControlStateHighlighted];
        [qiandao addTarget:self action:@selector(qiandaoClick:) forControlEvents:UIControlEventTouchUpInside];
        qiandao.tag=QIANDAO;
        [self.view addSubview:qiandao];
        
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(205, 355, 2, 45)];
        view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jiange"]];
        view1.opaque = NO;
        [self.view addSubview:view1];
        
        UIButton *biaozhu=[[UIButton alloc]initWithFrame:CGRectMake(206, 355, 88, 45)];
        [biaozhu setImage:[UIImage imageNamed:@"map_tool_bz"] forState:UIControlStateNormal];
        [biaozhu setImage:[UIImage imageNamed:@"map_tool_bz_hover"] forState:UIControlStateHighlighted];
        [biaozhu addTarget:self action:@selector(biaozhuClick:) forControlEvents:UIControlEventTouchUpInside];
        biaozhu.tag=BIAOZHU;
        
        [self.view addSubview:biaozhu];
	}
}
@end

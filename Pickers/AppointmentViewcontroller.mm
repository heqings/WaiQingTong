//
//  AppointmentViewcontroller.m
//  Pickers
//
//  Created by 张飞 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppointmentViewcontroller.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#define TOOLBARTAG 100
#define SEARCHTEXT  200
#define SEARCHBTN   300
#define BUS         400
#define DRIVING     500
#define FOOT        600

BOOL isRetina = FALSE;

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (isRetina) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@implementation AppointmentViewcontroller
@synthesize search,_mapView;

- (NSString*)getMyBundlePath1:(NSString *)filename{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

#pragma mark - View lifecycle

-(void)viewWillDisappear:(BOOL)animated{
    if(!isSuccess){
        [timer invalidate];
    }    
    timer=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    toDo=0;
    isLoading=NO;
    isSearching=NO;
    isSuccess=NO;
    _mapView= [[BMKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.showsUserLocation=YES;

    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findPoint) userInfo:nil repeats:YES];	
    
    self.view=_mapView; 
    UIView *toolBar=[[UIView alloc]initWithFrame:CGRectMake(10, 8, 301, 46)];
    toolBar.tag = TOOLBARTAG;
    toolBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"map_tool_bg"]];
    toolBar.opaque = NO;
    
    UIButton *bus=[[UIButton alloc]initWithFrame:CGRectMake(69, 9, 53, 28)];
    bus.tag=BUS;
    [bus setImage:[UIImage imageNamed:@"mt_icon_bus_hover"] forState:UIControlStateNormal];
    [bus addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:bus];
    
    UIButton *driving=[[UIButton alloc]initWithFrame:CGRectMake(125, 9, 53, 28)];
    driving.tag=DRIVING;
    [driving setImage:[UIImage imageNamed:@"mt_icon_taxi"] forState:UIControlStateNormal];
    [driving addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:driving];
    
    UIButton *foot=[[UIButton alloc]initWithFrame:CGRectMake(181, 9, 53, 28)];
    foot.tag=FOOT;
    [foot setImage:[UIImage imageNamed:@"mt_icon_foot"] forState:UIControlStateNormal];
    [foot addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:foot];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(7, 7, 51, 32)];
    [backBtn setImage:[UIImage imageNamed:@"map_tool_comeback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(244, 7, 51, 32)];
    [searchBtn setImage:[UIImage imageNamed:@"map_tool_seach"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:searchBtn];
    
    [self.view addSubview:toolBar];
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"定位中..." animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)findPoint{
    if(_mapView.userLocation.location.coordinate.latitude>0.0f&&_mapView.userLocation.location.coordinate.longitude>0.0f){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [timer invalidate];
        
        _mapView.zoomLevel=14;
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(_mapView.userLocation.location.coordinate.latitude,_mapView.userLocation.location.coordinate.longitude) animated:YES];
        isSuccess=YES;
    }    
}

//查询附近的餐馆、咖啡厅等
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BMKPoiResult* result = [poiResultList objectAtIndex:0];
    for (int i = 0; i < result.poiInfoList.count; i++) {
        BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = poi.pt;
        item.title = poi.name;
        item.subtitle=poi.address;
        [_mapView addAnnotation:item];
    }
	
}


//点击标注事件
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    if (![[view annotation] isKindOfClass:[RouteAnnotation class]]) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([[view annotation] coordinate].latitude,[[view annotation] coordinate].longitude) animated:YES];

        endAddress=[[view annotation]title];
        NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        startPt = (CLLocationCoordinate2D){_mapView.userLocation.location.coordinate.latitude, _mapView.userLocation.location.coordinate.longitude};
        endPt = (CLLocationCoordinate2D){[[view annotation] coordinate].latitude,[[view annotation] coordinate].longitude};
        
        BMKPlanNode *start = [[BMKPlanNode alloc]init];
        start.pt = startPt;
        start.name =currentAddress;
        BMKPlanNode *end = [[BMKPlanNode alloc]init];
        end.pt=endPt;
        end.name = endAddress;

        switch (toDo) {
            case 0:
            {
                BOOL flag = [search transitSearch:city startNode:start endNode:end];
                if (!flag) {

                }
            }
                break;
            case 1:
            {
                BOOL flag = [search drivingSearch:city startNode:start endCity:city endNode:end];
                if (!flag) {

                }
            }
                break;
            case 2:
            {
                BOOL flag = [search walkingSearch:city startNode:start endCity:city endNode:end];
                if (!flag) {
  
                }
            }
                break;
            default:
                break;
        }
    }    
}

- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error{
	if (error == BMKErrorOk) {
        isLoading=YES;
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.endPt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
		
		int size = [plan.lines count];
		int index = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			index += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					index += len;
				}
				break;
			}
		}

		BMKMapPoint *points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + index, line.points, line.pointsCount * sizeof(BMKMapPoint));
			index += line.pointsCount;
			
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item];
			route = [plan.routes objectAtIndex:i+1];
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOffStopPoiInfo.pt;
			item.title = route.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			[_mapView addAnnotation:item];
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
					index += len;
				}
				break;
			}
		}
		
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
}


- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error{
	if (error == BMKErrorOk) {
        isLoading=YES;
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];

		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
	
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error{
	if (error == BMKErrorOk) {
        isLoading=YES;
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
}

//更换标注图片
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}

//添加标注
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

//添加覆盖物－－－画线
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay{	
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

//根据经纬度获取地址
-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
	if (error == 0) {
       city=[(BMKPoiInfo *)[result.poiList objectAtIndex:0]city];
       currentAddress=[(BMKPoiInfo *)[result.poiList objectAtIndex:0]address];
        //两点距离长度
        double longNum=[Global DistanceOfTwoPoints:113.53022575378418 lat1:22.238339375978065 lng2:_mapView.userLocation.location.coordinate.longitude lat2:_mapView.userLocation.location.coordinate.latitude gs:nil];
        if(longNum>0.0){
            UIView *view=[self.view viewWithTag:TOOLBARTAG];
            UITextField *field=(UITextField *)[view viewWithTag:SEARCHTEXT];
    
            //半径长度
            double bj=longNum/2;
            CLLocationCoordinate2D cl = (CLLocationCoordinate2D){_mapView.userLocation.location.coordinate.latitude,_mapView.userLocation.location.coordinate.longitude}; 
            
            [search poiSearchNearBy:field.text center:cl radius:bj pageIndex:0];
            
            
            [field removeFromSuperview];
            [[view viewWithTag:SEARCHBTN]removeFromSuperview];
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
            [UIView setAnimationDuration:0.1f];
            view.frame=CGRectMake(10, 8, 301, 46);
            
            [UIView commitAnimations];
            isSearching=NO;
        }
	}
}

-(void)segmentBtnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = startPt;
    start.name =currentAddress;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=endPt;
    end.name = endAddress;

    if(btn.tag==BUS){
        [btn setImage:[UIImage imageNamed:@"mt_icon_bus_hover"] forState:UIControlStateNormal];
        UIView *toolBar=[self.view viewWithTag:TOOLBARTAG];
        [(UIButton *)[toolBar viewWithTag:DRIVING] setImage:[UIImage imageNamed:@"mt_icon_taxi"] forState:UIControlStateNormal];
        [(UIButton *)[toolBar viewWithTag:FOOT] setImage:[UIImage imageNamed:@"mt_icon_foot"] forState:UIControlStateNormal];
        toDo=0;
        if(isLoading){
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            array = [NSArray arrayWithArray:_mapView.overlays];
            [_mapView removeOverlays:array];
            BOOL flag = [search transitSearch:city startNode:start endNode:end];
            if (!flag) {

            }
        } 
    }else if(btn.tag==DRIVING){
        [btn setImage:[UIImage imageNamed:@"mt_icon_taxi_hover"] forState:UIControlStateNormal];
        UIView *toolBar=[self.view viewWithTag:TOOLBARTAG];
        [(UIButton *)[toolBar viewWithTag:BUS] setImage:[UIImage imageNamed:@"mt_icon_bus"] forState:UIControlStateNormal];
        [(UIButton *)[toolBar viewWithTag:FOOT] setImage:[UIImage imageNamed:@"mt_icon_foot"] forState:UIControlStateNormal];
        toDo=1;
        if(isLoading){
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            array = [NSArray arrayWithArray:_mapView.overlays];
            [_mapView removeOverlays:array];
            BOOL flag = [search drivingSearch:city startNode:start endCity:city endNode:end];
            if (!flag) {

            }
        }  
    }else if(btn.tag==FOOT){
        [btn setImage:[UIImage imageNamed:@"mt_icon_foot_hover"] forState:UIControlStateNormal];
        UIView *toolBar=[self.view viewWithTag:TOOLBARTAG];
        [(UIButton *)[toolBar viewWithTag:BUS] setImage:[UIImage imageNamed:@"mt_icon_bus"] forState:UIControlStateNormal];
        [(UIButton *)[toolBar viewWithTag:DRIVING] setImage:[UIImage imageNamed:@"mt_icon_taxi"] forState:UIControlStateNormal];
        toDo=2; 
        if(isLoading){
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            array = [NSArray arrayWithArray:_mapView.overlays];
            [_mapView removeOverlays:array];
            BOOL flag = [search walkingSearch:city startNode:start endCity:city endNode:end];
            if (!flag) {

            }
        } 
    }
     
}

//返回事件
-(void)backBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    
    
}

//搜索按钮事件
-(void)searchBtnClick:(id)sender{
    if(!isSearching){
        isSearching=YES;
        UIView *view=[self.view viewWithTag:TOOLBARTAG];
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(7, 52, 230, 35)];
        textfield.tag=SEARCHTEXT;
        textfield.placeholder=@"请输入查询信息";
        textfield.delegate = self;
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textfield.enablesReturnKeyAutomatically = YES;
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.returnKeyType = UIReturnKeySend;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        textfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        
        UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(244, 53, 51, 32)];
        searchBtn.tag=SEARCHBTN;
        [searchBtn setImage:[UIImage imageNamed:@"mt_tool_seach_btn"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchVal:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
        [UIView setAnimationDuration:0.1f];
        view.frame=CGRectMake(10, 8, 301, 92);
        [view addSubview:textfield];   
        [view addSubview:searchBtn];
        
        [UIView commitAnimations];
    }else{
        UIView *view=[self.view viewWithTag:TOOLBARTAG];
        UITextField *field=(UITextField *)[view viewWithTag:SEARCHTEXT];
        [field resignFirstResponder];
        [field removeFromSuperview];
        [[view viewWithTag:SEARCHBTN]removeFromSuperview];
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
        [UIView setAnimationDuration:0.1f];
        view.frame=CGRectMake(10, 8, 301, 46);
        
        [UIView commitAnimations];
        isSearching=NO;
    }
}

//搜索按钮查询
-(void)searchVal:(id)sender{
    UIView *view=[self.view viewWithTag:TOOLBARTAG];
    UITextField *text=(UITextField *)[view viewWithTag:SEARCHTEXT];
    if(![text.text isEqualToString:@""]){
        isLoading=NO;
        search = [[BMKSearch alloc]init];
        search.delegate = self;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_mapView.userLocation.location.coordinate.latitude,_mapView.userLocation.location.coordinate.longitude};    
        [search reverseGeocode:pt];
    }    
    [text resignFirstResponder];
}

@end

//
//  PlaceMapViewControllerViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceMapViewControllerViewController.h"


@implementation PlaceMapViewControllerViewController
@synthesize mapView;
static CGFloat kTransitionDuration = 0.45f;

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"位置查询";
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"请求中..." animated:YES];
    
    NSString *imei=[[NSUserDefaults standardUserDefaults]objectForKey:@"choosePlaceImei"];
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[Global getKey],imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"key",@"imei",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"terminal/terminalloc" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
    

}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        bubbleView = [[KYBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        bubbleView.hidden = YES;
        dataArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        mapView= [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        mapView.delegate = self;            	
        self.view= mapView;
        
        mapView.zoomLevel=16;
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake([[[resultDict objectForKey:@"data"] objectForKey:@"lat"]floatValue],[[[resultDict objectForKey:@"data"] objectForKey:@"lng"]floatValue]) animated:YES];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:[[resultDict objectForKey:@"data"] objectForKey:@"terminalName"] forKey:@"name"];
        [dict setObject:[[resultDict objectForKey:@"data"] objectForKey:@"address"] forKey:@"address"];
        [dict setObject:[[resultDict objectForKey:@"data"] objectForKey:@"time"] forKey:@"time"];
        [dict setObject:[[resultDict objectForKey:@"data"] objectForKey:@"locType"] forKey:@"locType"];
        [dataArray addObject:dict];
        
        KYPointAnnotation* annotation = [[KYPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[[resultDict objectForKey:@"data"] objectForKey:@"lat"]floatValue];
        coor.longitude = [[[resultDict objectForKey:@"data"] objectForKey:@"lng"]floatValue];
        annotation.coordinate = coor;
        annotation.tag = 0;
      
        [mapView addAnnotation:annotation];
        
        [NSThread sleepForTimeInterval:1.0];
        
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
        selectedAV = annotationView;
        if (bubbleView.superview == nil) {
			//bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
            [annotationView.superview addSubview:bubbleView];
            bubbleView.layer.zPosition = 1;
        }
        bubbleView.infoDict = [dataArray objectAtIndex:[(KYPointAnnotation*)annotationView.annotation tag]];
        [self showBubble:YES];
        [self changeBubblePosition];
        
    }else{
        [self alertWithMassage:[resultDict objectForKey:@"msg"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];  
    mapView=nil;
    dataArray=nil;
    bubbleView=nil;
    selectedAV=nil;
    dataArray=nil;
}

- (void)changeBubblePosition {
    if (selectedAV) {
        CGRect rect = selectedAV.frame;
        CGPoint center;
        center.x = rect.origin.x + rect.size.width/2;
        center.y = rect.origin.y - bubbleView.frame.size.height/2 + 8;
        bubbleView.center = center;
    }
}

#pragma mark 标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[self.mapView viewForAnnotation:annotation];
    
    if (annotationView == nil) 
    {
        KYPointAnnotation *ann;
        if ([annotation isKindOfClass:[KYPointAnnotation class]]) {
            ann = annotation;
        }
        NSUInteger tag = ann.tag;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
       
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                           reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed; 
        annotationView.canShowCallout = NO;//使用自定义bubble
        
		//((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
	}
	return annotationView ; 
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        selectedAV = view;
        if (bubbleView.superview == nil) {
			//bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
            [view.superview addSubview:bubbleView];
            bubbleView.layer.zPosition = 1;
        }
        bubbleView.infoDict = [dataArray objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];
        [self showBubble:YES];
        [self changeBubblePosition];
    }
    else {
        selectedAV = nil;
    }
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{

    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        [self showBubble:NO];
    }
}

#pragma mark 区域改变
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (selectedAV) {

    }

}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (selectedAV) {
        [self showBubble:YES];
        [self changeBubblePosition];
    }

}


#pragma mark show bubble animation
- (void)bounce4AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce3AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)showBubble:(BOOL)show {
    if (show) {
        [bubbleView showFromRect:selectedAV.frame];        
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        bubbleView.hidden = NO;
        [UIView commitAnimations];
        
    }else{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        bubbleView.hidden = YES;
        [UIView commitAnimations];
    }
}

-(void)dealloc{
    mapView.delegate=nil;
}
@end

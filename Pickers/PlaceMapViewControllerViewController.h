//
//  PlaceMapViewControllerViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <QuartzCore/QuartzCore.h>
#import "NetUtils.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "KYBubbleView.h"
#import "KYPointAnnotation.h"

@interface PlaceMapViewControllerViewController : UIViewController<BMKMapViewDelegate,UINavigationControllerDelegate>{
    BMKMapView *mapView;
    KYBubbleView *bubbleView;
    BMKAnnotationView *selectedAV;
    NSMutableArray *dataArray;
}
@property(nonatomic,strong)BMKMapView *mapView;
- (void)showBubble:(BOOL)show;
@end

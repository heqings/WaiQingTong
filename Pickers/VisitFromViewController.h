//
//  VisitFromViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>
#import "NotifyPlanServices.h"
#import "NotifyPoiServices.h"
#import "MBProgressHUD.h"
#import "NetUtils.h"
#import "JSON.h"
#import "ClientServices.h"
#import "Client.h"
#import "NotifyPoiServices.h"
#import "NotifyPoi.h"
#import "IDJDatePickerView.h"
#import "SpeechHelper.h"
#import "VisitClientViewController.h"
#import "WorkUtilsDelegate.h"

@interface VisitFromViewController:UIViewController<UITextViewDelegate,IDJDatePickerViewDelegate,WorkUtilsDelegate>{

    NSString *textContent;
    //公历日期选择器
    IDJDatePickerView *djdateGregorianView;
    BOOL isShow;
    int textCount;
    SpeechHelper *speechHelper;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    UIView *infoView;
    
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
}
@property(nonatomic,strong)IBOutlet UIButton *startButton;
@property(nonatomic,strong)IBOutlet UIButton *endButton;
-(IBAction)chooseTime:(id)sender;
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@property(nonatomic,retain)UIView *infoView;
@end

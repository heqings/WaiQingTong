//
//  NewPlanViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDJDatePickerView.h"
#import "NetUtils.h"
#import "JSON.h"
#import "WorkLogServices.h"
#import "WorkUtilsDelegate.h"
#import "iFlyISR/IFlyRecognizeControl.h"
#import "SpeechHelper.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "NotifyServices.h"
#import "NotifyGzrzServices.h"

@interface NewPlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,IDJDatePickerViewDelegate,UITextViewDelegate,UIAlertViewDelegate>{
    UITableView *myTable;
    NSMutableDictionary *myData;
    int textCount;
    //公历日期选择器
    IDJDatePickerView *djdateGregorianView;
    BOOL isShow;
    NSString *workType;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    
    SpeechHelper *speechHelper;
}
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;

@end

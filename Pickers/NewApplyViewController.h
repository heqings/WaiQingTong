//
//  NewApplyViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ApplyTypeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ApplyServices.h"
#import "WorkUtilsDelegate.h"
#import "NetUtils.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "iFlyISR/IFlyRecognizeControl.h"
#import "SpeechHelper.h"
#import "NotifyServices.h"
#import "Notify.h"
#import "NotifySqServices.h"

@interface NewApplyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,UITextViewDelegate,WorkUtilsDelegate,UIAlertViewDelegate>{
    UITableView *myTable;
    NSDictionary *myData;
    
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    SpeechHelper *speechHelper;
}
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

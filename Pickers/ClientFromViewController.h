//
//  ClientFromViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUtilsDelegate.h"
#import "NetUtils.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Global.h"
#import "WorkUtilsDelegate.h"
#import "SpeechHelper.h"
#import "ClientInfo.h"
#import "ClientInfoServices.h"

@interface ClientFromViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate,UITextViewDelegate,WorkUtilsDelegate,UITextFieldDelegate>{
    UITableView *myTable;
    NSDictionary *myData;
    
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    SpeechHelper *speechHelper;
}
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

//
//  RemarkGzrzViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyGzrzServices.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "JSON.h"
#import "NetUtils.h"
#import<QuartzCore/QuartzCore.h>
#import "WorkUtilsDelegate.h"

@interface RemarkGzrzViewController : UIViewController<UITextViewDelegate>{
    NSString *textContent;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate; 
}
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

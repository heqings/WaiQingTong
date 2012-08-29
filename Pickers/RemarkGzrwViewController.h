//
//  RemarkGzrwViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUtilsDelegate.h"
#import<QuartzCore/QuartzCore.h>
#import "NotifyGzrwServices.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "NetUtils.h"

@interface RemarkGzrwViewController : UIViewController<UITextViewDelegate>{
    NSString *textContent;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate; 
}
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

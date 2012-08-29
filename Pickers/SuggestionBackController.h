//
//  SuggestionBackController.h
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "User.h"
#import "Global.h"
#import "NetUtils.h"

@interface SuggestionBackController :  UIViewController<UIAlertViewDelegate,UITextViewDelegate>{
    
    UIView *infoView;
}
@property(nonatomic,retain)UIView *infoView;

@end

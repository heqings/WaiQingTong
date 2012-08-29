//
//  PersonSignController.h
//  Pickers
//
//  Created by  on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "NetUtils.h"

@interface PersonSignController : UIViewController<UIAlertViewDelegate,UITextViewDelegate>{
    
    UIView *infoView;
}
@property(nonatomic,retain)UIView *infoView;
@end

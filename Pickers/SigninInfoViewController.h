//
//  SigninInfoViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignIn.h"
#import "Attendance.h"
#import "PoiInfo.h"
#import "MainViewController.h"

@interface SigninInfoViewController : UIViewController<UIScrollViewDelegate>{
    SignIn *signIn;
    Attendance *attendance;
    PoiInfo *poiInfo;
    IBOutlet UIScrollView *scroll;
    IBOutlet UILabel *type;
    
}
@property(nonatomic,retain)SignIn *signIn;
@property(nonatomic,retain)Attendance *attendance;
@property(nonatomic,retain)PoiInfo *poiInfo;
@property(nonatomic,retain)IBOutlet UIScrollView *scroll;
@property(nonatomic,retain)IBOutlet UILabel *type;
@end

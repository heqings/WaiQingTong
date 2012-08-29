//
//  WorkplanDetailViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkLog.h"

@interface WorkplanDetailViewController : UIViewController<UIScrollViewDelegate>{
    WorkLog *workLog;
    IBOutlet UILabel *starTime;
    IBOutlet UILabel *endTime;
    IBOutlet UILabel *type;
    IBOutlet UIScrollView *scroll;
}
@property(nonatomic,retain)WorkLog *workLog;
@property(nonatomic,retain)IBOutlet UILabel *starTime;
@property(nonatomic,retain)IBOutlet UILabel *endTime;
@property(nonatomic,retain)IBOutlet UILabel *type;
@property(nonatomic,retain)IBOutlet UIScrollView *scroll;
@end

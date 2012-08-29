//
//  VisitClientViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientServices.h"
#import "Client.h"
#import "NetUtils.h"
#import "User.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "NotifyPlanServices.h"
#import "NotifyPlanE.h"
#import "NotifyPoi.h"
#import "NotifyPoiServices.h"
#import "PeopleServices.h"
#import "NotifyServices.h"

@interface VisitClientViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>{
    
    NSString *startTime;
    NSString *endTime;
    NSString *remark;
    
    NSMutableDictionary *myData;
    UITableView *table;
    NSMutableArray *chatArray;//选中行的联系人集合
    UIImage *checked;//选中图片
    UIImage *checkno;//没选中图片
    NSString *ids;
}
@property(nonatomic,retain)NSString *startTime;
@property(nonatomic,retain)NSString *endTime;
@property(nonatomic,retain)NSString *remark;
@property(nonatomic,retain)NSMutableDictionary *myData;
@property(nonatomic,retain)IBOutlet UITableView *table;
@end

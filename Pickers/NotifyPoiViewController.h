//
//  NotifyPoiViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NotifyPoi.h"
#import "NotifyPoiServices.h"
#import "User.h"
#import "NetUtils.h"

@interface NotifyPoiViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *table;
    NSMutableArray *cellsDataArray;
    NSInteger selectIndex;
    NSInteger npId;
}
@property(nonatomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)NSMutableArray *cellsDataArray;
@property(nonatomic,nonatomic)NSInteger npId;
@end

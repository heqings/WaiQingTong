//
//  HistorySiteViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceServices.h"
#import "Attendance.h"
#import "PoiHistoryServices.h"
#import "SignInService.h"
#import "SigninInfoViewController.h"

@interface HistorySiteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *table;
    NSMutableArray *cellsDataArray;
    NSInteger selectIndex;
}
@property(nonatomic,strong) NSMutableArray *cellsDataArray;
@property(nonatomic,strong) IBOutlet UITableView *table;
@end

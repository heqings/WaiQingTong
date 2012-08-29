//
//  VisitListViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyPlanServices.h"
#import "NotifyPlanE.h"
#import "VisitFromViewController.h"
#import "WorkUtilsDelegate.h"

@interface VisitListViewController:UIViewController<UITableViewDataSource,UITableViewDelegate,WorkUtilsDelegate>{
     UITableView *table;
     NSMutableArray *cellsDataArray;
     BOOL isHidden;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

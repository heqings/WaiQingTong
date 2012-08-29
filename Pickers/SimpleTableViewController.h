//
//  SimpleTableViewController.h
//  Pickers
//
//  Created by HeQing on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserViewController.h"
#import "CustomBadge.h"
#import "NotifyServices.h"
#import "WorkUtilsDelegate.h"
#import "GTAppDelegate.h"
#import "NotifyInfoServices.h"
#import "WorkUtilsDelegate.h"
#import "GTAppDelegate.h"
#import "NotifyOfficeViewController.h"
#import "NotifyTzServices.h"
#import "NotifyTzViewController.h"
#import "NotifySqViewController.h"
#import "NotifyGzrwViewController.h"
#import "NotifySqServices.h"

@interface SimpleTableViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,WorkUtilsDelegate>{
    BOOL isHidden;
    UITableView *myTable;
    
    NSMutableArray *cellsDataArray;
}
-(void)reloadTableView;
@property(nonatomic,strong)IBOutlet UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

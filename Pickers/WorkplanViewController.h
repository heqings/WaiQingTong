//
//  WorkplanViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPlanViewController.h"
#import "WorkLog.h"
#import "WorkUtilsDelegate.h"
#import "WorkLogServices.h"
#import "WorkplanDetailViewController.h"

@interface WorkplanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,WorkUtilsDelegate>{
    UITableView *myTable;
    
    NSMutableArray *cellsDataArray;

}
@property(nonatomic,strong)IBOutlet UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

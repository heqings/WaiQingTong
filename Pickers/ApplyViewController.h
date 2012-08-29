//
//  ApplyViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apply.h"
#import "NewApplyViewController.h"
#import "WorkUtilsDelegate.h"
#import "ApplyViewDetailViewController.h"

@interface ApplyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,WorkUtilsDelegate>{
    
    UITableView *myTable;
    NSMutableArray *cellsDataArray;
    
}
@property(nonatomic,strong)IBOutlet UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

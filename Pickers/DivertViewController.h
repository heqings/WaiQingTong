//
//  DivertViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUtilsDelegate.h"
#import "Global.h"
#import "PeopleServices.h"
#import "User.h"
#import "JSON.h"
#import "NetUtils.h"
#import "MBProgressHUD.h"

@interface DivertViewController : UIViewController< UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate,UIAlertViewDelegate>{
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate; 
    UITableView *table;
    NSMutableArray *cellsDataArray;
    NSMutableDictionary *myData;
    NSString *currentName;
}
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@property(nonatomic,strong) NSDictionary *myData;
-(IBAction)backBtnClick:(id)sender;
@end

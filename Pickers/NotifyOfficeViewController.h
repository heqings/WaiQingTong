//
//  NotifyOfficeViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"
#import "NotifyGzrzServices.h"
#import "NotifyGzrz.h"
#import "PeopleServices.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "JSON.h"
#import "NetUtils.h"
#import "NotifyServices.h"
#import "RemarkGzrzViewController.h"
#import "WorkUtilsDelegate.h"

@interface NotifyOfficeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,WorkUtilsDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

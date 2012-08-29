//
//  NotifyGzrwViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyServices.h"
#import "NotifyGzrwServices.h"
#import "CommentViewCell.h"
#import "NotifyGzrw.h"
#import "RemarkGzrwViewController.h"
#import "WorkUtilsDelegate.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "People.h"
#import "User.h"
#import "NetUtils.h"

@interface NotifyGzrwViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,WorkUtilsDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

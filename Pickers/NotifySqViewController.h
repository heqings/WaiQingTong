//
//  NotifySqViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifySqServices.h"
#import "CommentViewCell.h"
#import "PeopleServices.h"
#import "NotifyServices.h"
#import "RemarkSqViewController.h"
#import "WorkUtilsDelegate.h"
#import "DivertViewController.h"

@interface NotifySqViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,WorkUtilsDelegate,UINavigationBarDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

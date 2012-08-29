//
//  NotifyPlanViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"
#import "NotifyPlanE.h"
#import "NotifyServices.h"
#import "NotifyPlanServices.h"
#import "NotifyPoiViewController.h"

@interface NotifyPlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

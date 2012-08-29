//
//  NotifyTzViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"
#import "NotifyTzServices.h"
#import "NotifyServices.h"

@interface NotifyTzViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
    CommentViewCell *currentCell;
}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@end

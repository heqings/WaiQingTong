//
//  ClientInfoViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientTableCell.h"
#import "ClientInfoServices.h"
#import "ClientInfo.h"
#import "ClientFromViewController.h"
#import "WorkUtilsDelegate.h"
#import "ClientServices.h"

@interface ClientInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,WorkUtilsDelegate>{
    
    IBOutlet UITableView *table;
    NSMutableArray *cellsDataArray;
    ClientTableCell *currentCell;
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *address;
    IBOutlet UILabel *email;
    IBOutlet UILabel *url;
    IBOutlet UILabel *telphone;
    IBOutlet UILabel *faxphone;
    IBOutlet UIView *bodyView;

}
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@property(nonatomic,retain)IBOutlet UILabel *name;
@property(nonatomic,retain)IBOutlet UILabel *address;
@property(nonatomic,retain)IBOutlet UILabel *email;
@property(nonatomic,retain)IBOutlet UILabel *url;
@property(nonatomic,retain)IBOutlet UILabel *telphone;
@property(nonatomic,retain)IBOutlet UILabel *faxphone;
@property(nonatomic,strong) IBOutlet UIView *bodyView;
@end

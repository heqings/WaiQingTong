//
//  AddUserViewController.h
//  Pickers
//
//  Created by 张飞 on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "OtherViewController.h"
#import "SimpleTableViewController.h"
#import "NotifyServices.h"
#import "PeopleServices.h"
#import "Global.h"

@interface AddUserViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,UIScrollViewDelegate>{
    NSMutableDictionary *myData;
    UITableView *table;
    IBOutlet UIView *bootView;//底层视图，放会话，删除按钮
    NSMutableArray *chatArray;//选中行的联系人集合
    UIImage *checked;//选中图片
    UIImage *checkno;//没选中图片

    IBOutlet UIButton *submitBtn;
    IBOutlet UIButton *delBtn;
    NSMutableArray *mArray;
    
    NSString *from;
}
@property(nonatomic,strong) NSString *from;
@property(nonatomic,strong) IBOutlet UIButton *delBtn;
@property(nonatomic,strong) IBOutlet UIButton *submitBtn;
@property(nonatomic,strong) IBOutlet UIView *bootView;
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) IBOutlet UITableView *table;
-(IBAction)backBtnClick:(id)sender;
-(IBAction)addUser:(id)sender;
-(IBAction)deleteUser:(id)sender;
@end

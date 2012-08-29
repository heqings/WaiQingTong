//
//  SigninTypeViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUtilsDelegate.h"
#import "JSON.h"

@interface SigninTypeViewController : UIViewController<UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTable;
    NSDictionary *myData;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;

}
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

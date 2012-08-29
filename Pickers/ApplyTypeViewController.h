//
//  ApplyTypeViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "WorkUtilsDelegate.h"

@interface ApplyTypeViewController : UIViewController<UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTable;
    NSDictionary *myData;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
}
@property(nonatomic,strong) IBOutlet UITableView *myTable;
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
@end

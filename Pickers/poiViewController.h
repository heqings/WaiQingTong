//
//  poiViewController.h
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "NetUtils.h"
#import "Global.h"
#import "PoiInfo.h"
#import "AppGlobalServices.h"
#import "PoiInfoServices.h"
#import "PoiHistory.h"
#import "PoiHistoryServices.h"

@interface poiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *table; 
    NSMutableArray *cellsDataArray;
    int currentPoi;
    
    double latitude;
    double longitude;
}
@property(nonatomic,strong)NSMutableArray *cellsDataArray;
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,nonatomic)double latitude;
@property(nonatomic,nonatomic)double longitude;
@end

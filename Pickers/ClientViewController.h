//
//  ClientViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientFromViewController.h"
#import "ClientServices.h"
#import "Client.h"
#import "ClientInfoViewController.h"
#import "JsonClientServer.h"
#import "ClientListFromViewController.h"
#import "WorkUtilsDelegate.h"
#import "PullingRefreshTableView.h"

@interface ClientViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,UISearchBarDelegate,WorkUtilsDelegate,PullingRefreshTableViewDelegate>{
    NSMutableDictionary *myData;
    PullingRefreshTableView *table;
    BOOL isHidden;
    NSArray *pyArray;
    
    UISearchBar *searchBar;
    UIView *disableViewOverlay; 
    BOOL isSearching;
    
    BOOL refreshing;
}
@property(nonatomic,strong)PullingRefreshTableView *table;
@property(nonatomic,strong)NSMutableDictionary *myData;
@property(nonatomic)BOOL refreshing;
-(void)loadData;
-(void)downloadCompanygates:(id)temp;
-(void)updateTable;
-(void)searchTableSource:(NSString*)str;
-(void)btnChangeGroupMode;
-(void)btnFlushClient;
@end

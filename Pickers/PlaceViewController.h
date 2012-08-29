//
//  PlaceViewController.h
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "PlaceServices.h"
#import "MBProgressHUD.h"
#import "JsonPlaceServer.h"
#import "PlaceMapViewControllerViewController.h"


@interface PlaceViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,UISearchBarDelegate>{
    NSMutableDictionary *myData;
    UITableView *table;
    BOOL isHidden;
    NSArray *pyArray;

    UISearchBar *searchBar;
    UIView *disableViewOverlay; 
    BOOL isSearching;
}
@property(nonatomic,strong) IBOutlet UITableView *table;
-(void)loadData;
-(void)downloadCompanygates:(id)temp;
-(void)updateTable;
-(void)searchTableSource:(NSString*)str;
-(void)btnChangeGroupMode;
-(UIImage*)getPeopleTopImage:(Place*)p;
-(void)btnFlushPlace;
@end

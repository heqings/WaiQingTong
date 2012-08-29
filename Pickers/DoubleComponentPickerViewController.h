//
//  DoubleComponentPickerViewController.h
//  Pickers
//
//  Created by HeQing on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtils.h"
#import "OtherViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageInfoViewController.h"
#import "PeopleServices.h"

@interface DoubleComponentPickerViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,UISearchBarDelegate>{
    NSMutableDictionary *myData;
    UITableView *table;
    BOOL isHidden;
    NSArray *pyArray;
    //
    UISearchBar *searchBar;
    UIView *disableViewOverlay; 
    BOOL isSearching;
    
    //
}
@property(nonatomic,strong) IBOutlet UITableView *table;
-(void)loadData;
-(void)downloadCompanygates:(id)temp;
-(void)updateTable;
-(void)searchTableSource:(NSString*)str;
-(void)btnChangeGroupMode;
-(UIImage*)getPeopleTopImage:(People*)p;
-(void)btnFlushPeople;
@end

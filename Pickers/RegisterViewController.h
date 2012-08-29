//
//  RegisterViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "XyWebViewController.h"
#import "NetUtils.h"
#import "UserServices.h"
// #import "RegexKitLite.h"
#import "Global.h"


@interface RegisterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate>{
    UITableView *myTable;
    NSDictionary *myData;
    UIViewController* login;
    IBOutlet UIButton *xyCheckbox;
    float height;
    
}
@property(nonatomic,strong)IBOutlet UIButton *xyCheckbox;
@property(nonatomic,strong)IBOutlet UITableView *myTable;
@property(nonatomic,strong) NSDictionary *myData;
@property(nonatomic,strong) UIViewController  * login;

-(IBAction)backBtnClick:(id)sender;
-(IBAction)changeCheckBox:(id)sender;
-(IBAction)forwardXy:(id)sender;
-(IBAction)registerMobile:(id)sender;
@end

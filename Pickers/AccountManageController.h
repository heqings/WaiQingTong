//
//  AccountManageController.h
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface AccountManageController : UITableViewController<UITextFieldDelegate>
{
    NSDictionary* myData;
    NSDictionary* field;
    UISwitch*    switchAccount;
}
-(void)switchAction:(id)control;
-(void)updateUserInfo:(User*)user;
@end

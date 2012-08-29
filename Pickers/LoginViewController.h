//
//  LoginViewController.h
//  Pickers
//
//  Created by air macbook on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "NetUtils.h"
#import "UserServices.h"
#import "User.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "GTAppDelegate.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate>{
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *pwdText;
    BOOL registed;
}

@property(nonatomic,strong)IBOutlet UITextField *nameText;
@property(nonatomic,strong)IBOutlet UITextField *pwdText;
//
//注册按钮事件
-(IBAction)registerBtnClick:(id)sender;

//登陆按钮事件
-(IBAction)loginBtnClick:(id)sender;

-(IBAction)backBtnClick:(id)sender;

-(IBAction)getPasswordBack:(id)sender;

-(void)userLogin:(id)temp;
- (void)userRegister:(NSNotification*) notification ;
@end

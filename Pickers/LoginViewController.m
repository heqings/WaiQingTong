//
//  LoginViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "InitDataServer.h"
#import "JsonServer.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "GetPasswordBackViewController.h"
@interface LoginViewController(private)
- (void)textFieldDidEndEditing:(id)sender;
- (void)textFieldDidStartEditing:(id)sender;
@end

@implementation LoginViewController
@synthesize nameText,pwdText;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    registed = false;
    
    nameText=[[UITextField alloc]initWithFrame:CGRectMake(20, 93, 285, 41)];
    nameText.placeholder=@"手机号码";
    nameText.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    nameText.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    nameText.borderStyle=UITextBorderStyleRoundedRect;
    nameText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:nameText];
    //添加事件处理方法
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
    [nameText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
    
    pwdText=[[UITextField alloc]initWithFrame:CGRectMake(20, 172, 285, 41)];
    pwdText.borderStyle=UITextBorderStyleRoundedRect;
    pwdText.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    pwdText.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    pwdText.secureTextEntry=YES;
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwdText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
    [pwdText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:pwdText];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}


//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nameText resignFirstResponder];	
    [pwdText resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 20.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//注册按钮事件
-(IBAction)registerBtnClick:(id)sender{
  RegisterViewController* re = [[RegisterViewController alloc]init];
    
    [self presentModalViewController:re animated:true];
}
-(IBAction)getPasswordBack:(id)sender
{
    
   GetPasswordBackViewController* control = [[GetPasswordBackViewController alloc] init];
   [self presentModalViewController:control animated:TRUE];
    
}
//登陆按钮事件
-(IBAction)loginBtnClick:(id)sender{

     if(nameText.text==nil ||pwdText.text==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"名字或密码不能为空"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];

        return ;
    }

    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:nameText.text,pwdText.text,[Global getKey],nil]
                       forKeys:[NSArray arrayWithObjects:@"mobile",@"pwd",@"key",nil]
                       ];
 
        //提交服务器登录
        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"登录中..." animated:false];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ 
            
            dispatch_async(dispatch_get_main_queue(), ^{ 
                   @try{
                NSDictionary* result = [JsonServer loginUser:dic];
                NSString*     imei = [[result valueForKey:@"data"] valueForKey:@"imei"];
                [[NSUserDefaults standardUserDefaults] setValue:imei forKey:@"imei"];
                [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                [[NSUserDefaults standardUserDefaults] setValue:@"Logining" forKey:@"Status"];
              
                [self dismissModalViewControllerAnimated:YES];
            }
                @catch (NSException* e) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    if([[e name]isEqualToString:@"NetError"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                        message:e.reason
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    if([[e name]isEqualToString:@"loginUserError"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                        message:@"登陆名称或密码错误"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                }
                
            });  
        });  
 
}

//返回按钮事件
-(IBAction)backBtnClick:(id)sender{
     [self  dismissModalViewControllerAnimated:YES];
}

//输入文本结束后，关闭键盘，并恢复视图位置
- (void)textFieldDidEndEditing:(id)sender {
	[sender resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 20.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
	
}

//开始输入文本时，将当前视图向上移动，以显示键盘
- (void)textFieldDidStartEditing:(id)sender	 {
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -20.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
	
}

@end

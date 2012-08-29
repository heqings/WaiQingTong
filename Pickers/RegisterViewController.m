//
//  RegisterViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include "LoginViewController.h"
#import "RegisterViewController.h"
#import "InitDataServer.h"
#import "JsonServer.h"

#import "MBProgressHUD.h"

@interface RegisterViewController(private)
- (void)textFieldDidEndEditing:(id)sender;
- (void)textFieldDidStartEditing:(id)sender;
- (void)showMassage:(NSString *)msg;
@end

@implementation RegisterViewController
@synthesize myTable,myData,xyCheckbox,login;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *jsonString =@"{\"一\":[\"电话号码\",\"电子邮箱\",\"姓名\",\"密码\"]}";
    
    myData = [jsonString JSONValue];
    
    [xyCheckbox setSelected:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    UITableViewCell *startTimeCell=[[UITableViewCell alloc]init];
    
    if([text isEqualToString:@"电话号码"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"电话号码";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *phone=[[UITextField alloc]init];
        phone.frame=CGRectMake(110.0f, 5.0f, 170.0f, 30.0f);
        phone.tag=11;
        phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        phone.keyboardType = UIKeyboardTypeNumberPad;
        [phone addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [phone addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:phone];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"电子邮箱"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"电子邮箱";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *email=[[UITextField alloc]init];
        email.frame=CGRectMake(110.0f, 5.0f, 170.0f, 30.0f);
        email.tag=22;
        email.clearButtonMode = UITextFieldViewModeWhileEditing;
        [email addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [email addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:email];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"姓名"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=3;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"姓      名";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *name=[[UITextField alloc]init];
        name.frame=CGRectMake(110.0f, 5.0f, 170.0f, 30.0f);
        name.tag=33;
        name.clearButtonMode = UITextFieldViewModeWhileEditing;
        [name addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [name addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:name];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"密码"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=4;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"密      码";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *pwd=[[UITextField alloc]init];
        pwd.frame=CGRectMake(110.0f, 5.0f, 170.0f, 30.0f);
        pwd.tag=44;
        pwd.secureTextEntry=YES;
        pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        [pwd addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [pwd addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:pwd];
        
        [startTimeCell addSubview:view];
    }
    
    cell = startTimeCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//返回按钮事件
-(IBAction)backBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
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
- (void)textFieldDidStartEditing:(id)sender{
    int num=[sender tag];
    if (num>22) {
        height=70.0f;
    }else{
        height=0.0f;
    }
    
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -height, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
	
}

//协议按钮选择切换
-(IBAction)changeCheckBox:(id)sender{
    if(xyCheckbox.selected){
        UIImage *img=[UIImage imageNamed:@"checkbox.png"];
        [xyCheckbox setImage:img forState:UIControlStateNormal];
        [xyCheckbox setSelected:NO];
    }else{
        UIImage *img=[UIImage imageNamed:@"checkbox-pressed.png"];
        [xyCheckbox setImage:img forState:UIControlStateNormal];
        [xyCheckbox setSelected:YES];
    }
}

//跳转协议
-(IBAction)forwardXy:(id)sender{
    XyWebViewController *web = [[XyWebViewController alloc]init]; 
    [self presentModalViewController:web animated:YES];
}
//注册事件
-(IBAction)registerMobile:(id)sender{
    
    UIView *view=(UIView *)[myTable viewWithTag:1];
    UITextField *text=(UITextField *)[view viewWithTag:11];
    if (text.text==NULL) {
        [self showMassage:@"电话号码不能为空"];
        return ;
    }
    
    
    UIView *view2=(UIView *)[myTable viewWithTag:2];
    UITextField *text2=(UITextField *)[view2 viewWithTag:22];
    if (text2.text==NULL) {
        [self showMassage:@"电子邮箱不能为空"];
        return ;
    }
    
    UIView *view3=(UIView *)[myTable viewWithTag:3];
    UITextField *text3=(UITextField *)[view3 viewWithTag:33];
    if (text3.text==NULL) {
        [self showMassage:@"昵称不能为空"];
        return ;
    }
    
    UIView *view4=(UIView *)[myTable viewWithTag:4];
    UITextField *text4=(UITextField *)[view4 viewWithTag:44];
    if (text4.text==NULL) {
        [self showMassage:@"密码不能为空"];
        return ;
    }
 
    
    if(text.text!=NULL&&text2.text!=NULL&&text3.text!=NULL&&text4.text!=NULL){
        /*
        if(![text.text isMatchedByRegex:@"^((\\(\\d{3}\\))|(\\d{3}\\-))?13[0-9]\\d{8}|15[89]\\d{8}"]){
            [self showMassage:@"电话号码格式不正确"];
            return ;
        }
        
        if(![text2.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]){
            [self showMassage:@"电子邮箱格式不正确"];
            return ;
        }*/
        
        
        if(!xyCheckbox.selected){
            [self showMassage:@"请勾选遵守协议"];
            return ;
        }    
            
        
        NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        if(token ==nil)
            token=@"";
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:text.text,text2.text,@"",text4.text,@"IOS",[Global getKey],text3.text,@"",token,nil]
                           forKeys:[NSArray arrayWithObjects:@"mobile",@"email",@"nicke",@"pwd",@"mobiletype",@"key",@"name",@"imei",@"token",nil]
                           ];
        //
        //显示注册提示框
        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"注册中..." animated:YES ];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ 
            
            dispatch_async(dispatch_get_main_queue(), ^{ 
                @try{
                    NSDictionary* result = [JsonServer registerUser:dic];
                    
                    NSString* imei = [[result valueForKey:@"data"] valueForKey:@"imei"];
                    [[NSUserDefaults standardUserDefaults] setValue:imei forKey:@"imei"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"Logining" forKey:@"Status"];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:true]; 
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegister" object:nil];
 
                }@catch (NSException* e) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    if([[e name]isEqualToString:@"NetError"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络失败"
                                                                        message:e.reason
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    
                    if([e.name isEqualToString:@"registerUserError"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                                        message:e.reason
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                }
            });  
        });  
     }
}
//显示提示信息
- (void)showMassage:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end

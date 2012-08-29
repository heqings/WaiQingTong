//
//  AccountManageController.m
//  Pickers
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountManageController.h"
#import "JSON.h"
#import "InitDataServer.h"
#import "LoginViewController.h"
#import "JsonServer.h"
@implementation AccountManageController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    // Custom initialization
    NSString * jsonString =@"{\"一\":[\"邮箱地址\",\"手机号码\",\"识别码\"],\"二\":[\"退出当前账号\"]}";
    myData = [jsonString JSONValue];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [switchAccount setOn:false];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int i = [myData count];
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    int i= [[myData valueForKey:[[myData allKeys] objectAtIndex:section]] count];
    return i;
}
-(void)switchAction:(id)control{
    //更新服务器用户状态
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在注销..." animated:TRUE];

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSDictionary *dic=[
                   [NSDictionary alloc] 
                   initWithObjects:
                   [NSArray arrayWithObjects:user.imei,[Global getKey],nil]
                   forKeys:[NSArray arrayWithObjects:@"imei",@"key",nil]
                   ];
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 


    [[NetUtils shareNetworkHelper] requestDataFromURL:@"mobileterminal/setonline" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        [self.navigationController popViewControllerAnimated:true];

        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"User"];
        InitDataServer* ids = [InitDataServer getConnection];
        [ids clearAllData];

        GTAppDelegate *delegate=(GTAppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.rootController.selectedIndex=0; 

        LoginViewController *login = [[LoginViewController alloc]init]; 
        [self presentModalViewController:login animated:true];
    }else{
        [self alertWithMassage:[resultDict objectForKey:@"msg"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFaild:(NSObject*)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)updateUserInfo:(User*)user{
    UserServices * service = [UserServices getConnection];
    [service updateUser:user];
@try{
    [JsonServer updateUserInfoToServer:user];

}@catch(NSException* e){
    if([e.name isEqualToString:@"NetError"])
    {
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误，无法更改邮件"
                                                        message:e.reason
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];


    [textField resignFirstResponder];
    user.email = textField.text;

    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"上传信息..." animated:TRUE];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUserInfo:user];

        });
    });

    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"User"];

    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger count=[indexPath row];

    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if([text isEqualToString:@"退出当前账号"])
    {
        UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cellButton setFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width-20, 45.0f)];
        [cellButton setTitle:@"退出登陆" forState:UIControlStateNormal];
      
        [cellButton setBackgroundImage:[UIImage imageNamed:@"bodyinfo_font_del.png" ]forState:UIControlStateNormal];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:cellButton];
         
        [cellButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventAllTouchEvents];


    }else if([text isEqualToString:@"邮箱地址"])
    {
        cell.textLabel.text=[text stringByAppendingString:@"："];
        
        UITextField* f = [[UITextField alloc]init];
        f.frame=CGRectMake(110, 10 , 200, 80);
        f.opaque=false;
        f.enabled = true;
        f.backgroundColor=[UIColor clearColor];
        f.text=user.email;
        f.delegate = self;

        [cell addSubview:f];
    }else  if([text isEqualToString:@"手机号码"])
    {
        cell.textLabel.text=[text stringByAppendingString:@"："];
        
        UITextField* f = [[UITextField alloc]init];
        f.frame=CGRectMake(110, 10 , 200, 80);
        f.opaque=true;

        f.backgroundColor=[UIColor clearColor];

        f.text=user.mobile;
        f.enabled = false;

        [cell addSubview:f];
    }
    else  if([text isEqualToString:@"识别码"])
    {
        cell.textLabel.text=[text stringByAppendingString:@"："];
        
        UITextField* f = [[UITextField alloc]init];
        f.frame=CGRectMake(110, 10 , 200, 80);
        f.opaque=true;

        f.backgroundColor=[UIColor clearColor];

        f.text=user.imei;
        f.enabled = false;

        [cell addSubview:f];

    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

@end

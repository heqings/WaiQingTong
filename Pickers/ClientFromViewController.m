//
//  ClientFromViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientFromViewController.h"


@implementation ClientFromViewController
@synthesize workUtilsDelegate,myData,myTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title=@"新增详情资料";
    
    NSString *jsonString =@"{\"一\":[\"备注\"],\"二\":[\"联系人\"],\"三\":[\"电子邮箱\"],\"四\":[\"办公号码\"],\"五\":[\"手机号码\"]}";
    myData = [jsonString JSONValue];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" 
                                                                  style:UITabBarSystemItemContacts target:self action:@selector(saveBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= saveButton;
    //语音识别初始化
    speechHelper = [SpeechHelper alloc];
    [speechHelper inita:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

-(void)saveBtnClick:(id)sender{

    
    UIView *nameView=(UIView *)[myTable viewWithTag:1];
    UITextField *nameText=(UITextField *)[nameView viewWithTag:11];
    
    UIView *phoneView=(UIView *)[myTable viewWithTag:2];
    UITextField *phoneText=(UITextField *)[phoneView viewWithTag:22];
    
    UIView *officeView=(UIView *)[myTable viewWithTag:3];
    UITextField *officeText=(UITextField *)[officeView viewWithTag:110];
    
    UIView *emailView=(UIView *)[myTable viewWithTag:4];
    UITextField *emailText=(UITextField *)[emailView viewWithTag:180];
    
    UIView *remarkView=(UIView *)[myTable viewWithTag:5];
    UITextView *remarkText=(UITextView *)[remarkView viewWithTag:55];

    NSInteger customId=[[NSUserDefaults standardUserDefaults] integerForKey:@"chooseClientCustomId"];
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if(nameText.text==nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"联系人不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=2;
        [alertView show];
        return ;
    }
        
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[Global getNullString:nameText.text],[Global getNullString:phoneText.text],[Global getNullString:officeText.text],[Global getNullString:emailText.text],[Global getNullString:remarkText.text],[Global getKey],user.imei,[NSString stringWithFormat:@"%i",customId],nil]
                       forKeys:[NSArray arrayWithObjects:@"linkname",@"linkmobile",@"officetel",@"email",@"remark",@"key",@"imei",@"customId",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"custom/saveLinkman" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        UIView *nameView=(UIView *)[myTable viewWithTag:1];
        UITextField *nameText=(UITextField *)[nameView viewWithTag:11];
        
        UIView *phoneView=(UIView *)[myTable viewWithTag:2];
        UITextField *phoneText=(UITextField *)[phoneView viewWithTag:22];
        
        UIView *officeView=(UIView *)[myTable viewWithTag:3];
        UITextField *officeText=(UITextField *)[officeView viewWithTag:110];
        
        UIView *emailView=(UIView *)[myTable viewWithTag:4];
        UITextField *emailText=(UITextField *)[emailView viewWithTag:180];
        
        UIView *remarkView=(UIView *)[myTable viewWithTag:5];
        UITextView *remarkText=(UITextView *)[remarkView viewWithTag:55];
        
        NSInteger customId=[[NSUserDefaults standardUserDefaults] integerForKey:@"chooseClientCustomId"];
        
        ClientInfo *c=[[ClientInfo alloc]init];
        c.cId=customId;
        c.spId=[[resultDict objectForKey:@"data"] intValue];
        c.linkmobile=[Global getNullString:phoneText.text];
        c.linkname=[Global getNullString:nameText.text];
        c.officetel=[Global getNullString:officeText.text];
        c.remark=[Global getNullString:remarkText.text];
        c.email=[Global getNullString:emailText.text];
        
        [[ClientInfoServices getConnection]insertClientInfo:c];
     
        [workUtilsDelegate reloadTableView];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:[resultDict objectForKey:@"msg"]];
}

- (void)requestFaild:(NSObject*)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag=1;
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        if(alertView.tag<2)
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [myData count];
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
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    if([text isEqualToString:@"联系人"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"联 系 人";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *nameText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [nameText setFont:[UIFont fontWithName:@"Arial" size:16]];
        nameText.tag=11;
        nameText.font=font;
        nameText.backgroundColor=[UIColor clearColor];
        [view addSubview:nameText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"手机号码"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"手机号码";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *phoneText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [phoneText setFont:[UIFont fontWithName:@"Arial" size:16]];
        phoneText.tag=22;
        phoneText.delegate=self;
        phoneText.keyboardType = UIKeyboardTypeNumberPad;
        phoneText.font=font;
        phoneText.backgroundColor=[UIColor clearColor];
        [view addSubview:phoneText];
        
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"办公号码"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=3;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"办公号码";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *officeText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [officeText setFont:[UIFont fontWithName:@"Arial" size:16]];
        officeText.tag=110;
        officeText.font=font;
        officeText.delegate=self;
        officeText.backgroundColor=[UIColor clearColor];
        [officeText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [officeText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        
        [view addSubview:officeText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"电子邮箱"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=4;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"电子邮箱";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextField *emailText=[[UITextField alloc]initWithFrame:CGRectMake(110, 4, 165, 30)];
        [emailText setFont:[UIFont fontWithName:@"Arial" size:16]];
        emailText.tag=180;
        emailText.font=font;
        emailText.backgroundColor=[UIColor clearColor];
        [emailText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
        [emailText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];
        [view addSubview:emailText];
        
        [startTimeCell addSubview:view];
    }else if([text isEqualToString:@"备注"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 110.0f);
        view.tag=5;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 40.0f, 80.0f, 30.0f);
        label.text=@"备注";
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 47.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextView *text=[[UITextView alloc]init];
        text.frame=CGRectMake(110.0f, 3.0f, 165.0f, 92.0f);
        [text setFont:[UIFont fontWithName:@"Arial" size:16]];
        text.tag=55;
        text.contentOffset = CGPointMake(0,15);
        text.backgroundColor=[UIColor clearColor];
        text.delegate=self;
        UIEdgeInsets offset = UIEdgeInsetsMake(1, 0, 0, 0);
        [text setContentSize:text.frame.size];
        [text setContentInset:offset];

        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];  
        topView.barStyle = UIBarStyleBlackTranslucent; 
        
        //语音输入按钮
        UIBarButtonItem * speechButton = [[UIBarButtonItem alloc]initWithTitle:@"语音" style:UIBarButtonItemStyleDone target:self action:@selector(onButtonRecognize)]; 
        //语音识别绑定输入文本和触发按钮
        [speechHelper setSource:text speechTrigger:speechButton];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];  
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:speechButton,btnSpace,doneButton,nil];  
        [topView setItems:buttonsArray];          
        [text setInputAccessoryView:topView]; 
        
        [view addSubview:text];
        
        [startTimeCell addSubview:view];
    }
    
    cell = startTimeCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//uitextview输入文字时代理，当文字输入超过一行时，文本自动往上弹
-(void)textViewDidChange:(UITextView *)textView{
    if(textView.contentSize.height>36.000000f){
        UIEdgeInsets offset = UIEdgeInsetsMake(0, 0, 20, 0);
        [textView setContentInset:offset];
    }  
}

//隐藏键盘
-(IBAction)dismissKeyBoard{  
    UIView *view=(UIView *)[myTable viewWithTag:5];
    UITextField *text=(UITextField *)[view viewWithTag:55];
    [text resignFirstResponder];  
    [UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    if([text isEqualToString:@"备注"]){
        return 120.0f;
    }else{
        return 40.0f;
    }
}

// 语音识别触发按钮，启动语音输入
- (void)onButtonRecognize
{
    [speechHelper speechStart];
}


//输入文本结束后，关闭键盘，并恢复视图位置
- (void)textFieldDidEndEditing:(id)sender {
	[sender resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//开始输入文本时，将当前视图向上移动，以显示键盘
- (void)textFieldDidStartEditing:(id)sender	 {
    UITextField *text=(UITextField*)sender;
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -text.tag, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
	
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{ 
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -250, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
    return YES;
}    

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    UIView *view=(UIView *)[myTable viewWithTag:5];
    UITextField *text=(UITextField *)[view viewWithTag:55];
    [text resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag==22){
        if (range.location>10)return NO;
    }else if(textField.tag==110){
        if (range.location>11)return NO;
    }
    
    return YES;
}
@end

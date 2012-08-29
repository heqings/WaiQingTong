//
//  NewApplyViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewApplyViewController.h"

@interface NewApplyViewController (private)
-(NSString *)getTypeByString:(NSString *)type;
@end

@implementation NewApplyViewController
@synthesize myData,myTable,workUtilsDelegate;

//通知
- (void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

//键盘显示时
- (void) keyboardWasShown:(NSNotification *) notif{
    [UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -40.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//键盘隐藏时
- (void) keyboardWasHidden:(NSNotification *) notif{
    [UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0,0.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

#pragma mark - View lifecycle
//创建返回按钮，页面跳转动画
-(void)pageForward{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    //self.navigationController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" 
                                                                    style:UITabBarSystemItemContacts target:self action:@selector(saveApply:)]; 
    
    self.navigationItem.rightBarButtonItem= applyButton;
    self.navigationItem.title=@"新增申请";
    
    NSString *jsonString =@"{\"一\":[\"申请类型\"],\"二\":[\"申请详情\"]}";
    
    myData = [jsonString JSONValue];
    
    //语音识别初始化
    speechHelper = [SpeechHelper alloc];
    [speechHelper inita:self];  
}

- (void)alertWithMassage:(NSString *)tMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:tMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidUnload
{
    myTable=nil;
    myData=nil;
    speechHelper=nil;
    [super viewDidUnload];
}

//新增保存
-(void)saveApply:(id)sender{
    UIView *view=(UIView *)[myTable viewWithTag:1];
    UILabel *text=(UILabel *)[view viewWithTag:11];
    
    UIView *view2=(UIView *)[myTable viewWithTag:2];
    UITextView *text2=(UITextView *)[view2 viewWithTag:22];
    
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:[self getTypeByString:text.text],text2.text,[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"type",@"content",@"key",@"imei",nil]
                       ];
    
    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"apply!sumitapply.action" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        UIView *view=(UIView *)[myTable viewWithTag:1];
        UILabel *text=(UILabel *)[view viewWithTag:11];
        
        UIView *view2=(UIView *)[myTable viewWithTag:2];
        UITextView *text2=(UITextView *)[view2 viewWithTag:22];

        ApplyServices *conn=[ApplyServices getConnection];
        [conn insertApply:[self getTypeByString:text.text] content:text2.text applyTime:[[resultDict objectForKey:@"data"] objectForKey:@"applytime"] status:@"O"];
        
        
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_SQ]];
        NotifySqServices *notifySqConn=[NotifySqServices getConnection];
        
        NSString *title;
        if ([text2.text length]>10) {
            NSRange idsRange = NSMakeRange(0,10);
            title=[[NSString stringWithFormat:@"%@...",text2.text] substringWithRange:idsRange];
        }else{
            title=text2.text;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"申请信息" isRead:@"N" readCount:1 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_SQ] detailText:title];
        }
        
        Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_SQ]];
        
        [notifySqConn insertNotifySq:user.userId ntId:tempNotify.ntId spId:[[[resultDict objectForKey:@"data"]objectForKey:@"id"]intValue] nsContent:text2.text nsCreateDate:[[resultDict objectForKey:@"data"] objectForKey:@"applytime"]nsRemarkPeople:@"" nsRemarkContent:@"" status:@"N" nsType:[self getTypeByString:text.text]];
        
        int count=(int)tempNotify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:title ntDate:[Global getCurrentTime]];
        
        [workUtilsDelegate reloadTableView];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMassage:[resultDict objectForKey:@"msg"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
         [self.navigationController popViewControllerAnimated:YES];
    }
} 

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    UITableViewCell *startTimeCell=[[UITableViewCell alloc]init];
    
    if([text isEqualToString:@"申请类型"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"申请类型";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UILabel *sqLabel=[[UILabel alloc]init];
        sqLabel.frame=CGRectMake(80.0f, 0.0f, 200.0f, 30.0f);
        sqLabel.text=@"活动";
        sqLabel.textAlignment=UITextAlignmentCenter;
        sqLabel.backgroundColor=[UIColor clearColor];
        sqLabel.tag=11;
        [view addSubview:sqLabel];
        
        [startTimeCell addSubview:view];

    }else if([text isEqualToString:@"申请详情"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 110.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 40.0f, 80.0f, 30.0f);
        label.text=@"申请详情";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 47.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextView *text=[[UITextView alloc]init];
        text.frame=CGRectMake(110.0f, 3.0f, 160.0f, 92.0f);
        [text setFont:[UIFont fontWithName:@"Arial" size:16]];
        text.tag=22;
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
    if([text isEqualToString:@"申请类型"]){
          [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }    
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
    UIView *view=(UIView *)[myTable viewWithTag:2];
    UITextView *text=(UITextView *)[view viewWithTag:22];
    [text resignFirstResponder];  
    
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    if([text isEqualToString:@"申请详情"]){
        return 120.0f;
    }else{
        return 40.0f;
    }
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSString *text=[[myData valueForKey:[[myData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:count];
    UIView *view=(UIView *)[myTable viewWithTag:2];
    UITextView *textView=(UITextView *)[view viewWithTag:22];
    if([text isEqualToString:@"申请类型"]){
        [textView resignFirstResponder];
        [self pageForward];
        ApplyTypeViewController *type=[[ApplyTypeViewController alloc]init];
        type.workUtilsDelegate=self;
        [self.navigationController pushViewController:type animated:YES];
    }else if([text isEqualToString:@"申请详情"]){
        [textView becomeFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

//申请类型选择
-(void)chooseTypeName:(NSString *)name{
    UIView *view=(UIView *)[myTable viewWithTag:1];
    UILabel *text=(UILabel *)[view viewWithTag:11];
    text.text=name;
}

// 语音识别触发按钮，启动语音输入
- (void)onButtonRecognize
{
    [speechHelper speechStart];
}

//获取申请类型
-(NSString *)getTypeByString:(NSString *)type{
    if([type isEqualToString:@"活动"]){
        return @"H";
    }else if([type isEqualToString:@"费用"]){
        return @"F";
    }else if([type isEqualToString:@"出差"]){
        return @"C";
    }else if([type isEqualToString:@"其他"]){
        return @"Q";
    }
    return @"H";
}


@end

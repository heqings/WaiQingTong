//
//  NewPlanViewController.m
//  Pickers
//
//  Created by air macbook on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "WorkLog.h"
#import "NewPlanViewController.h"
#import "SpeechHelper.h"


@implementation NewPlanViewController
@synthesize myTable,myData,workUtilsDelegate;

//通知
- (void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

//键盘显示时
- (void) keyboardWasShown:(NSNotification *) notif{
    isShow=YES;
    [djdateGregorianView removeFromSuperview];
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	CGRect newFrame = CGRectMake(0.0, -180.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

//键盘隐藏时
- (void) keyboardWasHidden:(NSNotification *) notif{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2f];
	CGRect newFrame = CGRectMake(0.0,0.0, 320.0, 460.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    UIBarButtonItem *planButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                   style:UITabBarSystemItemContacts 
                                                                  target:self 
                                                                  action:@selector(saveBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= planButton;
    self.navigationItem.title=@"新增工作";
    //self.navigationController.delegate = self;
    
    //公历日期选择器
    djdateGregorianView=[[IDJDatePickerView alloc]initWithFrame:CGRectMake(0, 180, 320, 200) type:Gregorian1];
    djdateGregorianView.delegate=self;
    isShow=YES;
    workType=@"P";
    NSString *jsonString =@"{\"4\":[\"工作详情\"],\"3\":[\"结束时间\"],\"2\":[\"开始时间\"],\"1\":[\"工作类型\"]}";
    
    myData = [jsonString JSONValue];
    
    
    
    //语音识别初始化
    speechHelper = [SpeechHelper alloc];
    [speechHelper inita:self];  
}
-(void)dealloc
{
    djdateGregorianView.delegate=nil;
    workType =nil;
}
- (void)viewDidUnload
{
    djdateGregorianView=nil;
    myData=nil;
    myTable=nil;
    speechHelper=nil;
    workType=nil;
    [super viewDidUnload];
}

//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *temp;
    
    if(cal.month.length==1){      
        temp=[NSString stringWithFormat:@"%@-0%@",cal.year,cal.month];
    }else{
        temp=[NSString stringWithFormat:@"%@-%@",cal.year,cal.month];
    }
    if(cal.day.length==1){
        temp=[NSString stringWithFormat:@"%@-0%@",temp,cal.day];
        
    }else{
        temp=[NSString stringWithFormat:@"%@-%@",temp,cal.day];
        
    }
    if(textCount==1){
        UIView *view=(UIView *)[myTable viewWithTag:1];
        UIButton *text=(UIButton *)[view viewWithTag:11];
        
        [text setTitle:temp forState:UIControlStateNormal];
    }else if(textCount==2){
        UIView *view2=(UIView *)[myTable viewWithTag:2];
        UIButton *text2=(UIButton *)[view2 viewWithTag:22];
        
        [text2 setTitle:temp forState:UIControlStateNormal];
    }
    temp=NULL;
}

//工作计划保存
-(void)saveBtnClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
    UIView *view=(UIView *)[myTable viewWithTag:1];
    UIButton *text=(UIButton *)[view viewWithTag:11];
   
    UIView *view2=(UIView *)[myTable viewWithTag:2];
    UIButton *text2=(UIButton *)[view2 viewWithTag:22];
    
    UIView *view3=(UIView *)[myTable viewWithTag:3];
    UITextView *text3=(UITextView *)[view3 viewWithTag:33];
  
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSDictionary *dic=[
                       [NSDictionary alloc] 
                       initWithObjects:
                       [NSArray arrayWithObjects:workType,text.titleLabel.text,text2.titleLabel.text, text3.text,[Global getKey],user.imei,nil]
                       forKeys:[NSArray arrayWithObjects:@"type",@"startTime",@"endTime",@"content",@"key",@"imei",nil]
                       ];

    NSString *json=[dic JSONRepresentation];
    NSMutableData *postBody = [NSMutableData data];
    NSString *param =[NSString stringWithFormat:@"param=%@",json];
    [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]]; 
    
        
    [[NetUtils shareNetworkHelper] requestDataFromURL:@"worklog!sumitworklog.action" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;
    if([[resultDict objectForKey:@"result"]isEqualToString:@"success"]){
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        UIView *view=(UIView *)[myTable viewWithTag:1];
        UIButton *text=(UIButton *)[view viewWithTag:11];
        
        UIView *view2=(UIView *)[myTable viewWithTag:2];
        UIButton *text2=(UIButton *)[view2 viewWithTag:22];
        
        UIView *view3=(UIView *)[myTable viewWithTag:3];
        UITextView *text3=(UITextView *)[view3 viewWithTag:33];
        
        WorkLogServices *work=[WorkLogServices getConnection];
        [work insertWorkLog:workType content:text3.text startTime:text.titleLabel.text endTime:text2.titleLabel.text createTime:[[resultDict objectForKey:@"data"]objectForKey:@"createtime"]];
        
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRZ]];
        NotifyGzrzServices *notifyGzrzConn=[NotifyGzrzServices getConnection];
        
        NSString *title;
        if ([text3.text length]>10) {
            NSRange idsRange = NSMakeRange(0,10);
            title=[[NSString stringWithFormat:@"%@...",text3.text] substringWithRange:idsRange];
        }else{
            title=text3.text;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"工作日志" isRead:@"N" readCount:1 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_GZRZ] detailText:title];
        }
        Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRZ]];
        
        [notifyGzrzConn insertNotifyGzrz:user.userId ntId:tempNotify.ntId spId:[[[resultDict objectForKey:@"data"]objectForKey:@"id"]intValue] ngContent:text3.text ngCreateDate:[[resultDict objectForKey:@"data"]objectForKey:@"createtime"] ngRemarkContent:@"" ngRemarkPeople:@"" status:@"N" ngType:workType];
        
        int count=(int)tempNotify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:title ntDate:[Global getCurrentTime]];
        
        [workUtilsDelegate reloadTableView];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:[resultDict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
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
    NSArray* temp=   [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[myData valueForKey:[temp  objectAtIndex:indexPath.section]] objectAtIndex:count];
    
    UITableViewCell *startTimeCell=[[UITableViewCell alloc]init];
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if([text isEqualToString:@"工作类型"]){

        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=4;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"工作类型";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]init];    
        segmentedControl.frame = CGRectMake(110.0,2.0, 170.0, 30.0);   
        segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;//设置样式  
        segmentedControl.momentary = NO;//设置在点击后是否恢复原样  
        [segmentedControl addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl insertSegmentWithTitle:@"工作计划" atIndex:0 animated:YES];
        [segmentedControl insertSegmentWithTitle:@"工作总结" atIndex:1 animated:YES];
        segmentedControl.selectedSegmentIndex=0;
        [view addSubview:segmentedControl];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];

        [startTimeCell addSubview:view];
       
    }else if([text isEqualToString:@"开始时间"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=1;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"开始时间";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UIButton *startTime=[[UIButton alloc]init];
        startTime.frame=CGRectMake(80.0f, 3.0f, 200.0f, 30.0f);
        
        [startTime setTitle:[formatter stringFromDate:nowDate] forState:UIControlStateNormal];
        startTime.titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
        [startTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        startTime.tag=11;
        [startTime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:startTime];
        
        [startTimeCell addSubview:view];
        
    }else if([text isEqualToString:@"结束时间"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
        view.tag=2;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        label.text=@"结束时间";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 7.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UIButton *endTime=[[UIButton alloc]init];
        endTime.frame=CGRectMake(80.0f, 3.0f, 200.0f, 30.0f);
        [endTime setTitle:[formatter stringFromDate:nowDate] forState:UIControlStateNormal];
        endTime.titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
        [endTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        endTime.tag=22;
        [endTime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:endTime];
        
        [startTimeCell addSubview:view];
      
    }else if([text isEqualToString:@"工作详情"]){
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(20.0f, 5.0f, 280.0f, 110.0f);
        view.tag=3;
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0.0f, 40.0f, 80.0f, 30.0f);
        label.text=@"工作详情";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        
        UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_0052_03" ofType:@"png"]];
        UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        recordImageView.frame = CGRectMake(95.0f, 47.0f, 1.0f,17.0f);
        [view addSubview:recordImageView];
        
        UITextView *text=[[UITextView alloc]init];
        text.frame=CGRectMake(110.0f, 8.0f, 160.0f, 92.0f);
        [text setFont:[UIFont fontWithName:@"Arial" size:16]];
        text.tag=33;
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

// 语音识别触发按钮，启动语音输入
- (void)onButtonRecognize
{
    [speechHelper speechStart];
}

//隐藏键盘
-(IBAction)dismissKeyBoard{  
    UIView *view=(UIView *)[myTable viewWithTag:3];
    UITextView *text=(UITextView *)[view viewWithTag:33];
    [text resignFirstResponder];  
    
}

//开始时间、结束时间选择判断
-(void)chooseTime:(id)sender{
    UIView *view3=(UIView *)[myTable viewWithTag:3];
    UITextView *text3=(UITextView *)[view3 viewWithTag:33];
    [text3 resignFirstResponder];
    
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==11){
        textCount=1;
        djdateGregorianView.frame=CGRectMake(0, 180, 320, 200);
    }else{
        textCount=2;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];
        CGRect newFrame = CGRectMake(0.0, -120.0, 320.0, 460.0);
        self.view.frame = newFrame;
        [UIView commitAnimations];
         djdateGregorianView.frame=CGRectMake(0, 290, 320, 200);
    }
    if(isShow){
        [self.view addSubview:djdateGregorianView];
        isShow=NO;
    }
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count=[indexPath row];
    NSArray* temp=   [[myData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *text=[[myData valueForKey:[temp objectAtIndex:indexPath.section]] objectAtIndex:count];
    if([text isEqualToString:@"工作详情"]){
        return 120.0f;
    }else{
        return 40.0f;
    }
}

-(void)segmentBtnClick:(id)sender{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            workType=@"P";
            break;
        }    
        case 1:
        {
            workType=@"Z";
            break;
        }
        default:
            break;
    }
}
@end

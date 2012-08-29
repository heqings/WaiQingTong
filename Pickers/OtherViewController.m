//
//  OtherViewController.m
//  JsonDemo
//
//  Created by air macbook on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OtherViewController.h"
#import "ImageViewController.h"
#include "lame.h"

#define TEXTFIELDTAG	100
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define LOADINGVIEWTAG	400
#define SHOWWINDOW     500
#define SPEAK          600
#define SPEAKWINDOW    900
#define AMPVOICE            999
#define SPEAKBTN       888
#define VOICEIMG       700

#define XMAX	20.0f

@interface OtherViewController (private)
-(void)rechangeImg;//还原原先的语音图片
-(BOOL)getImageRange:(NSString*)message;
-(void)connectedSocket;;
@end

@implementation OtherViewController
@synthesize /*sendSocket,*/workUtilsDelegate;

//通知
- (void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

//键盘显示时
- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    keyCode=keyboardSize.height;
    if(keyboardSize.height==252.000000f){
        UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        UITextField *textfield=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
        CGRect frame = textfield.frame;               
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
        [UIView setAnimationDuration:0.3f];
        float width = self.view.frame.size.width;                
        float height = self.view.frame.size.height;        
        CGRect rect = CGRectMake(0.0f,-(frame.origin.y + 32),width,height);                
        self.view.frame = rect;        
        
        [UIView commitAnimations];
    }
}

//键盘隐藏时
- (void) keyboardWasHidden:(NSNotification *) notif{
    if(keyCode==252.000000f){
        CGRect rect = CGRectMake(0.0f,0.0f,320.0f,416.0f);                
        self.view.frame = rect; 
    }
    
    isShowWindow=YES;
    [[self.view viewWithTag:SHOWWINDOW] removeFromSuperview];
}

#pragma mark view controller methods
-(void)viewDidUnload{
    msgArray=nil;
    currentView=nil;
    chatArray=nil;
    recorder=nil;
    player=nil;
    timerCount=nil;
    activityView=nil;
    rootPath=nil;
    rootName=nil;
    recordCount=nil;
    timer=nil;
    [super viewDidUnload];
}

- (id)init {
	if(self = [super init]) {

        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_user"] style:UITabBarSystemItemContacts target:self action:@selector(addUser:)]; 
        
        self.navigationItem.rightBarButtonItem= addButton;
        
        [self registerForKeyboardNotifications];
		UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		self.view = contentView;
        
		chatArray = [[NSMutableArray alloc] initWithCapacity:0];
        NotifyServices *conn=[NotifyServices getConnection];
        
        NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
        Notify *notify=[conn findById:notifyId];
        if(notify.toUser!=nil){
            self.navigationItem.title=notify.ntTitle;
        }
        
        
        isShowWindow=YES;
        isCamera=NO;
        isSpeakBtn=YES;
		
        UIButton *speakBtn = [[UIButton alloc] initWithFrame:CGRectMake(67.0f, 4.0f, 185.0f, 38.0f)];
        speakBtn.tag=SPEAK;
        [speakBtn setImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
        [speakBtn addTarget:self action:@selector(handleLongPressStart) forControlEvents:UIControlEventTouchDown];
        [speakBtn addTarget:self action:@selector(handleLongPressEnd) forControlEvents:UIControlEventTouchUpOutside];
        [speakBtn addTarget:self action:@selector(handleLongPressEnd) forControlEvents:UIControlEventTouchUpInside];
        
        //语音，文字切换按钮
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 34.0f, 34.0f)];
        btn.tag=SPEAKBTN;
        [btn setImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal_2"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
        
        //类型选择按钮     
        UIButton *btn2=[[UIButton alloc] initWithFrame:CGRectMake(270.0f, 5.0f, 34.0f, 34.0f)];
        [btn2 setImage:[UIImage imageNamed:@"type_select_btn_nor"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"type_select_btn_nor_2"] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(showWindow) forControlEvents:UIControlEventTouchUpInside];
        
        //表情
        /*
        UIButton *btn3=[[[UIButton alloc] initWithFrame:CGRectMake(280.0f, 5.0f, 34.0f, 34.0f)]autorelease];
        [btn3 setImage:[UIImage imageNamed:@"type_select_btn_xl"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"type_select_btn_xl_2"] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(showface:) forControlEvents:UIControlEventTouchUpInside];
        */
		UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
		toolBar.tag = TOOLBARTAG;
        toolBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tools_bar"]];
        toolBar.opaque = NO;
        [toolBar addSubview:btn];
        [toolBar addSubview:speakBtn];
        [toolBar addSubview:btn2];
        //[toolBar addSubview:btn3];
        
		[self.view addSubview:toolBar];
        
		tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f) style:UITableViewStylePlain];
		tableView.delegate = self;
		tableView.dataSource = self;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		tableView.tag = TABLEVIEWTAG;
        
		[self.view addSubview:tableView];
        
        [self loadNotifyData];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNoifyChatMessage:) name:@"NoifyChatMessage" object:nil];
		
        /*
         UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
         loadingView.backgroundColor = [UIColor darkGrayColor];
         UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
         activityView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
         [activityView startAnimating];
         [loadingView addSubview:activityView];
         [activityView release];
         loadingView.hidden = YES;
         loadingView.tag = LOADINGVIEWTAG;
         [self.view addSubview:loadingView];
         [loadingView release];
         */
        
	}
	
	return self;
}
-(void)loadNotifyData{
    NotifyServices *conn=[NotifyServices getConnection];
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    
    [conn updateById:notifyId readCount:0];
   
    [chatArray removeAllObjects];

    NSMutableArray *all=[[NotifyInfoServices getConnection]findAll:notifyId];
    for(int i=0;i<[all count];i++){
        
        NotifyInfo *notifyInfo=(NotifyInfo *)[all objectAtIndex:i];  
        
        BOOL isMySpeaking=YES;
        if([notifyInfo.isMySpeaking isEqualToString:@"Y"]){
            isMySpeaking=YES;
        }else{
            isMySpeaking=NO;
        }
        
        if([notifyInfo.niType isEqualToString:[Global getAUDIO_MSG]]){
            
            UIView *chatView = [SoundUtils recordView:isMySpeaking recordCount:notifyInfo.recordTime peopleId:notifyInfo.peopelId showTime:notifyInfo.niDate];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:notifyInfo.niPath, @"text",isMySpeaking?@"self":@"other", @"speaker", chatView, @"view",@"record",@"type", nil]];
            
        }else if([notifyInfo.niType isEqualToString:[Global getIMAGE_MSG]]){
            UIView *chatView = [SoundUtils imageView: notifyInfo.niPath from:isMySpeaking peopleId:notifyInfo.peopelId showTime:notifyInfo.niDate];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:notifyInfo.niPath, @"text",isMySpeaking?@"self":@"other", @"speaker", chatView, @"view", @"image",@"type",nil]];
        }else if([notifyInfo.niType isEqualToString:[Global getTEXT_MSG]]){
            
            UIView *chatView=[SoundUtils bubbleView:[NSString stringWithFormat:@"%@",notifyInfo.niContent] 
                                               from:isMySpeaking peopleId:notifyInfo.peopelId showTime:notifyInfo.niDate];
            
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:notifyInfo.niContent, @"text",isMySpeaking?@"self":@"other", @"speaker", chatView, @"view",@"text",@"type", nil]];
        }else if([notifyInfo.niType isEqualToString:[Global getVEDIO_MSG]]){
            
        }else if([notifyInfo.niType isEqualToString:[Global getPHIZ_MSG]]){
            textArray=[[NSMutableArray alloc]init];
            [self getImageRange:notifyInfo.niContent];
            
            UIView *chatView = [SoundUtils faceView:YES textArray:textArray];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:notifyInfo.niContent, @"text",isMySpeaking?@"self":@"other", @"speaker", chatView, @"view", @"face",@"type",nil]];
        }
    }
    if([chatArray count]>0){
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }       
}

//显示消息组人员
-(void)addUser:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    ShowUserViewController *show=[[ShowUserViewController alloc]init];
    [self.navigationController pushViewController:show animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    NotifyServices *conn=[NotifyServices getConnection];
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    
    
     [conn updateById:notifyId readCount:0];
    if([player isPlaying]){
        [player stop];
        [imgTimer invalidate];
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView *chatView = [[chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
	return chatView.frame.size.height+10.0f;
}


- (UITableViewCell *)tableView:(UITableView *)temp_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [temp_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        
		cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSDictionary *chatInfo = [chatArray objectAtIndex:[indexPath row]];
	for(UIView *subview in [cell.contentView subviews])
		[subview removeFromSuperview];
    
	[cell.contentView addSubview:[chatInfo objectForKey:@"view"]];
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)temp_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    UITextField *textfield=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
    [textfield resignFirstResponder];
    
    NSDictionary *dic=[chatArray objectAtIndex:[indexPath row]];
    if([[dic objectForKey:@"type"]isEqualToString:@"record"]){//语音
        if([player isPlaying]){
            [player stop];
            [imgTimer invalidate];
            [self rechangeImg];
        }
        currentView=[dic objectForKey:@"view"];
        imgNum=1;
        isMyVoiceImg=[dic objectForKey:@"speaker"];
        
        NSURL *url = [NSURL fileURLWithPath:[dic objectForKey:@"text"]];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL: url 
                                                        error: nil];
        player.delegate=self;
        [player setVolume:3.0];//设置音量大小
        player.numberOfLoops=0;//设置播放次数，－1为一直循环，0为一次
        [player play];
        imgTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeImg) userInfo:nil repeats:YES]; 
        
    }else if([[dic objectForKey:@"type"]isEqualToString:@"image"]){//图片
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
        backbutton.title=@"返回";
        self.navigationItem.backBarButtonItem= backbutton;
        
        ImageViewController *image = [[ImageViewController alloc]init];
        image.url=[dic objectForKey:@"text"];
        [self.navigationController pushViewController:image animated:YES];
    }
    [temp_tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}    

#pragma mark text file methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(keyCode==252.000000f){
        UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        UITextField *textfield=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
        CGRect frame = textfield.frame;
        NSTimeInterval animationDuration = 0.30f;                
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;                
        float height = self.view.frame.size.height;        
        
        CGRect rect = CGRectMake(0.0f,-(frame.origin.y + 29),width,height);                
        self.view.frame = rect;        
        
        [UIView commitAnimations];
    }    
    
    isEditing=YES;
    [[self.view viewWithTag:SHOWWINDOW] removeFromSuperview];
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 156.0f, 320.0f, 44.0f);
	UITableView *temp_tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	temp_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 156.0f);
	if([chatArray count])
		[temp_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    isEditing=NO;
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
	UITableView *temp_tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	temp_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(![textField.text isEqualToString:@""]){
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        textArray=[[NSMutableArray alloc]init];
        BOOL isMessage=[self getImageRange:textField.text];
        
        Notify *notify=[[NotifyServices getConnection]findById:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"]];
        
        if(isMessage){
            NSString *time=[Global getCurrentTime];
            
            [[NotifyInfoServices getConnection]insertNotifyInfo:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"] peopelId:user.userId niType:[Global getTEXT_MSG] niName:@"" niPath:@"" niStatus:@"Y" niDate:time isRead:@"Y" isMySpeaking:@"Y" niContent:textField.text recordTime:@""];
            
            NSDictionary *dic=[
                               [NSDictionary alloc] 
                               initWithObjects:[NSArray arrayWithObjects:textField.text,@"0",@"",notify.toUser,[Global getCurrentTime],[Global getTEXT_MSG],[NSString stringWithFormat:@"%i",user.userId],nil]
                               forKeys:[NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                               ];
            
            NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"];  
            NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];

            NSDictionary* dic_data = [NSDictionary dictionaryWithObject:newData forKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendDataBySocketServer" object:nil userInfo:dic_data];
            UIView *chatView = [SoundUtils bubbleView:[NSString stringWithFormat:@"%@", textField.text] 
                                                 from:YES peopleId:0 showTime:time];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"text",@"self", @"speaker", chatView, @"view", @"text",@"type",nil]];
        }else{
            [[NotifyInfoServices getConnection]insertNotifyInfo:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"] peopelId:user.userId niType:[Global getPHIZ_MSG] niName:@"" niPath:@"" niStatus:@"Y" niDate:[Global getCurrentTime] isRead:@"Y" isMySpeaking:@"Y" niContent:textField.text recordTime:@""];
            
            NSDictionary *dic=[
                               [NSDictionary alloc] 
                               initWithObjects:[NSArray arrayWithObjects:textField.text,@"0",@"",notify.toUser,[Global getCurrentTime],[Global getPHIZ_MSG],[NSString stringWithFormat:@"%i",user.userId],nil]
                               forKeys:[NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                               ];
            
            NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"];  
            NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];
            
            NSDictionary* dic_data = [NSDictionary dictionaryWithObject:newData forKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendDataBySocketServer" object:nil userInfo:dic_data];
            
            UIView *chatView = [SoundUtils faceView:YES textArray:textArray];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"text",@"self", @"speaker", chatView, @"view", @"face",@"type",nil]];
        }
        NSString *detailText=[[NSString alloc]init];
        
        NSString *tempMsg=textField.text;
        if(tempMsg.length>10){
            detailText=[tempMsg substringToIndex:10];
            detailText=[detailText stringByAppendingString:@"..."];
        }else{
            detailText=tempMsg;
        }
        NotifyServices *conn=[NotifyServices getConnection];
        [conn updateById:notify.ntId readCount:0 detailText:detailText ntDate:[Global getCurrentTime]];
        
        UITableView *temp_tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        [temp_tableView reloadData];
        [temp_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        textField .text=@"";
        [textField resignFirstResponder];
    } 
    return YES;
}

//send完后隐藏键盘
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.text=@"";
    [textField resignFirstResponder];
    return NO;
}

//语音，文字按钮转换
-(void)changeBtn{
    if(isSpeakBtn){
        UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        UIButton *btn=(UIButton *)[toolBar viewWithTag:SPEAKBTN];
        [btn setImage:[UIImage imageNamed:@"type_select_btn_text"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"type_select_btn_text_2"] forState:UIControlStateHighlighted];
        
        UIButton *btn2=(UIButton *)[toolBar viewWithTag:SPEAK];
        [btn2 removeFromSuperview];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(67.0f, 4.0f, 185.0f, 38.0f)];
        textfield.tag = TEXTFIELDTAG;
        textfield.delegate = self;
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textfield.enablesReturnKeyAutomatically = YES;
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.returnKeyType = UIReturnKeySend;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        textfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        
        [toolBar addSubview:textfield];
        [textfield becomeFirstResponder];
        isShowWindow=YES;
        isSpeakBtn=NO;
    }else{
        UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
        UIButton *btn=(UIButton *)[toolBar viewWithTag:SPEAKBTN];
        [btn setImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal_2"] forState:UIControlStateHighlighted];
        
        UITextField *text=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
        [text removeFromSuperview];
        
        UIButton *speakBtn = [[UIButton alloc] initWithFrame:CGRectMake(67.0f, 4.0f, 185.0f, 38.0f)];
        speakBtn.tag=SPEAK;
        [speakBtn setImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
        [speakBtn addTarget:self action:@selector(handleLongPressStart) forControlEvents:UIControlEventTouchDown];
        [speakBtn addTarget:self action:@selector(handleLongPressEnd) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:speakBtn];
        
        isSpeakBtn=YES; 
    }
}

//显示功能选择提示框
-(void)showWindow{
    
    //if(isShowWindow){
        //
        
        /*
        isShowWindow=NO;
        UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(75.0f, 20.0f,100.0f, 73.0f)];
        //
        returnView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        returnView.opaque = NO;
        returnView.tag=SHOWWINDOW;
        //
        //背景
        UIImage *bubbleBackground = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"voice_rcd_btn_nor" ofType:@"png"]];
        //拍照图片
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"camera_btn_pressed" ofType:@"png"]];
        //
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 52.0f, 55.0f)];
        [btn setImage:bubble forState:UIControlStateNormal];
        [btn setBackgroundImage:bubbleBackground forState:UIControlStateNormal];
        [btn setTag:789];
        [btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        [returnView addSubview:btn];
         */
        //
        //录像
        /*
        UIImage *bubble2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_mode_btn_pressed" ofType:@"png"]];
        
        UIButton *btn2=[[UIButton alloc] initWithFrame:CGRectMake(60.0f, 3.0f, 52.0f, 55.0f)];
        [btn2 setImage:bubble2 forState:UIControlStateNormal];
        [btn2 setBackgroundImage:bubbleBackground forState:UIControlStateNormal];
        [btn2 setTag:891];
        [btn2 addTarget:self action:@selector(videoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [returnView addSubview:btn2];
        */
        /*
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
        [UIView setAnimationDuration:0.2f];
        if (isEditing) {
            returnView.frame = CGRectMake(75.0f, 79.0f,200.0f, 73.0f);
        }else{
            returnView.frame = CGRectMake(75.0f, 295.0f,200.0f, 73.0f);
        }    
        //
         
        [UIView commitAnimations];
        [self.view addSubview:returnView];
         */
   // }else{
        //isShowWindow=YES;
        //
        //[[self.view viewWithTag:SHOWWINDOW] removeFromSuperview];
   // }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:nil
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"拍摄", @"从相册选择", nil];
	alert.tag = 1;
	[alert show];

    
}

//表情
-(void)showface:(id)sender{
    UIButton *faceBtn=(UIButton *)sender;
    faceBtn.tag=!faceBtn.tag;
    UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    
    if(isSpeakBtn){
        UIButton *btn=(UIButton *)[toolBar viewWithTag:SPEAKBTN];
        [btn setImage:[UIImage imageNamed:@"type_select_btn_text"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"type_select_btn_text_2"] forState:UIControlStateHighlighted];
        
        UIButton *btn2=(UIButton *)[toolBar viewWithTag:SPEAK];
        [btn2 removeFromSuperview];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 4.0f, 185.0f, 38.0f)];
        textfield.tag = TEXTFIELDTAG;
        textfield.delegate = self;
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textfield.enablesReturnKeyAutomatically = YES;
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.returnKeyType = UIReturnKeySend;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        textfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        
        [toolBar addSubview:textfield];
        [textfield becomeFirstResponder];
        isShowWindow=YES;
        isSpeakBtn=NO;
    }
    
    UITextField *textView=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
	if (faceBtn.tag) {
		[textView resignFirstResponder];
		UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 215)];
		for (int i=0; i<4; i++) {
			FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(3+320*i, 0, 315, 220)];
			[fview loadFacialView:i size:CGSizeMake(45, 45)];
			fview.delegate=self;
			[scrollView addSubview:fview];
		}
		scrollView.contentSize=CGSizeMake(320*4, 215);
		scrollView.pagingEnabled=YES;
		textView.inputView=scrollView;
		[textView becomeFirstResponder];
		
	}else {
		textView.inputView=nil;
		[textView reloadInputViews];
		[textView becomeFirstResponder];
	}
}

//把表情添加到文本框
-(void)selectedFacialView:(NSString*)str{
    UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    UITextField *textView=(UITextField *)[toolBar viewWithTag:TEXTFIELDTAG];
	NSMutableString *str1=[[NSMutableString alloc] initWithString:@"<"];
	[str1 appendString:str];
	[str1 appendString:@">"];
	
	NSString *str2=[NSString stringWithFormat:@"%@%@",textView.text,str1];
	textView.text=str2;
}


//解析输入的文本，根据文本信息分析出那些是表情，那些是文字。
-(BOOL)getImageRange:(NSString*)message{
	NSRange range=[message rangeOfString:@"<"];
	NSRange range1=[message rangeOfString:@">"];
    BOOL isMessage=YES;
    //判断当前字符串是否还有表情的标志。
    if (range.length&&range1.length) {
        isMessage=NO;
        if (range.location>0) {
            [textArray addObject:[message substringToIndex:range.location]];
            [textArray addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [textArray addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str];
            }else {
                return isMessage;
            }
        }
        return isMessage;
    }else {
        [textArray addObject:message];
    }
    return isMessage;
}

#pragma mark  imagePickerController
//图片类型按钮事件
-(void)imageClick:(id)sender{
    [self showWindow];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:nil
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"拍摄", @"从相册选择", nil];
	alert.tag = 1;
	[alert show];
}

//视频按钮事件
- (void)videoClicked: (id)sender {  
    [self showWindow];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:nil
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"拍摄视频", @"从相册选择", nil];
	alert.tag = 2;
	[alert show];
}

//点击弹出框选择拍照或选择照片
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1 || alertView.tag == 2) {
        if (buttonIndex == 0) {
            return;
        }
		UIImagePickerController *Videopicker = [[UIImagePickerController alloc] init];
		Videopicker.delegate = self;
		[Videopicker setEditing:NO];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES
			&& buttonIndex == 1) {
			Videopicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			isCamera = YES;
		}
		else {
			Videopicker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
			Videopicker.allowsEditing = YES;
			isCamera = NO;
		}
        if (alertView.tag == 2) {			
            NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:Videopicker.sourceType];
            for (NSString *str in sourceTypes) {
                if ([str hasSuffix:@"movie"]) {
                    Videopicker.mediaTypes = [[NSArray alloc] initWithObjects: str, nil];
                    break;
                }
            }
		}
		[self.navigationController presentModalViewController:Videopicker animated:YES];
	}
    
}


//拍照或录像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];

    
    UIImage* image;
	if ([strType hasSuffix:@"image"]) {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];

		//NSArray *array = [NSArray arrayWithObjects:strType,strName,strPath,nil];
        
	}else {
		NSString *mediaUrl =  [NSMutableString stringWithString:[[info valueForKey:@"UIImagePickerControllerMediaURL"] path]];
        if (mediaUrl != nil) {
          
            image= [UIImage imageWithContentsOfFile:mediaUrl];
        }
	}
	
      	
        CGSize size;
        size.width =  320;
        size.height = 480;
        
        UIGraphicsBeginImageContext(size);  
        // 绘制改变大小的图片  
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
        // 从当前context中创建一个改变大小后的图片  
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
        // 使当前的context出堆栈  
        UIGraphicsEndImageContext();
        image=nil;
        
        NSString *strPath = [Global saveImageAsPng:scaledImage];
    
        NSString *time=[Global getCurrentTime];
      
        UIView *chatView = [SoundUtils imageView: strPath from:YES peopleId:0 showTime:time];
        [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:strPath, @"text",@"self", @"speaker", chatView, @"view", @"image",@"type",nil]];
        int notifyId = [[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
        NSString* strName = [strPath lastPathComponent];
        [[NotifyInfoServices getConnection] insertNotifyInfo:notifyId peopelId:user.userId niType:[Global getIMAGE_MSG] niName:strName niPath:strPath niStatus:@"Y" niDate:time isRead:@"Y" isMySpeaking:@"Y" niContent:@"" recordTime:recordCount];
        
        Notify *notify=[[NotifyServices getConnection]findById:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"]];
        
        NSData* imageData = UIImagePNGRepresentation(scaledImage);
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:[NSArray arrayWithObjects:[Base64Utils base64Encoding:imageData],@"0",@"",notify.toUser,[Global getCurrentTime],[Global getIMAGE_MSG],[NSString stringWithFormat:@"%i",user.userId],nil]
                           forKeys:[NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                           ];
        imageData=nil;
       
        NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"]; 

        NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];
        json=nil;

        NSDictionary* dic_data = [NSDictionary dictionaryWithObject:newData forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendDataBySocketServer" object:nil userInfo:dic_data];
        

        [picker dismissModalViewControllerAnimated:YES];

        UITableView *temp_tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        [temp_tableView reloadData];
        [temp_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        NotifyServices *conn=[NotifyServices getConnection];
        [conn updateById:notify.ntId readCount:0 detailText:@"[图片]" ntDate:[Global getCurrentTime]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

//语音长按事件委托-----开始
- (void)handleLongPressStart{
    isRecording = NO;
    
    UIView *window =[[UIView alloc] initWithFrame:CGRectMake(60.0f, 80.0f,200.0f, 200.0f)];
    window.backgroundColor=[UIColor blackColor];
    [[window layer] setBorderWidth:0.5];//画线的宽度
    [[window layer] setBorderColor:[UIColor blackColor].CGColor];//颜色
    [[window layer]setCornerRadius:15.0];//圆角
    window.alpha=0.7f;
    window.tag=SPEAKWINDOW;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame=CGRectMake(75.0f, 77.0f,50.0f, 50.0f);
    [activityView startAnimating];
    [window addSubview:activityView];
    
    [self.view addSubview:window];
    
    NSString *strDocPath = [[NSString alloc] initWithString:[Global getRecordPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:strDocPath attributes:nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddhhmmss";    
    rootName=[[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".caf"];
    rootPath=[strDocPath stringByAppendingPathComponent:rootName];  
    timerCount=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(longTimeClick) userInfo:nil repeats:YES];	
    
    UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    UIButton  *btn=(UIButton *)[toolBar viewWithTag:SPEAK];
    [btn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateHighlighted];
}


//语音长按事件委托-----结束
- (void)handleLongPressEnd{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User* user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(longCount==10&&![recordCount isEqualToString:@"00\""]){
        [recorder stop];
        recorder = nil;
        isRecording = NO;
        
        NSString *strDocPath = [[NSString alloc] initWithString:[Global getRecordPath]];
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [ dateFormat setDateFormat:@"yyyyMMddhhmmss"];
        NSString *strNowTime = [dateFormat stringFromDate:[NSDate date]];
        NSString *newMp3AudioName = [strNowTime stringByAppendingString:@".mp3"];
        NSString *mp3AudioPath = [strDocPath stringByAppendingPathComponent:newMp3AudioName];
        
        int read, write;
        FILE *pcm = fopen([rootPath cStringUsingEncoding:1], "rb");//被转换的文件
        FILE *mp3 = fopen([mp3AudioPath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        
        const int MP3_SIZE = 8192;
        
        short int pcm_buffer[PCM_SIZE*2];
        
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        
        lame_set_in_samplerate(lame,32000.0);
        
        lame_set_VBR(lame, vbr_default);
        
        lame_init_params(lame);
        
        do {
            
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            
            if (read == 0)
                
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            else
                
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        
        fclose(mp3);
        
        fclose(pcm);
        
        NSError *error=nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:rootPath error:&error];
        
        
        NSString *time=[Global getCurrentTime];
        UIView *chatView = [SoundUtils recordView:YES recordCount:recordCount peopleId:0 showTime:time];
        [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:mp3AudioPath, @"text",@"self", @"speaker", chatView, @"view",@"record",@"type", nil]];
        
        UITableView *temp_tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        [temp_tableView reloadData];
        [temp_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        [[NotifyInfoServices getConnection]insertNotifyInfo:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"] peopelId:user.userId niType:[Global getAUDIO_MSG] niName:rootName niPath:mp3AudioPath niStatus:@"Y" niDate:time isRead:@"Y" isMySpeaking:@"Y" niContent:@"" recordTime:recordCount];
        
        Notify *notify=[[NotifyServices getConnection]findById:[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"]];
        NSData *data = [NSData dataWithContentsOfFile: mp3AudioPath];
        
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:[NSArray arrayWithObjects:[Base64Utils base64Encoding:data],@"0",@"",notify.toUser,[Global getCurrentTime],[Global getAUDIO_MSG],[NSString stringWithFormat:@"%i",user.userId],nil]
                           forKeys:[NSArray arrayWithObjects:@"body",@"len",@"id",@"to",@"date",@"type",@"fm",nil]
                           ];
        NSString *json=[[dic JSONRepresentation] stringByAppendingFormat:@"eof"];  

        NSData *newData=[json dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary* dic_data = [NSDictionary dictionaryWithObject:newData forKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendDataBySocketServer" object:nil userInfo:dic_data];

        NotifyServices *conn=[NotifyServices getConnection];
        [conn updateById:notify.ntId readCount:0 detailText:@"[语音]" ntDate:[Global getCurrentTime]];
        
        longCount=0;
        [timer invalidate];
        timer = nil;
    }else{
        [recorder stop];
        recorder = nil;
        isRecording = NO;
        [timerCount invalidate];
		timerCount = nil;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:rootPath error:&error];
    }
    recordCount=nil;
    rootPath=nil;
    rootName=nil;
    [activityView stopAnimating];
    
    UIView *window=(UIView *)[self.view viewWithTag:SPEAKWINDOW];
    [window removeFromSuperview]; 
    
    UIToolbar *toolBar=(UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    UIButton  *btn=(UIButton *)[toolBar viewWithTag:SPEAK];
    [btn setImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
}

//录音时更新状态
- (void) updateStatus{
    [recorder updateMeters];
    float peak = [recorder peakPowerForChannel:0];
    
    float ampCount=(XMAX + peak) / XMAX;
    
    UIView *window=(UIView *)[self.view viewWithTag:SPEAKWINDOW];
    UIImageView *ampView=(UIImageView *)[window viewWithTag:AMPVOICE];
    UIImage *amp;
    if(ampCount>-3.0f&&ampCount<-1.0f){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp2" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 144.0f, 48.0f,38.0f);
    }else if(ampCount>-1.0f&&ampCount<0.0){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp3" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 121.0f, 48.0f,61.0f);
    }else if(ampCount>0.0f&&ampCount<0.2){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp4" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 98.0f, 48.0f,84.0f);
    }else if(ampCount>0.2f&&ampCount<0.4){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp5" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 75.0f, 48.0f,107.0f);
    }else if(ampCount>0.4f&&ampCount<0.6){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp6" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 52.0f, 48.0f,130.0f);
    }else if(ampCount>0.6f){
        amp= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp7" ofType:@"png"]];
        ampView.frame = CGRectMake(110.0f, 29.0f, 48.0f,153.0f);
    }
    [ampView setImage:amp];
    //录音时长
    int num=[recorder currentTime];
    int secs = num % 60;
	int min = num / 60;
    
	if (num < 60){
        recordCount=[NSString stringWithFormat:@"%02d\"", num];
    }else{
        recordCount=[NSString stringWithFormat:@"%d'%02d\"", min, secs];
    }
}

//录音
-(void)longTimeClick{
    if(longCount>=1){
        NSError *error;
        // Recording settings
//        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
//        [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//        [settings setValue: [NSNumber numberWithFloat:32000.0] forKey:AVSampleRateKey];
//        [settings setValue: [NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//        [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        //[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        NSDictionary *settings = [NSDictionary 
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16], 
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2], 
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:32000.0], 
                                        AVSampleRateKey,
                                        nil];
        
        NSURL *url = [NSURL fileURLWithPath:rootPath];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error]; 
        
        [recorder prepareToRecord];        
        recorder.meteringEnabled = YES;        
        [recorder peakPowerForChannel:0];
 
        BOOL success=[recorder record];
        if (!success){
			[recorder stop];
			recorder = nil;
			isRecording = NO;
            return ;
		}else{
            isRecording=YES;
        }
        
        if (isRecording){//开始录音
            [activityView stopAnimating];
            
            UIView *window=(UIView *)[self.view viewWithTag:SPEAKWINDOW];
            
            UIImage *voice = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"voice_rcd_hint" ofType:@"png"]];
            
            UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[voice stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
            recordImageView.frame = CGRectMake(45.0f, 25.0f, 58.0f,157.0f);
            
            UIImage *amp = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amp1" ofType:@"png"]];
            
            UIImageView *ampImageView = [[UIImageView alloc] initWithImage:[amp stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
            ampImageView.frame = CGRectMake(110.0f, 167.0f, 48.0f,15.0f);
            ampImageView.tag=AMPVOICE;
            
            [window addSubview:recordImageView];
            
            [window addSubview:ampImageView];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];		
        }
        longCount=10;
        [timerCount invalidate];
		timerCount = nil;
    }else{
        longCount++; 
    }
}

//音频播放结束调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{  
    [imgTimer invalidate];
    [self rechangeImg];
} 

//更换播音图片
-(void)changeImg{
    [[currentView viewWithTag:VOICEIMG] removeFromSuperview];
    UIImage *record;
    if(imgNum==1){
        if([isMyVoiceImg isEqualToString:@"self"]){
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatto_voice_playing_f1" ofType:@"png"]];
        }else{
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatfrom_voice_playing_f1" ofType:@"png"]];
        }
        imgNum=2;
    }else if(imgNum==2){
        if([isMyVoiceImg isEqualToString:@"self"]){
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatto_voice_playing_f2" ofType:@"png"]];
        }else{
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatfrom_voice_playing_f2" ofType:@"png"]];
        }
        imgNum=3;
    }else if(imgNum==3){
        if([isMyVoiceImg isEqualToString:@"self"]){
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatto_voice_playing_f3" ofType:@"png"]];
        }else{
            record= [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatfrom_voice_playing_f3" ofType:@"png"]];
        }
        imgNum=1;
    } 
    UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];    
    recordImageView.tag=VOICEIMG;
    if([isMyVoiceImg isEqualToString:@"self"]){
        recordImageView.frame = CGRectMake(100.0f,36.0f, 20.0f,26.0f);
    }else{
        recordImageView.frame = CGRectMake(30.0f,36.0f, 20.0f,26.0f);
    }
    [currentView addSubview:recordImageView];
}

//还原原先的语音图片
-(void)rechangeImg{
    if(currentView!=nil){
        [[currentView viewWithTag:VOICEIMG]removeFromSuperview];
        if([isMyVoiceImg isEqualToString:@"self"]){
            UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatto_voice_playing" ofType:@"png"]];
            UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];    
            recordImageView.frame = CGRectMake(100.0f,36.0f, 20.0f,26.0f);
            recordImageView.tag=VOICEIMG;
            
            [currentView addSubview:recordImageView];
        }else{
            UIImage *record = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chatfrom_voice_playing" ofType:@"png"]];
            UIImageView *recordImageView = [[UIImageView alloc] initWithImage:[record stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
            recordImageView.frame = CGRectMake(30.0f,36.0f, 20.0f,26.0f);
            recordImageView.tag=VOICEIMG;
            
            [currentView addSubview:recordImageView];
        }
    }
}


// 这里必须要使用流式数据
-(void)onNoifyChatMessage:(NSNotification*)nofiy{ 

    NSDictionary* dic = nofiy.userInfo;
    NSString* idsIdentity = [Global getSortIdentity:[dic objectForKey:@"fm"] toUser:[dic objectForKey:@"to"]];
   
    NotifyServices *conn=[NotifyServices getConnection];
    Notify *notify=[conn findByGroup:idsIdentity];
    int defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
     
    if(notify.ntId == defaultId )
    {//根据标识查询出消息组是否存在
        NSString *type=[dic objectForKey:@"type"];
        NSInteger peopleId=[[dic objectForKey:@"fm"]intValue];
        
        if([type isEqualToString:[Global getAUDIO_MSG]]){//语音
            NSString* path = [dic valueForKey:@"path"];
            NSString* rCount = [dic valueForKey:@"recordCount"];
            UIView *chatView = [SoundUtils recordView:NO recordCount:rCount peopleId:peopleId showTime:[Global getCurrentTime]];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:path, @"text",@"other", @"speaker", chatView, @"view",@"record",@"type", nil]];
            
        }else if([type isEqualToString:[Global getIMAGE_MSG]]){//图片
            // NSData *imgData=[Base64Utils dataWithBase64EncodedString:[dic objectForKey:@"body"]];
            NSString* path = [dic valueForKey:@"path"];

            UIView *chatView = [SoundUtils imageView:path  from:NO peopleId:peopleId showTime:[Global getCurrentTime]];
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:path, @"text",@"other", @"speaker", chatView, @"view", @"image",@"type",nil]];
            
        }else if([type isEqualToString:[Global getTEXT_MSG]]){//文字
            
            UIView *chatView=[SoundUtils bubbleView:[NSString stringWithFormat:@"%@",[dic objectForKey:@"body"]] from:NO peopleId:peopleId showTime:[Global getCurrentTime]];
            
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"body"], @"text",@"other", @"speaker", chatView, @"view",@"text",@"type", nil]];
        }         
        else if([type isEqualToString:[Global getVEDIO_MSG]]){//视频
            
        }else if([type isEqualToString:[Global getPHIZ_MSG]]){//表情
            
            UIView *chatView=[SoundUtils faceView:NO textArray:textArray];
            
            [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"body"], @"text",@"other", @"speaker", chatView, @"view",@"face",@"type", nil]];
            
        }

        UITableView *temp_chatView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
        [temp_chatView reloadData];
        [temp_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

    - (void)dealloc {
        currentView=nil;
    }
    @end

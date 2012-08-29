//
//  VisitFromViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VisitFromViewController.h"
#define TEXTVIEW  100

@implementation VisitFromViewController
@synthesize startButton,endButton,workUtilsDelegate,infoView;

//通知
- (void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

//键盘显示时
- (void) keyboardWasShown:(NSNotification *) notif{
    isShow=YES;
    [djdateGregorianView removeFromSuperview];
}

-(void)visitPageForward:(NSNotification*) notification{
    [workUtilsDelegate reloadTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [djdateGregorianView removeFromSuperview];
    djdateGregorianView.delegate=nil;
    djdateGregorianView=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visitPageForward:) name:@"visitPageForward" object:nil];

    self.navigationItem.title=@"新增拜访";
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" 
                                                                  style:UITabBarSystemItemContacts target:self action:@selector(newBtnClick:)]; 
    self.navigationItem.rightBarButtonItem= newButton;
    
    //语音识别初始化
    speechHelper = [SpeechHelper alloc];
    [speechHelper inita:self];

    infoView=[[UIView alloc] initWithFrame:CGRectMake(95.0f, 110.0f,210.0f, 130.0f)];
    [[infoView layer] setBorderWidth:1.3];//画线的宽度
    [[infoView layer] setBorderColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0f].CGColor];//颜色
    [[infoView layer]setCornerRadius:8.0];//圆角
    
    UIFont *font = [UIFont systemFontOfSize:16];
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(5,5, 200, 120)];
    textView.tag=TEXTVIEW;
    textView.delegate=self;
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = [UIColor clearColor];
    textView.font=font;
    textView.delegate=self;
    
    [infoView addSubview:textView];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];  
    topView.barStyle = UIBarStyleBlackTranslucent;   
    
    //语音输入按钮
    UIBarButtonItem * speechButton = [[UIBarButtonItem alloc]initWithTitle:@"语音" style:UIBarButtonItemStyleDone target:self action:@selector(onButtonRecognize)]; 
    //语音识别绑定输入文本和触发按钮
    [speechHelper setSource:textView speechTrigger:speechButton];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];  
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:speechButton,btnSpace,doneButton,nil];  
    [topView setItems:buttonsArray];          
    [textView setInputAccessoryView:topView]; 
    
    [self.view addSubview:infoView];
    
    //公历日期选择器
    djdateGregorianView=[[IDJDatePickerView alloc]initWithFrame:CGRectMake(0, 180, 320, 200) type:Gregorian1];
    djdateGregorianView.delegate=self;
    isShow=YES;
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    [startButton setTitle:[formatter stringFromDate:nowDate] forState:UIControlStateNormal];
    [endButton setTitle:[formatter stringFromDate:nowDate] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    textContent=nil;
    djdateGregorianView=nil;
    speechHelper=nil;
    infoView=nil;
}

//新增按钮事件
-(void)newBtnClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton; 
    
    UITextView *textView=(UITextView *)[infoView viewWithTag:TEXTVIEW];
    
    VisitClientViewController *client=[[VisitClientViewController alloc]init];
    client.startTime=startButton.titleLabel.text;
    client.endTime=endButton.titleLabel.text;
    if(textView.text==nil||[textView.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"计划描述不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return ;
    }
    client.remark=textView.text;
    [self.navigationController pushViewController:client animated:YES];
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
        [startButton setTitle:temp forState:UIControlStateNormal];
    }else if(textCount==2){
        [endButton setTitle:temp forState:UIControlStateNormal];
    }
    temp=NULL;
}

//开始时间、结束时间选择判断
-(IBAction)chooseTime:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==11){
        textCount=1;
        djdateGregorianView.frame=CGRectMake(0, 220, 320, 200);
    }else{
        textCount=2;
        djdateGregorianView.frame=CGRectMake(0, 220, 320, 200);
    }
    if(isShow){
        [self.view addSubview:djdateGregorianView];
        isShow=NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{ 
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, -110, 320.0, 420.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
    return YES;
} 

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    UITextView *text=(UITextView *)[self.view viewWithTag:TEXTVIEW];
    [text resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 420.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
    return YES;
}

//隐藏键盘
-(IBAction)dismissKeyBoard{  
    UITextView *text=(UITextView *)[self.view viewWithTag:TEXTVIEW];
    [text resignFirstResponder];	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4f];
	CGRect newFrame = CGRectMake(0.0, 0.0, 320.0, 420.0);
	self.view.frame = newFrame;
	[UIView commitAnimations];
}

-(void)dealloc{
    djdateGregorianView.delegate=nil;
}

// 语音识别触发按钮，启动语音输入
- (void)onButtonRecognize
{
    [speechHelper speechStart];
}
@end

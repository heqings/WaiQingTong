    //
//  UIRecognizeController.m
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIRecognizeController.h"

@interface UIRecognizeController(Private)

- (void)disableButton;

- (void)enableButton;

@end

@implementation UIRecognizeController

- (id)init
{
	if (self = [super init])
	{
		self.title = TITLE;
	}
	return self;
}


#pragma mark 
#pragma mark 接口回调

//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{

	[self enableButton];
	
}

- (void)onUpdateTextView:(NSString *)sentence
{
	
	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", _textView.text, sentence];
	_textView.text = str;
	
}

- (void)onRecognizeResult:(NSArray *)array
{
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	[self onRecognizeResult:resultArray];	
	
}
#pragma mark 
#pragma mark 内部调用

- (void)disableButton
{
	_recognizeButton.enabled = NO;
	_setupButton.enabled = NO;
	_textView.editable = NO;
	self.navigationController.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)enableButton
{
	_recognizeButton.enabled = YES;
	_setupButton.enabled = YES;
	_textView.editable = YES;
	self.navigationController.navigationItem.leftBarButtonItem.enabled  = YES;
}

// 转写
- (void)onButtonRecognize
{
	if([_iFlyRecognizeControl start])
	{
		[self disableButton];
	}
}

// 设置
- (void)onButtonSetup
{
	[self.navigationController pushViewController:_recoginzeSetupController animated:YES];
}

- (void)viewDidLoad 
{
	NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];

	// 识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN theInitParam:initParam];
	[self.view addSubview:_iFlyRecognizeControl];
	[_iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];
	[_iFlyRecognizeControl setSampleRate:16000];
	_iFlyRecognizeControl.delegate = self;
	
	_recoginzeSetupController = [[UIRecognizeSetupController alloc] initWithRecognize:_iFlyRecognizeControl];
	[super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_textView resignFirstResponder];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0;
	if (indexPath.section == 0) 
	{
		height = 185;
	}
	else 
	{
		height = 110;
	}
	return height;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* sectionTitle = nil;
	switch (section) 
	{
		case 0:
			sectionTitle = SECTION_TITLE1;
			break;
		case 1: 
			sectionTitle = SECTION_TITLE2;
			break;
	}
	return sectionTitle;
}*/


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	// Configure the cell.
	
	if (indexPath.section == 0)
	{
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input.png"]];
		imageView.frame = H_BACK_TEXTVIEW_FRAME;
		[cell addSubview:imageView];
		
		_textView = [self addTextViewWithFrame:H_TEXTVIEW_FRAME theText:nil];
		//_textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
		_textView.backgroundColor = [UIColor clearColor];
		[cell addSubview: _textView];
	}
	else
	{
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button1.frame = CGRectMake(20, 10, 280, 40);
		[button1 setTitle:BUTTON_TITLE1 forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(onButtonRecognize) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button1];
		
//		UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		button2.frame = CGRectMake(20, 60, 280, 40);
//		[button2 setTitle:BUTTON_TITLE2 forState:UIControlStateNormal];
//		[button2 addTarget:self action:@selector(onButtonSetup) forControlEvents:UIControlEventTouchDown];
//		
//		[cell addSubview:button2];
	}

    return cell;
}


@end

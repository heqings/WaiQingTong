//
//  UIDemoBaseController.m
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIDemoBaseController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIDemoBaseController

- (id)init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{
		self.tableView.allowsSelection = NO;
	}
	return self;
}


- (void)onButtonKeyBoard
{
	[_textView resignFirstResponder];

	self.navigationItem.rightBarButtonItem = NULL;
}

- (void)keyboardWillShow
{
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithTitle:@"Done" 
											   style:UIBarButtonItemStyleDone 
											   target:self 
											   action:@selector(onButtonKeyBoard)];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.tableView.allowsSelection = NO;
	self.tableView.scrollEnabled = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self keyboardWillShow];
}

- (UITextView *)addTextViewWithFrame:(CGRect)frame theText:(NSString *)text 
{
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	// 显示文本
	textView.font = [UIFont systemFontOfSize:18];
	textView.text = text;
	textView.backgroundColor = [UIColor whiteColor];
	textView.layer.cornerRadius = 8.0f;		//设定边框为圆角，并指定圆角半径
	textView.delegate = self;

	return textView;
}

- (UIButton *)addButton:(CGRect)frame theTitle:(NSString *)title 
		 theNomarlImage:(UIImage *)nomarlImage 
		thePressedImage:(UIImage *)pressedImgae
		theDisableImage:(UIImage *)disableImage
				 target:(SEL)action
{		
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	//UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundImage:nomarlImage forState:UIControlStateNormal];
	[button setBackgroundImage:pressedImgae forState:UIControlStateHighlighted];
	[button setBackgroundImage:disableImage forState:UIControlStateDisabled];

	button.backgroundColor = [UIColor redColor];
	button.exclusiveTouch = YES;
	return button;
}

/*
#ifdef __IPHONE_3_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
#else
	- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {    
		UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
#endif
		
		if (interfaceOrientation == UIInterfaceOrientationPortrait 
			|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{// 竖屏幕设置视图坐标

		}
		else 
		{// 横屏幕设置视图坐标

		}
	}
	
	// Override to allow orientations other than the default portrait orientation.
	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{	
		// Return YES for supported orientations
		return YES;
		
	}*/
	
@end

//
//  GetPasswordBackViewController.m
//  Pickers
//
//  Created by HeQing on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GetPasswordBackViewController.h"

@implementation GetPasswordBackViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(IBAction)onBackRegister:(id)sender
{
    [self dismissModalViewControllerAnimated:TRUE];
}
-(IBAction)onGetPasswordBack:(id)sender
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    mailText=[[UITextField alloc]initWithFrame:CGRectMake(20, 93, 285, 41)];
    mailText.placeholder=@"邮箱";
    mailText.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    mailText.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    mailText.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:mailText];
    //添加事件处理方法
    mailText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mailText addTarget:self action:@selector(textFieldDidEndEditing:)forControlEvents:UIControlEventEditingDidEndOnExit];
    [mailText addTarget:self action:@selector(textFieldDidStartEditing:)forControlEvents:UIControlEventEditingDidBegin];

}

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
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

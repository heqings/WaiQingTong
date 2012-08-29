//
//  SpeechHelper.m
//  Pickers
//
//  Created by HeQing on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpeechHelper.h"

@implementation SpeechHelper

- (IFlyRecognizeControl*)get {
    //语音识别
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
	// 识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN theInitParam:initParam];
    return _iFlyRecognizeControl;
}

- (IFlyRecognizeControl*)inita: (UIViewController*)targetView {
    _iFlyRecognizeControl = [self get];
	[targetView.view addSubview:_iFlyRecognizeControl];
	[_iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];
	[_iFlyRecognizeControl setSampleRate:16000];
	_iFlyRecognizeControl.delegate = self;
    return _iFlyRecognizeControl;
}

- (void)onUpdateTextView:(NSString *)sentence
{
	
	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", textView.text, sentence];
	textView.text = str;
	
}

- (void)setSource:(UITextView*)sourceText speechTrigger:(UIBarButtonItem*)speechTrigger {
    textView = sourceText;
    trigger = speechTrigger;
}

//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
    [self enableButton];	
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

// 语音服务启动
- (void)speechStart
{
	if([_iFlyRecognizeControl start])
	{
		[self disableButton];
    }
}

- (void)disableButton
{
	trigger.enabled = NO;
	textView.editable = NO;
}

- (void)enableButton
{
	trigger.enabled = YES;
	textView.editable = YES;
}

@end

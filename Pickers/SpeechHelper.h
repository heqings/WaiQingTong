//
//  SpeechHelper.h
//  Pickers
//
//  Created by HeQing on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFlyISR/IFlyRecognizeControl.h"


#define H_CONTROL_ORIGIN CGPointMake(20, 70)

//此appid为您所申请,请勿随意修改
#define APPID @"4f14e5ef"
#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"

@interface SpeechHelper: NSObject <IFlyRecognizeControlDelegate> {
    
    IFlyRecognizeControl		*_iFlyRecognizeControl;
    
    UITextView *textView;
    
    UIBarButtonItem *trigger;
}

- (IFlyRecognizeControl*)inita: (UIViewController*)targetView;

- (IFlyRecognizeControl*)get;

- (void)setSource:(UITextView*)sourceText speechTrigger:(UIBarButtonItem*)speechTrigger;

- (void)speechStart;

- (void)disableButton;

- (void)enableButton;

@end

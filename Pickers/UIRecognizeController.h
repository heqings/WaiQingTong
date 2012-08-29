//
//  UIRecognizeController.h
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDemoBaseController.h"
#import "iFlyISR/IFlyRecognizeControl.h"
#import "UIRecognizeSetupController.h"


// 按键坐标
#define H_BUTTON_RECOGNIZE			CGRectMake(50, 300, 80, 40)
#define H_BUTTON_RECOGNIZE_SETUP	CGRectMake(190, 300, 80, 40)


#define SECTION_TITLE1 @"识别结果"
#define SECTION_TITLE2 @"用户操作"

#define BUTTON_TITLE1  @"开始听写"
#define BUTTON_TITLE2  @"设置"

#define TITLE @"语音识别测试"

@interface UIRecognizeController : UIDemoBaseController <IFlyRecognizeControlDelegate>
{
	UIButton *_recognizeButton;
	UIButton *_setupButton;
	
	// 中间变量
	IFlyRecognizeControl		*_iFlyRecognizeControl;
	UIRecognizeSetupController	*_recoginzeSetupController;
}

@end

//
//  UIRecognizeSetupController.h
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDemoBaseController.h"
#import "iFlyISR/IFlyRecognizeControl.h"

#define H_VAD_KEYWORD_LABEL_FRAME		CGRectMake(20, 60, 130, 40)
#define H_VAD_KEYWORD_SWITCH_FRAME		CGRectMake(170, 65, 100, 40)

#define H_SEG_LABEL_FRAME				CGRectMake(20, 110, 130, 40)
#define H_SEG_FRAME						CGRectMake(120, 110, 150, 40)

#define H_AREA_FRAME					CGRectMake(10, 170, 120, 50)

#define SECTION_TITLE1 @"选择"
#define SECTION_TITLE2 @"类型"

#define TITLE @"转写设置"

@interface UIRecognizeSetupController : UIDemoBaseController 
<UIPickerViewDataSource,UIPickerViewDelegate> 
{
	// UI
	UIPickerView				*_areaPickerView;
	
	UILabel						*_recognizeTypeLabel;	
	UISegmentedControl			*_recognizeTypeSegment;
	
	// 中间变量
	IFlyRecognizeControl		*_iFlyRecognizeControl;
	NSInteger					_selectRow;
	
	NSArray						*_pickerViewArray;
}

- (id)initWithRecognize:(IFlyRecognizeControl *)iFlyRecognizeControl;

@end

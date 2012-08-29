//
//  SoundUtils.h
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import<QuartzCore/QuartzCore.h>
#import "OtherViewController.h"
#import "NotifyInfoServices.h"
#import "PeopleServices.h"

@interface SoundUtils : NSObject<AVAudioPlayerDelegate>{
    
}
+(NSString *)distanceOfTime:(NSDate *)date;
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf peopleId:(NSInteger)peopleId showTime:(NSString *)showTime;
+(UIView *)recordView:(BOOL)fromSelf recordCount:(NSString *)recordCount peopleId:(NSInteger)peopleId showTime:(NSString *)showTime;
+(UIView *)imageView:(NSString *)url from:(BOOL)fromSelf peopleId:(NSInteger)peopleId showTime:(NSString *)showTime;
+(UIView *)faceView:(BOOL)fromSelf textArray:(NSMutableArray *)textArray;
+(void)runNotifySound:(NSDictionary *)dic;
+(void)insertNotify:(NSDictionary*)dic;
-(void)updateById:(NSInteger)ntId readCount:(NSInteger)readCount;
@end

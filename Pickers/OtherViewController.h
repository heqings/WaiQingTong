//
//  OtherViewController.h
//  JsonDemo
//
//  Created by air macbook on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h> 
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NotifyInfoServices.h"
#import "PeopleServices.h"
#import "JSON.h"
#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"
#import "Global.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NotifyServices.h"
#import "UserServices.h"
#import "Base64Utils.h"
#import "WorkUtilsDelegate.h"
#import "FacialView.h"
#import "ShowUserViewController.h"
#import "SoundUtils.h"
#import "User.h"


@interface OtherViewController : UIViewController
<UITextFieldDelegate,UITableViewDelegate,
UITableViewDataSource,UIGestureRecognizerDelegate,
UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,facialViewDelegate>{
    NSMutableArray * chatArray;//聊天信息集合

    BOOL isShowWindow;//是否显示类型选择view
    BOOL isEditing;//是否正在编辑
    BOOL isSpeakBtn;
    CGFloat keyCode;//键盘高度
    
    AVAudioRecorder * recorder;
	AVAudioPlayer	* player;
	BOOL	isRecording;
    NSTimer   *timerCount;//模拟按钮长按事件
    int      longCount;//计算按下时长
	NSTimer	 *timer;//录音时间定时期
    NSString  *recordCount;//录音时间长短
    NSString  *rootPath;//语音路径
    NSString *rootName;//语音名称
    NSTimer *imgTimer;//语音图片更换
    UIView  *currentView;//当前语音图层
    int     imgNum;//当前语音图片
    NSString   *isMyVoiceImg;
    
    BOOL isCamera;//拍照或选择照片
    
    UIActivityIndicatorView *activityView;//录音弹出框加载
   // AsyncSocket  *sendSocket;
   // NSDictionary *user;
    NSMutableArray *msgArray;
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    
    NSMutableArray *textArray;
    UITableView *tableView;
}
//@property (nonatomic, retain)AsyncSocket *sendSocket;
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;
-(void)loadNotifyData;
@end

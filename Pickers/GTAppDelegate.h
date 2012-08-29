//
//  GTAppDelegate.h
//  Pickers
//
//  Created by HeQing on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h> 
#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"
#import "JSON.h"
#import "Global.h"
#import "WorkUtilsDelegate.h"
#import "AppGlobalServices.h"
#import "NotifyWork.h"
#import "NotifyPlan.h"
#import "NotifyTz.h"
#import "NotifyTask.h"
#import "SoundUtils.h"
#import "NotifyAudit.h"
#import "Reachability.h"


@interface GTAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>{
    
    UITabBarController *rootController;
    AsyncSocket  *sendSocket;
    NSMutableArray *msgArray;
    AVAudioPlayer	* player;
    UIWindow *window;
    
    id<WorkUtilsDelegate> __unsafe_unretained workUtilsDelegate;
    bool bRunningBackground;
    NSString *url;
}

@property (nonatomic, strong)AsyncSocket *sendSocket;
@property (nonatomic, strong) IBOutlet UITabBarController *rootController;
@property (nonatomic,strong) UIWindow* window;
@property(nonatomic, unsafe_unretained) id<WorkUtilsDelegate> workUtilsDelegate;

-(void)disconnectSocket;
-(BOOL)connectSocket;
-(BOOL)loginSocketServer;

@end

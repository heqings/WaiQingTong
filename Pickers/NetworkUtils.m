//
//  NetworkUtils.m
//  Reachability
//
//  Created by HeQing on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtils.h"
#import "Reachability.h"

@implementation NetworkUtils

- (NetworkUtils*) inita {
    //监测kNetworkReachabilityChangedNotification值的改变，这个值在Reachability.h中监控，如果该值改变了，
    //则执行reachabilityChanged方法。
   
    if(self)
    {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
	[hostReach startNotifier];
    }
    return self;
    
    //[self interfaceTipWithReachability: hostReach];
	
    //    internetReach = [[Reachability reachabilityForInternetConnection] retain];
    //	[internetReach startNotifier];
    //	[self interfaceTipWithReachability: internetReach];
    //    
    //    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    //	[wifiReach startNotifier];
    //	[self interfaceTipWithReachability: wifiReach];
    
}


//当网络环境状态改变时调用此方法
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [NetworkUtils getNetworkStatus];
}

+ (NetworkStatus) getNetworkStatus {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus status;
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            status = NotReachable;
            // [self alertTips:@"无网络"];
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            status = ReachableViaWWAN;
            // [self alertTips:@"GPRS网络可用"];
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            status = ReachableViaWiFi;
            // [self alertTips:@"Wi-Fi网络可用"];
            break;
    }
    return status;
}

// 是否wifi
+ (BOOL) IsEnableWIFI {
    
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (void) alertTips: (NSString* ) tips {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:nil 
                          message:tips 
                          delegate:nil 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
}

- (void) interfaceTipWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
        BOOL connectionRequired= [curReach connectionRequired];
        
        if(connectionRequired)
        {
            [NetworkUtils alertTips:@"网络已连接，但Internet不可用"];
        }
        else
        {
            [NetworkUtils alertTips:@"网络已连接"];
        }
        
    }
    //	if(curReach == internetReach)
    //	{	
    //		[NetworkUtils alertTips:@"GPRS可用"];
    //	}
    //	if(curReach == wifiReach)
    //	{	
    //		[NetworkUtils alertTips:@"Wi-Fi可用"];
    //	}
	
}

@end

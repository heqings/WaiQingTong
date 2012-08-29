//
//  NetworkUtils.h
//  Reachability
//
//  Created by HeQing on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

//定义网络是否连接
typedef enum {
	NoneNet = 0, //未连接
	GoodNet //已连接
} NetworkReach;

@interface NetworkUtils : NSObject {
    //外勤通服务器是否可达
    Reachability* hostReach;
    
    //Internet是否可用
    Reachability* internetReach;
    
    //WiFi是否可用
    Reachability* wifiReach;
}

- (NetworkUtils*) inita;

- (void) reachabilityChanged: (NSNotification* )note;

+ (BOOL) IsEnableWIFI;

+ (BOOL) IsEnable3G;

+ (void) alertTips: (NSString* ) tips;

+ (NetworkStatus) getNetworkStatus;

- (void) interfaceTipWithReachability: (Reachability*) curReach;

@end



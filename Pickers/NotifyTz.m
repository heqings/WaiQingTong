//
//  NotifyTz.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyTz.h"

@implementation NotifyTz

+(void)runNotifyTz:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_TZ]];
        NotifyTzServices *notifyTzConn=[NotifyTzServices getConnection];
        
        NSString *title=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"content"]];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"系统通知" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_TZ] detailText:msgTitle];
        }
        
        NSString *ntTitle=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"title"]];
        NSString *notTitle;
        if(ntTitle.length>15){
            notTitle=[ntTitle substringToIndex:15];
            notTitle=[notTitle stringByAppendingString:@"..."];
        }else{
            notTitle=ntTitle;
        }

        Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_TZ]];
        
        [notifyTzConn insertNotifyTz:0 ntId:tempNotify.ntId spId:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] nteContent:[[dic objectForKey:@"body"]objectForKey:@"content"] nteCreateDate:[[dic objectForKey:@"body"]objectForKey:@"createtime"] nteCreateUser:[[dic objectForKey:@"body"]objectForKey:@"createuser"] ntTitle:notTitle];
        
        int count=(int)notify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
@end

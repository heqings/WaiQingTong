//
//  NotifyGzrw.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyTask.h"

@implementation NotifyTask

+(void)runNotifyTask:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRW]];
        NotifyGzrwServices *notifyGzrwConn=[NotifyGzrwServices getConnection];
        
        NSString *title=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"worktask_content"]];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notify.ntType==nil){
            [notifyConn insertNotify:@"工作任务" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_GZRW] detailText:msgTitle];
        }
        
        NSString *ntTitle=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"worktask_title"]];
        NSString *notTitle;
        if(title.length>15){
            notTitle=[title substringToIndex:15];
            notTitle=[notTitle stringByAppendingString:@"..."];
        }else{
            notTitle=ntTitle;
        }
        
        Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_GZRW]];
        
        [notifyGzrwConn insertNotifySq:0 ntId:tempNotify.ntId spId:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] ngTitle:notTitle ngContent:[[dic objectForKey:@"body"]objectForKey:@"worktask_content"] ngCreateDate:[[dic objectForKey:@"body"]objectForKey:@"create_time"] ngLevel:[[dic objectForKey:@"body"]objectForKey:@"worktask_level"] status:@"N" finishTime:[[dic objectForKey:@"body"]objectForKey:@"over_time"] createUser:[[dic objectForKey:@"body"]objectForKey:@"create_user"] remarkUser:@"" remarkContent:@""];
        
        int count=(int)notify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
    }
    @catch (NSException *exception) {
        @throw exception;
    } 
}
@end

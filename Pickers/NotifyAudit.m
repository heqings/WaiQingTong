//
//  NotifyAudit.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyAudit.h"

@implementation NotifyAudit

+(void)runNotifyAudit:(NSDictionary *)dic{
    @try{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//手机震动
        
        NotifyServices *notifyConn=[NotifyServices getConnection];
        Notify *notify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_SQ]];
        NotifySqServices *notifySqConn=[NotifySqServices getConnection];
        NotifySq *notifySq=[notifySqConn findByParam:@"sp_id" param:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue]];
        
        NSString *title=[NSString stringWithString:[[dic objectForKey:@"body"]objectForKey:@"apply_content"]];
        NSString *msgTitle;
        if(title.length>10){
            msgTitle=[title substringToIndex:10];
            msgTitle=[msgTitle stringByAppendingString:@"..."];
        }else{
            msgTitle=title;
        }
        
        if(notifySq.nsContent==nil){

            if(notify.ntType==nil){
                [notifyConn insertNotify:@"申请信息" isRead:@"N" readCount:0 ntDate:[Global getCurrentTime] toUser:@"" groupId:@"" ntType:[Global getNOTIFY_SQ] detailText:msgTitle];
            }
            int who=[[dic objectForKey:@"fm"]intValue];
            if(![[[dic objectForKey:@"body"]objectForKey:@"terminal_id"]isEqualToString:@""]){
                who=[[[dic objectForKey:@"body"]objectForKey:@"terminal_id"]intValue];
            }
            Notify *tempNotify=[notifyConn findByParam:@"nt_type" param:[Global getNOTIFY_SQ]];
            
            [notifySqConn insertNotifySq:who ntId:tempNotify.ntId spId:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] nsContent:[[dic objectForKey:@"body"]objectForKey:@"apply_content"] nsCreateDate:[[dic objectForKey:@"body"]objectForKey:@"createtime"] nsRemarkPeople:@"" nsRemarkContent:@"" status:@"N" nsType:[[dic objectForKey:@"body"]objectForKey:@"apply_type"]];
            
        }else{
            [notifySqConn updateByParam:[[[dic objectForKey:@"body"]objectForKey:@"serverid_id"]intValue] nsRemarkContent:[[dic objectForKey:@"body"]objectForKey:@"handle_content"] nsRemarkPeople:[[dic objectForKey:@"body"]objectForKey:@"handler_name"] status:@"Y" nsRemarkTime:[[dic objectForKey:@"body"]objectForKey:@"handle_time"] nsRemarkType:[[dic objectForKey:@"body"]objectForKey:@"handle_status"]];
        }
        int count=(int)notify.readCount;
        count++;
        [notifyConn updateById:notify.ntId readCount:count detailText:msgTitle ntDate:[Global getCurrentTime]];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}
@end

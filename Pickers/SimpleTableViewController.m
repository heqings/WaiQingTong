//
//  SimpleTableViewController.m
//  Pickers
//
//  Created by HeQing on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "OtherViewController.h"
#import "NotifyPlanViewController.h"
#import "NotifyPlanServices.h"
#import "NotifyPoiServices.h"
#define BADGE   100

@interface SimpleTableViewController(private)
-(void)hideTabBar:(BOOL)hide;
@end

@implementation SimpleTableViewController
@synthesize myTable,cellsDataArray;

- (void)viewDidLoad {
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_body"] style:UITabBarSystemItemContacts target:self action:@selector(addBtnClick:)]; 
    
    self.navigationItem.rightBarButtonItem= addButton;
    
    GTAppDelegate *delegate=(GTAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.workUtilsDelegate=self;
    [super viewDidLoad];
}

- (void)viewDidUnload {
    cellsDataArray = nil;
    [super viewDidUnload];
}

//添加多人会话
-(void)addBtnClick:(id)sender{
    AddUserViewController *add=[[AddUserViewController alloc] init];
    add.from=@"A";
    [self presentModalViewController:add animated:YES];
}

#pragma mark -
#pragma mark 表视图数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIndentifier = @"SimpleTableIndentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIndentifier];
    Notify *notify=(Notify *)[cellsDataArray objectAtIndex:indexPath.row];
    UIImage *image;
    if([notify.ntType isEqualToString:[Global getNOTIFY_GZRZ]]){
        image = [UIImage imageNamed:@"notify_gzrz"];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_YY]]){
        NSArray *array=[notify.toUser componentsSeparatedByString:@"|"];
        if([array count]==1){
            People *p=[[PeopleServices getConnection]findBySpId:[[array objectAtIndex:0]intValue]];
            
            //设置图片大小
            CGSize size;
            size.width =  46;
            size.height = 46;
            UIGraphicsBeginImageContext(size);  
            // 绘制改变大小的图片  
            [[Global getPeopleTopImage:p] drawInRect:CGRectMake(0, 0, size.width, size.height)];  
            
            // 从当前context中创建一个改变大小后的图片  
            UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
            
            // 使当前的context出堆栈  
            UIGraphicsEndImageContext();
            
            image=scaledImage;
            scaledImage=nil;
        }else if([array count]>1){
            image = [UIImage imageNamed:@"shenqing_icon_metting"];
        } 
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_GZRW]]){
        image = [UIImage imageNamed:@"notify_gzrw"];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_SQ]]){
        image = [UIImage imageNamed:@"notify_sq"];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_BF]]){
        image = [UIImage imageNamed:@"notify_gzrz"];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_TZ]]){
       image = [UIImage imageNamed:@"notify_tz"];
    }
     
    cell.imageView.image = image;
    if(notify.readCount>0){
        CustomBadge *cb =  [CustomBadge customBadgeWithString:@"" 
                                            withStringColor:[UIColor whiteColor] 
                                            withInsetColor:[UIColor redColor] 
                                            withBadgeFrame:YES 
                                            withBadgeFrameColor:[UIColor whiteColor] 
                                            withScale:1.0
                                            withShining:YES];
        cb.tag=BADGE;
        cb.frame = CGRectMake(30,-2, 25, 25);
            
        cb.opaque =NO;
        cb.backgroundColor = [UIColor clearColor];
        cb.badgeText=[NSString stringWithFormat:@"%i",notify.readCount];
        [cell.imageView addSubview:cb];
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    UIFont *font1 = [UIFont systemFontOfSize:14];
    
    [cell.textLabel setFont:font];
	[cell.textLabel setText:[notify ntTitle]];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    [cell.detailTextLabel setFont:font1];
    [cell.detailTextLabel setText:[notify detailText]];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *currentTime=[SoundUtils distanceOfTime:[formatter dateFromString:[notify ntDate]]];
    
    UILabel *lab=[[UILabel alloc]init];
    lab.backgroundColor=[UIColor clearColor];
    lab.textAlignment=UITextAlignmentCenter;
    lab.text=currentTime;
    if(currentTime.length<=8){
        lab.frame=CGRectMake(240, 8, 80, 20);
    }else{
       lab.frame=CGRectMake(190, 8, 140, 20); 
    }
    
    lab.font=font1;
    [cell addSubview:lab];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,320.0f, 60.0f)];    
    cellView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_bg"]];
    cellView.opaque = NO;
    
    cell.backgroundView=cellView;
    return cell;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isHidden=YES;
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    Notify *notify=(Notify *)[cellsDataArray objectAtIndex:indexPath.row];

    [[NSUserDefaults standardUserDefaults] setInteger:notify.ntId forKey:@"notifyId"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if([notify.ntType isEqualToString:[Global getNOTIFY_GZRZ]]){//工作日志
        NotifyOfficeViewController *other=[[NotifyOfficeViewController alloc] init];
        [self.navigationController pushViewController:other animated:YES];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_YY]]){//语音
        OtherViewController *other=[[OtherViewController alloc] init];
        other.workUtilsDelegate=self;
        [self.navigationController pushViewController:other animated:YES];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_GZRW]]){//工作任务
        NotifyGzrwViewController *other=[[NotifyGzrwViewController alloc] init];
        [self.navigationController pushViewController:other animated:YES];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_SQ]]){//申请
        NotifySqViewController *other=[[NotifySqViewController alloc] init];
        [self.navigationController pushViewController:other animated:YES];
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_BF]]){//拜访
        NotifyPlanViewController* np =  [[NotifyPlanViewController alloc]init];
        [self.navigationController pushViewController:np animated:YES]; 
    }else if([notify.ntType isEqualToString:[Global getNOTIFY_TZ]]){//通知
        NotifyTzViewController *other=[[NotifyTzViewController alloc] init];
        [self.navigationController pushViewController:other animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
} 

//删除行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Notify *notify=(Notify *)[cellsDataArray objectAtIndex:indexPath.row];
        if([notify.ntType isEqualToString:[Global getNOTIFY_GZRZ]]){//工作日志
            [[NotifyGzrzServices getConnection]deleteByNtId:notify.ntId];
        }else if([notify.ntType isEqualToString:[Global getNOTIFY_GZRW]]){//工作任务
            [[NotifyGzrwServices getConnection] deleteByNtId:notify.ntId];
        }else if([notify.ntType isEqualToString:[Global getNOTIFY_BF]]){//工作拜访
            [[NotifyPlanServices getConnection] clearAll];
            [[NotifyPoiServices getConnection] cleanAll];
        }else if([notify.ntType isEqualToString:[Global getNOTIFY_SQ]]){//申请
            [[NotifySqServices getConnection]deleteByNtId:notify.ntId];
        }else if([notify.ntType isEqualToString:[Global getNOTIFY_TZ]]){//通知
            [[NotifyTzServices getConnection]deleteByNtId:notify.ntId];
        }else if([notify.ntType isEqualToString:[Global getNOTIFY_YY]]){//语音
            [[NotifyInfoServices getConnection]deleteByNtId:notify.ntId];
        }
        
        [[NotifyServices getConnection] deleteById:notify.ntId];
        [cellsDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

//将delete键显示成删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{  
    return @"删除";  
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

//视图显示前调用
-(void)viewWillAppear:(BOOL)animated{
    cellsDataArray=[[NSMutableArray alloc]init];
    NotifyServices *conn=[NotifyServices getConnection];
    cellsDataArray=[conn findAll];
    [myTable reloadData];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"forwardSounds"]isEqualToString:@"Yes"]){
        isHidden=YES;
        [self hideTabBar:YES];
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
        backbutton.title=@"返回";
        self.navigationItem.backBarButtonItem= backbutton;
        
        OtherViewController *other=[[OtherViewController alloc] init];
        other.workUtilsDelegate=self;
        [self.navigationController pushViewController:other animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"forwardSounds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        isHidden=NO;
        [self hideTabBar:NO];
    }
}

//视图跳转不显示时调用
-(void)viewWillDisappear:(BOOL)animated{
    if(isHidden==YES){
        [self hideTabBar:YES];
    }
}

//隐藏底部菜单栏
-(void)hideTabBar:(BOOL)hide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480-49, view.frame.size.width, view.frame.size.height)];
            }
        } 
        else 
        {
            if (hide) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480-49)];
            }
        }
    }
    [UIView commitAnimations];
}

//刷新表格
-(void)reloadTableView{
    NotifyServices *conn=[NotifyServices getConnection];
    cellsDataArray=[conn findAll];
    [myTable reloadData];
}

@end

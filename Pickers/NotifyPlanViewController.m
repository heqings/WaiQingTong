//
//  NotifyPlanViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyPlanViewController.h"

@implementation NotifyPlanViewController
@synthesize table,cellsDataArray;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    [[NotifyServices getConnection] updateById:notifyId readCount:0];
    cellsDataArray=[[NotifyPlanServices getConnection]findAll];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
    
    self.navigationItem.title=@"拜访信息";
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    table=nil;
    cellsDataArray=nil;
    [super viewDidUnload];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    double height = 95;
    static NSString *CellIdentifier = @"CommentViewCell";
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NotifyPlanE *notifyPlanE=(NotifyPlanE *)[cellsDataArray objectAtIndex:[indexPath row]];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.content.text =notifyPlanE.npContent;
    cell.content.frame=CGRectMake(20, 120, 280, 40);
    [cell.content sizeToFit];
    cell.name.text=notifyPlanE.createUser;
    cell.time.text=notifyPlanE.createDate;
    height += cell.content.frame.size.height;
    
    
    UILabel *startLab=[[UILabel alloc]init];
    startLab.text=@"开始时间：";
    startLab.font=font;
    startLab.frame=CGRectMake(20, 70, 100, 20);
    startLab.backgroundColor=[UIColor clearColor];
    [cell addSubview:startLab];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *startString = [df stringFromDate:[formatter dateFromString:notifyPlanE.createDate]];
    
    UILabel *startTime=[[UILabel alloc]init];
    startTime.text=startString;
    startTime.font=font;
    startTime.textAlignment=UITextAlignmentLeft;
    startTime.frame=CGRectMake(100, 70, 200, 20);
    startTime.backgroundColor=[UIColor clearColor];
    [cell addSubview:startTime];
    
    UILabel *endLab=[[UILabel alloc]init];
    endLab.text=@"结束时间：";
    endLab.font=font;
    startTime.textAlignment=UITextAlignmentLeft;
    endLab.frame=CGRectMake(20, 95, 100, 20);
    endLab.backgroundColor=[UIColor clearColor];
    [cell addSubview:endLab];
    
    NSString *endString = [df stringFromDate:[formatter dateFromString:notifyPlanE.endTime]];
    
    UILabel *endTime=[[UILabel alloc]init];
    endTime.text=endString;
    endTime.font=font;
    endTime.frame=CGRectMake(100, 95, 200, 20);
    endTime.backgroundColor=[UIColor clearColor];
    [cell addSubview:endTime];
    
    [cell.remarkBtn removeFromSuperview];

    UIButton *tgBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    tgBtn.frame=CGRectMake(20,cell.content.frame.size.height+130, 45, 25);
    tgBtn.tag=notifyPlanE.npId;
    [tgBtn setTitle:@"查看" forState:UIControlStateNormal];
    [tgBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:tgBtn];
    
    
    cell.bottom.frame = CGRectMake(0, 0, 320, height+tgBtn.frame.size.height+55);
    cell.bottom.image = [[UIImage imageNamed:@"block_foot_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    cell.frame = CGRectMake(0, 0, 320, height+tgBtn.frame.size.height+50);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}   

-(void)remarkBtnClick:(id)sender{
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    
    UIButton *btn=(UIButton *)sender;
    NotifyPoiViewController *poi=[[NotifyPoiViewController alloc]init];
    poi.npId=btn.tag;
    [self.navigationController pushViewController:poi animated:true];
}


@end

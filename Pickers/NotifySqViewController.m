//
//  NotifySqViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifySqViewController.h"

@interface NotifySqViewController (Private)
-(NSString *)getTypeByString:(NSString *)type;

@end

@implementation NotifySqViewController
@synthesize table,cellsDataArray;

- (void)viewDidLoad
{
    
    
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    [[NotifyServices getConnection] updateById:notifyId readCount:0];
    cellsDataArray=[[NotifySqServices getConnection]findAll];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];

    self.navigationItem.title=@"申请信息";
    
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
    
    NotifySq *notifySq=(NotifySq *)[cellsDataArray objectAtIndex:[indexPath row]];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.tag=[indexPath row];
    cell.content.text =notifySq.nsContent;
    
    [cell.content sizeToFit];
    cell.time.text=notifySq.nsCreateDate;
    cell.title.text= [self getTypeByString:notifySq.nsType];
    
    height += cell.content.frame.size.height;    
    [cell.remarkBtn removeFromSuperview];
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if(notifySq.peopleId!=user.userId){
        PeopleServices *pConn=[PeopleServices getConnection];
        People *p=[pConn findBySpId:notifySq.peopleId];
        cell.name.text=p.name;
    }else{
        cell.name.text=user.name; 
    }
    
    
    if([notifySq.status isEqualToString:@"N"]){
        if(notifySq.peopleId!=user.userId){
            UIButton *tgBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            tgBtn.frame=CGRectMake(20, height-10, 45, 25);
            tgBtn.tag=notifySq.spId;
            [tgBtn setTitle:@"通过" forState:UIControlStateNormal];
            [tgBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:tgBtn];
            
            UIButton *jjBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            jjBtn.frame=CGRectMake(70, height-10, 45, 25);
            jjBtn.tag=notifySq.spId;
            [jjBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [jjBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:jjBtn];
            
            UIButton *zyBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            zyBtn.frame=CGRectMake(120, height-10, 80, 25);
            zyBtn.tag=notifySq.spId;
            [zyBtn setTitle:@"转移申请" forState:UIControlStateNormal];
            [zyBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:zyBtn];
            
            height+=20;
        }
    }else{
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [notifySq.nsRemarkContent sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        
        
        UIImage *bubble = [UIImage imageNamed:@"office_remark"];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImageView.frame=CGRectMake(20,height-10,260, size.height+45);
        [cell addSubview:bubbleImageView];
        //[bubbleImageView release];
        
        UILabel *label=[[UILabel alloc]init];
        label.numberOfLines=0;
        label.text=notifySq.nsRemarkContent;
        label.frame=CGRectMake(30,height, 240, size.height+20);
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        NSString *status;
        if([notifySq.nsRemarkType isEqualToString:@"Y"]){
            status=@"通过";
        }else{
            status=@"拒绝";
        }
        
        UILabel *remarkLabel=[[UILabel alloc]init];
        remarkLabel.text=[NSString stringWithFormat:@"%@在%@%@审核",notifySq.nsRemarkPeople,notifySq.nsRemarkTime,status];
        remarkLabel.frame=CGRectMake(20,height+size.height+30, 260, size.height+20);
        remarkLabel.backgroundColor=[UIColor clearColor];
        remarkLabel.font=font;
        [cell addSubview:remarkLabel];
        
        height+=height+size.height-50;
    }
    
    cell.bottom.frame = CGRectMake(0, 0, 320, height+20);
    cell.bottom.image = [[UIImage imageNamed:@"block_foot_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    cell.frame = CGRectMake(0, 0, 320, height+15);
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
    //self.navigationController.delegate = self;

    UIButton *btn=(UIButton *)sender;
    [[NSUserDefaults standardUserDefaults]setInteger:btn.tag forKey:@"sqSpId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([btn.titleLabel.text isEqualToString:@"通过"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"sqStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        RemarkSqViewController *r=[[RemarkSqViewController alloc]init];
        r.workUtilsDelegate=self;
        [self.navigationController pushViewController:r animated:YES];
    }else if([btn.titleLabel.text isEqualToString:@"拒绝"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"sqStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        RemarkSqViewController *r=[[RemarkSqViewController alloc]init];
        r.workUtilsDelegate=self;
        [self.navigationController pushViewController:r animated:YES];
    }else if([btn.titleLabel.text isEqualToString:@"转移申请"]){
        DivertViewController *add=[[DivertViewController alloc] init];
        add.workUtilsDelegate=self;
        [self presentModalViewController:add animated:YES];
    }  
}

//刷新表格
-(void)reloadTableView{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"divert"] isEqualToString:@"true"]){
        [[NotifySqServices getConnection]deleteById:[[[NSUserDefaults standardUserDefaults]objectForKey:@"sqSpId"]intValue]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"divert"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    cellsDataArray=[[NotifySqServices getConnection]findAll];
    [table reloadData];
}

//获取申请类型
-(NSString *)getTypeByString:(NSString *)type{
    if([type isEqualToString:@"H"]){
        return @"活动";
    }else if([type isEqualToString:@"F"]){
        return @"费用";
    }else if([type isEqualToString:@"C"]){
        return @"出差";
    }else if([type isEqualToString:@"Q"]){
        return @"其他";
    }
    return @"活动";
}

@end

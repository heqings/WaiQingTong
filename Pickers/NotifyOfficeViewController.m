//
//  NotifyOfficeViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyOfficeViewController.h"
#define remarkView   100
#define remarkText   200 

@implementation NotifyOfficeViewController
@synthesize cellsDataArray,table;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    [[NotifyServices getConnection] updateById:notifyId readCount:0];
    cellsDataArray=[[NotifyGzrzServices getConnection]findAll];

    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];

    self.navigationItem.title=@"工作日志";
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
    
    NotifyGzrz *notifyGzrz=(NotifyGzrz *)[cellsDataArray objectAtIndex:[indexPath row]];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.content.text =notifyGzrz.ngContent;
    [cell.content sizeToFit];
    cell.time.text=notifyGzrz.ngCreateDate;
    height += cell.content.frame.size.height;
    
    NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if(notifyGzrz.peopleId!=user.userId){
        PeopleServices *pConn=[PeopleServices getConnection];
        People *p=[pConn findBySpId:notifyGzrz.peopleId];
        cell.name.text=p.name;
    }else{
        cell.name.text=user.name; 
    }
    NSString *tempType;
    if([notifyGzrz.ngType isEqualToString:@"P"]){
        tempType=@"工作计划";
    }else{
        tempType=@"工作总结";
    }
    cell.title.text=tempType;
    
    if([notifyGzrz.status isEqualToString:@"N"]){
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if(notifyGzrz.peopleId!=user.userId){
            cell.remarkBtn.frame=CGRectMake(20,height-10,45,25);
            cell.remarkBtn.tag=notifyGzrz.spId;
            [cell.remarkBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            height+=20;
        }else{
            [cell.remarkBtn removeFromSuperview];
        }
    }else{
        [cell.remarkBtn removeFromSuperview];
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [notifyGzrz.ngRemarkContent sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        
        
        UIImage *bubble = [UIImage imageNamed:@"office_remark"];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImageView.frame=CGRectMake(20,height-10,260, size.height+45);
        [cell addSubview:bubbleImageView];
        //[bubbleImageView release];
        
        UILabel *label=[[UILabel alloc]init];
        label.numberOfLines=0;
        label.text=notifyGzrz.ngRemarkContent;
        label.frame=CGRectMake(30,height, 240, size.height+20);
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        UILabel *remarkLabel=[[UILabel alloc]init];
        remarkLabel.text=[NSString stringWithFormat:@"%@在%@批阅",notifyGzrz.ngRemarkPeople,notifyGzrz.ngRemarkTime];
        remarkLabel.frame=CGRectMake(20,height+size.height+30, 260, size.height+20);
        remarkLabel.backgroundColor=[UIColor clearColor];
        remarkLabel.font=font;
        [cell addSubview:remarkLabel];
        
        height+=height+size.height-55;
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
    UIButton *btn=(UIButton *)sender;
    [[NSUserDefaults standardUserDefaults]setInteger:btn.tag forKey:@"gzrzSpId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;
    //self.navigationController.delegate = self;
    
    RemarkGzrzViewController *r=[[RemarkGzrzViewController alloc]init];
    r.workUtilsDelegate=self;
    [self.navigationController pushViewController:r animated:YES];
}

//刷新表格
-(void)reloadTableView{
    cellsDataArray=[[NotifyGzrzServices getConnection]findAll];
    [table reloadData];
}

@end

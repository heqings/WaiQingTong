//
//  NotifyGzrwViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyGzrwViewController.h"
@interface NotifyGzrwViewController (private)
//刷新表格
-(void)reloadTableView;
@end

@implementation NotifyGzrwViewController
@synthesize table,cellsDataArray;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    [[NotifyServices getConnection] updateById:notifyId readCount:0];
    cellsDataArray=[[NotifyGzrwServices getConnection]findAll];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
    
    self.navigationItem.title=@"工作任务";
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
    
    NotifyGzrw *notifyGzrw=(NotifyGzrw *)[cellsDataArray objectAtIndex:[indexPath row]];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.content.text =notifyGzrw.ngContent;
    [cell.content sizeToFit];
    cell.name.text=notifyGzrw.createUser;
    cell.time.text=notifyGzrw.ngCreateDate;
    cell.title.text=notifyGzrw.ngTitle;
    height += cell.content.frame.size.height;
    
    [cell.remarkBtn removeFromSuperview];
    UIFont *font = [UIFont systemFontOfSize:14];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, height-10, 250, 20)];
    label.text=[NSString stringWithFormat:@"完成时间：%@",notifyGzrw.finishTime];
    label.font=font;
    label.backgroundColor=[UIColor clearColor];
    [cell addSubview:label];
    
    if([notifyGzrw.status isEqualToString:@"N"]){
        
        
        UIButton *rlBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        rlBtn.frame=CGRectMake(20, height+20, 45, 25);
        rlBtn.tag=notifyGzrw.spId;
        [rlBtn setTitle:@"认领" forState:UIControlStateNormal];
        [rlBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:rlBtn];
        
        UIButton *wcBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        wcBtn.frame=CGRectMake(70, height+20, 45, 25);
        wcBtn.tag=notifyGzrw.spId;
        [wcBtn setTitle:@"完成" forState:UIControlStateNormal];
        [wcBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:wcBtn];
        
        height+=50;
    }else if([notifyGzrw.status isEqualToString:@"R"]){
        UIFont *font = [UIFont systemFontOfSize:14];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, height+20, 250, 20)];
        label.text=[NSString stringWithFormat:@"认领时间：%@",notifyGzrw.rlTime];
        label.font=font;
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        UIButton *wcBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        wcBtn.frame=CGRectMake(20, height+50, 45, 25);
        wcBtn.tag=notifyGzrw.spId;
        [wcBtn setTitle:@"完成" forState:UIControlStateNormal];
        [wcBtn addTarget:self action:@selector(remarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:wcBtn];
        
        height+=75;
        
    }else if([notifyGzrw.status isEqualToString:@"Y"]){

        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [notifyGzrw.remarkContent sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        
        
        UIImage *bubble = [UIImage imageNamed:@"office_remark"];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImageView.frame=CGRectMake(20,height+20,260, size.height+45);
        [cell addSubview:bubbleImageView];
        //[bubbleImageView release];
        
        UILabel *label=[[UILabel alloc]init];
        label.numberOfLines=0;
        label.text=notifyGzrw.remarkContent;
        label.frame=CGRectMake(30,height+25, 240, size.height+20);
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        
        height+=height+size.height-65;
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
    [[NSUserDefaults standardUserDefaults]setInteger:btn.tag forKey:@"gzrwSpId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([btn.titleLabel.text isEqualToString:@"认领"]){
        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES ];
        NSData* userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        NSDictionary *dic=[
                           [NSDictionary alloc] 
                           initWithObjects:
                           [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",btn.tag],[Global getKey],user.imei,nil]
                           forKeys:[NSArray arrayWithObjects:@"worktask_id",@"key",@"imei",nil]
                           ];
        
        NSString *json=[dic JSONRepresentation];
        NSMutableData *postBody = [NSMutableData data];
        NSString *param =[NSString stringWithFormat:@"param=%@",json];
        [postBody appendData:[param dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
        
        [[NetUtils shareNetworkHelper] requestDataFromURL:@"worktask/worktaskstatu" withParams:postBody withHelperDelegate:self withSuccessRequestMethod:@"requestSuccess:" withFaildRequestMethod:@"requestFaild:" contentType:NO];
   
    }else if([btn.titleLabel.text isEqualToString:@"完成"]){
        RemarkGzrwViewController *r=[[RemarkGzrwViewController alloc]init];
        r.workUtilsDelegate=self;
        [self.navigationController pushViewController:r animated:YES];
    }
}

- (void)requestSuccess:(NSObject*)result{
    NSDictionary *resultDict = (NSDictionary *)result;

    NotifyGzrwServices *gzrwConn=[NotifyGzrwServices getConnection];
    [gzrwConn updateByParam:[[NSUserDefaults standardUserDefaults]integerForKey:@"gzrwSpId"] rlTime:[resultDict objectForKey:@""] status:@"R"];
    
    [self reloadTableView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFaild:(NSObject*)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//刷新表格
-(void)reloadTableView{
    cellsDataArray=[[NotifyGzrwServices getConnection]findAll];
    [table reloadData];
}

@end

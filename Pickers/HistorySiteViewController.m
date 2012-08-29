//
//  HistorySiteViewController.m
//  Pickers
//
//  Created by 张飞 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistorySiteViewController.h"
#define kCustomButtonHeight		30.0

@implementation HistorySiteViewController
@synthesize table,cellsDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"考勤", @""),
                                   NSLocalizedString(@"签到", @""),
                                   NSLocalizedString(@"标注", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 250, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
    cellsDataArray=[[NSMutableArray alloc]init];
    AttendanceServices *conn=[AttendanceServices getConnection];
    cellsDataArray=[conn findAll];
    selectIndex=0;
}

- (IBAction)segmentAction:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	cellsDataArray=nil;
    
    if(segmentedControl.selectedSegmentIndex==0){
        selectIndex=0;
        AttendanceServices *conn=[AttendanceServices getConnection];
        cellsDataArray=[conn findAll];
        
    }else if(segmentedControl.selectedSegmentIndex==1){
        selectIndex=1;
        PoiHistoryServices *conn=[PoiHistoryServices getConnection];
        cellsDataArray=[conn findAll];
  
    }else if(segmentedControl.selectedSegmentIndex==2){
        selectIndex=2;
        SignInService *conn=[SignInService getConnection];
        cellsDataArray=[conn findAll];
    }
      [table reloadData];      
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    cellsDataArray=nil;
    table=nil;
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    

    if(selectIndex==0){
        Attendance *att=(Attendance *)[cellsDataArray objectAtIndex:indexPath.row];
        UIFont *font = [UIFont systemFontOfSize:18];
        UIFont *font1 = [UIFont systemFontOfSize:16];
        
        [cell.textLabel setFont:font];
        [cell.textLabel setText:att.address];
        
        NSString *detailText=[NSString stringWithFormat:@"考勤时间：%@",att.createtime];
        [cell.detailTextLabel setFont:font1];
        [cell.detailTextLabel setText:detailText];

    }else if(selectIndex==1){
        PoiHistory *info=(PoiHistory *)[cellsDataArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:15];
        UIFont *font1 = [UIFont systemFontOfSize:13.5];
        
        [cell.textLabel setFont:font];
        [cell.textLabel setText:info.poiAddress];

        NSString *detailText=[NSString stringWithFormat:@"签到时间：%@",info.createTime];
        [cell.detailTextLabel setFont:font1];
        [cell.detailTextLabel setText:detailText];
        
        UIImage *image;           
        if([info.poiType isEqualToString:@"KH"]){//客户
            image = [UIImage imageNamed:@"icon_kh"];
        }else if([info.poiType isEqualToString:@"MD"]){//门店
            image = [UIImage imageNamed:@"icon_qy"];
        }else if([info.poiType isEqualToString:@"QD"]){//渠道
            image = [UIImage imageNamed:@"icon_qd"];
        }else if([info.poiType isEqualToString:@"QT"]){//其他
            image = [UIImage imageNamed:@"icon_qt"];
        }
        
        cell.imageView.image = image;
    }else if(selectIndex==2){
        SignIn *signin=(SignIn *)[cellsDataArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:16];
        UIFont *font1 = [UIFont systemFontOfSize:14];
        
        [cell.textLabel setFont:font];
        [cell.textLabel setText:signin.signInName];
        
        NSString *detailText=[NSString stringWithFormat:@"标注时间：%@",signin.createTime];
        [cell.detailTextLabel setFont:font1];
        [cell.detailTextLabel setText:detailText];
        
        UIImage *image;           
        if([signin.signInType isEqualToString:@"KH"]){//客户
            image = [UIImage imageNamed:@"icon_kh"];
        }else if([signin.signInType isEqualToString:@"MD"]){//门店
            image = [UIImage imageNamed:@"icon_qy"];
        }else if([signin.signInType isEqualToString:@"QD"]){//渠道
            image = [UIImage imageNamed:@"icon_qd"];
        }else if([signin.signInType isEqualToString:@"QT"]){//其他
            image = [UIImage imageNamed:@"icon_qt"];
        }
        
        cell.imageView.image = image;
    }
	
    return cell;
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

//点击表格行方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title=@"返回";
    self.navigationItem.backBarButtonItem= backbutton;

    if(selectIndex==0){
        //Attendance *att=(Attendance *)[cellsDataArray objectAtIndex:indexPath.row];
      
    }else if(selectIndex==1){
        //PoiInfo *info=(PoiInfo *)[cellsDataArray objectAtIndex:indexPath.row];
        
    }else if(selectIndex==2){
        SigninInfoViewController *s=[[SigninInfoViewController alloc]init];
        SignIn *signin=(SignIn *)[cellsDataArray objectAtIndex:indexPath.row];
        s.signIn=signin;
        [self.navigationController pushViewController:s animated:true];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中行的颜色
}
@end

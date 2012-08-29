//
//  NotifyTzViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyTzViewController.h"

@implementation NotifyTzViewController
@synthesize table,cellsDataArray;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSInteger notifyId=[[NSUserDefaults standardUserDefaults] integerForKey:@"notifyId"];
    [[NotifyServices getConnection] updateById:notifyId readCount:0];
    cellsDataArray=[[NotifyTzServices getConnection]findAll];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
    
    self.navigationItem.title=@"系统通知";
    
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
    
    NotifyTzE *notifyTzE=(NotifyTzE *)[cellsDataArray objectAtIndex:[indexPath row]];

    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    cell.tag=[indexPath row];
    cell.content.text =notifyTzE.nteContent;
    [cell.remarkBtn removeFromSuperview];
    
    [cell.content sizeToFit];
    cell.name.text=notifyTzE.nteCreateUser;
    cell.time.text=notifyTzE.nteCreateDate;
    cell.title.text=notifyTzE.ntTitle;
    height += cell.content.frame.size.height;
    
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


@end

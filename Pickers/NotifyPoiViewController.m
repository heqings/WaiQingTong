//
//  NotifyPoiViewController.m
//  Pickers
//
//  Created by 张飞 on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotifyPoiViewController.h"
#define kCustomButtonHeight		30.0

@implementation NotifyPoiViewController
@synthesize table,cellsDataArray,npId;


#pragma mark - View lifecycle

- (void)viewDidLoad{

    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"未完成", @""),
                                   NSLocalizedString(@"已完成", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(120, 0, 150, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
    cellsDataArray=[[NSMutableArray alloc]init];
    NotifyPoiServices *conn=[NotifyPoiServices getConnection];
    cellsDataArray=[conn findByFinish:@"N" npId:npId];
    selectIndex=0;
    [super viewDidLoad];
}

- (void)viewDidUnload{

    [super viewDidUnload];

}

- (IBAction)segmentAction:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	cellsDataArray=nil;
    NotifyPoiServices *conn=[NotifyPoiServices getConnection];
    if(segmentedControl.selectedSegmentIndex==0){
        selectIndex=0;
        cellsDataArray=[conn findByFinish:@"N" npId:npId];
        
    }else if(segmentedControl.selectedSegmentIndex==1){
        selectIndex=1;
        cellsDataArray=[conn findByFinish:@"Y" npId:npId]; 
    }
    [table reloadData];      
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

    NotifyPoi *poi=(NotifyPoi *)[cellsDataArray objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    [cell.textLabel setFont:font];
    [cell.textLabel setText:poi.poiAddress];
    
    if(selectIndex==1){
        UIFont *font1 = [UIFont systemFontOfSize:13.5];
        NSString *detailText=[NSString stringWithFormat:@"签到时间：%@",poi.startTime];
        [cell.detailTextLabel setFont:font1];
        [cell.detailTextLabel setText:detailText];
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_kh"];
    cell.imageView.image = image;
    	
    return cell;
}

//设置table行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}
@end

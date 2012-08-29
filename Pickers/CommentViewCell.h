//
//  CommentViewCell.h
//  ShanZaiQB
//
//  Created by Chua Ivan on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell
{
    IBOutlet UIImageView *img;
    IBOutlet UILabel *name;
    IBOutlet UILabel *time;
    IBOutlet UILabel *content;
    IBOutlet UIImageView *bottom;
    IBOutlet UIButton *remarkBtn;
    IBOutlet UILabel *title;
}
@property(nonatomic,strong)IBOutlet UIImageView *img;
@property(nonatomic,strong)IBOutlet UILabel *name;
@property(nonatomic,strong)IBOutlet UILabel *time;
@property(nonatomic,strong)IBOutlet UILabel *content;
@property(nonatomic,strong)IBOutlet UIImageView *bottom;
@property(nonatomic,strong)IBOutlet UIButton *remarkBtn;
@property(nonatomic,strong)IBOutlet UILabel *title;
@end

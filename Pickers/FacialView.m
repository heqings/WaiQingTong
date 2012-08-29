//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(void)loadFacialView:(int)page size:(CGSize)size
{

	for (int i=0; i<4; i++) {
		for (int y=0; y<7; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
			NSString *imageName=[NSString stringWithFormat:@"%d",i*7+y+(page*28)];
			switch ([imageName length]) {
				case 1:
					imageName=[NSString stringWithFormat:@"00%@",imageName];
					break;
				case 2:
					imageName=[NSString stringWithFormat:@"0%@",imageName];
					break;
				default:
					break;
			}
			[button setBackgroundColor:[UIColor darkGrayColor]];
			[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
			[button setFrame:CGRectMake(0+y*size.width, 0+i*size.height, size.width, size.height)];
			button.tag=i*7+y+(page*28);
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
}


-(void)selected:(UIButton*)bt
{
	NSString *str=[NSString stringWithFormat:@"%d",bt.tag];
	
	switch ([str length]) {
		case 1:
			str=[NSString stringWithFormat:@"00%@",str];
			break;
		case 2:
			str=[NSString stringWithFormat:@"0%@",str];
			break;
		default:
			break;
	}
	[delegate selectedFacialView:str];
}



@end

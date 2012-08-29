//
//  KYBubbleView.h
//  DrugRef
//
//  Created by chen xin on 12-6-6.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBubbleView : UIView {
    NSDictionary *_infoDict;
    UILabel         *titleLabel;
    UILabel         *detailLabel;
}

@property (nonatomic, retain)NSDictionary *infoDict;

- (BOOL)showFromRect:(CGRect)rect;

@end

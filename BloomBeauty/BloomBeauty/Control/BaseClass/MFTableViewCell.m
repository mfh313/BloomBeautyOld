//
//  MFTableViewCell.m
//  装扮灵
//
//  Created by Administrator on 15/10/18.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFTableViewCell.h"

@implementation MFTableViewCell

@synthesize m_subContentView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setM_subContentView:(UIView *)subContentView
{
    m_subContentView = subContentView;
    m_subContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:m_subContentView];
}

@end

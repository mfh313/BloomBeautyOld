//
//  MFSuitableWearLibraryDropDownCellView.m
//  BloomBeauty
//
//  Created by EEKA on 16/5/10.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFSuitableWearLibraryDropDownCellView.h"

@interface MFSuitableWearLibraryDropDownCellView ()
{
    __weak IBOutlet UILabel *_textLabel;
    
}

@end

@implementation MFSuitableWearLibraryDropDownCellView

-(void)setCellViewSelected:(BOOL)selected
{
    if (selected) {
        _textLabel.backgroundColor = BBDefaultBgBlackColor;
        _textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textColor = MFDarkTextColor;
    }
}

-(void)setBrandTitle:(NSString *)title
{
   _textLabel.text = title;
}

- (IBAction)onClickCellView:(id)sender {
    if ([self.m_delegate respondsToSelector:@selector(onClickDropDownCellView:)]) {
        [self.m_delegate onClickDropDownCellView:self.indexPath];
    }
}


@end

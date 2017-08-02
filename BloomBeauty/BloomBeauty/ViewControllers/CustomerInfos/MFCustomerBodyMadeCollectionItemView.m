//
//  MFCustomerBodyMadeCollectionItemView.m
//  BloomBeauty
//
//  Created by EEKA on 2016/11/27.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCustomerBodyMadeCollectionItemView.h"
#import "MFCustomerBodyMadeModel.h"
#import "MFCustomerBodyMadeCollectionTapInputView.h"
#import "MFCustomerBodyMadeLogicController.h"

@interface MFCustomerBodyMadeCollectionItemView () <MFCustomerBodyMadeCollectionTapInputViewDelegate>
{
    __weak IBOutlet UIButton *_borderBtn;
    MFCustomerBodyMadeModel *m_bodyMadeItem;
    
    __weak IBOutlet UIImageView *_contentImage;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UILabel *_remarkLabel;
    __weak IBOutlet NSLayoutConstraint *_decHeightConstraint;
    __weak IBOutlet MFCustomerBodyMadeCollectionTapInputView *_tapInputView;
    
    
    
    BOOL m_editing;
    UIEdgeInsets _superScrollViewInset;
}

@end

@implementation MFCustomerBodyMadeCollectionItemView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _descLabel.font = [[self class] titleDescFont];
    _descLabel.numberOfLines = 3;
    [_borderBtn setBackgroundImage:MFImageStretchCenter(@"zbl39") forState:UIControlStateNormal];
    [_borderBtn setAdjustsImageWhenHighlighted:NO];
    
    _tapInputView.m_delegate = self;
    
    [self testBackGroundColor:NO];
}

#pragma mark - MFCustomerBodyMadeCollectionTapInputViewDelegate
-(void)onTapBeginEditing
{    
    if ([self.m_delegate respondsToSelector:@selector(onClickInputBodyMade:)]) {
        [self.m_delegate onClickInputBodyMade:m_bodyMadeItem];
    }
}

-(void)onKeyBoardWillShow:(NSNumber *)duration curve:(NSNumber *)curve needOffet:(CGFloat)yOffest
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat needInsetBotttom = yOffest + 20;
    [self.superScrollView setContentInset:UIEdgeInsetsMake(0, 0, needInsetBotttom, 0)];
    
    [UIView commitAnimations];
}

-(void)onKeyBoardWillHide:(NSNumber *)duration curve:(NSNumber *)curve keyboardEndFrame:(CGRect)keyboardEndFrame
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [self.superScrollView setContentInset:_superScrollViewInset];
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField tapView:(MFCustomerBodyMadeCollectionTapInputView *)tapView
{
    UITextField *containTextField = [tapView containTextField];
    NSString *inputString = containTextField.text;
    
    if ([CommonUtil isNull:inputString]) {
        return;
    }
    
    if ([self.m_delegate respondsToSelector:@selector(onFinishEndEditingBodyMadeModel:string:)]) {
        [self.m_delegate onFinishEndEditingBodyMadeModel:m_bodyMadeItem string:inputString];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string tapView:(MFCustomerBodyMadeCollectionTapInputView *)tapView
{
    return YES;
}

-(void)testBackGroundColor:(BOOL)test
{
    if (!test) {
        return;
    }
    
    self.backgroundColor = [UIColor grayColor];
    _descLabel.backgroundColor =  [UIColor redColor];
    _tapInputView.backgroundColor = [UIColor whiteColor];
}

-(void)setBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem editing:(BOOL)editing
{
    m_editing = editing;
    m_bodyMadeItem = bodyMadeItem;
    
    NSString *imageName = m_bodyMadeItem.descriptionImageName;
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"bodyMade" withExtension:@"bundle"]];
    NSString *imagePath = [bundle pathForResource:imageName ofType:nil];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    [_contentImage setImage:image];
    
    _decHeightConstraint.constant = [[self class] titleDecHeight:m_bodyMadeItem.titleDescription];
    _descLabel.text = m_bodyMadeItem.titleDescription;
    
    _remarkLabel.text = m_bodyMadeItem.remark;
    
    if (m_editing)
    {
        NSString *inputValue = [MFCustomerBodyMadeHelper bodyMadeValueShowStringWithOutUnit:m_bodyMadeItem.bodyMadeValue];
        [_tapInputView setInputViewValue:inputValue unit:m_bodyMadeItem.unitDesc];
    }
    else
    {
        NSString *showString = [MFCustomerBodyMadeHelper bodyMadeValueShowString:m_bodyMadeItem.bodyMadeValue];
        [_tapInputView setValueString:showString];
    }
    
    _superScrollViewInset = self.superScrollView.contentInset;
}

+(CGSize)sizeForBodyMadeModel:(MFCustomerBodyMadeModel *)bodyMadeItem
{
    CGFloat height = 0;
    NSString *titleDesc = bodyMadeItem.titleDescription;
    CGFloat titleDecHeight = [self titleDecHeight:titleDesc];
    titleDecHeight = 70;
    height = 241 + 10 + titleDecHeight + 35;
    
    return CGSizeMake(241, height);
}

+(CGFloat)titleDecHeight:(NSString *)titleDesc
{
    return [titleDesc MFSizeWithFont:[self titleDescFont] maxSize:CGSizeMake(240.0, CGFLOAT_MAX)].height + 20;
}

+(UIFont *)titleDescFont
{
    return [UIFont systemFontOfSize:13.0f];
}

@end

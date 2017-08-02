//
//  MFDiagnosticContentBaseView.m
//  BloomBeauty
//
//  Created by EEKA on 1/11/16.
//  Copyright © 2016 EEKA. All rights reserved.
//

#import "MFDiagnosticContentBaseView.h"

@implementation MFDiagnosticContentBaseView
@synthesize oDataItem;
@synthesize diagnosticSelectViewDelegate;


-(id)initWithDiagnosticDataItem:(MFDiagnosticQuestionDataItem *)oDataItem
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

#pragma mark - MFDiagnosticSelectViewDelegate
//-(BOOL)shouldSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
//{
//    if ([self.diagnosticSelectViewDelegate respondsToSelector:@selector(shouldSelectDiagnosticItemView:indexPath:)]) {
//       return [self.diagnosticSelectViewDelegate shouldSelectDiagnosticItemView:itemView indexPath:subIndexPath];
//    }
//    return YES;
//}
//
//-(void)shouldNotSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
//{
//    if ([self.diagnosticSelectViewDelegate respondsToSelector:@selector(shouldNotSelectDiagnosticItemView:indexPath:)]) {
//        [self.diagnosticSelectViewDelegate shouldNotSelectDiagnosticItemView:itemView indexPath:subIndexPath];
//    }
//}
//
//-(void)didSelectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
//{
//    if ([self.diagnosticSelectViewDelegate respondsToSelector:@selector(didSelectDiagnosticItemView:indexPath:)]) {
//        [self.diagnosticSelectViewDelegate didSelectDiagnosticItemView:itemView indexPath:subIndexPath];
//    }
//}
//
//-(void)didDeselectDiagnosticItemView:(MFDiagnosticSelectView *)itemView indexPath:(NSIndexPath *)subIndexPath
//{
//    if ([self.diagnosticSelectViewDelegate respondsToSelector:@selector(didDeselectDiagnosticItemView:indexPath:)]) {
//        [self.diagnosticSelectViewDelegate didDeselectDiagnosticItemView:itemView indexPath:subIndexPath];
//    }
//}

#pragma mark Method Forwarding
- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ( [super respondsToSelector:aSelector] )
        return YES;
    if ([self.diagnosticSelectViewDelegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([self.diagnosticSelectViewDelegate respondsToSelector:selector]) {
            return [(NSObject *)self.diagnosticSelectViewDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([self.diagnosticSelectViewDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self.diagnosticSelectViewDelegate];
    }
}

+(float)heightForQuestionDataItem:(MFDiagnosticQuestionDataItem *)oDataItem
{
    return 0;
}

@end

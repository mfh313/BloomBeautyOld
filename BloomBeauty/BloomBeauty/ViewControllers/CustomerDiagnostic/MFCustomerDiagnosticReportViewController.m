//
//  MFCustomerDiagnosticReportViewController.m
//  BloomBeauty
//
//  Created by 马方华 on 15/12/17.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticReportViewController.h"
#import "MFCustomerDiagnosticReportSendViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface MFCustomerDiagnosticReportViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    __weak IBOutlet UIWebView *_diagnosticReprotWebView;
    
    __weak IBOutlet UIView *_webGesView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
}

@end

@implementation MFCustomerDiagnosticReportViewController
@synthesize diagnosisResultId,diagnosticReportCustomerInfo;

-(void)onClickRightBtn
{
    UIStoryboard *storyBoard = BBCreateStoryBoard;
    MFCustomerDiagnosticReportSendViewController *diagnosticReportSendVC = [storyBoard instantiateViewControllerWithIdentifier:@"MFCustomerDiagnosticReportSendViewController"];
    diagnosticReportSendVC.diagnosticReportCustomerInfo = self.diagnosticReportCustomerInfo;
    diagnosticReportSendVC.diagnosisResultId = self.diagnosisResultId;
    [self.navigationController pushViewController:diagnosticReportSendVC animated:YES];
}

- (void)initWebViewProgressView
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self MF_wantsFullScreenLayout:NO];
    
    [self setRightNaviButtonWithTitle:@"下一页" action:@selector(onClickRightBtn)];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadWebView)];
    [_webGesView addGestureRecognizer:tapGes];
    _webGesView.hidden = YES;
    
    _diagnosticReprotWebView.delegate = self;
    
    NSURL *reportUrl = [self.diagnosisResultId customerDiagnosticUrl];
    [_diagnosticReprotWebView loadRequest:[NSURLRequest requestWithURL:reportUrl]];
    
//    [self loadTestPage:_diagnosticReprotWebView];
}

- (void)loadTestPage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"WeChatJs" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CKRadialMenuManager sharedManager].nowNav = self.navigationController;
    [[CKRadialMenuManager sharedManager]showMenu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[CKRadialMenuManager sharedManager] hiddenMenu];
}

-(void)reloadWebView
{
    NSURL *reportUrl = [self.diagnosisResultId customerDiagnosticUrl];
    [_diagnosticReprotWebView loadRequest:[NSURLRequest requestWithURL:reportUrl]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webGesView.hidden = YES;
    _diagnosticReprotWebView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theTitle) {
        self.title = theTitle;
    }
    else
    {
        self.title = @"诊断报告";
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _webGesView.hidden = NO;
    _diagnosticReprotWebView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

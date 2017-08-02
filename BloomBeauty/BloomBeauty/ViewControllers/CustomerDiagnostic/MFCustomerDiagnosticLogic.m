//
//  MFCustomerDiagnosticLogic.m
//  BloomBeauty
//
//  Created by Administrator on 15/12/14.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFCustomerDiagnosticLogic.h"
#import "MFCustomerDiagnosticCheckApi.h"
#import "MFCustomerDiagnosticDataUpdateApi.h"

#pragma mark - MFCustomerDiagnosticLogic
@interface MFCustomerDiagnosticLogic ()
{
    MFCustomerDiagnosticCheckApi *_checkApi;
    MFCustomerDiagnosticCheckApi *_checkNeedApi;
    MFCustomerDiagnosticDataUpdateApi *_updateDataApi;
    
    NSMutableArray *_diagnosticQuestions;
    NSString *_diagnosticQuestionsVersion;
    
    MFCustomerDiagnosticLogicLoadCompletedBlock _loadCompletedBlock;
    MFCustomerDiagnosticLogicLoadProgressBlock  _progressBlock;
    MFCustomerDiagnosticLogicLoadFailureBlock   _failBlock;
}

@end

@implementation MFCustomerDiagnosticLogic

+ (MFCustomerDiagnosticLogic *)sharedLogic
{
    static MFCustomerDiagnosticLogic *_sharedLogic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogic = [[self alloc] init];
    });
    
    return _sharedLogic;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        _diagnosticDataItemArray = [NSMutableArray array];
        
        _checkApi = [MFCustomerDiagnosticCheckApi new];
        _updateDataApi = [MFCustomerDiagnosticDataUpdateApi new];
        _checkNeedApi= [MFCustomerDiagnosticCheckApi new];
        
        _diagnosticQuestions = [NSMutableArray array];
        
        if ([self testLocalJsonData]) {
            [self testLocalJsonData];
        }
        else
        {
            [self readjsonData];
        }
        
    }
    
    return self;
}

-(BOOL)testLocalJsonData
{
    return NO;
}

-(void)readLocalJsonData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"diagnosticData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *jsonDataDic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
    
    NSMutableArray *contents = jsonDataDic[@"questions"];
    
    for (int i = 0; i < contents.count; i++) {
        MFDiagnosticQuestionDataItem *dataItem = [MFDiagnosticQuestionDataItem yy_modelWithDictionary:contents[i]];
        
        dataItem.diagnosticResultSelectedArray = [NSMutableArray array];
        NSMutableAttributedString *showingTitleDescription = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d、%@",i+1,dataItem.titleDescription]];
        dataItem.showingTitleDescription = showingTitleDescription;
        
        [_diagnosticQuestions addObject:dataItem];
    }
    
    [self fixDiagnosticQuestions];
    
}

+(void)getDiagnosticData:(MFCustomerDiagnosticLogicLoadCompletedBlock)completedBlock
                progress:(MFCustomerDiagnosticLogicLoadProgressBlock)progressBlock
               failBlock:(MFCustomerDiagnosticLogicLoadFailureBlock)failBlock
{
    [[self sharedLogic] getDiagnosticData:completedBlock progress:progressBlock failBlock:failBlock];
}

-(void)getDiagnosticData:(MFCustomerDiagnosticLogicLoadCompletedBlock)completedBlock
                progress:(MFCustomerDiagnosticLogicLoadProgressBlock)progressBlock
               failBlock:(MFCustomerDiagnosticLogicLoadFailureBlock)failBlock
{
    NSAssert(completedBlock, @"completedBlock must not nil");
    
    _loadCompletedBlock = [completedBlock copy];
    _progressBlock = [progressBlock copy];
    _failBlock = [failBlock copy];
    
    NSMutableArray *array = [[[self class] sharedLogic] diagnosticQuestions];
    if (array.count > 0) {
        completedBlock([array mutableCopy]);
        return;
    }
    
    if ([self testLocalJsonData]) {
        [self readLocalJsonData];
    }
    else
    {
        [self readjsonData];
    }
}

-(void)needLoadQuestions:(MFCustomerDiagnosticLogicCheckLoadBlock)loadBlock
{
    if ([self testLocalJsonData]) {
        loadBlock(YES);
        return;
    }
    
    [_checkNeedApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *serverNowVersion = responseObject[@"nowVersion"];

        if ([_diagnosticQuestionsVersion isEqualToString:serverNowVersion]) {
            loadBlock(NO);
            return;
        }
        
        if (_diagnosticQuestions) {
            [_diagnosticQuestions removeAllObjects];
        }
        
        dispatch_main_async_safe(^{
            loadBlock(YES);
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        dispatch_main_async_safe(^{
            loadBlock(YES);
        });
        
    }];
}

-(void)readjsonData
{
    __weak typeof(self) weakSelf = self;
    
    if (_progressBlock) {
        _progressBlock(@"正在获取诊断题目，请稍等...");
    }
    
    [_checkApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSString *serverNowVersion = responseObject[@"nowVersion"];
        NSArray *historys = responseObject[@"history"];
        
        __block NSString *jsonDataUrl = nil;
        [historys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"version"] isEqualToString:serverNowVersion]) {
                jsonDataUrl = obj[@"jsonUrl"];
            }
        }];
        
        if ([_diagnosticQuestionsVersion isEqualToString:serverNowVersion]) {
            NSLog(@"诊断题目版本号相同,不操作返回");
            return;
        }
        
        _diagnosticQuestionsVersion = serverNowVersion;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateDiagnosticData:jsonDataUrl];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        if (_failBlock) {
            _failBlock(error);
            _failBlock = nil;
        }
    }];
}

-(void)updateDiagnosticData:(NSString *)jsonDataUrl
{
    _updateDataApi.dataUrl = jsonDataUrl;
    [_updateDataApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [_diagnosticQuestions removeAllObjects];
        NSMutableDictionary *responseObject = request.responseJSONObject;
        NSMutableArray *contents = responseObject[@"questions"];
                
        for (int i = 0; i < contents.count; i++) {
            MFDiagnosticQuestionDataItem *dataItem = [MFDiagnosticQuestionDataItem MM_modelWithDictionary:contents[i]];
            
            dataItem.diagnosticResultSelectedArray = [NSMutableArray array];
            NSMutableAttributedString *showingTitleDescription = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d、%@",i+1,dataItem.titleDescription]];
            dataItem.showingTitleDescription = showingTitleDescription;
            
            [_diagnosticQuestions addObject:dataItem];
        }
        
        [self fixDiagnosticQuestions];
        
        if (_loadCompletedBlock) {
            _loadCompletedBlock(_diagnosticQuestions);
            _loadCompletedBlock = nil;
        }
        
        if (_progressBlock) {
            _progressBlock = nil;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSError *error = request.error;
        if (_failBlock) {
            _failBlock(error);
            _failBlock = nil;
        }
    }];
}

-(void)fixDiagnosticQuestions
{
    for (int i = 0; i < _diagnosticQuestions.count; i++) {
        MFDiagnosticQuestionDataItem *dataItem = _diagnosticQuestions[i];
        NSMutableAttributedString *showingTitleDescription = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d、%@",i+1,dataItem.titleDescription]];
        dataItem.showingTitleDescription = showingTitleDescription;
        
        dataItem.contentImageWidth = dataItem.contentImageWidth / 2;
        dataItem.contentImageHeight = dataItem.contentImageHeight / 2;
        
        NSArray *contentArray = dataItem.diagnosticContentArray;
        __block CGFloat contentDescriptionWidth = 0;
        __block CGFloat contentDescriptionMaxHeight = 0;
        [contentArray enumerateObjectsUsingBlock:^(MFDiagnosticQuestionContentDataItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat width = [self contentDescriptionWidth:obj.contentDescription];
            if (dataItem.contentDescriptionMaxWidth > 0) {
                width = [obj.contentDescription MFSizeWithFont:MFDiagnosticFont maxSize:CGSizeMake(dataItem.contentDescriptionMaxWidth, MAXFLOAT)].width;
            }
            
            if (width > contentDescriptionWidth) {
                contentDescriptionWidth = width;
            }
            
            CGFloat height = [obj.contentDescription MFSizeWithFont:MFDiagnosticFont maxSize:CGSizeMake(contentDescriptionWidth, MAXFLOAT)].height;
            if (height > contentDescriptionMaxHeight) {
                contentDescriptionMaxHeight = height;
            }
        }];
        
        
        if ([dataItem.itemType isEqualToString:MFDiagnosticTypeKeyImage]) {
            dataItem.itemHorizontalSpace = 10;
            dataItem.itemVerticalSpace = 10;
            
            dataItem.itemWidth = MAX(contentDescriptionWidth + 20, dataItem.contentImageWidth + 18);;
            dataItem.itemHeight = dataItem.contentImageHeight + 30 + contentDescriptionMaxHeight;
        }
        else if ([dataItem.itemType isEqualToString:MFDiagnosticTypeKeyString])
        {
            dataItem.itemHorizontalSpace = 5;
            dataItem.itemVerticalSpace = 2;
            if (dataItem.contentDescriptionMaxWidth > 0) {
                dataItem.itemWidth = MAX(contentDescriptionWidth + 50, dataItem.contentDescriptionMaxWidth);
            }
            else
            {
                dataItem.itemWidth = MAX(contentDescriptionWidth + 50, 200);
            }
            
            dataItem.itemHeight = MFDiagnosticStrItemHeight;
        }
    }

}

-(NSMutableArray *)diagnosticQuestions
{
    return _diagnosticQuestions;
}

-(CGFloat)contentDescriptionWidth:(NSString *)contentDescription
{
    CGFloat contentDescriptionWidth = 0;
    UIFont *contentDescriptionFont = MFDiagnosticFont;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    contentDescriptionWidth = [contentDescription MFSizeWithFont:contentDescriptionFont maxSize:maxSize].width;
    return contentDescriptionWidth;
}

-(NSMutableArray *)diagnosticDataItemArray
{
    return _diagnosticDataItemArray;
}


@end

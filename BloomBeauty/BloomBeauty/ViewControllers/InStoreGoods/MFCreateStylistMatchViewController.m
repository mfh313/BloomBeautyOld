//
//  MFCreateStylistMatchViewController.m
//  BloomBeauty
//
//  Created by EEKA on 16/6/12.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "MFCreateStylistMatchViewController.h"
#import "StylistMatchItem.h"
#import "MFStylistMatchItemView.h"

@interface MFCreateStylistMatchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    __weak IBOutlet MFUICollectionView *_collectionView;
    __weak IBOutlet UILabel *_countLabel;
    NSMutableArray *_stylistMatchs;
}

@end

@implementation MFCreateStylistMatchViewController
@synthesize itemStyleColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self MF_wantsFullScreenLayout:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.title = @"设计师原搭";
    [self setLeftNaviButtonWithAction:@selector(onClickBackBtn:)];
    
    _stylistMatchs = [NSMutableArray array];
    
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MFCollectionViewCell class] forCellWithReuseIdentifier:@"MFCreateStylistMatchViewController"];
    
    [self createStylistMatch];
}

- (void)onClickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _stylistMatchs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFCreateStylistMatchViewController";
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell.m_subContentView == nil) {
        MFStylistMatchItemView *cellView = [MFStylistMatchItemView viewWithNibName:@"MFStylistMatchItemView"];
        cell.m_subContentView = cellView;
        cell.contentView.backgroundColor = [UIColor redColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.m_subContentView.frame = cell.contentView.bounds;
    StylistMatchItem *item = _stylistMatchs[indexPath.row];
    
    MFStylistMatchItemView *cellView = (MFStylistMatchItemView *)cell.m_subContentView;
    [cellView setStylistMatchItem:item];
        
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _collectionView.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(_collectionView.frame);
    int itemIndex = (scrollView.contentOffset.x + width * 0.5) / width;
    [self setClothingCountLabelText:itemIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(_collectionView.frame);
    int itemIndex = (scrollView.contentOffset.x + width * 0.5) / width;
    [self setClothingCountLabelText:itemIndex];
}

-(void)setClothingCountLabelText:(NSInteger)index
{
    NSString *clothingCountLabelText = [NSString stringWithFormat:@"%d / %d",(int)(index+1),(int)_stylistMatchs.count];
    _countLabel.text = clothingCountLabelText;
}

- (void)createStylistMatch
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSString *commodityCode = self.itemStyleColor;
    NSDictionary *parameters = @{@"token": token,
                                 @"itemStyleColor":commodityCode,
                                 };
    
    [MFHTTPUtil POST:MFApiCreateStylistMatchURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *statusCode = responseObject[@"statusCode"];
         if (![statusCode isEqualToString:@"200"])
         {
             return;
         }
         
         if ([responseObject[@"stylistMatch"] isKindOfClass:[NSNull class]]) {
             [self showTips:@"无数据" withDuration:1];
             return;
         }
         
         [_stylistMatchs removeAllObjects];
         
         NSArray *stylistMatchs = responseObject[@"stylistMatch"];
         for (int i = 0; i < stylistMatchs.count; i++) {
             StylistMatchItem *item = [StylistMatchItem objectWithKeyValues:stylistMatchs[i]];
             [item makeCodesInfo];
             [_stylistMatchs addObject:item];
         }
         
         dispatch_main_async_safe(^{
             
             [_collectionView reloadData];
             [self setClothingCountLabelText:0];
             
             if(_stylistMatchs.count == 0)
             {
                 [self showMBStatusInViewController:@"无数据" withDuration:1];
             }
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

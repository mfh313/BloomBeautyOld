//
//  MFSelectGuideView.m
//  装扮灵
//
//  Created by Administrator on 15/10/20.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFSelectGuideView.h"
#import "BBEmployeeInfo.h"
#import "MFSelectGuideCell.h"

@interface MFSelectGuideView() <UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *_ClerkList;
    __weak IBOutlet UITableView *_storeManagerList;
    NSMutableArray *_ClerkArray;
    NSMutableArray *_storeManagerArray;
}

@end

@implementation MFSelectGuideView
@synthesize selectedEmployeeId;
@synthesize selectedEmployeeInfo;
@synthesize delegate;

-(void)queryEmployee:(NSNumber *)entityId
{
    NSString *token = BloomBeautyToken;
    if (!token) {
        return;
    }
    
    NSDictionary *parameters = @{@"entityId": entityId,
                                 @"token": token
                                 };
    [MFHTTPUtil POST:MFApiQueryEmployeeURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"statusCode"] isEqualToString:@"200"]) {
             NSArray *employeeInfo = responseObject[@"employeeInfo"];
             NSArray *array = [NSArray objectArrayWithKeyValuesArray:employeeInfo];
             [array enumerateObjectsUsingBlock:^(NSDictionary *employeeInfoDic, NSUInteger idx, BOOL *stop) {
                 BBEmployeeInfo *employeeInfo = [BBEmployeeInfo objectWithKeyValues:employeeInfoDic];
                 if ([employeeInfo.jobTitleCode isEqualToString:@"40"]) {
                     [_storeManagerArray addObject:employeeInfo];
                 }
                 else
                 {
                    [_ClerkArray addObject:employeeInfo];
                 }
             }];
             
             [_ClerkList reloadData];
             [_storeManagerList reloadData];
         }
         else
         {
             NSLog(@"%@",responseObject[@"message"]);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

-(void)awakeFromNib
{
    _ClerkArray = [NSMutableArray array];
    _storeManagerArray = [NSMutableArray array];
    [_ClerkList registerNib:[MFSelectGuideCell nib] forCellReuseIdentifier:[MFSelectGuideCell nibid]];
    [_storeManagerList registerNib:[MFSelectGuideCell nib] forCellReuseIdentifier:[MFSelectGuideCell nibid]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _ClerkList)
    {
        return _ClerkArray.count;
    }
    else if (tableView == _storeManagerList)
    {
        return _storeManagerArray.count;
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MFSelectGuideCell";
    MFSelectGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MFSelectGuideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    BBEmployeeInfo *employeeInfo = nil;
    if (tableView == _ClerkList)
    {
        employeeInfo = (BBEmployeeInfo*)_ClerkArray[indexPath.row];
    }
    else if(tableView == _storeManagerList)
    {
        employeeInfo = (BBEmployeeInfo*)_storeManagerArray[indexPath.row];
    }
    
    [cell setName:employeeInfo.employeeName];
    [cell setCellSelected:NO];
    if (_selectedEmployeeId == employeeInfo.employeeId) {
        [cell setCellSelected:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBEmployeeInfo *employeeInfo = nil;
    if (tableView == _ClerkList)
    {
        employeeInfo = (BBEmployeeInfo*)_ClerkArray[indexPath.row];
    }
    else if (tableView == _storeManagerList)
    {
        employeeInfo = (BBEmployeeInfo*)_storeManagerArray[indexPath.row];
    }
    
    _selectedEmployeeId = employeeInfo.employeeId;
    self.selectedEmployeeInfo = employeeInfo;
    [_ClerkList reloadData];
    [_storeManagerList reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedEmployee:)]) {
        [self.delegate didSelectedEmployee:employeeInfo];
    }
}

@end

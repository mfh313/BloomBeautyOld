//
//  MFApiUtil.h
//  BloomBeauty
//
//  Created by Administrator on 15/11/6.
//  Copyright © 2015年 EEKA. All rights reserved.
//

#import "MFObject.h"


#define MFURL [MFApiUtil getMFURL]

#define MFCustomerDiagnosticlUrl(reportID) [MFApiUtil customerDiagnosticlUrl:reportID]

#define BloomBeautyToken [[MFApiUtil sharedUtil] token]

#define MFURLWithPara(para) [MFURL stringByAppendingPathComponent:para]

#define MFApiLoginURL MFURLWithPara(@"login/login")

#define MFApiCheckUserURL MFURLWithPara(@"user/checkUser")

#define MFApiQueryBrandURL MFURLWithPara(@"company/queryBrand")

#define MFApiQueryEmployeeURL MFURLWithPara(@"company/queryEmployee")

#define MFApiCheckUpgradeURL MFURLWithPara(@"company/checkUpgrade")

#define MFApiAddCustomerURL MFURLWithPara(@"company/addCustomer")

#define MFApiQueryCustomerURL MFURLWithPara(@"company/queryCustomer")

#define MFApiUpdateCustomerURL MFURLWithPara(@"company/updateCustomer")

#define MFApiQueryCustomerByIdURL MFURLWithPara(@"company/queryCustomerById")

#define MFApiUpdatePortraitEntityURL MFURLWithPara(@"company/updatePortrait")

#define MFApiQueryDiagnosisResultsByEntityURL MFURLWithPara(@"company/queryDiagnosisResultsByEntity")

#define MFApiDiagnosisCustomerURL MFURLWithPara(@"company/diagnosisCustomer")

#define MFApiDiagnosisReportSendEmailURL MFURLWithPara(@"company/sendMail")

#define MFApiQueryAvailableCommodityURL MFURLWithPara(@"company/queryAvailableCommodity")

#define MFApiQueryCommodityByItemCodeURL MFURLWithPara(@"company/queryCommodityByItemCode")

#define MFApiQueryAvailableSizeURL MFURLWithPara(@"company/queryAvailableSize")

#define MFApiQueryPurchaseRecordsURL MFURLWithPara(@"company/queryPurchaseRecords")

#define MFApiQueryDiagnosisRecordsURL MFURLWithPara(@"company/queryDiagnosisRecords")

#define MFApiQueryEntityDiagnosisRecordsURL MFURLWithPara(@"company/queryEntityDiagnosisRecords")

#define MFApiQueryEntityAndIndividualDiagnosisRecordsURL MFURLWithPara(@"company/queryEntityAndIndividualDiagnosisRecords")

#define MFApiAddFavoriteURL MFURLWithPara(@"company/addFavorite")

#define MFApiRemoveFavoriteURL MFURLWithPara(@"company/removeFavorite")

#define MFApiQueryFavoritesURL MFURLWithPara(@"company/queryFavorites")

#define MFApiGenerateItemStockURL MFURLWithPara(@"company/generateItemStock")

#define MFApiGenerateOneClothesMatchMatchURL MFURLWithPara(@"company/generateOneClothesMatch")

#define MFApiCreateStylistMatchURL MFURLWithPara(@"company/createStylistMatch")

#define MFApiCustomerMaintenanceUpdateURL MFURLWithPara(@"company/addOrUpdateCustomerMaintain")

#define MFApiCustomerQueryMaintenanceURL MFURLWithPara(@"company/queryCustomerMaintain")

#define MFApiCustomerDeleteMaintenanceURL MFURLWithPara(@"company/deleteCustomerMaintain")

#define MFApiCustomerBodyMadeUpdateURL MFURLWithPara(@"company/addOrUpdateCustomerMeasurement")

#define MFApiCustomerBodyMadeQueryURL MFURLWithPara(@"company/queryCustomerMeasurement")

#define MFApiCustomerDeleteBodyMadeURL MFURLWithPara(@"company/deleteCustomerMeasurement")

#define MFApiGetRegionsURL MFURLWithPara(@"company/getRegions")

#define MFApiGetCitiesURL MFURLWithPara(@"company/getCities")

#define MFApiCustomerInfoGetTemplateURL MFURLWithPara(@"company/getDictionaryValue")

typedef void(^MFApiUtilTokenGetBlock)(NSString *token);

@interface MFApiUtil : MFObject

@property (nonatomic,strong) NSString *token;

+ (MFApiUtil *)sharedUtil;
+ (void)getNewToken:(MFApiUtilTokenGetBlock)tokenBlock;
+ (BOOL)packageTest;
+ (NSString*)getPackageDesc;
+ (NSString*)getMFURL;
+ (NSString*)customerDiagnosticlUrl:(NSString *)reportID;

@end




//
//  oneSDKBranchBaseActivity.h
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface oneSDKBranchBaseActivity : NSObject

// 获取总接口
+(void)getGeneralInterface;
// 总json
+(NSMutableDictionary*)getBaseJson;
// 请求域名以及其余接口名称
+(void)doSDKInterfaceInfo;
// 设置总名称
+(void)setSDKInterfaceInfo:(NSMutableDictionary*)json;

@end

NS_ASSUME_NONNULL_END

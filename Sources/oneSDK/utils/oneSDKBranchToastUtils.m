//
//  oneSDKBranchToastUtils.m
//  oneSDK
//
//  Created by 天下 on 2022/5/9.
//

#import <UIKit/UIKit.h>
#import "./oneSDKBranchToastUtils.h"
#import "./oneSDKBranchLogUtils.h"

@implementation oneSDKBranchToastUtils

+(void)show:(NSString*)message duration:(NSTimeInterval)time
{
//    if (message.length > 16)
//    {
//        oneSDKBranchLogUtils(@"文本过长");
//        return;
//    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
//    NSLog(@"[[UIApplication sharedApplication] windows].count is %lu", [[UIApplication sharedApplication] windows].count);
//    
//    UIWindow* window; //= [UIApplication sharedApplication].keyWindow;
    
//    if ([[UIApplication sharedApplication] windows].count <= 0)
//    {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    [window makeKeyAndVisible];
//    }
//    else
//    {
//    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    }



//    oneSDKBranchLogUtils(@"message is %@", message);

    
//    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
//    [window makeKeyAndVisible];
//    UIWindow* window = [[UIApplication sharedApplication] windows].count <= 0 ? [[[UIApplication sharedApplication] delegate] window] : [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    if ([[UIApplication sharedApplication] windows] != NULL)
//    {
//        window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    }
//    else
//    {
//        window = [[[UIApplication sharedApplication] delegate] window];
//    }
    
    
    
    UIView* showview = [[UIView alloc] init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];

    UILabel* label = [[UILabel alloc] init];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    label.frame = CGRectMake(10, 5, labelSize.width + 20, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:10];
    [showview addSubview:label];

    showview.frame = CGRectMake((screenSize.width - labelSize.width - 20) / 2, screenSize.height / 7 * 6, labelSize.width + 40, labelSize.height + 10);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end

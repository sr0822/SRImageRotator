//
//  GroupBuyingHeader.h
//  01-团购
//
//  Created by chao on 15/7/7.
//  Copyright (c) 2015年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupBuyingHeader : UIView

+ (instancetype)groupBuyingHeader;
-(void)loadDataWith:(NSString *)urlString;
@end

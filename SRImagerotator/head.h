//
//  head.h
//  网易新闻
//
//  Created by sr0822 on 15/10/29.
//  Copyright © 2015年 sr0822. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface head : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgsrc;
+(instancetype)headWithDict:(NSDictionary *)dict;
+(void)getArrayWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *array))completion;
@end

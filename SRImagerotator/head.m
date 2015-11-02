//
//  head.m
//  网易新闻
//
//  Created by sr0822 on 15/10/29.
//  Copyright © 2015年 sr0822. All rights reserved.
//

#import "head.h"
#import <objc/runtime.h>
#import "AFNetworking.h"
@implementation head
+(instancetype)headWithDict:(NSDictionary *)dict{
    
    head *myhead=[[head alloc]init];
    NSArray *properties=[self getProperties];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *property=obj;
        if (dict[property]) {
            [myhead setValue:dict[property] forKey:property];
        }
    }];
    return myhead;
}
+(NSArray *)getProperties{
    unsigned int count;
    objc_property_t *properties=class_copyPropertyList(self, &count);
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        objc_property_t pro=properties[i];
        const char *name=property_getName(pro);
        NSString *property=[[NSString alloc]initWithCString:name encoding:NSUTF8StringEncoding];
        [array addObject:property];
        
        
    }
    free(properties);
    return array;
}
+(void)getArrayWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *array))completion{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *array=responseObject[@"headline_ad"];
        // 字典转模型
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [arrayM addObject:[self headWithDict:dict]];
        }
        completion(arrayM);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加载失败");
    }];
}
@end

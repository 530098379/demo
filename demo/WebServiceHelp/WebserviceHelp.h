//
//  WebserviceHelp.h
//  commodity
//
//  Created by 王欢 on 15/5/5.
//  Copyright (c) 2015年 王欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceHelp : NSObject

-(NSString*)ResponseData:(NSString *)methodName withParas:(NSDictionary *)parasdic;
@end

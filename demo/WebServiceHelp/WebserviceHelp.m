//
//  WebserviceHelp.m
//  commodity
//
//  Created by 王欢 on 15/5/5.
//  Copyright (c) 2015年 王欢. All rights reserved.
//

#import "WebserviceHelp.h"
#import "ASIHTTPRequest.h"

@implementation WebserviceHelp

-(id)init{
    if (self=[super init]) {
        
    }
    return self;
}

-(NSString*)ResponseData:(NSString *)methodName withParas:(NSDictionary *)parasdic{

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" "
                                "xmlns:d=\"http://www.w3.org/2001/XMLSchema\" "
                                "xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" "
                                "xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                                "<v:Header /><v:Body>"
                                "<n0:GetAlertRule id=\"o0\" c:root=\"1\" xmlns:n0=\"http://webservice.water.dhrtec.com/\" />"
                                "</v:Body></v:Envelope>"
                             ];

    NSURL *url = [NSURL URLWithString:@"http://192.168.1.20:8080/water/ws/AlertRule"];
    //请求发送到的路径
    ASIHTTPRequest *theRequest =  [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [theRequest addRequestHeader: @"SOAPAction" value:@"http://webservice.water.dhrtec.com/"];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [theRequest startSynchronous];
    NSString *aaa = theRequest.responseStatusMessage;
    int *a = theRequest.responseStatusCode;
    
    
        NSError *error = [theRequest error];
       if (!error) {
        NSLog(@"aaaaaaa%@",error);
        NSString *responseString1 = [theRequest responseString];
        NSData *data = [theRequest responseData];//WebService接口返回的数据
           NSArray *keys =   [NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableContainers
                              error:nil];

        /*NSString *theXML = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];//将返回数据转换为字符串，进行解析（本文中返回的数据为XML数据）
        NSMutableString*result=[[NSMutableString init]initWithData:data encoding:NSUTF8StringEncoding ];
        NSString *responseString = [theRequest responseString];
        NSLog(@"%@",theXML);
        NSLog(@"%@",result);
        //NSLog(@"bbbbbbbb%@",responseString);*/
    }

    return @"aaa";
}

@end
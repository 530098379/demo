//
//  WebserviceHelp.m
//  commodity
//
//  Created by 王欢 on 15/5/5.
//  Copyright (c) 2015年 王欢. All rights reserved.
//

#import "WebserviceHelp.h"
#import "ASIHTTPRequest.h"

#define soapAction "\"http://webservice.water.dhrtec.com/\""
#define soapUrl "http://192.168.1.20:8080/water/ws/"

@implementation WebserviceHelp

-(id)init{
    if (self=[super init]) {
        
    }
    return self;
}

-(NSString*)ResponseData:(NSString *)methodName withParas:(NSDictionary *)parasdic{
    NSString *para = @"";
    if (parasdic.count >0) {
        for (NSString *key in parasdic) {
            NSString *temp = @"";
            temp = [NSString stringWithFormat:@"<%@>%@</%@>", key, parasdic[key], key ];
            [para stringByAppendingString:temp];
        }
    }

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" "
                                "xmlns:d=\"http://www.w3.org/2001/XMLSchema\" "
                                "xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" "
                                "xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                                "<v:Header />"
                                "<v:Body>"
                                //"<n0:GetAlertRule id=\"o0\" c:root=\"1\" xmlns:n0=\"http://webservice.water.dhrtec.com/\" />"
                                //"<n0:GetAlertRule id=\"o0\" c:root=\"1\" xmlns:n0=%@ />"
                                "<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=%@ >"
                                "%@"
                                "</n0>"
                                "</v:Body>"
                                "</v:Envelope>"
                             ,methodName, para, @soapAction];

    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.20:8080/water/ws/AlertRule"];
    NSURL *url = [NSURL URLWithString:[@soapUrl stringByAppendingString:methodName]];
    //请求发送到的路径
    ASIHTTPRequest *theRequest =  [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    //[theRequest addRequestHeader: @"SOAPAction" value:@"http://webservice.water.dhrtec.com/"];
    [theRequest addRequestHeader: @"SOAPAction" value:@soapAction];
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [theRequest startSynchronous];
    
    NSString *responseString = @"";
    NSError *error = [theRequest error];
    if (!error) {
        responseString = [theRequest responseString];
    }

    return responseString;
}

@end
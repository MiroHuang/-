//
//  KHttpPackageModel.m
//  土爸
//
//  Created by 黄凯 on 2016/11/29.
//  Copyright © 2016年 XHC. All rights reserved.
//

#import "KHttpPackageModel.h"
#import "NSString+KString.h"
#import "KGetDeviceInfo.h"

#define Boundary @"Boundary"

static int timeoutInterval = 10;

@implementation KHttpPackageModel

#pragma mark - Private Method
+ (NSArray *)kNSArrayFromNSDictionary:(NSDictionary *)parameters andAllowEmptyValue:(BOOL)allowEmptyValue {
    NSMutableArray *parametersKeyMuArr = [NSMutableArray arrayWithArray:[parameters allKeys]];
    [parametersKeyMuArr sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES]]];
    NSMutableArray *resultMuArr = [NSMutableArray arrayWithCapacity:parametersKeyMuArr.count];
    for (int i = 0; i < parametersKeyMuArr.count; i++) {
        NSString *keyStr = [parametersKeyMuArr objectAtIndex:i];
        NSString *valueStr = [parameters objectForKey:keyStr];
        if (!allowEmptyValue) {//是否允许value为空
            if ([valueStr isKindOfClass:[NSString class]] && (!valueStr || valueStr.length == 0)) {
                continue;
            }
        }
        [resultMuArr addObject:[NSString stringWithFormat:@"%@=%@", keyStr, valueStr]];
    }
    return resultMuArr;
}
+ (NSString *)kNSStringFromNSDictionary:(NSDictionary *)dic {
    if (!dic) {
        dic = [NSDictionary dictionary];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    BOOL loginLoginSuccess = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginSuccess"];
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    if (loginLoginSuccess && token.length > 0) {
        [parameters setValue:token forKey:@"token"];
    }
    
    //[parameters setValue:[KGetDeviceInfo getIPAddress:YES] forKey:@"clientip"];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
    [parameters setValue:[NSNumber numberWithInteger:nowTime] forKey:@"timestamp"];
    [parameters setValue:@"asdsijo8d" forKey:@"noncestr"];
    NSString *tmpStr = [[self kNSArrayFromNSDictionary:parameters andAllowEmptyValue:NO] componentsJoinedByString:@"&"];
    tmpStr = [tmpStr stringByAppendingFormat:@"&apisalt=bPORSWBRnGscAuZ7"];
    [parameters setValue:[NSString md5:tmpStr] forKey:@"sign"];
    return [[self kNSArrayFromNSDictionary:parameters andAllowEmptyValue:YES] componentsJoinedByString:@"&"];
}
#pragma mark - UploadData URLRequest
+ (NSURLRequest *)HTTPRequestOperationForUploadDataWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSMutableURLRequest *request = [urlRequest mutableCopy];
    request.timeoutInterval = timeoutInterval;
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setHTTPMethod:method];
    
    NSData *postData = [[self kNSStringFromNSDictionary:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    urlRequest = [request copy];
    return urlRequest;
}
#pragma mark - UploadTask URLRequest(上传图片)
+ (NSURLRequest *)HTTPRequestOperationForUploadTaskWithUrlRequest:(NSString *)URLString {
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSMutableURLRequest *request = [urlRequest mutableCopy];
    request.timeoutInterval = timeoutInterval;
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setHTTPMethod:@"POST"];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", Boundary] forHTTPHeaderField:@"Content-Type"];
    
    urlRequest = [request copy];
    return urlRequest;
}
+ (NSData *)HTTPRequestOperationForUploadTaskWithImageModelArr:(NSArray<KImageModel *> *)imageModelArr parameters:(id)parameters {
    __block NSInteger datalength = 512;
    
    [imageModelArr enumerateObjectsUsingBlock:^(KImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KImageModel *kImageModel = (KImageModel *)obj;
        kImageModel.kImageData = UIImageJPEGRepresentation(kImageModel.kImage, kImageModel.kCompressionQuality);
        datalength += [kImageModel.kImageData length];
    }];
    
    __block NSMutableArray<NSString *> *parameterKeyStrMuArray = [NSMutableArray array];/** 传参Key(NSString) */
    __block NSMutableArray<NSData *> *parameterValueDataMuArray = [NSMutableArray array];/** 传参Value(NSData) */
    NSString *parameterStr = [self kNSStringFromNSDictionary:parameters];
    NSArray *parameterArr = [parameterStr componentsSeparatedByString:@"&"];
    [parameterArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *parameter = (NSString *)obj;
        NSRange range = [parameter rangeOfString:@"="];
        NSString *value = [parameter substringFromIndex:range.location+1];
        NSString *key = [parameter substringToIndex:range.location];
        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
        datalength += [data length];
        [parameterValueDataMuArray addObject:data];
        [parameterKeyStrMuArray addObject:key];
    }];
    
    __block NSMutableData *postData = [NSMutableData dataWithCapacity:datalength];
    [parameterValueDataMuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", [parameterKeyStrMuArray objectAtIndex:idx]] dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = (NSData *)obj;
        [postData appendData:[[NSString stringWithFormat:@"Content-Length: %lu\r\n\r\n", data.length] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:data];
    }];
    
    [imageModelArr enumerateObjectsUsingBlock:^(KImageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KImageModel *kImageModel = (KImageModel *)obj;
        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.jpg\"\r\n\r\n", kImageModel.kImageKey] dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = (NSData *)kImageModel.kImageData;
        [postData appendData:data];
    }];
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", Boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return postData;
}
@end

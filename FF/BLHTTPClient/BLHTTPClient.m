
//  BLHTTPClient.m
//  BLHTTPClient
//
//  Created by Tov_ on 14-4-14.
//  Copyright (c) 2014年 Fulian. All rights reserved.
//

#import "BLHTTPClient.h"
#import "AFNetworking.h"
#import "define.h"
#import "UploadParam.h"
#import "LResponse.h"
#import "MBProgressHUD.h"

@implementation BLHTTPClient{
//    AFHTTPRequestOperationManager *af_httpRequestManager;
    AFHTTPSessionManager *af_session;
    NSMutableDictionary *dictionaryForConnectionTag;
}
+(BLHTTPClient *)shareInstance{
    static BLHTTPClient *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}
-(id)init{
    self = [super init];
    if (self) {
//        af_httpRequestManager = [AFHTTPRequestOperationManager manager];
        dictionaryForConnectionTag = [[NSMutableDictionary alloc]initWithCapacity:20];
    }
    return self;
}


/**
 *  该方法用于判断进入的网络连接请求是否是第一次，或者是否是重复请求（上一次请求还没结束，相同的请求又开始了）
 *
 *  @param verifyDictionary 外部传来的参数
 *
 *  @return 是否同意发起请求
 */
-(BOOL)verifyReuqest:(NSString*)verifyString{
    /**
     *  第一次请求经过数据中心类时，做一下标记，然后将请求交给AFHTTPRequestOperation。然后有返回数据，则将该标记清空。这样，在该过程中，如果有重复请求，在存在tag标记时，不会将请求交给AFHTTPRequestOperation
     */
    /**
     *  这个标识存在于传来的NSDictionary中，这样就可以确保每个类中每个请求传来的标识都不一样。
     使用NSMutableDictionary 储存该标识。key - value 对应 ‘key’储存的是每个请求的标识，‘value’储存的是请求的状态。默认是NO，发起请求时改变为YES，收到返回数据的时候还原为NO。如果有重复请求进入，则判断value为YES，阻止该次请求。
     */
    if ([dictionaryForConnectionTag objectForKey:verifyString]) {
        /**
         *  如果NSMutableDictionary中存在该标识，则去查看对应value的状态
         */
        if ([[dictionaryForConnectionTag objectForKey:verifyString] integerValue]== NO) {
            //[[BaiduMobStat defaultStat] eventEnd:@"id" eventLabel:@"重复事件"];
            return NO;
        }else{
            //[[BaiduMobStat defaultStat] eventStart:@"id" eventLabel:@"事件开始了"];
            return YES;
        }
        
        
    }else{
        /**
         *  如果没有该标识，则说明该请求是第一次，将其加入字典中，然后发起请求，百度统计
         */
        [dictionaryForConnectionTag setObject:[NSNumber numberWithBool:0] forKey:verifyString];
        //[[BaiduMobStat defaultStat] eventStart:@"id" eventLabel:@""];
        return YES;
    }
}

- (NSString*)getParameters:(NSString *)urlString
{
    NSString * newUrl = nil;
    NSString *versionUrl = nil;
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString* phoneModel = [[UIDevice currentDevice] model];
    //BLLocationManager *locationManager = [BLLocationManager sharedManager];
    versionUrl = [NSString stringWithFormat:@"%@?version=%@&systemVersion=%@&phoneModel=%@&source=%d",urlString, bundleVersion, systemVersion,phoneModel,1];
    NSLog(@"======================%@",versionUrl);
    //NSLog(@"===%ld",(long)locationManager.currentCityID);
    //NSLog(@"==%ld",(long)locationManager.currentWebID);
    ///NSLog(@"=%@",[[NSUserDefaults standardUserDefaults] objectForKey:K_DISTRICT_NAME]);

    
//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        NSLog(@"cookie:%@,%@", [cookie name], [cookie value]);
//    }
//    
    
//    NSArray * array = [versionUrl componentsSeparatedByString:@"?"];
//    NSString * paramParString = nil;
//    if (array.count>1) {
//        paramParString = [CommonFunc base64StringFromText:[array objectAtIndex:1]];
//        newUrl = [NSString stringWithFormat:@"%@?%@",[array objectAtIndex:0],paramParString];
//    }
//    NSLog(@"%@",newUrl);
    return newUrl;
}

// 请求超时设置
-(void)Get:(NSDictionary*)urlDictionary success:(void (^)(id responseObject))completion
   failure:(void (^)(NSError *error))failure
{
    
    if (![self verifyReuqest:[urlDictionary objectForKey:@"paramsIdentifier"]]) {
        return;
    }
    NSString *MethodType = [urlDictionary objectForKey:@"paramsMethod"] ;
    if ([MethodType isEqualToString:@"GET"]) {
        NSString *finalUrlString = [self getParameters:[urlDictionary objectForKey:@"paramsURL"]];
        af_session = [AFHTTPSessionManager manager];
        if (![self beforeExecute:af_session]) {
            return;
        };
        /**
         *  可以接受的类型
         */
        //af_session.responseSerializer = [AFHTTPResponseSerializer serializer];
        af_session.requestSerializer = [AFHTTPRequestSerializer serializer];
        [af_session GET:finalUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completion) {
                 completion(responseObject);
            }
            NSLog(@"%@",responseObject);
            //[[BaiduMobStat defaultStat] eventEnd:@"id" eventLabel:@"事件结束了"];
            [dictionaryForConnectionTag removeObjectForKey:[urlDictionary objectForKey:@"paramsIdentifier"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            LResponse *response = [[LResponse alloc]init];
            response.text = task.taskDescription;
            response.header = nil;
            response.body = nil;
            response.messsage = nil;
            response.error = error;
            response.status = [[NSNumber alloc]initWithInt:-1];
            [self afterExecute:response];
            if (failure) {
                failure(error);
            }
            //[[BaiduMobStat defaultStat] eventEnd:@"id" eventLabel:@"事件结束了"];
            [dictionaryForConnectionTag removeObjectForKey:[urlDictionary objectForKey:@"paramsIdentifier"]];
        }];
    }
}


+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *af_session = [AFHTTPSessionManager manager];
//    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:T_PARM_COOKIE];
//    [af_session.requestSerializer setValue:cookie forHTTPHeaderField:T_PARM_COOKIE];
//    af_session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    af_session.requestSerializer = [AFHTTPRequestSerializer serializer];
    if ([USERID length] > 0 && [PASSWD length] > 0) {
        [af_session.requestSerializer setValue:@"PiaoLiangApp" forHTTPHeaderField:@"User-Agent"];
    }
    
    [af_session POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure{
    
    if (parameters) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        dic[@"version"] = M_VERSION;
        dic[@"systemVersion"] = M_SYSTEMVERSION;
        dic[@"phoneModel"] = M_PHONEMODEL;
        parameters = dic;
    } else {
        if ([URLString containsString:@"?"]) {
            NSString *str = [NSString stringWithFormat:@"%@&version=%@&systemVersion=%@&phoneModel=%@", URLString, M_VERSION, M_SYSTEMVERSION, M_PHONEMODEL];
            URLString = str;
        } else {
            NSString *str = [NSString stringWithFormat:@"%@?version=%@&systemVersion=%@&phoneModel=%@", URLString, M_VERSION, M_SYSTEMVERSION, M_PHONEMODEL];
            URLString = str;
        }
        
        
    }
    
    TLog(@"%@, %@", parameters, URLString);
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"check"]) {
//        return;
//    }
    //进行网络请求
    AFHTTPSessionManager *af_session = [AFHTTPSessionManager manager];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    
//    af_session.securityPolicy = securityPolicy;
//    af_session.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    af_session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    NSMutableSet *acceptableSet = [NSMutableSet setWithSet:af_session.responseSerializer.acceptableContentTypes];
//    [acceptableSet addObject:@"text/html"];
//    af_session.responseSerializer.acceptableContentTypes = acceptableSet;
//    af_session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    
//    af_session.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDate *date = [NSDate date];
    NSMutableString *dateStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", date]];
    [dateStr deleteCharactersInRange:NSMakeRange(19, 6)];
    [dateStr appendString:@"."];
    NSMutableDictionary *cookieProperties = [[NSMutableDictionary alloc] init];
    [cookieProperties setObject:@"clientUTCTime" forKey:NSHTTPCookieName];
    [cookieProperties setObject:dateStr forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:C_DOMAIN forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:C_ORIGINURL forKey:NSHTTPCookieOriginURL];
    NSHTTPCookie *cookies = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookies];
    
    NSArray *cookiess = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:T_PARM_COOKIE];
    
    NSMutableString *cookieStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", cookie]];
    
    for (NSHTTPCookie *cookie in cookiess) {
        // Here I see the correct rails session cookie
//        NSLog(@"Block cookie: %@", cookie);
        if ([cookie.name isEqualToString:@"clientUTCTime"]) {
            [cookieStr appendString:[NSString stringWithFormat:@"; %@=%@", cookie.name, cookie.value]];
        }
        
    }
    
    
    
    [af_session.requestSerializer setValue:cookieStr forHTTPHeaderField:T_PARM_COOKIE];
    [af_session GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"check"];
}

#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(UploadParam *)uploadParam
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *af_session = [AFHTTPSessionManager manager];
    //af_session.responseSerializer = [AFHTTPResponseSerializer serializer];
    //af_session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [af_session POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (BOOL)beforeExecute:(AFHTTPSessionManager *)manager {
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    return true;
}

- (BOOL)afterExecute:(LResponse *) response {
    
    if (response.error == nil) {
        return TRUE;
    }
    
    if ([response.error code] == NSURLErrorNotConnectedToInternet) {
        [self alertErrorMessage:@"网络不给力"];
        return FALSE;
    }
    
    NSLog(@"server error text is %@", response.text);
    [self alertErrorMessage:@"服务器故障，请稍后再试。"];
    
    return true;
}

- (void)alertErrorMessage:(NSString *)message{
    NSLog(@"%@",message);
}

+ (void)networkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [[NSNotificationCenter defaultCenter] postNotificationName:TZ_UNKNOWN object:NSLocalizedString(@"网络异常, 请检查网络", nil)];
                TLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:TZ_NOTREACHABLE object:NSLocalizedString(@"网络异常, 请检查网络", nil)];
                TLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [[NSNotificationCenter defaultCenter] postNotificationName:TZ_NOTREACHABLE object:NSLocalizedString(@"网络异常, 请检查网络", nil)];
                TLog(@"wifi网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:TZ_REFRESH object:nil];
                break;
                
            default:
                TLog(@"蜂窝数据");
                [[NSNotificationCenter defaultCenter] postNotificationName:TZ_REFRESH object:nil];
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)getLoginStatusWithURL:(NSString *)url Parameter:(NSDictionary *)par Success:(void (^)(id responseObj))responseObj Error:(void (^)(NSError * error))failure
{
    AFHTTPSessionManager *af_session = [AFHTTPSessionManager manager];
        af_session.requestSerializer = [AFHTTPRequestSerializer serializer];
        [af_session GET:url parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObj) {
                responseObj(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];

}

/** 监测登录状态 */
+ (void)getUserStatus:(void (^)(id))user {
    //先监测是否登录
    [BLHTTPClient getLoginStatusWithURL:[NSString stringWithFormat:@"%@%@", T_BASE_URL, T_USER_CLIENTINFO_URL] Parameter:nil Success:^(id responseObj) {
        TLog(@"%@", responseObj);
        NSString *loginS = responseObj[@"data"][@"Login"];
        NSString *UserSysNo = responseObj[@"data"][@"UserSysNo"];
        if (![UserSysNo isKindOfClass:[NSNull class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:UserSysNo forKey:U_USERSYSNO];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:U_USERSYSNO];
        }
        
        TLog(@"login = %@", loginS);
        //loginS = 0为未登录 1为已登录
        if (loginS.integerValue == 0) {
            //监测是否保存有用户账号 存在后自动尝试登录
            if ([USERID length] > 0 && [PASSWD length] > 0) {
                NSMutableDictionary *parms = [NSMutableDictionary dictionary];
                [parms setObject:USERID forKey:T_PARM_USERID];
                [parms setObject:PASSWD forKey:T_PARM_PASSWD];
                [BLHTTPClient postWithURLString:[NSString stringWithFormat:@"%@%@", T_BASE_URL, T_USER_LOGIN_URL] parameters:parms success:^(id responseObject) {
                    TLog(@"%@", responseObject);
                    NSString *errS = responseObject[@"error"];
                    //登录失败 通知弹出login页面 用户自行登录
                    if (errS.integerValue != 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"needLogin" object:nil];
                    } else {
                        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                            TLog(@"cookie:%@,%@", [cookie name], [cookie value]);
                            if ([[cookie name] isEqualToString:@"PHPSESSID"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]] forKey:T_PARM_COOKIE];
//                                break;
                            }
                            
                        }
                        user(responseObject);
                        [[NSNotificationCenter defaultCenter] postNotificationName:U_PARMS_SETLANGUAGE object:nil];
                    }
                } failure:^(NSError *error) {
                    TLog(@"%@", error);
                }];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"needLogin" object:nil];
            }
        } else {
            user(@{@"error" : @"0"});
        }
    } Error:^(NSError *error) {
        user(@{@"error" : @"1"});
        [[NSNotificationCenter defaultCenter] postNotificationName:TZ_LOGINFAILE object:nil];
        TLog(@"%@", error);
    }];

}

//设置语言
+ (void)setupLanguageWithRefresh:(void (^)(id finish))finish {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:T_PARM_COOKIE];
    NSString *setLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:U_PARMS_SETLANGUAGE];
    [BLHTTPClient getWithURLString:[NSString stringWithFormat:@"%@/rest/locale/setLanguage", T_BASE_URL] parameters:@{@"LanguageCode" : setLanguage} success:^(id responseObject) {
        TLog(@"%@", responseObject);
        
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            TLog(@"cookie:%@,%@", [cookie name], [cookie value]);
            if ([[cookie name] isEqualToString:@"PHPSESSID"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]] forKey:T_PARM_COOKIE];
                break;
            }
        }
        finish(responseObject);
           } failure:^(NSError *error) {
        TLog(@"%@", error);
    }];
}

+ (void)iwatchGetUserStatus:(void (^)(id))user {
    //先监测是否登录
    [BLHTTPClient getLoginStatusWithURL:[NSString stringWithFormat:@"%@%@", T_BASE_URL, T_USER_CLIENTINFO_URL] Parameter:nil Success:^(id responseObj) {
        TLog(@"%@", responseObj);
        NSString *loginS = responseObj[@"data"][@"Login"];
        TLog(@"login = %@", loginS);
        //loginS = 0为未登录 1为已登录
        if (loginS.integerValue == 0) {
            //监测是否保存有用户账号 存在后自动尝试登录
            if ([USERID length] > 0 && [PASSWD length] > 0) {
                NSMutableDictionary *parms = [NSMutableDictionary dictionary];
                [parms setObject:USERID forKey:T_PARM_USERID];
                [parms setObject:PASSWD forKey:T_PARM_PASSWD];
                [BLHTTPClient postWithURLString:[NSString stringWithFormat:@"%@%@", T_BASE_URL, T_USER_LOGIN_URL] parameters:parms success:^(id responseObject) {
                    TLog(@"%@", responseObject);
                    NSString *errS = responseObject[@"error"];
                    //登录失败 通知弹出login页面 用户自行登录
                    if (errS.integerValue != 0) {
                        
                    } else {
                        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                            TLog(@"cookie:%@,%@", [cookie name], [cookie value]);
                            if ([[cookie name] isEqualToString:@"PHPSESSID"]) {
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]] forKey:T_PARM_COOKIE];
                            }
                            
                        }
                        user(responseObject);
                    }
                } failure:^(NSError *error) {
                    TLog(@"%@", error);
                    user(@{@"error" : @"1"});
                }];
            } else {
                
                user(@{@"error" : @"1"});
                
            }
        } else {
            user(responseObj);
        }
    } Error:^(NSError *error) {
        user(@{@"error" : @"1"});
    }];
    
    
}

@end

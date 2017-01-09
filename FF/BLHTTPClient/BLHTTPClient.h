//
//  BLHTTPClient.h
//  BLHTTPClient
//
//  Created by Tov_ on 14-4-14.
//  Copyright (c) 2014年 Fulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BLHttpParamsManager.h"
#import "UIViewController+HttpResponse.h"
#import "define.h"

@class UploadParam;

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

@interface BLHTTPClient : NSObject


+(BLHTTPClient *)shareInstance;
typedef NSURLSessionTask HYBURLSessionTask;

/**
 *  接收请求参数，判断发起的请求类型，将返回的参数返回vc
 *
 *  @param data    请求url数据
 *  @param success 请求成功返回的数据
 *  @param failure 请求失败返回的数据
 *
 *  @return void
 */

- (void)Get:(NSDictionary*)urlDictionary
                            success:(void (^)(id responseObject))completion
                            failure:(void (^)(NSError *error))failure;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param resultBlock 请求的结果
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(UploadParam *)uploadParam
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

/** 监测网络 */
+ (void)networkStatus;

/** 获取用户状态 */
+ (void)getUserStatus:(void (^)(id user))user;
+ (void)iwatchGetUserStatus:(void (^)(id user))user;

@end




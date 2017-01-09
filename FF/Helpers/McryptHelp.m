//
//  McryptHelp.m
//
//  Created by Tov_ on 2016/10/13.
//  Copyright © 2016年 com.ticket. All rights reserved.
//

#import "McryptHelp.h"

@interface McryptHelp()

@end

@implementation McryptHelp

+ (NSString*)descode:(NSString*)encryptText
{
    
    NSString *headStr = [encryptText substringToIndex:2];
    
    //1.判斷開頭是否為P~
    if([headStr isEqualToString:@"P~"]){
        //2.除去P~
        NSString *keyBodyStr = [encryptText substringFromIndex:2];
        
        //3.取前8個字元為Key
        NSString *tempKeyStr = [keyBodyStr substringToIndex:8];
        NSMutableString *keyStr = [[NSMutableString alloc] init];
        for(int i = 7; i >= 0; i--)
        {
            [keyStr appendString: [tempKeyStr substringWithRange:NSMakeRange(i, 1)]];
             //NSLog(@"第%ld个字符是:%hu",(long)i, [tempKeyStr characterAtIndex:i]);
        }
        //4.將char_8.rever() + char_8 = key
        [keyStr appendString:tempKeyStr];
        NSLog(@"keykeykey ==== %@",keyStr);
        
        //5.剩下的內容base64_decode
        //除去前8個字元的內容為加密內容
        NSString *base64Encoded = [keyBodyStr substringFromIndex:8];
        
        //將內容轉為nsdata
        NSData *encodeData = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:0];
        
        //取前16個byte為iv值
        NSData *ivData = [encodeData subdataWithRange:NSMakeRange(0, 16)];
        
        Byte *testByte = (Byte *)[ivData bytes];
        for(int i=0;i< 16 ;i++)
            printf("ivData = %d\n",testByte[i]);
        
        
        
        NSData *keyData = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte *keyByte = (Byte *)[keyData bytes];
        for(int i=0;i< 16 ;i++)
            printf("keyByte = %d\n",keyByte[i]);
        
        NSInteger length = encodeData.length - 16;
        NSData *bodyData = [encodeData subdataWithRange:NSMakeRange(16, length)];
        Byte *bodyByte = (Byte *)[bodyData bytes];
        for(int i=0;i< 20 ;i++)
            printf("bodyData = %d\n",bodyByte[i]);

        int LastLength = bodyData.length - 20;

        for(int i= LastLength; i < bodyData.length ;i++){
            printf("LASTbodyData = %d\n",bodyByte[i]);
        }
        
        
        
        //NSString *decodeStr = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];

       // NSData *gtmDecodeData = [GTMBase64 decodeString:base64Encoded];
       // NSString *gtmdecodeStr = [[NSString alloc] initWithData:gtmDecodeData encoding:NSUTF8StringEncoding];
        
        //NSData *originData = [decodeBodyStr dataUsingEncoding:NSUTF8StringEncoding];
        //NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        //NSString* decodeStr = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
        
        //取前16個字元為iv值
        //NSString *ivStr = [haxStr substringToIndex:16];
        //NSLog(@"ivStrivStrivStrivStrivStr ======= %@",ivStr);
        //剩下為加密內容
        //NSString *bodyStr = [haxStr substringFromIndex:16];
        
        
        //NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        //NSData *ivData = [ivStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;

        NSData *resultData = [self doCipher:bodyData iv:ivData key:keyData context:kCCDecrypt error:&error];

        NSString* resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        NSData *resultData2 = [self aes256_decrypt:bodyData andKey:keyData andIV:ivData];
        NSLog(@"%@", resultData2);
//        NSString* resultStr2 = [[NSString alloc] initWithData:resultData2 encoding:NSUTF8StringEncoding];
        
//        CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithData:bodyData key:keyData iv:ivData];
//        
//        NSLog(@"%@", aes256Decrypt.utf8String);
        
        NSString *sData = @"http://10.62.198.165/rest/scan/verifyTicket/b6938ea71ad1f020/7eb4476e/0qrXjyzxuYM61USZ4UTOT%252BaYg3gA%252BGED9MYgSEnf1HEpxjwynktGcnZ6z4Zb3%252BxTZpu%252Fa%252BxXmLrPvOB9K76%252BIA==";
        NSData *dData = [sData dataUsingEncoding:NSUTF8StringEncoding];

        
        //測試資料
        //測試加密
        NSData *dEncrypt = [self doCipher:dData iv:ivData key:keyData context:kCCEncrypt error:&error];
        //encode
        NSData *testEncodeData = [dEncrypt base64EncodedDataWithOptions:0];
        NSLog(@"testEncodeData %@", [NSString stringWithUTF8String:[testEncodeData bytes]]);
//        NSString *testEncodeStr = [[NSString alloc] initWithData:testEncodeData encoding:NSUTF8StringEncoding];
        
        
        NSData *testDecodeData = [testEncodeData initWithBase64EncodedData:testEncodeData options:0];
        NSLog(@"testDecodeData %@", [NSString stringWithUTF8String:[testDecodeData bytes]]);

        
        //測試解密
        NSData *dDecrypt = [self doCipher:testDecodeData iv:ivData key:keyData context:kCCDecrypt error:&error];
        NSString *sDecrypt = [[NSString alloc] initWithData:dDecrypt encoding:NSUTF8StringEncoding];
        //測試結果
        NSLog(@"Decrypted Data: %@",sDecrypt);

        
        //NSLog(@"decodeStrdecodeStrdecodeStrdecodeStr ======= :%@",resultStr);
        return resultStr;
    }
    else{
        NSLog(@"%@" , @"Not PCode");
        return @"Null";
    }
}
+ (NSData *)aes256_decrypt:(NSData *)data andKey:(NSData *)keyData andIV:(NSData *)ivData   //解密
{
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding ,
                                          [keyData bytes], kCCBlockSizeAES128,
                                          [ivData bytes],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    free(buffer);
    return nil;
}
+ (NSData *)doCipher:(NSData *)dataIn
                  iv:(NSData *)iv
                 key:(NSData *)symmetricKey
             context:(CCOperation)encryptOrDecrypt
               error:(NSError **)error
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
    
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       [symmetricKey bytes],
                       kCCKeySizeAES128,
                       [iv bytes],
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    
    if (ccStatus == kCCSuccess) {
        //NSData *outData = [NSData dataWithBytesNoCopy:dataOut.mutableBytes length:cryptBytes];
        /***
         //若需返回 NSString，需要上面加密算法和解密算法的各个方法对应好，使用下列语句才不会返回 nil; 切记 dataLength 一定匹配好
         NSString *outString = [[NSString alloc]initWithData:outData encoding:NSUTF8StringEncoding];
         ***/
        //NSString *outString = [[NSString alloc]initWithData:outData encoding:NSUTF8StringEncoding];
        //NSLog(@"outStringoutStringoutStringoutStringoutStringoutString ======= %@",outString);
        dataOut.length = cryptBytes;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:@"kEncryptionError"
                                         code:ccStatus
                                     userInfo:nil];
        }
        dataOut = nil;
    }
    
    return dataOut;
}

+ (NSString *) dataToHexString:(NSData *)data
{
    NSUInteger          len = [data length];
    char *              chars = (char *)[data bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}
//+(NSString *)AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key
//{
//        
//        if( ![self validKey:key] ){
//            return nil;
//        }
//        
//        char keyPtr[kCCKeySizeAES128 + 1];
//        memset(keyPtr, 0, sizeof(keyPtr));
//        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//        
//        char ivPtr[kCCBlockSizeAES128 + 1];
//        memset(ivPtr, 0, sizeof(ivPtr));
//        [key getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//        
//        NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
//        NSUInteger dataLength = [data length];
//        size_t bufferSize = dataLength + kCCBlockSizeAES128;
//        void *buffer = malloc(bufferSize);
//        
//        size_t numBytesCrypted = 0;
//        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                              kCCAlgorithmAES128,
//                                              0x0000,
//                                              [key UTF8String],
//                                              kCCBlockSizeAES128,
//                                              [key UTF8String],
//                                              [data bytes],
//                                              dataLength,
//                                              buffer,
//                                              bufferSize,
//                                              &numBytesCrypted);
//        if (cryptStatus == kCCSuccess) {
//            NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//            
//            NSString *decoded=[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//            return [self processDecodedString:decoded];  
//        }  
//        
//        free(buffer);  
//        return nil;  
//        
//    }
//}
@end

//
//  NSString+Common.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo
{
    //    NSString *condition = @"^(13[0-9]|15[0-9]|18[0-9]|14[57]|17[0-9])[0-9]{8}$";
    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
    
}

- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,12}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}


- (BOOL)isUserName
{
    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isChineseUserName
{
    NSString *      regex = @"(^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}


- (BOOL)isQQ
{
    NSString *regex = @"^[1-9]\\d{4,10}$";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isUrlAddress
{
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [emailTest evaluateWithObject:self];
    
}

- (int)charCount
{
    
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

- (BOOL)isPureNumandCharacters
{
    //    - (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    //    }
    
    //    NSString *str;
    //    str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    //    if(str.length > 0)
    //    {
    //        return NO;
    //    }
    //    return YES;
}

- (NSString *)stringByShowLinefeedString
{
    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    newStr = [newStr stringByReplacingOccurrencesOfString:@"<br />\r\n" withString:@"\n"];
    
    NSMutableString *string = [NSMutableString stringWithString:newStr];
    if(string.length > 6) {
        if ([[string substringWithRange:NSMakeRange(string.length - 6, 6)] isEqualToString:@"<br />"]) {
            [string deleteCharactersInRange:NSMakeRange(string.length - 6, 6)];
        }
    }
    newStr = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    //    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"<br />\r\n" withString:@"\r\n"];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"  "];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    return newStr;
    
    //    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"<br />\r\n" withString:@"\r\n"];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"  "];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    //    return newStr;
}

- (NSString *)stringByPostLinefeedString
{
    NSString *newStr = self;
    
    NSMutableString *mutString = [NSMutableString stringWithString:newStr];
    NSMutableArray *mutArray = [NSMutableArray array];
    NSMutableArray *charArray = [NSMutableArray array];
    NSString *temp =nil;
    for(int i =0; i < [mutString length]; i++)
    {
        temp = [newStr substringWithRange:NSMakeRange(i,1)];
        if ([temp isEqualToString:@" "]) {
            [mutArray addObject:@(i)];
        }
        [charArray addObject:temp];
    }
    for (int i = 0; i < mutArray.count ; i ++) {
        NSNumber *num = mutArray[i];
        if (num.integerValue) {
            NSString *tempChar = [charArray objectAtIndex:num.integerValue - 1];
            if ([tempChar isEqualToString:@" "]) {
                [mutString replaceCharactersInRange:NSMakeRange(num.integerValue, 1) withString:@"¡"];
            } else {
                //                [mutString replaceCharactersInRange:NSMakeRange(num.integerValue, 1) withString:@" "];
            }
        } else {
            //出现在最前面
        }
    }
    [mutString replaceOccurrencesOfString:@"¡" withString:@"&nbsp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutString.length)];
    newStr =  [mutString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />\r\n"];
    NSLog(@"%@",mutString);
    
    
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"  " withString:@" &nbsp;"];
    
    //    [newStr stringByAppendingString:@"<br />"];
    //    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\r\n<br />\r\n"];
    //    newStr = [newStr stringByReplacingOccurrencesOfString:@"  " withString:@" &nbsp;"];
    //    newStr = [newStr stringByAppendingString:@"<br />"];
    return newStr;
}

@end

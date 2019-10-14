//
//  NSString+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSString+FDAdd.h"
#import "NSData+FDAdd.h"
#import "NSNumber+FDAdd.h"
#import "UIDevice+FDAdd.h"
#import "FDCategoriesMacro.h"
#import "UIScreen+FDAdd.h"

FDSYNTH_DUMMY_CLASS(NSString_FDAdd)


@implementation NSString (FDAdd)

- (NSString *)fd_md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_md2String];
}

- (NSString *)fd_md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_md4String];
}

- (NSString *)fd_md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_md5String];
}

- (NSString *)fd_sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_sha1String];
}

- (NSString *)fd_sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_sha224String];
}

- (NSString *)fd_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_sha256String];
}

- (NSString *)fd_sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_sha384String];
}

- (NSString *)fd_sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_sha512String];
}

- (NSString *)fd_crc32String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_crc32String];
}

- (NSString *)fd_hmacMD5StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacMD5StringWithKey:key];
}

- (NSString *)fd_hmacSHA1StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacSHA1StringWithKey:key];
}

- (NSString *)fd_hmacSHA224StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacSHA224StringWithKey:key];
}

- (NSString *)fd_hmacSHA256StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacSHA256StringWithKey:key];
}

- (NSString *)fd_hmacSHA384StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacSHA384StringWithKey:key];
}

- (NSString *)fd_hmacSHA512StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            fd_hmacSHA512StringWithKey:key];
}

- (NSString *)fd_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_base64EncodedString];
}

+ (NSString *)fd_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData fd_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)fd_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
            - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
            - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
            - parameter string: The string to be percent-escaped.
            - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)fd_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)fd_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (CGSize)fd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGSize)fd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            paragraphStyle.lineBreakMode = lineBreakMode;
        }
        paragraphStyle.maximumLineHeight = lineHeight;
        paragraphStyle.minimumLineHeight = lineHeight;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;

        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(ceil(result.width), ceil(result.height));
;

}

- (CGFloat)fd_widthForFont:(UIFont *)font {
    CGSize size = [self fd_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)fd_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self fd_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (BOOL)fd_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (void)fd_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)fd_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement; {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

- (char)fd_charValue {
    return self.fd_numberValue.charValue;
}

- (unsigned char)fd_unsignedCharValue {
    return self.fd_numberValue.unsignedCharValue;
}

- (short)fd_shortValue {
    return self.fd_numberValue.shortValue;
}

- (unsigned short)fd_unsignedShortValue {
    return self.fd_numberValue.unsignedShortValue;
}

- (unsigned int)fd_unsignedIntValue {
    return self.fd_numberValue.unsignedIntValue;
}

- (long)fd_longValue {
    return self.fd_numberValue.longValue;
}

- (unsigned long)fd_unsignedLongValue {
    return self.fd_numberValue.unsignedLongValue;
}

- (unsigned long long)fd_unsignedLongLongValue {
    return self.fd_numberValue.unsignedLongLongValue;
}

- (NSUInteger)fd_unsignedIntegerValue {
    return self.fd_numberValue.unsignedIntegerValue;
}


+ (NSString *)fd_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
    return [[NSString alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
    NSString *str = self;
    if (range.location != 0 || range.length != self.length) {
        str = [self substringWithRange:range];
    }
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    if (len == 0 || char32 == NULL) return;
    
    NSUInteger location = 0;
    BOOL stop = NO;
    NSRange subRange;
    UTF32Char oneChar;
    
    for (NSUInteger i = 0; i < len; i++) {
        oneChar = char32[i];
        subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
        block(oneChar, subRange, &stop);
        if (stop) return;
        location += subRange.length;
    }
}

- (NSString *)fd_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)fd_stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)fd_stringByAppendingNameScreenScale {
    return [self fd_stringByAppendingNameScale:[UIScreen fd_screenScale]];
}

- (NSString *)fd_stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}
            
- (NSString *)fd_stringByAppendingPathScreenScale {
    return [self fd_stringByAppendingPathScale:[UIScreen fd_screenScale]];
}

- (CGFloat)fd_pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name fd_enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (BOOL)fd_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)fd_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)fd_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (NSNumber *)fd_numberValue {
    return [NSNumber fd_numberWithString:self];
}

- (NSData *)fd_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)fd_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)fd_jsonValueDecoded {
    return [[self fd_dataValue] fd_jsonValueDecoded];
}

+ (NSString *)fd_stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}

- (NSUInteger)fd_lengthOfComposedCharacterSequencesForLength:(NSUInteger)length {
    NSRange range = [self  rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
    return range.length;
}

- (NSString *)fd_composedCharacterSequencesWithMaxLength:(NSUInteger)maxLength {
    NSUInteger subLength = 0;
    NSUInteger trimLength = maxLength;
    do {
        subLength = [self fd_lengthOfComposedCharacterSequencesForLength:trimLength];
        trimLength = trimLength -1;
    } while (subLength > maxLength);
    NSRange range = NSMakeRange(0, subLength);
    return [self substringWithRange:range];
}

+ (NSString *)fd_timeStamp {
    return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970] * 1000];
}

+ (NSString *)fd_timeStampWithDate:(NSDate *)date {
    return [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970] * 1000];
}

//+ (NSString *)fd_randomWithLength:(NSUInteger)length {
//    NSUInteger powInteger = pow(10, length);
//    NSUInteger num = (arc4random() % powInteger);
//    //    @"%.4d" 不知道怎么用length匹配
//    NSString *randomNumber = [NSString stringWithFormat:@"%.4d", num];
////    NSString *randomNumber = [NSString stringWithFormat:@"%.zd",length , num];
//    return randomNumber;
//}

+ (void)sizOfTypes{
    NSLog(@"sizeof(short):%li",sizeof(short));
    NSLog(@"sizeof(int):%li",sizeof(int));
    NSLog(@"sizeof(float):%li",sizeof(float));
    NSLog(@"sizeof(double):%li",sizeof(double));
    NSLog(@"sizeof(long double):%li",sizeof(long double));
    NSLog(@"sizeof(long):%li",sizeof(long));
    NSLog(@"sizeof(long long):%li",sizeof(long long));
    //2019-10-11 14:57:17.024697+0800 TestImageView[661:633656] sizeof(short):2
    //2019-10-11 14:57:17.024765+0800 TestImageView[661:633656] sizeof(int):4
    //2019-10-11 14:57:17.024789+0800 TestImageView[661:633656] sizeof(float):4
    //2019-10-11 14:57:17.024808+0800 TestImageView[661:633656] sizeof(double):8
    //2019-10-11 14:57:17.024830+0800 TestImageView[661:633656] sizeof(long double):8
    //2019-10-11 14:57:17.024851+0800 TestImageView[661:633656] sizeof(long):8
    //2019-10-11 14:57:17.024871+0800 TestImageView[661:633656] sizeof(long long):8
    
}

@end

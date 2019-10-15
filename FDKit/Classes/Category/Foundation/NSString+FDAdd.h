//
//  NSString+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide hash, encrypt, encode and some common method for 'NSString'.
 */
@interface NSString (FDAdd)

#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (nullable NSString *)fd_md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (nullable NSString *)fd_md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)fd_md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)fd_sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (nullable NSString *)fd_sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)fd_sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (nullable NSString *)fd_sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (nullable NSString *)fd_sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (nullable NSString *)fd_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (nullable NSString *)fd_crc32String;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)fd_base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64EncodedString The encoded string.
 */
+ (nullable NSString *)fd_stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)fd_stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)fd_stringByURLDecode;

/**
 Escape commmon HTML to Entity.
 Example: "a>b" will be escape to "a&gt;b".
 */
- (NSString *)fd_stringByEscapingHTML;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @param font          The font to use for computing the string size.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)fd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;


/**
 Returns the size of the string if it were rendered with the specified constraints.

 @param font The font to use for computing the string size.
 
 @param size The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @param lineHeight lineHeight
 
 @return The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)fd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight;


/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)fd_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)fd_heightForFont:(UIFont *)font width:(CGFloat)width;





#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/**
 Whether it can match the regular expression
 
 @param regex  The regular expression
 @param options     The matching options to report.
 @return YES if can match the regex; otherwise, NO.
 */
- (BOOL)fd_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 Match the regular expression, and executes a given block using each object in the matches.
 
 @param regex    The regular expression
 @param options  The matching options to report.
 @param block    The block to apply to elements in the array of matches.
 The block takes four arguments:
     match: The match substring.
     matchRange: The matching options.
     stop: A reference to a Boolean value. The block can set the value
         to YES to stop further processing of the array. The stop
         argument is an out-only argument. You should only ever set
         this Boolean to YES within the Block.
 */
- (void)fd_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;

/**
 Returns a new string containing matching regular expressions replaced with the template string.
 
 @param regex       The regular expression
 @param options     The matching options to report.
 @param replacement The substitution template used when replacing matching instances.
 
 @return A string with matching regular expressions replaced by the template string.
 */
- (NSString *)fd_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement;


#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

// Now you can use NSString as a NSNumber.
@property (readonly) char fd_charValue;
@property (readonly) unsigned char fd_unsignedCharValue;
@property (readonly) short fd_shortValue;
@property (readonly) unsigned short fd_unsignedShortValue;
@property (readonly) unsigned int fd_unsignedIntValue;
@property (readonly) long fd_longValue;
@property (readonly) unsigned long fd_unsignedLongValue;
@property (readonly) unsigned long long fd_unsignedLongLongValue;
@property (readonly) NSUInteger fd_unsignedIntegerValue;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)fd_stringWithUUID;

/**
 Returns a string containing the characters in a given UTF32Char.
 
 @param char32 A UTF-32 character.
 @return A new string, or nil if the character is invalid.
 */
+ (NSString *)stringWithUTF32Char:(UTF32Char)char32;

/**
 Returns a string containing the characters in a given UTF32Char array.
 
 @param char32 An array of UTF-32 character.
 @param length The character count in array.
 @return A new string, or nil if an error occurs.
 */
+ (NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;

/**
 Enumerates the unicode characters (UTF-32) in the specified range of the string.
 
 @param range The range within the string to enumerate substrings.
 @param block The block executed for the enumeration. The block takes four arguments:
    char32: The unicode character.
    range: The range in receiver. If the range.length is 1, the character is in BMP;
        otherwise (range.length is 2) the character is in none-BMP Plane and stored
        by a surrogate pair in the receiver.
    stop: A reference to a Boolean value that the block can use to stop the enumeration 
        by setting *stop = YES; it should not touch *stop otherwise.
 */
- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)fd_stringByTrim;

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)fd_stringByAppendingNameScale:(CGFloat)scale;

- (NSString *)fd_stringByAppendingNameScreenScale;

/**
 Add scale modifier to the file path (with path extension),
 From @"name.png" to @"name@2x.png".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)fd_stringByAppendingPathScale:(CGFloat)scale;

- (NSString *)fd_stringByAppendingPathScreenScale;
/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)fd_pathScale;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)fd_isNotBlank;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 
 @discussion Apple has implemented this method in iOS8.
 */
- (BOOL)fd_containsString:(NSString *)string;

/**
 Returns YES if the target CharacterSet is contained within the receiver.
 @param set  A character set to test the the receiver.
 */
- (BOOL)fd_containsCharacterSet:(NSCharacterSet *)set;

/**
 Try to parse this string and returns an `NSNumber`.
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)fd_numberValue;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)fd_dataValue;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)fd_rangeOfAll;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)fd_jsonValueDecoded;

/**
 Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 
 @param name The file name (in main bundle).
 
 @return A new string create from the file in UTF-8 character encoding.
 */
+ (NSString *)fd_stringNamed:(NSString *)name;


/**
 Returns the length in the string of the composed character sequences for a given length.


 @param length A length in the receiver. The range must not exceed the bounds of the receiver.

 @return The range.length in the receiver that includes the composed character sequences in range's location is 0 .

 */
- (NSUInteger)fd_lengthOfComposedCharacterSequencesForLength:(NSUInteger)length;


/**
 Returns the composed Character Sequences length < maxLength

 @param maxLength maxLength
 @return the composed Character Sequences length < maxLength
 */
- (NSString *)fd_composedCharacterSequencesWithMaxLength:(NSUInteger)maxLength;

/**
 Returns an TimsStamp string with current time.
 Returns nil if an error occurs.
 
 e.g. NSString:
 */
+ (NSString *)fd_timeStamp;

/**
 Returns an TimsStamp string with date input.
 Returns nil if an error occurs.
 
 e.g. NSString:
 */
+ (NSString *)fd_timeStampWithDate:(NSDate *)date;

//+ (NSString *)fd_randomWithLength:(NSUInteger)length;

//+ (void)sizOfTypes;
@end

NS_ASSUME_NONNULL_END

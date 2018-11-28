//
//  NSDictionary+FDAdd.h
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (FDAdd)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)fd_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)fd_dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)fd_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)fd_plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)fd_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)fd_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)fd_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)fd_entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)fd_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)fd_jsonPrettyStringEncoded;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)fd_dictionaryWithXML:(id)xmlDataOrString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)fd_boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)fd_charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)fd_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)fd_shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)fd_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)fd_intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)fd_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)fd_longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)fd_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)fd_longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)fd_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)fd_floatValueForKey:(NSString *)key default:(float)def;
- (double)fd_doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)fd_integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)fd_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (nullable NSNumber *)fd_numberValueForKey:(NSString *)key default:(nullable NSNumber *)def;
- (nullable NSString *)fd_stringValueForKey:(NSString *)key default:(nullable NSString *)def;

@end



/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (FDAdd)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)fd_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)fd_dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)fd_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)fd_popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END

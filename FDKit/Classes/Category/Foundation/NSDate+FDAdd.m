//
//  NSDate+FDAdd.m
//  FDCategories <https://github.com/toolazytoname/FDCategories>
//
//  Created by ibireme on 13/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSDate+FDAdd.h"
#import "FDCategoriesMacro.h"
#import <time.h>

FDSYNTH_DUMMY_CLASS(NSDate_FDAdd)


@implementation NSDate (FDAdd)

- (NSInteger)fd_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)fd_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)fd_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)fd_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)fd_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)fd_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)fd_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)fd_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)fd_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)fd_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)fd_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)fd_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)fd_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)fd_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)fd_isLeapYear {
    NSUInteger year = self.fd_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)fd_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].fd_day == self.fd_day;
}

- (BOOL)fd_isYesterday {
    NSDate *added = [self fd_dateByAddingDays:1];
    return [added fd_isToday];
}

- (NSDate *)fd_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fd_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fd_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fd_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)fd_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)fd_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)fd_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)fd_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)fd_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)fd_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)fd_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)fd_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)fd_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

@end

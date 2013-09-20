/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

/********************************************************
 Drastic changes made by PeeJWeeJ, but thanks to all the contributors
 *********************************************************/

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

///  Returns a string with the device name and if it's a retina device," Retina" will be added to the string. e.g. @"iPhone 5 Retina"
+ (NSString *) platformString;

/// Returns the hw.model that is returned by the device
+ (NSString *) hwmodel;

/// Evaluates as true if the device uses the phone idiom, for distinguishing between iPhone and iPad idioms. If you want to distinguish between iPhone and iPod, please use [UIDevice isIPod]
+ (BOOL) isPhoneIdiom;

/// Evaluates as true only if the device is an iPOD. Use to distinguish between an iPhone and iPod. if you want to distinguish betwen iPad and iPhone interface idioms, use [UIDevice isPhoneIdiom
+ (BOOL) isIPod;

+ (NSUInteger) cpuFrequency;
+ (NSUInteger) busFrequency;
+ (NSUInteger) totalMemory;
+ (NSUInteger) userMemory;

+ (NSNumber *) totalDiskSpace;
+ (NSNumber *) freeDiskSpace;

+ (NSString *) macaddress;

@end
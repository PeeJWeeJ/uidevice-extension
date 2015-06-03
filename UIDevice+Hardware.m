/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

/********************************************************
 Drastic changes made by Paul Fechner Jr.  Thanks to all the other contributors
 *********************************************************/

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+Hardware.h"

/********************************************************
	Strings returned by the system
 *********************************************************/
#define IFPGA_SYS_STRING				@"iFPGA"

#define IPHONE_PREFIX_SYS_STRING		@"iPhone"
#define IPHONE_1_SYS_STRING				@"iPhone1,1"
#define IPHONE_3G_SYS_STRING            @"iPhone1,2"
#define IPHONE_3GS_SYS_STRING			@"iPhone2"
#define IPHONE_4GSM_SYS_STRING			@"iPhone3,1"
#define IPHONE_4CDMA_SYS_STRING			@"iPhone3,3"
#define IPHONE_4S_SYS_STRING            @"iPhone4"
#define IPHONE_5GSM_SYS_STRING			@"iPhone5,1"
#define IPHONE_5CDMA_SYS_STRING			@"iPhone5,2"
#define IPHONE_5C_USTEC_SYS_STRING		@"iPhone5,3"
#define IPHONE_5C_FRNTEC_SYS_STRING		@"iPhone5,4"
#define IPHONE_5S_USTEC_SYS_STRING		@"iPhone6,1"
#define IPHONE_5S_FRNTEC_SYS_STRING		@"iPhone6,2"
#define IPHONE_6_PLUS_SYS_STRING		@"iPhone7,1"
#define IPHONE_6_SYS_STRING				@"iPhone7,2"

#define IPOD_PREFIX_SYS_STRING			@"iPod"
#define IPOD_1G_SYS_STRING				@"iPod1"
#define IPOD_2G_SYS_STRING				@"iPod2"
#define IPOD_3G_SYS_STRING				@"iPod3"
#define IPOD_4G_SYS_STRING				@"iPod4"
#define IPOD_5G_SYS_STRING				@"iPod5"

#define IPAD_PREFIX_SYS_STRING			@"iPad"
#define IPAD_1_SYS_STRING				@"iPad1"

#define IPAD_2_WIFI_SYS_STRING			@"iPad2,1"
#define IPAD_2_GSM_SYS_STRING			@"iPad2,2"
#define IPAD_2_CDMA_SYS_STRING			@"iPad2,3"
#define IPAD_2_WIFI2_SYS_STRING			@"iPad2,4"

#define IPAD_MINI_WIFI_SYS_STRING		@"iPad2,5"
#define IPAD_MINI_GSM_SYS_STRING		@"iPad2,6"
#define IPAD_MINI_CDMA_SYS_STRING		@"iPad2,7"

#define IPAD_3_WIFI_SYS_STRING			@"iPad3,1"
#define IPAD_3_CDMA_SYS_STRING			@"iPad3,2"
#define IPAD_3_GSM_SYS_STRING			@"iPad3,3"

#define IPAD_4_WIFI_SYS_STRING			@"iPad3,4"
#define IPAD_4_GSM_SYS_STRING			@"iPad3,5"
#define IPAD_4_CDMA_SYS_STRING			@"iPad3,6"

#define IPAD_AIR_WIFI_SYS_STRING		@"iPad4,1"
#define IPAD_AIR_CELL_SYS_STRING		@"iPad4,2"
#define IPAD_AIR_CHINA_SYS_STRING		@"iPad4,3"

#define IPAD_MINI_2_WIFI_SYS_STRING		@"iPad4,4"
#define IPAD_MINI_2_CELL_SYS_STRING		@"iPad4,5"
#define IPAD_MINI_2_CHINA_SYS_STRING	@"iPad4,6"

#define IPAD_AIR_2_WIFI_SYS_STRING		@"iPad5,3"
#define IPAD_AIR_2_CELL_SYS_STRING		@"iPad5,4"

#define IPAD_MINI_3_WIFI_SYS_STRING		@"iPad4,7"
#define IPAD_MINI_3_CELL_SYS_STRING		@"iPad4,8"
#define IPAD_MINI_3_CHINA_SYS_STRING	@"iPad4,9"


#define APPLE_WATCH_PREFIX_SYS_STRING	@"Watch"
#define APPLE_WATCH_38MM_SYS_STRING		@"Watch1,1"
#define APPLE_WATCH_42MM_SYS_STRING		@"Watch1,2"


/********************************************************
 Strings [UIDevice platformString] will return one of these
 *********************************************************/

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5S_NAMESTRING            @"iPhone 5S"
#define IPHONE_5C_NAMESTRING            @"iPhone 5C"
#define IPHONE_6_PLUS_NAMESTRING		@"iPhone 6 Plus"
#define IPHONE_6_NAMESTRING				@"iPhone 6"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_AIR_1G_NAMESTRING			@"iPad Air"
#define IPAD_AIR_2G_NAMESTRING			@"iPad Air 12"
#define IPAD_1G_MINI_NAMESTRING			@"iPad Mini"
#define IPAD_2G_MINI_NAMESTRING			@"iPad Mini (retina) 2 "
#define IPAD_3G_MINI_NAMESTRING			@"iPad Mini (retina) 3 ("
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"


#define APPLE_WATCH_UNKNOWN_NAMESTRING    @"Unknown Apple Watch"
#define APPLE_WATCH_1G_38_NAMESTRING      @"Apple Watch 38mm"
#define APPLE_WATCH_1G_42_NAMESTRING      @"Apple Watch 42mm"


#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"Device Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator"

// Rather than a huge if block or switch statement, This uses a dictionary with all the possible values. It doesn't look pretty, but it's a lot simpler to look at in the code and it should be faster than other options. Also this means the actual code should never need to change. Instead, simply updating the DEVICE_STRINGS_DICTIONARY should add a device. Comments were added in for easier navigation and future additions.

#define DEVICE_STRINGS_DICTIONARY @{/*
	**iPhones-->***/ IFPGA_SYS_STRING: IFPGA_NAMESTRING,/***/IPHONE_1_SYS_STRING: IPHONE_1G_NAMESTRING,/***/IPHONE_3G_SYS_STRING: IPHONE_3G_NAMESTRING,/***/IPHONE_3GS_SYS_STRING: IPHONE_3GS_NAMESTRING,/*
	**iPhone 4-->***/IPHONE_4GSM_SYS_STRING: IPHONE_4_NAMESTRING,/***/IPHONE_4CDMA_SYS_STRING: IPHONE_4_NAMESTRING,/*
	**iPhone 4S-->***/ IPHONE_4S_SYS_STRING: IPHONE_4S_NAMESTRING,/*
	**iPhone 5-->***/IPHONE_5GSM_SYS_STRING: IPHONE_5_NAMESTRING,/***/IPHONE_5CDMA_SYS_STRING: IPHONE_5_NAMESTRING,/*
	**iPhone 5C-->***/IPHONE_5C_USTEC_SYS_STRING: IPHONE_5C_NAMESTRING, /***/IPHONE_5C_FRNTEC_SYS_STRING: IPHONE_5C_NAMESTRING, /*
	**iPhone 5S-->***/ IPHONE_5S_USTEC_SYS_STRING: IPHONE_5S_NAMESTRING,/***/IPHONE_5S_FRNTEC_SYS_STRING: IPHONE_5S_NAMESTRING, /*
	**iPhone 6-->***/ IPHONE_6_PLUS_SYS_STRING: IPHONE_6_PLUS_NAMESTRING,/***/IPHONE_6_SYS_STRING: IPHONE_6_NAMESTRING, /*

	**Apple Watch-->***/ APPLE_WATCH_38MM_SYS_STRING: APPLE_WATCH_1G_38_NAMESTRING,/***/APPLE_WATCH_42MM_SYS_STRING: APPLE_WATCH_1G_42_NAMESTRING, /*

	**iPods-->***/IPOD_1G_SYS_STRING: IPOD_1G_NAMESTRING,/***/IPOD_2G_SYS_STRING: IPOD_2G_NAMESTRING,/***/IPOD_3G_SYS_STRING: IPOD_3G_NAMESTRING,/***/IPOD_4G_SYS_STRING: IPOD_4G_NAMESTRING,/*
	**iPod5-->***/IPOD_5G_SYS_STRING: IPOD_5G_NAMESTRING,/*

	**iPads-->***/IPAD_1_SYS_STRING: IPAD_1G_NAMESTRING,/*
	**iPad2-->***/IPAD_2_WIFI_SYS_STRING: IPAD_2G_NAMESTRING,/***/IPAD_2_GSM_SYS_STRING: IPAD_2G_NAMESTRING,/***/IPAD_2_CDMA_SYS_STRING: IPAD_2G_NAMESTRING,/***/IPAD_2_WIFI2_SYS_STRING: IPAD_2G_NAMESTRING,/*
	**iPadMini-->***/IPAD_MINI_WIFI_SYS_STRING: IPAD_1G_MINI_NAMESTRING,/***/IPAD_MINI_GSM_SYS_STRING: IPAD_1G_MINI_NAMESTRING,/***/IPAD_MINI_CDMA_SYS_STRING: IPAD_1G_MINI_NAMESTRING,/*
	**iPad3-->***/IPAD_3_WIFI_SYS_STRING: IPAD_3G_NAMESTRING,/***/IPAD_3_CDMA_SYS_STRING: IPAD_3G_NAMESTRING,/***/IPAD_3_GSM_SYS_STRING: IPAD_3G_NAMESTRING,/*
	**iPad4-->***/IPAD_4_WIFI_SYS_STRING: IPAD_4G_NAMESTRING,/***/IPAD_4_GSM_SYS_STRING: IPAD_4G_NAMESTRING,/***/IPAD_4_CDMA_SYS_STRING: IPAD_4G_NAMESTRING,/*
	**iPad3-->***/IPAD_AIR_WIFI_SYS_STRING: IPAD_AIR_1G_NAMESTRING,/***/IPAD_AIR_CELL_SYS_STRING: IPAD_AIR_1G_NAMESTRING,/***/IPAD_AIR_CHINA_SYS_STRING: IPAD_AIR_1G_NAMESTRING,/*
	**iPad3-->***/IPAD_MINI_2_WIFI_SYS_STRING: IPAD_2G_MINI_NAMESTRING,/***/IPAD_MINI_2_CELL_SYS_STRING: IPAD_2G_MINI_NAMESTRING,/***/IPAD_MINI_2_CHINA_SYS_STRING: IPAD_2G_MINI_NAMESTRING,/*
	**iPad3-->***/IPAD_AIR_2_WIFI_SYS_STRING: IPAD_AIR_2G_NAMESTRING,/***/IPAD_AIR_2_CELL_SYS_STRING: IPAD_AIR_2G_NAMESTRING,/*
	**iPad3-->***/IPAD_MINI_3_WIFI_SYS_STRING: IPAD_3G_MINI_NAMESTRING,/***/IPAD_MINI_3_CELL_SYS_STRING: IPAD_3G_MINI_NAMESTRING,/***/IPAD_MINI_3_CHINA_SYS_STRING: IPAD_3G_MINI_NAMESTRING};


@implementation UIDevice (Hardware)

#pragma mark platform type and name utils

/********************************************************
 Returns a string with the device name and if it's a retina device," Retina" will be added to the string.
 e.g. @"iPhone 5" or @"iPhone 5 Retina"
 *********************************************************/
+ (NSString *) platformString
{
	NSString *hwString = [self getSysInfoByName:"hw.machine"];
	NSString *platform;
	
	NSDictionary *newDictionary = DEVICE_STRINGS_DICTIONARY;
	platform = [newDictionary objectForKey:hwString];
	
	if(!platform){
		if ([hwString hasPrefix:IPHONE_PREFIX_SYS_STRING])	platform = IPHONE_UNKNOWN_NAMESTRING;
		else if ([hwString hasPrefix:IPOD_PREFIX_SYS_STRING])	platform = IPOD_UNKNOWN_NAMESTRING;
		else if ([hwString hasPrefix:IPAD_PREFIX_SYS_STRING])	platform = IPAD_UNKNOWN_NAMESTRING;
		else if ([hwString hasPrefix:APPLE_WATCH_PREFIX_SYS_STRING])	platform = APPLE_WATCH_UNKNOWN_NAMESTRING;
		
	// Apple TV ***I may drop this in the future, I'm not sure whether it's really necessary, that's why it's not in the DEVICE_STRINGS_DICTIONARY***
		else if ([hwString hasPrefix:@"AppleTV"]){
			if ([hwString hasPrefix:@"AppleTV2"])           platform = APPLETV_2G_NAMESTRING;
			else if ([hwString hasPrefix:@"AppleTV3"])      platform = APPLETV_3G_NAMESTRING;
			else if	([hwString hasPrefix:@"AppleTV34"])  	platform = APPLETV_4G_NAMESTRING;
			else											platform = SIMULATOR_APPLETV_NAMESTRING;
		}
		
		// Simulator
		else if ([hwString hasSuffix:@"86"] || [hwString isEqual:@"x86_64"]){
			platform = ([UIDevice isPhoneIdiom])? SIMULATOR_IPHONE_NAMESTRING : SIMULATOR_IPAD_NAMESTRING;
		}
		else platform = IOS_FAMILY_UNKNOWN_DEVICE;
	}
	
	if(([UIScreen mainScreen].scale == 2.0f)){
		platform = [NSString stringWithFormat:@"%@ Retina", platform];
	}
	
	return platform;
}

// returns true if it's uses the phone idiom
+ (BOOL) isPhoneIdiom
{
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)? YES : NO;
}

// returns true only if it's an iPod
+ (BOOL) isIPod;

{
	NSString *hwString = [self getSysInfoByName:"hw.machine"];
	
	return ([hwString hasPrefix:IPOD_PREFIX_SYS_STRING])? YES : NO;
}

#pragma mark sysctlbyname utils
+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = @(answer);

    free(answer);
    return results;
}

+ (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}

// Thanks, Tom Harrington (Atomicbird)
+ (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!
+ (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return fattributes[NSFileSystemSize];
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return fattributes[NSFileSystemFreeSize];
}

@end
/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

/********************************************************
 Drastic changes made by PeeJWeeJ, but thanks to all the contributers listed above and below
 *********************************************************/

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice-Hardware.h"

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
#define IPHONE_5S_SYS_STRING            @"iPhone??"
#define IPHONE_5C_SYS_STRING            @"iPhone??"


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




/********************************************************
 Strings [UIDevice platformString] will return
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
#define IPAD_1G_MINI_NAMESTRING			@"iPad Mini"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"Device Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator"

// rather than a huge if block or switch statement, I changed it to a dictinary with all the possible values. this doesn't look pretty, but it's a lot simpler to look at in the code
// as it's a dictionary, it doesn't matter where a new device is added, so in future just make sure it's documented in the comments below
#define STRINGS_DICTIONARY @{IFPGA_SYS_STRING: IFPGA_NAMESTRING,IPHONE_1_SYS_STRING: IPHONE_1G_NAMESTRING,IPHONE_3G_SYS_STRING: IPHONE_3G_NAMESTRING,IPHONE_3GS_SYS_STRING: IPHONE_3GS_NAMESTRING,IPHONE_4GSM_SYS_STRING: IPHONE_4_NAMESTRING,IPHONE_4CDMA_SYS_STRING: IPHONE_4_NAMESTRING,IPHONE_4S_SYS_STRING: IPHONE_4S_NAMESTRING,IPHONE_5GSM_SYS_STRING: IPHONE_5_NAMESTRING,IPHONE_5CDMA_SYS_STRING: IPHONE_5_NAMESTRING,IPHONE_5S_SYS_STRING: IPHONE_5S_NAMESTRING,IPHONE_5C_SYS_STRING: IPHONE_5C_NAMESTRING,IPOD_1G_SYS_STRING: IPOD_1G_NAMESTRING,IPOD_2G_SYS_STRING: IPOD_2G_NAMESTRING,IPOD_3G_SYS_STRING: IPOD_3G_NAMESTRING,IPOD_4G_SYS_STRING: IPOD_4G_NAMESTRING,IPOD_5G_SYS_STRING: IPOD_5G_NAMESTRING,IPAD_1_SYS_STRING: IPAD_1G_NAMESTRING,IPAD_2_WIFI_SYS_STRING: IPAD_2G_NAMESTRING,IPAD_2_GSM_SYS_STRING: IPAD_2G_NAMESTRING,IPAD_2_CDMA_SYS_STRING: IPAD_2G_NAMESTRING,IPAD_2_WIFI2_SYS_STRING: IPAD_2G_NAMESTRING,IPAD_MINI_WIFI_SYS_STRING: IPAD_1G_MINI_NAMESTRING,IPAD_MINI_GSM_SYS_STRING: IPAD_1G_MINI_NAMESTRING,IPAD_MINI_CDMA_SYS_STRING: IPAD_1G_MINI_NAMESTRING,IPAD_3_WIFI_SYS_STRING: IPAD_3G_NAMESTRING,IPAD_3_CDMA_SYS_STRING: IPAD_3G_NAMESTRING,IPAD_3_GSM_SYS_STRING: IPAD_3G_NAMESTRING,IPAD_4_WIFI_SYS_STRING: IPAD_4G_NAMESTRING,IPAD_4_GSM_SYS_STRING: IPAD_4G_NAMESTRING,IPAD_4_CDMA_SYS_STRING: IPAD_4G_NAMESTRING};

/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 More organized view of the info above. Please add to both
 
STRINGS_DICTIONARY @{
 IFPGA_SYS_STRING: IFPGA_NAMESTRING,				IPHONE_1_SYS_STRING: IPHONE_1G_NAMESTRING,
 IPHONE_3G_SYS_STRING: IPHONE_3G_NAMESTRING,		IPHONE_3GS_SYS_STRING: IPHONE_3GS_NAMESTRING,
 IPHONE_4GSM_SYS_STRING: IPHONE_4_NAMESTRING,		IPHONE_4CDMA_SYS_STRING: IPHONE_4_NAMESTRING,
 IPHONE_4S_SYS_STRING: IPHONE_4S_NAMESTRING,		IPHONE_5GSM_SYS_STRING: IPHONE_5_NAMESTRING,
 IPHONE_5CDMA_SYS_STRING: IPHONE_5_NAMESTRING,		IPHONE_5S_SYS_STRING: IPHONE_5S_NAMESTRING,
 IPHONE_5C_SYS_STRING: IPHONE_5C_NAMESTRING,		IPOD_1G_SYS_STRING: IPOD_1G_NAMESTRING,
 IPOD_2G_SYS_STRING: IPOD_2G_NAMESTRING,			IPOD_3G_SYS_STRING: IPOD_3G_NAMESTRING,
 IPOD_4G_SYS_STRING: IPOD_4G_NAMESTRING,			IPOD_5G_SYS_STRING: IPOD_5G_NAMESTRING,
 IPAD_1_SYS_STRING: IPAD_1G_NAMESTRING,				IPAD_2_WIFI_SYS_STRING: IPAD_2G_NAMESTRING,
 IPAD_2_GSM_SYS_STRING: IPAD_2G_NAMESTRING,			IPAD_2_CDMA_SYS_STRING: IPAD_2G_NAMESTRING,
 IPAD_2_WIFI2_SYS_STRING: IPAD_2G_NAMESTRING,		IPAD_MINI_WIFI_SYS_STRING: IPAD_1G_MINI_NAMESTRING,
 IPAD_MINI_GSM_SYS_STRING: IPAD_1G_MINI_NAMESTRING,	IPAD_MINI_CDMA_SYS_STRING: IPAD_1G_MINI_NAMESTRING,
 IPAD_3_WIFI_SYS_STRING: IPAD_3G_NAMESTRING,		IPAD_3_CDMA_SYS_STRING: IPAD_3G_NAMESTRING,
 IPAD_3_GSM_SYS_STRING: IPAD_3G_NAMESTRING,			IPAD_4_WIFI_SYS_STRING: IPAD_4G_NAMESTRING,
 IPAD_4_GSM_SYS_STRING: IPAD_4G_NAMESTRING,			IPAD_4_CDMA_SYS_STRING: IPAD_4G_NAMESTRING};
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 */
@implementation UIDevice (Hardware)

#pragma mark platform type and name utils

/********************************************************
 Returns a string with the device name and if it's a retina device," Retina" will be added to the string.
 e.g. @"iPhone 5 Retina"
 *********************************************************/
+ (NSString *) platformString
{
	NSString *hwString = [self getSysInfoByName:"hw.machine"];
	NSString *platform;
	
	NSDictionary *newDictionary = STRINGS_DICTIONARY;
	platform = [newDictionary objectForKey:hwString];
	
	if(!platform){
		if ([hwString hasPrefix:IPHONE_PREFIX_SYS_STRING])	platform = IPHONE_UNKNOWN_NAMESTRING;
		else if ([hwString hasPrefix:IPOD_PREFIX_SYS_STRING])	platform = IPOD_UNKNOWN_NAMESTRING;
		else if ([hwString hasPrefix:IPAD_PREFIX_SYS_STRING])	platform = IPAD_UNKNOWN_NAMESTRING;
		
		
		
		// Apple TV
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

// returns true if it's an Phone
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

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}


@end
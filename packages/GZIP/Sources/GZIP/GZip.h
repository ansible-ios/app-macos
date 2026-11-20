#ifndef Telegram_GZip_h
#define Telegram_GZip_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    NSData * _Nullable AnsibleGZipData(NSData * __nonnull data, float level);
    NSData * _Nullable AnsibleGUnzipData(NSData * __nullable data, uint sizeLimit);
    
#ifdef __cplusplus
}
#endif

#endif

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>


typedef enum
{
    AnsibleMediaVideoConversionPresetCompressedDefault,
    AnsibleMediaVideoConversionPresetCompressedVeryLow,
    AnsibleMediaVideoConversionPresetCompressedLow,
    AnsibleMediaVideoConversionPresetCompressedMedium,
    AnsibleMediaVideoConversionPresetCompressedHigh,
    AnsibleMediaVideoConversionPresetCompressedVeryHigh,
    AnsibleMediaVideoConversionPresetAnimation,
    AnsibleMediaVideoConversionPresetVideoMessage
} AnsibleMediaVideoConversionPreset;



@interface AnsibleMediaVideoConversionPresetSettings : NSObject

+ (CGSize)maximumSizeForPreset:(AnsibleMediaVideoConversionPreset)preset;
+ (NSDictionary *)videoSettingsForPreset:(AnsibleMediaVideoConversionPreset)preset dimensions:(CGSize)dimensions bitrate:(int)bitrate;
+ (NSDictionary *)audioSettingsForPreset:(AnsibleMediaVideoConversionPreset)preset bitrate:(int)bitrate;

@end

@protocol AnsibleVideoCameraMovieRecorderDelegate;

@interface AnsibleVideoCameraMovieRecorder : NSObject

@property (nonatomic, assign) bool paused;

- (instancetype)initWithURL:(NSURL *)URL delegate:(id<AnsibleVideoCameraMovieRecorderDelegate>)delegate callbackQueue:(dispatch_queue_t)queue;

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription transform:(CGAffineTransform)transform settings:(NSDictionary *)videoSettings;
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;


- (void)prepareToRecord;

- (void)appendVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime;
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)finishRecording;

- (NSTimeInterval)videoDuration;

@end

@protocol AnsibleVideoCameraMovieRecorderDelegate <NSObject>
@required
- (void)movieRecorderDidFinishPreparing:(AnsibleVideoCameraMovieRecorder *)recorder;
- (void)movieRecorder:(AnsibleVideoCameraMovieRecorder *)recorder didFailWithError:(NSError *)error;
- (void)movieRecorderDidFinishRecording:(AnsibleVideoCameraMovieRecorder *)recorder;
@end

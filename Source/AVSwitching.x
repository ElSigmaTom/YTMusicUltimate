#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

static BOOL YTMU(NSString *key) {
    NSDictionary *YTMUltimateDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
    return [YTMUltimateDict[key] boolValue];
}

static int YTMUint(NSString *key) {
    NSDictionary *YTMUltimateDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"];
    return [YTMUltimateDict[key] integerValue];
}

// Remove popup reminder 
%hook YTMPlayerHeaderViewController
- (BOOL)shouldDisplayHintForAudioVideoSwitch {
	return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig;
}
%end

%hook YTIPlayerResponse
- (id)ytm_audioOnlyUpsell {
    return YTMU(@"YTMUltimateIsEnabled") ? nil : %orig;
}

- (BOOL)ytm_isAudioOnlyPlayable {
    return YTMU(@"YTMUltimateIsEnabled") ? YES : %orig;
}

- (BOOL)isAudioOnlyAvailabilityBlocked {
    return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig;
}

- (void)setIsAudioOnlyAvailabilityBlocked:(BOOL)blocked{
    YTMU(@"YTMUltimateIsEnabled") ? %orig(NO) : %orig;
}

- (void)setYtm_isAudioOnlyPlayable:(BOOL)playable{
    YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig;
}
%end

%hook YTMAudioVideoModeController
- (BOOL)isAudioOnlyBlocked {
    return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig;
}

- (void)setIsAudioOnlyBlocked:(BOOL)blocked {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(NO) : %orig;
}

- (void)setSwitchAvailability:(NSInteger)arg1 {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(1) : %orig;
}
%end

%hook YTMQueueConfig
- (BOOL)isAudioVideoModeSupported {
    return YTMU(@"YTMUltimateIsEnabled") ? YES : %orig;
}

- (void)setIsAudioVideoModeSupported:(BOOL)supported {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig;
}

/*
- (BOOL)noVideoModeEnabled {
    return YES;
}

- (void)setNoVideoModeEnabled:(BOOL)enabled {
    %orig(YES);
}
*/
%end

%hook YTMAudioVideoModeControllerInternalImpl
- (void)setSwitchAvailability:(NSInteger)arg1 { YTMU(@"YTMUltimateIsEnabled") ? %orig(1) : %orig; }
- (NSInteger)switchAvailability { return YTMU(@"YTMUltimateIsEnabled") ? 1 : %orig; }
- (BOOL)isAudioOnlyBlocked { return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig; }
%end

%hook YTVideoQualitySwitchRedesignedController
- (void)setAllowAudioOnlyManualQualitySelection:(BOOL)arg1 { YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig; }
- (BOOL)allowAudioOnlyManualQualitySelection { return YTMU(@"YTMUltimateIsEnabled") ?: %orig; }
%end

%hook YTVideoQualitySwitchOriginalController
- (void)setAllowAudioOnlyManualQualitySelection:(BOOL)arg1 { YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig; }
- (BOOL)allowAudioOnlyManualQualitySelection { return YTMU(@"YTMUltimateIsEnabled") ?: %orig; }
%end

%hook YTDefaultQueueConfig
- (BOOL)isAudioVideoModeSupportedForNonPodcasts {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}

- (BOOL)isAudioVideoModeSupported {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}

- (void)setIsAudioVideoModeSupported:(BOOL)supported {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig;
}
%end

%hook YTMSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}
%end

%hook YTMSettingsImpl
- (BOOL)allowAudioOnlyManualQualitySelection {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}
%end

%hook YTIAudioOnlyPlayabilityRenderer
- (BOOL)audioOnlyPlayability {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}

- (int)audioOnlyAvailability {
    return YTMU(@"YTMUltimateIsEnabled") ? 1 : %orig;
}

- (void)setAudioOnlyPlayability:(BOOL)playability {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig;
}

- (id)infoRenderer {
    return YTMU(@"YTMUltimateIsEnabled") ? nil : %orig;
}

- (BOOL)hasInfoRenderer {
    return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig;
}
%end

%hook YTIAudioOnlyPlayabilityRenderer_AudioOnlyPlayabilityInfoSupportedRenderers
- (id)upsellDialogRenderer {
    return YTMU(@"YTMUltimateIsEnabled") ? nil : %orig;
}

- (void)setUpsellDialogRenderer:(id)renderer {
    if (!YTMU(@"YTMUltimateIsEnabled")) return %orig;
}
%end

%hook YTQueueItem
- (BOOL)supportsAudioVideoSwitching {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}

- (void)setSupportsAudioVideoSwitching:(BOOL)arg1 {
    YTMU(@"YTMUltimateIsEnabled") ? %orig(YES) : %orig;
}
%end

%hook YTMMusicAppMetadata
- (BOOL)isAudioOnlyButtonVisible {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}
%end

%hook YTMMusicAppMetadataImpl
- (BOOL)isAudioOnlyButtonVisible {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}
%end

%hook YTMQueueConfig
- (BOOL)noVideoModeEnabledForMusic {
	return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}

- (BOOL)noVideoModeEnabledForPodcasts {
	return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
%end

%hook YTMQueueConfigImpl
- (BOOL)isAudioVideoModeSupportedForNonPodcasts {
    return YTMU(@"YTMUltimateIsEnabled") ?: %orig;
}

- (BOOL)noVideoModeEnabledForMusic {
	return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}

- (BOOL)noVideoModeEnabledForPodcasts {
	return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
%end

%hook YTQueueController
- (BOOL)noVideoModeEnabled:(id)arg1 {
	return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (BOOL)isAudioVideoModeSupportedForVideo:(id)video { return YTMU(@"YTMUltimateIsEnabled") ?: %orig; }
%end

%hook YTColdConfig
- (BOOL)iosEnableHighQualityAudioAppSettingsPremiumUpsell { 
    return YTMU(@"YTMUltimateIsEnabled") ? NO : %orig;
}
%end

// Force audio-only ("song", not music video) when the AV default mode is Audio
// (audioVideoMode == 0, the default). Closes the gaps the queue hooks above miss:
// YTDefaultQueueConfig is consulted by some queue-build paths but was never hooked
// for no-video-mode, and the global/persisted no-video-mode setting was never forced.
// All gated on `== 0 ? ... : %orig` so choosing Video (segment 1) still plays video.

%hook YTDefaultQueueConfig
- (BOOL)noVideoModeEnabledForMusic {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (BOOL)noVideoModeEnabledForPodcasts {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
%end

%hook YTMSettings
- (BOOL)initialFormatAudioOnly {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (BOOL)noVideoModeEnabled {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (void)setNoVideoModeEnabled:(BOOL)enabled {
    YTMUint(@"audioVideoMode") == 0 ? %orig(YES) : %orig;
}
%end

%hook YTMSettingsImpl
- (BOOL)initialFormatAudioOnly {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (BOOL)noVideoModeEnabled {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (void)setNoVideoModeEnabled:(BOOL)enabled {
    YTMUint(@"audioVideoMode") == 0 ? %orig(YES) : %orig;
}
%end

%hook YTUserDefaults
- (BOOL)noVideoModeEnabled {
    return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
}
- (void)setNoVideoModeEnabled:(BOOL)enabled {
    YTMUint(@"audioVideoMode") == 0 ? %orig(YES) : %orig;
}
%end

// Escalation (opt-in): forcing audio at the format-REQUEST layer. Most aggressive
// lever — it can turn a video-only track into a playback FAILURE when no audio-only
// stream exists, which is likely why upstream left it disabled. Uncomment and
// device-test ONLY if music videos still leak through with the hooks above.
// %hook YTIAudioConfig
// - (BOOL)hasPlayAudioOnly {
//     return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
// }
// - (BOOL)playAudioOnly {
//     return YTMUint(@"audioVideoMode") == 0 ? YES : %orig;
// }
// %end

%ctor {
    NSMutableDictionary *YTMUltimateDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YTMUltimate"]];
    NSArray *intKeys = @[@"audioVideoMode"];
    for (NSString *key in intKeys) {
        if (!YTMUltimateDict[key]) {
            [YTMUltimateDict setObject:@(0) forKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:YTMUltimateDict forKey:@"YTMUltimate"];
        }
    }
}

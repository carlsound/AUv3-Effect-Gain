//
//  AUv3_Effect_Gain_macOS_ExtensionAudioUnit.h
//  AUv3-Effect-Gain-macOS-Extension
//
//
// AUv3 example code: https://github.com/invalidstream/ring-modulator-v3audiounit
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AUAudioUnit.h>
#import <AudioUnit/AUAudioUnit.h>
#import <AVFoundation/AVFoundation.h>

// Define parameter addresses.
/*extern */ const AUParameterAddress gainParameterAddress = 0; // https://developer.apple.com/documentation/audiotoolbox/auparameteraddress?language=objc

@interface AUv3_Effect_Gain_macOS_ExtensionAudioUnit : AUAudioUnit // https://developer.apple.com/documentation/audiotoolbox/auaudiounit?language=objc

@end

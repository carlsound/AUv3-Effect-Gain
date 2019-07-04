//
//  AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit.h
//  AUV3-Effect-Gain-macOS-Extension-ObjC-2
//
//  Created by John Carlson on 7/4/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////

// Define parameter addresses.
//extern const AudioUnitParameterID myParam1;
extern const AUParameterAddress GAIN_PARAMETER_ADDRESS;

///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit : AUAudioUnit

@end

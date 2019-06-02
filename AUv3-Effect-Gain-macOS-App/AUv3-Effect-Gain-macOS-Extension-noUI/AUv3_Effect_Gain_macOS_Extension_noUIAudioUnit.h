//
//  AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit.h
//  AUv3-Effect-Gain-macOS-Extension-noUI
//
//  Created by John Carlson on 6/2/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AUAudioUnit.h>
#import <AVFoundation/AVFoundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////


// Define parameter addresses.
extern const AudioUnitParameterID _GAIN_PARAMETER_ID;


///////////////////////////////////////////////////////////////////////////////////////////////////////



@interface AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit : AUAudioUnit

//-(AudioUnitParameterID)getGainParamterID;

@end

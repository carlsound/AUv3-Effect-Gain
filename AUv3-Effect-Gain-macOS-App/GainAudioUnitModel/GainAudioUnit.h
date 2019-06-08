//
//  GainAudioUnit.h
//  GainAudioUnitModel
//
//  Created by John Carlson on 6/8/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AUAudioUnit.h>
#import <AVFoundation/AVFoundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////

// Define parameter addresses.
extern const AUParameterAddress GAIN_PARAMETER_ADDRESS;

///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface GainAudioUnit : AUAudioUnit

@end

//
//  AudioUnitViewController.m
//  AUV3-Effect-Gain-macOS-Extension-ObjC-2
//
//  Created by John Carlson on 7/4/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AudioUnitViewController.h"
#import "AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit.h"

@interface AudioUnitViewController ()

@end

@implementation AudioUnitViewController {
    
    AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit* audioUnit;
    //AUAudioUnit *audioUnit;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!audioUnit) {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
}

- (AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError **)error {
    audioUnit = [[AUV3_Effect_Gain_macOS_Extension_ObjC_2AudioUnit alloc] initWithComponentDescription:desc error:error];
    
    return audioUnit;
}

@end

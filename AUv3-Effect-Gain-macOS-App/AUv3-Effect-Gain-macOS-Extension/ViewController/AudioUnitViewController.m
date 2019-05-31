//
//  AudioUnitViewController.m
//  AUv3-Effect-Gain-macOS-Extension
//
//  Created by John Carlson on 4/30/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AudioUnitViewController.h"
#import "AUv3_Effect_Gain_macOS_ExtensionAudioUnit.h"

@interface AudioUnitViewController ()

@end

//////////////////////////////////////////////////////////

@implementation AudioUnitViewController {
    //AUAudioUnit *audioUnit;
    AUv3_Effect_Gain_macOS_ExtensionAudioUnit* audioUnit;
}


//@synthesize audioUnit;

AUParameter* _gainParameter;



- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!audioUnit) {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
}



- (void)beginRequestWithExtensionContext:(nonnull NSExtensionContext *)context {
    
    [super beginRequestWithExtensionContext:context];
}



- (nullable AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    
    audioUnit = [audioUnit initWithComponentDescription:desc options:kAudioComponentInstantiation_LoadOutOfProcess error:error];
    
    _gainParameter = [audioUnit.parameterTree parameterWithAddress:[audioUnit getGainParamterAddress]];
    
    gainSlider.integerValue = [_gainParameter value];
    
    return audioUnit;
}



/*
- (BOOL)commitEditingAndReturnError:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return TRUE;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    //
}
 */



-(IBAction)gainSliderChanged:(NSSlider*)sender{
    
    [_gainParameter setValue: (int) sender.integerValue];
}

@end

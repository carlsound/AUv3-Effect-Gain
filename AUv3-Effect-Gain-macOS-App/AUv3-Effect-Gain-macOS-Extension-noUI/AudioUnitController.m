//
//  AudioUnitController.m
//  AUv3-Effect-Gain-macOS-Extension-noUI
//
//  Created by John Carlson on 6/2/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AudioUnitController.h"
#import "AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit.h"

@implementation AudioUnitController{
    
    AUAudioUnit *audioUnit;
}

#pragma mark- @protocol AUAudioUnitFactory
- (AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc
                                                   error:(NSError **)error {
    
    audioUnit = [[AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit alloc] initWithComponentDescription:desc error:error];
    
    return audioUnit;
}



#pragma mark- @protocol NSExtensionRequestHandling; inherited by AUAudioUnitFactory
-(void) beginRequestWithExtensionContext: (nonnull NSExtensionContext *) context {
    
    //[super beginRequestWithExtensionContext: context];
}

@end
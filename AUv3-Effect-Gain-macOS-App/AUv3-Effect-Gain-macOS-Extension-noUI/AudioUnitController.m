//
//  AudioUnitController.m
//  AUv3-Effect-Gain-macOS-Extension-noUI
//
//  Created by John Carlson on 6/2/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AudioUnitController.h"
//#import "AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit.h"
#import "GainAudioUnit.h"

@implementation AudioUnitController{
    
    GainAudioUnit* audioUnit;
}

#pragma mark- @protocol AUAudioUnitFactory
- (GainAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc
                                                   error:(NSError **)error {
    
    audioUnit = [[GainAudioUnit alloc] initWithComponentDescription: desc
                                                            options: kAudioComponentInstantiation_LoadOutOfProcess
                                                              error: error];
    
    return audioUnit;
}



#pragma mark- @protocol AUAudioUnitFactory
- (void) requestViewControllerWithCompletionHandler: (void (^)(AUViewControllerBase *viewController)) completionHandler {
    
    completionHandler(nil);
}



#pragma mark- @protocol NSExtensionRequestHandling; inherited by AUAudioUnitFactory
- (void)beginRequestWithExtensionContext:(nonnull NSExtensionContext *)context {
    
    //NSArray* inputItems = context.inputItems; // https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html#//apple_ref/doc/uid/TP40014214-CH5-SW1
    
    [super beginRequestWithExtensionContext: context];
}

@end

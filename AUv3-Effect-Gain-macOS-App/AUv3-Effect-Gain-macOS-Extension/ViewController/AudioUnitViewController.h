//
//  AudioUnitViewController.h
//  AUv3-Effect-Gain-macOS-Extension
//
//  Created by John Carlson on 4/30/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudioKit/CoreAudioKit.h>
//#import "ParameterAddresses.h"
#import "AUv3_Effect_Gain_macOS_ExtensionAudioUnit.h"

@interface AudioUnitViewController : AUViewController <AUAudioUnitFactory>{
    // https://developer.apple.com/documentation/coreaudiokit/auviewcontroller?language=objc
    //
    
    IBOutlet NSSlider* gainSlider;
}

//@property AUv3_Effect_Gain_macOS_ExtensionAudioUnit* audioUnit;

-(void) viewDidLoad;

-(IBAction)gainSliderChanged:(NSSlider*)sender;

@end

//
//  AudioUnitViewController.h
//  AUv3-Effect-Gain-macOS-Extension
//
//  Created by John Carlson on 4/30/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <CoreAudioKit/AUViewController.h>
//#import "ParameterAddresses.h"
//#import "AUv3_Effect_Gain_macOS_ExtensionAudioUnit.h"
#import "GainAudioUnit.h"

@interface AudioUnitViewController : AUViewController <AUAudioUnitFactory>{
    // https://developer.apple.com/documentation/coreaudiokit/auviewcontroller?language=objc
    //
    
    IBOutlet NSSlider* gainSlider;
}

@property (nonnull)GainAudioUnit* audioUnit;

-(void) viewDidLoad;

-(void) dealloc;

//-(nonnull AUv3_Effect_Gain_macOS_ExtensionAudioUnit *) getAudioUnit;

//-(void) setAudioUnit: (nonnull AUv3_Effect_Gain_macOS_ExtensionAudioUnit *) audioUnit;


#pragma mark- KVO
/*
-(void) observeValueForKeyPath: (nullable NSString *) keyPath
                      ofObject: (nullable id) object
                        change: (nullable NSDictionary<NSString *, id> *) change
                       context: (nullable void *) context;
 */


#pragma mark- @protocol NSExtensionRequestHandling; inherited by AUAudioUnitFactory
-(void) beginRequestWithExtensionContext: (nonnull NSExtensionContext *) context;

#pragma mark- @protocol AUAudioUnitFactory
/*
-(nullable AUAudioUnit *) createAudioUnitWithComponentDescription:(AudioComponentDescription) desc
                                                            error:(NSError * _Nullable * _Nullable) error;
 */

-(void) requestViewControllerWithCompletionHandler: (void (^_Nullable)(AUViewControllerBase* _Nullable viewController)) completionHandler;


#pragma mark: Actions
-(IBAction) gainSliderChanged: (nonnull NSSlider*) sender;

@end

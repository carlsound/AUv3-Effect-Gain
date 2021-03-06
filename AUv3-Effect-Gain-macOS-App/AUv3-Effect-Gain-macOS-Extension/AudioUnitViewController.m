//
//  AudioUnitViewController.m
//  AUv3-Effect-Gain-macOS-Extension
//
//  Created by John Carlson on 4/30/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AudioUnitViewController.h"
//#import "AUv3_Effect_Gain_macOS_ExtensionAudioUnit.h"
#import "GainAudioUnit.h"

@interface AudioUnitViewController (){

}

//-(void)connectViewWithAU;
//-(void)disconnectViewWithAU;

@end

//////////////////////////////////////////////////////////

@implementation AudioUnitViewController {
    
    AUAudioUnit *audioUnit;
    AUParameter* _gainParameter;
    AUParameterObserverToken _parameterObserverToken;
    
    __weak IBOutlet NSSlider *_gainSlider;
}



#pragma mark- viewDidLoad
- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    if(!audioUnit) {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    [self connectViewWithAU];
}


- (void) dealloc {
    
    [self disconnectViewWithAU];
}



#pragma mark- getter
/*
- (GainAudioUnit *) getAudioUnit {
    
    return audioUnit;
}
 */

#pragma mark- setter
/*
- (void)setAudioUnit:(GainAudioUnit *) audioUnit {
    
    self.audioUnit = audioUnit;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            [self connectViewWithAU];
        }
    });
}
 */




#pragma mark- KVO

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString *, id> *)change
                       context:(nullable void *)context
{
    NSLog(@"AudioUnitViewControler allParameterValues key path changed: %s\n", keyPath.UTF8String);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //filterView.frequency = cutoffParameter.value;
        //filterView.resonance = resonanceParameter.value;
        
        //[self updateFilterViewFrequencyAndMagnitudes];
    });
}





#pragma mark-
-(void) connectViewWithAU {
    
    // @protocol AUAudioUnitFactory
    /*
    [self requestViewControllerWithCompletionHandler: ^(AUViewControllerBase* _Nullable viewController){
        viewController = self;
    }];
     */
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the Audio Unit
    
    if (audioUnit.parameterTree) {
        
        //_gainParameter = [paramTree valueForKey: @"gainParameter"];
        _gainParameter = [audioUnit.parameterTree parameterWithAddress: GAIN_PARAMETER_ADDRESS];
        
        gainSlider.integerValue = [_gainParameter value];
        
        [audioUnit addObserver: self forKeyPath: @"allParameterValues"
                        options: NSKeyValueObservingOptionNew
                        context: _parameterObserverToken];
    } else {
        NSLog(@"paramTree is NULL!\n");
    }
}




#pragma mark-
-(void) disconnectViewWithAU {
    if (_parameterObserverToken) {
        [audioUnit.parameterTree removeParameterObserver: _parameterObserverToken];
        [audioUnit removeObserver: self forKeyPath: @"allParameterValues" context: _parameterObserverToken];
        _parameterObserverToken = 0;
    }
}


#pragma mark- @protocol NSExtensionRequestHandling; inherited by AUAudioUnitFactory
-(void) beginRequestWithExtensionContext: (nonnull NSExtensionContext *) context {
    
    [super beginRequestWithExtensionContext: context];
}


#pragma mark- @protocol AUAudioUnitFactory
-(AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription) desc
                                                   error:(NSError * _Nullable * _Nullable) error{
    
    audioUnit = [[GainAudioUnit alloc] initWithComponentDescription: desc
                                                            options: kAudioComponentInstantiation_LoadOutOfProcess
                                                              error: error];
    if(self.isViewLoaded){
        [self connectViewWithAU];
    }
    
    return audioUnit;
}

#pragma mark- @protocol AUAudioUnitFactory

- (void)requestViewControllerWithCompletionHandler:(void (^)(AUViewControllerBase *viewController))completionHandler{
    
    //NSBundle* bndle = [NSBundle bundleWithIdentifier: @"net.carlsound.AUv3-Effect-Gain-macOS-App.AUv3-Effect-Gain-macOS-Extension"];
    
    AUViewControllerBase* viewController = [self initWithNibName:@"AudioUnitViewController"
                                                          bundle: nil];
    //[self loadView];
    completionHandler(viewController);
    //completionHandler(nil);
}


/*
- (BOOL) commitEditingAndReturnError:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return TRUE;
}

- (void) encodeWithCoder:(nonnull NSCoder *)aCoder {
    //
}
 */


#pragma mark: Actions
-(IBAction) gainSliderChanged: (nonnull NSSlider*) sender{
    
    [_gainParameter setValue: (int) sender.integerValue];
}

@end

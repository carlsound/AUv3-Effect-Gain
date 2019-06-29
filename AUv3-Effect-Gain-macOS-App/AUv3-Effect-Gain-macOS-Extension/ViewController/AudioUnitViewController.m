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
    
    GainAudioUnit* audioUnit;
}

//-(void)connectViewWithAU;
//-(void)disconnectViewWithAU;

@end

//////////////////////////////////////////////////////////

@implementation AudioUnitViewController {
    
    //AUAudioUnit *audioUnit;
    //AUv3_Effect_Gain_macOS_ExtensionAudioUnit* _audioUnit;
    //GainAudioUnit* _audioUnit;
    AUParameter* _gainParameter;
    AUParameterObserverToken _parameterObserverToken;
}

//@synthesize audioUnit;


#pragma mark- viewDidLoad
- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    if(audioUnit == nil) {
        return;
    }
    else {
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
        [self connectViewWithAU];
    }
}


- (void) dealloc {
    
    [self disconnectViewWithAU];
}



#pragma mark- getter
- (GainAudioUnit *) getAudioUnit {
    
    return audioUnit;
}

#pragma mark- setter
- (void)setAudioUnit:(GainAudioUnit *) audioUnit {
    
    self.audioUnit = audioUnit;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            [self connectViewWithAU];
        }
    });
}




#pragma mark- KVO
/*
- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString *, id> *)change
                       context:(nullable void *)context
{
    NSLog(@"AUdioUnitViewControler allParameterValues key path changed: %s\n", keyPath.UTF8String);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        filterView.frequency = cutoffParameter.value;
        filterView.resonance = resonanceParameter.value;
        
        frequencyLabel.stringValue = [cutoffParameter stringFromValue: nil];
        resonanceLabel.stringValue = [resonanceParameter stringFromValue: nil];
        
        [self updateFilterViewFrequencyAndMagnitudes];
    });
}
 */




#pragma mark-
-(void) connectViewWithAU {
    
    // @protocol AUAudioUnitFactory
    
    [self requestViewControllerWithCompletionHandler: ^(AUViewControllerBase* _Nullable viewController){
        viewController = self;
    }];
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the Audio Unit
    
    AUParameterTree *paramTree = audioUnit.parameterTree;
    
    if (paramTree) {
        
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
-(nullable GainAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription) desc
                                                   error:(NSError * _Nullable * _Nullable) error{
    
    self.audioUnit = [[GainAudioUnit alloc] initWithComponentDescription: desc
                                                                 options: kAudioComponentInstantiation_LoadOutOfProcess
                                                                   error: error];
    
    if(self.isViewLoaded){
        [self connectViewWithAU];
    }
    
    return audioUnit;
}

#pragma mark- @protocol AUAudioUnitFactory

- (void)requestViewControllerWithCompletionHandler:(void (^)(AUViewControllerBase *viewController))completionHandler{
    
    [self loadView];
    completionHandler(self);
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

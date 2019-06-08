//
//  AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit.m
//  AUv3-Effect-Gain-macOS-Extension-noUI
//
//  Created by John Carlson on 6/2/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import "AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit.h"

#import <AVFoundation/AVFoundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////


// Define parameter addresses.
const AudioUnitParameterID _GAIN_PARAMETER_ID = 0;


///////////////////////////////////////////////////////////////////////////////////////////////////////


@interface AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit ()

@property (nonatomic, readwrite) AUParameterTree* parameterTree; // https://developer.apple.com/documentation/audiotoolbox/auparametertree

@property AUAudioUnitBus *outputBus; // https://developer.apple.com/documentation/audiotoolbox/auaudiounitbus?language=objc

@property AUAudioUnitBusArray *inputBusArray; // https://developer.apple.com/documentation/audiotoolbox/auaudiounitbusarray?language=objc

@property AUAudioUnitBusArray *outputBusArray;

-(instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription
                                    options:(AudioComponentInstantiationOptions)options
                                      error:(NSError **)outError;

-(AUAudioUnitBusArray*)inputBusses;

-(AUAudioUnitBusArray*)outputBusses;

-(BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError;

-(void)deallocateRenderResources;

-(AUInternalRenderBlock)internalRenderBlock; // https://developer.apple.com/documentation/audiotoolbox/auinternalrenderblock?language=objc


@end


///////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation AUv3_Effect_Gain_macOS_Extension_noUIAudioUnit



#pragma mark - Local Variables

@synthesize parameterTree = _parameterTree;

AUAudioUnitBus* _inputBus;

AudioStreamBasicDescription _streamBasicDescription; // local copy of the asbd that block can capture
// https://developer.apple.com/documentation/coreaudio/audiostreambasicdescription?language=objc

UInt64 _totalFrames = 0;

AUValue _gain = 50;  // https://developer.apple.com/documentation/audiotoolbox/auvalue?language=objc

AudioBufferList _renderAudioBufferList; // https://developer.apple.com/documentation/coreaudio/audiobufferlist?language=objc




#pragma mark - Initialization

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription
                                     options:(AudioComponentInstantiationOptions)options
                                       error:(NSError **)outError {
    
    self = [super initWithComponentDescription:componentDescription
                                       options:options
                                         error:outError];
    
    if (self == nil) {
        return nil;
    }
    
    // Initialize a default format for the busses.
    AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100.0 channels:2]; // https://developer.apple.com/documentation/avfoundation/avaudioformat?language=objc
    
    _streamBasicDescription = *defaultFormat.streamDescription;
    
    // Create parameter objects.
    AUParameter* gainParameter = [AUParameterTree createParameterWithIdentifier: @"gainParameter"
                                                                           name: @"GainParam"
                                                                        address: _GAIN_PARAMETER_ID
                                                                            min: 0
                                                                            max: 100
                                                                           unit: kAudioUnitParameterUnit_Percent
                                                                       unitName: nil
                                                                          flags: 0
                                                                   valueStrings: nil
                                                            dependentParameters: nil];
    
    // Initialize the parameter values.
    gainParameter.value = 50;
    
    // Create the parameter tree.
    _parameterTree = [AUParameterTree createTreeWithChildren:@[ gainParameter ]];
    
    // Create the input and output busses (AUAudioUnitBus).
    _inputBus  = [[AUAudioUnitBus alloc] initWithFormat:defaultFormat error:nil];
    _outputBus = [[AUAudioUnitBus alloc] initWithFormat:defaultFormat error:nil];
    
    // Create the input and output bus arrays (AUAudioUnitBusArray).
    _inputBusArray  = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeInput  busses: @[_inputBus]];
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
    // implementorValueObserver is called when a parameter changes value.
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        switch (param.address) {
            case _GAIN_PARAMETER_ID:
                _gain = value;
                break;
            default:
                break;
        }
    };
    
    // implementorValueProvider is called when the value needs to be refreshed.
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        switch (param.address) {
            case _GAIN_PARAMETER_ID:
                return _gain; // TODO: is this capturing self?
            default:
                return (AUValue) 0.0;
        }
    };
    
    // A function to provide string representations of parameter values.
    _parameterTree.implementorStringFromValueCallback = ^(AUParameter *param, const AUValue *__nullable valuePtr) {
        AUValue value = valuePtr == nil ? param.value : *valuePtr;
        
        switch (param.address) {
            case _GAIN_PARAMETER_ID:
                return [NSString stringWithFormat:@"%.f", value];
            default:
                return @"?";
        }
    };
    
    self.maximumFramesToRender = 512;
    
    return self;
}

#pragma mark - Parameter ID Getter
/*
-(AudioUnitParameterID)getGainParamterID{
    
    return _GAIN_PARAMETER_ID;
}
 */

#pragma mark - AUAudioUnit Overrides

// If an audio unit has input, an audio unit's audio input connection points.
// Subclassers must override this property getter and should return the same object every time.
// See sample code.
- (AUAudioUnitBusArray *)inputBusses {
//#pragma message("implementation must return non-nil AUAudioUnitBusArray")
    return _inputBusArray;
}

// An audio unit's audio output connection points.
// Subclassers must override this property getter and should return the same object every time.
// See sample code.
- (AUAudioUnitBusArray *)outputBusses {
//#pragma message("implementation must return non-nil AUAudioUnitBusArray")
    return _outputBusArray;
}

// Allocate resources required to render.
// Subclassers should call the superclass implementation.
- (BOOL)allocateRenderResourcesAndReturnError: (NSError **)outError {
    
    if (![super allocateRenderResourcesAndReturnError:outError]) {
        return NO;
    }
    
    // Validate that the bus formats are compatible.
    if (_outputBus.format.channelCount != _inputBus.format.channelCount)
    {
        if (outError)
        {
            *outError = [NSError errorWithDomain: NSOSStatusErrorDomain
                                            code: kAudioUnitErr_FailedInitialization
                                        userInfo: nil];
        }
        // Notify superclass that initialization was not successful
        self.renderResourcesAllocated = NO;
        
        return NO;
    }
    
    // Allocate your resources.
    _renderAudioBufferList.mNumberBuffers = _outputBus.format.channelCount;
    
    _totalFrames = 0;
    
    return YES;
}

// Deallocate resources allocated in allocateRenderResourcesAndReturnError:
// Subclassers should call the superclass implementation.
- (void)deallocateRenderResources {
    
    // Deallocate your resources.
    [super deallocateRenderResources];
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)

// Block which subclassers must provide to implement rendering.
- (AUInternalRenderBlock) internalRenderBlock { // https://developer.apple.com/documentation/audiotoolbox/auinternalrenderblock?language=objc
    
    // Capture in locals to avoid ObjC member lookups. If "self" is captured in render, we're doing it wrong. See sample code.
    AUValue* gainCapture = &_gain;
    AudioStreamBasicDescription *streamBasicDescriptionCapture = &_streamBasicDescription;
    __block UInt64 *totalFramesCapture = &_totalFrames;
    AudioBufferList *renderAudioBufferListCapture = &_renderAudioBufferList;
    
    ///////////////////////////////////////////////////
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags,
                              const AudioTimeStamp *timestamp,
                              AVAudioFrameCount frameCount,
                              NSInteger outputBusNumber,
                              AudioBufferList *outputData,
                              const AURenderEvent *realtimeEventListHead,
                              AURenderPullInputBlock pullInputBlock) {

        // Do event handling and signal processing here.
        
        // use logged AudioStreamBasicDescription format from above (float + packed + noninterleaved)
        /*
        if (streamBasicDescriptionCapture->mFormatID != kAudioFormatLinearPCM || streamBasicDescriptionCapture->mFormatFlags != 0x29 || streamBasicDescriptionCapture->mChannelsPerFrame != 2) {
            return -999;
        }
         */
        
        
        // pull in samples to filter
        AUAudioUnitStatus auauStatus = pullInputBlock(actionFlags, timestamp, frameCount, 0, renderAudioBufferListCapture); //https://developer.apple.com/documentation/audiotoolbox/aurenderpullinputblock?language=objc
        
        // copy samples from AudioBufferList, apply gain multiplier, write to outputData
        size_t sampleSize = sizeof(Float32);
        for (int frame = 0; frame < frameCount; frame++) {
            
            *totalFramesCapture += 1;
            
            for (int renderBuf = 0; renderBuf < renderAudioBufferListCapture->mNumberBuffers; renderBuf++) {
                
                Float32 *sample = renderAudioBufferListCapture->mBuffers[renderBuf].mData + (frame * streamBasicDescriptionCapture->mBytesPerFrame);
                
                // apply gain multiplier
                *sample = ( (*sample) * (*gainCapture/100.0) );
                
                // https://developer.apple.com/documentation/kernel/1579338-memcpy?language=occ
                memcpy(outputData->mBuffers[renderBuf].mData + (frame * streamBasicDescriptionCapture->mBytesPerFrame),
                       sample,
                       sampleSize);
            }
        }
        
        //return noErr;
        return auauStatus;
    };
}

@end


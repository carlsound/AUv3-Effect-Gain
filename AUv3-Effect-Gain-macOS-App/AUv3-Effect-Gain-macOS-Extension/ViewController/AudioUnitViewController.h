//
//  AudioUnitViewController.h
//  AUv3-Effect-Gain-macOS-Extension
//
//  Created by John Carlson on 4/30/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudioKit/CoreAudioKit.h>

@interface AudioUnitViewController : AUViewController <AUAudioUnitFactory>

@property (strong) IBOutlet NSObjectController *volumeObjectController;

@end

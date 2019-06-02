//
//  AudioUnitController.h
//  AUv3-Effect-Gain-macOS-Extension-noUI
//
//  Created by John Carlson on 6/2/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioUnitController : NSObject <AUAudioUnitFactory>

@end

NS_ASSUME_NONNULL_END

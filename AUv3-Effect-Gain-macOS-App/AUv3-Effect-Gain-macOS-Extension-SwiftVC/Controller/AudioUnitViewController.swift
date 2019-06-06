//
//  AudioUnitViewController.swift
//  AUv3-Effect-Gain-macOS-Extension-SwiftVC
//
//  Created by John Carlson on 6/6/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

import CoreAudioKit

public class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    var audioUnit: AUAudioUnit?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioUnit == nil {
            return
        }
        
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    }
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try AUv3_Effect_Gain_macOS_Extension_SwiftVCAudioUnit(componentDescription: componentDescription, options: [])
        
        return audioUnit!
    }
    
}

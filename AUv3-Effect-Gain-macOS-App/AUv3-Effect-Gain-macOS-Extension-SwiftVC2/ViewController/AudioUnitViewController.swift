//
//  AudioUnitViewController.swift
//  AUv3-Effect-Gain-macOS-Extension-SwiftVC2
//
//  Created by John Carlson on 6/18/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

import CoreAudioKit

public class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    var audioUnit: GainAudioUnit?
    
    @IBOutlet var gainSlider: NSSlider!
    
    //////////////////////////////////////////////////////
    
    // @protocol AUAudioUnitFactory
    public func requestViewController(completionHandler: @escaping (NSViewController?) -> Void) {
        self.loadView()
        completionHandler(self)
    }
    
    //////////////////////////////////////////////////////
    
    
    private func connectViewWithAU() {
        // @protocol AUAudioUnitFactory
        /*
         self.requestViewController { (self) -> (Void) in
         let a = 1;
         } */
        
        let paramTree: AUParameterTree = (audioUnit?.parameterTree)!
        let gainParam: AUParameter = paramTree.value(forKey: "gain") as! AUParameter
        
        // prevent retain cycle in parameter observer
    }
    
    //////////////////////////////////////////////////////
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioUnit == nil {
            return
        }
        
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
        
        connectViewWithAU()
    }
    
    //////////////////////////////////////////////////////
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        
        audioUnit = try GainAudioUnit(componentDescription: componentDescription, options: [])
        
        return audioUnit!
    }
    
    //////////////////////////////////////////////////////
    
    // @protocol NSExtensionRequestHandling
    override public func beginRequest(with context: NSExtensionContext) {
        
        //var extensionContextItems: NSArray = context.inputItems as NSArray
        super.beginRequest(with: context)
    }
    
    //////////////////////////////////////////////////////
    
    @IBAction func handleGainSliderValueChanged(_ sender: NSSlider) {
        
        guard let gainUnit = audioUnit as? GainAudioUnit, //AUv3_Effect_Gain_macOS_Extension_SwiftVCAudioUnit,
            //guard let gainUnit = audioUnit as? GainAudioUnit,
            let gainParam = gainUnit.parameterTree?.parameter(withAddress: GAIN_PARAMETER_ADDRESS) else { return }
        
        gainParam.setValue(sender.floatValue, originator: nil)
        
    }
    
}

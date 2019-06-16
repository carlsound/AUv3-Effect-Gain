//
//  ApplicationViewController.h
//  AUv3-Effect-Gain-macOS-App
//
//  Created by John Carlson on 6/15/19.
//  Copyright © 2019 John Carlson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationViewController : NSViewController{
    
    __weak IBOutlet NSView* AppExtensionContainerView;
}

@end

NS_ASSUME_NONNULL_END

//
//  PSTGMNViewController.h
//  Pocket Stageman
//
//  Created by Alexander Golubets on 11.06.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "iAd/iAd.h"

@interface PSTGMNViewController : UIViewController <MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, ADBannerViewDelegate> // Add the delegate

@property (strong, nonatomic) IBOutlet UILabel *AmpName;
@property (strong, nonatomic) IBOutlet UILabel *HRBrightSwitchLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRVolumeLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRDriveLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRTrebleLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRBassLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRMiddleLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRMasterLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRReverbLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRPresenceLabel;
@property (strong, nonatomic) IBOutlet UISwitch *HRBrightSwitch;
@property (strong, nonatomic) IBOutlet UISlider *HRVolumeSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRDriveSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRTrebleSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRBassSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRMiddleSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRMasterSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRReverbSlider;
@property (strong, nonatomic) IBOutlet UISlider *HRPresenceSlider;

- (IBAction)showHelp:(id)sender;
- (IBAction)showEmail:(id)sender;
- (IBAction)HRVolumeSlider:(id)sender;
- (IBAction)HRDriveSlider:(id)sender;
- (IBAction)HRTrebleSlider:(id)sender;
- (IBAction)HRBassSlider:(id)sender;
- (IBAction)HRMiddleSlider:(id)sender;
- (IBAction)HRMasterSlider:(id)sender;
- (IBAction)HRReverbSlider:(id)sender;
- (IBAction)HRPresenceSlider:(id)sender;
- (IBAction)HRBrightSwitch:(id)sender;

//storage read/write
- (NSString *)dataFilePath;
- (void) writePlist;
- (void) readPlist;

@end

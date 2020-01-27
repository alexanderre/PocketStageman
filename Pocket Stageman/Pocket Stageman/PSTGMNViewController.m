//
//  PSTGMNViewController.m
//  Pocket Stageman
//
//  Created by Alexander Golubets on 11.06.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "PSTGMNViewController.h"

@interface PSTGMNViewController ()

@end

@implementation PSTGMNViewController
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

@synthesize HRBrightSwitch,HRVolumeSlider,HRDriveSlider,HRTrebleSlider,HRBassSlider,HRMiddleSlider,HRMasterSlider,HRReverbSlider,HRPresenceSlider;

- (int)HRBrightSwitchStateDisplay {
    int state = (int) HRBrightSwitch.state;
    if (HRBrightSwitch.on) {
        _HRBrightSwitchLabel.text = [NSString stringWithFormat:@"Bright ON"];
        state = 1;
    }
    else {
        _HRBrightSwitchLabel.text = [NSString stringWithFormat:@"Bright OFF"];
        state = 0;
    }
    NSLog(@"Switch state = %i", state);
    return state;

}
- (IBAction)savePreset:(id)sender {
    
    [self writePlist];
}

- (IBAction)showHelp:(id)sender {
    UIAlertView *InfoAlert = [[UIAlertView alloc] initWithTitle:@"Pocket Stageman Help"
                                                message:@"This is a really simple iPhone App. Dial the settings you want, then press Save button. Next time you'll launch an app it will load last saved preset. To share the settings with your stageman just use Share button. No more low lightning pics of amp knobs ;)." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [InfoAlert show];

}

- (IBAction)showEmail:(id)sender {
    [self composingMessage];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //    NSLog([NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        //    NSLog([NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    //NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            //          NSLog([NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
            //                                 placemark.subThoroughfare, placemark.thoroughfare,
            //                                 placemark.postalCode, placemark.locality,
            //                                 placemark.administrativeArea,
            //                                 placemark.country]);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}


- (void) composingMessage {
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"%@ settings", _AmpName.text];
    // Email Content
    //getting date
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    //adding settings
    NSString *messageBody = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n\n Made with Pocket Stageman App by Alexanderre in the city of %@, %@ on %@", _HRBrightSwitchLabel.text, _HRVolumeLabel.text, _HRDriveLabel.text, _HRTrebleLabel.text, _HRBassLabel.text, _HRMiddleLabel.text, _HRMasterLabel.text, _HRReverbLabel.text, _HRPresenceLabel.text, placemark.locality, placemark.country, dateString];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //getting saved data
    [self readPlist];
    //[self HRDInitSaved];
    
    //getting location
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //working with our data storage
    
}

- (void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
//    [self writePlist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)HRVolumeSlider:(UISlider *)sender {
    _HRVolumeLabel.text = [NSString stringWithFormat:@"Volume: %i", (int)self.HRVolumeSlider.value];
}

- (IBAction)HRDriveSlider:(id)sender {
    _HRDriveLabel.text = [NSString stringWithFormat:@"Drive: %i", (int)self.HRDriveSlider.value];
}

- (IBAction)HRTrebleSlider:(id)sender {
   _HRTrebleLabel.text = [NSString stringWithFormat:@"Treble: %i", (int)self.HRTrebleSlider.value];
}

- (IBAction)HRBassSlider:(id)sender {
   _HRBassLabel.text = [NSString stringWithFormat:@"Bass: %i", (int)self.HRBassSlider.value];
    
}

- (IBAction)HRMiddleSlider:(id)sender {
    _HRMiddleLabel.text = [NSString stringWithFormat:@"Middle: %i", (int)self.HRMiddleSlider.value];
}

- (IBAction)HRMasterSlider:(id)sender {
    _HRMasterLabel.text = [NSString stringWithFormat:@"Master: %i", (int)self.HRMasterSlider.value];
}

- (IBAction)HRReverbSlider:(id)sender {
    _HRReverbLabel.text = [NSString stringWithFormat:@"Reverb: %i", (int)self.HRReverbSlider.value];
}


- (IBAction)HRPresenceSlider:(id)sender {
    _HRPresenceLabel.text = [NSString stringWithFormat:@"Presence: %i", (int)self.HRPresenceSlider.value];
}

- (IBAction)HRBrightSwitch:(id)sender {
    [self HRBrightSwitchStateDisplay];
}


#pragma mark load/save data

//creating a plist
- (NSString *)dataFilePath {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSLog(@"Path: %@", path);
    NSLog(@"DIR: %@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:@"HRD.plist"];
}

//writing data to plist
- (void) writePlist {
    //casting floats to id
    NSNumber *hRBright = [NSNumber numberWithInt:[self HRBrightSwitchStateDisplay]];
    NSNumber *hRVolume = [NSNumber numberWithInt:(int)HRVolumeSlider.value];
    NSNumber *hRDrive = [NSNumber numberWithInt:(int)HRDriveSlider.value];
    NSNumber *hRTreble = [NSNumber numberWithInt:(int)HRTrebleSlider.value];
    NSNumber *hRBass = [NSNumber numberWithInt:(int)HRBassSlider.value];
    NSNumber *hRMiddle = [NSNumber numberWithInt:(int)HRMiddleSlider.value];
    NSNumber *hRMaster = [NSNumber numberWithInt:(int)HRMasterSlider.value];
    NSNumber *hRReverb = [NSNumber numberWithInt:(int)HRReverbSlider.value];
    NSNumber *hRPresence = [NSNumber numberWithInt:(int)HRPresenceSlider.value];
    //putting values to array
    NSArray *hotRodDeluxeStore = [NSArray arrayWithObjects:hRBright, hRVolume, hRDrive, hRTreble, hRBass, hRMiddle, hRMaster, hRReverb, hRPresence, nil];
    [hotRodDeluxeStore writeToFile:[self dataFilePath] atomically:YES];
    NSLog(@"My array contents: %@", hotRodDeluxeStore);
    
    
    
   }
//reading data from plist

- (void) HRDInitSaved {
    [HRBrightSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    [HRVolumeSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRDriveSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRTrebleSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRBassSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRMiddleSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRMasterSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRReverbSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [HRPresenceSlider sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) readPlist {
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *hotRodDeluxeLoad = [[NSArray alloc]initWithContentsOfFile:filePath];
        NSLog(@"\n Path: %@", filePath);
        NSLog(@"\n Saved Array contents: %@", hotRodDeluxeLoad);
        HRBrightSwitch.on = [[hotRodDeluxeLoad objectAtIndex:0] boolValue];
        HRVolumeSlider.value = [[hotRodDeluxeLoad objectAtIndex:1] floatValue];
        HRDriveSlider.value = [[hotRodDeluxeLoad objectAtIndex:2] floatValue];
        HRTrebleSlider.value = [[hotRodDeluxeLoad objectAtIndex:3] floatValue];
        HRBassSlider.value = [[hotRodDeluxeLoad objectAtIndex:4] floatValue];
        HRMiddleSlider.value = [[hotRodDeluxeLoad objectAtIndex:5] floatValue];
        HRMasterSlider.value = [[hotRodDeluxeLoad objectAtIndex:6] floatValue];
        HRReverbSlider.value = [[hotRodDeluxeLoad objectAtIndex:7] floatValue];
        HRPresenceSlider.value = [[hotRodDeluxeLoad objectAtIndex:8] floatValue];
        
        [self HRDInitSaved];
    }
    else {
        NSLog(@"Couldn't find PLIST for HRD!");
        [self writePlist];
        NSLog(@"Created a new one, moving on");
    }

}

#pragma mark iAd Delegate Methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}



@end

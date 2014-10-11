//
//  ViewController.m
//  Shew
//
//  Created by Ben Liu on 11/10/2014.
//  Copyright (c) 2014 Ben Liu. All rights reserved.
//

#import "ViewController.h"
#import <DBChooser/DBChooser.h>
#import <DBChooser/DBChooserResult.h>


@interface ViewController()


@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@end

@implementation ViewController
{
    DBChooserResult *_result; // result received from last CHooser call
    CLLocationManager *locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    //_labelLocation.text= @"Soemthing";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnGetCurrentLocation:(UIButton *)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization]; // Add This Line
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
    
    if (currentLocation != nil)
    {
        _labelLocation.text = [NSString stringWithFormat:@"%.8f\n%.8f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude];
        NSLog(@"%.8f",currentLocation.coordinate.longitude);
    }
}

- (IBAction)btnChooseDBfile:(UIButton *)sender {
    
    NSLog(@"Start!");
    
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         NSLog(@"Returned 1!");
         if ([results count]) {
             // Process results from Chooser
             _result = results[0];
             _labelLocation.text= results[0];
             //NSLog(@"The coutn value is %@", _result);
             NSLog(@"Returned 2!");
             
         } else {
             // User canceled the action
             NSLog(@"Returned 3!");
             //NSLog(@"The coutn value is %@", _result);
         }
     }];
}

@end

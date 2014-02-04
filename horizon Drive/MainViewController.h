//
//  MainViewController.h
//  horizon Drive
//
//  Created by Scott Hillson on 2/14/12.
//  Copyright (c) 2012 All rights reserved.

#import "FlipsideViewController.h"
#import "LocationController.h"
#import "AppDelegate.h"
#import "HorizonBrain.h"
#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,LocationControllerDelegate> {
    LocationController *locationController;
    UIButton *infoButton ;
    UILabel *speedometer ;
    UILabel *measurement ;
    UILabel *distanceLabel ;
    UILabel *heading ;
    UILabel *timerLabel ;
	UIImageView *speedBackground ;
	UIImageView *timeBackground ;
	UIImageView *distanceBackground ;
    NSNumber *totalDistance ;
    NSNumber *displayDistance ;
    NSNumber *displaySpeed ;
    NSDate *startTime ;
    NSDate *speedTime ;
    NSDate *distanceTime ;
    NSDate *headingTime ;
	NSDate *historyTime ;
	CLLocation *storedLocationOne ;
    CLLocation *storedLocationTwo ;
    CLLocation *temporaryPoint ;
    NSTimer *speedTimer ;
}

-(void)locationUpdate:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation ;
-(void)locationError:(NSError *)error ;

-(double)returnTotalDistance ;
-(double)returnTime ;

-(IBAction)measurePress:(id)sender ;
-(IBAction)distancePress:(id)sender ;
-(IBAction)timerPress:(id)sender ;

@property ( strong , nonatomic ) NSNumber *displayDistance ;
@property ( strong , nonatomic ) NSNumber *displaySpeed ;
@property ( strong , nonatomic ) IBOutlet UIImageView *distanceBackground ;
@property ( strong , nonatomic ) IBOutlet UILabel *distanceLabel ;
@property ( strong , nonatomic ) IBOutlet UILabel *heading ;
@property ( strong , nonatomic ) IBOutlet UIButton *infoButton ;
@property ( strong , nonatomic ) NSManagedObjectContext *managedObjectContext ;
@property ( strong , nonatomic ) IBOutlet UILabel *measurement ;
@property ( strong , nonatomic ) NSString *measurementString ;
@property ( strong , nonatomic ) IBOutlet UIImageView *speedBackground ;
@property ( strong , nonatomic ) IBOutlet UILabel *speedometer ;
@property ( strong , nonatomic ) NSTimer *speedTimer ;
@property ( strong , nonatomic ) CLLocation *storedLocationOne ;
@property ( strong , nonatomic ) CLLocation *storedLocationTwo ;
@property ( strong , nonatomic ) CLLocation *temporaryPoint ;
@property ( strong , nonatomic ) IBOutlet UIImageView *timeBackground ;
@property ( strong , nonatomic ) IBOutlet UILabel *timerLabel ;
@property ( strong , nonatomic ) NSNumber *totalDistance ;
@end
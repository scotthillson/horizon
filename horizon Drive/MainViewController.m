//
//  MainViewController.m
//  horizon Drive
//
//  Created by Scott Hillson on 2/14/12.
//  Copyright (c) 2012 All rights reserved.

// speed is measured in meters per second
#define kMilesPerHour 2.236936 // multiply meters per second by this
#define kKilometersPerHour 3.6 // multiply meters per second by this
#define kMetersToMiles 0.000621371192
#import "MainViewController.h"

@interface MainViewController ( )
// private properties go here!
@property ( nonatomic ) float blue ;
@property ( strong , nonatomic ) HorizonBrain *brain ;
@property ( strong , nonatomic ) NSDate *distanceTime ;
@property ( nonatomic ) float green ;
@property ( strong , nonatomic ) NSDate *headingTime ;
@property ( strong , nonatomic ) NSDate *historyTime ;
@property ( nonatomic ) float horizontalAccuracy ;
@property ( strong , nonatomic ) NSDate *startTime ;
@property ( nonatomic ) double storedTime ;
@property ( nonatomic ) float targetBlue ;
@property ( nonatomic ) float targetGreen ;
@property ( nonatomic ) double time ;
@end

@implementation MainViewController
@synthesize blue ;
@synthesize brain = _brain ;
@synthesize displayDistance ;
@synthesize displaySpeed ;
@synthesize distanceBackground ;
@synthesize distanceLabel ;
@synthesize distanceTime ;
@synthesize green ;
@synthesize heading ;
@synthesize headingTime ;
@synthesize historyTime ;
@synthesize horizontalAccuracy ;
@synthesize infoButton ;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize measurement ;
@synthesize measurementString ;
@synthesize speedBackground ;
@synthesize speedometer ;
@synthesize speedTimer ;
@synthesize startTime ;
@synthesize storedLocationOne ;
@synthesize storedLocationTwo ;
@synthesize storedTime ;
@synthesize targetBlue ;
@synthesize targetGreen ;
@synthesize temporaryPoint ;
@synthesize time ;
@synthesize timerLabel ;
@synthesize timeBackground ;
@synthesize totalDistance ;

- (HorizonBrain *)brain {
	if ( !_brain ) _brain = [ [ HorizonBrain alloc ] init ] ;
	return _brain ;
}

/*- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}*/

- ( double ) returnTest {
	return 1.123 ;
}

- ( void ) didReceiveMemoryWarning { [ super didReceiveMemoryWarning ] ; } // Release any cached data, images, etc that aren't in use.

#pragma mark - View lifecycle

- ( void ) viewDidLoad {
	double testDouble = [ self returnTest ] ;
	NSLog(@"test double %f" , testDouble ) ;
	// Do any additional setup after loading the view, typically from a nib.
	[super viewDidLoad];
    [ UIApplication sharedApplication ] . idleTimerDisabled = YES ;
	NSLog(@"view did load" ) ;
	NSLog ( @"location services enabled? %@" , locationController.locationServicesEnabled ) ;
    measurementString = @"mph" ;
    speedometer.text = @"0" ;
    measurement.text = measurementString ;
    locationController = [ [ LocationController alloc ] init ] ;
    locationController.delegate = self ;
    locationController.locationManager.desiredAccuracy = kCLLocationAccuracyBest ;
    [locationController.locationManager startUpdatingLocation] ;
	
	totalDistance = [ NSNumber numberWithDouble: [ self.brain retrieveDistance ] ] ;
    
    displayDistance = totalDistance ;
	
	// the starTime is used for the time displayed to the user
	startTime = NSDate.date ;
	
	// historyTime is used to keep frequent updates of where the user was located
	historyTime = NSDate.date ;
	
	// distance time is the time since our last distance label update
    distanceTime = NSDate.date ;
	
	// heading time is measuring the time between compass updates
    headingTime = NSDate.date ;
    
	// speedTimer is the primary timer!
	speedTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE] ;
	
	if ( !green ) green = 4 ;
	if ( !blue ) blue = 4 ;
    
}

- ( void ) viewDidUnload {
	NSLog(@"view did unload!");
    // called when we are running low on memory, releases any retained outlets or subviews of this main view
    speedometer = nil ;
    measurement = nil ;
    measurementString = nil ;
    heading = nil ;
    distanceLabel = nil ;
	speedBackground = nil ;
	distanceBackground = nil ;
	timeBackground = nil ;
	[super viewDidUnload];
    [ UIApplication sharedApplication ] . idleTimerDisabled = NO ;
}

- ( void ) applicationDidBecomeActive:(UIApplication *) application {
	// restart any interface tasks that were paused or not yet started
	
	// the starTime is used for the time displayed to the user
	startTime = NSDate.date ;
	
	distanceTime = NSDate.date ;

	headingTime = NSDate.date ;
    
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE] ;
	
}

- ( void ) applicationWillResignActive : ( NSNotification * ) notification {
	// application will be moved into the background when the user exits or for incoming phone calls, etc
	
}

- ( void ) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        speedometer.frame = CGRectMake ( 120 , 20 , 240, 140 ) ;
        measurement.frame = CGRectMake ( 380 , 70 , 90 , 50 ) ;
        distanceLabel.frame = CGRectMake ( 140 , 225 , 200 , 50 ) ;
        heading.frame = CGRectMake ( 20 , 220 , 60 , 60 ) ;
        timerLabel.frame = CGRectMake( 140 , 170 , 200 , 50 ) ;
        infoButton.frame = CGRectMake ( 440 , 20 , 20 , 20 ) ;
		speedBackground.frame = CGRectMake ( 120 , 15 , 240 , 150 ) ;
		timeBackground.frame = CGRectMake ( 120 , 170 , 240 , 50 ) ;
		distanceBackground.frame = CGRectMake ( 120 , 225 , 240 , 50 ) ;
    }
    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        speedometer.frame = CGRectMake ( 40 , 80 , 240 , 150 ) ;
        measurement.frame = CGRectMake ( 110 , 230 , 100 , 50 ) ;
        distanceLabel.frame = CGRectMake ( 60 , 385 , 200 , 50 ) ;
        heading.frame = CGRectMake ( 130 , 22 , 60 , 60 ) ;
        timerLabel.frame = CGRectMake ( 60 , 320 , 200 , 50 ) ;
        infoButton.frame = CGRectMake ( 240 , 20 , 20 , 20 ) ;
		speedBackground.frame = CGRectMake ( 40 , 75 , 240 , 150 ) ;
		timeBackground.frame = CGRectMake ( 40 , 320 , 240 , 50 ) ;
		distanceBackground.frame = CGRectMake ( 40 , 385 , 240 , 50 ) ;
    }
}

- ( void ) updateColor {
	if ( horizontalAccuracy > 100 ) {
		targetBlue = 0 ;
		targetGreen = 0 ;
	}
	else if ( horizontalAccuracy > 20 ) {
		targetBlue = 0 ;
		targetGreen = 100 ;
	}
	else {
		targetBlue = 256 ;
		targetGreen = 256 ;
	}
	if ( targetBlue > blue ) blue += 4 ;
	if ( targetBlue < blue ) blue -= 4 ;
	if ( targetGreen > green ) green += 4 ;
	if ( targetGreen < green ) green -= 4 ;
	float blueColor = blue / 256 ;
	float greenColor = green / 256 ;
	speedometer.textColor = [ UIColor colorWithRed:256 green:greenColor blue:blueColor alpha:1 ] ;
	measurement.textColor = [ UIColor colorWithRed:256 green:greenColor blue:blueColor alpha:1 ] ;
	heading.textColor = [ UIColor colorWithRed:256 green:greenColor blue:blueColor alpha:1 ] ;
	distanceLabel.textColor = [ UIColor colorWithRed:256 green:greenColor blue:blueColor alpha:1 ] ;
}

- ( void ) locationUpdate:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	horizontalAccuracy = newLocation.horizontalAccuracy ;
    if ( horizontalAccuracy > 20 ) {
        // not enough accuracy to do what we want?
        if ( newLocation.speed > 0 ) {
            // we can still keep an eye on distance if we lose reception
            if ( !temporaryPoint ) temporaryPoint = newLocation ;
        }

    }
    else {
        // we have enough accuracy to calculate everything, oh yes we do.
		// storedLocationOne is our oldest location.
        if ( !storedLocationOne ) {
			// we will need it to have at least some value to start our calculations, even if it isn't that different.
            storedLocationOne = newLocation ;
        }
        if ( temporaryPoint ) {
            // we lost reception for a period, in a tunnel for example ;
            double totalDistanceDouble = totalDistance.doubleValue ;
            totalDistanceDouble += [ newLocation distanceFromLocation : temporaryPoint ] ;
            totalDistance = [ NSNumber numberWithDouble : totalDistanceDouble ] ;
            temporaryPoint = nil ;
        }
        CLLocationDistance newDistance = [ newLocation distanceFromLocation:oldLocation ] ;
        if ( !totalDistance ) totalDistance = 0 ;
        double totalDistanceDouble = totalDistance.doubleValue ;
        totalDistanceDouble += newDistance ;
        totalDistance = [ NSNumber numberWithDouble : totalDistanceDouble ] ;
    }
	// storedLocationTwo is always our most recent location for calculation purposes.
    storedLocationTwo = newLocation ;
}

- ( double ) returnTotalDistance {
	if ( totalDistance ) return [ totalDistance doubleValue ] ;
	else return 0 ;
}

- ( void ) recordDistance {
	// log the distance we've traveled in our core stack
	id result = [ self.brain storeDistance : totalDistance ] ;
	NSLog(@"result %@" , result ) ;
}

- ( double ) returnTime {
	NSLog(@"time i'm sending %f" , time ) ;
	return time ;
}

- ( double ) seeTime {
	NSLog(@"time i'm seeing %f" , time ) ;
	return time ;
}

- ( void ) updateDistance {
	double totalDistanceDouble = totalDistance.doubleValue ;
	if ( totalDistanceDouble > 0 ) {
		double displayDistanceDouble = displayDistance.doubleValue ;
		double difference = totalDistanceDouble - displayDistanceDouble ;
		double distanceTimeDouble = [ [ NSDate date ] timeIntervalSinceDate : distanceTime ] ;
		if ( difference > 80 ) { displayDistanceDouble = totalDistanceDouble ; } // if our distance starts to escape us, we have to eventually skip and catch up
		if ( difference <= 40 & distanceTimeDouble > 0.05 || difference > 40 ) {
			displayDistanceDouble = difference > 1 ? displayDistanceDouble + 1 : totalDistanceDouble ;
			displayDistance = [ NSNumber numberWithDouble : displayDistanceDouble ] ;
			displayDistanceDouble = displayDistanceDouble * ( measurementString == @"mph" ? kMetersToMiles : 0.001 ) ;
			totalDistanceDouble = totalDistanceDouble * ( measurementString == @"mph" ? kMetersToMiles : 0.001 ) ;
			distanceLabel.text = [ [ NSString alloc ] initWithFormat:@"%.2f %@", displayDistanceDouble , measurementString == @"mph" ? @" miles" : @" kilometres" ] ;
			measurement.text = measurementString ;
			// distancetime is the time since our last distance label update
			distanceTime = NSDate.date ;
		}
	}
	else {
		distanceLabel.text = @"0.00" ;
	}
}

- ( void ) updateHeading {
	int headingDifference = [ [ NSDate date ] timeIntervalSinceDate : headingTime ] ;
    if ( headingDifference > 1 ) {
        if ( storedLocationOne ) {
            if ( [ storedLocationTwo distanceFromLocation:storedLocationOne ] > 100 ) {
                // if it has been at least five seconds and we've gone 100 meters we calculate our heading and reset
                float lat1 = storedLocationOne.coordinate.latitude ;
                float lat2 = storedLocationTwo.coordinate.latitude ;
                float long1 = storedLocationOne.coordinate.longitude ;
                float long2 = storedLocationTwo.coordinate.longitude ;
                float longitudeDifference = long2 - long1 ;
                float arctangent = atan2 ( sin ( longitudeDifference ) * cos ( lat2 ) , ( cos ( lat1 ) * sin ( lat2 ) ) - ( sin ( lat1 ) * cos ( lat2 ) * cos ( longitudeDifference ) ) ) ;
                float degrees = arctangent * ( 180 / M_PI ) ;
                if ( degrees < 0 ) degrees = ( 180 - fabs ( degrees ) ) + 180 ;
                // degrees are now 0 to 360
                NSString *headingString = [ [ NSString alloc ] init ] ;
                if ( degrees < 22.5 || degrees > 337.5 ) headingString = @"N" ;
                else if ( degrees < 67.5 ) headingString = @"NE" ;
                else if ( degrees < 112.5 ) headingString = @"E" ;
                else if ( degrees < 157.5 ) headingString = @"SE" ;
                else if ( degrees < 202.5 ) headingString = @"S" ;
                else if ( degrees < 247.5 ) headingString = @"SW" ;
                else if ( degrees < 292.5 ) headingString = @"W" ;
                else headingString = @"NW" ;
                if ( heading.text != headingString ) { heading.text = headingString ; }
                storedLocationOne = storedLocationTwo ;
            }
        }
    }
}

- ( void ) updateUserTimer {
	time = [ [ NSDate date ] timeIntervalSinceDate : startTime ] + storedTime ;
    int minutes = (int) ( time / 60 ) ;
    int seconds = (int) time - ( minutes * 60 ) ;
    int hours = (int) ( minutes / 60 ) ;
    minutes = minutes - hours * 60 ;
    NSString *timerstring = [ [ NSString alloc ] initWithFormat : @"%02d:%02d:%02d" , hours , minutes , seconds ] ;
    if ( timerLabel.text != timerstring ) { timerLabel.text = timerstring ; }
}

- ( void ) updateSpeedometer {
	// speed is measured in meters per second
	if ( storedLocationTwo.speed < 0 )
		// if our current speed registers as less than 0, just display 0 to the user
	{ speedometer.text = @"0" ; }
	else {
		double displaySpeedDouble = displaySpeed.doubleValue ;
		double actualSpeed = storedLocationTwo.speed  ;
		if ( displaySpeedDouble < 1 ) {
			// we haven't kept track of our display speed yet, we start from the beginning
			displaySpeedDouble = actualSpeed ;
		}
		if ( actualSpeed > displaySpeedDouble ) {
			if ( actualSpeed > displaySpeedDouble + 0.5 ) {
				displaySpeedDouble = displaySpeedDouble + 0.5 ;
			}
			else {
				displaySpeedDouble = actualSpeed ;
			}
		}
		else if ( actualSpeed < displaySpeedDouble ) {
			if ( actualSpeed < displaySpeedDouble - 0.5 ) {
				displaySpeedDouble = displaySpeedDouble - 0.5 ;
			}
			else {
				displaySpeedDouble = actualSpeed ;
			}
		}
		double multiplier = measurementString == @"mph" ? kMilesPerHour : kKilometersPerHour ;
		NSString *speedString = [ [ NSString alloc ] initWithFormat : @"%.0f" , displaySpeedDouble * multiplier ] ;
		if ( speedometer.text != speedString ) { speedometer.text = speedString ; }
		displaySpeed = [ NSNumber numberWithDouble : displaySpeedDouble ] ;
	}
}

- ( void ) onTimer : ( NSTimer * ) timer {
	
	double historyTimeDouble = [ [ NSDate date ] timeIntervalSinceDate : historyTime ] ;
	
	if ( historyTimeDouble > 10 ) {
		// store the current distance permanently
		[ self recordDistance ] ;
		
		NSLog(@"here in the mainview, how is time doing? %f" , time ) ;
		
		[ self.brain storeTime ] ;
		
		[ self seeTime ] ;
		
		// reset this timer
		historyTime = NSDate.date ;
	}
    
	[ self updateDistance ] ;
	
	[ self updateSpeedometer ] ;
	
	[ self updateColor ] ;
	
    // handle our heading now
	[ self updateHeading ] ;
	
	// update the display timer
    [ self updateUserTimer ] ;
}

- ( void ) stopTimer {
	// killing the speed timer will kill all tasks.
    speedTimer = nil ;
}

- (void)locationError:(NSError *)error {
    NSLog(@"Error%@", error ) ;
    
}

- (IBAction)measurePress:(id)sender {
    if ( measurementString == @"mph" ) measurementString = @"kph" ;
    else measurementString = @"mph" ;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) { 
		if ( alertView.tag == 1 ) totalDistance = 0 ;
		if ( alertView.tag == 2 ) startTime = NSDate.date ;
	}
}

- (IBAction)distancePress:(id)sender {
	UIAlertView *alertView = [ [ UIAlertView alloc ] initWithTitle : @"Reset Distance" message : @"Would you like to reset the distance?" delegate : self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset" , nil ] ;
	alertView.tag = 1 ;
	[ alertView show ] ;
}

- (IBAction)timerPress:(id)sender {
	UIAlertView *alertView = [ [ UIAlertView alloc ] initWithTitle: @"Reset Timer" message:@"Would you like to reset the timer?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Reset" , nil ] ;
	alertView.tag = 2 ;
	[ alertView show ] ;
	
}

- (void)viewWillAppear:(BOOL)animated{[super viewWillAppear:animated];}
- (void)viewDidAppear:(BOOL)animated{[super viewDidAppear:animated];}
- (void)viewWillDisappear:(BOOL)animated{[super viewWillDisappear:animated];}
- (void)viewDidDisappear:(BOOL)animated{[super viewDidDisappear:animated];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES ;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller{[self dismissModalViewControllerAnimated:YES];}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
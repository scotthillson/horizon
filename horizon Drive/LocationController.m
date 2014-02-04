//
//  MyCLController.m
//  Hike
//
//  Created by Scott Hillson on 2/7/12.
//  Copyright (c) 2012 Dr Bott LLC. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

@synthesize locationManager ;
@synthesize delegate ;
@synthesize locationServicesEnabled ;

- (id) init {
    
    if ( self != nil ) {
        
        self.locationManager = [ [ CLLocationManager alloc ] init ] ;
        self.locationManager.delegate = self ; //send update to myself
        
    }
    
    return self ;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [ self.delegate locationUpdate:newLocation fromLocation:(CLLocation *)oldLocation ] ;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [ self.delegate locationError:error ] ;
}

@end

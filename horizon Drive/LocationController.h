//
//  LocationController.h
//  Hike
//
//  Created by Scott Hillson on 2/7/12.
//  Copyright (c) 2012 Dr Bott LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate
-(void)locationUpdate:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation ;
-(void)locationError:(NSError *)error ;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager ;
    id delegate ;
    
}

@property ( nonatomic , strong ) CLLocationManager *locationManager;
@property ( nonatomic , strong ) id <LocationControllerDelegate> delegate ;

@property ( nonatomic ) BOOL locationServicesEnabled ;


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation ;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error ;

@end

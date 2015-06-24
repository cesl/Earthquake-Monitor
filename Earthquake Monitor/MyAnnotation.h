//
//  MyAnnotation.h
//  Jerez
//
//  Created by Cesar Saucedo on 01/08/14.
//  Copyright (c) 2014 Cesar Saucedo. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>{
    
    CLLocationCoordinate2D coordinate;
    
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
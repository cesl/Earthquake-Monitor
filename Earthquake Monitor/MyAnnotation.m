//
//  MyAnnotation.m
//  Jerez
//
//  Created by Cesar Saucedo on 01/08/14.
//  Copyright (c) 2014 Cesar Saucedo. All rights reserved.
//



#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    NSLog(@"setCoordinate");
    coordinate = newCoordinate;
}

@end
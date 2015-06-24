//
//  detailViewController.m
//  Earthquake Monitor
//
//  Created by Cesar Saucedo on 22/06/15.
//  Copyright (c) 2015 César Saucedo. All rights reserved.
//

#import "detailViewController.h"
#import "sumaryReader.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "Reachability.h"

@interface detailViewController () <MKMapViewDelegate>{
    NSDictionary * detailData;
    IBOutlet UILabel *lblMagnitude;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblLocation;
    IBOutlet MKMapView *mapa;
    IBOutlet UILabel *lblDepth;
}

@end

@implementation detailViewController

@synthesize titulo, detailUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titulo;
    UIBarButtonItem * refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    
    mapa.delegate = self;
    
    [self refresh];
}

-(void) refresh{
    if ([self connected]) {
        NSLog(@"refresh");
        
        dispatch_queue_t loaderQ = dispatch_queue_create("load detail", NULL);
        dispatch_async(loaderQ, ^{
            NSDictionary* data = [sumaryReader getDetailFeedfrom:self.detailUrl];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configureViewWith:data];

                
            });
        });
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"detailFeed"] != nil ) {
        
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailFeed"];
        NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //NSDictionary * temp  = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
        
        NSLog(@"else %@", temp);
        
        [self configureViewWith:[temp valueForKey:self.detailUrl] ];
    }
}


-(void) configureViewWith:(NSDictionary*) data{
    detailData = data;
    lblMagnitude.text = [[detailData[@"properties"] objectForKey:@"mag"] description];
    
    NSTimeInterval interval = [[detailData[@"properties"] objectForKey:@"time"] floatValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd-MM-yyyy  HH:mm:ss"];
    
    lblDate.text = [formatter stringFromDate:date];
    lblLocation.text = [[detailData[@"properties"] objectForKey:@"place"] description];
    
    NSLog(@"depth %@",[detailData[@"properties"][@"products"][@"dyfi"] [0][@"properties"][@"depth"]  description]);
    
    if([detailData[@"properties"][@"products"][@"dyfi"] [0][@"properties"][@"depth"]  description])
        lblDepth.text = [NSString stringWithFormat:@"%@ Km", [detailData[@"properties"][@"products"][@"dyfi"] [0][@"properties"][@"depth"]  description]] ;
    
    float latitude = [[[detailData objectForKey:@"geometry"] objectForKey:@"coordinates" ][1] floatValue];
    float longitude = [[[detailData objectForKey:@"geometry"] objectForKey:@"coordinates" ][0] floatValue];
    
    NSLog(@"%f", latitude);
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake( latitude, longitude);
    
    [mapa removeAnnotations:mapa.annotations];
    MyAnnotation *myPin = [[MyAnnotation alloc] initWithCoordinate:loc ];
    [mapa addAnnotation:myPin];
    
    MKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.latitudeDelta = 6.0;
    region.span.longitudeDelta = 6.0;
    [mapa setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma MARK connectivity
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


@end

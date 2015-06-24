//
//  detailViewController.h
//  Earthquake Monitor
//
//  Created by Cesar Saucedo on 22/06/15.
//  Copyright (c) 2015 César Saucedo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController{
    NSString * titulo;
    NSString * detailUrl;
    
}

@property (strong, nonatomic) NSString * titulo;

@property (strong, nonatomic) NSString * detailUrl;

@end

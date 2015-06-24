//
//  sumaryReader.h
//  Earthquake Monitor
//
//  Created by Cesar Saucedo on 22/06/15.
//  Copyright (c) 2015 César Saucedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sumaryReader : NSObject


+ (NSDictionary *) getSumaryFeedfrom:(NSString*)url;
+ (NSDictionary *) getDetailFeedfrom:(NSString*)url;

@end


//
//  GeocodeAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-23.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeocodeAnnotation.h"

@interface GeocodeAnnotation ()

@property (nonatomic, readwrite, strong) AMapGeocode *geocode;

@end

@implementation GeocodeAnnotation
@synthesize geocode = _geocode;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return self.geocode.formattedAddress;
}

- (NSString *)subtitle
{
    return [self.geocode.location description];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.geocode.location.latitude, self.geocode.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithGeocode:(AMapGeocode *)geocode
{
    if (self = [super init])
    {
        self.geocode = geocode;
    }
    
    return self;
}

@end

//
//  PlaytomicPrivateLeaderboard.m
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaytomicPrivateLeaderboard.h"

@interface PlaytomicPrivateLeaderboard ()

@property(retain,nonatomic)     NSString* tableId;
@property(retain,nonatomic)     NSString* name;
@property(retain,nonatomic)     NSString* permalink;
@property(assign,nonatomic)     BOOL      hightest;
@property(retain,nonatomic)     NSString* realName;

@end

@implementation PlaytomicPrivateLeaderboard

@synthesize tableId;
@synthesize name;
@synthesize permalink;
@synthesize hightest;
@synthesize realName;

- (id)initWithName:(NSString*)pname andHighest:(BOOL)phighest
{
    self = [self init];
    if(self)
    {
        name = pname;
        hightest = phighest;
    }
    return self;
}

- (id)initWithName:(NSString*)pname 
        andTableId:(NSString*)ptableid
      andPermalink:(NSString*)ppermalink 
       andHighest:(BOOL)phighest 
       andRealName:(NSString*)prealname
{
    self = [self init];
    if(self)
    {
        name = pname;
        hightest = phighest;
        permalink = ppermalink;
        tableId = ptableid;
        realName = prealname;
    }
    return self;
}

@end

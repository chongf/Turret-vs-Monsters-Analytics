//
//  PlaytomicPrivateLeaderboard.h
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaytomicPrivateLeaderboard : NSObject
{
    NSString* tableId;
    NSString* name;
    NSString* permalink;
    BOOL      hightest;
    NSString* realName;
}

- (id)initWithName:(NSString*)pname andHighest:(BOOL)phighest;

- (id)initWithName:(NSString*)pname 
        andTableId:(NSString*)ptableid
      andPermalink:(NSString*)ppermalink 
       andHighest:(BOOL)phighest 
       andRealName:(NSString*)prealname;
@end

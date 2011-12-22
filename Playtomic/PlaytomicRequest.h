//
//  PlaytomicRequest.h
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaytomicResponse.h"

@interface PlaytomicRequest : NSObject
{
    
}

+ (void) sendRequestUrl:(NSString*)url
             andSection:(NSString*)section 
              andAction:(NSString*)action 
    andCompleteDelegate:(id)completeDelegate
    andCompleteSelector:(SEL)completeSelector
            andPostData:(NSDictionary*)postData;

+ (PlaytomicResponse*) sendRequestUrl:(NSString*)url
                           andSection:(NSString*)section                            
                            andAction:(NSString*)action 
                          andPostData:(NSDictionary*)postData;


+ (void) generateKeyName:(NSString*)name andKey:(NSString*)key andArray:(NSMutableArray*)array;

+ (NSString*) joinArray:(NSMutableArray*)array;
@end

//
//  PlaytomicURLRequest.h
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaytomicURLRequest : NSObject {

    NSString*               domain;
	NSMutableData*          buffer;
    NSMutableURLRequest*    request;
    NSData*                 lastRequestData;
    NSMutableDictionary*    postData;
    NSError*                error;
	
	id                      delegate;
    SEL                     completeSelector;
}

@property (copy,nonatomic) NSString* domain;
@property (assign, nonatomic) id delegate;
@property (copy,nonatomic)      NSError* error;
@property                  SEL       completeSelector;
@property (copy, nonatomic) NSData* lastRequestData;
@property (copy)            NSMutableData* buffer;

- (id) initWithDomain:(NSString*) sourceDomain;

- (void) startSynchronous;

- (void) startAsynchronous;

- (void) setPostValue:(NSString*)value forKey:(NSString*)key;

- (NSString*) getPostString;

- (NSString*) responseString;
@end

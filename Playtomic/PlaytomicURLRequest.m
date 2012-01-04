//
//  PlaytomicURLRequest.m
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaytomicURLRequest.h"

@implementation PlaytomicURLRequest

@synthesize domain;
@synthesize delegate;
@synthesize error;
@synthesize completeSelector;
@synthesize lastRequestData;
@synthesize buffer;

- (id) initWithDomain:(NSString *)sourceDomain {
    
	self = [super init];
	if (self != nil) {
		if (sourceDomain != nil) {
			self.domain = sourceDomain;
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sourceDomain]];            
		}
	}
	return self;
}


- (void) startSynchronous
{
    self.buffer = nil;
    if(postData != nil)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[[self getPostString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLResponse* response = nil;
    NSError* localError = nil;
    self.lastRequestData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&localError];
    self.error = localError;
}

- (void) startAsynchronous
{
    self.buffer = nil;
    if(postData != nil)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[[self getPostString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.error = 0;
	if (connection) {
		buffer = [[NSMutableData data] retain];
		
	}
	else {
        self.error = [NSError errorWithDomain:[request.URL path] code:1 userInfo:nil];
		if(delegate && [delegate respondsToSelector:completeSelector]) {
            [delegate performSelector:completeSelector withObject:self];

		}
	}
}

- (void) setPostValue:(NSString*)value forKey:(NSString*)key
{
    if(postData == nil)
    {
        postData = [[NSMutableDictionary alloc] init];
    }
    [postData setObject:value forKey:key];
}

- (NSString*) getPostString
{
    NSMutableString* postString = nil;
    if(postData != nil && [postData count] > 0)
    {
        for(id key in postData)
        {
            if( postString == nil)
            {
                postString = [NSString stringWithFormat:@"%@=%@", key, [postData objectForKey:key]];
            }
            else
            {
                [postString appendString:[NSString stringWithFormat:@"&%@=%@", key, [postData objectForKey:key]]];
            }
        }
    }
    return postString;
}

- (void) connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *) responde {
	
	[buffer setLength:0];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[buffer appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) connectionError {
	[connection release];
	self.buffer = nil;
    error = connectionError;
	if(delegate && [delegate respondsToSelector:completeSelector]) {
        [delegate performSelector:completeSelector withObject:self];
        
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
    self.lastRequestData = buffer;
    self.buffer = nil;
    if(delegate && [delegate respondsToSelector:completeSelector]) {
        [delegate performSelector:completeSelector withObject:self];
        
    }

}

- (NSString*) responseString
{
    return [[[NSString alloc] initWithBytes:[lastRequestData bytes] length:[lastRequestData length] encoding:NSUTF8StringEncoding] autorelease];
}


- (void) dealloc {
	
    self.lastRequestData = nil;
    
    if(postData != nil)
    {
        [postData release];
    }
    self.error = nil;
    [domain release];
	self.buffer = nil;
	[super dealloc];
}

@end

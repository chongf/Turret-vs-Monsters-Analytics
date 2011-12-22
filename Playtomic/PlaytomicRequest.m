//
//  PlaytomicRequest.m
//  ObjectiveCTest
//
//  Created by matias calegaris on 11/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaytomicRequest.h"
#import "PlaytomicEncrypt.h"
#import "ASI/ASIFormDataRequest.h"
#import "ASI/ASIHTTPRequest.h"
#import "Playtomic.h"
#import "JSON/JSON.h"


NSInteger compareStringValue(id a, id b, void *context) {
    // Get the integer value of the number at the start
    // of the filename
    NSString* a_string = (NSString*)a;
    NSString* b_string = (NSString*)b;
    
 /*      
    // Now compare and return the appropriate value
    if (a_string > b_string) return NSOrderedAscending;
    if (a_string < b_string) return NSOrderedDescending;
    return NSOrderedSame;
    
*/    
    return [a_string localizedCaseInsensitiveCompare:b_string];
}


@implementation PlaytomicRequest

+ (NSString*) EscapeString:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    string = [string stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    string = [string stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    string = [string stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    return string;
}

+ (void) sendRequestUrl:(NSString*)url
             andSection:(NSString*)section 
              andAction:(NSString*)action 
    andCompleteDelegate:(id)completeDelegate
    andCompleteSelector:(SEL)completeSelector
            andPostData:(NSDictionary*)postData
{
    NSString *newUrl = [NSString stringWithFormat:@"%@&r=%dZ", url,arc4random()];
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:newUrl]];
    
    [request setDelegate:completeDelegate];
    request.didFinishSelector = completeSelector;

    
    
    NSDate *today = [NSDate date];
    
    NSTimeInterval time = [today timeIntervalSince1970];
    
    NSString *timestamp = [[NSString stringWithFormat:@"%f" , time] substringToIndex:10];
    
    NSString *nonce = [PlaytomicEncrypt md5: [NSString stringWithFormat:@"%f%@", time * arc4random(), [Playtomic getGameGuid] ]];
    
    NSMutableArray* pd = [NSMutableArray array];
    
    [pd addObject:[NSString stringWithFormat:@"nonce=%@", nonce]];
    [pd addObject:[NSString stringWithFormat:@"timestamp=%@", timestamp]];
    
    for(id customfield in postData)
    {
        [pd addObject:[NSString stringWithFormat:@"%@=%@", customfield, 
                       [PlaytomicRequest EscapeString:[postData objectForKey:customfield] ]]];
    }
    
    [PlaytomicRequest generateKeyName:@"section" andKey:section andArray:pd];
    [PlaytomicRequest generateKeyName:@"action" andKey:action andArray:pd];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                           nonce, 
                           timestamp,
                           section, 
                           action, 
                           newUrl, 
                           [Playtomic getGameGuid]];
    [PlaytomicRequest generateKeyName:@"signature" andKey:signature andArray:pd];
    
    NSString* joinedArray = [PlaytomicRequest joinArray:pd];
    
    
    [request setPostValue:[PlaytomicRequest EscapeString:[PlaytomicEncrypt encodeBase64WithString:joinedArray]] forKey:@"data"];
    
    [request startAsynchronous];
}


+ (PlaytomicResponse*) sendRequestUrl:(NSString*)url
                           andSection:(NSString*)section                            
                            andAction:(NSString*)action 
                          andPostData:(NSDictionary*)postData
{
    NSString *newUrl = [NSString stringWithFormat:@"%@&debug=y&r=%dZ", url,arc4random()];


    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:newUrl]];
    

       
    NSDate *today = [NSDate date];
    
    NSTimeInterval time = [today timeIntervalSince1970];
    
    NSString *timestamp = [[NSString stringWithFormat:@"%f" , time] substringToIndex:10];
    
    NSString *nonce = [PlaytomicEncrypt md5: [NSString stringWithFormat:@"%f%@", time * arc4random(), [Playtomic getGameGuid] ]];
  
    NSMutableArray* pd = [NSMutableArray array];
    
    [pd addObject:[NSString stringWithFormat:@"nonce=%@", nonce]];
    [pd addObject:[NSString stringWithFormat:@"timestamp=%@", timestamp]];
    
    for(id customfield in postData)
    {
        [pd addObject:[NSString stringWithFormat:@"%@=%@", customfield, 
                       [PlaytomicRequest EscapeString:[postData objectForKey:customfield] ]]];
    }
    
    [PlaytomicRequest generateKeyName:@"section" andKey:section andArray:pd];
    [PlaytomicRequest generateKeyName:@"action" andKey:action andArray:pd];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                           nonce, 
                           timestamp,
                           section, 
                           action, 
                           newUrl, 
                           [Playtomic getGameGuid]];
    [PlaytomicRequest generateKeyName:@"signature" andKey:signature andArray:pd];
    
    NSString* joinedArray = [PlaytomicRequest joinArray:pd];
    
   
    [request setPostValue:[PlaytomicRequest EscapeString:[PlaytomicEncrypt encodeBase64WithString:joinedArray]] forKey:@"data"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if(error)
    {
        //[request release];
        return [[[PlaytomicResponse alloc] initWithError:1] autorelease];
    }
    
    NSString *response = [request responseString];       
  
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
    
    [json release];
    [parser release];
    //[request release];
    if(status == 1)
    {
        NSDictionary *dvars = [data valueForKey:@"Data"];
              
        PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                             andErrorCode:errorcode 
                                                                                  andDict:dvars];
        [playtomicResponse autorelease];
        
        return playtomicResponse;
    }
    else
    {
        return [[[PlaytomicResponse alloc] initWithError:errorcode] autorelease];
    }

    return nil;
}

+ (void) generateKeyName:(NSString*)name andKey:(NSString*)key andArray:(NSMutableArray*)array
{
    [array sortUsingFunction:compareStringValue context:NULL];
    [array addObject:[NSString stringWithFormat:@"%@=%@", name, [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", [PlaytomicRequest joinArray:array], key]]]];
}

+ (NSString*) joinArray:(NSMutableArray*)array
{
    NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
    for(NSInteger i = 0; i < array.count; i++)
    {
        if(i > 0)
        {
            [returnString appendString:@"&"];
        }
        [returnString appendString:[array objectAtIndex:i]];
        
    }
    return returnString;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end

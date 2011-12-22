//
//  PlaytomicPlayerLevels.m
//  ObjectiveCTest
//
//  This file is part of the official Playtomic API for iOS games.  
//  Playtomic is a real time analytics platform for casual games 
//  and services that go in casual games.  If you haven't used it 
//  before check it out:
//  http://playtomic.com/
//
//  Created by ben at the above domain on 2/25/11.
//  Copyright 2011 Playtomic LLC. All rights reserved.
//
//  Documentation is available at:
//  http://playtomic.com/api/ios
//
// PLEASE NOTE:
// You may modify this SDK if you wish but be kind to our servers.  Be
// careful about modifying the analytics stuff as it may give you 
// borked reports.
//
// If you make any awesome improvements feel free to let us know!
//
// -------------------------------------------------------------------------
// THIS SOFTWARE IS PROVIDED BY PLAYTOMIC, LLC "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "PlaytomicLevel.h"
#import "PlaytomicResponse.h"
#import "Playtomic.h"
#import "JSON/JSON.h"
#import "ASI/ASIFormDataRequest.h"
#import "ASI/ASIHTTPRequest.h"
#import "PlaytomicRequest.h"
#include "PlaytomicEncrypt.h"

@interface PlaytomicPlayerLevels() 

- (void)requestLoadFinished:(ASIHTTPRequest*)request;
- (void)requestRateFinished:(ASIHTTPRequest*)request;
- (void)requestListFinished:(ASIHTTPRequest*)request;
- (void)requestSaveFinished:(ASIHTTPRequest*)request;

- (void)addLevel:(NSDictionary*)level 
      ForLevelid:(NSString*)levelid 
         ToArray:(NSMutableArray*)md;

@end

@implementation PlaytomicPlayerLevels

// synchronous calls
//
- (PlaytomicResponse*)loadLevelid:(NSString*)levelid
{   
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-load-", [Playtomic getApiKey]]];
    
    [postData setObject:levelid forKey:@"levelid"];
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];

      
    if(![response success])
    {
        return response;
    }    
    // level list completed
    NSDictionary *level = [response dictionary];
    NSMutableArray *md = [[NSMutableArray alloc] init];
    
    [self addLevel:level 
        ForLevelid:levelid 
           ToArray:md];
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:1];
    [playtomicResponse autorelease];
    [md release];

    return playtomicResponse;
}

- (PlaytomicResponse*)rateLevelid:(NSString*)levelid 
                        andRating:(NSInteger)rating
{
    if(rating < 1 || rating > 10)
    {
        return [[[PlaytomicResponse alloc] initWithError:401] autorelease];
    }
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-rate-", [Playtomic getApiKey]]];
    
    [postData setObject:levelid forKey:@"levelid"];
    [postData setObject:[NSString stringWithFormat:@"%d", rating] forKey:@"rating"];

    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
      
    return response;
}

- (PlaytomicResponse*)listMode:(NSString*)mode 
                       andPage:(NSInteger)page 
                    andPerPage:(NSInteger)perpage 
                andIncludeData:(Boolean)includedata 
              andIncludeThumbs:(Boolean)includethumbs 
               andCustomFilter:(NSDictionary*)customfilter
{
    return [self listWithDateRangeMode:mode 
                               andPage:page 
                            andPerPage:perpage 
                        andIncludeData:includedata 
                      andIncludeThumbs:includethumbs 
                       andCustomFilter:customfilter 
                            andDateMin:nil 
                            andDateMax:nil];
}

- (PlaytomicResponse*)listWithDateRangeMode:(NSString*)mode 
                                    andPage:(NSInteger)page
                                 andPerPage:(NSInteger)perpage
                             andIncludeData:(Boolean)includedata
                           andIncludeThumbs:(Boolean)includethumbs
                            andCustomFilter:(NSDictionary*)customfilter
                                 andDateMin:(NSDate*)datemin
                                 andDateMax:(NSDate*)datemax
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    NSString *modesafe = mode == nil ? @"popular" : (mode == @"newest" || mode == @"popular" ? mode : @"popular");
    NSString *datasafe = includedata ? @"y" : @"n";
    NSString *thumbsafe = includethumbs ? @"y" : @"n";
    NSString *dateminsafe = datemin == nil ? @"" : [df stringFromDate:datemin];
    NSString *datemaxsafe = datemax == nil ? @"" : [df stringFromDate:datemax];
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-list-", [Playtomic getApiKey]]];
    
    [postData setValue:modesafe forKey:@"mode"];
    [postData setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [postData setValue:[NSString stringWithFormat:@"%d", perpage] forKey:@"perpage"];
    [postData setValue:datasafe forKey:@"data"];
    [postData setValue:thumbsafe forKey:@"thumbs"];
    [postData setValue:dateminsafe forKey:@"datemin"];
    [postData setValue:datemaxsafe forKey:@"datemax"];
    
    [postData setValue:[NSString stringWithFormat:@"%d", numfilters] forKey:@"filters"];
    if(customfilter != nil)
    {
        NSInteger fieldnumber = 0;
            
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setValue:customfield forKey:ckey];
            [postData setValue:value forKey:cdata];
        }
    }
        
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];    
    
    if(![response success])
    {
        [df release];
        return response;
    }    
    // level list completed
    NSDictionary *dvars = [response dictionary]; 
    NSArray *levels = [dvars valueForKey:@"Levels"];
    NSInteger numlevels = [[dvars valueForKey:@"NumLevels"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
        
    //NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    //[nf setFormatterBehavior:NSNumberFormatterDecimalStyle];
    
    for(id level in levels)
    {
        NSString *levelid = [level valueForKey:@"LevelId"];
        
        [self addLevel:level 
            ForLevelid:levelid 
               ToArray:md];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numlevels];
    [playtomicResponse autorelease];
    [df release];
    [md release];
    
    return playtomicResponse;
}

- (PlaytomicResponse*)saveLevel:(PlaytomicLevel*)level
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-save-", [Playtomic getApiKey]]];
    
    NSString *safeSource = [level getPlayerSource] != nil ?[level getPlayerSource] : @" ";
    NSString *safePlayerId = [level getPlayerId] != nil ? [level getPlayerId] : @" ";
    NSString *safePlayerName = [level getPlayerName] != nil ? [level getPlayerName] : @" ";
    NSString *safeData = [level getData] != nil ? [level getData] : @" ";
    NSString *safeName = [level getName] != nil ? [level getName] : @" ";
  
    
    
    
    [postData setValue:safePlayerId forKey:@"playerid"];
    [postData setValue:safeSource forKey:@"playersource"];
    [postData setValue:safePlayerName forKey:@"playername"];
    [postData setValue:safeData forKey:@"data"];
    [postData setValue:safeName forKey:@"name"];
    [postData setValue:@"y" forKey:@"nothumb"];
       
    
    NSDictionary *customdata = [level getCustomData];
    [postData setValue:[NSString stringWithFormat:@"%d"
                        , [customdata count]] forKey:@"customfields"];
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setValue:customfield forKey:ckey];
        [postData setValue:value forKey:cdata];
    }
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];    
    
    if(![response success])
    {
        return response;
    }    
    
    
    NSDictionary *dvars = [response dictionary]; 
    NSString *levelid = [dvars valueForKey:@"LevelId"];
       
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setValue:levelid forKey:@"LevelId"];
        
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                             andErrorCode:[response errorCode] 
                                                                                  andDict:md];
    [playtomicResponse autorelease];
    [md release];
                
    return playtomicResponse;

}

// asynchronous calls
//
- (void)loadAsyncLevelid:(NSString*)levelid 
             andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    levelid_ = [levelid copy];
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-load-", [Playtomic getApiKey]]];
    
    [postData setObject:levelid forKey:@"levelid"];
    delegate = aDelegate;
    [PlaytomicRequest sendRequestUrl:url andSection:section
                          andAction:action andCompleteDelegate:self
                andCompleteSelector:@selector(requestLoadFinished:)
                        andPostData:postData];
    
}

- (void)requestLoadFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestLoadPlayerLevelsFinished:)])) {
        return;
    }
       
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate requestLoadPlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    // we got a response of some kind
    NSString *response = [request responseString];
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    
    [json release];
    [parser release];
    
    // failed on the server side
    if(status != 1)
    {
        NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
        [delegate requestLoadPlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    // level list completed
    NSDictionary *level = [data valueForKey:@"Data"];
    NSMutableArray *md = [[NSMutableArray alloc] init];
    
    [self addLevel:level 
        ForLevelid:levelid_ 
           ToArray:md];
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:1];
    [playtomicResponse autorelease];
    [md release];
    [delegate requestLoadPlayerLevelsFinished:playtomicResponse];
}

- (void)rateAsyncLevelid:(NSString*)levelid 
               andRating:(NSInteger)rating 
             andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    if(rating < 1 || rating > 10)
    {
        if (aDelegate && [aDelegate respondsToSelector:@selector(requestRatePlayerLevelsFinished:)]) {
            [aDelegate requestRatePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:401] autorelease]];            
        }
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-rate-", [Playtomic getApiKey]]];
    
    [postData setObject:levelid forKey:@"levelid"];
    [postData setObject:[NSString stringWithFormat:@"%d", rating] forKey:@"rating"];
    
    delegate = aDelegate;    
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestRateFinished:) andPostData:postData];
    
}

- (void)requestRateFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestRatePlayerLevelsFinished:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate requestRatePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    // we got a response of some kind
    NSString *response = [request responseString];
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
    
    //[request autorelrease];
    [json release];
    [parser release];
    
    // failed on the server side
    if(status != 1)
    {
        [delegate requestRatePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    [delegate requestRatePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithSuccess:YES andErrorCode:errorcode] autorelease]];
}

- (void)listAsyncMode:(NSString*)mode 
              andPage:(NSInteger)page 
           andPerPage:(NSInteger)perpage 
       andIncludeData:(Boolean)includedata 
     andIncludeThumbs:(Boolean)includethumbs 
      andCustomFilter:(NSDictionary*)customfilter 
          andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self listWithDateRangeAsyncMode:mode 
                             andPage:page 
                          andPerPage:perpage 
                      andIncludeData:includedata 
                    andIncludeThumbs:includethumbs 
                     andCustomFilter:customfilter 
                          andDateMin:nil 
                          andDateMax:nil 
                         andDelegate:aDelegate];
}

- (void)listWithDateRangeAsyncMode:(NSString*)mode 
                           andPage:(NSInteger)page 
                        andPerPage:(NSInteger)perpage 
                    andIncludeData:(Boolean)includedata 
                  andIncludeThumbs:(Boolean)includethumbs 
                   andCustomFilter:(NSDictionary*)customfilter 
                        andDateMin:(NSDate*)datemin 
                        andDateMax:(NSDate*)datemax 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString *modesafe = mode == nil ? @"popular" : (mode == @"newest" || mode == @"popular" ? mode : @"popular");
    NSString *datasafe = includedata ? @"y" : @"n";
    NSString *thumbsafe = includethumbs ? @"y" : @"n";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *dateminsafe = datemin == nil ? @"" : [df stringFromDate:datemin];
    NSString *datemaxsafe = datemax == nil ? @"" : [df stringFromDate:datemax];
    [df release];
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-list-", [Playtomic getApiKey]]];
    
    [postData setValue:modesafe forKey:@"mode"];
    [postData setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [postData setValue:[NSString stringWithFormat:@"%d", perpage] forKey:@"perpage"];
    [postData setValue:datasafe forKey:@"data"];
    [postData setValue:thumbsafe forKey:@"thumbs"];
    [postData setValue:dateminsafe forKey:@"datemin"];
    [postData setValue:datemaxsafe forKey:@"datemax"];
    
    [postData setValue:[NSString stringWithFormat:@"%d", numfilters] forKey:@"filters"];
    if(customfilter != nil)
    {
        NSInteger fieldnumber = 0;
        
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setValue:customfield forKey:ckey];
            [postData setValue:value forKey:cdata];
        }
    }
    
    [PlaytomicRequest sendRequestUrl:url 
                          andSection:section 
                           andAction:action
                 andCompleteDelegate:self 
                 andCompleteSelector:@selector(requestLoadFinished:)
                         andPostData:postData];       
    delegate = aDelegate;
}

- (void)requestListFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestListPlayerLevelsFinished:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate requestListPlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    // we got a response of some kind
    NSString *response = [request responseString];
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    
    //[request autorelease];
    [json release];
    [parser release];
    
    // failed on the server side
    if(status != 1)
    {
        NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
        [delegate requestListPlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    // level list completed
    NSDictionary *dvars = [data valueForKey:@"Data"];
    NSArray *levels = [dvars valueForKey:@"Levels"];
    NSInteger numlevels = [[dvars valueForKey:@"NumLevels"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
    
    for(id level in levels)
    {
        NSString* levelid = [level valueForKey:@"LevelId"];
        
        [self addLevel:level 
            ForLevelid:levelid 
               ToArray:md];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numlevels];
    [playtomicResponse autorelease];
    [md release];
    
    [delegate requestListPlayerLevelsFinished:playtomicResponse];
}

- (void)saveAsyncLevel:(PlaytomicLevel*)level 
           andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"playerlevels-save-", [Playtomic getApiKey]]];
    
    
    NSString *safeSource = [level getPlayerSource] != nil ?[level getPlayerSource] : @" ";
    NSString *safePlayerId = [level getPlayerId] != nil ? [level getPlayerId] : @" ";
    NSString *safePlayerName = [level getPlayerName] != nil ? [level getPlayerName] : @" ";
    NSString *safeData = [level getData] != nil ? [level getData] : @" ";
    NSString *safeName = [level getName] != nil ? [level getName] : @" ";
    
    
    
    
    [postData setValue:safePlayerId forKey:@"playerid"];
    [postData setValue:safeSource forKey:@"playersource"];
    [postData setValue:safePlayerName forKey:@"playername"];
    [postData setValue:safeData forKey:@"data"];
    [postData setValue:safeName forKey:@"name"];
    [postData setValue:@"y" forKey:@"nothumb"];
    
    
    NSDictionary *customdata = [level getCustomData];
    [postData setValue:[NSString stringWithFormat:@"%d"
                        , [customdata count]] forKey:@"customfields"];
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setValue:customfield forKey:ckey];
        [postData setValue:value forKey:cdata];
    }
    delegate = aDelegate;
    [PlaytomicRequest sendRequestUrl:url
                          andSection:section
                           andAction:action
                         andCompleteDelegate:self 
                 andCompleteSelector:@selector(requestSaveFinished:) 
                         andPostData:postData];    
    
}

- (void)requestSaveFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestListPlayerLevelsFinished:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    if(error)
    {
        [delegate requestSavePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    NSString *response = [request responseString];       
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
    
    [json release];
    [parser release];
    
    if(status == 1)
    {
        NSDictionary *dvars = [data valueForKey:@"Data"];
        NSString *levelid = [dvars valueForKey:@"LevelId"];
        
        NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
        [md setValue:levelid forKey:@"LevelId"];
        
        PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                             andErrorCode:errorcode 
                                                                                  andDict:md];
        [playtomicResponse autorelease];
        [md release];
        
        [delegate requestSavePlayerLevelsFinished:playtomicResponse];
    }
    else
    {
        [delegate requestSavePlayerLevelsFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
    }
}


-(void) startLevel:(NSString*)levelid
{
    [[Playtomic Log] playerLevelStartLevelid:levelid];
}

-(void) retryLevel:(NSString*)levelid
{
    [[Playtomic Log] playerLevelRetryLevelid:levelid];
}

-(void) winLevel:(NSString*)levelid
{
    [[Playtomic Log] playerLevelWinLevelid:levelid];
}

-(void) quitLevel:(NSString*)levelid
{
    [[Playtomic Log] playerLevelQuitLevelid:levelid];
}

-(void) flagLevel:(NSString*)levelid
{
    [[Playtomic Log] playerLevelFlagLevelid:levelid];
}

- (NSString*) clean:(NSString*)string
{    
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

- (void)addLevel:(NSDictionary*)level 
      ForLevelid:(NSString*)levelid 
         ToArray:(NSMutableArray*)md  
{    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    //NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    //[nf setFormatterBehavior:NSNumberFormatterDecimalStyle];
    
    NSString *playerid = [level valueForKey:@"PlayerId"];
    NSString *playername = [[level valueForKey:@"PlayerName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *playersource = [level valueForKey:@"PlayerSource"];
    NSString *name = [[level valueForKey:@"Name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ldata = [[level valueForKey:@"Data"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *lthumb = [level valueForKey:@"Thumb"];
    NSInteger plays = [[level valueForKey:@"Plays"] integerValue];
    NSInteger votes = [[level valueForKey:@"Votes"] integerValue];
    NSInteger score = [[level valueForKey:@"Score"] integerValue];
    NSDecimalNumber *rating = [level valueForKey:@"Rating"];
    NSString *relativedate = [level valueForKey:@"RDate"];
    NSDate *date = [df dateFromString: [level valueForKey:@"SDate"]];   
    NSMutableDictionary *customdata = [[NSMutableDictionary alloc] init]; 
    NSDictionary *returnedcustomdata = [level valueForKey:@"CustomData"];    
    
    for(id key in returnedcustomdata)
    {
        NSString *cvalue = [[returnedcustomdata valueForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cvalue = [cvalue stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        [customdata setObject:cvalue forKey:key];
    }
    
    [md addObject:[[[PlaytomicLevel alloc] initWithName:name 
                                         andPlayerName:playername 
                                           andPlayerId:playerid 
                                       andPlayerSource:playersource 
                                               andData:ldata 
                                              andThumb:lthumb 
                                              andVotes:votes 
                                              andPlays:plays 
                                             andRating:rating 
                                              andScore:score 
                                               andDate:date 
                                       andRelativeDate:relativedate 
                                         andCustomData:customdata
                                            andLevelId:levelid] autorelease]];
    
    [df release];
    [customdata release];
}

- (void)dealloc {
    [levelid_ release];
    [super dealloc];
}

@end

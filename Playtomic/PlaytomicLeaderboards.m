//
//  Leaderboards.m
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

#import "PlaytomicLeaderboards.h"
#import "PlaytomicResponse.h"
#import "Playtomic.h"
#import "PlaytomicScore.h"
#import "PlaytomicEncrypt.h"
#import "PlaytomicRequest.h"
#import "JSON/JSON.h"
#import "ASI/ASIFormDataRequest.h"
#import "ASI/ASIHTTPRequest.h"
#import "PlaytomicPrivateLeaderboard.h"


@interface PlaytomicLeaderboards() 

- (void)requestSaveFinished:(ASIHTTPRequest*)request;
- (void)requestListFinished:(ASIHTTPRequest*)request;
- (void)requestSaveAndListFinished:(ASIHTTPRequest*)request;
- (void)requestCreatePrivateFinished:(ASIHTTPRequest*) request;
- (void)requestLoadPrivateFinished:(ASIHTTPRequest*) request;

@end

@implementation PlaytomicLeaderboards

// synchronous calls
//

- (PlaytomicResponse*)saveTable:(NSString*)table 
                       andScore:(PlaytomicScore*)score 
                     andHighest:(Boolean)highest 
             andAllowDuplicates:(Boolean)allowduplicates
{        

    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
    // save fields
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:[score getName] forKey:@"name"];
    [postData setObject:@"n" forKey:@"fb"];
    [postData setObject:@" " forKey:@"fbuserid"];
    [postData setObject:[NSString stringWithFormat:@"%d", [score getPoints]] forKey:@"points"];
    [postData setObject:(allowduplicates ? @"y" : @"n") forKey:@"allowduplicates"];
    [postData setObject:[PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%d",[Playtomic getBaseUrl], [score getPoints]]] forKey:@"auth"];
    
    
    
    
    NSDictionary* customdata = [score getCustomData];
    [postData setObject:[NSString stringWithFormat:@"%d", [customdata count]]  forKey:@"customfields"]; 
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setObject:customfield  forKey:ckey]; 
        [postData setObject:value  forKey:cdata]; 
    }


      
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-save-", [Playtomic getApiKey]]];
    
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    
    return response;
    
}
    



- (PlaytomicResponse*)listTable:(NSString*)table 
                     andHighest:(Boolean)highest 
                        andMode:(NSString*)mode 
                        andPage:(NSInteger)page 
                     andPerPage:(NSInteger)perpage 
                andCustomFilter:(NSDictionary*)customfilter
{
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
        
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
   
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:mode  forKey:@"mode"]; 
    [postData setObject:@"y"  forKey:@"global"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", perpage]  forKey:@"perpage"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", numfilters]  forKey:@"filters"];
    [postData setObject:[NSString stringWithFormat:@"%d" , page]  forKey:@"page"]; 
    
    if(numfilters > 0)
    {
        NSInteger fieldnumber = 0;
        
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"lkey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"ldata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setObject:customfield  forKey:ckey]; 
            [postData setObject:value  forKey:cdata]; 
        }
    }
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-list-", [Playtomic getApiKey]]];

    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    
    
    
    // failed on the client / connectivty side
    if(![response success])
    {
        return response;
    }
    
    // we got a response of some kind
      
    // score list completed
    NSDictionary *dvars = [response dictionary];
    NSArray *scores = [dvars valueForKey:@"Scores"];
    NSInteger numscores = [[dvars valueForKey:@"NumScores"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    for(id score in scores)
    {
        NSString *username = [score valueForKey:@"Name"];
        NSInteger points = [[score valueForKey:@"Points"] integerValue];
        NSString *relativedate = [score valueForKey:@"RDate"];
        NSDate *date = [df dateFromString:[score valueForKey:@"SDate"]];
        long rank = [[score valueForKey:@"Rank"] doubleValue];
        NSMutableDictionary *customdata = [[[NSMutableDictionary alloc] init] autorelease];
        
        NSDictionary *returnedcustomdata = [score valueForKey:@"CustomData"];
        
        for(id key in returnedcustomdata)
        {
            NSString *cvalue = [[returnedcustomdata valueForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cvalue = [cvalue stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            [customdata setObject:cvalue forKey:key];
        }
        
        [md addObject:[[[PlaytomicScore alloc] initWithName:username 
                                                 andPoints:points 
                                                   andDate:date 
                                           andRelativeDate:relativedate 
                                             andCustomData:customdata 
                                                   andRank:rank] autorelease]];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numscores];
    [playtomicResponse autorelease];
    [df release];
    [md release];
    
    return playtomicResponse;
}

- (PlaytomicResponse*)saveAndListTable:(NSString*)table 
                              andScore:(PlaytomicScore*)score 
                            andHighest:(Boolean)highest 
                    andAllowDuplicates:(Boolean)allowduplicates 
                               andMode:(NSString*)mode 
                            andPerPage:(NSInteger)perpage 
                       andCustomFilter:(NSDictionary*) customfilter
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                                                , [Playtomic getGameGuid]
                                                , [Playtomic getGameId]];
    
      
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    

    
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
    // save fields
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:[score getName] forKey:@"name"];
    [postData setObject:[NSString stringWithFormat:@"%d", [score getPoints]] forKey:@"points"];
    [postData setObject:(allowduplicates ? @"y" : @"n") forKey:@"allowduplicates"];
    [postData setObject:[PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%d",[Playtomic getBaseUrl], [score getPoints]]] forKey:@"auth"];

   
   
    
    NSDictionary* customdata = [score getCustomData];
    [postData setObject:[NSString stringWithFormat:@"%d", [customdata count]]  forKey:@"numfields"]; 
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setObject:customfield  forKey:ckey]; 
        [postData setObject:value  forKey:cdata]; 
    }
    
    // list fields
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
    
    
    [postData setObject:mode  forKey:@"mode"]; 
    [postData setObject:@"y"  forKey:@"global"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", perpage]  forKey:@"perpage"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", numfilters]  forKey:@"numfilters"];
    [postData setObject:@"1"  forKey:@"page"]; 
    
    if(numfilters > 0)
    {
        NSInteger fieldnumber = 0;
        
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"lkey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"ldata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setObject:customfield  forKey:ckey]; 
            [postData setObject:value  forKey:cdata]; 
        }
    }
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-saveandlist-", [Playtomic getApiKey]]];
    
    
       
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    /////////////////////////////////////////
    
    if(![response success])
    {
        return response;
    }
        
    // score list completed
    NSDictionary *dvars = [response dictionary];
    NSArray *scores = [dvars valueForKey:@"Scores"];
    NSInteger numscores = [[dvars valueForKey:@"NumScores"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    for(id score in scores)
    {
        NSString *username = [score valueForKey:@"Name"];
        NSInteger points = [[score valueForKey:@"Points"] integerValue];
        NSString *relativedate = [score valueForKey:@"RDate"];
        NSDate *date = [df dateFromString:[score valueForKey:@"SDate"]];
        long rank = [[score valueForKey:@"Rank"] doubleValue];
        NSMutableDictionary *customdata = [[NSMutableDictionary alloc] init];
        
        NSDictionary *returnedcustomdata = [score valueForKey:@"CustomData"];
        
        for(id key in returnedcustomdata)
        {
            NSString *cvalue = [[returnedcustomdata valueForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cvalue = [cvalue stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            [customdata setObject:cvalue forKey:key];
        }
        
        [md addObject:[[[PlaytomicScore alloc] initWithName:username 
                                                 andPoints:points 
                                                   andDate:date 
                                           andRelativeDate:relativedate 
                                             andCustomData:customdata 
                                                   andRank:rank] autorelease]];        
        [customdata release];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numscores];
    [playtomicResponse autorelease];
    [df release];
    [md release];
    
    return playtomicResponse;
}

- (PlaytomicResponse*) createPrivateLeaderboardName:(NSString *)name andHighest:(Boolean)highest
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:name forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    [postData setObject:[NSString stringWithFormat:@"http://%@.com", name] forKey:@"permalink"];
    
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-createprivateleaderboard-", [Playtomic getApiKey]]];
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    /////////////////////////////////////////
    
    if(![response success])
    {
        return response;
    }
    
    // score list completed
    NSDictionary *dvars = [response dictionary];
    
    PlaytomicPrivateLeaderboard* leaderboard = [[[PlaytomicPrivateLeaderboard alloc]
                                                initWithName:[dvars objectForKey:@"Name"] 
                                                andTableId:[dvars objectForKey:@"TableId"]
                                                andPermalink:[dvars objectForKey:@"Bitly"]
                                                andHighest:[[dvars objectForKey:@"Highest"] boolValue]
                                                andRealName:[dvars objectForKey:@"RealName"]] autorelease];

    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setValue:leaderboard forKey:@"leaderboard"];
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:[response errorCode] 
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    
    return playtomicResponse;

}

-(PlaytomicResponse*)loadPrivateLeaderboardTableId:(NSString*)tableid
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:tableid forKey:@"tableid"];

    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-loadprivateleaderboard-", [Playtomic getApiKey]]];
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    /////////////////////////////////////////
    
    if(![response success])
    {
        return response;
    }
    
    // score list completed
    NSDictionary *dvars = [response dictionary];
    
    PlaytomicPrivateLeaderboard* leaderboard = [[[PlaytomicPrivateLeaderboard alloc]
                                                 initWithName:[dvars objectForKey:@"Name"] 
                                                 andTableId:[dvars objectForKey:@"TableId"]
                                                 andPermalink:[dvars objectForKey:@"Bitly"]
                                                 andHighest:[[dvars objectForKey:@"Highest"] boolValue]
                                                 andRealName:[dvars objectForKey:@"RealName"]] autorelease];
    
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setValue:leaderboard forKey:@"leaderboard"];
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:[response errorCode] 
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    
    return playtomicResponse;
}
// asynchronous calls
//
- (void)saveAsyncTable:(NSString*)table 
              andScore:(PlaytomicScore*)score 
            andHighest:(Boolean)highest 
    andAllowDuplicates:(Boolean)allowduplicates 
           andDelegate:(id<PlaytomicDelegate>)aDelegate;
{     
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
    // save fields
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:[score getName] forKey:@"name"];
    [postData setObject:@"n" forKey:@"fb"];
    [postData setObject:@" " forKey:@"fbuserid"];
    [postData setObject:[NSString stringWithFormat:@"%d", [score getPoints]] forKey:@"points"];
    [postData setObject:(allowduplicates ? @"y" : @"n") forKey:@"allowduplicates"];
    [postData setObject:[PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%d",[Playtomic getBaseUrl], [score getPoints]]] forKey:@"auth"];
    
    
    
    
    NSDictionary* customdata = [score getCustomData];
    [postData setObject:[NSString stringWithFormat:@"%d", [customdata count]]  forKey:@"customfields"]; 
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setObject:customfield  forKey:ckey]; 
        [postData setObject:value  forKey:cdata]; 
    }
    
    
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-save-", [Playtomic getApiKey]]];
    delegate = aDelegate;
    
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestSaveFinished:) andPostData:postData];    
}

- (void)requestSaveFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestSaveLeaderboardFinished:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    if(error)
    {
        [delegate requestSaveLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    NSString *response = [request responseString];       
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    
    [json release];
    [parser release];
    
    if(status == 1)
    {
        NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
        [delegate requestSaveLeaderboardFinished:[[[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                                andErrorCode:errorcode] autorelease]]; 
    }
    else
    {
        //NSLog(@"failed here %@", response);
        NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
        [delegate requestSaveLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
    }
}

- (void)listAsyncTable:(NSString*)table 
            andHighest:(Boolean)highest 
               andMode:(NSString*)mode 
               andPage:(NSInteger)page 
            andPerPage:(NSInteger)perpage 
       andCustomFilter:(NSDictionary*)customfilter 
           andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
    
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:mode  forKey:@"mode"]; 
    [postData setObject:@"y"  forKey:@"global"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", perpage]  forKey:@"perpage"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", numfilters]  forKey:@"filters"];
    [postData setObject:[NSString stringWithFormat:@"%d" , page]  forKey:@"page"]; 
    
    if(numfilters > 0)
    {
        NSInteger fieldnumber = 0;
        
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"lkey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"ldata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setObject:customfield  forKey:ckey]; 
            [postData setObject:value  forKey:cdata]; 
        }
    }
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-list-", [Playtomic getApiKey]]];
    
    
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestListFinished:) andPostData:postData];
    
    delegate = aDelegate;    
}

- (void)requestListFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestListLeaderboardFinished:)])) {
        return;
    }

    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate requestListLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
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
        [delegate requestListLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
         return;
    }
    
    // score list completed
    NSDictionary *dvars = [data valueForKey:@"Data"];
    NSArray *scores = [dvars valueForKey:@"Scores"];
    NSInteger numscores = [[dvars valueForKey:@"NumScores"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    for(id score in scores)
    {
        NSString *username = [score valueForKey:@"Name"];
        NSInteger points = [[score valueForKey:@"Points"] integerValue];
        NSString *relativedate = [score valueForKey:@"RDate"];
        NSDate *date = [df dateFromString:[score valueForKey:@"SDate"]];
        long rank = [[score valueForKey:@"Rank"] doubleValue];
        NSMutableDictionary *customdata = [[[NSMutableDictionary alloc] init] autorelease];
        
        NSDictionary *returnedcustomdata = [score valueForKey:@"CustomData"];
        
        for(id key in returnedcustomdata)
        {
            NSString *cvalue = [[returnedcustomdata valueForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cvalue = [cvalue stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            [customdata setObject:cvalue forKey:key];
        }
        
        [md addObject:[[[PlaytomicScore alloc] initWithName:username 
                                                 andPoints:points 
                                                   andDate:date 
                                           andRelativeDate:relativedate 
                                             andCustomData:customdata 
                                                   andRank:rank] autorelease]];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numscores];
    [playtomicResponse autorelease];
    [df release];
    [md release];
    
    [delegate requestListLeaderboardFinished: playtomicResponse];    
}

- (void)saveAndListAsyncTable:(NSString*)table 
                     andScore:(PlaytomicScore*)score 
                   andHighest:(Boolean)highest 
           andAllowDuplicates:(Boolean)allowduplicates 
                      andMode:(NSString*)mode 
                   andPerPage:(NSInteger)perpage 
              andCustomFilter:(NSDictionary*)customfilter 
                  andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    
    // common fields
    [postData setObject:table forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    
    // save fields
    [postData setObject:[Playtomic getSourceUrl] forKey:@"url"];
    [postData setObject:[score getName] forKey:@"name"];
    [postData setObject:[NSString stringWithFormat:@"%d", [score getPoints]] forKey:@"points"];
    [postData setObject:(allowduplicates ? @"y" : @"n") forKey:@"allowduplicates"];
    [postData setObject:[PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%d",[Playtomic getBaseUrl], [score getPoints]]] forKey:@"auth"];
    
    
    
    
    NSDictionary* customdata = [score getCustomData];
    [postData setObject:[NSString stringWithFormat:@"%d", [customdata count]]  forKey:@"numfields"]; 
    NSInteger fieldnumber = 0;
    
    for(id customfield in customdata)
    {
        NSString *ckey = [NSString stringWithFormat:@"ckey%d", fieldnumber];
        NSString *cdata = [NSString stringWithFormat:@"cdata%d", fieldnumber];
        NSString *value = [customdata objectForKey:customfield];
        fieldnumber++;
        
        [postData setObject:customfield  forKey:ckey]; 
        [postData setObject:value  forKey:cdata]; 
    }
    
    // list fields
    NSInteger numfilters = customfilter == nil ? 0 : [customfilter count];
    
    
    [postData setObject:mode  forKey:@"mode"]; 
    [postData setObject:@"y"  forKey:@"global"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", perpage]  forKey:@"perpage"]; 
    [postData setObject:[NSString stringWithFormat:@"%d", numfilters]  forKey:@"numfilters"];
    [postData setObject:@"1"  forKey:@"page"]; 
    
    if(numfilters > 0)
    {
        NSInteger fieldnumber = 0;
        
        for(id customfield in customfilter)
        {
            NSString *ckey = [NSString stringWithFormat:@"lkey%d", fieldnumber];
            NSString *cdata = [NSString stringWithFormat:@"ldata%d", fieldnumber];
            NSString *value = [customfilter objectForKey:customfield];
            fieldnumber++;
            
            [postData setObject:customfield  forKey:ckey]; 
            [postData setObject:value  forKey:cdata]; 
        }
    }
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-saveandlist-", [Playtomic getApiKey]]];
    
    
    
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestSaveAndListFinished:) andPostData:postData];    
    delegate = aDelegate;
}

- (void)requestSaveAndListFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestSaveAndListLeaderboardFinished:)])) {
        return;
    }

    NSError *error = [request error];
    
    if(error)
    {
        [delegate requestSaveAndListLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
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
        [delegate requestSaveAndListLeaderboardFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    // score list completed
    NSDictionary *dvars = [data valueForKey:@"Data"];
    NSArray *scores = [dvars valueForKey:@"Scores"];
    NSInteger numscores = [[dvars valueForKey:@"NumScores"] integerValue];  
    NSMutableArray *md = [[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    for(id score in scores)
    {
        NSString *username = [score valueForKey:@"Name"];
        NSInteger points = [[score valueForKey:@"Points"] integerValue];
        NSString *relativedate = [score valueForKey:@"RDate"];
        NSDate *date = [df dateFromString:[score valueForKey:@"SDate"]];
        long rank = [[score valueForKey:@"Rank"] doubleValue];
        NSMutableDictionary *customdata = [[NSMutableDictionary alloc] init];
        
        NSDictionary *returnedcustomdata = [score valueForKey:@"CustomData"];
        
        for(id key in returnedcustomdata)
        {
            NSString *cvalue = [[returnedcustomdata valueForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cvalue = [cvalue stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            [customdata setObject:cvalue forKey:key];
        }
        
        [md addObject:[[[PlaytomicScore alloc] initWithName:username 
                                                 andPoints:points 
                                                   andDate:date 
                                           andRelativeDate:relativedate 
                                             andCustomData:customdata 
                                                   andRank:rank] autorelease]];
        
        [customdata release];
    }
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andData:md 
                                                                        andNumResults:numscores];
    [playtomicResponse autorelease];
    [df release];
    [md release];
    
    [delegate requestSaveAndListLeaderboardFinished:playtomicResponse];
}

-(void)createPrivateLeaderboardAsyncName:(NSString*)name 
                              andHighest:(Boolean)highest 
                             andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    delegate = aDelegate;
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];


    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:name forKey:@"table"];
    [postData setObject:(highest ? @"y" : @"n") forKey:@"highest"];
    [postData setObject:[NSString stringWithFormat:@"http://%@.com", name] forKey:@"permalink"];


    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-createprivateleaderboard-", [Playtomic getApiKey]]];

    [PlaytomicRequest sendRequestUrl:url 
                          andSection:section
                           andAction:action
                 andCompleteDelegate:self
                 andCompleteSelector:@selector(requestCreatePrivateFinished:)
                         andPostData:postData];
}
- (void)requestCreatePrivateFinished:(ASIHTTPRequest*) request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestCreateprivateLeaderboardFinish:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    if(error)
    {
        [delegate requestCreateprivateLeaderboardFinish:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
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
        [delegate requestCreateprivateLeaderboardFinish:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    // score list completed
    NSDictionary *dvars = [data valueForKey:@"Data"];
    
    PlaytomicPrivateLeaderboard* leaderboard = [[[PlaytomicPrivateLeaderboard alloc]
                                                 initWithName:[dvars objectForKey:@"Name"] 
                                                 andTableId:[dvars objectForKey:@"TableId"]
                                                 andPermalink:[dvars objectForKey:@"Bitly"]
                                                 andHighest:[[dvars objectForKey:@"Highest"] boolValue]
                                                 andRealName:[dvars objectForKey:@"RealName"]] autorelease];
    
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setValue:leaderboard forKey:@"leaderboard"];
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:[[data valueForKey:@"ErrorCode"] integerValue]
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    [delegate requestCreateprivateLeaderboardFinish: playtomicResponse];    

}

-(void)loadPrivateLeaderboardTableAsyncId:(NSString*)tableid 
                              andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    delegate = aDelegate;
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    // common fields
    [postData setObject:tableid forKey:@"tableid"];
    
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"leaderboards-loadprivateleaderboard-", [Playtomic getApiKey]]];
    
    [PlaytomicRequest sendRequestUrl:url 
                          andSection:section 
                           andAction:action 
                 andCompleteDelegate:self 
                 andCompleteSelector:@selector(requestLoadPrivateFinished:) 
                         andPostData:postData];
    
}

- (void)requestLoadPrivateFinished:(ASIHTTPRequest*) request
{
    if (!(delegate && [delegate respondsToSelector:@selector(requestLoadprivateLeaderboardFinish:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    if(error)
    {
        [delegate requestLoadprivateLeaderboardFinish:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
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
        [delegate requestLoadprivateLeaderboardFinish:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    // score list completed
    NSDictionary *dvars = [data valueForKey:@"Data"];
    
    PlaytomicPrivateLeaderboard* leaderboard = [[[PlaytomicPrivateLeaderboard alloc]
                                                 initWithName:[dvars objectForKey:@"Name"] 
                                                 andTableId:[dvars objectForKey:@"TableId"]
                                                 andPermalink:[dvars objectForKey:@"Bitly"]
                                                 andHighest:[[dvars objectForKey:@"Highest"] boolValue]
                                                 andRealName:[dvars objectForKey:@"RealName"]] autorelease];
    
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    [md setValue:leaderboard forKey:@"leaderboard"];
    
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:[[data valueForKey:@"ErrorCode"] integerValue]
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    [delegate requestLoadprivateLeaderboardFinish: playtomicResponse];  
}
@end

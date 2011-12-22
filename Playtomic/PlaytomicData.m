//
//  PlaytomicLink.h
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

#import "PlaytomicData.h"
#import "PlaytomicResponse.h"
#import "Playtomic.h"
#import "JSON/JSON.h"
#import "ASI/ASIHTTPRequest.h"
#import "PlaytomicRequest.h"
#import "PlaytomicEncrypt.h"

@interface PlaytomicData()

- (void)requestGetDataFinished:(ASIHTTPRequest*)request;

@end

@implementation PlaytomicData

// general stats

// synchronous calls
//
- (PlaytomicResponse*)views
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"views" 
                      andDay:0
                    andMonth:0 
                     andYear:0];
}

- (PlaytomicResponse*)viewsMonth:(NSInteger)month 
                         andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"views" 
                      andDay:0 
                    andMonth:month 
                     andYear:year];
}

- (PlaytomicResponse*)viewsDay:(NSInteger)day 
                      andMonth:(NSInteger)month 
                       andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"views" 
                      andDay:day 
                    andMonth:month 
                     andYear:year];
}

- (PlaytomicResponse*)plays
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"plays" 
                      andDay:0
                    andMonth:0 
                     andYear:0];
}

- (PlaytomicResponse*)playsMonth:(NSInteger)month 
                         andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"plays" 
                      andDay:0
                    andMonth:month
                     andYear:year];
}

- (PlaytomicResponse*)playsDay:(NSInteger)day 
                      andMonth:(NSInteger)month 
                       andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"plays" 
                      andDay:day 
                    andMonth:month 
                     andYear:year];

}

- (PlaytomicResponse*)playtime
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"playtime" 
                      andDay:0
                    andMonth:0 
                     andYear:0];

}

- (PlaytomicResponse*)playtimeMonth:(NSInteger)month 
                            andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];
    
    return [self generalMode:action 
                     andType:@"playtime" 
                      andDay:0
                    andMonth:month 
                     andYear:year];

}

- (PlaytomicResponse*)playtimeDay:(NSInteger)day 
                         andMonth:(NSInteger)month 
                          andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];

    return [self generalMode:action 
                     andType:@"playtime" 
                      andDay:day 
                    andMonth:month 
                     andYear:year];
}

- (PlaytomicResponse*)generalMode:(NSString*)mode 
                          andType:(NSString*)type
                           andDay:(NSInteger)day 
                         andMonth:(NSInteger)month 
                          andYear:(NSInteger)year
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
      
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:type forKey:@"type"];
    return [PlaytomicRequest sendRequestUrl:url andSection:section andAction:mode andPostData:postData];
}

// custom metrics
- (PlaytomicResponse*)customMetricName:(NSString*)name
{
    return [self customMetricName:name 
                           andDay:0 
                         andMonth:0 
                          andYear:0];
}

- (PlaytomicResponse*)customMetricName:(NSString*)name 
                              andMonth:(NSInteger)month 
                               andYear:(NSInteger)year
{
    return [self customMetricName:name 
                           andDay:0 
                         andMonth:month 
                          andYear:year];
}

- (PlaytomicResponse*)customMetricName:(NSString*)name 
                                andDay:(NSInteger)day 
                              andMonth:(NSInteger)month 
                               andYear:(NSInteger)year
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-custommetric-", [Playtomic getApiKey]]];
    
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:name forKey:@"metric"];
    return [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
}

// level counters
- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                                    andLevel:(NSString*)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:0 
                        andMonth:0 
                         andYear:0];
}

- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:0
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:0
                         andYear:0];
}

- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelCounterMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

// level averages
- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                                    andLevel:(NSString*)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:0 
                        andMonth:0 
                         andYear:0];
}

- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:0 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:0 
                         andYear:0];
}

- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:month 
                         andYear:year];}

- (PlaytomicResponse*)levelAverageMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragemetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

// level rangeds
- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                                   andLevel:(NSString*)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level 
                          andDay:0 
                        andMonth:0 
                         andYear:0];
}

- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                                   andLevel:(NSString*)level 
                                   andMonth:(NSInteger)month 
                                    andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level 
                          andDay:0
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                                   andLevel:(NSString*)level 
                                     andDay:(NSInteger)day 
                                   andMonth:(NSInteger)month
                                    andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:level 
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                             andLevelNumber:(NSInteger)level
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:0 
                         andYear:0];
}

- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                             andLevelNumber:(NSInteger)level 
                                   andMonth:(NSInteger)month 
                                    andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:0 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelRangedMetricName:(NSString*)name 
                             andLevelNumber:(NSInteger)level 
                                     andDay:(NSInteger)day 
                                   andMonth:(NSInteger)month 
                                    andYear:(NSInteger)year
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    return [self levelMetricType:action 
                         andName:name 
                        andLevel:[NSString stringWithFormat:@"%d", level] 
                          andDay:day 
                        andMonth:month 
                         andYear:year];
}

- (PlaytomicResponse*)levelMetricType:(NSString*)type 
                              andName:(NSString*)name 
                             andLevel:(NSString*)level 
                               andDay:(NSInteger)day 
                             andMonth:(NSInteger)month 
                              andYear:(NSInteger)year
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
    
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:name forKey:@"metric"];
    [postData setValue:level forKey:@"level"];
    return [PlaytomicRequest sendRequestUrl:url andSection:section andAction:type andPostData:postData];
}

// get data
- (PlaytomicResponse*)getDataUrl:(NSString*)url
{    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        return [[[PlaytomicResponse alloc] initWithError:1] autorelease];
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
        return [[[PlaytomicResponse alloc] initWithError:errorcode] autorelease];
    }
    
    NSDictionary *dvars = [data valueForKey:@"Data"];
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
    for(id key in dvars)
    {
        [md setObject:[dvars valueForKey:key] forKey:key];
    }
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    
    return playtomicResponse;
}

- (NSString*)clean:(NSString*)string
{    
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

// asynchronous calls
//
- (void)viewsAsync:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestViewsDataFinished:);
    requestFinished = @selector(requestViewsDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"views" 
                    andDay:0
                  andMonth:0 
                   andYear:0 
               andDelegate:aDelegate];
}

- (void)viewsAsyncMonth:(NSInteger)month 
                andYear:(NSInteger)year
            andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestViewsDataFinished:);
    requestFinished = @selector(requestViewsDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"views"
                    andDay:0 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)viewsAsyncDay:(NSInteger)day 
             andMonth:(NSInteger)month
              andYear:(NSInteger)year
          andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-views-", [Playtomic getApiKey]]];
    
    requestFinished = @selector(requestViewsDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"views" 
                    andDay:day 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)playsAsync:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestPlaysDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"plays" 
                    andDay:0 
                  andMonth:0 
                   andYear:0 
               andDelegate:aDelegate];
}

- (void)playsAsyncMonth:(NSInteger)month 
                andYear:(NSInteger)year 
            andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestPlaysDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"plays" 
                    andDay:0 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)playsAsyncDay:(NSInteger)day 
             andMonth:(NSInteger)month 
              andYear:(NSInteger)year 
          andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-plays-", [Playtomic getApiKey]]];
    
    requestFinished = @selector(requestPlaysDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"plays" 
                    andDay:day 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)playtimeAsync:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestPlaytimeDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"playtime" 
                    andDay:0 
                  andMonth:0 
                   andYear:0 
               andDelegate:aDelegate];
}

- (void)playtimeAsyncMonth:(NSInteger)month 
                   andYear:(NSInteger)year 
               andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];
    requestFinished = @selector(requestPlaytimeDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"playtime" 
                    andDay:0 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)playtimeAsyncDay:(NSInteger)day 
                andMonth:(NSInteger)month 
                 andYear:(NSInteger)year 
             andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-playtime-", [Playtomic getApiKey]]];
    
    requestFinished = @selector(requestPlaytimeDataFinished:);
    [self generalAsyncMode:action 
                   andType:@"playtime" 
                    andDay:day 
                  andMonth:month 
                   andYear:year 
               andDelegate:aDelegate];
}

- (void)generalAsyncMode:(NSString*)mode 
                 andType:(NSString*)type
                  andDay:(NSInteger)day 
                andMonth:(NSInteger)month 
                 andYear:(NSInteger)year 
             andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
    
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:type forKey:@"type"];
    delegate = aDelegate;
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:mode andCompleteDelegate:self andCompleteSelector:@selector(requestGetDataFinished:) andPostData:postData];
    
}

// custom metrics
- (void)customMetricAsyncName:(NSString*)name 
                  andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self customMetricAsyncName:name 
                         andDay:0 
                       andMonth:0 
                        andYear:0 
                    andDelegate:aDelegate];
}

- (void)customMetricAsyncName:(NSString*)name 
                     andMonth:(NSInteger)month 
                      andYear:(NSInteger)year 
                  andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self customMetricAsyncName:name 
                         andDay:0 
                       andMonth:month 
                        andYear:year 
                    andDelegate:aDelegate];
}

- (void)customMetricAsyncName:(NSString*)name 
                       andDay:(NSInteger)day 
                     andMonth:(NSInteger)month 
                      andYear:(NSInteger)year 
                  andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    delegate = aDelegate;
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-custommetric-", [Playtomic getApiKey]]];
    
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:name forKey:@"metric"];
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestGetDataFinished:) andPostData:postData];
    
    requestFinished = @selector(requestCustomMetricDataFinished:);
}

// level counters
- (void)levelCounterMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelCounterMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelCounterMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelCounterMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelCounterMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelCounterMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"counter" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

// level averages
- (void)levelAverageMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelAverageMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelAverageMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelAverageMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelAverageMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:month 
                       andYear:year
                   andDelegate:aDelegate];
}

- (void)levelAverageMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"average" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:day 
                      andMonth:month 
                       andYear:year 
                   andDelegate:aDelegate];
}

// level rangeds
- (void)levelRangedMetricAsyncName:(NSString*)name 
                          andLevel:(NSString*)level 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelRangedMetricAsyncName:(NSString*)name 
                          andLevel:(NSString*)level 
                          andMonth:(NSInteger)month 
                           andYear:(NSInteger)year 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name 
                      andLevel:level 
                        andDay:0 
                      andMonth:month 
                       andYear:year 
                   andDelegate:aDelegate];
}

- (void)levelRangedMetricAsyncName:(NSString*)name 
                          andLevel:(NSString*)level 
                            andDay:(NSInteger)day 
                          andMonth:(NSInteger)month
                           andYear:(NSInteger)year 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name
                      andLevel:level
                        andDay:day
                      andMonth:month
                       andYear:year
                   andDelegate:aDelegate];
}

- (void)levelRangedMetricAsyncName:(NSString*)name 
                    andLevelNumber:(NSInteger)level 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:0 
                      andMonth:0 
                       andYear:0 
                   andDelegate:aDelegate];
}

- (void)levelRangedMetricAsyncName:(NSString*)name 
                    andLevelNumber:(NSInteger)level
                          andMonth:(NSInteger)month 
                           andYear:(NSInteger)year 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level]
                        andDay:0 
                      andMonth:month 
                       andYear:year 
                   andDelegate:aDelegate];
}

- (void)levelRangedMetricAsyncName:(NSString*)name 
                    andLevelNumber:(NSInteger)level 
                            andDay:(NSInteger)day 
                          andMonth:(NSInteger)month 
                           andYear:(NSInteger)year 
                       andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    [self levelMetricAsyncType:@"ranged" 
                       andName:name 
                      andLevel:[NSString stringWithFormat:@"%d", level] 
                        andDay:day
                      andMonth:month
                       andYear:year
                   andDelegate:aDelegate];
}

- (void)levelMetricAsyncType:(NSString*)type 
                     andName:(NSString*)name 
                    andLevel:(NSString*)level 
                      andDay:(NSInteger)day 
                    andMonth:(NSInteger)month
                     andYear:(NSInteger)year 
                 andDelegate:(id<PlaytomicDelegate>)aDelegate
{
    if ([type isEqualToString:@"counter"])
    {
        requestFinished = @selector(requestLevelMetricCounterDataFinished:);
        type = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelcountermetric-", [Playtomic getApiKey]]];
    } 
    else if ([type isEqualToString:@"average"])
    {
        requestFinished = @selector(requestLevelMetricAverageDataFinished:);
        type = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelaveragedmetric-", [Playtomic getApiKey]]];
    }
    else
    {
        requestFinished = @selector(requestLevelMetricRangeDataFinished:);
        type = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-levelrangedmetric-", [Playtomic getApiKey]]];
    }
    
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=y"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"data-", [Playtomic getApiKey]]];
    
    [postData setValue:[NSString stringWithFormat:@"%d", day] forKey:@"day"];
    [postData setValue:[NSString stringWithFormat:@"%d", month] forKey:@"month"];
    [postData setValue:[NSString stringWithFormat:@"%d", year] forKey:@"year"];
    [postData setValue:level forKey:@"level"];
    [postData setValue:name forKey:@"metric"];
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:type  andCompleteDelegate:self andCompleteSelector:@selector(requestGetDataFinished:) andPostData:postData];
    delegate = aDelegate;
}

// get data
- (void)getDataAsyncUrl:(NSString*)url 
            andDelegate:(id<PlaytomicDelegate>)aDelegate
{    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];

    delegate = aDelegate;
    
    [request setDelegate:self];
    request.didFinishSelector = @selector(requestGetDataFinished:);
    [request startAsynchronous];
}

- (void)requestGetDataFinished:(ASIHTTPRequest*)request
{
    if (!(delegate && [delegate respondsToSelector:requestFinished]))
    {
        return;
    }
    
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate performSelector:requestFinished 
                       withObject:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
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
        [delegate performSelector:requestFinished 
                       withObject:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    NSDictionary *dvars = [data valueForKey:@"Data"];
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
    for(id key in dvars)
    {
        [md setObject:[dvars valueForKey:key] forKey:key];
    }
    PlaytomicResponse *playtomicResponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                         andErrorCode:0 
                                                                              andDict:md];
    [playtomicResponse autorelease];
    [md release];
    
    [delegate performSelector:requestFinished 
                   withObject:playtomicResponse];
}

@end

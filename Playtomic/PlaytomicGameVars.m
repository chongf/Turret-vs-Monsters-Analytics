//
//  GameVars.m
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
//

#import "Playtomic.h"
#import "PlaytomicGameVars.h"
#import "PlaytomicResponse.h"
#import "JSON/JSON.h"
#import "ASI/ASIHTTPRequest.h"
#import "PlaytomicRequest.h"
#import "PlaytomicEncrypt.h"

@interface PlaytomicGameVars() 

- (void)requestLoadFinished:(ASIHTTPRequest*)request;

@end

@implementation PlaytomicGameVars

- (PlaytomicResponse*)load
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=m"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"gamevars-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"gamevars-load-", [Playtomic getApiKey]]];
    
    
    PlaytomicResponse* response = [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andPostData:postData];
    // failed on the client / connectivty side
    if(![response success])
    {
        return response;
    }
    
    NSDictionary *dvars = [response dictionary];
        


    PlaytomicResponse *playtomicReponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                        andErrorCode:0 
                                                                             andDict:dvars];
    [playtomicReponse autorelease];

    
    return playtomicReponse;
}

- (void)loadAsync:(id<PlaytomicDelegate>)aDelegate
{
    NSString *url = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/v3/api.aspx?swfid=%d&js=m"
                     , [Playtomic getGameGuid]
                     , [Playtomic getGameId]];
    
    
    NSMutableDictionary * postData = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    
    NSString* section = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"gamevars-", [Playtomic getApiKey]]];
    NSString* action = [PlaytomicEncrypt md5:[NSString stringWithFormat:@"%@%@", @"gamevars-load-", [Playtomic getApiKey]]];
    
    delegate = aDelegate;
    [PlaytomicRequest sendRequestUrl:url andSection:section andAction:action andCompleteDelegate:self andCompleteSelector:@selector(requestLoadFinished:) andPostData:postData];
}

- (void)requestLoadFinished:(ASIHTTPRequest*)request
{    
    if (!(delegate && [delegate respondsToSelector:@selector(requestLoadGameVarsFinished:)])) {
        return;
    }
    
    NSError *error = [request error];
    
    // failed on the client / connectivty side
    if(error)
    {
        [delegate requestLoadGameVarsFinished:[[[PlaytomicResponse alloc] initWithError:1] autorelease]];
        return;
    }
    
    // we got a response of some kind
    NSString *response = [request responseString];
    NSString *json = [[NSString alloc] initWithString:response];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *data = [parser objectWithString:json error:nil];
    
    //[request release];
    [json release];
    [parser release];
    
    NSInteger status = [[data valueForKey:@"Status"] integerValue];
    
    // failed on the server side
    if(status != 1)
    {
        NSInteger errorcode = [[data valueForKey:@"ErrorCode"] integerValue];
        [delegate requestLoadGameVarsFinished:[[[PlaytomicResponse alloc] initWithError:errorcode] autorelease]];
        return;
    }
    
    NSDictionary *dvars = [data valueForKey:@"Data"];
    //NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
 /*   for(id key in dvars)
    {
        for(id name in key)
        {
            [md setObject:[key valueForKey:name] forKey:name];
        }
    }
  */  
    PlaytomicResponse *playtomicReponse = [[PlaytomicResponse alloc] initWithSuccess:YES 
                                                                        andErrorCode:0 
                                                                             andDict:dvars];
    [playtomicReponse autorelease];
    //[md release];
    
    [delegate requestLoadGameVarsFinished:playtomicReponse];
}


@end

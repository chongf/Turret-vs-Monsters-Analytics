//
//  PlaytomicRequest.m
//  Playtomic
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

#import "PlaytomicLogRequest.h"
#import "Playtomic.h"
#import "PlaytomicLog.h"
#import "ASI/ASIHTTPRequest.h"

NSString * const PLAYTOMIC_QUEUE_SIZE = @"playtomic.queue.size";
NSString * const PLAYTOMIC_QUEUE_BYTES = @"playtomic.queue.bytes";
NSString * const PLAYTOMIC_QUEUE_ITEM = @"playtomic.queue.item_%d";
NSString * const PLAYTOMIC_QUEUE_READY = @"playtomic.queue.ready";
int const PLAYTOMIC_QUEUE_MAX_BYTES = 1048577; // actually the max size is 1048576.
                                          // the 1048577 value allow us to do
                                          // if (queueSize < PLAYTOMIC_QUEUE_MAX_SIZE) {...}


@interface PlaytomicLogRequest ()

@property (nonatomic,copy) NSString *data;
@property (nonatomic,copy) NSString *trackUrl;
@property (assign) BOOL mustReleaseOnRequestFinished;
@property (retain) ASIHTTPRequest* _request;


- (void)requestFailed:(ASIHTTPRequest *)request;

@end

@implementation PlaytomicLogRequest

@synthesize data;
@synthesize trackUrl;
@synthesize mustReleaseOnRequestFinished;
@synthesize _request;

- (id)initWithTrackUrl:(NSString*)url
{
    self.trackUrl = url;
    self.data = @"";
    return self;
}

- (void)queueEvent:(NSString*)event
{
    if([self.data length] == 0)
    {
        self.data = event;
    }
    else
    {
        self.data = [self.data stringByAppendingString:@"~"];
        self.data = [self.data stringByAppendingString:event];
    }
}

- (void)massQueue:(NSMutableArray*)eventqueue
{
    while([eventqueue count] > 0)
    {
        id event = [[[eventqueue objectAtIndex:0] retain] autorelease];
        [eventqueue removeObjectAtIndex:0];
        
        if([self.data length] == 0)
        {
            self.data = event;
        }
        else
        {
            self.data = [self.data stringByAppendingString:@"~"];
            self.data = [self.data stringByAppendingString:event];
            
            if([self.data length] > 300)
            {
                [self send];                
                PlaytomicLogRequest* request = [[PlaytomicLogRequest alloc] initWithTrackUrl:trackUrl];
                [request massQueue:eventqueue];
                return;
            }
        } 
    }
    
    [self send];
}

- (void)send
{
	NSString *fullurl = self.trackUrl;
    fullurl = [fullurl stringByAppendingString:self.data];
    
    //NSLog(@"%@", fullurl);
    
    if ([Playtomic getInternetActive])
    {    
        //NSLog(@"Internet is active");
        
        self._request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullurl]] autorelease];
        [_request HEADRequest];
        [_request setDelegate:self];
        [_request startAsynchronous];
        //[request autorelease];
    }
    else
    {
        //NSLog(@"Internet is not active");     
        
        [self requestFailed:nil];
    }
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    //NSLog(@"request finished");
    
    // try to send data we have failed to send in a previous call to send
    //    
    NSUserDefaults *dataToSendLater = [NSUserDefaults standardUserDefaults];
    NSInteger queueSize = [dataToSendLater integerForKey:PLAYTOMIC_QUEUE_SIZE];
    
    //NSLog(@"messages in queue %d", queueSize);
    
    if (queueSize > 0)
    {
        // we send only one message by call
        //
        BOOL ready = [dataToSendLater boolForKey:PLAYTOMIC_QUEUE_READY];
        if (ready)
        {
            [dataToSendLater setBool:NO forKey:PLAYTOMIC_QUEUE_READY];
            
            // this is managed as filo list
            //
            NSString *key = [NSString stringWithFormat:PLAYTOMIC_QUEUE_ITEM, queueSize];
            NSString *savedData = [dataToSendLater objectForKey:key];
            queueSize--;
            [dataToSendLater setInteger:queueSize forKey:PLAYTOMIC_QUEUE_SIZE];   
            [dataToSendLater removeObjectForKey:key];
            
            PlaytomicLogRequest* request = [[[PlaytomicLogRequest alloc] initWithTrackUrl:trackUrl] autorelease];
            [request queueEvent:savedData];
            request.mustReleaseOnRequestFinished = YES;
            [request send];
            
            //NSLog(@"message re-send: %@", trackUrl);
        }
        else
        {
            [dataToSendLater setBool:YES forKey:PLAYTOMIC_QUEUE_READY];        
        }
    }   
    if (self.mustReleaseOnRequestFinished)
    {
        [self release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSLog(@"request failed %@", [request error]);
    
    // save data to send later
    //
    // this is managed as filo list
    //    
    NSUserDefaults *dataToSendLater = [NSUserDefaults standardUserDefaults];
    NSInteger queueSize = [dataToSendLater integerForKey:PLAYTOMIC_QUEUE_SIZE];
    NSInteger queueBytes = [dataToSendLater integerForKey:PLAYTOMIC_QUEUE_BYTES];
    if (queueBytes < [Playtomic getOfflineQueueMaxSize])
    {        
        queueSize++;
        [dataToSendLater setInteger:queueSize forKey:PLAYTOMIC_QUEUE_SIZE];
        NSString *key = [NSString stringWithFormat:PLAYTOMIC_QUEUE_ITEM, queueSize];
        NSString *dataToSave = self.data;
        NSRange foundRange = [dataToSave rangeOfString:@"&date="];
        if (foundRange.location == NSNotFound) 
        {
            long seconds = (long)[[NSDate date] timeIntervalSince1970];
            dataToSave = [NSString stringWithFormat:@"%@&date=%ld", dataToSave, seconds];
        }
        [dataToSendLater setObject:dataToSave forKey:key];
        queueBytes += [dataToSave length] * 2;
        [dataToSendLater setInteger:queueBytes forKey:PLAYTOMIC_QUEUE_BYTES];
        [dataToSendLater setBool:YES forKey:PLAYTOMIC_QUEUE_READY];
    }

    if (self.mustReleaseOnRequestFinished)
    {
        [self release];
    }
}

- (void)dealloc {
    self._request = nil;
    self.data = nil;
    self.trackUrl = nil;
    [super dealloc];
}

@end


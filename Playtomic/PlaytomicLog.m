//
//  PlaytomicLog.m
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



#import "PlaytomicLog.h"
#import "Playtomic.h"

@interface PlaytomicLog ()

@property (nonatomic,copy) NSString *trackUrl;
@property (nonatomic,copy) NSString *sourceUrl;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,readwrite) Boolean enabled;
@property (nonatomic,retain) NSTimer *playTimer;
@property (nonatomic,retain) NSTimer *firstPing;
@property (nonatomic,readwrite) NSInteger pings;
@property (nonatomic,readwrite) NSInteger plays;
@property (nonatomic,readwrite) NSInteger views;
@property (nonatomic,readwrite) Boolean frozen;
@property (nonatomic,retain) NSMutableArray *queue;
@property (nonatomic,retain) NSMutableArray *customMetrics;
@property (nonatomic,retain) NSMutableArray *levelCounters;
@property (nonatomic,retain) NSMutableArray *levelAverages;
@property (nonatomic,retain) NSMutableArray *levelRangeds;
@property (nonatomic,retain) NSDate *lastEventOccurence;

@end

@implementation PlaytomicLog

@synthesize trackUrl;
@synthesize sourceUrl;
@synthesize baseUrl;
@synthesize enabled;
@synthesize playTimer;
@synthesize firstPing;
@synthesize views;
@synthesize pings;
@synthesize plays;
@synthesize frozen;
@synthesize queue;
@synthesize customMetrics;
@synthesize levelCounters;
@synthesize levelAverages;
@synthesize levelRangeds;
@synthesize lastEventOccurence;

- (id)initWithGameId:(NSInteger)gameid 
             andGUID:(NSString*)gameguid 
{
    self.lastEventOccurence = [NSDate date];
    self.sourceUrl = [Playtomic getSourceUrl];
    self.baseUrl = [Playtomic getBaseUrl];
    self.trackUrl = [NSString stringWithFormat:@"http://g%@.api.playtomic.com/tracker/q.aspx?swfid=%d&url=%@&q="
                                                , gameguid
                                                , gameid
                                                , sourceUrl];
    self.enabled = YES;
    self.views = [self getCookie:@"views"];
    self.plays = [self getCookie:@"plays"];
    self.pings = 0;
    self.frozen = NO;    
    self.queue = [NSMutableArray array];
    self.customMetrics = [NSMutableArray array];
    self.levelCounters = [NSMutableArray array];
    self.levelAverages = [NSMutableArray array];
    self.levelRangeds = [NSMutableArray array];
    self.firstPing = [NSTimer scheduledTimerWithTimeInterval:60.0 
                                                      target:self 
                                                    selector:@selector(pingServer)
                                                    userInfo:nil 
                                                     repeats:NO];
    
    //NSLog(@"Initialised PlaytomicLog with\nsource url: %@\nbase url: %@\ntrackurl: %@", self.sourceUrl, self.baseUrl, self.trackUrl);
    return self;
}

- (void) view 
{
    [self sendEvent:[NSString stringWithFormat:@"v/%d", self.views + 1] 
          andCommit:YES];
}

- (void) play 
{
    //NSLog(@"[PlaytomicLog play]");
    [self sendEvent:[NSString stringWithFormat:@"p/%d", self.plays + 1] 
          andCommit:YES];
}

- (void) pingServer
{   
    self.pings++;
    [self sendEvent:[NSString stringWithFormat:@"t/%@/%d", (self.pings == 1 ? @"y" : @"n"), self.pings] 
          andCommit:YES];
    
    if(self.pings == 1)
    {
        [self.firstPing invalidate];
        self.firstPing = nil;
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 
                                                          target:self 
                                                        selector:@selector(pingServer) 
                                                        userInfo:nil 
                                                         repeats:YES];
    }
}

// custom metrics
- (void)customMetricName:(NSString*)name 
                andGroup:(NSString*)group 
               andUnique:(Boolean)unique
{
    if(group == nil)
        group = @"";
    
    if(unique == YES)
    {
        if([self.customMetrics containsObject:name])
        {
            return;
        }
        
        [self.customMetrics addObject:name];
    }
    
    [self sendEvent:[NSString stringWithFormat:@"c/%@/%@", [self clean:name], [self clean:group]] 
          andCommit:NO];
}

// links
- (void)linkUrl:(NSString*)url 
        andName:(NSString*)name 
       andGroup:(NSString*)group 
      andUnique:(NSInteger)unique 
       andTotal:(NSInteger)total 
        andFail:(NSInteger)fail
{ 
    [self sendEvent:[NSString stringWithFormat:@"l/%@/%@/%@/%d/%d/%d"
                                                , [self clean:name]
                                                , [self clean:group]
                                                , [self clean:url]
                                                , unique, total, fail] 
          andCommit:NO];
}

- (void)heatmapName:(NSString*)name 
           andGroup:(NSString*)group 
               andX:(NSInteger)x 
               andY:(NSInteger)y;
{
    [self sendEvent:[NSString stringWithFormat:@"h/%@/%@/%d/%d"
                                                , [self clean: name]
                                                , [self clean: group]
                                                , x, y] 
          andCommit: NO];
}

- (void) funnel 
{
}

// level metrics
- (void)levelCounterMetricName:(NSString*)name 
                andLevelNumber:(NSInteger)levelnumber 
                     andUnique:(Boolean)unique
{
    [self levelCounterMetricName:name 
                        andLevel:[NSString stringWithFormat:@"%d",levelnumber] 
                       andUnique:unique];
}

- (void)levelCounterMetricName:(NSString*)name 
                      andLevel:(NSString*)level 
                     andUnique:(Boolean)unique
{
    NSString *nameclean = [self clean:name];
    NSString *levelclean = [self clean:level];
    
    if(unique == YES)
    {
        NSString *key = [NSString stringWithFormat:@"%@.%@", nameclean, levelclean];
                         
        if([self.levelCounters containsObject:key])
        {
            return;
        }
        
        [self.levelCounters addObject:key];
    }
    
    [self sendEvent:[NSString stringWithFormat:@"lc/%@/%@", nameclean, levelclean] 
          andCommit:NO];
}

- (void)levelRangedMetricName:(NSString*)name 
               andLevelNumber:(NSInteger)levelnumber 
                andTrackValue:(NSUInteger)trackvalue 
                    andUnique:(Boolean)unique
{
    [self levelRangedMetricName:name 
                       andLevel:[NSString stringWithFormat:@"%d", levelnumber] 
                  andTrackValue:trackvalue 
                      andUnique:unique];
}

- (void)levelRangedMetricName:(NSString*)name 
                     andLevel:(NSString*)level 
                andTrackValue:(NSUInteger)trackvalue 
                    andUnique:(Boolean)unique
{
    NSString *nameclean = [self clean:name];
    NSString *levelclean = [self clean:level];
    
    if(unique == YES)
    {
        NSString *key = [NSString stringWithFormat:@"%@.%@.%d", nameclean, levelclean, trackvalue];
        
        if([self.levelRangeds containsObject:key])
        {
            return;
        }
        
        [self.levelRangeds addObject:key];
    }
    
    [self sendEvent:[NSString stringWithFormat:@"lr/%@/%@/%d", nameclean, levelclean, trackvalue] 
          andCommit:NO];
}

- (void)levelAverageMetricName:(NSString*)name 
                andLevelNumber:(NSInteger)levelnumber 
                      andValue:(NSUInteger)value 
                     andUnique:(Boolean)unique
{
    [self levelAverageMetricName:name 
                        andLevel:[NSString stringWithFormat:@"%d",levelnumber] 
                        andValue:value 
                       andUnique:unique];
}

- (void)levelAverageMetricName:(NSString*)name 
                      andLevel:(NSString*)level 
                      andValue:(NSUInteger)value 
                     andUnique:(Boolean)unique
{
    NSString *nameclean = [self clean:name];
    NSString *levelclean = [self clean:level];
    
    if(unique == YES)
    {
        NSString *key = [NSString stringWithFormat:@"%@.%@", nameclean, levelclean];
        
        if([self.levelAverages containsObject:key])
        {
            return;
        }
        
        [self.levelAverages addObject:key];
    }
    
    [self sendEvent:[NSString stringWithFormat:@"la/%@/%@/%d", nameclean, levelclean, value] 
          andCommit:NO]; 
}



// player levels
- (void)playerLevelStartLevelid:(NSString*)levelid
{
    [self sendEvent:[NSString stringWithFormat:@"pls/%@", [self clean:levelid]] 
          andCommit:NO];
}

- (void)playerLevelWinLevelid:(NSString*)levelid
{
   [self sendEvent:[NSString stringWithFormat:@"plw/%@", [self clean:levelid]] 
         andCommit: NO]; 
}

- (void)playerLevelRetryLevelid:(NSString*)levelid
{
    [self sendEvent:[NSString stringWithFormat:@"plr/%@", [self clean:levelid]] 
          andCommit: NO]; 
}

- (void)playerLevelQuitLevelid:(NSString*)levelid
{
    [self sendEvent:[NSString stringWithFormat:@"plq/%@", [self clean:levelid]] 
          andCommit: NO];
}

- (void)playerLevelFlagLevelid:(NSString*)levelid
{
    [self sendEvent:[NSString stringWithFormat:@"plf/%@", [self clean:levelid]] 
          andCommit: NO];
}

// misc
- (void)freeze 
{
    if (!self.frozen)
    {
        self.frozen = YES;
        if (firstPing)
        {
            [firstPing invalidate];
            self.firstPing = nil;
        }
        if (playTimer) 
        {
            [playTimer invalidate];
            self.playTimer = nil;
        }    
    }
}

- (void)unfreeze 
{
    if (self.frozen)
    {
        self.frozen = NO;
        
        if ([self.lastEventOccurence timeIntervalSinceNow] < -1200)
        {
            [self view];
        }
        else
        {
            [self forceSend];
        }
        if (self.pings == 0)
        {
            self.firstPing = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(pingServer) userInfo:nil repeats:NO];    
        }
        else 
        {
            if(self.pings == 1) {
                if (firstPing)
                {
                    [self.firstPing invalidate];
                    self.firstPing = nil;
                }
            }
            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(pingServer) userInfo:nil repeats:YES];
        }
    }
}

- (void)forceSend 
{
    if([self.queue count] > 0)
    {
        PlaytomicLogRequest *request = [[PlaytomicLogRequest alloc] initWithTrackUrl:self.trackUrl];
        [request massQueue:self.queue];
        [self.queue removeAllObjects];
    }
}
     
- (void)sendEvent:(NSString*)event 
        andCommit:(Boolean)commit
{
    self.lastEventOccurence = [NSDate date];
    
    [self.queue addObject:event];
    
    if(self.frozen == YES || commit == NO)
    {
        return;
    }
    
    [self forceSend];
}

- (NSString*)clean:(NSString*)string
{    
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

- (NSInteger)getCookie:(NSString*)name
{
    return 0;
}

- (void) saveCookie 
{
}

- (void) increaseViews
{
    views++;    
}

- (void) increasePlays
{
    plays++;
}

- (void)dealloc {
    
    // change all of this for  self.xxx = nil;
    self.trackUrl = nil;
    self.sourceUrl = nil;
    self.baseUrl = nil;
    if (firstPing)
    {
        [firstPing invalidate];
        self.firstPing = nil;
    }
    if (playTimer) 
    {
        [playTimer invalidate];
        self.playTimer = nil;
    }
    self.queue = nil;
    self.customMetrics = nil;
    self.levelCounters = nil;
    self.levelAverages = nil;
    self.levelRangeds = nil;    
    self.lastEventOccurence = nil;
    [super dealloc];
}

@end
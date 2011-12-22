//
//  Playtomic.m
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

#import "Playtomic.h"
#import "Reachability.h"

@interface Playtomic ()
@property (nonatomic,readwrite) NSInteger gameId;
@property (nonatomic,copy) NSString *gameGuid;
@property (nonatomic,copy) NSString *sourceUrl;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,copy) NSString *apiKey;
@property (retain) PlaytomicLog *log;
@property (retain) PlaytomicGameVars *gameVars;
@property (retain) PlaytomicGeoIP *geoIP;
@property (retain) PlaytomicLeaderboards *leaderboards;
@property (retain) PlaytomicPlayerLevels *playerLevels;
@property (retain) PlaytomicLink *link;
@property (retain) PlaytomicData *data;
@property (assign) BOOL hostActive;
@property (assign) BOOL internetActive;
@property (assign) NSInteger offlineQueueMaxSize;
@end

@implementation Playtomic

@synthesize gameId;
@synthesize gameGuid;
@synthesize sourceUrl;
@synthesize baseUrl;
@synthesize log;
@synthesize gameVars;
@synthesize geoIP;
@synthesize leaderboards;
@synthesize playerLevels;
@synthesize link;
@synthesize data;
@synthesize hostActive;
@synthesize internetActive;
@synthesize offlineQueueMaxSize;
@synthesize apiKey;

static Playtomic *instance = nil;

+ (void)initialize
{
    if (instance == nil)
    {
        instance = [[self alloc] init];
    }
}

+ (PlaytomicLog*)Log
{
	return instance.log;
}

+ (PlaytomicGameVars*)GameVars
{
	return instance.gameVars;
}

+ (PlaytomicGeoIP*)GeoIP
{
    return instance.geoIP;
}

+ (PlaytomicLeaderboards*)Leaderboards
{
    return instance.leaderboards;
}

+ (PlaytomicPlayerLevels*)PlayerLevels
{
    return instance.playerLevels;
}

+ (PlaytomicLink*)Link
{
    return instance.link;
}

+ (PlaytomicData*)Data
{
    return instance.data;
}

+ (NSInteger)getGameId
{
    return instance.gameId;
}

+ (NSString*)getGameGuid
{
    return instance.gameGuid;
}

+ (NSString*)getApiKey
{
    return instance.apiKey;
}

+ (NSString*)getSourceUrl
{
    return instance.sourceUrl;
}

+ (NSString*)getBaseUrl
{
    return instance.baseUrl;
}

+ (BOOL)getInternetActive
{
    // When the status is not connected we recheck
    // because after some testing with a device
    // (not in simulator) we have noticed that
    // NSNotificationCenter is not calling
    // every time wifi and internet get reachable
    //
    if (instance.internetActive == NO || instance.hostActive == NO)
    {
        [instance checkNetworkStatus:nil];
    }
    return instance.internetActive && instance.hostActive;
}

+ (NSInteger)getOfflineQueueMaxSize
{
    return instance.offlineQueueMaxSize;
}

+ (void)setOfflineQueueMaxSizeInKbytes:(NSInteger)size
{
    // we save the size in bytes
    //
    if (size < 0)
    {
        size = 0;
    }
    size = size * 1024;
    if (size > PLAYTOMIC_QUEUE_MAX_BYTES)
    {
        instance.offlineQueueMaxSize = PLAYTOMIC_QUEUE_MAX_BYTES;
    }
    else
    {
        instance.offlineQueueMaxSize = size;
    }
}

- (id)initWithGameId:(NSInteger)gameid 
             andGUID:(NSString*)gameguid 
           andAPIKey:(NSString*)apikey
{
    NSString *model = [[UIDevice currentDevice] model];
    NSString *system = [[UIDevice currentDevice] systemName];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    model = [model stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    system = [system stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    version = [version stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    instance.gameId = gameid;
    instance.gameGuid = gameguid;
    instance.sourceUrl = [NSString stringWithFormat:@"http://ios.com/%@/%@/%@", model, system, version];
    instance.baseUrl = @"ios.com";
    instance.apiKey = apikey;

    instance.log = [[[PlaytomicLog alloc] initWithGameId:gameid andGUID:gameguid]autorelease ];
    instance.gameVars = [[[PlaytomicGameVars alloc] init] autorelease];
    instance.geoIP = [[[PlaytomicGeoIP alloc] init] autorelease];
    instance.leaderboards = [[[PlaytomicLeaderboards alloc] init] autorelease ];
    instance.playerLevels = [[[PlaytomicPlayerLevels alloc] init] autorelease];
    instance.link = [[[PlaytomicLink alloc] init]autorelease ];
    instance.data = [[[PlaytomicData alloc] init] autorelease];
   
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName:@"www.playtomic.com"] retain];
    [hostReachable startNotifier];
    
    instance.hostActive = YES;
    instance.internetActive = YES;
    instance.offlineQueueMaxSize = PLAYTOMIC_QUEUE_MAX_BYTES; // 1 MB 
  
    return instance;    
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    //NSLog(@"checkNetworkStatus was called.");
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            //NSLog(@"The internet is down.");
            instance.internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"The internet is working via WIFI.");
            instance.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"The internet is working via WWAN.");
            instance.internetActive = YES;
            
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            //NSLog(@"A gateway to the host server is down.");
            instance.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"A gateway to the host server is working via WIFI.");
            instance.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"A gateway to the host server is working via WWAN.");
            instance.hostActive = YES;
            
            break;
            
        }
    }
    
}

- (void)dealloc {
    self.gameGuid = nil;
    self.sourceUrl = nil;
    self.baseUrl = nil;
    self.log = nil;
    self.gameVars = nil;
    self.geoIP = nil;
    self.leaderboards = nil;
    self.playerLevels = nil;
    self.link = nil;
    self.data = nil;    
    
    if (hostReachable)
    {
        [hostReachable release];
        hostReachable = nil;
    }

    if (internetReachable)
    {
        [internetReachable release];
        internetReachable = nil;
    }
    
    [super dealloc];
}


@end

//
//  Playtomic.h
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

#import <Foundation/Foundation.h>
#import "PlaytomicLog.h"
#import "PlaytomicGameVars.h"
#import "PlaytomicGeoIP.h"
#import "PlaytomicLeaderboards.h"
#import "PlaytomicPlayerLevels.h"
#import "PlaytomicLink.h"
#import "PlaytomicData.h"

@class Reachability;

extern int const PLAYTOMIC_QUEUE_MAX_BYTES;

@interface Playtomic : NSObject {
    
    NSInteger gameId;
    NSString *gameGuid;
    NSString *sourceUrl;
    NSString *apiKey;
    NSString *baseUrl;
    PlaytomicLog *log;
    PlaytomicGameVars *gameVars;
    PlaytomicGeoIP *geoIP;
    PlaytomicLeaderboards *leaderboards;
    PlaytomicPlayerLevels *playerLevels;
    PlaytomicLink *link;
    PlaytomicData *data;
    
    Reachability *internetReachable;
    Reachability *hostReachable;
    
    BOOL hostActive;
    BOOL internetActive;
    NSInteger offlineQueueMaxSize;
}

- (id)initWithGameId:(NSInteger)gameid 
             andGUID:(NSString*)gameguid 
           andAPIKey:(NSString*)apikey;

- (void) checkNetworkStatus:(NSNotification *)notice;

+ (PlaytomicLog*)Log;

+ (PlaytomicGameVars*)GameVars;

+ (PlaytomicGeoIP*)GeoIP;

+ (PlaytomicLeaderboards*)Leaderboards;

+ (PlaytomicPlayerLevels*)PlayerLevels;

+ (PlaytomicLink*)Link;

+ (PlaytomicData*)Data;

+ (NSInteger)getGameId;

+ (NSString*)getGameGuid;

+ (NSString*)getApiKey;

+ (NSString*)getSourceUrl;

+ (NSString*)getBaseUrl;

+ (BOOL)getInternetActive;

+ (NSInteger)getOfflineQueueMaxSize;

+ (void)setOfflineQueueMaxSizeInKbytes:(NSInteger)size;

@end

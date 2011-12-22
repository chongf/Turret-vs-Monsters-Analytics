//
//  PlaytomicLog.h
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
#import "PlaytomicLogRequest.h"

@interface PlaytomicLog : NSObject {
    NSString *trackUrl;
    NSString *sourceUrl;
    NSString *baseUrl;
    Boolean enabled;
    NSTimer *playTimer;
    NSTimer *firstPing;
    NSInteger pings;
    NSInteger views;
    NSInteger plays;
    Boolean frozen;
    NSMutableArray *queue;
    NSMutableArray *customMetrics;
    NSMutableArray *levelCounters;
    NSMutableArray *levelAverages;
    NSMutableArray *levelRangeds;
    NSDate *lastEventOccurence;
}

- (id)initWithGameId:(NSInteger)gameid 
             andGUID:(NSString*)gameguid;

- (void) view;

- (void) play;

- (void) pingServer;

- (void)customMetricName:(NSString*)name 
                andGroup:(NSString*)group 
               andUnique:(Boolean)unique;

- (void)levelCounterMetricName:(NSString*)name 
                      andLevel:(NSString*)level 
                     andUnique:(Boolean)unique;

- (void)levelCounterMetricName:(NSString*)name 
                andLevelNumber:(NSInteger)levelnumber 
                     andUnique:(Boolean)unique;

- (void)levelRangedMetricName:(NSString*)name 
                     andLevel:(NSString*)level 
                andTrackValue:(NSUInteger)trackvalue 
                    andUnique:(Boolean)unique;

- (void)levelRangedMetricName:(NSString*)name 
               andLevelNumber:(NSInteger)levelnumber 
                andTrackValue:(NSUInteger)trackvalue 
                    andUnique:(Boolean)unique;

- (void)levelAverageMetricName:(NSString*)name 
                      andLevel:(NSString*)level 
                      andValue:(NSUInteger)value 
                     andUnique:(Boolean)unique;

- (void)levelAverageMetricName:(NSString*)name 
                andLevelNumber:(NSInteger)levelnumber 
                      andValue:(NSUInteger)value 
                     andUnique:(Boolean)unique;

- (void)linkUrl:(NSString*)url 
        andName:(NSString*)name 
       andGroup:(NSString*)group 
      andUnique:(NSInteger)unique 
       andTotal:(NSInteger)total 
        andFail:(NSInteger)fail;

- (void)heatmapName:(NSString*)name 
           andGroup:(NSString*)group 
               andX:(NSInteger)x 
               andY:(NSInteger)y;

- (void)funnel;

- (void)playerLevelStartLevelid:(NSString*)levelid;

- (void)playerLevelRetryLevelid:(NSString*)levelid;

- (void)playerLevelWinLevelid:(NSString*)levelid;

- (void)playerLevelQuitLevelid:(NSString*)levelid;

- (void)playerLevelFlagLevelid:(NSString*)levelid;

- (void)freeze;

- (void)unfreeze;

- (void)forceSend;

- (void)sendEvent:(NSString*)event 
        andCommit:(Boolean)commit;

- (NSString*)clean:(NSString*)string;

- (NSInteger)getCookie:(NSString*)name;

- (void)saveCookie;

- (void)increaseViews;

- (void)increasePlays;

@end

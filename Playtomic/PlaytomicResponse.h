//
//  GameVarResults.h
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

#import <Foundation/Foundation.h>

@interface PlaytomicResponse : NSObject {
    Boolean responseSucceeded;
    NSInteger responseError;
    NSArray *responseData;
    NSDictionary *responseDictionary;
    NSInteger numResults;
}

- (id)initWithError:(NSInteger)errorcode;

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode;

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode 
              andData:(NSArray*)data 
        andNumResults:(NSInteger)numresults;

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode 
              andDict:(NSDictionary*)dict;

- (Boolean)success;

- (NSInteger)errorCode;

- (NSArray*)data;

- (NSDictionary*) dictionary;

- (NSString*)getValueForName:(NSString*)name;

- (void)setValueForName:(NSString*)name 
               andValue:(NSString*)value;

- (NSInteger)getNumResults;

@end

@protocol PlaytomicDelegate <NSObject>

@optional

// Leaderboards
//
- (void)requestSaveLeaderboardFinished:(PlaytomicResponse*)response;
- (void)requestListLeaderboardFinished:(PlaytomicResponse*)response;
- (void)requestSaveAndListLeaderboardFinished:(PlaytomicResponse*)response;

- (void)requestCreateprivateLeaderboardFinish:(PlaytomicResponse*)response;
- (void)requestLoadprivateLeaderboardFinish:(PlaytomicResponse*)response;

// GeoIP
//
- (void)requestLoadGeoIPFinished:(PlaytomicResponse*)response;

// GameVars
//
- (void)requestLoadGameVarsFinished:(PlaytomicResponse*)response;

// PlayerLevels
//
- (void)requestLoadPlayerLevelsFinished:(PlaytomicResponse*)response;
- (void)requestSavePlayerLevelsFinished:(PlaytomicResponse*)response;
- (void)requestRatePlayerLevelsFinished:(PlaytomicResponse*)response;
- (void)requestListPlayerLevelsFinished:(PlaytomicResponse*)response;

// Data
//
- (void)requestViewsDataFinished:(PlaytomicResponse*)response;
- (void)requestPlaysDataFinished:(PlaytomicResponse*)response;
- (void)requestPlaytimeDataFinished:(PlaytomicResponse*)response;
- (void)requestCustomMetricDataFinished:(PlaytomicResponse*)response;
- (void)requestLevelMetricCounterDataFinished:(PlaytomicResponse*)response;
- (void)requestLevelMetricAverageDataFinished:(PlaytomicResponse*)response;
- (void)requestLevelMetricRangeDataFinished:(PlaytomicResponse*)response;

@end


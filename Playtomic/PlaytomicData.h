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

#import <Foundation/Foundation.h>
#import "PlaytomicResponse.h"

@interface PlaytomicData : NSObject {
    
    id<PlaytomicDelegate> delegate;
    SEL requestFinished;
    
}

// synchronous
//
- (PlaytomicResponse*) views;

- (PlaytomicResponse*) viewsMonth:(NSInteger)month 
                          andYear:(NSInteger)year;

- (PlaytomicResponse*) viewsDay:(NSInteger)day 
                       andMonth:(NSInteger)month andYear:(NSInteger)year;

- (PlaytomicResponse*) plays;

- (PlaytomicResponse*) playsMonth:(NSInteger)month 
                          andYear:(NSInteger)year;

- (PlaytomicResponse*) playsDay:(NSInteger)day 
                       andMonth:(NSInteger)month andYear:(NSInteger)year;

- (PlaytomicResponse*) playtime;

- (PlaytomicResponse*) playtimeMonth:(NSInteger)month 
                             andYear:(NSInteger)year;

- (PlaytomicResponse*) playtimeDay:(NSInteger)day 
                          andMonth:(NSInteger)month 
                           andYear:(NSInteger)year;

- (PlaytomicResponse*) generalMode:(NSString*)mode 
                           andType:(NSString*)type
                            andDay:(NSInteger)day 
                          andMonth:(NSInteger)month 
                           andYear:(NSInteger)year;

- (PlaytomicResponse*) customMetricName:(NSString*)name;

- (PlaytomicResponse*) customMetricName:(NSString*)name 
                               andMonth:(NSInteger)month 
                                andYear:(NSInteger)year;

- (PlaytomicResponse*) customMetricName:(NSString*)name 
                                 andDay:(NSInteger)day 
                               andMonth:(NSInteger)month 
                                andYear:(NSInteger)year;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                                     andLevel:(NSString*)level;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                                     andLevel:(NSString*)level 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                                     andLevel:(NSString*)level 
                                       andDay:(NSInteger)day 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelCounterMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level 
                                       andDay:(NSInteger)day 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                                     andLevel:(NSString*)level;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                                     andLevel:(NSString*)level 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                                     andLevel:(NSString*)level 
                                       andDay:(NSInteger)day 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelAverageMetricName:(NSString*)name 
                               andLevelNumber:(NSInteger)level 
                                       andDay:(NSInteger)day 
                                     andMonth:(NSInteger)month 
                                      andYear:(NSInteger)year;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                                    andLevel:(NSString*)level;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                                    andLevel:(NSString*)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year;

- (PlaytomicResponse*) levelRangedMetricName:(NSString*)name 
                              andLevelNumber:(NSInteger)level 
                                      andDay:(NSInteger)day 
                                    andMonth:(NSInteger)month 
                                     andYear:(NSInteger)year;

- (PlaytomicResponse*) levelMetricType:(NSString*)type 
                               andName:(NSString*)name 
                              andLevel:(NSString*)level 
                                andDay:(NSInteger)day 
                              andMonth:(NSInteger)month 
                               andYear:(NSInteger)year;

- (PlaytomicResponse*) getDataUrl:(NSString*)url;

- (NSString*) clean:(NSString*)string;

// asynchronous
//
- (void) viewsAsync:(id<PlaytomicDelegate>)delegate;

- (void) viewsAsyncMonth:(NSInteger)month 
                 andYear:(NSInteger)year 
             andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) viewsAsyncDay:(NSInteger)day 
              andMonth:(NSInteger)month 
               andYear:(NSInteger)year 
           andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) playsAsync:(id<PlaytomicDelegate>)delegate;

- (void) playsAsyncMonth:(NSInteger)month 
                 andYear:(NSInteger)year 
             andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) playsAsyncDay:(NSInteger)day 
              andMonth:(NSInteger)month 
               andYear:(NSInteger)year 
           andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) playtimeAsync:(id<PlaytomicDelegate>)delegate;

- (void) playtimeAsyncMonth:(NSInteger)month 
                    andYear:(NSInteger)year 
                andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) playtimeAsyncDay:(NSInteger)day 
                 andMonth:(NSInteger)month 
                  andYear:(NSInteger)year 
              andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) generalAsyncMode:(NSString*)mode 
                  andType:(NSString*)type
                   andDay:(NSInteger)day andMonth:(NSInteger)month 
                  andYear:(NSInteger)year 
              andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) customMetricAsyncName:(NSString*)name 
                   andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) customMetricAsyncName:(NSString*)name 
                      andMonth:(NSInteger)month 
                       andYear:(NSInteger)year 
                   andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) customMetricAsyncName:(NSString*)name 
                        andDay:(NSInteger)day 
                      andMonth:(NSInteger)month 
                       andYear:(NSInteger)year 
                   andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                              andDay:(NSInteger)day 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelCounterMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                              andDay:(NSInteger)day 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                            andLevel:(NSString*)level 
                              andDay:(NSInteger)day 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                            andMonth: (NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelAverageMetricAsyncName:(NSString*)name 
                      andLevelNumber:(NSInteger)level 
                              andDay:(NSInteger)day 
                            andMonth:(NSInteger)month 
                             andYear:(NSInteger)year 
                         andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                           andLevel:(NSString*)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelRangedMetricAsyncName:(NSString*)name 
                     andLevelNumber:(NSInteger)level 
                             andDay:(NSInteger)day 
                           andMonth:(NSInteger)month 
                            andYear:(NSInteger)year 
                        andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) levelMetricAsyncType:(NSString*)type 
                      andName:(NSString*)name 
                     andLevel:(NSString*)level 
                       andDay:(NSInteger)day 
                     andMonth:(NSInteger)month 
                      andYear:(NSInteger)year 
                  andDelegate:(id<PlaytomicDelegate>)delegate;

- (void) getDataAsyncUrl:(NSString*)url 
             andDelegate:(id<PlaytomicDelegate>)delegate;

@end
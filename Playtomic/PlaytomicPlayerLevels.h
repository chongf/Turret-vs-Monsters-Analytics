//
//  PlaytomicPlayerLevels.h
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
#import "PlaytomicLevel.h"


@interface PlaytomicPlayerLevels : NSObject {
    
    id<PlaytomicDelegate> delegate;
    NSString *levelid_;    
}

// synchronous calls
//
- (PlaytomicResponse*)loadLevelid:(NSString*)levelid;

- (PlaytomicResponse*)rateLevelid:(NSString*)levelid 
                        andRating:(NSInteger)rating;

- (PlaytomicResponse*)listMode:(NSString*)mode 
                       andPage:(NSInteger)page 
                    andPerPage:(NSInteger)perpage 
                andIncludeData:(Boolean)includedata
              andIncludeThumbs:(Boolean)includethumbs
               andCustomFilter:(NSDictionary*)customfilter;

- (PlaytomicResponse*)listWithDateRangeMode:(NSString*)mode 
                                    andPage:(NSInteger)page 
                                 andPerPage:(NSInteger)perpage 
                             andIncludeData:(Boolean)data 
                           andIncludeThumbs:(Boolean)includethumbs 
                            andCustomFilter:(NSDictionary*)customfilter 
                                 andDateMin:(NSDate*)datemin 
                                 andDateMax:(NSDate*)datemax;

- (PlaytomicResponse*)saveLevel:(PlaytomicLevel*)level;

// asynchronous calls
//
- (void)loadAsyncLevelid:(NSString*)levelid 
             andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)rateAsyncLevelid:(NSString*)levelid 
               andRating:(NSInteger)rating 
             andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)listAsyncMode:(NSString*)mode 
              andPage:(NSInteger)page 
           andPerPage:(NSInteger)perpage 
       andIncludeData:(Boolean)includedata 
     andIncludeThumbs:(Boolean)includethumbs 
      andCustomFilter:(NSDictionary*)customfilter 
          andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)listWithDateRangeAsyncMode:(NSString*)mode
                           andPage:(NSInteger)page
                        andPerPage:(NSInteger)perpage
                    andIncludeData:(Boolean)data
                  andIncludeThumbs:(Boolean)includethumbs
                   andCustomFilter:(NSDictionary*)customfilter
                        andDateMin:(NSDate*)datemin
                        andDateMax:(NSDate*)datemax
                       andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)saveAsyncLevel:(PlaytomicLevel*)level 
           andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)startLevel:(NSString*)levelid;

- (void)retryLevel:(NSString*)levelid;

- (void)winLevel:(NSString*)levelid;

- (void)quitLevel:(NSString*)levelid;

- (void)flagLevel:(NSString*)levelid;

@end

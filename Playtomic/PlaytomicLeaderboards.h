//
//  GameVars.h
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
#import "PlaytomicScore.h"

@interface PlaytomicLeaderboards : NSObject {
    
    id<PlaytomicDelegate> delegate;
    
}

// synchronous calls
//
- (PlaytomicResponse*)saveTable:(NSString*)table 
                       andScore:(PlaytomicScore*)score 
                     andHighest:(Boolean)highest 
             andAllowDuplicates:(Boolean)allowduplicates;

- (PlaytomicResponse*)listTable:(NSString*)table 
                     andHighest:(Boolean)highest 
                        andMode:(NSString*)mode 
                        andPage:(NSInteger)page 
                     andPerPage:(NSInteger)perpage 
                andCustomFilter:(NSDictionary*)customfilter;

- (PlaytomicResponse*)saveAndListTable:(NSString*)table 
                              andScore:(PlaytomicScore*)score 
                            andHighest:(Boolean)highest 
                    andAllowDuplicates:(Boolean)allowduplicates 
                               andMode:(NSString*)mode 
                            andPerPage:(NSInteger)perpage 
                       andCustomFilter:(NSDictionary*)customfilter;

-(PlaytomicResponse*)createPrivateLeaderboardName:(NSString*)name 
                                       andHighest:(Boolean)highest;

-(PlaytomicResponse*)loadPrivateLeaderboardTableId:(NSString*)tableid;

// asynchronous calls
//
- (void)saveAsyncTable:(NSString*)table 
              andScore:(PlaytomicScore*)score 
            andHighest:(Boolean)highest 
    andAllowDuplicates:(Boolean)allowduplicates 
           andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)listAsyncTable:(NSString*)table 
            andHighest:(Boolean)highest 
               andMode:(NSString*)mode 
               andPage:(NSInteger)page 
            andPerPage:(NSInteger)perpage 
       andCustomFilter:(NSDictionary*)customfilter 
           andDelegate:(id<PlaytomicDelegate>)delegate;

- (void)saveAndListAsyncTable:(NSString*)table 
                     andScore:(PlaytomicScore*)score 
                   andHighest:(Boolean)highest 
           andAllowDuplicates:(Boolean)allowduplicates 
                      andMode:(NSString*)mode 
                   andPerPage:(NSInteger)perpage 
              andCustomFilter:(NSDictionary*)customfilter 
                  andDelegate:(id<PlaytomicDelegate>)delegate;

-(void)createPrivateLeaderboardAsyncName:(NSString*)name 
                              andHighest:(Boolean)highest 
                             andDelegate:(id<PlaytomicDelegate>)delegate;

-(void)loadPrivateLeaderboardTableAsyncId:(NSString*)tableid 
                              andDelegate:(id<PlaytomicDelegate>)delegate;
@end


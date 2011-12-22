//
//  PlayerScore.m
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

#import "PlaytomicScore.h"


@interface PlaytomicScore ()
@property (nonatomic,copy) NSString *name;
@property (nonatomic,readwrite) NSInteger points;
@property (nonatomic,copy) NSDate *date;
@property (nonatomic,copy) NSString *relativeDate;
@property (nonatomic,retain) NSMutableDictionary *customData;
@property (nonatomic,readwrite) long rank;
@end

@implementation PlaytomicScore

@synthesize name;
@synthesize points;
@synthesize date;
@synthesize relativeDate;
@synthesize customData;
@synthesize rank;

- (id)initNewScoreWithName:(NSString *)pname 
                 andPoints:(NSInteger)ppoints
{
    self.name = pname;
    self.points = ppoints;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    self.customData = data;
    [data release];
    return self; 
}

- (id)initWithName:(NSString*)pname 
         andPoints:(NSInteger)ppoints 
           andDate:(NSDate*)pdate 
   andRelativeDate:(NSString*)relativedate 
     andCustomData:(NSMutableDictionary*)customdata 
           andRank:(long)prank
{
    self.name = pname;
    self.points = ppoints;
    self.date = pdate;
    self.relativeDate = relativedate;
    self.customData = customdata;
    self.rank = prank;
    return self;
}

- (NSString*)getName
{
    return self.name;
}

- (NSInteger)getPoints
{
    return self.points;
}

- (NSDate*)getDate
{
    return self.date;
}

- (NSString*)getRelativeDate
{
    return self.relativeDate;
}

- (long)getRank
{
    return self.rank;
}

- (NSMutableDictionary*)getCustomData
{
    return self.customData;
}

- (NSString*)getCustomValue:(NSString*)key
{
    return [self.customData valueForKey:key];
}

- (void)addCustomValue:(NSString*)key 
              andValue:(NSString*)value
{
    [self.customData setObject:value 
                        forKey:key];
}

- (void)dealloc {
    self.name = nil;
    self.date = nil;
    self.relativeDate = nil;
    self.customData = nil;
    [super dealloc];
}

@end
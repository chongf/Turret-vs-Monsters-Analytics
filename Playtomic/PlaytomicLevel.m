//
//  PlaytomicLevel.m
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

#import "PlaytomicLevel.h"
#import "Playtomic.h"

@interface PlaytomicLevel ()
@property (nonatomic,copy) NSString *levelId;
@property (nonatomic,copy) NSString *playerId;
@property (nonatomic,copy) NSString *playerName;
@property (nonatomic,copy) NSString *playerSource;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *data;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,readwrite) NSInteger votes;
@property (nonatomic,readwrite) NSInteger plays;
@property (nonatomic,copy) NSDecimalNumber *rating;
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,copy) NSDate *date;
@property (nonatomic,copy) NSString *relativeDate;
@property (nonatomic,retain) NSMutableDictionary *customData;
@end

@implementation PlaytomicLevel

@synthesize levelId;
@synthesize playerId; 
@synthesize playerName;
@synthesize playerSource;
@synthesize name;
@synthesize data;
@synthesize thumb;
@synthesize votes;
@synthesize plays;
@synthesize rating;
@synthesize score;
@synthesize date;
@synthesize relativeDate;
@synthesize customData;

- (id)initWithName:(NSString*)pname 
     andPlayerName:(NSString*)pplayername 
       andPlayerId:(NSString*)pplayerid 
           andData:(NSString*)pdata;
{
    self.name = pname;
    self.playerName = pplayername;
    self.playerId = pplayerid;
    self.data = pdata;
    return self;
}

- (id)initWithName:(NSString*)pname 
     andPlayerName:(NSString*)pplayername 
       andPlayerId:(NSString*)pplayerid 
   andPlayerSource:(NSString*)playersource 
           andData:(NSString*)pdata 
          andThumb:(NSString*)pthumb 
          andVotes:(NSInteger)pvotes 
          andPlays:(NSInteger)pplays 
         andRating:(NSDecimalNumber*)prating 
          andScore:(NSInteger)pscore 
           andDate:(NSDate*)pdate 
   andRelativeDate:(NSString*)prelativedate 
     andCustomData:(NSMutableDictionary*)pcustomdata 
        andLevelId:(NSString*)levelid
{
    self.name = pname;
    self.playerName = pplayername;
    self.playerId = pplayerid;
    self.playerSource = playersource;
    self.data = pdata;
    self.thumb = pthumb;
    self.votes = pvotes;
    self.plays = pplays;
    self.rating = prating;
    self.score = pscore;
    self.date = pdate;
    self.relativeDate = prelativedate;
    self.customData = pcustomdata;
    self.levelId = levelid;
    return self;
}

- (NSString*)getLevelId
{
    return self.levelId;
}

- (NSString*)getPlayerId
{
    return self.playerId;
}

- (NSString*)getPlayerName
{
    return self.playerName;
}

- (NSString*)getPlayerSource
{
    return self.playerSource;
}

- (NSString*)getName
{
    return self.name;
}

- (NSString*)getData
{
    return self.data;
}

- (NSInteger)getVotes
{
    return self.votes;
}

- (NSInteger)getPlays
{
    return self.plays;
}

- (NSDecimalNumber*)getRating
{
    return self.rating;
}

- (NSInteger)getScore
{
    return self.score;
}

- (NSDate*)getDate
{
    return self.date;
}

- (NSString*)getRelativeDate
{
    return self.relativeDate;
}

- (NSMutableDictionary*)getCustomData
{
    return self.customData;
}

- (NSString*)getThumbnailURL
{
    return [NSString stringWithFormat:@"http://g%@.api.playtomic.com/playerlevels/load.aspx?swfid=%d&levelid=%@"
                                        , [Playtomic getGameGuid]
                                        , [Playtomic getGameId]
                                        , self.levelId];
}

- (NSMutableData*)getThumbnail
{
    unsigned long ixtext = 0;
    unsigned long lentext = [self.thumb length];
    const char *temporary = [self.thumb UTF8String];
    NSMutableData *result = [NSMutableData dataWithCapacity:lentext];
    short ixinput = 0;
    short i;
    unsigned char ch, input[4], output[3];
    Boolean flignore, flendtext = false;
    
    while (true) 
    {
        if (ixtext >= lentext)
            break;
        ch = temporary[ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z'))
            ch = ch - 'A';
        else if ((ch >= 'a') && (ch <= 'z'))
            ch = ch - 'a' + 26;
        else if ((ch >= '0') && (ch <= '9'))
            ch = ch - '0' + 52;
        else if (ch == '+')
            ch = 62;
        else if (ch == '=')
            flendtext = true;
        else if (ch == '/')
            ch = 63;
        else
            flignore = true; 
        
        if (!flignore) 
        {
            short ctcharsinput = 3;
            Boolean flbreak = false;
            
            if (flendtext) 
            {
                if (ixinput == 0)
                    break; 
                
                if ((ixinput == 1) || (ixinput == 2)) 
                {
                    ctcharsinput = 1;
                }
                else
                {
                    ctcharsinput = 2;
                    ixinput = 3;
                    flbreak = true;
                }
                
                input[ixinput++] = ch;
                
                if (ixinput == 4)
                    ixinput = 0;
                
                output[0] = (input[0] << 2) | ((input[1] & 0x30) >> 4);
                output[1] = ((input[1] & 0x0F) << 4) | ((input[2] & 0x3C) >> 2);
                output[2] = ((input[2] & 0x03) << 6) | (input[3] & 0x3F);
                
                for (i = 0; i < ctcharsinput; i++)
                    [result appendBytes:&output[i] length:1];
            }
            
            if (flbreak)
                break;
        }
    }
    
    return result;
}

- (NSString*)getCustomValue:(NSString*)key
{
    return [self.customData valueForKey:key];
}

-(void) addCustomValue:(NSString*)key 
              andValue:(NSString*)value
{
    [self.customData setObject:value forKey:key];
}

- (void)dealloc {
    self.levelId = nil;
    self.playerId = nil;
    self.playerName = nil;
    self.playerSource = nil;
    self.name = nil;
    self.data = nil;
    self.thumb = nil;
    self.rating = nil;
    self.date = nil;
    self.relativeDate = nil;
    self.customData = nil;
    [super dealloc];
}

@end

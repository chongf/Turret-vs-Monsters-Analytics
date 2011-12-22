//
//  PlaytomicLink.m
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

#import "PlaytomicLink.h"
#import "Playtomic.h"
#import "PlaytomicLog.h"

@interface PlaytomicLink()

@property (nonatomic,retain) NSMutableDictionary *clicks;

@end

@implementation PlaytomicLink

@synthesize clicks;

- (void)trackUrl:(NSString*)url 
         andName:(NSString*)name 
        andGroup:(NSString*)group
{
    NSInteger unique = 0;
    NSInteger bunique = 0;
    NSInteger total = 0;
    NSInteger btotal = 0;
    NSString* key = [NSString stringWithFormat:@"%@.%@", url, name];
    
    NSString* baseurl = [NSString stringWithString:url];
    [baseurl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    [baseurl stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    NSRange slash = [baseurl rangeOfString:@"/"];
    
    if(slash.location > 0)
    {
        baseurl = [baseurl substringToIndex:slash.location];
    }
    
    NSString* baseurlname = [NSString stringWithString:baseurl];
    NSRange www = [baseurlname rangeOfString:@"www."];
    
    if(www.location == 0 && www.length == 4)
    {
        baseurlname = [baseurlname substringFromIndex:www.location];
    }
    
    if([clicks objectForKey:key] == 0)
    {
        total = 1;
        unique = 1;
        [clicks setObject:0 forKey:key];
    }
    else
    {
        total = 1;
    }
    
    if([clicks objectForKey: baseurlname] == 0)
    {
        btotal = 1;
        bunique = 1;
        [clicks setObject:0 forKey:baseurlname];
    }
    else
    {
        btotal = 1;
    }
    
    [[Playtomic Log] linkUrl:baseurl 
                     andName:baseurlname 
                    andGroup:@"DomainTotals" 
                   andUnique:bunique 
                    andTotal:btotal 
                     andFail:0];
    
    [[Playtomic Log] linkUrl:url 
                     andName:name 
                    andGroup:group 
                   andUnique:unique 
                    andTotal:total 
                     andFail:0];
    
    [[Playtomic Log] forceSend];
}

- (void)dealloc {
    self.clicks = nil;
    [super dealloc];
}

@end
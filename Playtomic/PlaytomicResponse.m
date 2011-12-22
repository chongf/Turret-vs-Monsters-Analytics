//
//  GameVarResults.m
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

#import "PlaytomicResponse.h"

@interface PlaytomicResponse ()
@property (nonatomic, readwrite) NSInteger responseError;
@property (nonatomic, readwrite) Boolean responseSucceeded;
@property (nonatomic, retain) NSArray *responseData;
@property (nonatomic, retain) NSDictionary *responseDictionary;
@property (nonatomic, readwrite) NSInteger numResults;
@end


@implementation PlaytomicResponse

@synthesize responseError;
@synthesize responseSucceeded;
@synthesize responseData;
@synthesize responseDictionary;
@synthesize numResults;

- (id)initWithError:(NSInteger)errorcode
{
    self.responseSucceeded = NO;
    self.responseError = errorcode;
    return self;
}

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode
{
    self.responseSucceeded = success;
    self.responseError = errorcode;
    return self;
}

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode 
              andData:(NSArray*)data 
        andNumResults:(NSInteger)numresults
{
    self.responseSucceeded = success;
    self.responseError = errorcode;
    self.responseData = data;
    self.numResults = numresults;
    return self;
}

- (id)initWithSuccess:(Boolean)success 
         andErrorCode:(NSInteger)errorcode 
              andDict:(NSDictionary*)dict
{
    //NSLog(@"Creating PlaytomicResponse with success %d and error %d", success, errorcode);
    self.responseSucceeded = success;
    self.responseError = errorcode;
    self.responseDictionary = dict;
    return self;
}

- (Boolean)success
{
    return self.responseSucceeded;
}

- (NSInteger)errorCode
{
    return self.responseError;
}

- (NSArray*)data
{
    return self.responseData;
}

- (NSDictionary*) dictionary
{
    return self.responseDictionary;
}

- (NSString*)getValueForName:(NSString*)name
{
    return [self.responseDictionary valueForKey:name];
}

- (void)setValueForName:(NSString*)name 
               andValue:(NSString*)value
{
    if(self.responseDictionary == nil)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        self.responseDictionary = dict;
        [dict release];
    }
    
    [self.responseDictionary setValue:value forKey:name];
}

- (NSInteger)getNumResults
{
    return self.numResults;
}

- (void)dealloc {
    self.responseData = nil;
    self.responseDictionary = nil;    
    [super dealloc];
}

@end

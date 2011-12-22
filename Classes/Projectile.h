//
//  Projectile.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 4/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"

@interface Projectile : CCSprite {
	NSMutableArray *_monstersHit;
	
}
// generate getter and setter
@property (nonatomic, retain) NSMutableArray *monstersHit;

// instance methods
- (Projectile*)initWithFile:(NSString *)file;
- (BOOL)shouldDamageMonster:(CCSprite *)monster;

@end

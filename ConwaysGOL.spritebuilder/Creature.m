//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"


@implementation Creature {

}
- (id)initCreature {
    self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];

    if (self) {
        self.isAlive = false;
    }

    return self;
}
@end

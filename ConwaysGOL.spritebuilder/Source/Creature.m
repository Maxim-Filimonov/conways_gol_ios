//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"


@implementation Creature {

}
- (void)setIsAlive:(BOOL)isAlive {
    _isAlive = isAlive;
    self.visible = _isAlive;
}

- (id)initCreature {
    self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];

    if (self) {
        self.isAlive = FALSE;
    }

    return self;
}
@end

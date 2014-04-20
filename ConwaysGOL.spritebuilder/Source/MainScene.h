//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CCLabelTTF.h"

@class Grid;

@interface MainScene : CCNode

@property(nonatomic, strong) CCLabelTTF *generationLabel;
@property(nonatomic, strong) CCLabelTTF *populationLabel;

@property(nonatomic, strong) Grid *grid;

- (void)play;

- (void)pause;
@end

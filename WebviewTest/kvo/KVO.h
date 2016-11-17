//
//  Facade.h
//  eContact
//
//  Created by zouxu on 14/6/14.
//  Copyright (c) 2014 zouxu. All rights reserved.
//


#import <Foundation/Foundation.h>

//亲，多线程别忘atomic
//@property(atomic, strong)NSString* str;

typedef void (^KvoBlk)(id object, NSString* keyPath, NSDictionary *change, id content);

@interface KVO : NSObject
+ (KVO *)shared;

-(void)observeAdd:(id)object keyPath:(NSString*)keyPath blk:(KvoBlk)blk content:(id)content;
-(void)observeRemove:(id)object keyPath:(NSString*)keyPath;
-(void)observeRemoveAll:(id)object;

@end

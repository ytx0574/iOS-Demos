//
//  Object.m
//  NS_DESIGNATED_INITIALIZER
//
//  Created by Johnson on 11/06/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import "Object.h"


    @interface Object()

    - (instancetype)initObject NS_DESIGNATED_INITIALIZER;

    - (instancetype)initObject1 NS_DESIGNATED_INITIALIZER;

    - (instancetype)initObject2;

    @end

    @implementation Object


    - (instancetype)init
    {
        self = [self initObject];
        if (self) {
            
        }
        return self;
    }


    - (instancetype)initObject;
    {
        return self = [super init];
    }

    - (instancetype)initObject1;
    {
        return self = [super init];
    }

    - (instancetype)initObject2;
    {
        return self = [self initObject3];
    }


    - (instancetype)initObject3;
    {
        return self = [self initObject1];
    }

    @end


    @interface SubObject()

    - (instancetype)initSubObject NS_DESIGNATED_INITIALIZER;

    @end

    @implementation SubObject


    - (instancetype)initSubObject
    {
        return self = [super initObject];
    }

    - (instancetype)initObject;
    {
        return self = [self initSubObject];
    }

    - (instancetype)initObject1;
    {
        return self = [self initObject3];
    }

    - (instancetype)initObject3;
    {
        return self = [self initObject];
    }

    - (instancetype)initObject2;
    {
        return self = [self initObject2];
    //    return self = [self initObject];
    //    return self = [self initObject3];
    //    return self = [super initObject];
    }

    @end

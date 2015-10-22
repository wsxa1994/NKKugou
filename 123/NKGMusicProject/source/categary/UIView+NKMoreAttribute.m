//
//  UIView+NKMoreAttribute.m
//  NKGMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIView+NKMoreAttribute.h"

@implementation UIView (NKMoreAttribute)

-(CGFloat)width{

    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}
-(CGFloat)left{
    return self.frame.origin.x;

}
-(CGFloat)right{

    return self.frame.origin.x +self.frame.size.width;
}

-(CGFloat)top{

    return self.frame.origin.y;
}
-(CGFloat)bottom{

    return self.frame.origin.y +self.frame.size.height;
}
@end

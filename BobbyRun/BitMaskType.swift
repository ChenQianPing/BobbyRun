//
//  BitMaskType.swift
//  位运算标识类,碰撞标识类
//
//  Created by ChenQianPing on 16/6/7.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//


// 记录着物理世界里的种类标示符.有小人,平台,场景边缘,苹果4种标识。
class BitMaskType {
    class var bobby:UInt32 {
        return 1<<0
    }
    class var platform:UInt32 {
        return 1<<1
    }
    class var apple:UInt32 {
        return 1<<2
    }
    class var scene:UInt32{
        return 1<<3
    }
    
}

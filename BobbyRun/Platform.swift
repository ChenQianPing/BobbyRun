//
//  Platform.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit

// 平台类
class Platform:SKNode {
    
    var width :CGFloat = 0.0     // 宽
    var height :CGFloat = 10.0   // 高
    
    var isDown = false           // 是否下沉
    var isShock = false          // 是否振动
    
    // 我们需要写一个onCreate方法来组装平台的零件.
    // onCreate接受一个SKSpriteNode类型的数组。并将数组内的元素按顺序水平排好,加入当前类中的实例中。
    func onCreate(_ arrSprite:[SKSpriteNode]) {
        
        // 通过接受SKSpriteNode数组来创建平台
        for platform in arrSprite {
            platform.position.x = self.width     // 以当前宽度为平台零件的x坐标
            self.addChild(platform)              // 加载
            self.width += platform.size.width    // 更新宽度
        }
        
        // 短到只有三小块的平台会下落
        // 当平台的零件只有三样,左中右时,设为会下落的平台
        if arrSprite.count <= 3 {
            isDown = true
        } else {
            // 随机振动
            let random = arc4random() % 10
            if random > 6 {
                isShock = true
            }
        }

        self.height = 10.0
        
        // 设置物理系统及场景碰撞
        
        // 设置物理体为当前高宽组成的矩形
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: self.height),center:CGPoint(x: self.width/2, y: 0))
        self.physicsBody?.categoryBitMask = BitMaskType.platform   // 设置物理标识
        self.physicsBody?.isDynamic = false                        // 不响应响应物理效果
        self.physicsBody?.allowsRotation = false                   // 不旋转
        self.physicsBody?.restitution = 0                          // 弹性0
        
        self.zPosition = 20  // 这个属性决定了渲染顺序,越小越先渲染,也就是越小越在后面.
    }
    
}

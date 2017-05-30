//
//  PlatformFactory.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit

// 平台的工厂类,它负责产生平台零件然后传给平台类进行组装.
// 在编码的时候,我们应该根据功能设计不同的类负责不同的功能.这样各司其职结构清晰,也方便日后的扩展修改。
// 在工厂类中,存有平台的纹理。
class PlatformFactory:SKNode {
    let textureLeft = SKTexture(imageNamed: "platform_l")    // 定义平台左边纹理
    let textureMid = SKTexture(imageNamed: "platform_m")     // 定义平台中间纹理
    let textureRight = SKTexture(imageNamed: "platform_r")   // 定义平台右边纹理
    
    var platforms = [Platform]()       // 定义一个数组来储存组装后的平台
    var screenWdith:CGFloat = 0.0      // 游戏场景的宽度
    var delegate:ProtocolMainscreen?   // ProtocolMainScene代理
    
    // 生成随机位置的平台的方法
    // 用来创建随机位置的平台.
    // 当然,在方法中会调用之前的createPlatform方法。
    // 方法名为createPlatformRandom.
    func createPlatformRandom(){
        let midNum = arc4random()%4 + 1                 // 随机平台的长度
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)   // 随机间隔
        let x = self.screenWdith + CGFloat(midNum*50) + gap + 100  // 随机x坐标
        let y = CGFloat(arc4random()%200 + 200)                    // 随机y坐标
        
        createPlatform(midNum, x: x, y: y)
    }
    
    
    // createPlatform,它接收四个参数。
    // minNum就是生成几个中间部分。
    // x与y就是位置坐标了
    func createPlatform(_ midNum:UInt32,x:CGFloat,y:CGFloat) {
        let platform = Platform()                                 // 声明一个平台类,用来组装平台
        let platform_left = SKSpriteNode(texture: textureLeft)    // 生成平台的左边零件
        platform_left.anchorPoint = CGPoint(x: 0, y: 0.9)         // 设置中心点
        
        let platform_right = SKSpriteNode(texture: textureRight)    // 生成平台的右边零件
        platform_right.anchorPoint = CGPoint(x: 0, y: 0.9)          // 设置中心点
        
        var arrPlatform = [SKSpriteNode]()   // 声明一个数组来存放平台的零件
        arrPlatform.append(platform_left)    // 将左边零件加入零件数组
        
        platform.position = CGPoint(x: x, y: y)  // 设置平台的位置
        
        // 根据传入的参数来决定要组装几个平台的中间零件
        // 然后将中间的零件加入零件数组
        for _ in 1...midNum {
            let platform_mid = SKSpriteNode(texture: textureMid)
            platform_mid.anchorPoint = CGPoint(x: 0, y: 0.9)
            arrPlatform.append(platform_mid)
        }
        arrPlatform.append(platform_right)  // 将右边零件加入零件数组
        platform.onCreate(arrPlatform)      // 将零件数组传入
        platform.name = "platform"
        self.addChild(platform)             // 放到当前实例中
        
        platforms.append(platform)          // 将平台加入平台数组
        
        // 回传距离用于判断什么时候生成新的平台
        self.delegate?.onGetData(platform.width + x - screenWdith,theY:y)
        
    }
    
    func move(_ speed:CGFloat) {
        // 遍历所有平台
        for p in platforms {
            let position = p.position
            p.position = CGPoint(x: position.x - speed, y: position.y)
        }
        
        // 移除平台
        if platforms[0].position.x < -platforms[0].width{
            platforms[0].removeFromParent()   // 从平台工厂类中移除
            platforms.remove(at: 0)           // 从平台数组中移除
        }
    }
    
    // 清楚所有的Node
    func reset() {
        self.removeAllChildren()
        platforms.removeAll(keepingCapacity: false)
    }
}

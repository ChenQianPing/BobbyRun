//
//  AppleFactory.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/7.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit

class AppleFactory:SKNode {
    let appleTexture = SKTexture(imageNamed: "apple")   // 定义苹果纹理
    var sceneWidth:CGFloat = 0.0                        // 游戏场景的宽度
    var arrApple = [SKSpriteNode]()   // 定义苹果数组
    var timer = Timer()               // 定时器
    var theY:CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onInit(_ width:CGFloat, y:CGFloat) {
        
        self.sceneWidth = width
        self.theY = y
        
        // 启动的定时器
        timer = Timer.scheduledTimer( timeInterval: 0.2, target: self, selector: #selector(AppleFactory.createApple), userInfo: nil, repeats: true)
    }
    
    // 创建苹果类
    func createApple() {
        // 通过随机数来随机生成苹果
        // 算法是:随机生成0-9的数,当随机数大于8的时候生成苹果
        // 也就是说,有1/10的几率生成苹果
        // 这样游戏场景中的苹果就不会整整齐齐以相同间隔出现了
        let random = arc4random() % 10
        if random > 8 {
            let apple = SKSpriteNode(texture: appleTexture)   // 生成苹果
            
            apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size)      // 设置物理体
            apple.physicsBody!.restitution = 0                              // 弹性设为0
            apple.physicsBody!.categoryBitMask = BitMaskType.apple          // 物理体标识
            apple.physicsBody!.isDynamic = false                              // 不受物理效果影响
            apple.anchorPoint = CGPoint(x: 0, y: 0)                           // 设置中心点
            
            apple.zPosition = 40                                                      // z轴深度
            apple.position  = CGPoint(x: sceneWidth+apple.frame.width , y: theY + 150)  // 设定位置
            arrApple.append(apple)   // 加入数组
            self.addChild(apple)     // 加入场景
        }
    }
    
    // 苹果移动方法
    func move(_ speed:CGFloat){
        for apple in arrApple {
            apple.position.x -= speed
        }
        
        // 移出屏幕外时移除苹果
        if arrApple.count > 0 && arrApple[0].position.x < -20 {
            arrApple[0].removeFromParent()
            arrApple.remove(at: 0)
        }
        
    }
    
    // 重置方法
    func reSet(){
        self.removeAllChildren()                     // 移除所有子对象
        arrApple.removeAll(keepingCapacity: false)   // 清空苹果数组
    }
}

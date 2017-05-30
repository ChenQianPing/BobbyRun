//
//  Bobby.swift
//  奔跑小人类
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit   // 导入SpriteKit框架

// 创建一个枚举值,用来记录Bobby的不同状态,分别是跑,跳,二段跳,打滚
// 在Swift中,当给枚举的首个名称设置整型值时,接下来的名称会自动顺序填充。
// 例如下面的run=1之后,jump就为2,jump2就为3,roll就为4
enum Status:Int {
    case run = 1, jump , jump2 ,roll
}


class Bobby : SKSpriteNode {
    
    let runAtlas = SKTextureAtlas(named: "run.atlas")    // 常量用来获取跑这个动作的文理集合
    var runFrames = [SKTexture]()                        // 一个数组常量来储存跑动动画文理

    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")  // 跳的纹理集合
    var jumpFrames = [SKTexture]()                       // 存储跳的文理的数组
    
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")  // 打滚的文理集合
    var rollFrames = [SKTexture]()                       // 存储打滚文理的数组
    
    // 增加跳起的逼真效果动画
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")   // 起跳特效纹理集
    var jumpEffectFrames = [SKTexture]()                               // 存储起跳特效纹理的数组
    var jumpEffect = SKSpriteNode()                                    // 起跳特效
    
    
    // 动作状态,默认值为枚举中的跑
    var status = Status.run
    
    var jumpStart:CGFloat = 0.0   // 起跳 y坐标
    var jumpEnd:CGFloat = 0.0     // 落地 y坐标
    
    // 构造器
    // 让Bobby显示在场景中。我们只需要在构造器中给Bobby的父类也就是SKSpriteNode的构造器传入3个参数。
    // 分别是文理（texture）,默认颜色(color),默认尺寸(size)
    init() {
        // 在构造器中用跑这个动画的第一张文理作为默认的文理.
        let texture = runAtlas.textureNamed("panda_run_01")
        // 用这个纹理的尺寸作为Bobby类的默认尺寸
        let size = texture.size()
        // SKColor.whiteColor()获取白色的色值
        super.init(texture:texture,color:SKColor.white,size:size)
        
        // 跑,显示一个动态的Bobby
        
        // Swift 3.0取消了C风格的for循环,for var i = 0 ;i < 10 ; i += 1语句变更为：for i in 0 ..< 10
        
        // for var i = 1; i<=runAtlas.textureNames.count; i += 1 {
        // for var i = 1; i<=jumpAtlas.textureNames.count; i += 1 {
        // for var i = 1; i<=rollAtlas.textureNames.count; i += 1 {
        // for var i=1 ; i <= jumpEffectAtlas.textureNames.count ; i += 1 {

        for i in 1 ..< runAtlas.textureNames.count {
            let tempName = String(format: "panda_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)

            runFrames.append(runTexture)
        }
        
        // 跳
        for i in 1 ..< jumpAtlas.textureNames.count {
            let tempName = String(format: "panda_jump_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            
            jumpFrames.append(jumpTexture)
            
        }
        
        // 滚
        for i in 1 ..< rollAtlas.textureNames.count {
            let tempName = String(format: "panda_roll_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            rollFrames.append(rollTexture)
        }
        
        // 起跳特效,跳的时候的点缀效果
        for i in 1 ..< jumpEffectAtlas.textureNames.count {
            let tempName = String(format: "jump_effect_%.2d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)
            jumpEffectFrames.append(effectexture)
        }
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPoint(x: -80, y: -30)
        jumpEffect.isHidden = true
        self.addChild(jumpEffect)
        
        // 设置物理系统及场景碰撞
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.1        // 反弹力
        self.physicsBody?.categoryBitMask = BitMaskType.bobby
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.apple
        self.physicsBody?.collisionBitMask = BitMaskType.platform
        
        self.zPosition = 20

         run()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 跑
    func run() {
        self.removeAllActions()  // 移除所有的动作
        self.status = .run       // 将当前动作状态设为跑
        
        // 重复跑动动作
        // 通过SKAction.animateWithTextures将跑的文理数组设置为0.05秒切换一次的动画
        // SKAction.repeatActionForever将让动画永远执行
        // self.runAction执行动作形成动画
        self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05)))
    }
    
    // 跳
    func jump () {
        self.removeAllActions()
        
        if status != .jump2 {
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05),withKey:"jump")
            
            // 施加一个向上的力,让小人跳起来
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 450)
            
            if status == Status.jump {
                // 由于跳和打滚的动作不像跑的动作需要循环播放,所以就不需要用repeatActionForever.
                // 而跳跃动作由于不知道什么时候落地,所以将会由外部控制它的动作转变.
                self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05))
                status = Status.jump2
                self.jumpStart = self.position.y  // 刷新熊猫起跳点
            } else {
                showJumpEffect()
                status = .jump
            }
        }
        
    }
    
    // 打滚
    func roll() {
        self.removeAllActions()
        status = .roll
        // 打滚动作结束后就执行跑步动作.
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05),completion:{() in self.run()})
    }
    
    // 起跳特效
    func showJumpEffect() {
        // 先将特效取消隐藏
        jumpEffect.isHidden = false
        // 利用action播放特效
        let ectAct = SKAction.animate( with: jumpEffectFrames, timePerFrame: 0.05)
        
        // 执行闭包,再次隐藏特效
        let removeAct = SKAction.run({() in
            self.jumpEffect.isHidden = true
        })
        
        // 组成序列Action进行执行,执行两个动作,先显示,后隐藏
        jumpEffect.run(SKAction.sequence([ectAct,removeAct]))
    }

    
}

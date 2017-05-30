//
//  GameScene.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright (c) 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit

// 定义一个协议,用来接收数据
protocol ProtocolMainscreen {
    func onGetData(_ dist:CGFloat,theY:CGFloat)
}

class GameScene: SKScene {
    lazy var panda  = Bobby()
    lazy var platformFactory = PlatformFactory()
    lazy var sound = SoundManager()
    lazy var bg = BackGround()
    lazy var appleFactory = AppleFactory()
    
    let scoreLab = SKLabelNode(fontNamed:"Chalkduster")
    let appLab = SKLabelNode(fontNamed:"Chalkduster")
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var appleNum = 0                // 吃到的苹果数
    var moveSpeed :CGFloat = 15.0   // 移动速度
    var maxSpeed :CGFloat = 15.0    // 最大速度,默认为50.0
    var distance:CGFloat = 0.0      // 跑了多远变量
    var lastDis:CGFloat = 0.0       // 接收PlatformFactory传过来的变量,判断最后一个平台还有多远完全进入游戏场景
    var theY:CGFloat = 0.0
    var isLose = false              // 是否game over
    
    override func didMove(to view: SKView) {
        // 场景的背景颜色
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor
        
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLab.position = CGPoint(x: 20, y: self.frame.size.height-150)
        scoreLab.text = "run: 0 km"
        self.addChild(scoreLab)
        
        appLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        appLab.position = CGPoint(x: 400, y: self.frame.size.height-150)
        appLab.text = "eat: \(appleNum) apple"
        self.addChild(appLab)
        
        myLabel.text = "";
        myLabel.fontSize = 65;
        myLabel.zPosition = 100
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(myLabel)
        
        // 设置物理系统及场景碰撞
        self.physicsWorld.contactDelegate = self                            // 物理世界代理
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)                 // 重力设置
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)          // 设置物理体
        self.physicsBody!.categoryBitMask = BitMaskType.scene               // 设置种类标示
        self.physicsBody!.isDynamic = false                                 // 是否响应物理效果
        
        panda.position = CGPoint(x: 200, y: 400)   // 给Bobby定一个初始位置
        self.addChild(panda)                       // 将Bobby显示在场景中
        self.addChild(platformFactory)             // 将平台工厂加入视图
        
        platformFactory.screenWdith = self.frame.width  // 将屏幕的宽度传到平台工厂类中
        platformFactory.delegate = self                 // 设置代理
        platformFactory.createPlatform(3, x: 0, y: 200) // 初始平台让小人有立足之地
        
        self.addChild(bg)   // 设置背景
        
        self.addChild(sound)
        sound.playBackgroundMusic()
        
        appleFactory.onInit(self.frame.width, y: theY)   // 苹果工厂
        self.addChild(appleFactory)
        
    }
    
    
    // up and down 方法(平台震动一下)
    func downAndUp(_ node :SKNode,down:CGFloat = -50,downTime:CGFloat=0.05,up:CGFloat=50,upTime:CGFloat=0.1,isRepeat:Bool=false) {
        
        let downAct = SKAction.moveBy(x: 0, y: down, duration: Double(downTime))  // 下沉动作
        let upAct = SKAction.moveBy(x: 0, y: up, duration: Double(upTime))        // 上升动过
        
        let downUpAct = SKAction.sequence([downAct,upAct])                        // 下沉上升动作序列
        
        if isRepeat {
            node.run(SKAction.repeatForever(downUpAct))
        } else {
            node.run(downUpAct)
        }
    }

    // 触碰屏幕响应的方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isLose {
            reSet()
        } else{
            if panda.status != Status.jump2 {
                sound.playJump()
            }
            panda.jump()
        }
    }
    
    // 重新开始游戏
    func reSet(){
        isLose = false                         // 重置isLose变量
        panda.position = CGPoint(x: 200, y: 400) // 重置小人位置
        myLabel.text = ""
        moveSpeed  = 15.0                      // 重置移动速度
        distance = 0.0                         // 重置跑的距离
        lastDis = 0.0                          // 重置首个平台完全进入游戏场景的距离
        self.appleNum = 0
        platformFactory.reset()                // 平台工厂的重置方法
        appleFactory.reSet()
        platformFactory.createPlatform(3, x: 0, y: 200)   // 创建一个初始的平台给熊猫一个立足之地
        sound.playBackgroundMusic()
    }
    
    // 在update方法方法中调用平台工厂类的移动方法
    override func update(_ currentTime: TimeInterval) {
        if isLose {
            
        }else {
            if panda.position.x < 200 {  // 如果小人出现了位置偏差,就逐渐恢复
                let x = panda.position.x + 1
                panda.position = CGPoint(x: x, y: panda.position.y)
            }
            distance += moveSpeed
            lastDis -= moveSpeed
            var tempSpeed = CGFloat(5 + Int(distance/2000))  // 速度以5为基础,以跑的距离除以2000为增量
            
            
            if tempSpeed > maxSpeed {    // 将速度控制在maxSpeed
                tempSpeed = maxSpeed
            }
            if moveSpeed < tempSpeed {   // 如果移动速度小于新的速度就改变
                moveSpeed = tempSpeed
            }
            
            if lastDis < 0 {
                platformFactory.createPlatformRandom()
            }
            distance += moveSpeed
            scoreLab.text = "run: \(Int(distance/1000*10)/10) km"
            appLab.text = "eat: \(appleNum) apple"
            platformFactory.move(moveSpeed)
            bg.move(moveSpeed/5)  // 背景的滚动也需要在GameScene的update中实现
            appleFactory.move(moveSpeed)
        }
    }
}


extension GameScene:ProtocolMainscreen {
    func onGetData(_ dist:CGFloat,theY:CGFloat) {
        self.lastDis = dist
        self.theY = theY
        appleFactory.theY = theY
    }
}

extension GameScene:SKPhysicsContactDelegate {
    
    // 碰撞检测方法
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 熊猫和苹果碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.apple | BitMaskType.bobby){
            sound.playEat()
            self.appleNum += 1    // 苹果计数加1
            
            // 如果碰撞体A是苹果,隐藏碰撞体A,反之隐藏碰撞体B
            // 因为苹果出了屏幕都会被移除,所以这里隐藏就可以了
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node!.isHidden = true
            } else {
                contact.bodyB.node!.isHidden = true
            }
        }
        
        // 熊猫和台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.bobby) {
            
            // 假设平台不会下沉,用于给后面判断平台是否会被熊猫震的颤抖
            var isDown = false
            // 用于判断接触平台后能否转变为跑的状态,默认值为false不能转换
            var canRun = false
            
            // 如果碰撞体A是平台
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! Platform).isDown {  // 如果是会下沉的平台
                    isDown = true
                    contact.bodyA.node!.physicsBody!.isDynamic = true        // 让平台接收重力影响
                    
                    // 不将碰撞效果取消,平台下沉的时候会跟着熊猫跑这不是我们希望看到的,
                    // 大家可以将这行注释掉看看效果
                    contact.bodyA.node!.physicsBody!.collisionBitMask = 0
                    
                    // 如果是会升降的平台...
                    
                } else if (contact.bodyA.node as! Platform).isShock {
                    (contact.bodyA.node as! Platform).isShock = false
                    downAndUp(contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun=true
                }
                
            } else if contact.bodyB.categoryBitMask == BitMaskType.platform  {  // 如果碰撞体B是平台
                if (contact.bodyB.node as! Platform).isDown {
                    contact.bodyB.node!.physicsBody!.isDynamic = true
                    contact.bodyB.node!.physicsBody!.collisionBitMask = 0
                    isDown = true
                } else if (contact.bodyB.node as! Platform).isShock {
                    (contact.bodyB.node as! Platform).isShock = false
                    downAndUp(contact.bodyB.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun=true
                }
                
            }
            
            // 判断是否打滚
            panda.jumpEnd = panda.position.y
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
                sound.playRoll()
                
                // 如果平台下沉就不让它被震得颤抖一下
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
                
            } else {
                if canRun {
                    panda.run()
                }
                
            }
        }
        
        // 如果熊猫和场景边缘碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.bobby) {
            print("game over")
            myLabel.text = "game over"
            sound.playDead()
            isLose = true
            sound.stopBackgroundMusic()
        }
        
        // 落地后jumpstart数据要设为当前位置,防止自由落地计算出错
        panda.jumpStart = panda.position.y
    }
    
    // 离开平台时记录起跳点
    func didEnd(_ contact: SKPhysicsContact) {
        panda.jumpStart = panda.position.y
        
    }
}


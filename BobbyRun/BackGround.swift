//
//  BackGround.swift
//  视差滚动背景,场景的动态背景图类
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit

class BackGround :SKNode {
    
    var arrBG = [SKSpriteNode]()   // 近处背景数组
    var arrFar = [SKSpriteNode]()  // 远处背景数组
    
    override init() {
        super.init()
        let farTexture = SKTexture(imageNamed: "background_f1")  // 获取远处背景的纹理
        
        let farBg0 = SKSpriteNode(texture: farTexture)           // 远处背景由3张无缝图衔接而成
        farBg0.position.y = 150
        farBg0.zPosition = 9
        farBg0.anchorPoint = CGPoint(x: 0, y: 0)
        
        let farBg1 = SKSpriteNode(texture: farTexture)
        farBg1.position.y = 150
        farBg1.zPosition = 9
        farBg1.anchorPoint = CGPoint(x: 0, y: 0)
        farBg1.position.x = farBg1.frame.width
        
        let farBg2 = SKSpriteNode(texture: farTexture)
        farBg2.position.y = 150
        farBg2.zPosition = 9
        farBg2.anchorPoint = CGPoint(x: 0, y: 0)
        farBg2.position.x = farBg2.frame.width*2
        
        self.addChild(farBg0)
        self.addChild(farBg1)
        self.addChild(farBg2)
        arrFar.append(farBg0)
        arrFar.append(farBg1)
        arrFar.append(farBg2)
        
        let texture = SKTexture(imageNamed: "background_f0")      // 近处背景纹理
        let bg0 = SKSpriteNode(texture: texture)                  // 近处背景由2张无缝衔接图组成
        bg0.anchorPoint = CGPoint(x: 0, y: 0)
        bg0.position.y = 70
        bg0.zPosition = 10
        
        let bg1 = SKSpriteNode(texture: texture)
        bg1.anchorPoint = CGPoint(x: 0, y: 0)
        bg1.position.y = 70
        bg1.zPosition = 10
        bg1.position.x = bg0.frame.size.width
        
        self.addChild(bg0)
        self.addChild(bg1)
        arrBG.append(bg0)
        arrBG.append(bg1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 移动方法
    func move(_ speed:CGFloat){
        // 近景,通过遍历获取背景,然后做x方向的改变
        for bg in arrBG {
            bg.position.x -= speed
        }
        
        // 循环滚动算法
        if arrBG[0].position.x + arrBG[0].frame.size.width < speed {
            arrBG[0].position.x = 0
            arrBG[1].position.x = arrBG[0].frame.size.width
        }
        
        // 远景
        for far in arrFar {
            far.position.x -= speed/4
            
        }
        if arrFar[0].position.x + arrFar[0].frame.size.width < speed/4 {
            arrFar[0].position.x = 0
            arrFar[1].position.x = arrFar[0].frame.size.width
            arrFar[2].position.x = arrFar[0].frame.size.width * 2
        }
        
    }

}

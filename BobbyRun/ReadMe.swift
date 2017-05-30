//
//  ReadMe.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/6.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//


/**

 学习目标
 1.进一步学习Swift的游戏制作
 2.掌握SKNode,SKSpriteNode的运用
 3.了解SpriteKit的物理系统
 4.掌握动作（SKAction）的运用


波比快跑是一个跑酷类的游戏.我们将操控熊猫这个胖纸施展轻功,在或长或短的平台上飞奔,同时还要收集小苹果.跑的越远,收集的苹果越多,成就越高.不小心掉落平台,游戏就失败.那么做这样一个游戏,我们脑中要有一个概念,我们该按照什么样的顺序完成它.我们经过分析将之形成一个清单,如下:

l  我们要做一个能跑能跳能滚的熊猫
l  我们要产生源源不断的平台,以便熊猫能在上面飞奔
l  我们要制作视差移动的背景,让游戏看上去更为真实
l  我们要产生很多小苹果,让熊猫去收集
l  我们需要记录熊猫跑了多长距离,收集了多少个苹果
l  我们要给游戏增加难度,让熊猫跑动的速度越来越快
l  我们要给游戏增加些亮点让熊猫起跳和滚动的时候有个尘土飞扬的效果
l  我们要制作不同类型的平台,让它或掉落,或上下移动,增加游戏的趣味性
l  我们要给游戏配上背景音乐和一些音效
l  最后,我们还要判断游戏的失败,然后重置,开始新的游戏

 */


/* 

Bobby.swift            奔跑小人类,跑,跳,二段跳,打滚
BackGround.swift       背景类,视差滚动背景,场景的动态背景图类
Platform.swift         平台类
PlatformFactory.swift  平台工厂类
AppleFactory.swift     苹果工厂类
SoundManager.swift     声音管理类
BitMaskType.swift      碰撞标识类
GameScene.swift        主场景类

*/


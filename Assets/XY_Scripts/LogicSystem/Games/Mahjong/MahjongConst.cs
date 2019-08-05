using UnityEngine;
using System.Collections;

/// <summary>
/// 麻将初始化常量
/// </summary>
public class MahjongConst {

    public const bool IsUsed2DCamera = true;//是否使用2d相机

    public const float MahjongOffset_x = 0.29f;//麻将宽度
    public const float MahjongOffset_y = 0.21f;//麻将厚度
    public const float MahjongOffset_z = 0.41f;//麻将长度

    public const int OutCardNum_x = 5;//出牌区每行个数
    public const int OutCardNum_y = 4;//出牌区每列个数

    public const int MahjongPlayerCount = 4;//人数
    public const int MahjongTotalCount = 136;//总牌数
    public const int MahjongHandCount = 14;//手牌
    public const int MahjongMaxOutCount = 0;//最多出牌数

    public const float MahjongAnimationTime = 0.05f;//麻将动画时间
    public const float MahjongOperCardInterval = 0.2f;//麻将操作牌间距
}


public enum MahjongKind
{
    Character = 0,//万
    Bamboo = 10,//条
    Dot = 20,//筒
    Wind = 30,//风
    Flower = 40,//花
    Unknown = 0xff,
}

public enum MahjongPlace
{
    牌墩,
    手牌,
    出牌,
    操作牌,
    癞子标志,
    马牌,
}

public enum MahjongOperAll
{
    None,
    GiveUp,//过,
    Collect,//吃,
    TripletLeft,//碰左,
    TripletCenter,//碰中,
    TripletRight,//碰右,
    DarkBar,//暗杠,
    BrightBarLeft,//明杠左,
    BrightBarCenter,//明杠中,
    BrightBarRight,//明杠右,
    AddBarLeft,//补杠左,
    AddBarCenter,//补杠中,
    AddBarRight,//补杠右,
    Ting,//听,
    Hu,//胡,
}

public enum MahjongExtraOper
{
    DingLai,//定癞,
    DingQue,//定缺,
    HuanPai,//换牌,
    XiaPao,//吓跑,

}
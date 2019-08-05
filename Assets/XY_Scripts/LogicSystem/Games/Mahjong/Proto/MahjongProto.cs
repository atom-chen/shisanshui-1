using System.Collections.Generic;

namespace Mahjong
{
    public class GameStart
    {

    }

    public class Deal
    {
        public int[] cards = new int[4];
        public int currentCardNum;
        public int banker;
        public int roundWind;// 圈风  东所在的位置 首轮东就是庄
        public int subRound;// 该圈第几轮
        public int[] dice = new int[2];// 两个 骰子
        public Dictionary<string, int> cardCount = new Dictionary<string, int>();
        public int cardLeft;//剩余牌数
    }


}
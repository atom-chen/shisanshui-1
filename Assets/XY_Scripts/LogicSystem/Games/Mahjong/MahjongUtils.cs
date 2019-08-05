using UnityEngine;
using System.Collections;

public class MahjongUtils : MonoBehaviour {

    public static int MahjongMeshIndexToValue(int index)
    {
        if (index >= 0 && index < 9)//条
        {
            return 0;
        }
        else if (index >= 9 && index < 18)//万
        {
            return 0;
        }
        else if (index >= 18 && index < 27)//筒
        {
            return 0;
        }
        else if (index >= 27 && index < 30)//发中白
        {
            return 0;
        }
        else if (index >= 30 && index < 34)//花
        {
            return 0;
        }
        else if (index >= 34 && index < 38)//季节
        {
            return 0;
        }
        else if (index >= 38 && index < 42)//东南西北
        {
            return 0;
        }
        return 0;
    }

    public static int MahjongValueToMeshIndex(int value)
    {
        if (value >= 1 && value < 10)//万
        {
            return value + 8;
        }
        else if (value >= 11 && value < 20)//条
        {
            return value - 11;
        }
        else if (value >= 21 && value < 30)//筒
        {
            return value - 3;
        }
        else if (value >= 31 && value < 35)//东南西北
        {
            return value + 7;
        }
        else if (value >= 35 && value < 38)//发中白
        {
            return value - 8;
        }
        else if (value >= 40 && value < 44)//季节
        {
            return value - 6;
        }
        else if (value >= 45 && value < 48)//花
        {
            return value - 10;
        }
        return 0;
    }
}

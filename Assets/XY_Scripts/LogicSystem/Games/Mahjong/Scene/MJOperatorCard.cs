using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class MJOperatorCard : MonoBehaviour {

    public float Width
    {
        get { return GetOperWidth(); }
    }

    private MJItem _keyItem;
    public MJItem KeyItem
    {
        get
        {
            return _keyItem;
        }
    }

    private List<MJItem> operList;

    private float OffsetZ = (MahjongConst.MahjongOffset_z - MahjongConst.MahjongOffset_x) / 2;

    private MJOperatorModel _operData;

    /// <summary>
    /// 显示
    /// </summary>
    /// <param name="data"></param>
    /// <param name="list"></param>
    /// <returns></returns>
    public IEnumerator Show(MJOperatorModel data,List<MJItem> list)
    {
        yield return null;
        operList = new List<MJItem>();
        int keyIndex;
        List<int> values = data.GetOperValue(out keyIndex);
        if (keyIndex != -1)
            _keyItem = list[keyIndex];
        float xOffset = 0;
        for(int i = 0; i < list.Count; ++i)
        {
            //list[i].PaiVal = values[i];
            list[i].transform.SetParent(transform);
            if (i == keyIndex || i == keyIndex-1)
            {
                list[i].transform.DOLocalMove(
                    new Vector3(xOffset, (MahjongConst.MahjongOffset_z + MahjongConst.MahjongOffset_x) / 2, 0), 
                    0.05f);
                list[i].transform.DOLocalRotate(new Vector3(0,90,0), 0.05f);
                xOffset += (MahjongConst.MahjongOffset_x+ MahjongConst.MahjongOffset_z)/ 2;
            }
            else
            {
                list[i].transform.DOLocalMove(new Vector3(xOffset, 0, 0), 0.05f);
                list[i].transform.DOLocalRotate(Vector3.zero, 0.05f);
                xOffset += MahjongConst.MahjongOffset_x;
            }
            operList.Add(list[i]);
        }
        yield return new WaitForSeconds(0.05f);
    }

    /// <summary>
    /// 增加
    /// </summary>
    /// <param name="data"></param>
    /// <param name="mj"></param>
    /// <returns></returns>
    public IEnumerator AddShow(MJOperatorModel data, MJItem mj)
    {
        yield return null;
        if (_operData.Oper != MahjongOperAll.None)
        {
            yield break;
        }
        _operData = data;
        Vector3 keyPos = _keyItem.transform.position;
        //mj.PaiVal = data.Pai;
        mj.transform.SetParent(transform);
        mj.transform.DOLocalMove(keyPos + new Vector3(0, 0, MahjongConst.MahjongOffset_x), 0.05f);
        mj.transform.DOLocalRotate(new Vector3(0, 90, 0), 0.05f);
        operList.Add(mj);
        yield return new WaitForSeconds(0.05f);
    }

    /// <summary>
    /// 获得操作牌组的宽度
    /// </summary>
    /// <returns></returns>
    private float GetOperWidth()
    {
        float width = 0;
        if (_operData != null)
        {
            switch (_operData.Oper)
            {
                case MahjongOperAll.Collect:
                    width = MahjongConst.MahjongOffset_x * 3;
                    break;
                case MahjongOperAll.TripletLeft:
                case MahjongOperAll.TripletCenter:
                case MahjongOperAll.TripletRight:
                    width = MahjongConst.MahjongOffset_x * 2 + MahjongConst.MahjongOffset_z;
                    break;
                case MahjongOperAll.DarkBar:
                    width = MahjongConst.MahjongOffset_x * 4;
                    break;
                case MahjongOperAll.BrightBarLeft:
                case MahjongOperAll.BrightBarCenter:
                case MahjongOperAll.BrightBarRight:
                case MahjongOperAll.AddBarLeft:
                case MahjongOperAll.AddBarCenter:
                case MahjongOperAll.AddBarRight:
                    width = MahjongConst.MahjongOffset_x * 3 + MahjongConst.MahjongOffset_z;
                    break;
                default:
                    Debug.LogError("GetOperWidth _operData.Oper:" + _operData.Oper.ToString());
                    break;
            }
        }
        return width;
    }
}

/// <summary>
/// 操作牌数据存储类
/// </summary>
public class MJOperatorModel
{
    public MahjongOperAll Oper;
    public int Pai;//关键牌，别人打的牌
    public int[] Pais;//其余牌

    public MJOperatorModel()
    {
        this.Oper = MahjongOperAll.None;
        this.Pai = 0;
        this.Pais = new int[3];
    }

    public MJOperatorModel(MahjongOperAll oper, int pai,int[] pais)
    {
        this.Oper = oper;
        this.Pai = pai;
        this.Pais = pais;
    }

    /// <summary>
    /// 更新
    /// </summary>
    /// <param name="o"></param>
    /// <param name="p"></param>
    /// <param name="pais"></param>
    public void SetValue(MahjongOperAll o, int p, int[] pais)
    {
        this.Oper = o;
        this.Pai = p;
        this.Pais = pais;
    }

    /// <summary>
    /// 得到牌值
    /// </summary>
    /// <param name="keyIndex">要横置的牌下标</param>
    /// <returns></returns>
    public List<int> GetOperValue(out int keyIndex)
    {
        List<int> values = new List<int>();
        values.Add(Pai);
        for(int i = 0; i < Pais.Length; ++i)
        {
            values.Add(Pais[i]);
        }
        values.Sort();
        keyIndex = -1;
        if (Pai != 0 && Oper!= MahjongOperAll.None)
        {
            switch (Oper)
            {
                case MahjongOperAll.TripletLeft:
                    keyIndex = 0;
                    break;
                case MahjongOperAll.TripletCenter:
                    keyIndex = 1;
                    break;
                case MahjongOperAll.TripletRight:
                    keyIndex = 2;
                    break;
                case MahjongOperAll.BrightBarLeft:
                    keyIndex = 0;
                    break;
                case MahjongOperAll.BrightBarCenter:
                    keyIndex = 1;
                    break;
                case MahjongOperAll.BrightBarRight:
                    keyIndex = 3;
                    break;
            }
        }
        return values;
    }
}

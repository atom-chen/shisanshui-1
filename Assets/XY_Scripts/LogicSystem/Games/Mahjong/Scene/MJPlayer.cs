using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class MJPlayer : MonoBehaviour
{

    public Transform _handCardPoint;
    public Transform _operCardPoint;
    public Transform _outCardPoint;

    public int viewSeat;
    private List<MJItem> handCardList;
    private List<MJItem> outCardList;
    private List<MJOperatorCard> operCardList;

    void Awake()
    {
        handCardList = new List<MJItem>();
        outCardList = new List<MJItem>();
        operCardList = new List<MJOperatorCard>();
    }

    public void AddHandCard(MJItem item)
    {
        handCardList.Add(item);
    }

    public MJItem GetLastOutCard()
    {
        if (outCardList.Count > 0)
            return outCardList[outCardList.Count - 1];
        return null;
    }

    public void Init()
    {
        if (viewSeat == 0)
        {
            for (int i = 0; i < handCardList.Count; i++)
            {
                handCardList[i].eventPai -= myPaiEvents;
                if (MahjongConst.IsUsed2DCamera)
                    handCardList[i].Layer = 0;
            }
        }
        handCardList.Clear();
        outCardList.Clear();
        operCardList.Clear();
    }

    public IEnumerator InitEvent()
    {
        yield return null;
        yield return StartCoroutine(SortHandCard());
        for (int i = 0; i < handCardList.Count; i++)
        {
            handCardList[i].eventPai += myPaiEvents;
        }
    }

    private void myPaiEvents(MJItem val)
    {
        int paiVal = val.PaiVal;
        //测试用 改请求
        StartCoroutine(OutCard(val.PaiVal));
    }

    /// <summary>
    /// 出牌
    /// </summary>
    /// <param name="paiValue"></param>
    /// <returns></returns>
    public IEnumerator OutCard(int paiValue)
    {
        yield return null;
        if (viewSeat == 0)
        {
            for (int i = 0; i < handCardList.Count; ++i)
            {
                if (handCardList[i].PaiVal == paiValue)
                {
                    MJItem item = handCardList[i];
                    handCardList[i].eventPai -= this.myPaiEvents;
                    handCardList.Remove(handCardList[i]);
                    StartCoroutine(DoOutCard(item));
                    yield break;
                }
            }
        }
        else
        {
            int index = Random.Range(0, handCardList.Count);
            MJItem item = handCardList[index];
            handCardList.Remove(handCardList[index]);
            item.PaiVal = paiValue;
            StartCoroutine(DoOutCard(item));
            yield break;
        }
    }

    IEnumerator DoOutCard(MJItem item)
    {
        yield return null;
        MJItem mj = item;
        mj.transform.SetParent(_outCardPoint);
        if (MahjongConst.IsUsed2DCamera && viewSeat == 0)
            mj.Layer = _outCardPoint.gameObject.layer;
        Vector3 endPos = GetOutCardPos();
        mj.transform.DOLocalMove(endPos + new Vector3(0.1f, 0, -0.15f), 0.05f);
        mj.transform.DOLocalRotate(Vector3.zero, 0.05f);
        outCardList.Add(mj);
        yield return new WaitForSeconds(0.05f);
        StartCoroutine(SortHandCard());
        yield return new WaitForSeconds(0.2f);
        mj.transform.DOLocalMove(endPos, 0.1f);

    }

    private Vector3 GetOutCardPos()
    {
        int x, z;
        int count = outCardList.Count;
        x = count % MahjongConst.OutCardNum_x;
        z = count / MahjongConst.OutCardNum_x;
        return new Vector3(x * MahjongConst.MahjongOffset_x, 0, -z * MahjongConst.MahjongOffset_z);
    }

    /// <summary>
    /// 排序
    /// </summary>
    /// <returns></returns>
    IEnumerator SortHandCard()
    {
        //handCardList.Sort();
        InsertSort(handCardList);
        for (int i = 0; i < handCardList.Count; ++i)
        {
            float x = i * MahjongConst.MahjongOffset_x;
            MJItem mj = handCardList[i];
            mj.transform.DOLocalMove(new Vector3(x, 0, 0), 0.05f);
            mj.transform.DOLocalRotate(Vector3.zero, 0.05f);
        }
        yield return new WaitForSeconds(0.05f);
    }

    /// <summary>
    /// 排序
    /// </summary>
    /// <param name="list"></param>
    private void InsertSort(List<MJItem> list)
    {
        for (int i = 1; i < list.Count; i++)
        {
            MJItem insertItem = list[i];
            int insertIndex = i - 1;

            while (insertIndex >= 0 && insertItem.PaiVal < list[insertIndex].PaiVal)
            {
                list[insertIndex + 1] = list[insertIndex];
                insertIndex--;
            }
            list[insertIndex + 1] = insertItem;
        }
    }

    /// <summary>
    /// 发牌
    /// </summary>
    /// <param name="paiValue"></param>
    /// <param name="item"></param>
    /// <returns></returns>
    public IEnumerator SentCard(int paiValue, MJItem item)
    {
        yield return null;
        item.PaiVal = paiValue;
        float x = handCardList.Count * MahjongConst.MahjongOffset_x;
        item.transform.SetParent(_handCardPoint);
        if(MahjongConst.IsUsed2DCamera && viewSeat == 0)
            item.Layer = _handCardPoint.gameObject.layer;
        item.transform.DOLocalMove(new Vector3(x, 0, 0), 0.05f);
        item.transform.DOLocalRotate(Vector3.zero, 0.05f);
        if (viewSeat == 0)
            item.eventPai += this.myPaiEvents;
        handCardList.Add(item);
        yield return new WaitForSeconds(0.05f);
    }

    /// <summary>
    /// 操作牌调用
    /// </summary>
    /// <param name="oper"></param>
    /// <returns></returns>
    public IEnumerator OperateCard(MJOperatorModel oper,MJItem item)
    {
        yield return null;
        switch (oper.Oper)
        {
            case MahjongOperAll.GiveUp:
                break;
            case MahjongOperAll.Collect:
            case MahjongOperAll.TripletLeft:
            case MahjongOperAll.TripletCenter:
            case MahjongOperAll.TripletRight:
            case MahjongOperAll.DarkBar:
            case MahjongOperAll.BrightBarLeft:
            case MahjongOperAll.BrightBarCenter:
            case MahjongOperAll.BrightBarRight:
                CreateOperCard(oper, item);
                break;
            case MahjongOperAll.AddBarLeft:
            case MahjongOperAll.AddBarCenter:
            case MahjongOperAll.AddBarRight:
                AddOperCard(oper, item);
                break;
            case MahjongOperAll.Ting:
            case MahjongOperAll.Hu:
                break;
        }
    }

    /// <summary>
    /// 创建操作牌
    /// </summary>
    /// <param name="data"></param>
    /// <param name="item"></param>
    private void CreateOperCard(MJOperatorModel data, MJItem item)
    {
        float xOffset = 0;
        for(int i = 0;i< operCardList.Count; ++i)
        {
            xOffset = xOffset + operCardList[i].Width + MahjongConst.MahjongOperCardInterval;
        }
        MJOperatorCard oper = new GameObject().AddComponent<MJOperatorCard>();
        oper.transform.SetParent(_operCardPoint);
        oper.transform.localPosition = new Vector3(xOffset, 0, 0);
        oper.Show(data, GetOperCardList(data, item));
        operCardList.Add(oper);
    }

    private List<MJItem> GetOperCardList(MJOperatorModel data, MJItem item)
    {
        int index = 0;
        List<MJItem> itemList = new List<MJItem>();
        int[] pais = data.Pais;
        for (int i = 0; i < pais.Length; ++i)
        {
            if (pais[i] > 0 && pais[i] < 48)
            {
                while (index < handCardList.Count)
                {
                    if (handCardList[index].PaiVal == pais[i])
                    {
                        itemList.Add(handCardList[index++]);
                        break;
                    }
                }
                Debug.LogError("GetOperCardList , oper card is not exist");
            }
            else
            {
                Debug.LogError("GetOperCardList data.Pais[" + i + "]:" + pais[i]);
            }
        }
        item.PaiVal = data.Pai;
        itemList.Add(item);

        InsertSort(itemList);
        return itemList;
    }

    /// <summary>
    /// 更新操作牌
    /// </summary>
    /// <param name="data"></param>
    /// <param name="item"></param>
    private void AddOperCard(MJOperatorModel data, MJItem item)
    {
        for(int i = 0;i< operCardList.Count; ++i)
        {
            if(data.Pai == operCardList[i].KeyItem.PaiVal)
            {
                item.PaiVal = data.Pai;
                operCardList[i].AddShow(data, item);
                break;
            }
        }
    }

    /// <summary>
    /// 倒牌
    /// </summary>
    /// <returns></returns>
    public IEnumerator FallCard(bool show = true)
    {
        yield return null;
        if (viewSeat == 0)
        {
            for (int i = 0; i < handCardList.Count; i++)
            {
                handCardList[i].eventPai -= this.myPaiEvents;
            }
            if (MahjongConst.IsUsed2DCamera)
                yield break;
        }
        for (int i = 0; i < handCardList.Count; ++i)
        {
            float x = i * MahjongConst.MahjongOffset_x;
            MJItem mj = handCardList[i];
            mj.transform.DOLocalMove(new Vector3(x, 0, -0.1f), 0.05f);
            float r = -90f;
            if (show)
                r = 90f;
            mj.transform.DOLocalRotate(new Vector3(r, 0, 0), 0.05f);
        }
        yield return new WaitForSeconds(0.05f);
    }

}

using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class MJItem : MonoBehaviour,IComparable<MJItem>
{
    public delegate void MJClick(MJItem val);

    private int _paiVal;
    public int PaiVal
    {
        get { return _paiVal; }
        set
        {
            _paiVal = value;
            _meshFilter.mesh = MJControl.Instance._mjResMgr.GetMahjongMesh(MahjongUtils.MahjongValueToMeshIndex(_paiVal));
        }
    }

    private int _layer;
    public int Layer
    {
        get { return _layer; }
        set
        {
            _layer = value;
            gameObject.layer = value;
            _mjObj.layer = value;
        }
    }

    private bool _isShow;
    public bool IsShow
    {
        get { return _isShow; }
        set { _isShow = value; }
    }


    private Transform _trans;//transform引用
    private GameObject _mjObj;//模型对象
    private MeshFilter _meshFilter;//模型mesh

    private MahjongPlace mjPlace;//当前状态，处于哪里

    public event MJClick eventPai;//点击事件

    void Awake()
    {
        FindChild();
    }

    void FindChild()
    {
        _trans = transform;
        _mjObj = _trans.FindChild("mjobj").gameObject;
        _meshFilter = _mjObj.GetComponent<MeshFilter>();
    }

    public void OnClick()
    {
        if (this.eventPai != null)
        {
            this.eventPai(this);
        }
    }

    public int CompareTo(MJItem other)
    {
        if (other == null) return 1;
        {
            if (this._paiVal > other._paiVal) return 1;
            if (this._paiVal < other._paiVal) return -1;
        }
        return 0;
    }
}

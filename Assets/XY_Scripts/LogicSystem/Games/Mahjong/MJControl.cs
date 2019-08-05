using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class MJControl : MonoBehaviour {

    public static MJControl Instance;

    public MJTable _mjTable;
    public MJDice _mjDice;
    public MJResMgr _mjResMgr;
    public MJCameraMgr _mjCamera;
    public MJItemMgr _mjItemMgr;
    public List<MJPlayer> _mjPlayerList;
    //public MJUI _mjUI;

    private bool isStarting;

    #region 初始化
    void Awake()
    {
        Instance = this;
        Init();
    }

    void Init()
    {
        //资源加载管理
        _mjResMgr = new MJResMgr();
        //加载麻将桌
        GameObject tablePrefab = _mjResMgr.CreateMJTable();
        GameObject _mjTableObj = GameObject.Instantiate(tablePrefab, this.transform) as GameObject;
        //_mjTableObj.name = tablePrefab.name;
        _mjTable = _mjTableObj.GetComponent<MJTable>();
        //加载麻将mesh
        _mjResMgr.LoadMJMesh();
        //加载骰子
        GameObject dicePrefab = _mjResMgr.CreateDice();
        GameObject _dice = Instantiate(dicePrefab, _mjTable.transform) as GameObject;
        if (_dice != null)
        {
            _dice.transform.localPosition = new Vector3(0, 0.7f, 0);
            _mjDice = _dice.GetComponent<MJDice>();
        }
        //加载摄像机管理
        _mjCamera = new MJCameraMgr();
        _mjCamera.Init();
        //加载玩家控制类
        _mjPlayerList = new List<MJPlayer>();
        GameObject playersPoint = new GameObject("Players");
        GameObject playerPrefab = _mjResMgr.CreatePlayers();
        for (int i = 0; i < 4; ++i)
        {
            GameObject _player = Instantiate(playerPrefab, playersPoint.transform) as GameObject;
            _player.name = playerPrefab.name + i;
            _player.transform.localEulerAngles = new Vector3(0, -90 * i, 0);
            if (_player != null)
            {
                MJPlayer mjPlayer = _player.GetComponent<MJPlayer>();
                if (mjPlayer != null)
                {
                    mjPlayer.viewSeat = i;
                    _mjPlayerList.Add(mjPlayer);
                }
            }
        }
        //加载麻将子管理类
        _mjItemMgr = new MJItemMgr();
        _mjItemMgr.InitMJItem();

        //测试
        InitTestMahjong();
    }
    #endregion

    #region 麻将点击
    void Update()
    {
        if (Input.GetMouseButtonUp(0))
        {
            Ray ray;
            RaycastHit rayhit;
            if (MahjongConst.IsUsed2DCamera)
                ray = _mjCamera.Camera2D.ScreenPointToRay(Input.mousePosition);
            else
                ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out rayhit))
            {
                //Debug.Log(rayhit.collider.gameObject.name);
                GameObject go = rayhit.collider.gameObject;
                Transform trans = go.transform.parent;
                if (trans != null)
                {
                    MJItem item = trans.GetComponent<MJItem>();
                    if (item != null)
                        item.OnClick();
                }
            }
        }
    }
    #endregion

    #region 测试
    List<int> mahjongValueList = new List<int>();
    private void InitTestMahjong()
    {
        for (int j = 0; j < 4; ++j)
        {
            for (int i = 1; i < 10; ++i)
            {
                mahjongValueList.Add(i);
            }
            for (int i = 11; i < 20; ++i)
            {
                mahjongValueList.Add(i);
            }
            for (int i = 21; i < 30; ++i)
            {
                mahjongValueList.Add(i);
            }
            for (int i = 31; i < 38; ++i)
            {
                mahjongValueList.Add(i);
            }
        }
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 10, 100, 30), "发牌1"))
        {
            StartCoroutine(SendCard(0, 5));
        }
        if (GUI.Button(new Rect(120, 10, 100, 30), "发牌2"))
        {
            StartCoroutine(SendCard(1, 5));
        }
        if (GUI.Button(new Rect(240, 10, 100, 30), "发牌3"))
        {
            StartCoroutine(SendCard(2, 5));
        }
        if (GUI.Button(new Rect(360, 10, 100, 30), "发牌4"))
        {
            StartCoroutine(SendCard(3, 5));
        }

        if (GUI.Button(new Rect(0, 50, 100, 30), "出牌1"))
        {
            StartCoroutine(OutCard(0, 1));
        }
        if (GUI.Button(new Rect(120, 50, 100, 30), "出牌2"))
        {
            StartCoroutine(OutCard(1, 1));
        }
        if (GUI.Button(new Rect(240, 50, 100, 30), "出牌3"))
        {
            StartCoroutine(OutCard(2, 1));
        }
        if (GUI.Button(new Rect(360, 50, 100, 30), "出牌4"))
        {
            StartCoroutine(OutCard(3, 1));
        }

        if (GUI.Button(new Rect(0, 90, 100, 30), "结束"))
        {
            StartCoroutine(EndGame());
        }

        if (GUI.Button(new Rect(0, 130, 100, 30), "开始"))
        {
            StartCoroutine(StartGame());
        }
    }
    #endregion

    #region 游戏逻辑
    /// <summary>
    /// 开始游戏
    /// </summary>
    /// <returns></returns>
    public IEnumerator StartGame()
    {
        yield return null;
        ReadyToStart();
        StartCoroutine(GameStart());
    }

    /// <summary>
    /// 准备阶段，开始前初始化
    /// </summary>
    private void ReadyToStart()
    {
        StopAllCoroutines();
        _mjItemMgr.InitMJItem();
        _mjDice.Init();
        for (int i = 0; i < _mjPlayerList.Count; ++i)
        {
            _mjPlayerList[i].Init();
        }
    }

    /// <summary>
    /// 开始游戏
    /// </summary>
    /// <returns></returns>
    private IEnumerator GameStart()
    {
        isStarting = true;
        yield return StartCoroutine(_mjTable.CreatMJWall());
        yield return new WaitForSeconds(0.5f);
        yield return StartCoroutine(PlayDice());
        yield return new WaitForSeconds(2f);
        yield return StartCoroutine(SendAllCard(10, 0));
        yield return new WaitForSeconds(0.5f);
        yield return StartCoroutine(_mjPlayerList[0].InitEvent());
    }

    int index;//发牌位置
    int lastIndex;//尾牌位置


    /// <summary>
    /// 发牌
    /// </summary>
    /// <param name="dun">牌墩，从视图玩家1左边开始数，墩数从1开始</param>
    /// <param name="viewSeat">视图玩家座位号</param>
    /// <returns></returns>
    IEnumerator SendAllCard(int dun, int viewSeat)
    {
        yield return null;
        index = dun * 2 - 1;
        lastIndex = index + 2;
        //4圈牌
        for (int i = 0; i < 4; ++i)
        {
            //4人
            for (int j = 0; j < 4; j++)
            {
                int num = 4;
                if (i == 3)
                {
                    if (viewSeat == j)
                        num = 2;
                    else
                        num = 1;
                }
                //牌数
                for (int k = 0; k < num; ++k)
                {
                    float x = (i * 4 + k) * MahjongConst.MahjongOffset_x;
                    if (index == -1)
                        index = 135;
                    MJItem mj = _mjItemMgr.MJItemList[index--];
                    //*******测试*********
                    int testIndex = Random.Range(0, mahjongValueList.Count);
                    int testPaiValue = mahjongValueList[testIndex];
                    mahjongValueList.Remove(testIndex);
                    //*******测试*********
                    mj.PaiVal = testPaiValue;
                    mj.transform.SetParent(_mjPlayerList[j]._handCardPoint);
                    mj.transform.DOLocalMove(new Vector3(x, 0, 0), 0.05f);
                    mj.transform.DOLocalRotate(Vector3.zero, 0.05f);
                    _mjPlayerList[j].AddHandCard(mj);
                    yield return new WaitForSeconds(0.03f);
                    if (MahjongConst.IsUsed2DCamera && j == 0)
                        mj.Layer = _mjPlayerList[j]._handCardPoint.gameObject.layer;
                }
                yield return new WaitForSeconds(0.2f);
            }
        }
    }

    /// <summary>
    /// 播放骰子
    /// </summary>
    /// <returns></returns>
    IEnumerator PlayDice()
    {
        yield return null;
        MJControl.Instance._mjDice.Play(true);
    }

    /// <summary>
    /// 出牌
    /// </summary>
    /// <param name="viewSeat"></param>
    /// <param name="paiValue"></param>
    /// <returns></returns>
    public IEnumerator OutCard(int viewSeat, int paiValue)
    {
        yield return null;
        MJPlayer player = _mjPlayerList[viewSeat];
        StartCoroutine(player.OutCard(paiValue));
    }

    /// <summary>
    /// 发牌
    /// </summary>
    /// <param name="viewSeat"></param>
    /// <param name="paiValue"></param>
    /// <returns></returns>
    public IEnumerator SendCard(int viewSeat, int paiValue, bool sendHead = true)
    {
        yield return null;
        MJItem item;
        if (sendHead)
        {
            if (index == -1)
                index = 135;
            item = _mjItemMgr.MJItemList[index--];
        }
        else
        {
            if (lastIndex == 136)
                lastIndex = 0;
            item = _mjItemMgr.MJItemList[lastIndex];
            if (lastIndex % 2 == 0)
                lastIndex += 2;
            else
                lastIndex--;
        }
        MJPlayer player = _mjPlayerList[viewSeat];
        StartCoroutine(player.SentCard(paiValue, item));
    }

    /// <summary>
    /// 操作牌
    /// </summary>
    /// <param name="viewSeat"></param>
    /// <param name="oper"></param>
    /// <returns></returns>
    public IEnumerator OperateCard(int viewSeat, MJOperatorModel oper, int outCardViewSeat)
    {
        yield return null;
        MJPlayer player = _mjPlayerList[viewSeat];
        MJItem item = null;
        if (outCardViewSeat != -1)
            item = _mjPlayerList[viewSeat].GetLastOutCard();
        StartCoroutine(player.OperateCard(oper, item));
    }

    /// <summary>
    /// 游戏结束
    /// </summary>
    /// <returns></returns>
    public IEnumerator EndGame()
    {
        yield return null;
        for (int i = 0; i < 4; ++i)
        {
            StartCoroutine(_mjPlayerList[i].FallCard());
        }
        isStarting = false;
    }
    #endregion
}

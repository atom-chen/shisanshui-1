using UnityEngine;
using System.Collections;
using System.IO;
using LitJson;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using cs;
using System.Net;
using Framework;
using NS_DataCenter;
using XYHY;

namespace NS_VersionUpdate
{
    public enum VersionUpdateType
    {
        NoNeedUpdate,               //不需要更新
        PatchPackageUpdate,         //增量包更新
        ChannelPackageUpdate        //渠道包更新
    }

    public class AssetUpdateManager : MonoBehaviour
    {
        public static AssetUpdateManager Instance;

        [SerializeField]
        private bool isEnableVersionUpdate = true;


        /// <summary>
        /// 版本校验服务器地址
        /// 外网IP:""
        /// 内网IP:""
        /// </summary>
        private string httpUrl = "";

        [SerializeField]
        private UILabel currentVerNoLab;
        [SerializeField]
        private UILabel checkState;  //检查更新状态
        [SerializeField]
        private UISlider slider;     //进度条
        [SerializeField]
        private UILabel downSizeLab;

        private long allSize = 0;
        private MessageBox curMsgBox = null;
        private Coroutine versionReqCor = null;
        private AssetBundleParams abp = null;
        private VersionInfo verInfo = null;


        #region Mono方法
        void Awake()
        {
            Instance = this;
        }

        void Start()
        {
            Messenger.AddListener(MSG_DEFINE.MSG_DESTROY_VERSION_UPDATE_UI, destroySelf);

            if (!isEnableVersionUpdate)
            {
                SkipAssetUpdate();
                return;
            }

            if (checkState != null)
            {
                checkState.gameObject.SetActive(true);
                checkState.text = "正在连接服务器...";
            }

            /*verInfo = FileUtils.GetCurrentVerNo();
            if (verInfo == null)
            {
                showMsg("确定", delegate
                {
                    closeMessageBox();
                    Application.Quit();
                }, "版本信息读取失败");
                return;
            }
            Version localVer = new Version(verInfo.VersionNum);
            verInfo.VersionNum = localVer.ToString();

            VersionInfoData.CurrentVersionInfo = verInfo;
            if (currentVerNoLab != null)
            {
                if (verInfo.IsReleaseVer)
                {
                    currentVerNoLab.text = string.Format("当前资源版本 v{0}", verInfo.VersionNum);
                }
                else
                {
                    currentVerNoLab.text = string.Format("当前资源版本 v{0}_1_{1}_{2}_{3}", verInfo.VersionNum, verInfo.SvnNum, verInfo.CurrentDT, verInfo.CurrentTime);
                }
            }*/
            versionReqCor = StartCoroutine(versionReq());
        }

        private bool CheckRecommendPlay()
        {
            if (!DeviceQuality.IsRecommendPlay())
            {
                showMsg("确定", () =>
                {
                    closeMessageBox();
                    Application.Quit();
                }, "手机配置较低，不推荐游玩");

                return false;
            }

            return true;
        }

        void OnDestroy()
        {
            Messenger.RemoveListener(MSG_DEFINE.MSG_DESTROY_VERSION_UPDATE_UI, destroySelf);
        }
        #endregion Mono方法

        private bool isSkipAssetUpdate = false;
        public void SkipAssetUpdate()
        {
            if (!isSkipAssetUpdate)
            {
                isSkipAssetUpdate = true;
                closeMessageBox();
                if (versionReqCor != null)
                {
                    StopCoroutine(versionReqCor);
                }
                if (startGameCor != null)
                {
                    StopCoroutine(startGameCor);
                }
                startGameCor = StartCoroutine(startGame());
            }
        }

        IEnumerator versionReq()
        {
            yield return null;
            /*System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.AppendFormat("{0}={1}&", "game_id", "20");
            sb.AppendFormat("{0}={1}&", "os", verInfo.OsType);
            sb.AppendFormat("{0}={1}&", "channelId", verInfo.ChannelNum);
            sb.AppendFormat("{0}={1}", "ver", verInfo.VersionNum);

            if (!verInfo.IsReleaseVer)
            {
                LuaInterface.Debugger.Log("HttpUrl:" + httpUrl);
                LuaInterface.Debugger.Log("--req info-->" + sb.ToString());
            }*/
            VersionResult(VersionUpdateType.NoNeedUpdate, null);
        }

        private void showMsg(string firstBtnText, Action firstBtnAct, string content, string secondBtnText = null, Action secondBtnAct = null)
        {
            List<ButtonEvent> btnEventList = new List<ButtonEvent>();
            ButtonEvent btn1 = new ButtonEvent(firstBtnText, firstBtnAct);
            btnEventList.Add(btn1);
            if (!string.IsNullOrEmpty(secondBtnText))
            {
                ButtonEvent btn2 = new ButtonEvent(secondBtnText, secondBtnAct);
                btnEventList.Add(btn2);
            }
            showMessageBox("", content, btnEventList);
        }

        /// <summary>
        /// 版本检测结果
        /// </summary>
        /// <param name="result"></param>
        void VersionResult(VersionUpdateType type, VersionUpdateBody verPackageResp)
        {
            VersionInfoData.CurVersionUpdateType = type;
            switch (type)
            {
                //当前版本已是最新
                case VersionUpdateType.NoNeedUpdate:
                    {
                        if (startGameCor != null)
                        {
                            StopCoroutine(startGameCor);
                        }
                        startGameCor = StartCoroutine(startGame());
                    }
                    break;
                //更新增量包
                case VersionUpdateType.PatchPackageUpdate:
                    {
                        List<PatchPackage> patchList = verPackageResp.res_list;
                        HandlePatchPackageData(patchList);
                    }
                    break;
                //更新渠道包
                case VersionUpdateType.ChannelPackageUpdate:
                    {
                        showMsg("取消", delegate { closeMessageBox(); Application.Quit(); },
                            "版本过低，请前往商店下载最新版本",
                            "确定", delegate { closeMessageBox(); Application.OpenURL(verPackageResp.bin_url); Application.Quit(); });
                    }
                    break;
            }
        }

        void HandlePatchPackageData(List<PatchPackage> patchList)
        {
            if (checkState != null)
            {
                checkState.text = "检查更新...";
            }

            string localPersistentPath = BundleConfig.Instance.BundlesPathForPersist;
            if (!Directory.Exists(localPersistentPath))
                Directory.CreateDirectory(localPersistentPath);

            List<DownLoadFile> updateList = new List<DownLoadFile>();

            for (int i = 0; i < patchList.Count; i++)
            {
                DownLoadFile df = new DownLoadFile();
                df.remoteFile = patchList[i].url;
                UnityEngine.Debug.Log(string.Format("downFileIndex: {0}, remoteUrl: {1}", i, df.remoteFile));
                df.localFile = string.Format("{0}patch_{1}.zip", localPersistentPath, patchList[i].ver.Replace('.', '_'));
                df.totalSize = long.Parse(patchList[i].size);
                df.size = df.totalSize - ThreadDownLoad.GetSize(df.localFile);
                df.md5 = patchList[i].md5;
                if (df.size == 0)
                {
                    UnityEngine.Debug.LogWarning("3333");
                    df.isDownFinished = true;
                }


                if (updateList == null)
                    updateList = new List<DownLoadFile>();
                updateList.Add(df);
                allSize += df.size;
            }

            if (checkState != null)
            {
                checkState.gameObject.SetActive(false);
            }

            if (allSize > 0 && updateList.Count > 0)
            {
                showMsg("取消", delegate { closeMessageBox(); Application.Quit(); },
                        string.Format("发现游戏有更新，需要下载{0}的更新包", getSize(allSize)),
                        "确定", delegate { closeMessageBox(); startUpdateAssets(updateList); });
            }
            else
            {
                if (unZipCor != null)
                {
                    StopCoroutine(unZipCor);
                }
                unZipCor = StartCoroutine(unZip(updateList));
            }
        }

        bool _isDownLoading = false;
        bool isDownLoading
        {
            get
            {
                return _isDownLoading;
            }
            set
            {
                _isDownLoading = value;
            }
        }
        Coroutine updateAssetsCor = null;
        private void startUpdateAssets(List<DownLoadFile> updateList)
        {
            ThreadDownLoad.BeingAssetUpdate = true;

            if (updateAssetsCor != null)
            {
                StopCoroutine(updateAssetsCor);
            }

            if (threadDownLoad == null)
            {
                threadDownLoad = gameObject.AddComponent<ThreadDownLoad>();
            }
            threadDownLoad.ClearEvent();
            isDownLoading = false;

            updateAssetsCor = StartCoroutine(OnUpdateAssets(updateList));
        }

        private const int timeout = 5000;
        float totalDownSize;
        IEnumerator OnUpdateAssets(List<DownLoadFile> updateList)
        {
            if (downSizeLab != null)
            {
                downSizeLab.gameObject.SetActive(true);
                downSizeLab.text = string.Format("正在下载更新 {0}/{1}", getSize(totalDownSize), getSize(allSize));
            }

            if (slider != null)
            {
                slider.gameObject.SetActive(true);      //进度条
            }

            totalDownSize = getTotalDownSize(updateList);
            if (slider != null)
            {
                slider.value = totalDownSize / allSize;
            }

            for (int i = 0; i < updateList.Count; i++)
            {
                if (!updateList[i].isDownFinished)
                {
                    BeginDownLoad(updateList[i]);

                    timeoutSw.Reset();
                    timeoutSw.Start();
                    while (isDownLoading)
                    {
                        if (timeoutSw.ElapsedMilliseconds > timeout)     //如果正在下载中的文件 5秒都没有下载信息回调，说明有问题
                        {
                            ThreadDownLoad.BeingAssetUpdate = false;
                            showMsg("取消", delegate { closeMessageBox(); Application.Quit(); },
                                "更新出现异常，请点击确定再次更新",
                                "确定", delegate { closeMessageBox(); startUpdateAssets(updateList); });
                            yield break;
                        }

                        yield return new WaitForEndOfFrame();

                        totalDownSize = getTotalDownSize(updateList);
                        if (slider != null)
                        {
                            slider.value = totalDownSize / allSize;
                        }

                        if (downSizeLab != null)
                        {
                            downSizeLab.text = string.Format("正在下载更新 {0}/{1}", getSize(totalDownSize), getSize(allSize));
                        }
                    }

                    totalDownSize = getTotalDownSize(updateList);
                    if (slider != null)
                    {
                        slider.value = totalDownSize / allSize;
                    }

                    if (downSizeLab != null)
                    {
                        downSizeLab.text = string.Format("正在下载更新 {0}/{1}", getSize(totalDownSize), getSize(allSize));
                    }
                }
            }

            if (unZipCor != null)
            {
                StopCoroutine(unZipCor);
            }
            unZipCor = StartCoroutine(unZip(updateList));
            yield break;
        }

        Coroutine unZipCor = null;
        private IEnumerator unZip(List<DownLoadFile> list)
        {
            if (!verInfo.IsReleaseVer)
            {
                LuaInterface.Debugger.Log(string.Format("--unZip--listcount: {0}", list.Count));
            }

            if (!checkFiles(list))
            {
                //文件校验失败，重新下载
                showMsg("取消",
                    delegate { closeMessageBox(); Application.Quit(); },
                    "文件校验失败，是否重新下载",
                    "确定",
                    delegate
                    {
                        closeMessageBox();
                        if (versionReqCor != null)
                        {
                            StopCoroutine(versionReqCor);
                            versionReqCor = StartCoroutine(versionReq());
                        }
                    });
                yield break;
            }

            yield return null;
            if (slider != null)
            {
                slider.gameObject.SetActive(true);
            }

            for (int i = 0; i < list.Count; i++)
            {
                if (!downSizeLab.gameObject.activeSelf)
                {
                    downSizeLab.gameObject.SetActive(true);
                    downSizeLab.text = string.Format("正在解压:{0}/{1}", i, list.Count);
                    yield return new WaitForSeconds(0.5f);
                }

                string gzipFileUrl = list[i].localFile;

                if (File.Exists(gzipFileUrl))
                {
                    string[] arraytemp = gzipFileUrl.Split('/');
                    string gzipFileName = arraytemp[arraytemp.Length - 1];
                    string gzipFilePath = gzipFileUrl.Replace(gzipFileName, "");

                    ZipResult zipResult = new ZipResult();
                    ZipHelper.Decompress(string.Format("{0}{1}", gzipFilePath, gzipFileName), gzipFilePath, ref zipResult);

                    if (zipResult.Errors)
                    {
                        if (!verInfo.IsReleaseVer)
                        {
                            LuaInterface.Debugger.LogError("解压结果：失败" + i);
                        }

                        //重新下包。。。
                        showMsg("取消",
                        delegate { closeMessageBox(); Application.Quit(); },
                        "解压失败，是否重新解压文件",
                        "确定",
                        delegate
                        {
                            closeMessageBox();
                            if (unZipCor != null)
                            {
                                StopCoroutine(unZipCor);
                            }
                            unZipCor = StartCoroutine(unZip(list));
                        });
                        yield break;
                    }

                    if (downSizeLab != null)
                    {
                        downSizeLab.text = string.Format("正在解压:{0}/{1}", (i + 1), list.Count);
                        yield return null;
                        if (!verInfo.IsReleaseVer)
                        {
                            LuaInterface.Debugger.Log(string.Format("--->:{0}, {1}", downSizeLab.gameObject.activeSelf, downSizeLab.text));
                        }
                    }

                    //删除patch压缩包
                    if (File.Exists(gzipFileUrl))
                    {
                        File.Delete(gzipFileUrl);
                    }
                }
            }


            verInfo = FileUtils.GetCurrentVerNo();
            VersionInfoData.CurrentVersionInfo = verInfo;

            if (currentVerNoLab != null)
            {
                currentVerNoLab.text = string.Format("当前资源版本 {0}", verInfo.VersionNum);
            }
            if (downSizeLab != null)
            {
                downSizeLab.gameObject.SetActive(false);
            }
            if (slider != null)
            {
                slider.gameObject.SetActive(false);
            }

            if (startGameCor != null)
            {
                StopCoroutine(startGameCor);
            }
            startGameCor = StartCoroutine(startGame());
        }

        //文件校验
        private bool checkFiles(List<DownLoadFile> list)
        {
            bool ret = true;
            for (int i = 0; i < list.Count; i++)
            {
                if (File.Exists(list[i].localFile))
                {
                    string srvFileMd5 = list[i].md5;
                    string localFileMd5 = FileUtils.getFileMd5(list[i].localFile);

                    if (!srvFileMd5.Equals(localFileMd5))
                    {
                        UnityEngine.Debug.LogWarning("MD5值不同" + i);
                        ret = false;
                        break;
                    }
                }
                else
                {
                    ret = false;
                    UnityEngine.Debug.LogWarning("不存在");
                }
            }

            return ret;
        }

        private float getTotalDownSize(List<DownLoadFile> updateList)
        {
            float totalDownSize = 0;
            for (int i = 0; i < updateList.Count; i++)
            {
                totalDownSize += updateList[i].downSize;
            }
            return totalDownSize;
        }

        private ThreadDownLoad threadDownLoad = null;
        void BeginDownLoad(DownLoadFile df)
        {
            threadDownLoad.AddEvent(df, OnDownLoad);
            isDownLoading = true;
        }

        //监测网络问题，超出一定时间没有收到任何网络数据，断定网络有问题
        Stopwatch timeoutSw = new Stopwatch();
        void OnDownLoad(DownLoadFile df)
        {
            if (df.isDownFinished)
            {
                isDownLoading = false;
            }
            else
            {
                timeoutSw.Reset();
                timeoutSw.Start();
            }
        }

        Coroutine startGameCor = null;
        /// <summary>
        /// 加载完成
        /// </summary>
        IEnumerator startGame()
        {
            if (checkState != null)
            {
                if (!checkState.gameObject.activeSelf)
                    checkState.gameObject.SetActive(true);

                checkState.text = "正在初始化游戏...";
            }

            if (_initAssetCor != null)
            {
                StopCoroutine(_initAssetCor);
            }
            _initAssetCor = StartCoroutine(initAssetCor());
            yield return _initAssetCor;

            if (checkState != null)
            {
                checkState.text = "正在进入游戏...";
            }

            // 创建游戏内核
            Framework.GameKernel.Create();            
        }

        void destroySelf()
        {
            if (curMsgBox != null)
            {
                Destroy(curMsgBox.gameObject);
            }
            Destroy(gameObject);
            Framework.GameKernel.Get<XYHY.IResourceMgr>().UnloadImmortalResource("Prefabs/UI/VersionUpdate/version_update_ui", typeof(GameObject));
        }

        Coroutine _initAssetCor = null;
        IEnumerator initAssetCor()
        {
            initAsset();
            int toProgress = 0;
            int displayProgress = 0;
            if (preloadResult != null && preloadResult.TotalCount > 0)
            {
                if (slider != null)
                {
                    slider.gameObject.SetActive(true);
                    slider.value = 0;
                }

                while (true)
                {
                    toProgress = (int)(preloadResult.PreloadPercent * 100);

                    while (displayProgress < toProgress)
                    {
                        displayProgress += 2;
                        if (slider != null)
                        {
                            slider.value = 0.01f * displayProgress;
                        }

                        yield return new WaitForEndOfFrame();
                    }
                    if (toProgress >= 100)
                    {
                        if (slider != null)
                        {
                            slider.gameObject.SetActive(false);
                        }
                        yield break;
                    }
                    yield return null;
                }
            }
        }

        PreloadResult preloadResult;
        ResBinData resBinData;
        ResBinData NewResBinDataForPreLoad()
        {
            resBinData = ResBinData.Instance;
            return resBinData;
        }

        void ReleaseNewResBinData()
        {
            if (resBinData != null)
                resBinData.UnInitialize();
            resBinData = null;
        }

        void initAsset()
        {
            preloadResult = null;
            preloadResult = new PreloadResult();

            GameKernel.CreateForInitData();
            IResourceMgr resourceMgr = GameKernel.Get<IResourceMgr>();
            ResBinData iResBinData = NewResBinDataForPreLoad();

            //预加载资源，不需要提前获取mainAsset
            List<string> residentGoList = iResBinData.GetImmortalAssetList(1);
            List<string> residentACList = iResBinData.GetImmortalAssetList(3);
            List<string> residentTexture2DList = iResBinData.GetImmortalAssetList(5);
            List<string> residentAudioClipList = iResBinData.GetImmortalAssetList(7);
            List<string> residentAnimClipList = iResBinData.GetImmortalAssetList(9);

            //预加载资源，需要提前获取mainAsset
            List<string> residentPreloadGoList = iResBinData.GetImmortalAssetList(2);
            List<string> residentPreloadACList = iResBinData.GetImmortalAssetList(4);
            List<string> residentPreloadTexture2DList = iResBinData.GetImmortalAssetList(6);
            List<string> residentPreloadAudioClipList = iResBinData.GetImmortalAssetList(8);
            List<string> residentPreloadAnimClipList = iResBinData.GetImmortalAssetList(10);


            if (residentGoList != null && residentGoList.Count > 0)
                this.preloadResult.TotalCount += residentGoList.Count;
            if (residentPreloadGoList != null && residentPreloadGoList.Count > 0)
                this.preloadResult.TotalCount += residentPreloadGoList.Count;
            if (residentACList != null && residentACList.Count > 0)
                this.preloadResult.TotalCount += residentACList.Count;
            if (residentPreloadACList != null && residentPreloadACList.Count > 0)
                this.preloadResult.TotalCount += residentPreloadACList.Count;
            if (residentTexture2DList != null && residentTexture2DList.Count > 0)
                this.preloadResult.TotalCount += residentTexture2DList.Count;
            if (residentPreloadTexture2DList != null && residentPreloadTexture2DList.Count > 0)
                this.preloadResult.TotalCount += residentPreloadTexture2DList.Count;
            if (residentAudioClipList != null && residentAudioClipList.Count > 0)
                this.preloadResult.TotalCount += residentAudioClipList.Count;
            if (residentPreloadAudioClipList != null && residentPreloadAudioClipList.Count > 0)
                this.preloadResult.TotalCount += residentPreloadAudioClipList.Count;
            if (residentAnimClipList != null && residentAnimClipList.Count > 0)
                this.preloadResult.TotalCount += residentAnimClipList.Count;
            if (residentPreloadAnimClipList != null && residentPreloadAnimClipList.Count > 0)
                this.preloadResult.TotalCount += residentPreloadAnimClipList.Count;

            if (residentGoList != null)
            {
                for (int i = 0; i < residentGoList.Count; i++)
                {
                    abp = new AssetBundleParams(residentGoList[i], typeof(GameObject));
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentPreloadGoList != null)
            {
                for (int i = 0; i < residentPreloadGoList.Count; i++)
                {
                    abp = new AssetBundleParams(residentPreloadGoList[i], typeof(GameObject));
                    abp.IsPreloadMainAsset = true;
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentACList != null)
            {
                for (int i = 0; i < residentACList.Count; i++)
                {
                    abp = new AssetBundleParams(residentACList[i], typeof(RuntimeAnimatorController));
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentPreloadACList != null)
            {
                for (int i = 0; i < residentPreloadACList.Count; i++)
                {
                    abp = new AssetBundleParams(residentPreloadACList[i], typeof(RuntimeAnimatorController));
                    abp.IsPreloadMainAsset = true;
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentTexture2DList != null)
            {
                for (int i = 0; i < residentTexture2DList.Count; i++)
                {
                    abp = new AssetBundleParams(residentTexture2DList[i], typeof(Texture2D));
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentPreloadTexture2DList != null)
            {
                for (int i = 0; i < residentPreloadTexture2DList.Count; i++)
                {
                    abp = new AssetBundleParams(residentPreloadTexture2DList[i], typeof(Texture2D));
                    abp.IsPreloadMainAsset = true;
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentAudioClipList != null)
            {
                for (int i = 0; i < residentAudioClipList.Count; i++)
                {
                    abp = new AssetBundleParams(residentAudioClipList[i], typeof(AudioClip));
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentPreloadAudioClipList != null)
            {
                for (int i = 0; i < residentPreloadAudioClipList.Count; i++)
                {
                    abp = new AssetBundleParams(residentPreloadAudioClipList[i], typeof(AudioClip));
                    abp.IsPreloadMainAsset = true;
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentAnimClipList != null)
            {
                for (int i = 0; i < residentAnimClipList.Count; i++)
                {
                    abp = new AssetBundleParams(residentAnimClipList[i], typeof(AnimationClip));
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }
            if (residentPreloadAnimClipList != null)
            {
                for (int i = 0; i < residentPreloadAnimClipList.Count; i++)
                {
                    abp = new AssetBundleParams(residentPreloadAnimClipList[i], typeof(AnimationClip));
                    abp.IsPreloadMainAsset = true;
                    resourceMgr.LoadResidentMemoryObjAsync(abp);
                }
            }

            ReleaseNewResBinData();
        }

        /*private void residentAssetCallback(AssetBundleInfo info)
        {
            this.preloadResult.Index++;
            this.preloadResult.PreloadPercent = 1.0f * this.preloadResult.Index / this.preloadResult.TotalCount;
        }*/

        private string getSize(float size)
        {
            string sizeInfo = "";
            if (size >= 1024 * 1024)
            {
                sizeInfo = ((double)size / (1024 * 1024)).ToString("0.00") + "M";
            }
            else
            {
                sizeInfo = ((double)size / 1024).ToString("0.00") + "K";
            }
            return sizeInfo;
        }

        private Coroutine msgBoxCor = null;
        private TweenScale msgBoxTS = null;
        private void showMessageBox(string title, string content, List<ButtonEvent> btnEventList)
        {
            if (msgBoxCor != null)
            {
                StopCoroutine(msgBoxCor);
            }
            msgBoxCor = StartCoroutine(showMsgBoxIEtor(title, content, btnEventList));
        }
        private IEnumerator showMsgBoxIEtor(string title, string content, List<ButtonEvent> btnEventList)
        {
            yield return null;
            if (curMsgBox == null)
            {
                curMsgBox = MessageBox.CreateMessageBox();
            }
            else
            {
                if (!curMsgBox.gameObject.activeSelf)
                {
                    curMsgBox.gameObject.SetActive(true);
                }
            }
            if (msgBoxTS == null)
            {
                msgBoxTS = curMsgBox.gameObject.GetComponent<TweenScale>();
            }

            msgBoxTS.ResetToBeginning();
            msgBoxTS.PlayForward();

            curMsgBox.ShowMessageBox(title, content, btnEventList);
        }

        private void closeMessageBox()
        {
            if (msgBoxCor != null)
            {
                StopCoroutine(msgBoxCor);
            }
            if (curMsgBox != null && curMsgBox.gameObject.activeSelf)
            {
                curMsgBox.gameObject.SetActive(false);
            }
        }
    }

    public class VersionUpdateResp
    {
        public int status;
        public string msg;
        public VersionUpdateBody data;
    }


    public class VersionUpdateBody
    {
        //类型，如果type为"patch"，则为增量包
        public string type;
        public string bin_url;
        public List<PatchPackage> res_list;
    }

    public class PatchPackage
    {
        //patch包版本号
        public string ver;
        //patch包下载地址
        public string url;
        //patch包的大小
        public string size;
        //patch包的md5
        public string md5;
    }

    public class DownLoadFile
    {
        public string remoteFile;   //文件的url地址
        public string localFile;    //文件的本地url
        public long size;           //还需下载文件大小
        public long downSize;       //已经下载的大小
        public long totalSize;      //该文件总大小
        public string md5;          //文件的Md5
        public bool isDownFinished = false; //下载是否完成

        public Stream fs;
        public HttpWebRequest request = null;
    }
}
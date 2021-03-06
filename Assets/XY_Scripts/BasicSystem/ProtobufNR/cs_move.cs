﻿// Classes and structures being serialized

// Generated by ProtocolBuffer
// - a pure c# code generation implementation of protocol buffers
// Report bugs to: https://silentorbit.com/protobuf/

// DO NOT EDIT
// This file will be overwritten when CodeGenerator is run.
// To make custom modifications, edit the .proto file and add //:external before the message line
// then write the code and the changes in a separate file.
using System;
using System.Collections.Generic;

namespace cs
{
    /// <summary> CS_ENTER_MAP_INFO_NOTIFY 通知进入地图的信息</summary>
    public partial class CSEnterMapInfoNotify
    {
        public CSEnterMapInfoNotify()
        {
            Clear();
        }
        /// <summary> 地图 id</summary>
        public uint MapID { get; set; }

        /// <summary> 位置</summary>
        public global::cs.Triple Pos { get; set; }

        public global::cs.Triple Rotation { get; set; }

        /// <summary> 使用位置类型, 0: 表示使用 Pos; 1: 表示使用 NodeID</summary>
        public int PosType { get; set; }

        public int NodeID { get; set; }

        public global::cs.MyUint64 RoomID { get; set; }

        /// <summary>进入动态副本类型, @see cs_define_enum.EnmDynamicEnterType</summary>
        public int DynamicEnterType { get; set; }


        public void Clear()
        {
            MapID = 0;
            if (Pos != null)
            {
                Pos.Clear();
            }
            if (Rotation != null)
            {
                Rotation.Clear();
            }
            PosType = 0;
            NodeID = 0;
            if (RoomID != null)
            {
                RoomID.Clear();
            }
            DynamicEnterType = 0;
        }
    }

    /// <summary> CS_ENTER_MAP_READY_REQ 客户端加载完地图资源之后通知服务器请求</summary>
    public partial class CSEnterMapReadyReq
    {
        public CSEnterMapReadyReq()
        {
            Clear();
        }

        public void Clear()
        {
        }
    }

    /// <summary> CS_ENTER_MAP_READY_RES 户端加载完地图资源之后通知服务器请求</summary>
    public partial class CSEnterMapReadyRes
    {
        public CSEnterMapReadyRes()
        {
            Clear();
        }
        public int RetCode { get; set; }

        public uint MapID { get; set; }


        public void Clear()
        {
            RetCode = 0;
            MapID = 0;
        }
    }

    /// <summary> CS_HERO_MOVE_REQ 玩家移动请求</summary>
    public partial class CSHeroMoveReq
    {
        public CSHeroMoveReq()
        {
            Clear();
        }
        /// <summary> 移动方向</summary>
        public global::cs.Triple Direct { get; set; }

        /// <summary> 当前位置</summary>
        public global::cs.Triple Pos { get; set; }


        public void Clear()
        {
            if (Direct != null)
            {
                Direct.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
        }
    }

    /// <summary> CS_HERO_MOVE_RES 玩家移动响应</summary>
    public partial class CSHeroMoveRes
    {
        public CSHeroMoveRes()
        {
            Clear();
        }
        /// <summary> 移动错误码</summary>
        public int RetCode { get; set; }

        /// <summary> 玩家位置，当 RetCode 不为 0 时 pos 表示玩家上一次的位置</summary>
        public global::cs.Triple Pos { get; set; }


        public void Clear()
        {
            RetCode = 0;
            if (Pos != null)
            {
                Pos.Clear();
            }
        }
    }

    /// <summary> CS_REPORT_HERO_LOCATION 玩家上报他当前的位置</summary>
    public partial class CSReportHeroLocation
    {
        public CSReportHeroLocation()
        {
            Clear();
        }
        /// <summary> 移动方向</summary>
        public global::cs.Triple Direct { get; set; }

        /// <summary> 当前位置</summary>
        public global::cs.Triple Pos { get; set; }


        public void Clear()
        {
            if (Direct != null)
            {
                Direct.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
        }
    }

    /// <summary> CS_ACTOR_MOVE_NOTIFY 通知玩家移动（除自己外）</summary>
    public partial class CSActorMoveNotify
    {
        public CSActorMoveNotify()
        {
            Clear();
        }
        public global::cs.MyUint64 ActorID { get; set; }

        /// <summary> 移动方向</summary>
        public global::cs.Triple Direct { get; set; }

        /// <summary> 当前位置</summary>
        public global::cs.Triple Pos { get; set; }

        /// <summary> Actor 的类型 @see cs_define_enum.proto: EnmActorType</summary>
        public int ActorType { get; set; }


        public void Clear()
        {
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            if (Direct != null)
            {
                Direct.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
            ActorType = 0;
        }
    }

    /// <summary> CS_ACTOR_ENTER_VIEW_NOTIFY 通知玩家进入视野</summary>
    public partial class CSActorEnterViewNotify
    {
        public CSActorEnterViewNotify()
        {
            HeroInfo = new List<global::cs.HeroEnterViewInfo>();
            NpcInfo = new List<global::cs.NpcEnterViewInfo>();
            InitAllCacheList();
            Clear();
        }
        /// <summary>a cache list for HeroInfo</summary>
        public List<global::cs.HeroEnterViewInfo> HeroInfoCacheList = new List<global::cs.HeroEnterViewInfo>(50);

        /// <summary>a cache list for NpcInfo</summary>
        public List<global::cs.NpcEnterViewInfo> NpcInfoCacheList = new List<global::cs.NpcEnterViewInfo>(50);

        /// <summary> 进入视野的玩家列表</summary>
        public List<global::cs.HeroEnterViewInfo> HeroInfo { get; set; }

        /// <summary> 进入视野的 npc 列表</summary>
        public List<global::cs.NpcEnterViewInfo> NpcInfo { get; set; }

        /// <summary> 1: 表示全量视野</summary>
        public int FullViewFlag { get; set; }


        public void Clear()
        {
            if (HeroInfo != null)
            {
                for (int i = 0; i < HeroInfo.Count;  ++i)
                {
                    HeroInfo[i].Clear();
                    ReturnHeroInfoElement(HeroInfo[i]);
                }
                HeroInfo.Clear();
            }
            if (NpcInfo != null)
            {
                for (int i = 0; i < NpcInfo.Count;  ++i)
                {
                    NpcInfo[i].Clear();
                    ReturnNpcInfoElement(NpcInfo[i]);
                }
                NpcInfo.Clear();
            }
            FullViewFlag = 0;
        }

        /// <summary>init all the cache lists</summary>
        public void InitAllCacheList()
        {
            HeroInfoCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                HeroInfoCacheList.Add(new global::cs.HeroEnterViewInfo());
            }
            NpcInfoCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                NpcInfoCacheList.Add(new global::cs.NpcEnterViewInfo());
            }
        }

        /// <summary>get a free element from HeroInfoCacheList</summary>
        public global::cs.HeroEnterViewInfo GetFreeHeroInfoElement()
        {
            global::cs.HeroEnterViewInfo ret = null;
            if (HeroInfoCacheList.Count > 0)
            {
                 ret = HeroInfoCacheList[0];
                HeroInfoCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.HeroEnterViewInfo();
            }
            return ret;
        }

        /// <summary>return a free element to HeroInfoCacheList</summary>
        public void ReturnHeroInfoElement(global::cs.HeroEnterViewInfo element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < HeroInfoCacheList.Count;  ++i)
            {
                if (HeroInfoCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                HeroInfoCacheList.Add(element);
            }
        }

        /// <summary>get a free element from NpcInfoCacheList</summary>
        public global::cs.NpcEnterViewInfo GetFreeNpcInfoElement()
        {
            global::cs.NpcEnterViewInfo ret = null;
            if (NpcInfoCacheList.Count > 0)
            {
                 ret = NpcInfoCacheList[0];
                NpcInfoCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.NpcEnterViewInfo();
            }
            return ret;
        }

        /// <summary>return a free element to NpcInfoCacheList</summary>
        public void ReturnNpcInfoElement(global::cs.NpcEnterViewInfo element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < NpcInfoCacheList.Count;  ++i)
            {
                if (NpcInfoCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                NpcInfoCacheList.Add(element);
            }
        }
    }

    /// <summary> CS_ACTOR_LEAVE_VIEW_NOTIFY 通知离开的玩家列表</summary>
    public partial class CSActorLeaveViewNotify
    {
        public CSActorLeaveViewNotify()
        {
            HeroList = new List<global::cs.CSActorLeaveViewNotify.LeaveInfo>();
            NpcList = new List<global::cs.CSActorLeaveViewNotify.LeaveInfo>();
            InitAllCacheList();
            Clear();
        }
        /// <summary>a cache list for HeroList</summary>
        public List<global::cs.CSActorLeaveViewNotify.LeaveInfo> HeroListCacheList = new List<global::cs.CSActorLeaveViewNotify.LeaveInfo>(50);

        /// <summary>a cache list for NpcList</summary>
        public List<global::cs.CSActorLeaveViewNotify.LeaveInfo> NpcListCacheList = new List<global::cs.CSActorLeaveViewNotify.LeaveInfo>(50);

        /// <summary> 离开视野的玩家账号列表</summary>
        public List<global::cs.CSActorLeaveViewNotify.LeaveInfo> HeroList { get; set; }

        /// <summary> 离开视野的 npc 列表</summary>
        public List<global::cs.CSActorLeaveViewNotify.LeaveInfo> NpcList { get; set; }


        public void Clear()
        {
            if (HeroList != null)
            {
                for (int i = 0; i < HeroList.Count;  ++i)
                {
                    HeroList[i].Clear();
                    ReturnHeroListElement(HeroList[i]);
                }
                HeroList.Clear();
            }
            if (NpcList != null)
            {
                for (int i = 0; i < NpcList.Count;  ++i)
                {
                    NpcList[i].Clear();
                    ReturnNpcListElement(NpcList[i]);
                }
                NpcList.Clear();
            }
        }

        /// <summary>init all the cache lists</summary>
        public void InitAllCacheList()
        {
            HeroListCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                HeroListCacheList.Add(new global::cs.CSActorLeaveViewNotify.LeaveInfo());
            }
            NpcListCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                NpcListCacheList.Add(new global::cs.CSActorLeaveViewNotify.LeaveInfo());
            }
        }

        /// <summary>get a free element from HeroListCacheList</summary>
        public global::cs.CSActorLeaveViewNotify.LeaveInfo GetFreeHeroListElement()
        {
            global::cs.CSActorLeaveViewNotify.LeaveInfo ret = null;
            if (HeroListCacheList.Count > 0)
            {
                 ret = HeroListCacheList[0];
                HeroListCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.CSActorLeaveViewNotify.LeaveInfo();
            }
            return ret;
        }

        /// <summary>return a free element to HeroListCacheList</summary>
        public void ReturnHeroListElement(global::cs.CSActorLeaveViewNotify.LeaveInfo element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < HeroListCacheList.Count;  ++i)
            {
                if (HeroListCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                HeroListCacheList.Add(element);
            }
        }

        /// <summary>get a free element from NpcListCacheList</summary>
        public global::cs.CSActorLeaveViewNotify.LeaveInfo GetFreeNpcListElement()
        {
            global::cs.CSActorLeaveViewNotify.LeaveInfo ret = null;
            if (NpcListCacheList.Count > 0)
            {
                 ret = NpcListCacheList[0];
                NpcListCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.CSActorLeaveViewNotify.LeaveInfo();
            }
            return ret;
        }

        /// <summary>return a free element to NpcListCacheList</summary>
        public void ReturnNpcListElement(global::cs.CSActorLeaveViewNotify.LeaveInfo element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < NpcListCacheList.Count;  ++i)
            {
                if (NpcListCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                NpcListCacheList.Add(element);
            }
        }
        public partial class LeaveInfo
        {
            public LeaveInfo()
            {
                Clear();
            }
            public global::cs.MyUint64 ActorID { get; set; }


            public void Clear()
            {
                if (ActorID != null)
                {
                    ActorID.Clear();
                }
            }
        }

    }

    /// <summary> CS_JUMP_POS_INSCENE_NOTIFY 场景内瞬移</summary>
    public partial class CSJumpPosInSceneNotify
    {
        public CSJumpPosInSceneNotify()
        {
            Clear();
        }
        /// <summary> 位置</summary>
        public global::cs.Triple Pos { get; set; }

        /// <summary> 朝向</summary>
        public global::cs.Triple Rotation { get; set; }


        public void Clear()
        {
            if (Pos != null)
            {
                Pos.Clear();
            }
            if (Rotation != null)
            {
                Rotation.Clear();
            }
        }
    }

    /// <summary> CS_JUMP_SCENE_REQ 场景跳转请求</summary>
    public partial class CSJumpSceneReq
    {
        public CSJumpSceneReq()
        {
            Clear();
        }
        /// <summary>跳转点</summary>
        public uint JumpPoint { get; set; }

        /// <summary> 踩的跳转点怪物 id，如果是单人本，则没有这个字段</summary>
        public global::cs.MyUint64 NpcActorID { get; set; }


        public void Clear()
        {
            JumpPoint = 0;
            if (NpcActorID != null)
            {
                NpcActorID.Clear();
            }
        }
    }

    /// <summary> CS_JUMP_SCENE_RES 场景跳转请求</summary>
    public partial class CSJumpSceneRes
    {
        public CSJumpSceneRes()
        {
            Clear();
        }
        /// <summary> 错误码</summary>
        public int RetCode { get; set; }


        public void Clear()
        {
            RetCode = 0;
        }
    }

    /// <summary> CS_CHG_CITY_TIME_OUT_NOTIFY 场景切换超时通知</summary>
    public partial class CSChgCityTimeOutNotify
    {
        public CSChgCityTimeOutNotify()
        {
            Clear();
        }

        public void Clear()
        {
        }
    }

    /// <summary> CS_CITY_HOST_NOTIFY 通知玩家新的 ip:port</summary>
    public partial class CSCityHostNotify
    {
        public CSCityHostNotify()
        {
            Clear();
        }
        public global::cs.TconndAddr Addr { get; set; }


        public void Clear()
        {
            if (Addr != null)
            {
                Addr.Clear();
            }
        }
    }

    /// <summary>停止消息   CS_STOP_MOVE_NOTIFY = 1042;</summary>
    public partial class CSStopMoveNotify
    {
        public CSStopMoveNotify()
        {
            Clear();
        }
        /// <summary> 移动对象UID</summary>
        public global::cs.MyUint64 ActorID { get; set; }

        /// <summary> 当前位置</summary>
        public global::cs.Triple Pos { get; set; }

        /// <summary> Actor 的类型 @see cs_define_enum.proto: EnmActorType</summary>
        public int ActorType { get; set; }

        /// <summary> 朝向</summary>
        public global::cs.Triple Toward { get; set; }

        public global::cs.MyUint64 TargetActorID { get; set; }


        public void Clear()
        {
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
            ActorType = 0;
            if (Toward != null)
            {
                Toward.Clear();
            }
            if (TargetActorID != null)
            {
                TargetActorID.Clear();
            }
        }
    }

    /// <summary>CS_ACTOR_ATTR_CHANGE_NOTIFY = 2273 通知视野内Actor属性变化(武器，上衣，武器特效等。。)</summary>
    public partial class CSActorAttrChangeNotify
    {
        public CSActorAttrChangeNotify()
        {
            RoleAttr = new List<global::cs.AttrData>();
            InitAllCacheList();
            Clear();
        }
        /// <summary>a cache list for RoleAttr</summary>
        public List<global::cs.AttrData> RoleAttrCacheList = new List<global::cs.AttrData>(50);

        /// <summary>通知视野内玩家属性变化</summary>
        public global::cs.MyUint64 ActorID { get; set; }

        /// <summary>玩家基础属性情况</summary>
        public List<global::cs.AttrData> RoleAttr { get; set; }

        /// <summary>视野中其它属性</summary>
        public global::cs.ViewOtherInfo OtherView { get; set; }

        /// <summary>
        /// <para>视野中其他属性</para>
        /// <para>帮会ID变更</para>
        /// </summary>
        public global::cs.MyUint64 FactionID { get; set; }


        public void Clear()
        {
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            if (RoleAttr != null)
            {
                for (int i = 0; i < RoleAttr.Count;  ++i)
                {
                    RoleAttr[i].Clear();
                    ReturnRoleAttrElement(RoleAttr[i]);
                }
                RoleAttr.Clear();
            }
            if (OtherView != null)
            {
                OtherView.Clear();
            }
            if (FactionID != null)
            {
                FactionID.Clear();
            }
        }

        /// <summary>init all the cache lists</summary>
        public void InitAllCacheList()
        {
            RoleAttrCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                RoleAttrCacheList.Add(new global::cs.AttrData());
            }
        }

        /// <summary>get a free element from RoleAttrCacheList</summary>
        public global::cs.AttrData GetFreeRoleAttrElement()
        {
            global::cs.AttrData ret = null;
            if (RoleAttrCacheList.Count > 0)
            {
                 ret = RoleAttrCacheList[0];
                RoleAttrCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.AttrData();
            }
            return ret;
        }

        /// <summary>return a free element to RoleAttrCacheList</summary>
        public void ReturnRoleAttrElement(global::cs.AttrData element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < RoleAttrCacheList.Count;  ++i)
            {
                if (RoleAttrCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                RoleAttrCacheList.Add(element);
            }
        }
    }

    /// <summary>CS_MOVE_INTO_NPC_AREA_REQ</summary>
    public partial class CSMoveIntoNpcAreaReq
    {
        public CSMoveIntoNpcAreaReq()
        {
            Clear();
        }
        /// <summary>1-进入 2-退出</summary>
        public int IntoOpt { get; set; }

        public global::cs.MyUint64 NpcID { get; set; }


        public void Clear()
        {
            IntoOpt = 0;
            if (NpcID != null)
            {
                NpcID.Clear();
            }
        }
    }

    /// <summary>CS_MOVE_INTO_NPC_AREA_RES</summary>
    public partial class CSMoveIntoNpcAreaRes
    {
        public CSMoveIntoNpcAreaRes()
        {
            Clear();
        }
        public int retcode { get; set; }


        public void Clear()
        {
            retcode = 0;
        }
    }

    /// <summary> CS_ENTER_MAP_REQ = 2446 进入地图 请求/回复</summary>
    public partial class CSEnterMapReq
    {
        public CSEnterMapReq()
        {
            Clear();
        }
        public uint MapID { get; set; }

        /// <summary> 这个字段 客户端 忽略不填</summary>
        public int LevelType { get; set; }


        public void Clear()
        {
            MapID = 0;
            LevelType = 0;
        }
    }

    /// <summary> CS_ENTER_MAP_RES = 2447 进入地图 请求/回复</summary>
    public partial class CSEnterMapRes
    {
        public CSEnterMapRes()
        {
            Clear();
        }
        /// <summary> 0 表示请求成功，非零表示请求错误</summary>
        public int RetCode { get; set; }

        /// <summary> 地图 id</summary>
        public uint MapID { get; set; }


        public void Clear()
        {
            RetCode = 0;
            MapID = 0;
        }
    }

    /// <summary>玩家轻功请求 CS_QINGKUNG_REQ = 2476</summary>
    public partial class CSQingkungReq
    {
        public CSQingkungReq()
        {
            Clear();
        }
        /// <summary>轻功点id</summary>
        public uint QingkungID { get; set; }


        public void Clear()
        {
            QingkungID = 0;
        }
    }

    /// <summary>玩家轻功回复 CS_QINGKUNG_RES = 2477;</summary>
    public partial class CSQingkungRes
    {
        public CSQingkungRes()
        {
            Clear();
        }
        /// <summary> 0 表示请求成功，非零表示请求错误</summary>
        public int RetCode { get; set; }


        public void Clear()
        {
            RetCode = 0;
        }
    }

    /// <summary>通知玩家轻功 CS_QINKUNG_NOTIFY = 2478</summary>
    public partial class CSQinkungNotify
    {
        public CSQinkungNotify()
        {
            Clear();
        }
        public global::cs.MyUint64 ActorID { get; set; }

        /// <summary>轻功点id</summary>
        public uint QingkungID { get; set; }


        public void Clear()
        {
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            QingkungID = 0;
        }
    }

    public partial class MiniMonsterInfo
    {
        public MiniMonsterInfo()
        {
            Clear();
        }
        public uint MonsterID { get; set; }

        public global::cs.MyUint64 ActorID { get; set; }

        public global::cs.Triple Pos { get; set; }


        public void Clear()
        {
            MonsterID = 0;
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
        }
    }

    /// <summary> CS_MINI_MAP_INFO_REQ = 2705;</summary>
    public partial class CSMiniMapInfoReq
    {
        public CSMiniMapInfoReq()
        {
            Clear();
        }

        public void Clear()
        {
        }
    }

    /// <summary> CS_MINI_MAP_INFO_RES = 2706;</summary>
    public partial class CSMiniMapInfoRes
    {
        public CSMiniMapInfoRes()
        {
            MonsterInfo = new List<global::cs.MiniMonsterInfo>();
            InitAllCacheList();
            Clear();
        }
        /// <summary>a cache list for MonsterInfo</summary>
        public List<global::cs.MiniMonsterInfo> MonsterInfoCacheList = new List<global::cs.MiniMonsterInfo>(50);

        public int RetCode { get; set; }

        public List<global::cs.MiniMonsterInfo> MonsterInfo { get; set; }


        public void Clear()
        {
            RetCode = 0;
            if (MonsterInfo != null)
            {
                for (int i = 0; i < MonsterInfo.Count;  ++i)
                {
                    MonsterInfo[i].Clear();
                    ReturnMonsterInfoElement(MonsterInfo[i]);
                }
                MonsterInfo.Clear();
            }
        }

        /// <summary>init all the cache lists</summary>
        public void InitAllCacheList()
        {
            MonsterInfoCacheList.Clear();
            for (int i = 0; i < 50; ++i)
            {
                MonsterInfoCacheList.Add(new global::cs.MiniMonsterInfo());
            }
        }

        /// <summary>get a free element from MonsterInfoCacheList</summary>
        public global::cs.MiniMonsterInfo GetFreeMonsterInfoElement()
        {
            global::cs.MiniMonsterInfo ret = null;
            if (MonsterInfoCacheList.Count > 0)
            {
                 ret = MonsterInfoCacheList[0];
                MonsterInfoCacheList.RemoveAt(0);
            }
            else
            {
                 ret = new global::cs.MiniMonsterInfo();
            }
            return ret;
        }

        /// <summary>return a free element to MonsterInfoCacheList</summary>
        public void ReturnMonsterInfoElement(global::cs.MiniMonsterInfo element)
        {
            bool alreadyInList = false;
            for (int i = 0; i < MonsterInfoCacheList.Count;  ++i)
            {
                if (MonsterInfoCacheList[i] == element)
                {
                    alreadyInList = true;
                    break;
                }
            }
            if (!alreadyInList)
            {
                element.Clear();
                MonsterInfoCacheList.Add(element);
            }
        }
    }

    /// <summary> CS_CHECK_SELF_LOC_REQ = 2712 校正位置</summary>
    public partial class CSCheckSelfLocReq
    {
        public CSCheckSelfLocReq()
        {
            Clear();
        }
        public uint MapID { get; set; }

        public global::cs.MyUint64 RoomID { get; set; }


        public void Clear()
        {
            MapID = 0;
            if (RoomID != null)
            {
                RoomID.Clear();
            }
        }
    }

    /// <summary>非正常移动坐标同步    CS_SYN_POSITION_REQ = 2765;</summary>
    public partial class CSSynPositionReq
    {
        public CSSynPositionReq()
        {
            Clear();
        }
        public global::cs.MyUint64 ActorID { get; set; }

        public global::cs.Triple Pos { get; set; }

        public int ActorType { get; set; }

        /// <summary>0中间同步（不广播） 1最后同步（广播）</summary>
        public int Type { get; set; }


        public void Clear()
        {
            if (ActorID != null)
            {
                ActorID.Clear();
            }
            if (Pos != null)
            {
                Pos.Clear();
            }
            ActorType = 0;
            Type = 0;
        }
    }

    /// <summary>非正常移动坐标同步    CS_SYN_POSITION_RES = 2766;</summary>
    public partial class CSSynPositionRes
    {
        public CSSynPositionRes()
        {
            Clear();
        }
        public int RetCode { get; set; }


        public void Clear()
        {
            RetCode = 0;
        }
    }



























































































































































































































}

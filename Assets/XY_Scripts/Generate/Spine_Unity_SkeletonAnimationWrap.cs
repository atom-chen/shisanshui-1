﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Spine_Unity_SkeletonAnimationWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Spine.Unity.SkeletonAnimation), typeof(Spine.Unity.SkeletonRenderer));
		L.RegFunction("AddToGameObject", AddToGameObject);
		L.RegFunction("NewSkeletonAnimationGameObject", NewSkeletonAnimationGameObject);
		L.RegFunction("Initialize", Initialize);
		L.RegFunction("ChangeQueue", ChangeQueue);
		L.RegFunction("Update", Update);
		L.RegFunction("Awake", Awake);
		L.RegFunction("PlayCompleteCallBackToLua", PlayCompleteCallBackToLua);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("state", get_state, set_state);
		L.RegVar("loop", get_loop, set_loop);
		L.RegVar("timeScale", get_timeScale, set_timeScale);
		L.RegVar("playComPleteCallBack", get_playComPleteCallBack, set_playComPleteCallBack);
		L.RegVar("AnimationState", get_AnimationState, null);
		L.RegVar("AnimationName", get_AnimationName, set_AnimationName);
		L.RegVar("UpdateLocal", get_UpdateLocal, set_UpdateLocal);
		L.RegVar("UpdateWorld", get_UpdateWorld, set_UpdateWorld);
		L.RegVar("UpdateComplete", get_UpdateComplete, set_UpdateComplete);
		L.RegFunction("PlayCompleteCallBack", Spine_Unity_SkeletonAnimation_PlayCompleteCallBack);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddToGameObject(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.GameObject));
			Spine.Unity.SkeletonDataAsset arg1 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckUnityObject(L, 2, typeof(Spine.Unity.SkeletonDataAsset));
			Spine.Unity.SkeletonAnimation o = Spine.Unity.SkeletonAnimation.AddToGameObject(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NewSkeletonAnimationGameObject(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonDataAsset arg0 = (Spine.Unity.SkeletonDataAsset)ToLua.CheckUnityObject(L, 1, typeof(Spine.Unity.SkeletonDataAsset));
			Spine.Unity.SkeletonAnimation o = Spine.Unity.SkeletonAnimation.NewSkeletonAnimationGameObject(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Initialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.Initialize(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ChangeQueue(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.ChangeQueue(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(Spine.Unity.SkeletonAnimation)))
			{
				Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.ToObject(L, 1);
				obj.Update();
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(Spine.Unity.SkeletonAnimation), typeof(float)))
			{
				Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.ToObject(L, 1);
				float arg0 = (float)LuaDLL.lua_tonumber(L, 2);
				obj.Update(arg0);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Spine.Unity.SkeletonAnimation.Update");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Awake(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			obj.Awake();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayCompleteCallBackToLua(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			Spine.TrackEntry arg0 = (Spine.TrackEntry)ToLua.CheckObject(L, 2, typeof(Spine.TrackEntry));
			obj.PlayCompleteCallBackToLua(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_ToString(IntPtr L)
	{
		object obj = ToLua.ToObject(L, 1);

		if (obj != null)
		{
			LuaDLL.lua_pushstring(L, obj.ToString());
		}
		else
		{
			LuaDLL.lua_pushnil(L);
		}

		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_state(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			Spine.AnimationState ret = obj.state;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index state on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loop(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			bool ret = obj.loop;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index loop on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			float ret = obj.timeScale;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index timeScale on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_playComPleteCallBack(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			Spine.Unity.SkeletonAnimation.PlayCompleteCallBack ret = obj.playComPleteCallBack;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index playComPleteCallBack on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AnimationState(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			Spine.AnimationState ret = obj.AnimationState;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index AnimationState on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AnimationName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			string ret = obj.AnimationName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index AnimationName on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateLocal(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonAnimation.UpdateLocal"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateWorld(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonAnimation.UpdateWorld"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UpdateComplete(IntPtr L)
	{
		ToLua.Push(L, new EventObject("Spine.Unity.SkeletonAnimation.UpdateComplete"));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_state(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			Spine.AnimationState arg0 = (Spine.AnimationState)ToLua.CheckObject(L, 2, typeof(Spine.AnimationState));
			obj.state = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index state on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loop(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.loop = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index loop on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_timeScale(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.timeScale = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index timeScale on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_playComPleteCallBack(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			Spine.Unity.SkeletonAnimation.PlayCompleteCallBack arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (Spine.Unity.SkeletonAnimation.PlayCompleteCallBack)ToLua.CheckObject(L, 2, typeof(Spine.Unity.SkeletonAnimation.PlayCompleteCallBack));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(Spine.Unity.SkeletonAnimation.PlayCompleteCallBack), func) as Spine.Unity.SkeletonAnimation.PlayCompleteCallBack;
			}

			obj.playComPleteCallBack = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index playComPleteCallBack on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_AnimationName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.AnimationName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index AnimationName on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateLocal(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonAnimation.UpdateLocal' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonAnimation'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)DelegateFactory.CreateDelegate(typeof(Spine.Unity.UpdateBonesDelegate), arg0.func);
				obj.UpdateLocal += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonAnimation), "UpdateLocal");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.UpdateBonesDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.UpdateLocal -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateWorld(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonAnimation.UpdateWorld' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonAnimation'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)DelegateFactory.CreateDelegate(typeof(Spine.Unity.UpdateBonesDelegate), arg0.func);
				obj.UpdateWorld += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonAnimation), "UpdateWorld");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.UpdateBonesDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.UpdateWorld -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UpdateComplete(IntPtr L)
	{
		try
		{
			Spine.Unity.SkeletonAnimation obj = (Spine.Unity.SkeletonAnimation)ToLua.CheckObject(L, 1, typeof(Spine.Unity.SkeletonAnimation));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Spine.Unity.SkeletonAnimation.UpdateComplete' can only appear on the left hand side of += or -= when used outside of the type 'Spine.Unity.SkeletonAnimation'");
			}

			if (arg0.op == EventOp.Add)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)DelegateFactory.CreateDelegate(typeof(Spine.Unity.UpdateBonesDelegate), arg0.func);
				obj.UpdateComplete += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				Spine.Unity.UpdateBonesDelegate ev = (Spine.Unity.UpdateBonesDelegate)LuaMisc.GetEventHandler(obj, typeof(Spine.Unity.SkeletonAnimation), "UpdateComplete");
				Delegate[] ds = ev.GetInvocationList();
				LuaState state = LuaState.Get(L);

				for (int i = 0; i < ds.Length; i++)
				{
					ev = (Spine.Unity.UpdateBonesDelegate)ds[i];
					LuaDelegate ld = ev.Target as LuaDelegate;

					if (ld != null && ld.func == arg0.func)
					{
						obj.UpdateComplete -= ev;
						state.DelayDispose(ld.func);
						break;
					}
				}

				arg0.func.Dispose();
			}

			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Spine_Unity_SkeletonAnimation_PlayCompleteCallBack(IntPtr L)
	{
		try
		{
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);
			Delegate arg1 = DelegateFactory.CreateDelegate(typeof(Spine.Unity.SkeletonAnimation.PlayCompleteCallBack), func);
			ToLua.Push(L, arg1);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}


﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaHelperWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("LuaHelper");
		L.RegFunction("GetType", GetType);
		L.RegFunction("GetComponentInChildren", GetComponentInChildren);
		L.RegFunction("GetComponent", GetComponent);
		L.RegFunction("GetComponentsInChildren", GetComponentsInChildren);
		L.RegFunction("GetAllChild", GetAllChild);
		L.RegFunction("Action", Action);
		L.RegFunction("ScrollViewVoidDelegate", ScrollViewVoidDelegate);
		L.RegFunction("VoidDelegate", VoidDelegate);
		L.RegFunction("OnInitializeItemDelegate", OnInitializeItemDelegate);
		L.RegFunction("BoolDelegate", BoolDelegate);
		L.RegFunction("FloatDelegate", FloatDelegate);
		L.RegFunction("eventDelegate", eventDelegate);
		L.RegFunction("eventCenterDelegate", eventCenterDelegate);
		L.RegFunction("ObjectDelegate", ObjectDelegate);
		L.RegFunction("VectorDelegate", VectorDelegate);
		L.RegFunction("OnJsonCallFunc", OnJsonCallFunc);
		L.RegFunction("SetTransformLocalX", SetTransformLocalX);
		L.RegFunction("SetTransformLocalY", SetTransformLocalY);
		L.RegFunction("SetTransformLocalXY", SetTransformLocalXY);
		L.RegFunction("SetTransformX", SetTransformX);
		L.RegFunction("SetTransformXZ", SetTransformXZ);
		L.RegFunction("SetTransformXYZ", SetTransformXYZ);
		L.RegFunction("SetTransformLocalEulers", SetTransformLocalEulers);
		L.RegVar("openGuestMode", get_openGuestMode, set_openGuestMode);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetType(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			System.Type o = LuaHelper.GetType(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetComponentInChildren(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.GameObject));
			string arg1 = ToLua.CheckString(L, 2);
			UnityEngine.Component o = LuaHelper.GetComponentInChildren(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetComponent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.GameObject));
			string arg1 = ToLua.CheckString(L, 2);
			UnityEngine.Component o = LuaHelper.GetComponent(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetComponentsInChildren(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.GameObject));
			string arg1 = ToLua.CheckString(L, 2);
			UnityEngine.Component[] o = LuaHelper.GetComponentsInChildren(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAllChild(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.GameObject));
			UnityEngine.Transform[] o = LuaHelper.GetAllChild(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Action(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			System.Action o = LuaHelper.Action(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ScrollViewVoidDelegate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			UIScrollView.OnDragNotification o = LuaHelper.ScrollViewVoidDelegate(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int VoidDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				UIEventListener.VoidDelegate o = LuaHelper.VoidDelegate(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction), typeof(LuaInterface.LuaTable)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				LuaTable arg1 = ToLua.ToLuaTable(L, 2);
				UIEventListener.VoidDelegate o = LuaHelper.VoidDelegate(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaHelper.VoidDelegate");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnInitializeItemDelegate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			UIWrapContent.OnInitializeItem o = LuaHelper.OnInitializeItemDelegate(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BoolDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				UIEventListener.BoolDelegate o = LuaHelper.BoolDelegate(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction), typeof(LuaInterface.LuaTable)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				LuaTable arg1 = ToLua.ToLuaTable(L, 2);
				UIEventListener.BoolDelegate o = LuaHelper.BoolDelegate(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaHelper.BoolDelegate");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FloatDelegate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			UIEventListener.FloatDelegate o = LuaHelper.FloatDelegate(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int eventDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				EventDelegate.Callback o = LuaHelper.eventDelegate(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction), typeof(LuaInterface.LuaTable)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				LuaTable arg1 = ToLua.ToLuaTable(L, 2);
				EventDelegate.Callback o = LuaHelper.eventDelegate(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaHelper.eventDelegate");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int eventCenterDelegate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			UICenterOnChild.OnCenterCallback o = LuaHelper.eventCenterDelegate(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ObjectDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				UIEventListener.ObjectDelegate o = LuaHelper.ObjectDelegate(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes(L, 1, typeof(LuaInterface.LuaFunction), typeof(LuaInterface.LuaTable)))
			{
				LuaFunction arg0 = ToLua.ToLuaFunction(L, 1);
				LuaTable arg1 = ToLua.ToLuaTable(L, 2);
				UIEventListener.ObjectDelegate o = LuaHelper.ObjectDelegate(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaHelper.ObjectDelegate");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int VectorDelegate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 1);
			UIEventListener.VectorDelegate o = LuaHelper.VectorDelegate(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnJsonCallFunc(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			string arg0 = ToLua.CheckString(L, 1);
			LuaFunction arg1 = ToLua.CheckLuaFunction(L, 2);
			LuaHelper.OnJsonCallFunc(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformLocalX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			LuaHelper.SetTransformLocalX(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformLocalY(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			LuaHelper.SetTransformLocalY(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformLocalXY(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			LuaHelper.SetTransformLocalXY(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformX(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			LuaHelper.SetTransformX(arg0, arg1);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformXZ(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			LuaHelper.SetTransformXZ(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformXYZ(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			LuaHelper.SetTransformXYZ(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransformLocalEulers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckUnityObject(L, 1, typeof(UnityEngine.Transform));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			LuaHelper.SetTransformLocalEulers(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_openGuestMode(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, LuaHelper.openGuestMode);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_openGuestMode(IntPtr L)
	{
		try
		{
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			LuaHelper.openGuestMode = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}


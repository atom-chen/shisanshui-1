﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class SingleWebWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(SingleWeb), typeof(Singleton<SingleWeb>));
		L.RegFunction("InitWebPage", InitWebPage);
		L.RegFunction("GetDicObj", GetDicObj);
		L.RegFunction("DestroyDicObj", DestroyDicObj);
		L.RegFunction("Init", Init);
		L.RegFunction("Show", Show);
		L.RegFunction("Hide", Hide);
		L.RegFunction("setsize", setsize);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", Lua_ToString);
		L.RegVar("_webView", get__webView, set__webView);
		L.RegVar("url", get_url, set_url);
		L.RegVar("Complete", get_Complete, set_Complete);
		L.RegVar("Receive", get_Receive, set_Receive);
		L.RegVar("dic", get_dic, set_dic);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitWebPage(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			string arg0 = ToLua.CheckString(L, 2);
			obj.InitWebPage(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDicObj(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			string arg0 = ToLua.CheckString(L, 2);
			WebPage o = obj.GetDicObj(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DestroyDicObj(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			string arg0 = ToLua.CheckString(L, 2);
			obj.DestroyDicObj(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			string arg0 = ToLua.CheckString(L, 2);
			obj.Init(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Show(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			obj.Show();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Hide(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			obj.Hide();
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setsize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			SingleWeb obj = (SingleWeb)ToLua.CheckObject(L, 1, typeof(SingleWeb));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 5);
			obj.setsize(arg0, arg1, arg2, arg3);
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
	static int get__webView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			UniWebView ret = obj._webView;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index _webView on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_url(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			string ret = obj.url;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index url on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Complete(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			OnloadComplete ret = obj.Complete;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Complete on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Receive(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			OnReceiveMessage ret = obj.Receive;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Receive on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_dic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			System.Collections.Generic.Dictionary<string,WebPage> ret = obj.dic;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index dic on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set__webView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			UniWebView arg0 = (UniWebView)ToLua.CheckUnityObject(L, 2, typeof(UniWebView));
			obj._webView = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index _webView on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_url(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.url = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index url on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Complete(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			OnloadComplete arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (OnloadComplete)ToLua.CheckObject(L, 2, typeof(OnloadComplete));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(OnloadComplete), func) as OnloadComplete;
			}

			obj.Complete = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Complete on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Receive(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			OnReceiveMessage arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (OnReceiveMessage)ToLua.CheckObject(L, 2, typeof(OnReceiveMessage));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(OnReceiveMessage), func) as OnReceiveMessage;
			}

			obj.Receive = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index Receive on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_dic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			SingleWeb obj = (SingleWeb)o;
			System.Collections.Generic.Dictionary<string,WebPage> arg0 = (System.Collections.Generic.Dictionary<string,WebPage>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.Dictionary<string,WebPage>));
			obj.dic = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index dic on a nil value" : e.Message);
		}
	}
}


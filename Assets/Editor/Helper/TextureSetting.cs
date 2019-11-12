using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Diagnostics;

public class TextureSetting 
{
	private static List<string> extensions = new List<string>{".png", ".tga", ".jpg", ".bmp", ".tif", ".gif"};
	private static List<string> texturePaths;

	// 取消mipmap和可读状态
	[MenuItem("Tools/TakeOut MipMap And Read")]
	public static void takeOutMipMapAndRead()
	{
		texturePaths = new List<string>();

		Object[] objs = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
		if (null != objs && null != objs[0])
		{
			string selectPath = AssetDatabase.GetAssetPath(objs[0]);
			if (!string.IsNullOrEmpty(selectPath))
			{
				getTexturePaths(selectPath);
				if (texturePaths.Count > 0) 
				{
					string textPath = null;
					foreach (string eachPath in texturePaths) 
					{
						textureSetting(eachPath.Substring(eachPath.LastIndexOf("Assets")));
					}

					AssetDatabase.Refresh();
				}
			}
		}
	}

	private static void getTexturePaths(string path)
	{
		if (Directory.Exists(path))
		{
			DirectoryInfo dirInfo = new DirectoryInfo(path);
			FileSystemInfo[] fileInfos = dirInfo.GetFileSystemInfos();
			foreach(FileSystemInfo info in fileInfos)
			{
				string childPath = info.FullName;
				if ((info.Attributes & FileAttributes.Directory) == FileAttributes.Directory)
				{
					getTexturePaths(childPath);
				} 
				else 
				{
					addTexture(childPath);
				}
			}
		} else if (File.Exists(path)) 
		{
			addTexture(path);
		}
	}

	private static void addTexture(string path)
	{
		if (isTextureFile(path))
		{
			if (!texturePaths.Contains(path)) {
				texturePaths.Add(path);
			}
		}
	}

	private static bool isTextureFile(string texturePath)
	{
		bool isTexture = false;
		string extensionName = texturePath.Substring(texturePath.LastIndexOf('.'));
		if (extensions.Contains(extensionName))
		{
			isTexture = true;
		}
		return isTexture;
	}

	private static void textureSetting(string texturePath) 
	{
		TextureImporter ti = AssetImporter.GetAtPath(texturePath) as TextureImporter;
		if (null == ti)
		{
			UnityEngine.Debug.LogError("TextureSetting TextureImporter 获取失败！texturePath=" + texturePath);
			return;
		}

		// if (!ti.isReadable && !ti.mipmapEnabled)
		// 	return;

		// ti.isReadable = false;
		ti.mipmapEnabled = false;
		ti.filterMode = FilterMode.Bilinear;
		ti.textureFormat = TextureImporterFormat.AutomaticTruecolor;
		AssetDatabase.ImportAsset(texturePath);
		AssetDatabase.SaveAssets();
	}
}
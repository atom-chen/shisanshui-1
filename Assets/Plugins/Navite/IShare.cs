
using System;

//namespace Native
//{
    interface IShare
    {
        void Login(Action<string> callback);

        void ShareText(string text, ShareType type, Action<int> callback);

        void ShareImage(string img_path, string icon_path, ShareType type, Action<int> callback);

        void ShareWepPage(string url, string title, string des, string icon_path, ShareType type, Action<int> callback);

        void ShareGameRoom(string url, string title, string des, string roomId, string roomToken, string icon_path, ShareType type, Action<int> callback);

    }
//}

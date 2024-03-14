export class Constants {
    // 路由path
    static readonly PAGE_INDEX = 'pages/Index';
    static readonly PAGE_LOGIN = 'pages/Account/LoginPage';
    static readonly PAGE_JUST_TEST = "pages/JustTestPage";
    static readonly PAGE_NORMAL_TEST = "pages/NormalTest/NormalTestPage";
    static readonly PAGE_LOGIN_BY_EMAIL = "pages/Account/LoginByEmailPage";

    // 获取Preference所用到的Key
    static readonly PREFERENCES_STORE = "PREFERENCES_STORE";
    // 获取到上述Preference以后往里面存数据时候用到的Key
    static readonly LOGIN_USER_PREFERENCE = "LOGIN_USER_PREFERENCE";
}
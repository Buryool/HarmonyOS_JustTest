import { AGConnectUser, SignInResult, } from '@hw-agconnect/auth-ohos';
import '@hw-agconnect/auth-ohos';
import { PhoneAuthProvider, VerifyCodeSettingBuilder, EmailAuthProvider } from '@hw-agconnect/auth-ohos';
import agconnect from '@hw-agconnect/api-ohos'
import { Log } from '../common/utils/Log';
import { UserLoginUtil } from '../common/utils/UserLoginUtil';

const TAG = "[AGCAuth]";

export class AGCAuth {

  // 获取当前登录的用户信息
  public static async getCurrentUser(): Promise<AGConnectUser> {
    return await agconnect.auth().getCurrentUser();
  }

  // 获取手机验证码
  public static async requestPhoneVerifyCode(phone: string, ctrCode: string = '+86') {
    try {
      let verifyCodeSettings = new VerifyCodeSettingBuilder()
        .setAction(1001) // 1001表示注册登录，1002表示修改密码
        .setLang('zh_CN')
        .setSendInterval(300)
        .build();

      let ret = await agconnect.auth().requestPhoneVerifyCode(
        ctrCode,
        phone,
        verifyCodeSettings);

      return '验证码获取成功';
    } catch (err) {
      Log.log('手机验证码获取失败:' + JSON.stringify(err))
      throw err
    }
  }

  // 获取邮箱验证码
  public static async requestEmailVerifyCode(email: string) {
    try {
      let verifyCodeSettings = new VerifyCodeSettingBuilder()
        .setAction(1001) // 1001表示注册登录，1002表示修改密码
        .setLang('zh_CN')
        .setSendInterval(300)
        .build();

      let ret = await agconnect.auth().requestEmailVerifyCode(
        email,
        verifyCodeSettings);

      return '验证码获取成功';
    } catch (err) {
      Log.log('邮箱验证码获取失败:' + JSON.stringify(err))
      throw err
    }
  }

  // // 获取用户头像
  // static async getImg(uid) {
  //   return "https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmqa-bbnx2/defaultAvatar%2Fic_public_avatar1.png?token=ec5c702d-9ed9-4caf-ac7f-4ca205c70e68";
  //   /*
  //     const headImgs = await DatabaseHelper.userHeadImg_Query_By_uid(uid);
  //     if(headImgs && headImgs.length>0){
  //       return headImgs[0].imgurl;
  //     }else{
  //       return 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmqa-bbnx2/user_dark.png?token=74d1ae76-2075-4ab2-b702-74ee968eb6ed';
  //     }
  //     */
  // }

  // 将AGConnectUser类型的user转换成AgUser（本类中自己定义）类型的user
  public static async Change(user: AGConnectUser) {
    try {
      // let imgurl = await AGCAuth.getImg(user.getUid());
      let imgurl = ""

      let userExtra = await user.getUserExtra();

      let loginRes = new User(
        user.getUid(),
        imgurl,
        user.getPhone(),
        user.getEmail(),
        user.getDisplayName(),
        userExtra.getCreateTime(),
        userExtra.getLastSignInTime());

      return loginRes;
    } catch (err) {
      Log.log(JSON.stringify(err))

      throw err
    }
  }

  // 手机验证码/邮箱验证码登录
  // 登录成功后将登录成功的用户信息写入到AppStorage并用首选项持久化到硬盘
  public static async login(isPhoneLogin: boolean, username: string, verifyCode: string, countryCode: string = '+86'): Promise<User> {
    try {
      let credential = null;
      if (isPhoneLogin) {
        credential = PhoneAuthProvider.credentialWithVerifyCode(countryCode, username, verifyCode);
      } else {
        credential = EmailAuthProvider.credentialWithVerifyCode(username, verifyCode);
      }

      let ret: SignInResult = await agconnect.auth().signIn(credential)
      let agcUser:AGConnectUser = ret.getUser()
      let user = await AGCAuth.Change(agcUser)
      // 将登录成功的用户信息用首选项持久化到硬盘
      await UserLoginUtil.setLoginUserToDisk(user, getContext(this))
      return user
    } catch (err) {
      Log.log(JSON.stringify(err))
      throw err
    }
  }

  // AGC登出
  public static async logout(): Promise<boolean> {
    try {
      await agconnect.auth().signOut()
      // 从首选项中删除登录用户数据
      UserLoginUtil.deleteLoginUserFromPreference(getContext(this))
      // AppStorage中也删除登录用户数据
      UserLoginUtil.deleteLoginUserFromMemory()
      return true
    } catch (err) {
      Log.log(JSON.stringify(err))
      throw err
    }
  }

  // 在AGC中删除用户
  public async deleteUser(): Promise<boolean> {
    try {
      await agconnect.auth().deleteUser()
      return true
    } catch (err) {
      Log.log(JSON.stringify(err))

      throw err
    }

  }
}

export class User {
  uid: String;
  photoUrl: String;
  phone: String;
  email: String;
  displayName: String;
  registerDate: String;
  lastLogin: String;

  constructor(uid: String = "", photoUrl: String = "", phone: String = "", email: String = "", displayName: String = "", registerDate: String = "", lastLogin: String = "") {
    this.uid = uid;
    this.photoUrl = photoUrl;
    this.phone = phone;
    this.email = email
    this.displayName = displayName;
    this.registerDate = registerDate;
    this.lastLogin = lastLogin;
  }

  getUid(): String {
    return this.uid;
  }

  getPhone(): String {
    return this.phone;
  }

  getEmail(): String {
    return this.email;
  }

  getDisplayName(): String {
    return this.displayName;
  }

  getPhotoUrl(): String {
    return this.photoUrl;
  }

  getRegisterDate(): String {
    return this.registerDate;
  }

  getLastLogin(): String {
    return this.lastLogin;
  }
}


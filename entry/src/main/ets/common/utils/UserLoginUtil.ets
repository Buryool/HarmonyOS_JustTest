import dataPreferences from '@ohos.data.preferences' // 导入首选项
import { User } from '../../services/Auth';
import { Constants } from '../Constants';
import { Log } from './Log';



export class UserLoginUtil {
  // 保存用户数据到内存
  static setLoginUserToMemory(userData: User){
    AppStorage.SetOrCreate('user', userData);
    Log.log(`成功将user数据写入到AppStorage`)
  }

  // 从内存中删除用户数据
  static deleteLoginUserFromMemory(){
    AppStorage.Delete('user');
    Log.log("成功将user数据从AppStorage中删除")
  }

  // 保存数据到首选项(磁盘持久化)
  static async setLoginUserToDisk(data, context) {
    const store = await dataPreferences.getPreferences(context, Constants.PREFERENCES_STORE);
    store.put(Constants.LOGIN_USER_PREFERENCE, JSON.stringify(data));
    await store.flush(); // 将数据保存到磁盘
    Log.log(`试图将user数据持久化到首选项（一般没问题）`)
  }

  // 从磁盘获取用户数据
  static async getLoginUser(context) {
    const store = await dataPreferences.getPreferences(context, Constants.PREFERENCES_STORE);
    let res = await store.get(Constants.LOGIN_USER_PREFERENCE, "{}");
    Log.log(`试图从首选项中获取user信息`)

    return JSON.parse(res.toString()) as User;
  }

  // 从首选项中删除用户数据
  static async deleteLoginUserFromPreference(context) {
    const store = await dataPreferences.getPreferences(context, Constants.PREFERENCES_STORE);
    await store.delete(Constants.LOGIN_USER_PREFERENCE);
    await store.flush();
    Log.log("试图将user数据从首选项中删除（一般没问题）")
  }

  static async setRanking<T>(data: T, context) {
    // 保存数据到首选项(磁盘持久化)
    const store = await dataPreferences.getPreferences(context, Constants.PREFERENCES_STORE);
    store.put("ranking", JSON.stringify(data));
    await store.flush(); // 将数据保存到磁盘
  }
}
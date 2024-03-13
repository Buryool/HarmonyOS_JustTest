import preferences from '@ohos.data.preferences';

class PreferencesUtil {
  preferencesMap: Map<string, preferences.Preferences> = new Map()

  // 加载Preference
  loadPreference(context, preferenceName: string){
    preferences.getPreferences(context, preferenceName)
      .then(preferences => {
        this.preferencesMap.set(preferenceName, preferences)
        console.log(`加载Preference[${preferenceName}]成功`)
      })
      .catch(reason => {
        console.log(`加载Preference[${preferenceName}]失败`, JSON.stringify(reason))
      })
  }

  // 增
  putPreferenceValue(preferenceName: string, key: string, value: preferences.ValueType) {
    if (!this.preferencesMap.has(preferenceName)){
      console.log(`Preference[${preferenceName}]尚未初始化`)
      return
    }
    let preference = this.preferencesMap.get(preferenceName)
    // 写入数据
    preference.put(key, value)
      // 成功返回为Promise<void>
      .then(() => {
        console.log(`成功插入数据[${preferenceName}.${key} = ${value}]`)
      })
      .catch(err => {
        console.error("Failed to put value of 'startup'. code =" + err.code +", message =" + err.message);
      })

    // 刷盘
    preference.flush()
      // 成功返回为Promise<void>
      .then(() => {
        console.log("成功刷盘")
      })
      .catch(err => {
        console.error("Failed to put value of 'startup'. code =" + err.code +", message =" + err.message);
      })
  }

  // 查
  getPreferenceValue(preferenceName: string, key: string, defaultValue: preferences.ValueType) {
    if (!this.preferencesMap.has(preferenceName)){
      console.log(`Preference[${preferenceName}]尚未初始化`)
      return
    }
    let preference = this.preferencesMap.get(preferenceName)
    // 查数据
    preference.get(key, defaultValue)
      .then((value) => {
        console.log(`成功查找数据[${preferenceName}.${key} = ${value}]`)
        return value
      })
      .catch(err => {
        console.error("Failed to put value of 'startup'. code =" + err.code +", message =" + err.message);
      })
  }
}

const preferencesUtil = new PreferencesUtil()

export default preferencesUtil as PreferencesUtil
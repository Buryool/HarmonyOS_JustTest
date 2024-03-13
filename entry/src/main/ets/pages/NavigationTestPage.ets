import MyNav from '../common/components/MyNavigation'

@Entry
@Component
struct NavigationExample {
  build() {
    Column() {
      MyNav()
    }.width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}
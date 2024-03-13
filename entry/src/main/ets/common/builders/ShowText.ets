@Builder
export function ShowText($$: {
  info: string,
  hint?: string
}) {
  Row() {
    Text($$.hint)
    Text($$.info)
  }
  .justifyContent(FlexAlign.Center)
}
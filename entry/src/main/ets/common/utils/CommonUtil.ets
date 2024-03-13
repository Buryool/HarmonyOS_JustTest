export function formatDate(date: string): string {
  console.log('formatDate->', date);
  if (date) {
    let d = new Date();
    if (date.toString().indexOf('+') > -1) {
      d = new Date(date);
    } else {
      d = new Date(parseInt(date));
    }

    let year = d.getFullYear();

    let month = (d.getMonth() + 1).toString();
    month = month.length < 2 ? "0" + month : month;

    let day = d.getDate()
                .toString()
                .length < 2 ? "0" + d.getDate() : d.getDate();
    ;

    let hours = d.getHours()
                  .toString()
                  .length < 2 ? "0" + d.getHours() : d.getHours();

    let minutes = d.getMinutes()
                    .toString()
                    .length < 2 ? "0" + d.getMinutes() : d.getMinutes();

    let seconds = d.getSeconds()
                    .toString()
                    .length < 2 ? "0" + d.getSeconds() : d.getSeconds();

    let hm = hours + ':' + minutes + ':' + seconds;

    return `${year}-${month}-${day}` + ' ' + hm;
  } else {
    return date;
  }
}

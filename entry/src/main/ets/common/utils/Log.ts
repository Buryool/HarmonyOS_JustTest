export class Log {
    private static tag = "[MyTag]"
    static log (info){
        console.log(`${Log.tag} ${info}`)
    }
}
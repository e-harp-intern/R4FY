/* eslint-disable */
// 共通処理

export default {
    /* 日時成形処理用 */
    datetimeData: (datetime) => {
        datetime = new Date(datetime);
        return {
            year: datetime.getUTCFullYear(),
            month: datetime.getUTCMonth() + 1,
            date: datetime.getUTCDate().toString().padStart(2, "0"),
            hours: datetime.getUTCHours().toString().padStart(2, "0"),
            minutes: datetime.getUTCMinutes().toString().padStart(2, "0"),
        };
    }
}

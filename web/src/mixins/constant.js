/* eslint-disable */
// 定数

/* レスポンス周りの定義 */
const STATE = {
    SUCCESS: "success",
    ERROR: "error",
};

/* ツアー状態 */
const TOUR_STATE = {
    TOUR_STATE_CODE_INCOMPLETE: 1,
    TOUR_STATE_CODE_ASSIGNED: 2,
    TOUR_STATE_CODE_COMPLETE: 4,
    TOUR_STATE_CODE_COMPLETE_RECORDED: 8,
    TOUR_STATE_CODE_CANCEL: 256,
}

export default {
    STATE: STATE,
    TOUR_STATE: TOUR_STATE
};

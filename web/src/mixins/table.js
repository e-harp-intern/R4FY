/* eslint-disable */

export default {
    data() {
        return {
            sort_key: "",
            sort_asc: true,
        };
    },
    methods: {
        /* テーブルのソートを開始 */
        sortBy(key, array) {
            // keyにnullを指定した場合、現在と同じ条件で並び替えをする
            if(key == null){
                key =  this.sort_key;
                this.sort_asc = !this.sort_asc;
            }

            // 前回の選択と同じタイトルを選択された場合、sort_ascを切り替え、昇順降順処理の切り替えを行う
            this.sort_asc = this.sort_key !== key ? true : !this.sort_asc;
            this.sort_key = key;
            this.sortArray(key, this.sort_asc, array);
        },

        /* テーブルのソートを行う */
        sortArray: (key, asc, array) => {
            // タイトルが選択されているか判断
            if (key === "") return array;

            // 選択されたタイトルで並び替える
            const order = asc ? 1 : -1;
            array.sort((a, b) => {
                if (a[key] < b[key]) return -1 * order;
                if (a[key] > b[key]) return 1 * order;
                return 0;
            });

            return array;
        },

        /* テーブルの昇順降順表示を切り替える */
        addSortClass(key) {
            return {
                asc: this.sort_key === key && this.sort_asc,
                desc: this.sort_key === key && !this.sort_asc,
            };
        },
    },
};

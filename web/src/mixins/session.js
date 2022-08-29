/* eslint-disable */

export default {
    data() {
        return {};
    },
    methods: {
        // ログイン済みか調べる
        isLogin: async function () {
            const result = await this.getData("/api/v1/connection", this.$router.push);
            return result.status === "success";
        }
    },
};

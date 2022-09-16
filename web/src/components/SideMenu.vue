<template>
  <div id="menu-frame">
    <nav id="menu">
      <ul>
        <li
          v-for="value in menuList"
          v-bind:key="value.path"
          :class="{ 'router-active': $route.path.startsWith(value.path) }"
          :style="value.styleMenu"
        >
          <a @click="menuClick(value.path)" :style="value.styleText">{{
            value.title
          }}</a>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {
  data() {
    return {
      menuList: [
        {
          path: "/tours",
          title: this.$i18n.t("pages.tours.title"),
        },
        {
          path: "/accounts",
          title: this.$i18n.t("pages.accounts.title"),
        },
        {
          path: "/myaccount",
          title: this.$i18n.t("pages.myaccount.title"),
        },
        {
          path: "/logout",
          title: this.$i18n.t("pages.logout.title"),
          styleMenu: { marginTop: "3em" },
          styleText: {},
        },
      ],
    };
  },
  methods: {
    menuClick(path) {
      if (path !== this.$route.path) {
        this.$emit("SendLoadComplete", false);
      }
      this.$router.push(path);
    },
  },
};
</script>

<style lang="scss" scoped>
#menu-frame {
  width: 215px;
  background-color: var(--color-theme);
  box-shadow: 5px 0 20px 5px rgba(0, 0, 0, 0.15);
}

#menu {
  position: sticky;
  top: 0;
  padding: 0;
}

#menu ul {
  margin: 0;
  padding: 0;
  list-style-type: none;
  margin-top: 2em;
}

#menu li {
  padding: 0;
  margin: 0;
  display: table;
  width: 100%;
  box-sizing: border-box;
}

#menu li a {
  box-sizing: border-box;
  padding: 0.5em 1em;
  text-decoration: none;
  color: var(--color-light-gray);
  width: 100%;
  margin: 0;
  text-align: left;
  font-size: 1.05rem;
  font-weight: bold;
  height: 3em;
  display: table-cell;
  vertical-align: middle;
}

#menu li a:hover {
  color: var(--color-white);
  background-color: var(--color-dark-theme);
  opacity: 0.75;
  cursor: pointer;
}

.router-active {
  background-color: var(--color-dark-theme);
}
</style>
